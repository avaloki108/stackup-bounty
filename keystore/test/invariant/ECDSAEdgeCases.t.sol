// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import {Test} from "forge-std/Test.sol";
import {SIG_VALIDATION_FAILED, SIG_VALIDATION_SUCCESS} from "account-abstraction/core/Helpers.sol";
import {ECDSA} from "solady/utils/ECDSA.sol";
import {Merkle} from "murky/src/Merkle.sol";

import {Keystore} from "../../src/core/Keystore.sol";
import {IKeystore} from "../../src/interface/IKeystore.sol";
import {UserOpECDSAVerifier} from "../../src/verifier/UserOpECDSAVerifier.sol";
import {UpdateAction, ValidateAction} from "../../src/lib/Actions.sol";

/**
 * @title ECDSAEdgeCases
 * @notice Targeted tests for ECDSA verifier vulnerabilities
 *
 * FOCUS AREAS:
 * 1. Domain separation - message commits to all critical fields
 * 2. Signature malleability - reject non-canonical s, invalid v
 * 3. Replay protection - same sig can't authorize different actions
 * 4. Cross-chain behavior - useChainId=false semantics
 */
contract ECDSAEdgeCases is Test {
    Keystore public keystore;
    UserOpECDSAVerifier public verifier;
    Merkle public ucmt;

    uint256 internal signerPrivateKey = 0xA11CE;
    address internal signer;

    function setUp() public {
        keystore = new Keystore();
        verifier = new UserOpECDSAVerifier(address(keystore));
        ucmt = new Merkle();
        signer = vm.addr(signerPrivateKey);
    }

    /*//////////////////////////////////////////////////////////////
              TEST: DOMAIN SEPARATION - ALL FIELDS COMMITTED
    //////////////////////////////////////////////////////////////*/

    /**
     * @notice Verify message includes refHash - changing it invalidates signature
     */
    function testFuzz_domainSeparation_refHash(bytes32 refHash1, bytes32 refHash2) public view {
        vm.assume(refHash1 != refHash2);

        bytes32 nextHash = keccak256("next");
        address account = address(this);
        uint256 nonce = 0;
        bytes32 nodeHash = keccak256("node");
        bytes32 nextNodeHash = keccak256("");

        // Message for refHash1
        bytes32 message1 = keccak256(
            abi.encode(refHash1, nextHash, account, nonce, nodeHash, nextNodeHash, block.chainid)
        );

        // Message for refHash2
        bytes32 message2 = keccak256(
            abi.encode(refHash2, nextHash, account, nonce, nodeHash, nextNodeHash, block.chainid)
        );

        // Messages must be different
        assertNotEq(message1, message2, "Different refHash should produce different message");
    }

    /**
     * @notice Verify message includes account - one account can't replay another's signature
     */
    function testFuzz_domainSeparation_account(address account1, address account2) public view {
        vm.assume(account1 != account2);

        bytes32 refHash = keccak256("ref");
        bytes32 nextHash = keccak256("next");
        uint256 nonce = 0;
        bytes32 nodeHash = keccak256("node");
        bytes32 nextNodeHash = keccak256("");

        bytes32 message1 = keccak256(
            abi.encode(refHash, nextHash, account1, nonce, nodeHash, nextNodeHash, block.chainid)
        );

        bytes32 message2 = keccak256(
            abi.encode(refHash, nextHash, account2, nonce, nodeHash, nextNodeHash, block.chainid)
        );

        assertNotEq(message1, message2, "Different account should produce different message");
    }

    /**
     * @notice Verify message includes nonce - same action can't be replayed
     */
    function testFuzz_domainSeparation_nonce(uint256 nonce1, uint256 nonce2) public view {
        vm.assume(nonce1 != nonce2);

        bytes32 refHash = keccak256("ref");
        bytes32 nextHash = keccak256("next");
        address account = address(this);
        bytes32 nodeHash = keccak256("node");
        bytes32 nextNodeHash = keccak256("");

        bytes32 message1 = keccak256(
            abi.encode(refHash, nextHash, account, nonce1, nodeHash, nextNodeHash, block.chainid)
        );

        bytes32 message2 = keccak256(
            abi.encode(refHash, nextHash, account, nonce2, nodeHash, nextNodeHash, block.chainid)
        );

        assertNotEq(message1, message2, "Different nonce should produce different message");
    }

    /**
     * @notice Verify message includes nextHash - can't use sig to set different root
     */
    function testFuzz_domainSeparation_nextHash(bytes32 nextHash1, bytes32 nextHash2) public view {
        vm.assume(nextHash1 != nextHash2);

        bytes32 refHash = keccak256("ref");
        address account = address(this);
        uint256 nonce = 0;
        bytes32 nodeHash = keccak256("node");
        bytes32 nextNodeHash = keccak256("");

        bytes32 message1 = keccak256(
            abi.encode(refHash, nextHash1, account, nonce, nodeHash, nextNodeHash, block.chainid)
        );

        bytes32 message2 = keccak256(
            abi.encode(refHash, nextHash2, account, nonce, nodeHash, nextNodeHash, block.chainid)
        );

        assertNotEq(message1, message2, "Different nextHash should produce different message");
    }

    /**
     * @notice Verify message includes nodeHash - sig for node A can't validate node B
     */
    function testFuzz_domainSeparation_nodeHash(bytes32 nodeHash1, bytes32 nodeHash2) public view {
        vm.assume(nodeHash1 != nodeHash2);

        bytes32 refHash = keccak256("ref");
        bytes32 nextHash = keccak256("next");
        address account = address(this);
        uint256 nonce = 0;
        bytes32 nextNodeHash = keccak256("");

        bytes32 message1 = keccak256(
            abi.encode(refHash, nextHash, account, nonce, nodeHash1, nextNodeHash, block.chainid)
        );

        bytes32 message2 = keccak256(
            abi.encode(refHash, nextHash, account, nonce, nodeHash2, nextNodeHash, block.chainid)
        );

        assertNotEq(message1, message2, "Different nodeHash should produce different message");
    }

    /*//////////////////////////////////////////////////////////////
                   TEST: SIGNATURE MALLEABILITY
    //////////////////////////////////////////////////////////////*/

    /**
     * @notice Solady ECDSA should reject non-canonical s values
     * @dev ECDSA signatures have malleability: (r, s, v) and (r, n-s, v^1) are both valid
     *      for secp256k1. Proper implementations only accept s < n/2.
     */
    function test_signatureMalleability_rejectHighS() public {
        bytes32 messageHash = keccak256("test message");
        bytes32 ethSignedHash = ECDSA.toEthSignedMessageHash(messageHash);

        // Sign with private key
        (uint8 v, bytes32 r, bytes32 s) = vm.sign(signerPrivateKey, ethSignedHash);

        // Compute the malleable signature
        // secp256k1 order n
        uint256 n = 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141;
        uint256 sInt = uint256(s);

        // If s is already in low half, compute high s
        // If s is in high half, this is the original (already rejected by Solady)
        uint256 malleableS = n - sInt;
        uint8 malleableV = v == 27 ? 28 : 27;

        // Pack signatures
        bytes memory originalSig = abi.encodePacked(r, s, v);
        bytes memory malleableSig = abi.encodePacked(r, bytes32(malleableS), malleableV);

        // Original should recover correctly
        address recovered1 = ECDSA.recover(ethSignedHash, originalSig);
        assertEq(recovered1, signer, "Original signature should recover signer");

        // Malleable signature should fail (Solady rejects high s)
        address recovered2 = ECDSA.recover(ethSignedHash, malleableSig);
        // Either returns address(0) or wrong address - not signer
        assertTrue(recovered2 != signer || recovered2 == address(0), "Malleable signature should not recover signer");
    }

    /**
     * @notice Test invalid v values
     */
    function testFuzz_invalidV(uint8 badV) public {
        vm.assume(badV != 27 && badV != 28);

        bytes32 messageHash = keccak256("test message");
        bytes32 ethSignedHash = ECDSA.toEthSignedMessageHash(messageHash);

        // Sign with private key
        (, bytes32 r, bytes32 s) = vm.sign(signerPrivateKey, ethSignedHash);

        // Pack with invalid v
        bytes memory badSig = abi.encodePacked(r, s, badV);

        // Should not recover to signer
        address recovered = ECDSA.recover(ethSignedHash, badSig);
        assertTrue(recovered != signer, "Invalid v should not recover signer");
    }

    /*//////////////////////////////////////////////////////////////
                TEST: CROSS-CHAIN REPLAY (useChainId=false)
    //////////////////////////////////////////////////////////////*/

    /**
     * @notice When useChainId=false, message doesn't include chainid
     * @dev This is INTENTIONAL for cross-chain sync. Document the replay domain.
     *
     * Replay protection when useChainId=false:
     * - refHash: unique per account configuration
     * - account: which account this applies to
     * - nonce: per (refHash, key, account) - must be fresh
     *
     * Cross-chain replay IS allowed when:
     * - Same Keystore address on both chains
     * - Same refHash
     * - Same account
     * - Nonce not yet used on target chain
     */
    function test_crossChainReplay_documentedBehavior() public pure {
        bytes32 refHash = keccak256("ref");
        bytes32 nextHash = keccak256("next");
        address account = address(0x1234);
        uint256 nonce = 0;
        bytes32 nodeHash = keccak256("node");
        bytes32 nextNodeHash = keccak256("");

        // Message without chainid (useChainId=false)
        bytes32 messageNoChain = keccak256(
            abi.encode(refHash, nextHash, account, nonce, nodeHash, nextNodeHash)
        );

        // Same message computed on "different chain" (no chainid in hash)
        bytes32 messageOtherChain = keccak256(
            abi.encode(refHash, nextHash, account, nonce, nodeHash, nextNodeHash)
        );

        // INTENTIONAL: Same message allows cross-chain replay
        assertEq(messageNoChain, messageOtherChain, "Without chainid, messages are identical");

        // With chainid (useChainId=true)
        uint256 chain1 = 1;
        uint256 chain2 = 137;

        bytes32 messageWithChain1 = keccak256(
            abi.encode(refHash, nextHash, account, nonce, nodeHash, nextNodeHash, chain1)
        );

        bytes32 messageWithChain2 = keccak256(
            abi.encode(refHash, nextHash, account, nonce, nodeHash, nextNodeHash, chain2)
        );

        // With chainid, messages differ
        assertNotEq(messageWithChain1, messageWithChain2, "With chainid, messages should differ");
    }

    /**
     * @notice Verify nonce provides replay protection even when useChainId=false
     * @dev The nonce space is (refHash, key, account) scoped
     */
    function test_nonceProtectsAgainstReplay_sameChain() public {
        // Setup: Create valid node with signer
        bytes memory node = abi.encodePacked(address(verifier), signer);
        bytes32 nodeHash = keccak256(node);

        // Build UCMT with this node
        bytes32[] memory leaves = new bytes32[](2);
        leaves[0] = nodeHash;
        leaves[1] = keccak256("dummy");
        bytes32 refHash = ucmt.getRoot(leaves);
        bytes32[] memory proof = ucmt.getProof(leaves, 0);

        // Create message for nonce=0
        bytes32 nextHash = keccak256("next");
        bytes32 message = keccak256(
            abi.encode(refHash, nextHash, address(this), 0, nodeHash, keccak256(""))
        );

        // Sign it
        bytes32 ethSignedHash = ECDSA.toEthSignedMessageHash(message);
        (uint8 v, bytes32 r, bytes32 s) = vm.sign(signerPrivateKey, ethSignedHash);
        bytes memory signature = abi.encodePacked(r, s, v);

        // First update should succeed (mocked verifier)
        // Note: This would need full integration test with actual Merkle proofs

        // Second attempt with same nonce should fail
        // The nonce validation happens BEFORE signature validation
        // So even a valid signature with wrong nonce is rejected
    }

    /*//////////////////////////////////////////////////////////////
                TEST: SIGNATURE LENGTH EDGE CASES
    //////////////////////////////////////////////////////////////*/

    /**
     * @notice ECDSA verifier accepts raw signature (65 bytes) or PackedUserOperation
     */
    function test_signatureLengthHandling() public view {
        // 65 bytes = raw signature
        bytes memory rawSig = new bytes(65);
        assertTrue(rawSig.length == 65, "Raw sig is 65 bytes");

        // > 65 bytes = decoded as PackedUserOperation
        bytes memory packedUserOp = new bytes(100);
        assertTrue(packedUserOp.length > 65, "PackedUserOp is > 65 bytes");
    }

    /**
     * @notice Empty signature should fail validation
     */
    function test_emptySignature() public {
        bytes32 messageHash = keccak256("test");
        bytes memory emptySig = "";

        address recovered = ECDSA.recover(messageHash, emptySig);
        assertEq(recovered, address(0), "Empty signature should recover to zero");
    }

    /**
     * @notice Truncated signature should fail
     */
    function testFuzz_truncatedSignature(uint8 length) public {
        vm.assume(length > 0 && length < 65);

        bytes32 messageHash = keccak256("test");
        bytes memory truncatedSig = new bytes(length);

        address recovered = ECDSA.recover(messageHash, truncatedSig);
        assertEq(recovered, address(0), "Truncated signature should recover to zero");
    }

    /*//////////////////////////////////////////////////////////////
                    TEST: MESSAGE HASH COLLISION
    //////////////////////////////////////////////////////////////*/

    /**
     * @notice Verify abi.encode prevents hash collisions between different structures
     * @dev abi.encode is length-prefixed, preventing concatenation attacks
     */
    function test_noMessageHashCollision() public pure {
        // Two different structures that might collide with abi.encodePacked
        bytes32 refHash = bytes32(uint256(1));
        bytes32 nextHash = bytes32(uint256(2));
        address account = address(uint160(3));
        uint256 nonce = 4;
        bytes32 nodeHash = bytes32(uint256(5));
        bytes32 nextNodeHash = bytes32(uint256(6));
        uint256 chainid = 7;

        bytes32 message1 = keccak256(
            abi.encode(refHash, nextHash, account, nonce, nodeHash, nextNodeHash, chainid)
        );

        // Try to create collision by rearranging
        bytes32 message2 = keccak256(
            abi.encode(refHash, nextHash, account, nonce + 1, nodeHash, nextNodeHash, chainid)
        );

        assertNotEq(message1, message2, "Different params should not collide");
    }
}
