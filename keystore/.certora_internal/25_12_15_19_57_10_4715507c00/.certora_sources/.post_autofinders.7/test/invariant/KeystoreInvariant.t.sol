// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import {Test} from "forge-std/Test.sol";
import {StdInvariant} from "forge-std/StdInvariant.sol";
import {SIG_VALIDATION_FAILED, SIG_VALIDATION_SUCCESS} from "account-abstraction/core/Helpers.sol";

import {Keystore} from "../../src/core/Keystore.sol";
import {IKeystore} from "../../src/interface/IKeystore.sol";
import {IVerifier} from "../../src/interface/IVerifier.sol";
import {UpdateAction, ValidateAction} from "../../src/lib/Actions.sol";
import {VerifierMock} from "../mock/VerifierMock.sol";

/**
 * @title KeystoreInvariant
 * @notice Foundry invariant tests for Certora formal verification
 * @dev Run with: forge test --match-contract KeystoreInvariant
 *      Certora: certoraRun --foundry --wait_for_results
 *
 * Critical invariants that if broken = funds/authority loss:
 * 1. Nonce monotonicity (replay protection)
 * 2. State isolation (cross-user attack prevention)
 * 3. Root hash integrity (auth bypass prevention)
 */
contract KeystoreInvariant is StdInvariant, Test {
    Keystore public keystore;
    KeystoreHandler public handler;

    // Ghost variables to track state changes across calls
    mapping(bytes32 => mapping(address => mapping(uint192 => uint256))) public nonceBefore;
    mapping(bytes32 => mapping(address => bytes32)) public rootHashBefore;

    function setUp() public {
        keystore = new Keystore();
        handler = new KeystoreHandler(keystore);

        // Only target the handler contract
        targetContract(address(handler));

        // Exclude view functions (they can't break invariants)
        bytes4[] memory selectors = new bytes4[](3);
        selectors[0] = keystore.getRootHash.selector;
        selectors[1] = keystore.getNonce.selector;
        selectors[2] = keystore.getRegisteredNode.selector;
        targetSelector(FuzzSelector({addr: address(keystore), selectors: selectors}));
    }

    /*//////////////////////////////////////////////////////////////
                        INVARIANT 1: NONCE MONOTONICITY
    //////////////////////////////////////////////////////////////*/

    /**
     * @notice Nonces can NEVER decrease - this is critical for replay protection
     * @dev If broken: allows replaying old signed operations
     * Bounty estimate: $100K+ (critical, cross-chain replay attack)
     */
    function invariant_nonceCanOnlyIncrease() public view {
        bytes32 refHash = handler.lastRefHash();
        address account = handler.lastAccount();
        uint192 key = handler.lastNonceKey();

        if (refHash != bytes32(0) && account != address(0)) {
            uint256 currentNonce = keystore.getNonce(refHash, account, key);
            uint256 previousNonce = handler.initialNonce(refHash, account, key);

            assertGe(currentNonce, previousNonce, "CRITICAL: Nonce decreased - replay attack possible");
        }
    }

    /**
     * @notice Nonce increment is exactly 0 or 1 per successful update
     * @dev If broken: nonce could skip, causing DoS or allowing parallel replays
     */
    function invariant_nonceIncrementsCorrectly() public view {
        bytes32 refHash = handler.lastRefHash();
        address account = handler.lastAccount();
        uint192 key = handler.lastNonceKey();

        if (handler.updateWasSuccessful()) {
            uint256 currentNonce = keystore.getNonce(refHash, account, key);
            uint256 beforeNonce = handler.nonceBeforeLastUpdate();

            // Nonce should increase by exactly 1 on success
            assertEq(currentNonce, beforeNonce + 1, "CRITICAL: Nonce did not increment by 1");
        }
    }

    /*//////////////////////////////////////////////////////////////
                      INVARIANT 2: STATE ISOLATION
    //////////////////////////////////////////////////////////////*/

    /**
     * @notice One user's actions cannot modify another user's state
     * @dev If broken: cross-user state corruption, potential fund theft
     * Bounty estimate: $200K+ (critical, authorization bypass)
     */
    function invariant_stateIsolation() public view {
        bytes32 refHash = handler.lastRefHash();
        address attacker = handler.lastAccount();
        address victim = handler.victimAccount();

        if (refHash != bytes32(0) && attacker != victim && victim != address(0)) {
            // Victim's root hash should not change due to attacker's actions
            bytes32 victimRoot = keystore.getRootHash(refHash, victim);
            // For victim who never interacted, rootHash == refHash
            assertEq(victimRoot, refHash, "CRITICAL: Victim state modified by attacker");
        }
    }

    /**
     * @notice Different refHashes are completely isolated
     * @dev One account's updates to refHash1 cannot affect refHash2
     */
    function invariant_refHashIsolation() public view {
        bytes32 refHash1 = handler.lastRefHash();
        bytes32 refHash2 = handler.otherRefHash();
        address account = handler.lastAccount();

        if (refHash1 != bytes32(0) && refHash2 != bytes32(0) && refHash1 != refHash2 && account != address(0)) {
            bytes32 root2 = keystore.getRootHash(refHash2, account);
            // For never-modified refHash2, rootHash should equal refHash2 itself
            assertEq(root2, refHash2, "CRITICAL: Operations on refHash1 affected refHash2");
        }
    }

    /*//////////////////////////////////////////////////////////////
                    INVARIANT 3: ROOT HASH INTEGRITY
    //////////////////////////////////////////////////////////////*/

    /**
     * @notice Root hash is NEVER zero for valid refHash
     * @dev Initial rootHash == refHash; if somehow zero, validation breaks
     * Bounty estimate: $100K+ (validation bypass)
     */
    function invariant_rootHashNeverZero() public view {
        bytes32 refHash = handler.lastRefHash();
        address account = handler.lastAccount();

        if (refHash != bytes32(0) && account != address(0)) {
            bytes32 rootHash = keystore.getRootHash(refHash, account);
            assertNotEq(rootHash, bytes32(0), "CRITICAL: Root hash is zero - validation would fail");
        }
    }

    /**
     * @notice Root hash only changes via handleUpdates with valid signature
     * @dev registerNode and validate must NOT change rootHash
     */
    function invariant_rootHashOnlyChangesViaHandleUpdates() public view {
        if (handler.lastOperationType() == KeystoreHandler.OpType.RegisterNode ||
            handler.lastOperationType() == KeystoreHandler.OpType.Validate) {
            bytes32 refHash = handler.lastRefHash();
            address account = handler.lastAccount();

            bytes32 rootBefore = handler.rootHashBeforeOp();
            bytes32 rootAfter = keystore.getRootHash(refHash, account);

            assertEq(rootBefore, rootAfter, "CRITICAL: Root hash changed outside handleUpdates");
        }
    }

    /*//////////////////////////////////////////////////////////////
                      INVARIANT 4: VERIFIER INTEGRITY
    //////////////////////////////////////////////////////////////*/

    /**
     * @notice Registered nodes must have valid verifier (non-zero)
     * @dev Zero verifier = no validation = anyone can sign
     * Bounty estimate: $200K+ (complete auth bypass)
     */
    function invariant_noZeroVerifierNodes() public view {
        bytes32 refHash = handler.lastRefHash();
        address account = handler.lastAccount();
        bytes32 nodeHash = handler.lastNodeHash();

        if (nodeHash != bytes32(0)) {
            bytes memory node = keystore.getRegisteredNode(refHash, account, nodeHash);
            if (node.length >= 20) {
                address verifier = address(bytes20(node));
                assertNotEq(verifier, address(0), "CRITICAL: Registered node with zero verifier");
            }
        }
    }

    /*//////////////////////////////////////////////////////////////
                    INVARIANT 5: 2D NONCE KEY INDEPENDENCE
    //////////////////////////////////////////////////////////////*/

    /**
     * @notice Different nonce keys are completely independent
     * @dev Operations on key1 must not affect key2's sequence
     */
    function invariant_nonceKeyIndependence() public view {
        bytes32 refHash = handler.lastRefHash();
        address account = handler.lastAccount();
        uint192 key1 = handler.lastNonceKey();
        uint192 key2 = handler.otherNonceKey();

        if (key1 != key2 && refHash != bytes32(0)) {
            uint256 nonce2 = keystore.getNonce(refHash, account, key2);
            // getNonce returns seq | (key << 64), so for unmodified key2, seq should be 0
            uint64 seq2 = uint64(nonce2);  // Extract just the sequence part

            // Key2's sequence should be 0 since we never operated on it
            assertEq(seq2, 0, "CRITICAL: Nonce keys are not independent");
        }
    }
}

