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
        uint256 length = actions.length;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000001,length)}
        for (uint256 i = 0; i < length; i++) {
            UpdateAction calldata action = actions[i];assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00010010,0)}

            (uint192 nonceKey, uint64 nonceSeq) = _unpackNonceKey(action.nonce);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00010011,0)}
            uint64 currSeq = _validateAndGetNonce(action.refHash, action.account, nonceKey, nonceSeq);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000012,currSeq)}

            (bytes32 nodeHash, bytes memory node) =
                _fetchOrValidateNode(action.refHash, action.account, action.proof, action.node);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00010013,0)}
            bytes32 message = _getUpdateActionHash(action, nodeHash);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000014,message)}

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
        (, bytes memory node) = _fetchOrValidateNode(action.refHash, msg.sender, action.proof, action.node);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00010002,0)}

        (address verifier, bytes memory config) = _unpackNode(node);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00010003,0)}
        return IVerifier(verifier).validateData(action.message, action.data, config);
    }

    function registerNode(bytes32 refHash, bytes32[] calldata proof, bytes calldata node) external {
        require(node.length >= NODE_VERIFIER_LENGTH, InvalidNode());
        require(address(bytes20(node[0:NODE_VERIFIER_LENGTH])) != address(0), InvalidVerifier());

        bytes32 rootHash = _getCurrentRootHash(refHash, msg.sender);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000004,rootHash)}
        bytes32 nodeHash = keccak256(node);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000005,nodeHash)}
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
        rootHash = _getCurrentRootHash(refHash, account);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000009,rootHash)}
    }

    function getNonce(bytes32 refHash, address account, uint192 key) external view returns (uint256 nonce) {
        return _nonceSequence[refHash][key][account] | (uint256(key) << 64);
    }

    // ================================================================
    // Internal functions
    // ================================================================

    function _unpackNonceKey(uint256 nonce) internal pure returns (uint192 nonceKey, uint64 nonceSeq) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff02d70000, 1037618709207) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff02d70001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff02d70005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff02d76000, nonce) }
        nonceKey = uint192(nonce >> 64);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0000000a,nonceKey)}
        nonceSeq = uint64(nonce);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0000000b,nonceSeq)}
    }

    function _validateAndGetNonce(bytes32 refHash, address account, uint192 key, uint64 seq)
        internal
        view
        returns (uint64 currSeq)
    {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff02d80000, 1037618709208) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff02d80001, 4) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff02d80005, 585) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff02d86003, seq) }
        currSeq = _nonceSequence[refHash][key][account];assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0000000c,currSeq)}
        require(currSeq == seq, InvalidNonce());
    }

    function _incrementNonce(bytes32 refHash, address account, uint192 key, uint64 currSeq) internal {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff02da0000, 1037618709210) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff02da0001, 4) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff02da0005, 585) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff02da6003, currSeq) }
        _nonceSequence[refHash][key][account] = currSeq + 1;
    }

    function _getCurrentRootHash(bytes32 refHash, address account) internal view returns (bytes32) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff02db0000, 1037618709211) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff02db0001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff02db0005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff02db6001, account) }
        bytes32 currRootHash = _rootHash[refHash][account];assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000006,currRootHash)}
        return currRootHash == bytes32(0) ? refHash : currRootHash;
    }

    function _unpackNode(bytes memory node) internal pure returns (address verifier, bytes memory config) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff02d90000, 1037618709209) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff02d90001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff02d90005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff02d96000, node) }
        if (node.length < NODE_VERIFIER_LENGTH) revert InvalidNode();

        verifier = address(bytes20(LibBytes.slice(node, 0, NODE_VERIFIER_LENGTH)));assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0000000d,verifier)}
        config = LibBytes.slice(node, NODE_VERIFIER_LENGTH, node.length);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0002000e,0)}
        if (verifier == address(0)) {
            revert InvalidVerifier();
        }
    }

    function _fetchOrValidateNode(bytes32 refHash, address account, bytes calldata aProof, bytes calldata aNode)
        internal
        view
        returns (bytes32 nodeHash, bytes memory node)
    {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff02dc0000, 1037618709212) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff02dc0001, 6) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff02dc0005, 38554) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff02dc6104, aNode.offset) }
        if (aProof.length == 0) {
            nodeHash = bytes32(aNode); // convert from bytes to bytes32
            node = _nodeCache[_getCurrentRootHash(refHash, account)][nodeHash][account];
            require(node.length >= NODE_VERIFIER_LENGTH, UnregisteredProof());
        } else {
            nodeHash = keccak256(aNode);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000016,nodeHash)}
            node = aNode;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00020017,0)}
            (bytes32[] memory proof) = abi.decode(aProof, (bytes32[]));assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00010015,0)}
            require(MerkleProofLib.verify(proof, _getCurrentRootHash(refHash, account), nodeHash), InvalidProof());
        }
    }

    function _getUpdateActionHash(UpdateAction calldata action, bytes32 nodeHash)
        internal
        view
        returns (bytes32 message)
    {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff02dd0000, 1037618709213) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff02dd0001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff02dd0005, 33) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff02dd6001, nodeHash) }
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
            );assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0000000f,message)}
    }

    function _isSigValidationFailed(bytes32 message, bytes memory node, bytes memory data)
        internal
        view
        returns (bool)
    {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff02de0000, 1037618709214) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff02de0001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff02de0005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff02de6002, data) }
        (address verifier, bytes memory config) = _unpackNode(node);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00010007,0)}
        return IVerifier(verifier).validateData(message, data, config) == SIG_VALIDATION_FAILED;
    }

    function _requiresNextNodeVerifierCall(
        bytes32 nextHash,
        bytes32 nodeHash,
        bytes calldata nextProof,
        bytes calldata nextNode
    ) internal pure returns (bool) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff02df0000, 1037618709215) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff02df0001, 6) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff02df0005, 38554) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff02df6104, nextNode.offset) }
        (bytes32[] memory proof) = abi.decode(nextProof, (bytes32[]));assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00010008,0)}
        if (nextNode.length == 0) {
            require(MerkleProofLib.verify(proof, nextHash, nodeHash), InvalidNextProof());
            return false;
        } else {
            require(MerkleProofLib.verify(proof, nextHash, keccak256(nextNode)), InvalidNextProof());
            return true;
        }
    }
}
