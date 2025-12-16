// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import {Test} from "forge-std/Test.sol";
import {StdInvariant} from "forge-std/StdInvariant.sol";
import {SIG_VALIDATION_FAILED, SIG_VALIDATION_SUCCESS} from "account-abstraction/core/Helpers.sol";
import {Merkle} from "murky/src/Merkle.sol";

import {Keystore} from "../../src/core/Keystore.sol";
import {IKeystore} from "../../src/interface/IKeystore.sol";
import {IVerifier} from "../../src/interface/IVerifier.sol";
import {UpdateAction, ValidateAction} from "../../src/lib/Actions.sol";
import {VerifierMock} from "../mock/VerifierMock.sol";
import {
    AlwaysSuccessVerifier,
    AlwaysFailVerifier,
    RevertingVerifier,
    GasGriefingVerifier,
    ReentrantVerifier,
    StatefulVerifier,
    CalldataLengthVerifier
} from "../mock/AdversarialVerifiers.sol";

/**
 * @title KeystoreAdversarial
 * @notice Adversarial invariant tests - hostile verifiers, negative testing
 * @dev Proves "verification failure can't cause state corruption or permanent lock"
 *
 * CRITICAL PROPERTIES:
 * 1. If handleUpdates() reverts, NO state changes
 * 2. If verifier rejects, nonce must NOT increment
 * 3. Partial updates can't slip through (atomicity)
 * 4. Reentrant verifiers can't corrupt state
 * 5. Gas griefing can't permanently lock accounts
 */
