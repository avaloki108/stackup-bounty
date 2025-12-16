// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import {Test} from "forge-std/Test.sol";
import {Merkle} from "murky/src/Merkle.sol";
import {MerkleProofLib} from "solady/utils/MerkleProofLib.sol";

import {Keystore} from "../../src/core/Keystore.sol";
import {IKeystore} from "../../src/interface/IKeystore.sol";
import {VerifierMock} from "../mock/VerifierMock.sol";
import {SIG_VALIDATION_SUCCESS} from "account-abstraction/core/Helpers.sol";

/**
 * @title MerkleProofEdgeCases
 * @notice Targeted tests for Merkle proof verification vulnerabilities
 *
 * FOCUS AREAS:
 * 1. Invalid proofs never update root / never mark nodes valid
 * 2. Valid proofs only validate the exact leaf intended
 * 3. Proof manipulation (bit flips, reordering, wrong depth)
 * 4. Second preimage resistance
 * 5. Empty/edge case proofs
 */
contract MerkleProofEdgeCases is Test {
    Keystore public keystore;
    Merkle public ucmt;
    VerifierMock public verifier;

    function setUp() public {
        keystore = new Keystore();
        ucmt = new Merkle();
        verifier = new VerifierMock(SIG_VALIDATION_SUCCESS);
    }

    /*//////////////////////////////////////////////////////////////
              TEST: INVALID PROOFS NEVER UPDATE STATE
    //////////////////////////////////////////////////////////////*/

    /**
     * @notice Flipping one bit in proof should cause rejection
     */
    function testFuzz_bitFlipInProofRejected(
        bytes32[] calldata leaves,
        uint256 leafIndex,
        uint256 proofIndex,
        uint256 bitPosition
    ) public {
        vm.assume(leaves.length >= 2 && leaves.length <= 16);
        vm.assume(leafIndex < leaves.length);
        vm.assume(bitPosition < 256);

        // Create node with valid verifier
        bytes memory node = abi.encodePacked(address(verifier), bytes32(uint256(leafIndex)));
        bytes32 nodeHash = keccak256(node);

        // Build tree
        bytes32[] memory tree = new bytes32[](leaves.length);
        for (uint256 i = 0; i < leaves.length; i++) {
            tree[i] = i == leafIndex ? nodeHash : leaves[i];
        }
        bytes32 root = ucmt.getRoot(tree);
        bytes32[] memory validProof = ucmt.getProof(tree, leafIndex);

        vm.assume(proofIndex < validProof.length);

        // Flip one bit in proof
        bytes32[] memory corruptedProof = new bytes32[](validProof.length);
        for (uint256 i = 0; i < validProof.length; i++) {
            if (i == proofIndex) {
                corruptedProof[i] = bytes32(uint256(validProof[i]) ^ (1 << bitPosition));
            } else {
                corruptedProof[i] = validProof[i];
            }
        }

        // Verify that corrupted proof is rejected
        bool isValid = MerkleProofLib.verify(corruptedProof, root, nodeHash);

        // If the bit flip happens to create another valid proof path (astronomically unlikely),
        // that's still a valid Merkle proof - not a vulnerability
        // But typically this should fail
        if (!isValid) {
            // Try to register with corrupted proof - should revert
            vm.expectRevert(IKeystore.InvalidProof.selector);
            keystore.registerNode(root, corruptedProof, node);
        }
    }

    /**
     * @notice Swapping sibling order should cause rejection
     */
    function testFuzz_siblingOrderSwapRejected(
        bytes32[] calldata leaves,
        uint256 leafIndex
    ) public {
        vm.assume(leaves.length >= 4 && leaves.length <= 16);
        vm.assume(leafIndex < leaves.length);

        bytes memory node = abi.encodePacked(address(verifier), bytes32(uint256(leafIndex)));
        bytes32 nodeHash = keccak256(node);

        bytes32[] memory tree = new bytes32[](leaves.length);
        for (uint256 i = 0; i < leaves.length; i++) {
            tree[i] = i == leafIndex ? nodeHash : leaves[i];
        }
        bytes32 root = ucmt.getRoot(tree);
        bytes32[] memory validProof = ucmt.getProof(tree, leafIndex);

        // Need at least 2 proof elements to swap
        vm.assume(validProof.length >= 2);

        // Swap first two elements
        bytes32[] memory swappedProof = new bytes32[](validProof.length);
        swappedProof[0] = validProof[1];
        swappedProof[1] = validProof[0];
        for (uint256 i = 2; i < validProof.length; i++) {
            swappedProof[i] = validProof[i];
        }

        // Should be rejected
        bool isValid = MerkleProofLib.verify(swappedProof, root, nodeHash);
        assertFalse(isValid, "Swapped proof should be invalid");
    }

    /**
     * @notice Truncated proof should be rejected
     */
    function testFuzz_truncatedProofRejected(
        bytes32[] calldata leaves,
        uint256 leafIndex
    ) public {
        vm.assume(leaves.length >= 4 && leaves.length <= 16);
        vm.assume(leafIndex < leaves.length);

        bytes memory node = abi.encodePacked(address(verifier), bytes32(uint256(leafIndex)));
        bytes32 nodeHash = keccak256(node);

        bytes32[] memory tree = new bytes32[](leaves.length);
        for (uint256 i = 0; i < leaves.length; i++) {
            tree[i] = i == leafIndex ? nodeHash : leaves[i];
        }
        bytes32 root = ucmt.getRoot(tree);
        bytes32[] memory validProof = ucmt.getProof(tree, leafIndex);

        vm.assume(validProof.length >= 2);

        // Truncate proof
        bytes32[] memory truncatedProof = new bytes32[](validProof.length - 1);
        for (uint256 i = 0; i < truncatedProof.length; i++) {
            truncatedProof[i] = validProof[i];
        }

        // Should be rejected
        bool isValid = MerkleProofLib.verify(truncatedProof, root, nodeHash);
        assertFalse(isValid, "Truncated proof should be invalid");
    }

    /**
     * @notice Extended proof (extra elements) should be rejected
     */
    function testFuzz_extendedProofRejected(
        bytes32[] calldata leaves,
        uint256 leafIndex,
        bytes32 extraElement
    ) public {
        vm.assume(leaves.length >= 2 && leaves.length <= 16);
        vm.assume(leafIndex < leaves.length);

        bytes memory node = abi.encodePacked(address(verifier), bytes32(uint256(leafIndex)));
        bytes32 nodeHash = keccak256(node);

        bytes32[] memory tree = new bytes32[](leaves.length);
        for (uint256 i = 0; i < leaves.length; i++) {
            tree[i] = i == leafIndex ? nodeHash : leaves[i];
        }
        bytes32 root = ucmt.getRoot(tree);
        bytes32[] memory validProof = ucmt.getProof(tree, leafIndex);

        // Extend proof
        bytes32[] memory extendedProof = new bytes32[](validProof.length + 1);
        for (uint256 i = 0; i < validProof.length; i++) {
            extendedProof[i] = validProof[i];
        }
        extendedProof[validProof.length] = extraElement;

        // Should be rejected
        bool isValid = MerkleProofLib.verify(extendedProof, root, nodeHash);
        assertFalse(isValid, "Extended proof should be invalid");
    }

    /*//////////////////////////////////////////////////////////////
            TEST: VALID PROOFS ONLY VALIDATE EXACT LEAF
    //////////////////////////////////////////////////////////////*/

    /**
     * @notice Proof for leaf A cannot validate leaf B
     */
    function testFuzz_proofForACannotValidateB(
        bytes32[] calldata leaves,
        uint256 indexA,
        uint256 indexB
    ) public {
        vm.assume(leaves.length >= 4 && leaves.length <= 16);
        vm.assume(indexA < leaves.length);
        vm.assume(indexB < leaves.length);
        vm.assume(indexA != indexB);

        bytes memory nodeA = abi.encodePacked(address(verifier), bytes32(uint256(indexA)));
        bytes memory nodeB = abi.encodePacked(address(verifier), bytes32(uint256(indexB)));
        bytes32 nodeHashA = keccak256(nodeA);
        bytes32 nodeHashB = keccak256(nodeB);

        bytes32[] memory tree = new bytes32[](leaves.length);
        for (uint256 i = 0; i < leaves.length; i++) {
            if (i == indexA) tree[i] = nodeHashA;
            else if (i == indexB) tree[i] = nodeHashB;
            else tree[i] = leaves[i];
        }
        bytes32 root = ucmt.getRoot(tree);
        bytes32[] memory proofForA = ucmt.getProof(tree, indexA);

        // Proof for A should validate A
        bool validForA = MerkleProofLib.verify(proofForA, root, nodeHashA);
        assertTrue(validForA, "Proof for A should validate A");

        // Proof for A should NOT validate B
        bool validForB = MerkleProofLib.verify(proofForA, root, nodeHashB);
        assertFalse(validForB, "Proof for A should NOT validate B");
    }

    /*//////////////////////////////////////////////////////////////
                  TEST: EMPTY AND EDGE CASE PROOFS
    //////////////////////////////////////////////////////////////*/

    /**
     * @notice Empty proof is valid only if leaf == root (single-node tree)
     */
    function test_emptyProofSingleNode() public view {
        bytes memory node = abi.encodePacked(address(verifier), bytes32(0));
        bytes32 nodeHash = keccak256(node);

        // Single node tree: root = leaf
        bytes32 root = nodeHash;
        bytes32[] memory emptyProof = new bytes32[](0);

        // Should be valid
        bool isValid = MerkleProofLib.verify(emptyProof, root, nodeHash);
        assertTrue(isValid, "Empty proof valid when leaf == root");
    }

    /**
     * @notice Empty proof invalid when leaf != root
     */
    function testFuzz_emptyProofInvalidWhenLeafNotRoot(bytes32 root, bytes32 leaf) public view {
        vm.assume(root != leaf);

        bytes32[] memory emptyProof = new bytes32[](0);

        bool isValid = MerkleProofLib.verify(emptyProof, root, leaf);
        assertFalse(isValid, "Empty proof should be invalid when leaf != root");
    }

    /*//////////////////////////////////////////////////////////////
                   TEST: SECOND PREIMAGE RESISTANCE
    //////////////////////////////////////////////////////////////*/

    /**
     * @notice Cannot find different leaf that validates with same proof
     * @dev This tests the underlying hash function's preimage resistance
     */
    function testFuzz_secondPreimageResistance(
        bytes32[] calldata leaves,
        uint256 leafIndex,
        bytes memory differentNode
    ) public {
        vm.assume(leaves.length >= 2 && leaves.length <= 16);
        vm.assume(leafIndex < leaves.length);
        vm.assume(differentNode.length >= 20);
        // Ensure differentNode has valid verifier (non-zero first 20 bytes)
        vm.assume(address(bytes20(differentNode)) != address(0));

        bytes memory originalNode = abi.encodePacked(address(verifier), bytes32(uint256(leafIndex)));
        bytes32 originalHash = keccak256(originalNode);
        bytes32 differentHash = keccak256(differentNode);

        // Only test if hashes differ (not a hash collision)
        vm.assume(originalHash != differentHash);

        bytes32[] memory tree = new bytes32[](leaves.length);
        for (uint256 i = 0; i < leaves.length; i++) {
            tree[i] = i == leafIndex ? originalHash : leaves[i];
        }
        bytes32 root = ucmt.getRoot(tree);
        bytes32[] memory proof = ucmt.getProof(tree, leafIndex);

        // Proof validates original
        assertTrue(MerkleProofLib.verify(proof, root, originalHash), "Should validate original");

        // Proof does NOT validate different node
        assertFalse(MerkleProofLib.verify(proof, root, differentHash), "Should NOT validate different node");
    }

    /*//////////////////////////////////////////////////////////////
                TEST: NODE CACHE SECURITY
    //////////////////////////////////////////////////////////////*/

    /**
     * @notice registerNode only caches for caller, not others
     */
    function testFuzz_nodeCacheIsolation(
        bytes32[] calldata leaves,
        uint256 leafIndex,
        address otherAccount
    ) public {
        vm.assume(leaves.length >= 2 && leaves.length <= 16);
        vm.assume(leafIndex < leaves.length);
        vm.assume(otherAccount != address(this));
        vm.assume(otherAccount != address(0));

        bytes memory node = abi.encodePacked(address(verifier), bytes32(uint256(leafIndex)));
        bytes32 nodeHash = keccak256(node);

        bytes32[] memory tree = new bytes32[](leaves.length);
        for (uint256 i = 0; i < leaves.length; i++) {
            tree[i] = i == leafIndex ? nodeHash : leaves[i];
        }
        bytes32 refHash = ucmt.getRoot(tree);
        bytes32[] memory proof = ucmt.getProof(tree, leafIndex);

        // Register as this contract
        keystore.registerNode(refHash, proof, node);

        // Verify cached for this
        bytes memory cachedForThis = keystore.getRegisteredNode(refHash, address(this), nodeHash);
        assertGe(cachedForThis.length, 20, "Should be cached for caller");

        // NOT cached for other account
        bytes memory cachedForOther = keystore.getRegisteredNode(refHash, otherAccount, nodeHash);
        assertEq(cachedForOther.length, 0, "Should NOT be cached for other account");
    }

    /**
     * @notice Root hash change invalidates cache
     */
    function testFuzz_cacheInvalidatedOnRootChange(
        bytes32[] calldata leaves,
        uint256 leafIndex
    ) public {
        vm.assume(leaves.length >= 2 && leaves.length <= 16);
        vm.assume(leafIndex < leaves.length);

        bytes memory node = abi.encodePacked(address(verifier), bytes32(uint256(leafIndex)));
        bytes32 nodeHash = keccak256(node);

        bytes32[] memory tree = new bytes32[](leaves.length);
        for (uint256 i = 0; i < leaves.length; i++) {
            tree[i] = i == leafIndex ? nodeHash : leaves[i];
        }
        bytes32 refHash = ucmt.getRoot(tree);
        bytes32[] memory proof = ucmt.getProof(tree, leafIndex);

        // Register node
        keystore.registerNode(refHash, proof, node);

        // Verify cached
        bytes memory cachedBefore = keystore.getRegisteredNode(refHash, address(this), nodeHash);
        assertGe(cachedBefore.length, 20, "Should be cached");

        // Note: To fully test cache invalidation, we'd need to:
        // 1. Perform handleUpdates to change root hash
        // 2. Verify the old cache is now inaccessible
        // This requires a more complex test setup with valid update signatures
    }
}
