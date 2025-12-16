// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import {ReentrancyGuardTransient} from "@openzeppelin/contracts/utils/ReentrancyGuardTransient.sol";
import {SIG_VALIDATION_FAILED} from "account-abstraction/core/Helpers.sol";
import {LibBytes} from "solady/utils/LibBytes.sol";
import {MerkleProofLib} from "solady/utils/MerkleProofLib.sol";

import {IKeystore} from "../interface/IKeystore.sol";
import {IVerifier} from "../interface/IVerifier.sol";
import {UpdateAction, ValidateAction} from "../lib/Actions.sol";

contract Keystore is IKeystore, ReentrancyGuardTransient {
    uint256 constant NODE_VERIFIER_LENGTH = 20;

    mapping(bytes32 refHash => mapping(address account => bytes32 rootHash)) internal _rootHash;
    mapping(bytes32 refHash => mapping(uint192 key => mapping(address account => uint64 seq))) internal _nonceSequence;
    mapping(bytes32 rootHash => mapping(bytes32 nodeHash => mapping(address account => bytes node))) internal _nodeCache;

    /**
     * @dev This function can revert if at least one UpdateAction in the batch encounters
     * any of the following errors:
     *   - InvalidNonce()
     *   - InvalidProof()
     *   - InvalidNextProof()
     *   - UnregisteredProof()
     *   - InvalidNode()
     *   - InvalidVerifier()
     *   - Verifier call revert
     * If a verifier call returns with SIG_VALIDATION_FAILED (1) this will NOT revert
     * but instead emit RootHashUpdated(..., success=false).
     * Relaying entities SHOULD run sufficient checks and simulations on their batch
     * before submitting onchain to prevent transaction reverts.
     */
    function handleUpdates(UpdateAction[] calldata actions) external nonReentrant {
        uint256 length = actions.length;
        for (uint256 i = 0; i < length; i++) {
            UpdateAction calldata action = actions[i];

            (uint192 nonceKey, uint64 nonceSeq) = _unpackNonceKey(action.nonce);
            uint64 currSeq = _validateAndGetNonce(action.refHash, action.account, nonceKey, nonceSeq);

            (bytes32 nodeHash, bytes memory node) =
                _fetchOrValidateNode(action.refHash, action.account, action.proof, action.node);
            bytes32 message = _getUpdateActionHash(action, nodeHash);

            if (_isSigValidationFailed(message, node, action.data)) {
                emit RootHashUpdated(action.refHash, action.account, action.nextHash, action.nonce, false);
            } else if (
                _requiresNextNodeVerifierCall(action.nextHash, nodeHash, action.nextProof, action.nextNode)
                    && _isSigValidationFailed(message, action.nextNode, action.nextData)
            ) {
                emit RootHashUpdated(action.refHash, action.account, action.nextHash, action.nonce, false);
            } else {
                _rootHash[action.refHash][action.account] = action.nextHash;
                _incrementNonce(action.refHash, action.account, nonceKey, currSeq);
                emit RootHashUpdated(action.refHash, action.account, action.nextHash, action.nonce, true);
            }
        }
    }

    function validate(ValidateAction calldata action) external view returns (uint256 validationData) {
        (, bytes memory node) = _fetchOrValidateNode(action.refHash, msg.sender, action.proof, action.node);

        (address verifier, bytes memory config) = _unpackNode(node);
        return IVerifier(verifier).validateData(action.message, action.data, config);
    }

    function registerNode(bytes32 refHash, bytes32[] calldata proof, bytes calldata node) external {
        require(node.length >= NODE_VERIFIER_LENGTH, InvalidNode());
        require(address(bytes20(node[0:NODE_VERIFIER_LENGTH])) != address(0), InvalidVerifier());

        bytes32 rootHash = _getCurrentRootHash(refHash, msg.sender);
        bytes32 nodeHash = keccak256(node);
        require(MerkleProofLib.verifyCalldata(proof, rootHash, nodeHash), InvalidProof());

        _nodeCache[rootHash][nodeHash][msg.sender] = node;
    }

    function getRegisteredNode(bytes32 refHash, address account, bytes32 nodeHash)
        external
        view
        returns (bytes memory)
    {
        return _nodeCache[_getCurrentRootHash(refHash, account)][nodeHash][account];
    }

    function getRootHash(bytes32 refHash, address account) external view returns (bytes32 rootHash) {
        rootHash = _getCurrentRootHash(refHash, account);
    }

    function getNonce(bytes32 refHash, address account, uint192 key) external view returns (uint256 nonce) {
        return _nonceSequence[refHash][key][account] | (uint256(key) << 64);
    }

    // ================================================================
    // Internal functions
    // ================================================================

    function _unpackNonceKey(uint256 nonce) internal pure returns (uint192 nonceKey, uint64 nonceSeq) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04730000, 1037618709619) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04730001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04730005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04736000, nonce) }
        nonceKey = uint192(nonce >> 64);
        nonceSeq = uint64(nonce);
    }

    function _validateAndGetNonce(bytes32 refHash, address account, uint192 key, uint64 seq)
        internal
        view
        returns (uint64 currSeq)
    {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04740000, 1037618709620) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04740001, 4) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04740005, 585) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04746003, seq) }
        currSeq = _nonceSequence[refHash][key][account];
        require(currSeq == seq, InvalidNonce());
    }

    function _incrementNonce(bytes32 refHash, address account, uint192 key, uint64 currSeq) internal {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04760000, 1037618709622) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04760001, 4) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04760005, 585) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04766003, currSeq) }
        _nonceSequence[refHash][key][account] = currSeq + 1;
    }

    function _getCurrentRootHash(bytes32 refHash, address account) internal view returns (bytes32) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04770000, 1037618709623) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04770001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04770005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04776001, account) }
        bytes32 currRootHash = _rootHash[refHash][account];
        return currRootHash == bytes32(0) ? refHash : currRootHash;
    }

    function _unpackNode(bytes memory node) internal pure returns (address verifier, bytes memory config) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04750000, 1037618709621) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04750001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04750005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04756000, node) }
        if (node.length < NODE_VERIFIER_LENGTH) revert InvalidNode();

        verifier = address(bytes20(LibBytes.slice(node, 0, NODE_VERIFIER_LENGTH)));
        config = LibBytes.slice(node, NODE_VERIFIER_LENGTH, node.length);
        if (verifier == address(0)) {
            revert InvalidVerifier();
        }
    }

    function _fetchOrValidateNode(bytes32 refHash, address account, bytes calldata aProof, bytes calldata aNode)
        internal
        view
        returns (bytes32 nodeHash, bytes memory node)
    {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04780000, 1037618709624) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04780001, 6) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04780005, 38554) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04786104, aNode.offset) }
        if (aProof.length == 0) {
            nodeHash = bytes32(aNode); // convert from bytes to bytes32
            node = _nodeCache[_getCurrentRootHash(refHash, account)][nodeHash][account];
            require(node.length >= NODE_VERIFIER_LENGTH, UnregisteredProof());
        } else {
            nodeHash = keccak256(aNode);
            node = aNode;
            (bytes32[] memory proof) = abi.decode(aProof, (bytes32[]));
            require(MerkleProofLib.verify(proof, _getCurrentRootHash(refHash, account), nodeHash), InvalidProof());
        }
    }

    function _getUpdateActionHash(UpdateAction calldata action, bytes32 nodeHash)
        internal
        view
        returns (bytes32 message)
    {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04790000, 1037618709625) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04790001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04790005, 33) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04796001, nodeHash) }
        message = action.useChainId
            ? keccak256(
                abi.encode(
                    action.refHash,
                    action.nextHash,
                    action.account,
                    action.nonce,
                    nodeHash,
                    keccak256(action.nextNode),
                    block.chainid
                )
            )
            : keccak256(
                abi.encode(
                    action.refHash, action.nextHash, action.account, action.nonce, nodeHash, keccak256(action.nextNode)
                )
            );
    }

    function _isSigValidationFailed(bytes32 message, bytes memory node, bytes memory data)
        internal
        view
        returns (bool)
    {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff047a0000, 1037618709626) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff047a0001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff047a0005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff047a6002, data) }
        (address verifier, bytes memory config) = _unpackNode(node);
        return IVerifier(verifier).validateData(message, data, config) == SIG_VALIDATION_FAILED;
    }

    function _requiresNextNodeVerifierCall(
        bytes32 nextHash,
        bytes32 nodeHash,
        bytes calldata nextProof,
        bytes calldata nextNode
    ) internal pure returns (bool) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff047b0000, 1037618709627) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff047b0001, 6) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff047b0005, 38554) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff047b6104, nextNode.offset) }
        (bytes32[] memory proof) = abi.decode(nextProof, (bytes32[]));
        if (nextNode.length == 0) {
            require(MerkleProofLib.verify(proof, nextHash, nodeHash), InvalidNextProof());
            return false;
        } else {
            require(MerkleProofLib.verify(proof, nextHash, keccak256(nextNode)), InvalidNextProof());
            return true;
        }
    }
}