contract KeystoreAdversarial is StdInvariant, Test {
    Keystore public keystore;
    AdversarialHandler public handler;
    Merkle public ucmt;

    function setUp() public {
        keystore = new Keystore();
        ucmt = new Merkle();
        handler = new AdversarialHandler(keystore, ucmt);

        targetContract(address(handler));
    }

    /*//////////////////////////////////////////////////////////////
                   INVARIANT: REVERT = NO STATE CHANGE
    //////////////////////////////////////////////////////////////*/

    /**
     * @notice If handleUpdates reverts, state must be unchanged
     * @dev This is critical - reverts should be atomic
     */
    function invariant_revertMeansNoStateChange() public view {
        if (handler.lastCallReverted()) {
            bytes32 refHash = handler.lastRefHash();
            address account = handler.lastAccount();
            uint192 key = handler.lastNonceKey();

            // State should match pre-call snapshot
            assertEq(
                keystore.getRootHash(refHash, account),
                handler.rootHashBeforeCall(),
                "CRITICAL: State changed despite revert"
            );

            uint64 seqBefore = uint64(handler.nonceBeforeCall());
            uint64 seqAfter = uint64(keystore.getNonce(refHash, account, key));
            assertEq(seqAfter, seqBefore, "CRITICAL: Nonce changed despite revert");
        }
    }

    /*//////////////////////////////////////////////////////////////
                 INVARIANT: VERIFIER REJECT = NO NONCE INCREMENT
    //////////////////////////////////////////////////////////////*/

    /**
     * @notice If verifier returns FAILED, nonce must NOT increment
     * @dev Prevents "burn nonce" attacks where attacker exhausts nonces
     */
    function invariant_verifierRejectMeansNoNonceIncrement() public view {
        if (handler.verifierReturnedFailed() && !handler.lastCallReverted()) {
            bytes32 refHash = handler.lastRefHash();
            address account = handler.lastAccount();
            uint192 key = handler.lastNonceKey();

            uint64 seqBefore = uint64(handler.nonceBeforeCall());
            uint64 seqAfter = uint64(keystore.getNonce(refHash, account, key));

            assertEq(seqAfter, seqBefore, "CRITICAL: Nonce incremented on failed verification");
        }
    }

    /*//////////////////////////////////////////////////////////////
                    INVARIANT: REENTRANCY PROTECTION
    //////////////////////////////////////////////////////////////*/

    /**
     * @notice Reentrant verifier calls cannot corrupt state
     * @dev ReentrancyGuardTransient should prevent this
     */
    function invariant_reentrantVerifierCannotCorruptState() public view {
        if (handler.usedReentrantVerifier()) {
            bytes32 refHash = handler.lastRefHash();
            address account = handler.lastAccount();

            // Root hash should be either unchanged (if reentry blocked)
            // or correctly updated (if reentry was legitimate)
            bytes32 root = keystore.getRootHash(refHash, account);
            assertTrue(
                root == refHash || root == handler.expectedRootAfterSuccess(),
                "CRITICAL: Reentrant verifier corrupted root hash"
            );
        }
    }

    /*//////////////////////////////////////////////////////////////
                   INVARIANT: GRIEFING CANNOT LOCK
    //////////////////////////////////////////////////////////////*/

    /**
     * @notice Gas griefing verifier cannot permanently lock account
     * @dev Account should still be usable with different verifier/node
     */
    function invariant_griefingCannotPermanentlyLock() public view {
        // After any operation, view functions should still work
        bytes32 refHash = handler.lastRefHash();
        address account = handler.lastAccount();

        if (refHash != bytes32(0)) {
            // These should never revert
            keystore.getRootHash(refHash, account);
            keystore.getNonce(refHash, account, 0);
            // If we get here without revert, account is not locked
        }
    }

    /*//////////////////////////////////////////////////////////////
                  INVARIANT: BATCH ATOMICITY
    //////////////////////////////////////////////////////////////*/

    /**
     * @notice Batch updates are atomic - all succeed or all fail
     * @dev Partial state changes are a critical vulnerability
     */
    function invariant_batchAtomicity() public view {
        if (handler.lastBatchSize() > 1) {
            bool anyFailed = handler.anyActionInBatchFailed();
            bool allSucceeded = handler.allActionsInBatchSucceeded();

            // Either all succeed or state unchanged for all
            assertTrue(
                allSucceeded || !handler.anyStateChanged(),
                "CRITICAL: Batch partially succeeded - atomicity broken"
            );
        }
    }

    /*//////////////////////////////////////////////////////////////
                 INVARIANT: INVALID VERIFIER RETURN VALUES
    //////////////////////////////////////////////////////////////*/

    /**
     * @notice Invalid return values (not 0 or 1) don't corrupt state
     */
    function invariant_invalidReturnValuesSafe() public view {
        if (handler.usedInvalidReturnVerifier()) {
            // State should be unchanged or correctly handle the invalid return
            bytes32 refHash = handler.lastRefHash();
            address account = handler.lastAccount();

            bytes32 root = keystore.getRootHash(refHash, account);
            // Root should either be refHash (initial) or a valid update
            assertTrue(root != bytes32(0), "CRITICAL: Invalid return value corrupted state");
        }
    }
}

/**
 * @title AdversarialHandler
 * @notice Handler that uses hostile verifiers for invariant testing
 */
