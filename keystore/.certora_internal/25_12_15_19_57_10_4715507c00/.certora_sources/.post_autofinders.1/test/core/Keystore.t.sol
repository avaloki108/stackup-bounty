// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import {SIG_VALIDATION_FAILED, SIG_VALIDATION_SUCCESS} from "account-abstraction/core/Helpers.sol";
import {console} from "forge-std/console.sol";
import {Test} from "forge-std/Test.sol";
import {Merkle} from "murky/src/Merkle.sol";
import {LibBytes} from "solady/utils/LibBytes.sol";

import {VerifierMock} from "../mock/VerifierMock.sol";
import {Keystore} from "../../src/core/Keystore.sol";
import {IKeystore} from "../../src/interface/IKeystore.sol";
import {IVerifier} from "../../src/interface/IVerifier.sol";
import {UpdateAction, ValidateAction} from "../../src/lib/Actions.sol";

contract KeystoreTest is Test {
    Keystore public keystore;
    Merkle public ucmt;

    struct UCMTProps {
        bytes32 root;
        bytes proof;
        bytes node;
    }

    struct MultiUpdateProps {
        UCMTProps init;
        UCMTProps next;
        UCMTProps fin;
    }

    struct UpdateInputs {
        bytes32 refHash;
        bytes32 nextHash;
        bytes proof;
        bytes node;
        bytes nextProof;
        bytes nextNode;
        uint256 nonce;
        bytes32 message;
    }

    function setUp() public {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff030b0000, 1037618709259) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff030b0001, 0) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff030b0004, 0) }
        keystore = new Keystore();
        ucmt = new Merkle();
    }

    function testFuzz_initRootHash(bytes32 refHash, address account) public view {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff02fb0000, 1037618709243) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff02fb0001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff02fb0005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff02fb6001, account) }
        assertEq(keystore.getRootHash(refHash, account), refHash);
    }

    function testFuzz_initNonce(bytes32 refHash, address account, uint192 key) public view {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03140000, 1037618709268) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03140001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03140005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03146002, key) }
        assertEq(keystore.getNonce(refHash, account, key), 0 | uint256(key) << 64);
    }

    function testFuzz_registerNode(bytes32[] calldata nodes, uint256 index, bytes calldata node) public {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff030c0000, 1037618709260) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff030c0001, 5) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff030c0005, 13402) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff030c6103, node.offset) }
        vm.assume(node.length >= 20 && bytes20(node) != 0);

        (bytes32 refHash, bytes memory proof) = _generateUCMT(nodes, index, node);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00010018,0)}
        bytes32 nodeHash = keccak256(node);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000019,nodeHash)}
        assertEq(keystore.getRegisteredNode(refHash, address(this), nodeHash).length, 0);
        _registerNode(refHash, proof, node);
        assertGe(keystore.getRegisteredNode(refHash, address(this), nodeHash).length, 20);
    }

    function testFuzz_registerNodeWithMultipleRootHashUpdates(
        bytes32[] calldata nodes,
        bytes32[] calldata nextNodes,
        bytes32[] calldata finalNodes,
        uint256 index,
        bytes calldata nodeConfig,
        bytes calldata data
    ) public {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03050000, 1037618709253) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03050001, 11) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03050005, 3545044634) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03056109, data.offset) }
        vm.assume(nextNodes.length > 1 && index < nextNodes.length);
        vm.assume(finalNodes.length > 1 && index < finalNodes.length);
        MultiUpdateProps memory props = _generateAndAssertMultiUpdateProps(
            address(new VerifierMock(SIG_VALIDATION_SUCCESS)),
            address(new VerifierMock(SIG_VALIDATION_SUCCESS)),
            nodes,
            nextNodes,
            finalNodes,
            index,
            nodeConfig
        );assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0001001a,0)}

        // Registers a proof when rootHash == refHash
        bytes32 initNodeHash = keccak256(props.init.node);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0000001b,initNodeHash)}
        assertEq(keystore.getRegisteredNode(props.init.root, address(this), initNodeHash).length, 0);
        _registerNode(props.init.root, props.init.proof, props.init.node);
        assertGe(keystore.getRegisteredNode(props.init.root, address(this), initNodeHash).length, 20);

        // Update rootHash to nextHash
        // Node is included in the next UCMT so nextNode & nextData can be nil
        keystore.handleUpdates(
            _getUpdateActions(
                props.init.root, props.next.root, 0, "", bytes.concat(initNodeHash), data, props.next.proof, "", ""
            )
        );
        assertEq(keystore.getRegisteredNode(props.init.root, address(this), initNodeHash).length, 0);

        // Registers a proof when rootHash == nextHash
        _registerNode(props.init.root, props.next.proof, props.next.node);
        assertGe(keystore.getRegisteredNode(props.init.root, address(this), initNodeHash).length, 20);

        // Update rootHash to finalHash
        // Node is NOT included in the final UCMT so nextNode & nextData are required
        keystore.handleUpdates(
            _getUpdateActions(
                props.init.root,
                props.fin.root,
                1,
                "",
                bytes.concat(keccak256(props.next.node)),
                data,
                props.fin.proof,
                props.fin.node,
                data
            )
        );
        assertEq(keystore.getRegisteredNode(props.init.root, address(this), initNodeHash).length, 0);

        // Update rootHash back to refHash and cache state should follow
        keystore.handleUpdates(
            _getUpdateActions(
                props.init.root,
                props.init.root,
                2,
                props.fin.proof,
                props.fin.node,
                data,
                props.init.proof,
                props.init.node,
                data
            )
        );
        assertGe(keystore.getRegisteredNode(props.init.root, address(this), initNodeHash).length, 20);
    }

    function testFuzz_registerNodeWithInvalidNode(bytes32[] calldata nodes, uint256 index, bytes calldata node)
        public
    {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff02ff0000, 1037618709247) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff02ff0001, 5) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff02ff0005, 13402) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff02ff6103, node.offset) }
        vm.assume(node.length < 20);

        (bytes32 root, bytes memory proof) = _generateUCMT(nodes, index, node);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0001001c,0)}
        bytes32 nodeHash = keccak256(node);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0000001d,nodeHash)}
        assertEq(keystore.getRegisteredNode(root, address(this), nodeHash).length, 0);
        vm.expectRevert(IKeystore.InvalidNode.selector);
        _registerNode(root, proof, node);
        assertEq(keystore.getRegisteredNode(root, address(this), nodeHash).length, 0);
    }

    function testFuzz_registerNodeWithInvalidVerifier(bytes32[] calldata nodes, uint256 index) public {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03150000, 1037618709269) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03150001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03150005, 209) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03156002, index) }
        bytes memory node = abi.encode(address(0));assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0001001e,0)}

        (bytes32 root, bytes memory proof) = _generateUCMT(nodes, index, node);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0001001f,0)}
        bytes32 nodeHash = keccak256(node);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000020,nodeHash)}
        assertEq(keystore.getRegisteredNode(root, address(this), nodeHash).length, 0);
        vm.expectRevert(IKeystore.InvalidVerifier.selector);
        _registerNode(root, proof, node);
        assertEq(keystore.getRegisteredNode(root, address(this), nodeHash).length, 0);
    }

    function testFuzz_registerNodeWithInvalidProof(
        bytes32[] calldata nodes,
        bytes32[] calldata badProof,
        uint256 index,
        bytes calldata node
    ) public {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03090000, 1037618709257) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03090001, 7) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03090005, 865370) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03096105, node.offset) }
        vm.assume(node.length >= 20 && bytes20(node) != 0);

        (bytes32 root,) = _generateUCMT(nodes, index, node);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00010021,0)}
        bytes32 nodeHash = keccak256(node);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000022,nodeHash)}
        assertEq(keystore.getRegisteredNode(root, address(this), nodeHash).length, 0);
        vm.expectRevert(IKeystore.InvalidProof.selector);
        _registerNode(root, abi.encode(badProof), node);
        assertEq(keystore.getRegisteredNode(root, address(this), nodeHash).length, 0);
    }

    function testFuzz_validate(
        bytes32[] calldata nodes,
        uint256 index,
        bytes calldata nodeConfig,
        bytes32 message,
        bytes calldata data,
        uint256 validationData
    ) public {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff02f20000, 1037618709234) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff02f20001, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff02f20005, 54895313) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff02f26008, validationData) }
        address nodeVerifier = address(new VerifierMock(validationData));assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000023,nodeVerifier)}
        UCMTProps memory curr = _packNodeAndGenerateUCMT(nodes, index, nodeVerifier, nodeConfig);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00010024,0)}

        ValidateAction memory action =
            ValidateAction({refHash: curr.root, message: message, proof: curr.proof, node: curr.node, data: data});assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00010025,0)}
        assertEq(keystore.validate(action), validationData);
    }

    function testFuzz_validateRegisteredProof(
        bytes32[] calldata nodes,
        uint256 index,
        bytes calldata nodeConfig,
        bytes32 message,
        bytes calldata data,
        uint256 validationData
    ) public {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03070000, 1037618709255) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03070001, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03070005, 54895313) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03076008, validationData) }
        address nodeVerifier = address(new VerifierMock(validationData));assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000026,nodeVerifier)}
        UCMTProps memory curr = _packNodeAndGenerateUCMT(nodes, index, nodeVerifier, nodeConfig);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00010027,0)}
        _registerNode(curr.root, curr.proof, curr.node);

        ValidateAction memory action = ValidateAction({
            refHash: curr.root,
            message: message,
            proof: "",
            node: abi.encode(keccak256(curr.node)),
            data: data
        });assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00010028,0)}
        assertEq(keystore.validate(action), validationData);
    }

    function testFuzz_validateUnregisteredProof(
        bytes32[] calldata nodes,
        uint256 index,
        address nodeVerifier,
        bytes calldata nodeConfig,
        bytes32 message,
        bytes calldata data
    ) public {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff02fd0000, 1037618709245) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff02fd0001, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff02fd0005, 54834266) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff02fd6107, data.offset) }
        vm.assume(nodeVerifier != address(0));
        UCMTProps memory curr = _packNodeAndGenerateUCMT(nodes, index, nodeVerifier, nodeConfig);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00010029,0)}

        ValidateAction memory action =
            ValidateAction({refHash: curr.root, message: message, proof: "", node: curr.node, data: data});assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0001002a,0)}
        vm.expectRevert(IKeystore.UnregisteredProof.selector);
        keystore.validate(action);
    }

    function testFuzz_validateInvalidProof(
        bytes32 badRoot,
        bytes32[] calldata nodes,
        uint256 index,
        address nodeVerifier,
        bytes calldata nodeConfig,
        bytes32 message,
        bytes calldata data
    ) public {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff02f30000, 1037618709235) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff02f30001, 10) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff02f30005, 189051994) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff02f36108, data.offset) }
        vm.assume(nodeVerifier != address(0));
        UCMTProps memory curr = _packNodeAndGenerateUCMT(nodes, index, nodeVerifier, nodeConfig);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0001002b,0)}

        ValidateAction memory action =
            ValidateAction({refHash: badRoot, message: message, proof: curr.proof, node: curr.node, data: data});assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0001002c,0)}
        vm.expectRevert(IKeystore.InvalidProof.selector);
        keystore.validate(action);
    }

    function testFuzz_validateInvalidNode(
        bytes32[] calldata nodes,
        uint256 index,
        bytes calldata node,
        bytes32 message,
        bytes calldata data
    ) public {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03120000, 1037618709266) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03120001, 8) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03120005, 6861914) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03126106, data.offset) }
        vm.assume(node.length < 20);
        (bytes32 root, bytes memory proof) = _generateUCMT(nodes, index, node);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0001002d,0)}

        ValidateAction memory action =
            ValidateAction({refHash: root, message: message, proof: proof, node: node, data: data});assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0001002e,0)}
        vm.expectRevert(IKeystore.InvalidNode.selector);
        keystore.validate(action);
    }

    function testFuzz_validateInvalidVerifier(
        bytes32[] calldata nodes,
        uint256 index,
        bytes calldata nodeConfig,
        bytes32 message,
        bytes calldata data
    ) public {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03060000, 1037618709254) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03060001, 8) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03060005, 6861914) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03066106, data.offset) }
        address badVerifier = address(0);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0000002f,badVerifier)}
        UCMTProps memory curr = _packNodeAndGenerateUCMT(nodes, index, badVerifier, nodeConfig);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00010030,0)}

        ValidateAction memory action =
            ValidateAction({refHash: curr.root, message: message, proof: curr.proof, node: curr.node, data: data});assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00010031,0)}
        vm.expectRevert(IKeystore.InvalidVerifier.selector);
        keystore.validate(action);
    }

    function testFuzz_handleUpdates(
        uint192 nonceKey,
        bytes32[] calldata nodes,
        uint256 index,
        bytes calldata nodeConfig,
        bytes calldata data
    ) public {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03130000, 1037618709267) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03130001, 8) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03130005, 2954906) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03136106, data.offset) }
        address nodeVerifier = address(new VerifierMock(SIG_VALIDATION_SUCCESS));assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000032,nodeVerifier)}
        UpdateInputs memory inputs = _packNodeAndGetUpdateInputs(nonceKey, nodes, index, nodeVerifier, nodeConfig);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00010033,0)}

        vm.expectEmit();
        emit IKeystore.RootHashUpdated(inputs.refHash, address(this), inputs.nextHash, inputs.nonce, true);
        keystore.handleUpdates(
            _getUpdateActions(
                inputs.refHash, inputs.nextHash, inputs.nonce, inputs.proof, inputs.node, data, inputs.nextProof, "", ""
            )
        );

        assertEq(keystore.getNonce(inputs.refHash, address(this), nonceKey), 1 | uint256(nonceKey) << 64);
        assertEq(keystore.getRootHash(inputs.refHash, address(this)), inputs.nextHash);
    }

    function testFuzz_handleUpdatesNextValidation(
        uint192 nonceKey,
        bytes32[] calldata nodes,
        uint256 index,
        bytes calldata nodeConfig,
        bytes calldata data
    ) public {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03040000, 1037618709252) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03040001, 8) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03040005, 2954906) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03046106, data.offset) }
        address nodeVerifier = address(new VerifierMock(SIG_VALIDATION_SUCCESS));assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000034,nodeVerifier)}
        address nextNodeVerifier = address(new VerifierMock(SIG_VALIDATION_SUCCESS));assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000035,nextNodeVerifier)}
        UpdateInputs memory inputs = _packNodeAndGetUpdateInputsWithNextNodeVerifier(
            nonceKey, nodes, index, nodeVerifier, nextNodeVerifier, nodeConfig
        );assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00010036,0)}

        vm.expectEmit();
        emit IKeystore.RootHashUpdated(inputs.refHash, address(this), inputs.nextHash, inputs.nonce, true);
        keystore.handleUpdates(
            _getUpdateActions(
                inputs.refHash,
                inputs.nextHash,
                inputs.nonce,
                inputs.proof,
                inputs.node,
                data,
                inputs.nextProof,
                inputs.nextNode,
                data
            )
        );

        assertEq(keystore.getNonce(inputs.refHash, address(this), nonceKey), 1 | uint256(nonceKey) << 64);
        assertEq(keystore.getRootHash(inputs.refHash, address(this)), inputs.nextHash);
    }

    function testFuzz_handleUpdatesInvalidNonce(
        uint192 nonceKey,
        bytes32[] calldata nodes,
        uint256 index,
        address nodeVerifier,
        bytes calldata nodeConfig,
        bytes calldata data
    ) public {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff030e0000, 1037618709262) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff030e0001, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff030e0005, 23631514) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff030e6107, data.offset) }
        vm.assume(nodeVerifier != address(0));
        UpdateInputs memory inputs = _packNodeAndGetUpdateInputs(nonceKey, nodes, index, nodeVerifier, nodeConfig);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00010037,0)}

        vm.expectRevert(IKeystore.InvalidNonce.selector);
        keystore.handleUpdates(
            _getUpdateActions(
                inputs.refHash,
                inputs.nextHash,
                inputs.nonce + 1,
                inputs.proof,
                inputs.node,
                data,
                inputs.nextProof,
                "",
                ""
            )
        );

        assertEq(keystore.getNonce(inputs.refHash, address(this), nonceKey), 0 | uint256(nonceKey) << 64);
        assertEq(keystore.getRootHash(inputs.refHash, address(this)), inputs.refHash);
    }

    function testFuzz_handleUpdatesInvalidProof(
        uint192 nonceKey,
        bytes32[] calldata nodes,
        uint256 index,
        address nodeVerifier,
        bytes calldata nodeConfig,
        bytes calldata data
    ) public {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff030a0000, 1037618709258) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff030a0001, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff030a0005, 23631514) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff030a6107, data.offset) }
        vm.assume(nodeVerifier != address(0));
        UpdateInputs memory inputs = _packNodeAndGetUpdateInputs(nonceKey, nodes, index, nodeVerifier, nodeConfig);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00010038,0)}

        bytes32[] memory badProof = new bytes32[](1);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00010039,0)}
        badProof[0] = bytes32(0);bytes32 certora_local90 = badProof[0];assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0000005a,certora_local90)}
        inputs.proof = abi.encode(badProof);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0002005b,0)}
        vm.expectRevert(IKeystore.InvalidProof.selector);
        keystore.handleUpdates(
            _getUpdateActions(
                inputs.refHash, inputs.nextHash, inputs.nonce, inputs.proof, inputs.node, data, inputs.nextProof, "", ""
            )
        );

        assertEq(keystore.getNonce(inputs.refHash, address(this), nonceKey), 0 | uint256(nonceKey) << 64);
        assertEq(keystore.getRootHash(inputs.refHash, address(this)), inputs.refHash);
    }

    function testFuzz_handleUpdatesInvalidNode(
        uint192 nonceKey,
        bytes32[] calldata nodes,
        uint256 index,
        bytes calldata node,
        bytes calldata data
    ) public {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff02f40000, 1037618709236) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff02f40001, 8) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff02f40005, 2954906) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff02f46106, data.offset) }
        vm.assume(node.length < 20);
        UpdateInputs memory inputs = _getUpdateInputs(nonceKey, nodes, index, node);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0001003a,0)}

        vm.expectRevert(IKeystore.InvalidNode.selector);
        keystore.handleUpdates(
            _getUpdateActions(
                inputs.refHash, inputs.nextHash, inputs.nonce, inputs.proof, inputs.node, data, inputs.nextProof, "", ""
            )
        );

        assertEq(keystore.getNonce(inputs.refHash, address(this), nonceKey), 0 | uint256(nonceKey) << 64);
        assertEq(keystore.getRootHash(inputs.refHash, address(this)), inputs.refHash);
    }

    function testFuzz_handleUpdatesInvalidVerifier(
        uint192 nonceKey,
        bytes32[] calldata nodes,
        uint256 index,
        bytes calldata nodeConfig,
        bytes calldata data
    ) public {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03020000, 1037618709250) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03020001, 8) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03020005, 2954906) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03026106, data.offset) }
        UpdateInputs memory inputs = _packNodeAndGetUpdateInputs(nonceKey, nodes, index, address(0), nodeConfig);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0001003b,0)}

        vm.expectRevert(IKeystore.InvalidVerifier.selector);
        keystore.handleUpdates(
            _getUpdateActions(
                inputs.refHash, inputs.nextHash, inputs.nonce, inputs.proof, inputs.node, data, inputs.nextProof, "", ""
            )
        );

        assertEq(keystore.getNonce(inputs.refHash, address(this), nonceKey), 0 | uint256(nonceKey) << 64);
        assertEq(keystore.getRootHash(inputs.refHash, address(this)), inputs.refHash);
    }

    function testFuzz_handleUpdatesInvalidValidation(
        uint192 nonceKey,
        bytes32[] calldata nodes,
        uint256 index,
        bytes calldata nodeConfig,
        bytes calldata data
    ) public {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff02f10000, 1037618709233) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff02f10001, 8) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff02f10005, 2954906) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff02f16106, data.offset) }
        address nodeVerifier = address(new VerifierMock(SIG_VALIDATION_FAILED));assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0000003c,nodeVerifier)}
        UpdateInputs memory inputs = _packNodeAndGetUpdateInputs(nonceKey, nodes, index, nodeVerifier, nodeConfig);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0001003d,0)}

        vm.expectEmit();
        emit IKeystore.RootHashUpdated(inputs.refHash, address(this), inputs.nextHash, inputs.nonce, false);
        keystore.handleUpdates(
            _getUpdateActions(
                inputs.refHash, inputs.nextHash, inputs.nonce, inputs.proof, inputs.node, data, inputs.nextProof, "", ""
            )
        );

        assertEq(keystore.getNonce(inputs.refHash, address(this), nonceKey), 0 | uint256(nonceKey) << 64);
        assertEq(keystore.getRootHash(inputs.refHash, address(this)), inputs.refHash);
    }

    function testFuzz_handleUpdatesInvalidNextProofForReusedNode(
        uint192 nonceKey,
        bytes32[] calldata nodes,
        uint256 index,
        bytes calldata nodeConfig,
        bytes calldata data
    ) public {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff02fc0000, 1037618709244) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff02fc0001, 8) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff02fc0005, 2954906) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff02fc6106, data.offset) }
        address nodeVerifier = address(new VerifierMock(SIG_VALIDATION_SUCCESS));assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0000003e,nodeVerifier)}
        UpdateInputs memory inputs = _packNodeAndGetUpdateInputs(nonceKey, nodes, index, nodeVerifier, nodeConfig);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0001003f,0)}

        vm.expectRevert(IKeystore.InvalidNextProof.selector);
        keystore.handleUpdates(
            _getUpdateActions(
                inputs.refHash, inputs.nextHash, inputs.nonce, inputs.proof, inputs.node, data, inputs.proof, "", ""
            )
        );

        assertEq(keystore.getNonce(inputs.refHash, address(this), nonceKey), 0 | uint256(nonceKey) << 64);
        assertEq(keystore.getRootHash(inputs.refHash, address(this)), inputs.refHash);
    }

    function testFuzz_handleUpdatesInvalidNextProofForNewNode(
        uint192 nonceKey,
        bytes32[] calldata nodes,
        uint256 index,
        bytes calldata nodeConfig,
        bytes calldata data
    ) public {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff02fe0000, 1037618709246) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff02fe0001, 8) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff02fe0005, 2954906) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff02fe6106, data.offset) }
        address nodeVerifier = address(new VerifierMock(SIG_VALIDATION_SUCCESS));assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000040,nodeVerifier)}
        address nextNodeVerifier = address(new VerifierMock(SIG_VALIDATION_SUCCESS));assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000041,nextNodeVerifier)}
        UpdateInputs memory inputs = _packNodeAndGetUpdateInputsWithNextNodeVerifier(
            nonceKey, nodes, index, nodeVerifier, nextNodeVerifier, nodeConfig
        );assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00010042,0)}

        vm.expectRevert(IKeystore.InvalidNextProof.selector);
        keystore.handleUpdates(
            _getUpdateActions(
                inputs.refHash,
                inputs.nextHash,
                inputs.nonce,
                inputs.proof,
                inputs.node,
                data,
                inputs.proof,
                inputs.nextNode,
                data
            )
        );

        assertEq(keystore.getNonce(inputs.refHash, address(this), nonceKey), 0 | uint256(nonceKey) << 64);
        assertEq(keystore.getRootHash(inputs.refHash, address(this)), inputs.refHash);
    }

    function testFuzz_handleUpdatesInvalidNextNode(
        uint192 nonceKey,
        bytes32[] calldata nodes,
        uint256 index,
        bytes calldata nodeConfig,
        bytes calldata data,
        bytes calldata nextNode
    ) public {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff02fa0000, 1037618709242) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff02fa0001, 10) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff02fa0005, 189114010) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff02fa6108, nextNode.offset) }
        vm.assume(nextNode.length > 0 && nextNode.length < 20);
        UpdateInputs memory inputs = _packNodeAndGetUpdateInputsWithNextNode(
            nonceKey, nodes, index, address(new VerifierMock(SIG_VALIDATION_SUCCESS)), nodeConfig, nextNode
        );assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00010043,0)}

        vm.expectRevert(IKeystore.InvalidNode.selector);
        keystore.handleUpdates(
            _getUpdateActions(
                inputs.refHash,
                inputs.nextHash,
                inputs.nonce,
                inputs.proof,
                inputs.node,
                data,
                inputs.nextProof,
                inputs.nextNode,
                data
            )
        );

        assertEq(keystore.getNonce(inputs.refHash, address(this), nonceKey), 0 | uint256(nonceKey) << 64);
        assertEq(keystore.getRootHash(inputs.refHash, address(this)), inputs.refHash);
    }

    function testFuzz_handleUpdatesInvalidNextValidation(
        uint192 nonceKey,
        bytes32[] calldata nodes,
        uint256 index,
        bytes calldata nodeConfig,
        bytes calldata data
    ) public {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03100000, 1037618709264) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03100001, 8) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03100005, 2954906) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03106106, data.offset) }
        UpdateInputs memory inputs = _packNodeAndGetUpdateInputsWithNextNodeVerifier(
            nonceKey,
            nodes,
            index,
            address(new VerifierMock(SIG_VALIDATION_SUCCESS)), // node verifier
            address(new VerifierMock(SIG_VALIDATION_FAILED)), // next node verifier
            nodeConfig
        );assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00010044,0)}

        vm.expectEmit();
        emit IKeystore.RootHashUpdated(inputs.refHash, address(this), inputs.nextHash, inputs.nonce, false);
        keystore.handleUpdates(
            _getUpdateActions(
                inputs.refHash,
                inputs.nextHash,
                inputs.nonce,
                inputs.proof,
                inputs.node,
                data,
                inputs.nextProof,
                inputs.nextNode,
                data
            )
        );

        assertEq(keystore.getNonce(inputs.refHash, address(this), nonceKey), 0 | uint256(nonceKey) << 64);
        assertEq(keystore.getRootHash(inputs.refHash, address(this)), inputs.refHash);
    }

    function testFuzz_handleUpdatesBatch(bool[2] calldata status, bool useChainId) public {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03030000, 1037618709251) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03030001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03030005, 33) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03036001, useChainId) }
        UpdateAction[] memory actions = new UpdateAction[](2);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00010045,0)}

        actions[0] = UpdateAction({
            refHash: 0x0b0c5aafb3e9b932d414ae02f5e98357eae425e3648f7c7ac9b00b909de88050,
            nextHash: 0x50a73340dcc550ea7d740f05dfb274337e59b76adf642171ae85def8058de0ee,
            nonce: 37207976134154252492264189946807070066999296,
            useChainId: useChainId,
            account: address(this),
            proof: hex"00000000000000000000000000000000000000000000000000000000000000200000000000000000000000000000000000000000000000000000000000000006f1f7073eba3b359366b152f3276391cd9d9495f7a9944d4832c6f1bf244c1b90a7db15676f9941cea51d6caf720f3acd22ba25d61aa398b1f10a7d87c05e9b2490ae60fea9cb87fbad67179be8d3dfc6435a6beb240d7e9784b3f69032cdfb40920701ca778b55e38c90c86b93df6a2c7ba0a41a15ad2f5bef808136b2d8ba7506979888f65f6d18f1588e176bf6cfe767e3c4d1916b25e28ea79dedbf4a30decbe2c0b2ab0da8b30c59b2ede87aa84eee9b3325caabe55455d7cea70ce91580",
            node: hex"f62849f9a0b5bf2913b396098f7c7019b51a820a254e",
            data: hex"030e9cf6c36ad78513c19c871162828305a587b0d250b8f8e77b52e1de295858ea",
            nextProof: hex"00000000000000000000000000000000000000000000000000000000000000200000000000000000000000000000000000000000000000000000000000000006deadbeef0000000000000000000000000000000000000000000000000000000025319a35c0bb3a04f1302c6cfbcfc5865a68811cbc88e274ef905dafb8e8062b1f53c557ba9419171ace80e1993e31e5778af8c673b7045d2dfba760f841db0944d9d7c7490032557068f748dc770e5cef57a68b77456be5a10c163fb9e834fc80e96c5094b70c211030c57b3c4a1dd6b3392fba2213e93d9c0c2ca9d8ede5d8da6304fcf5b53497d6f5313225742afe45beb9e682a819e1ee0547f909fe8093",
            nextNode: "",
            nextData: ""
        });assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0002005c,0)}

        actions[1] = UpdateAction({
            refHash: 0xa5b085d3e5946c17752fcd954b3acc366126ee059aae083bb8035920f855a13e,
            nextHash: 0xf4e494131e88a45ea86945380962a15ca6106a393c6bf4c6ee01d11bf16e598f,
            nonce: 0,
            useChainId: useChainId,
            account: address(this),
            proof: hex"0000000000000000000000000000000000000000000000000000000000000020000000000000000000000000000000000000000000000000000000000000000877ecc67af61b68ff0569a4948a2392a1a3e67562446a9a817342e2538e79f0a329d07472a5aca4ca4ef8a35610251903d61f758a002720cd8d44767eea5242c13e4ab998e72c4b6cd9c585dec028b030e69a05a7bdcda6542e60dc27caccb6b2796b1ef3f077ec7a8fd18738287c828e7be04acd50e3b7eb6a2609b63e334a1635063be8fd01c17783629d9aaef50712f05b4669cfdfd2f7be101b9a17789b28e62337ee13497c0d58d8b309ce9801d02a58e6f512885aee862c552694b7a6d9674bb355ee62afe4036ff367a97cc49759d37124e0d794389b307e3ee4408b832aeb656df7e769074ab9c784123e491dc9d5bf6dca6a8f453c4c9debafa2e4fa",
            node: hex"f62849f9a0b5bf2913b396098f7c7019b51a820a04c4b72cf269ef43e4e73639e935b295af3c4626ca90354a035d0b70f78c4639ca8602ab12a541e2adabd6b0c970ba404edd8f682ba4daf4",
            data: hex"5566480da317068432200dd07ddf71f86aea334825144e4338121f20d2c3cc8c43b7776617677ce903d7f913116323eb6048a891",
            nextProof: hex"00000000000000000000000000000000000000000000000000000000000000200000000000000000000000000000000000000000000000000000000000000008deadbeef0000000000000000000000000000000000000000000000000000000025319a35c0bb3a04f1302c6cfbcfc5865a68811cbc88e274ef905dafb8e8062b1f53c557ba9419171ace80e1993e31e5778af8c673b7045d2dfba760f841db0944d9d7c7490032557068f748dc770e5cef57a68b77456be5a10c163fb9e834fc80e96c5094b70c211030c57b3c4a1dd6b3392fba2213e93d9c0c2ca9d8ede5d86040050af6e6bd7bd7e20142485887a175961535bb20853ca6087f750d6754908af8183849b20a7456ed353b1101caedb083ac153ee5c06183df46df129fd2ad4f01395c883311d68279323c4118819fb52f633a35b784607f3477172462484b",
            nextNode: "",
            nextData: ""
        });assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0002005d,0)}

        _mockVerifier(
            useChainId
                ? keccak256(
                    abi.encode(
                        actions[0].refHash,
                        actions[0].nextHash,
                        address(this),
                        actions[0].nonce,
                        keccak256(actions[0].node),
                        keccak256(actions[0].nextNode),
                        block.chainid
                    )
                )
                : keccak256(
                    abi.encode(
                        actions[0].refHash,
                        actions[0].nextHash,
                        address(this),
                        actions[0].nonce,
                        keccak256(actions[0].node),
                        keccak256(actions[0].nextNode)
                    )
                ),
            actions[0].node,
            actions[0].data,
            status[0] ? SIG_VALIDATION_SUCCESS : SIG_VALIDATION_FAILED
        );

        _mockVerifier(
            useChainId
                ? keccak256(
                    abi.encode(
                        actions[1].refHash,
                        actions[1].nextHash,
                        address(this),
                        actions[1].nonce,
                        keccak256(actions[1].node),
                        keccak256(actions[1].nextNode),
                        block.chainid
                    )
                )
                : keccak256(
                    abi.encode(
                        actions[1].refHash,
                        actions[1].nextHash,
                        address(this),
                        actions[1].nonce,
                        keccak256(actions[1].node),
                        keccak256(actions[1].nextNode)
                    )
                ),
            actions[1].node,
            actions[1].data,
            status[1] ? SIG_VALIDATION_SUCCESS : SIG_VALIDATION_FAILED
        );

        vm.expectEmit();
        emit IKeystore.RootHashUpdated(
            actions[0].refHash, address(this), actions[0].nextHash, actions[0].nonce, status[0]
        );

        vm.expectEmit();
        emit IKeystore.RootHashUpdated(
            actions[1].refHash, address(this), actions[1].nextHash, actions[1].nonce, status[1]
        );
        keystore.handleUpdates(actions);

        uint192 nonceKey0 = uint192(actions[0].nonce >> 64);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000046,nonceKey0)}
        uint192 nonceKey1 = uint192(actions[1].nonce >> 64);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000047,nonceKey1)}
        bytes32 currHash0 = status[0] ? actions[0].nextHash : actions[0].refHash;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000048,currHash0)}
        bytes32 currHash1 = status[1] ? actions[1].nextHash : actions[1].refHash;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000049,currHash1)}
        uint64 nonceSeq0 = status[0] ? 1 : 0;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0000004a,nonceSeq0)}
        uint64 nonceSeq1 = status[1] ? 1 : 0;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0000004b,nonceSeq1)}
        assertEq(keystore.getRootHash(actions[0].refHash, address(this)), currHash0);
        assertEq(keystore.getNonce(actions[0].refHash, address(this), nonceKey0), nonceSeq0 | uint256(nonceKey0) << 64);
        assertEq(keystore.getRootHash(actions[1].refHash, address(this)), currHash1);
        assertEq(keystore.getNonce(actions[1].refHash, address(this), nonceKey1), nonceSeq1 | uint256(nonceKey1) << 64);
    }

    // ================================================================
    // Helper functions
    // ================================================================

    function _registerNode(bytes32 refHash, bytes memory proof, bytes memory node) internal {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff02e60000, 1037618709222) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff02e60001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff02e60005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff02e66002, node) }
        (bytes32[] memory proofArray) = abi.decode(proof, (bytes32[]));assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0001004c,0)}
        keystore.registerNode(refHash, proofArray, node);
    }

    function _packNodeAndGenerateUCMT(
        bytes32[] calldata nodes,
        uint256 index,
        address nodeVerifier,
        bytes calldata nodeConfig
    ) internal view returns (UCMTProps memory curr) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff02e70000, 1037618709223) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff02e70001, 6) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff02e70005, 107098) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff02e76104, nodeConfig.offset) }
        vm.assume(nodes.length > 1);
        vm.assume(index < nodes.length);

        bytes32[] memory tree = nodes;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0001004d,0)}
        curr.node = abi.encodePacked(nodeVerifier, nodeConfig);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0002005e,0)}
        tree[index] = keccak256(curr.node);bytes32 certora_local95 = tree[index];assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0000005f,certora_local95)}
        curr.root = ucmt.getRoot(tree);bytes32 certora_local96 = curr.root;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000060,certora_local96)}
        curr.proof = abi.encode(ucmt.getProof(tree, index));assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00020061,0)}
    }

    function _generateUCMT(bytes32[] calldata nodes, uint256 index, bytes memory node)
        internal
        view
        returns (bytes32 root, bytes memory proof)
    {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff02e90000, 1037618709225) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff02e90001, 4) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff02e90005, 1673) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff02e96003, node) }
        vm.assume(nodes.length > 1);
        vm.assume(index < nodes.length);

        bytes32[] memory tree = nodes;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0001004e,0)}
        tree[index] = keccak256(node);bytes32 certora_local98 = tree[index];assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000062,certora_local98)}
        root = ucmt.getRoot(tree);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000063,root)}
        proof = abi.encode(ucmt.getProof(tree, index));assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00020064,0)}
    }

    function _generateNextUCMT(bytes32[] calldata nodes, uint256 index, bytes memory node)
        internal
        view
        returns (UCMTProps memory next)
    {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff02ea0000, 1037618709226) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff02ea0001, 4) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff02ea0005, 1673) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff02ea6003, node) }
        bytes32[] memory tree = nodes;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0001004f,0)}
        for (uint256 i = 0; i < nodes.length; i++) {
            if (i == index) {
                tree[i] = keccak256(node);
            } else {
                tree[i] = bytes32(hex"deadbeef");bytes32 certora_local138 = tree[i];assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0000008a,certora_local138)}
            }
        }
        next.root = ucmt.getRoot(tree);bytes32 certora_local101 = next.root;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000065,certora_local101)}
        next.proof = abi.encode(ucmt.getProof(tree, index));assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00020066,0)}
        next.node = node;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00020067,0)}
    }

    function _generateAndAssertMultiUpdateProps(
        address nodeVerifier,
        address finalNodeVerifier,
        bytes32[] calldata nodes,
        bytes32[] calldata nextNodes,
        bytes32[] calldata finalNodes,
        uint256 index,
        bytes calldata nodeConfig
    ) internal view returns (MultiUpdateProps memory props) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff02e80000, 1037618709224) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff02e80001, 11) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff02e80005, 1263350874) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff02e86109, nodeConfig.offset) }
        props.init = _packNodeAndGenerateUCMT(nodes, index, nodeVerifier, nodeConfig);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00020068,0)}
        props.next = _packNodeAndGenerateUCMT(nextNodes, index, nodeVerifier, nodeConfig);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00020069,0)}
        props.fin = _packNodeAndGenerateUCMT(finalNodes, index, finalNodeVerifier, nodeConfig);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0002006a,0)}
        assertNotEq(props.init.root, props.next.root);
        assertNotEq(props.next.root, props.fin.root);
        assertNotEq(props.init.proof, props.next.proof);
        assertNotEq(props.next.proof, props.fin.proof);
        assertEq(props.init.node, props.next.node);
        assertNotEq(props.next.node, props.fin.node);
    }

    function _packNodeAndGetUpdateInputsWithNextNode(
        uint192 nonceKey,
        bytes32[] calldata nodes,
        uint256 index,
        address nodeVerifier,
        bytes calldata nodeConfig,
        bytes calldata nextNode
    ) internal view returns (UpdateInputs memory updateInputs) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff02eb0000, 1037618709227) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff02eb0001, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff02eb0005, 23631514) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff02eb6107, nextNode.offset) }
        UCMTProps memory curr = _packNodeAndGenerateUCMT(nodes, index, nodeVerifier, nodeConfig);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00010050,0)}
        UCMTProps memory next = _generateNextUCMT(nodes, index, nextNode);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00010051,0)}

        updateInputs.refHash = curr.root;bytes32 certora_local107 = updateInputs.refHash;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0000006b,certora_local107)}
        updateInputs.proof = curr.proof;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0002006c,0)}
        updateInputs.node = curr.node;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0002006d,0)}
        updateInputs.nextHash = next.root;bytes32 certora_local110 = updateInputs.nextHash;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0000006e,certora_local110)}
        updateInputs.nextProof = next.proof;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0002006f,0)}
        updateInputs.nextNode = next.node;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00020070,0)}
        updateInputs.nonce = keystore.getNonce(curr.root, address(this), nonceKey);uint256 certora_local113 = updateInputs.nonce;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000071,certora_local113)}
        updateInputs.message = keccak256(
            abi.encode(
                curr.root, next.root, address(this), updateInputs.nonce, keccak256(curr.node), keccak256(next.node)
            )
        );bytes32 certora_local114 = updateInputs.message;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000072,certora_local114)}
    }

    function _packNodeAndGetUpdateInputsWithNextNodeVerifier(
        uint192 nonceKey,
        bytes32[] calldata nodes,
        uint256 index,
        address nodeVerifier,
        address nextNodeVerifier,
        bytes calldata nodeConfig
    ) internal view returns (UpdateInputs memory updateInputs) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff02ec0000, 1037618709228) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff02ec0001, 8) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff02ec0005, 2953818) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff02ec6106, nodeConfig.offset) }
        UCMTProps memory curr = _packNodeAndGenerateUCMT(nodes, index, nodeVerifier, nodeConfig);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00010052,0)}
        UCMTProps memory next = _generateNextUCMT(nodes, index, abi.encodePacked(nextNodeVerifier, nodeConfig));assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00010053,0)}

        updateInputs.refHash = curr.root;bytes32 certora_local115 = updateInputs.refHash;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000073,certora_local115)}
        updateInputs.proof = curr.proof;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00020074,0)}
        updateInputs.node = curr.node;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00020075,0)}
        updateInputs.nextHash = next.root;bytes32 certora_local118 = updateInputs.nextHash;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000076,certora_local118)}
        updateInputs.nextProof = next.proof;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00020077,0)}
        updateInputs.nextNode = next.node;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00020078,0)}
        updateInputs.nonce = keystore.getNonce(curr.root, address(this), nonceKey);uint256 certora_local121 = updateInputs.nonce;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000079,certora_local121)}
        updateInputs.message = keccak256(
            abi.encode(
                curr.root, next.root, address(this), updateInputs.nonce, keccak256(curr.node), keccak256(next.node)
            )
        );bytes32 certora_local122 = updateInputs.message;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0000007a,certora_local122)}
    }

    function _packNodeAndGetUpdateInputs(
        uint192 nonceKey,
        bytes32[] calldata nodes,
        uint256 index,
        address nodeVerifier,
        bytes calldata nodeConfig
    ) internal view returns (UpdateInputs memory updateInputs) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff02ed0000, 1037618709229) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff02ed0001, 7) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff02ed0005, 369242) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff02ed6105, nodeConfig.offset) }
        UCMTProps memory curr = _packNodeAndGenerateUCMT(nodes, index, nodeVerifier, nodeConfig);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00010054,0)}
        UCMTProps memory next = _generateNextUCMT(nodes, index, curr.node);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00010055,0)}

        updateInputs.refHash = curr.root;bytes32 certora_local123 = updateInputs.refHash;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0000007b,certora_local123)}
        updateInputs.proof = curr.proof;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0002007c,0)}
        updateInputs.node = curr.node;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0002007d,0)}
        updateInputs.nextHash = next.root;bytes32 certora_local126 = updateInputs.nextHash;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0000007e,certora_local126)}
        updateInputs.nextProof = next.proof;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0002007f,0)}
        updateInputs.nonce = keystore.getNonce(curr.root, address(this), nonceKey);uint256 certora_local128 = updateInputs.nonce;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000080,certora_local128)}
        updateInputs.message = keccak256(
            abi.encode(
                curr.root, next.root, address(this), updateInputs.nonce, keccak256(curr.node), keccak256(next.node)
            )
        );bytes32 certora_local129 = updateInputs.message;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000081,certora_local129)}
    }

    function _getUpdateInputs(uint192 nonceKey, bytes32[] calldata nodes, uint256 index, bytes memory node)
        internal
        view
        returns (UpdateInputs memory updateInputs)
    {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff02ee0000, 1037618709230) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff02ee0001, 5) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff02ee0005, 5769) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff02ee6004, node) }
        (bytes32 root, bytes memory proof) = _generateUCMT(nodes, index, node);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00010056,0)}
        UCMTProps memory next = _generateNextUCMT(nodes, index, node);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00010057,0)}

        updateInputs.refHash = root;bytes32 certora_local130 = updateInputs.refHash;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000082,certora_local130)}
        updateInputs.proof = proof;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00020083,0)}
        updateInputs.node = node;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00020084,0)}
        updateInputs.nextHash = next.root;bytes32 certora_local133 = updateInputs.nextHash;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000085,certora_local133)}
        updateInputs.nextProof = next.proof;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00020086,0)}
        updateInputs.nonce = keystore.getNonce(root, address(this), nonceKey);uint256 certora_local135 = updateInputs.nonce;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000087,certora_local135)}
        updateInputs.message = keccak256(
            abi.encode(root, next.root, address(this), updateInputs.nonce, keccak256(node), keccak256(next.node))
        );bytes32 certora_local136 = updateInputs.message;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000088,certora_local136)}
    }

    function _getUpdateActions(
        bytes32 refHash,
        bytes32 nextHash,
        uint256 nonce,
        bytes memory proof,
        bytes memory node,
        bytes memory data,
        bytes memory nextProof,
        bytes memory nextNode,
        bytes memory nextData
    ) internal view returns (UpdateAction[] memory) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff02ef0000, 1037618709231) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff02ef0001, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff02ef0005, 19173961) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff02ef6008, nextData) }
        UpdateAction[] memory actions = new UpdateAction[](1);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00010058,0)}
        UpdateAction memory action = UpdateAction({
            refHash: refHash,
            nextHash: nextHash,
            nonce: nonce,
            useChainId: false,
            account: address(this),
            proof: proof,
            node: node,
            data: data,
            nextProof: nextProof,
            nextNode: nextNode,
            nextData: nextData
        });assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00010059,0)}
        actions[0] = action;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00020089,0)}
        return actions;
    }

    function _mockVerifier(bytes32 message, bytes memory node, bytes memory data, uint256 validationData) internal {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff02f00000, 1037618709232) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff02f00001, 4) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff02f00005, 585) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff02f06003, validationData) }
        vm.mockCall(
            address(bytes20(node)),
            abi.encodeWithSelector(
                IVerifier.validateData.selector, message, data, LibBytes.slice(node, 20, node.length)
            ),
            abi.encodePacked(validationData)
        );
    }
}
