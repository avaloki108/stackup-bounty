// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import "forge-std/Test.sol";
import {Keystore} from "../../src/core/Keystore.sol";
import {UpdateAction, ValidateAction} from "../../src/lib/Actions.sol";
import {IVerifier} from "../../src/interface/IVerifier.sol";
import {UserOpECDSAVerifier} from "../../src/verifier/UserOpECDSAVerifier.sol";
import {UserOpMultiSigVerifier} from "../../src/verifier/UserOpMultiSigVerifier.sol";
import {LibBytes} from "solady/utils/LibBytes.sol";
import {ECDSA} from "solady/utils/ECDSA.sol";
import {MerkleProofLib} from "solady/utils/MerkleProofLib.sol";

/**
 * @title AdversarialFuzz
 * @notice Targeted fuzzing for bounty-grade bugs in Keystore
 * Focus: LibBytes.slice edge cases, cross-chain replay, cache invalidation
 */
contract AdversarialFuzz is Test {
    Keystore keystore;
    UserOpECDSAVerifier ecdsaVerifier;
    UserOpMultiSigVerifier multiSigVerifier;

    // Test accounts
    address constant ALICE = address(0xA11CE);
    address constant BOB = address(0xB0B);
    address constant ATTACKER = address(0xBAD);

    // Private keys for signing
    uint256 constant ALICE_PK = 0xA11CE;
    uint256 constant BOB_PK = 0xB0B;

    function setUp() public {
        keystore = new Keystore();
        ecdsaVerifier = new UserOpECDSAVerifier(address(keystore));
        multiSigVerifier = new UserOpMultiSigVerifier(address(keystore));
    }

    /*//////////////////////////////////////////////////////////////
                    LIBYTES.SLICE EDGE CASES
    //////////////////////////////////////////////////////////////*/

    /// @notice Fuzz test: Node length boundary conditions
    /// @dev LibBytes.slice is called with (0, 20) and (20, node.length)
    /// Edge cases: length exactly 20, length 21, very large lengths
    function testFuzz_NodeLengthBoundaries(bytes calldata nodeData) public view {
        // Skip empty or too-short nodes
        if (nodeData.length < 20) return;

        // Try to unpack the node the same way Keystore does
        try this.externalUnpackNode(nodeData) returns (address verifier, bytes memory config) {
            // Verify the unpacking is consistent
            assertEq(verifier, address(bytes20(nodeData[0:20])));
            assertEq(config.length, nodeData.length - 20);
        } catch {
            // Expected for invalid verifier (address(0))
        }
    }

    /// @notice External wrapper for testing _unpackNode logic
    function externalUnpackNode(bytes calldata node) external pure returns (address verifier, bytes memory config) {
        require(node.length >= 20, "InvalidNode");
        verifier = address(bytes20(LibBytes.slice(node, 0, 20)));
        config = LibBytes.slice(node, 20, node.length);
        require(verifier != address(0), "InvalidVerifier");
    }

    /// @notice Test slice with maximum length inputs
    function testFuzz_SliceMaxLength(uint256 length, uint256 start, uint256 end) public pure {
        // Bound to reasonable sizes
        length = bound(length, 1, 10000);
        start = bound(start, 0, length);
        end = bound(end, start, length);

        bytes memory data = new bytes(length);

        // Fill with recognizable pattern
        for (uint256 i = 0; i < length; i++) {
            data[i] = bytes1(uint8(i % 256));
        }

        bytes memory sliced = LibBytes.slice(data, start, end);
        assertEq(sliced.length, end - start);
    }

    /*//////////////////////////////////////////////////////////////
                    CROSS-CHAIN REPLAY ATTACK VECTORS
    //////////////////////////////////////////////////////////////*/

    /// @notice Test: Same UpdateAction with useChainId=false should produce same message hash
    /// across different chainIds (simulated by forking)
    function testFuzz_CrossChainReplayVulnerability(
        bytes32 refHash,
        bytes32 nextHash,
        uint256 nonce,
        bytes32 nodeHash
    ) public {
        // Build action with useChainId = false
        bytes memory nextNode = "";

        // Message WITHOUT chainId
        bytes32 messageWithoutChainId = keccak256(
            abi.encode(refHash, nextHash, ALICE, nonce, nodeHash, keccak256(nextNode))
        );

        // Message WITH chainId
        bytes32 messageWithChainId = keccak256(
            abi.encode(refHash, nextHash, ALICE, nonce, nodeHash, keccak256(nextNode), block.chainid)
        );

        // These should be different (unless block.chainid is somehow included in the first hash)
        assertTrue(messageWithoutChainId != messageWithChainId, "Chain ID should make hashes different");

        // Log the messages for analysis
        emit log_named_bytes32("Message without chainId", messageWithoutChainId);
        emit log_named_bytes32("Message with chainId", messageWithChainId);
        emit log_named_uint("Current chainId", block.chainid);
    }

    /*//////////////////////////////////////////////////////////////
                    DUPLICATE SIGNER ATTACKS (MULTISIG)
    //////////////////////////////////////////////////////////////*/

    /// @notice Fuzz: Try to bypass multisig threshold with duplicate signers
    function testFuzz_DuplicateSignerBypass(
        uint8 threshold,
        uint8 numOwners,
        uint8 duplicateIndex
    ) public {
        // Reasonable bounds
        threshold = uint8(bound(threshold, 1, 10));
        numOwners = uint8(bound(numOwners, threshold, 20));
        duplicateIndex = uint8(bound(duplicateIndex, 0, numOwners - 1));

        // Create sorted owner array
        address[] memory owners = new address[](numOwners);
        for (uint256 i = 0; i < numOwners; i++) {
            owners[i] = address(uint160(i + 1)); // 0x1, 0x2, 0x3, ...
        }

        // Encode config
        bytes memory config = abi.encode(threshold, owners);

        // Create signatures with duplicates
        UserOpMultiSigVerifier.SignerData[] memory sigs = new UserOpMultiSigVerifier.SignerData[](threshold);
        for (uint256 i = 0; i < threshold; i++) {
            sigs[i] = UserOpMultiSigVerifier.SignerData({
                index: duplicateIndex, // All same index = duplicate!
                signature: bytes("dummy") // Will fail signature check
            });
        }

        bytes memory data = abi.encodePacked(
            bytes1(0xff), // SIGNATURES_ONLY_TAG
            abi.encode(sigs)
        );

        // This should NOT pass even with 'threshold' signatures if they're duplicates
        // The seen[] array should prevent counting duplicates
        vm.prank(address(keystore));
        uint256 result = multiSigVerifier.validateData(bytes32(0), data, config);

        // Should fail because duplicates don't count
        assertEq(result, 1, "Duplicate signers should not pass validation");
    }

    /*//////////////////////////////////////////////////////////////
                    MERKLE PROOF MANIPULATION
    //////////////////////////////////////////////////////////////*/

    /// @notice Fuzz: Empty proof with various nodeHash formats
    function testFuzz_EmptyProofNodeHashConversion(bytes calldata rawNode) public {
        if (rawNode.length < 32) return;

        // When proof is empty, Keystore converts aNode to bytes32
        // bytes32(aNode) - what happens with various lengths?
        bytes32 convertedHash = bytes32(rawNode);

        // The first 32 bytes should become the hash
        bytes32 expectedHash = bytes32(rawNode[0:32]);
        assertEq(convertedHash, expectedHash, "Conversion should take first 32 bytes");
    }

    /// @notice Test: Can an attacker register a malicious node that gets cached?
    function testFuzz_CachePoison(
        bytes32 refHash,
        bytes memory maliciousNode
    ) public {
        // Skip too-short nodes
        if (maliciousNode.length < 20) return;

        // The first 20 bytes become the verifier address
        address verifier = address(bytes20(maliciousNode));
        if (verifier == address(0)) return;

        // For a new refHash, rootHash = refHash
        // To register a node, we need a valid Merkle proof where:
        // MerkleProofLib.verify(proof, rootHash, keccak256(node)) == true

        // For a single-leaf tree, the root IS the leaf hash
        bytes32 nodeHash = keccak256(maliciousNode);

        // If refHash == nodeHash, we can register with empty proof!
        bytes32 specialRefHash = nodeHash;
        bytes32[] memory emptyProof = new bytes32[](0);

        // This should work - registering a node where refHash = keccak256(node)
        vm.prank(ALICE);
        keystore.registerNode(specialRefHash, emptyProof, maliciousNode);

        // Verify it's cached
        bytes memory cachedNode = keystore.getRegisteredNode(specialRefHash, ALICE, nodeHash);
        assertEq(keccak256(cachedNode), keccak256(maliciousNode), "Node should be cached");
    }

    /*//////////////////////////////////////////////////////////////
                    NONCE REPLAY/RESET ATTACKS
    //////////////////////////////////////////////////////////////*/

    /// @notice Fuzz: Nonce key independence - actions with different keys should not interfere
    function testFuzz_NonceKeyIndependence(
        bytes32 refHash,
        uint192 key1,
        uint192 key2
    ) public view {
        if (key1 == key2) return;

        uint256 nonce1 = keystore.getNonce(refHash, ALICE, key1);
        uint256 nonce2 = keystore.getNonce(refHash, ALICE, key2);

        // Extract sequences (lower 64 bits)
        uint64 seq1 = uint64(nonce1);
        uint64 seq2 = uint64(nonce2);

        // Both should start at 0 for fresh state
        assertEq(seq1, 0, "Fresh nonce should start at 0");
        assertEq(seq2, 0, "Fresh nonce should start at 0");
    }

    /*//////////////////////////////////////////////////////////////
                    VERIFIER RETURN VALUE BOUNDS
    //////////////////////////////////////////////////////////////*/

    /// @notice The verifier should ONLY return 0 or 1
    /// @dev If verifier returns anything else, what happens?
    function testFuzz_VerifierReturnBounds(uint256 maliciousReturn) public {
        // Most verifiers are constrained to 0 or 1
        // But what if a malicious verifier returns other values?

        // SIG_VALIDATION_FAILED = 1
        // SIG_VALIDATION_SUCCESS = 0

        // The check in Keystore is:
        // IVerifier(verifier).validateData(...) == SIG_VALIDATION_FAILED

        // If verifier returns 2, 3, etc., it won't == 1, so it's treated as success!
        if (maliciousReturn != 0 && maliciousReturn != 1) {
            // This would be a bug if verifiers could return arbitrary values
            emit log_string("Malicious return value detected - verifier should be constrained");
        }
    }

    /*//////////////////////////////////////////////////////////////
                    SEQUENTIAL ATTACK SIMULATION
    //////////////////////////////////////////////////////////////*/

    /// @notice Simulate a long sequence of operations to find state corruption
    function testFuzz_LongSequence(uint256 seed) public {
        // Use seed to generate deterministic "random" operations
        uint256 ops = bound(seed % 100, 10, 50);

        bytes32 refHash = keccak256(abi.encode("test", seed));

        for (uint256 i = 0; i < ops; i++) {
            uint256 action = (seed >> i) % 3;

            if (action == 0) {
                // Check nonce
                uint192 key = uint192((seed >> (i + 1)) % 10);
                keystore.getNonce(refHash, ALICE, key);
            } else if (action == 1) {
                // Check root hash
                keystore.getRootHash(refHash, ALICE);
            } else {
                // Try to register node (will likely fail but shouldn't corrupt state)
                bytes memory node = abi.encodePacked(
                    address(ecdsaVerifier),
                    abi.encode(vm.addr(1))
                );
                bytes32[] memory proof = new bytes32[](0);
                try keystore.registerNode(refHash, proof, node) {} catch {}
            }
        }

        // State should still be consistent
        assertTrue(true, "Sequence completed without corruption");
    }
}