/**
 * @title KeystoreHandler
 * @notice Handler contract that wraps Keystore for invariant testing
 * @dev Tracks ghost state for invariant assertions
 */
contract KeystoreHandler is Test {
    enum OpType { None, HandleUpdates, RegisterNode, Validate }

    Keystore public keystore;
    VerifierMock public verifier;

    // Ghost state tracking
    bytes32 public lastRefHash;
    address public lastAccount;
    uint192 public lastNonceKey;
    bytes32 public lastNodeHash;
    bytes32 public otherRefHash;
    uint192 public otherNonceKey;
    address public victimAccount;
    OpType public lastOperationType;
    bool public updateWasSuccessful;
    uint256 public nonceBeforeLastUpdate;
    bytes32 public rootHashBeforeOp;

    // Initial state snapshots
    mapping(bytes32 => mapping(address => mapping(uint192 => uint256))) public initialNonce;
    mapping(bytes32 => mapping(address => bytes32)) public initialRootHash;

    constructor(Keystore _keystore) {
        keystore = _keystore;
        verifier = new VerifierMock(SIG_VALIDATION_SUCCESS);
        victimAccount = address(0xBEEF);
        otherRefHash = keccak256("otherRefHash");
        otherNonceKey = 999;
    }

    function handleUpdates(
        bytes32 refHash,
        bytes32 nextHash,
        uint192 nonceKey,
        bytes calldata data
    ) external {
        // Snapshot initial state if first interaction
        _snapshotInitialState(refHash, msg.sender, nonceKey);
        _snapshotInitialState(refHash, victimAccount, nonceKey);
        _snapshotInitialState(otherRefHash, msg.sender, otherNonceKey);

        lastRefHash = refHash;
        lastAccount = msg.sender;
        lastNonceKey = nonceKey;
        lastOperationType = OpType.HandleUpdates;
        rootHashBeforeOp = keystore.getRootHash(refHash, msg.sender);
        nonceBeforeLastUpdate = keystore.getNonce(refHash, msg.sender, nonceKey);

        // Create minimal valid UpdateAction
        bytes memory node = abi.encodePacked(address(verifier), data);
        UpdateAction[] memory actions = new UpdateAction[](1);
        actions[0] = UpdateAction({
            refHash: refHash,
            nextHash: nextHash,
            nonce: nonceBeforeLastUpdate,
            useChainId: false,
            account: msg.sender,
            proof: "",
            node: node,
            data: data,
            nextProof: "",
            nextNode: "",
            nextData: ""
        });

        try keystore.handleUpdates(actions) {
            updateWasSuccessful = true;
        } catch {
            updateWasSuccessful = false;
        }
    }

    function registerNode(
        bytes32 refHash,
        bytes32[] calldata proof,
        bytes calldata nodeConfig
    ) external {
        _snapshotInitialState(refHash, msg.sender, 0);

        lastRefHash = refHash;
        lastAccount = msg.sender;
        lastOperationType = OpType.RegisterNode;
        rootHashBeforeOp = keystore.getRootHash(refHash, msg.sender);

        bytes memory node = abi.encodePacked(address(verifier), nodeConfig);
        lastNodeHash = keccak256(node);

        try keystore.registerNode(refHash, proof, node) {
            // success
        } catch {
            // fail
        }
    }

    function validate(
        bytes32 refHash,
        bytes32 message,
        bytes calldata proof,
        bytes calldata nodeConfig,
        bytes calldata data
    ) external view returns (uint256) {
        bytes memory node = abi.encodePacked(address(verifier), nodeConfig);

        ValidateAction memory action = ValidateAction({
            refHash: refHash,
            message: message,
            proof: proof,
            node: node,
            data: data
        });

        return keystore.validate(action);
    }

    function _snapshotInitialState(bytes32 refHash, address account, uint192 key) internal {
        if (initialRootHash[refHash][account] == bytes32(0)) {
            initialRootHash[refHash][account] = keystore.getRootHash(refHash, account);
        }
        if (initialNonce[refHash][account][key] == 0) {
            initialNonce[refHash][account][key] = keystore.getNonce(refHash, account, key);
        }
    }
}
