// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import {SIG_VALIDATION_SUCCESS} from "account-abstraction/core/Helpers.sol";
import {Test} from "forge-std/Test.sol";
import {LibBytes} from "solady/utils/LibBytes.sol";

import {Keystore} from "../../src/core/Keystore.sol";
import {IKeystore} from "../../src/interface/IKeystore.sol";
import {IVerifier} from "../../src/interface/IVerifier.sol";
import {UpdateAction, ValidateAction} from "../../src/lib/Actions.sol";

contract Keystore32NodeUCMT is Test {
    Keystore public keystore;

    function setUp() public {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07a80000, 1037618710440) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07a80001, 0) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07a80004, 0) }
        keystore = new Keystore();
    }

    function test_registerNode() public {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07a20000, 1037618710434) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07a20001, 0) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07a20004, 0) }
        bytes32[] memory proof = _getProof();assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00010018,0)}
        ValidateAction memory action = _getValidateAction("");assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00010019,0)}

        vm.startSnapshotGas("1. registerNode");
        keystore.registerNode(action.refHash, proof, action.node);
        vm.stopSnapshotGas();
    }

    function test_validate_withProof() public {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07a50000, 1037618710437) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07a50001, 0) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07a50004, 0) }
        bytes32[] memory proof = _getProof();assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0001001a,0)}
        ValidateAction memory action = _getValidateAction(abi.encode(proof));assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0001001b,0)}

        _mockVerifier(action.message, action.node, action.data);

        vm.startSnapshotGas("2. validate (with proof)");
        uint256 actualValidationData = keystore.validate(action);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0000001c,actualValidationData)}
        vm.stopSnapshotGas();
        assertEq(actualValidationData, SIG_VALIDATION_SUCCESS);
    }

    function test_validate_withoutProof() public {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07ac0000, 1037618710444) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07ac0001, 0) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07ac0004, 0) }
        bytes32[] memory proof = _getProof();assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0001001d,0)}
        ValidateAction memory action = _getValidateAction("");assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0001001e,0)}
        keystore.registerNode(action.refHash, proof, action.node);

        _mockVerifier(action.message, action.node, action.data);

        action.node = abi.encode(keccak256(action.node));assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00020029,0)}
        vm.startSnapshotGas("3. validate (without proof)");
        uint256 actualValidationData = keystore.validate(action);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0000001f,actualValidationData)}
        vm.stopSnapshotGas();
        assertEq(actualValidationData, SIG_VALIDATION_SUCCESS);
    }

    function test_handleUpdate_withProof() public {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07a10000, 1037618710433) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07a10001, 0) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07a10004, 0) }
        bytes32[] memory proof = _getProof();assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00010020,0)}
        bytes32[] memory nextProof = _getNextProof();assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00010021,0)}
        UpdateAction[] memory actions = _getUpdateActions(abi.encode(proof), abi.encode(nextProof));assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00010022,0)}

        _mockVerifier(
            keccak256(
                abi.encode(
                    actions[0].refHash,
                    actions[0].nextHash,
                    actions[0].account,
                    actions[0].nonce,
                    keccak256(actions[0].node),
                    keccak256(actions[0].nextNode)
                )
            ),
            actions[0].node,
            actions[0].data
        );

        vm.expectEmit();
        emit IKeystore.RootHashUpdated(actions[0].refHash, address(this), actions[0].nextHash, actions[0].nonce, true);
        vm.startSnapshotGas("4. handleUpdates (with proof)");
        keystore.handleUpdates(actions);
        vm.stopSnapshotGas();
    }

    function test_handleUpdate_withoutProof() public {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07af0000, 1037618710447) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07af0001, 0) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07af0004, 0) }
        bytes32[] memory proof = _getProof();assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00010023,0)}
        bytes32[] memory nextProof = _getNextProof();assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00010024,0)}
        UpdateAction[] memory actions = _getUpdateActions("", abi.encode(nextProof));assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00010025,0)}
        keystore.registerNode(actions[0].refHash, proof, actions[0].node);

        _mockVerifier(
            keccak256(
                abi.encode(
                    actions[0].refHash,
                    actions[0].nextHash,
                    actions[0].account,
                    actions[0].nonce,
                    keccak256(actions[0].node),
                    keccak256(actions[0].nextNode)
                )
            ),
            actions[0].node,
            actions[0].data
        );

        vm.expectEmit();
        emit IKeystore.RootHashUpdated(actions[0].refHash, address(this), actions[0].nextHash, actions[0].nonce, true);
        actions[0].node = abi.encode(keccak256(actions[0].node));assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0002002a,0)}
        vm.startSnapshotGas("5. handleUpdates (without proof)");
        keystore.handleUpdates(actions);
        vm.stopSnapshotGas();
    }

    // ================================================================
    // Helper functions
    // ================================================================

    function _getProof() internal pure returns (bytes32[] memory) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff079a0000, 1037618710426) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff079a0001, 0) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff079a0004, 0) }
        bytes32[] memory proof = new bytes32[](5);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00010026,0)}
        proof[0] = 0xd75925ab1c24fe4af10b28baa7b632d28a52ffc73eae1a386152fd44e805fe15;bytes32 certora_local43 = proof[0];assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0000002b,certora_local43)}
        proof[1] = 0xbfc020b001604c83cdaf1759486f5d4547d89278b8e90ee2e49cc9b8576cf3ee;bytes32 certora_local44 = proof[1];assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0000002c,certora_local44)}
        proof[2] = 0xecd6bb55e8f496defad7865a73041e22a4a761938c6638e288e8380768e99c19;bytes32 certora_local45 = proof[2];assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0000002d,certora_local45)}
        proof[3] = 0xf8a598929a6ff9a031bc9727bf8536a590d1dc764fe678d5595f8459221a8e25;bytes32 certora_local46 = proof[3];assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0000002e,certora_local46)}
        proof[4] = 0xb0cf634098ce6f594f969fdde6243f10810a5a2817676821356a9aba230baf01;bytes32 certora_local47 = proof[4];assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0000002f,certora_local47)}
        return proof;
    }

    function _getNextProof() internal pure returns (bytes32[] memory) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff079b0000, 1037618710427) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff079b0001, 0) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff079b0004, 0) }
        bytes32[] memory proof = new bytes32[](5);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00010027,0)}
        proof[0] = 0x9ee4edde6a7fd03851aab27a77e7a3fb77f2fdfde7c4dfbfaf5dcae99698f684;bytes32 certora_local48 = proof[0];assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000030,certora_local48)}
        proof[1] = 0xe999f6e618762b50b717ff1809f6c86d7e15753ba2f792fb16c6262373c10b7a;bytes32 certora_local49 = proof[1];assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000031,certora_local49)}
        proof[2] = 0x09a2e71e783ee4e7550de83552c555c04bb81384f4299a087bded32e5d6e0586;bytes32 certora_local50 = proof[2];assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000032,certora_local50)}
        proof[3] = 0xe18e4b59fe0f576bd444f3e6f496020239e4b6391c703c15ae2538c358a2baac;bytes32 certora_local51 = proof[3];assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000033,certora_local51)}
        proof[4] = 0x8cdc539d55721a221aa7a351817962aa7f35639d126c1860936cedbc1de9796c;bytes32 certora_local52 = proof[4];assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000034,certora_local52)}
        return proof;
    }

    function _getValidateAction(bytes memory proof) internal pure returns (ValidateAction memory) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff079d0000, 1037618710429) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff079d0001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff079d0005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff079d6000, proof) }
        return ValidateAction({
            refHash: 0x919c2e64fdfe95a09781da7a31cec323904edeece2aadab9db2809401f24feb1,
            message: keccak256(hex"deadbeef"),
            proof: proof,
            node: hex"217c31512a2fc94b172b5ef447d1deca0abf0c34a47ae671572752b2eafbb25ce40f59229f25811cfae1c253226d6b08cbecfd13e8b413cdbe616886c94b",
            data: hex"7b41359034736ce7bb5277e09979f3b337"
        });
    }

    function _getUpdateActions(bytes memory proof, bytes memory nextProof)
        internal
        view
        returns (UpdateAction[] memory)
    {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff079e0000, 1037618710430) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff079e0001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff079e0005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff079e6001, nextProof) }
        UpdateAction[] memory actions = new UpdateAction[](1);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00010028,0)}
        actions[0] = UpdateAction({
            refHash: 0x919c2e64fdfe95a09781da7a31cec323904edeece2aadab9db2809401f24feb1,
            nextHash: 0xb13960137758ce826ea70bb3d7d699c7f81f467610baf36babb5902b08d98529,
            nonce: 779254045811195516568393371847926550426994733077148739871778103143432192,
            useChainId: false,
            account: address(this),
            proof: proof,
            node: hex"217c31512a2fc94b172b5ef447d1deca0abf0c34a47ae671572752b2eafbb25ce40f59229f25811cfae1c253226d6b08cbecfd13e8b413cdbe616886c94b",
            data: hex"7b41359034736ce7bb5277e09979f3b337",
            nextProof: nextProof,
            nextNode: "",
            nextData: ""
        });assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00020035,0)}
        return actions;
    }

    function _mockVerifier(bytes32 message, bytes memory node, bytes memory data) internal {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff079c0000, 1037618710428) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff079c0001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff079c0005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff079c6002, data) }
        vm.mockCall(
            address(bytes20(node)),
            abi.encodeWithSelector(
                IVerifier.validateData.selector, message, data, LibBytes.slice(node, 20, node.length)
            ),
            abi.encodePacked(SIG_VALIDATION_SUCCESS)
        );
    }
}