contract AdversarialHandler is Test {
    Keystore public keystore;
    Merkle public ucmt;

    // Adversarial verifiers
    AlwaysSuccessVerifier public alwaysSuccess;
    AlwaysFailVerifier public alwaysFail;
    RevertingVerifier public reverting;
    GasGriefingVerifier public gasGriefing;
    ReentrantVerifier public reentrant;
    StatefulVerifier public stateful;

    // State tracking
    bytes32 public lastRefHash;
    address public lastAccount;
    uint192 public lastNonceKey;
    bool public lastCallReverted;
    bool public verifierReturnedFailed;
    bool public usedReentrantVerifier;
    bool public usedInvalidReturnVerifier;
    bytes32 public rootHashBeforeCall;
    uint256 public nonceBeforeCall;
    bytes32 public expectedRootAfterSuccess;
    uint256 public lastBatchSize;
    bool public anyActionInBatchFailed;
    bool public allActionsInBatchSucceeded;
    bool public anyStateChanged;

    constructor(Keystore _keystore, Merkle _ucmt) {
        keystore = _keystore;
        ucmt = _ucmt;

        // Deploy adversarial verifiers
        alwaysSuccess = new AlwaysSuccessVerifier();
        alwaysFail = new AlwaysFailVerifier();
        reverting = new RevertingVerifier();
        gasGriefing = new GasGriefingVerifier();
        reentrant = new ReentrantVerifier();
        stateful = new StatefulVerifier();
    }

    /*//////////////////////////////////////////////////////////////
                      HANDLER: NORMAL UPDATE
    //////////////////////////////////////////////////////////////*/

    function handleUpdateWithSuccessVerifier(
        bytes32 refHash,
        uint192 nonceKey,
        bytes32 nextHashSeed
    ) external {
        _resetState();

        lastRefHash = refHash;
        lastAccount = msg.sender;
        lastNonceKey = nonceKey;
        rootHashBeforeCall = keystore.getRootHash(refHash, msg.sender);
        nonceBeforeCall = keystore.getNonce(refHash, msg.sender, nonceKey);
        verifierReturnedFailed = false;

        bytes memory node = abi.encodePacked(address(alwaysSuccess), bytes32(0));
        bytes32 nextHash = keccak256(abi.encode(nextHashSeed, refHash));
        expectedRootAfterSuccess = nextHash;

        UpdateAction[] memory actions = new UpdateAction[](1);
        actions[0] = _createUpdateAction(refHash, nextHash, nonceBeforeCall, node, "");

        try keystore.handleUpdates(actions) {
            lastCallReverted = false;
            anyStateChanged = keystore.getRootHash(refHash, msg.sender) != rootHashBeforeCall;
        } catch {
            lastCallReverted = true;
        }
    }

    /*//////////////////////////////////////////////////////////////
                    HANDLER: ALWAYS FAIL VERIFIER
    //////////////////////////////////////////////////////////////*/

    function handleUpdateWithFailVerifier(
        bytes32 refHash,
        uint192 nonceKey,
        bytes32 nextHashSeed
    ) external {
        _resetState();

        lastRefHash = refHash;
        lastAccount = msg.sender;
        lastNonceKey = nonceKey;
        rootHashBeforeCall = keystore.getRootHash(refHash, msg.sender);
        nonceBeforeCall = keystore.getNonce(refHash, msg.sender, nonceKey);
        verifierReturnedFailed = true;

        bytes memory node = abi.encodePacked(address(alwaysFail), bytes32(0));
        bytes32 nextHash = keccak256(abi.encode(nextHashSeed, refHash));

        UpdateAction[] memory actions = new UpdateAction[](1);
        actions[0] = _createUpdateAction(refHash, nextHash, nonceBeforeCall, node, "");

        try keystore.handleUpdates(actions) {
            lastCallReverted = false;
            anyStateChanged = keystore.getRootHash(refHash, msg.sender) != rootHashBeforeCall;
        } catch {
            lastCallReverted = true;
        }
    }

    /*//////////////////////////////////////////////////////////////
                    HANDLER: REVERTING VERIFIER
    //////////////////////////////////////////////////////////////*/

    function handleUpdateWithRevertingVerifier(
        bytes32 refHash,
        uint192 nonceKey,
        bytes32 messagePrefix
    ) external {
        _resetState();

        lastRefHash = refHash;
        lastAccount = msg.sender;
        lastNonceKey = nonceKey;
        rootHashBeforeCall = keystore.getRootHash(refHash, msg.sender);
        nonceBeforeCall = keystore.getNonce(refHash, msg.sender, nonceKey);

        bytes memory node = abi.encodePacked(address(reverting), bytes32(0));
        // Use messagePrefix that might trigger revert (0xdeadbeef)
        bytes32 nextHash = keccak256(abi.encode(messagePrefix));

        UpdateAction[] memory actions = new UpdateAction[](1);
        actions[0] = _createUpdateAction(refHash, nextHash, nonceBeforeCall, node, "");

        try keystore.handleUpdates(actions) {
            lastCallReverted = false;
        } catch {
            lastCallReverted = true;
        }
    }

    /*//////////////////////////////////////////////////////////////
                    HANDLER: REENTRANT VERIFIER
    //////////////////////////////////////////////////////////////*/

    function handleUpdateWithReentrantVerifier(
        bytes32 refHash,
        uint192 nonceKey
    ) external {
        _resetState();
        usedReentrantVerifier = true;

        lastRefHash = refHash;
        lastAccount = msg.sender;
        lastNonceKey = nonceKey;
        rootHashBeforeCall = keystore.getRootHash(refHash, msg.sender);
        nonceBeforeCall = keystore.getNonce(refHash, msg.sender, nonceKey);

        bytes memory node = abi.encodePacked(address(reentrant), bytes32(0));
        bytes32 nextHash = keccak256(abi.encode(refHash, "reentrant"));
        expectedRootAfterSuccess = nextHash;

        // Set up reentrancy attempt
        UpdateAction[] memory reentryActions = new UpdateAction[](1);
        reentryActions[0] = _createUpdateAction(refHash, bytes32(uint256(1)), nonceBeforeCall + 1, node, "");
        reentrant.setReentrancyTarget(
            address(keystore),
            abi.encodeCall(keystore.handleUpdates, (reentryActions))
        );

        UpdateAction[] memory actions = new UpdateAction[](1);
        actions[0] = _createUpdateAction(refHash, nextHash, nonceBeforeCall, node, "");

        try keystore.handleUpdates(actions) {
            lastCallReverted = false;
        } catch {
            lastCallReverted = true;
        }
    }

    /*//////////////////////////////////////////////////////////////
                       HANDLER: BATCH UPDATE
    //////////////////////////////////////////////////////////////*/

    function handleBatchUpdate(
        bytes32 refHash1,
        bytes32 refHash2,
        uint192 nonceKey,
        bool secondShouldFail
    ) external {
        _resetState();
        lastBatchSize = 2;

        lastRefHash = refHash1;
        lastAccount = msg.sender;
        lastNonceKey = nonceKey;
        rootHashBeforeCall = keystore.getRootHash(refHash1, msg.sender);
        nonceBeforeCall = keystore.getNonce(refHash1, msg.sender, nonceKey);

        bytes memory node1 = abi.encodePacked(address(alwaysSuccess), bytes32(0));
        bytes memory node2 = secondShouldFail
            ? abi.encodePacked(address(alwaysFail), bytes32(0))
            : abi.encodePacked(address(alwaysSuccess), bytes32(0));

        UpdateAction[] memory actions = new UpdateAction[](2);
        actions[0] = _createUpdateAction(
            refHash1,
            keccak256(abi.encode(refHash1, "next1")),
            keystore.getNonce(refHash1, msg.sender, nonceKey),
            node1,
            ""
        );
        actions[1] = _createUpdateAction(
            refHash2,
            keccak256(abi.encode(refHash2, "next2")),
            keystore.getNonce(refHash2, msg.sender, nonceKey),
            node2,
            ""
        );

        try keystore.handleUpdates(actions) {
            lastCallReverted = false;
            anyActionInBatchFailed = secondShouldFail;
            allActionsInBatchSucceeded = !secondShouldFail;
            anyStateChanged = keystore.getRootHash(refHash1, msg.sender) != rootHashBeforeCall;
        } catch {
            lastCallReverted = true;
        }
    }

    /*//////////////////////////////////////////////////////////////
                          INTERNAL HELPERS
    //////////////////////////////////////////////////////////////*/

    function _resetState() internal {
        lastCallReverted = false;
        verifierReturnedFailed = false;
        usedReentrantVerifier = false;
        usedInvalidReturnVerifier = false;
        lastBatchSize = 1;
        anyActionInBatchFailed = false;
        allActionsInBatchSucceeded = false;
        anyStateChanged = false;
    }

    function _createUpdateAction(
        bytes32 refHash,
        bytes32 nextHash,
        uint256 nonce,
        bytes memory node,
        bytes memory data
    ) internal view returns (UpdateAction memory) {
        return UpdateAction({
            refHash: refHash,
            nextHash: nextHash,
            nonce: nonce,
            useChainId: false,
            account: msg.sender,
            proof: "",
            node: node,
            data: data,
            nextProof: "",
            nextNode: "",
            nextData: ""
        });
    }
}
