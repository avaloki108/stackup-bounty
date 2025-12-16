// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import {SIG_VALIDATION_FAILED} from "account-abstraction/core/Helpers.sol";
import {EntryPoint} from "account-abstraction/core/EntryPoint.sol";
import {IAccount} from "account-abstraction/interfaces/IAccount.sol";
import {IEntryPoint} from "account-abstraction/interfaces/IEntryPoint.sol";
import {IStakeManager} from "account-abstraction/interfaces/IStakeManager.sol";
import {PackedUserOperation} from "account-abstraction/interfaces/PackedUserOperation.sol";
import {Test} from "forge-std/Test.sol";

import {ERC7739PersonalSignVerifierMock} from "../mock/ERC7739PersonalSignVerifierMock.sol";
import {ERC7739TypedDataSignVerifierMock} from "../mock/ERC7739TypedDataSignVerifierMock.sol";
import {VerifierMock} from "../mock/VerifierMock.sol";
import {KeystoreAccount} from "../../src/account/KeystoreAccount.sol";
import {KeystoreAccountFactory} from "../../src/account/KeystoreAccountFactory.sol";
import {Keystore} from "../../src/core/Keystore.sol";
import {IKeystore} from "../../src/interface/IKeystore.sol";

contract KeystoreAccountFactoryTest is Test {
    EntryPoint public entryPoint;
    Keystore public keystore;
    KeystoreAccountFactory public factory;

    function setUp() public {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00270000, 1037618708519) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00270001, 0) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00270004, 0) }
        entryPoint = new EntryPoint();
        keystore = new Keystore();
        factory = new KeystoreAccountFactory(entryPoint, keystore);
    }

    function testFuzz_keystoreAccountInitialized(bytes32 refHash) public {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff001d0000, 1037618708509) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff001d0001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff001d0005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff001d6000, refHash) }
        vm.expectEmit();
        emit KeystoreAccount.KeystoreAccountInitialized(entryPoint, keystore, refHash);
        _createAccount(refHash);
    }

    function testFuzz_entryPoint(bytes32 refHash) public {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff002f0000, 1037618708527) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff002f0001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff002f0005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff002f6000, refHash) }
        KeystoreAccount account = _createAccount(refHash);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0001000e,0)}
        assertEq(address(account.entryPoint()), address(entryPoint));
    }

    function testFuzz_keystore(bytes32 refHash) public {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff001f0000, 1037618708511) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff001f0001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff001f0005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff001f6000, refHash) }
        KeystoreAccount account = _createAccount(refHash);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0001000f,0)}
        assertEq(address(account.keystore()), address(keystore));
    }

    function testFuzz_ERC7739SupportDetection(bytes32 refHash) public {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00240000, 1037618708516) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00240001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00240005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00246000, refHash) }
        KeystoreAccount account = _createAccount(refHash);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00010010,0)}
        assertEq(
            account.isValidSignature(0x7739773977397739773977397739773977397739773977397739773977397739, ""),
            bytes4(0x77390001)
        );
    }

    function test_erc1271SignerReverts() public {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff002e0000, 1037618708526) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff002e0001, 0) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff002e0004, 0) }
        KeystoreAccountHarness acc = new KeystoreAccountHarness(entryPoint, keystore);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00010011,0)}
        vm.expectRevert(KeystoreAccount.ERC1271SignerUnused.selector);
        acc.expose_erc1271Signer();
    }

    function testFuzz_isValidSignatureSuccess(bytes32 message, uint256 validationData, bytes calldata data) public {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00300000, 1037618708528) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00300001, 4) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00300005, 602) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00306102, data.offset) }
        vm.assume(validationData != SIG_VALIDATION_FAILED);
        bytes memory node = abi.encodePacked(address(new VerifierMock(validationData)));assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00010012,0)}
        (bytes32 root, bytes memory proof) = _generateUCMT(node);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00010013,0)}
        bytes memory signature = abi.encode(proof, node, data);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00010014,0)}

        KeystoreAccount account = _createAccount(root);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00010015,0)}
        assertEq(account.isValidSignature(message, signature), bytes4(0x1626ba7e));
    }

    function testFuzz_isValidSignaturePersonalSignRehash(bytes32 message) public {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00230000, 1037618708515) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00230001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00230005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00236000, message) }
        bytes memory node = abi.encodePacked(address(new ERC7739PersonalSignVerifierMock(message)));assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00010016,0)}
        (bytes32 root, bytes memory proof) = _generateUCMT(node);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00010017,0)}

        KeystoreAccount account = _createAccount(root);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00010018,0)}
        bytes memory data = bytes.concat(bytes20(address(account)));assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00010019,0)}
        bytes memory signature = abi.encodePacked(abi.encode(proof, node, data));assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0001001a,0)}

        assertEq(account.isValidSignature(message, signature), bytes4(0x1626ba7e));
    }

    function testFuzz_isValidSignatureTypedDataSignRehash(bytes32 appDomainSeparator, bytes32 contents) public {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00200000, 1037618708512) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00200001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00200005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00206001, contents) }
        ERC7739TypedDataSignVerifierMock verifier = new ERC7739TypedDataSignVerifierMock(appDomainSeparator, contents);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0001001b,0)}
        bytes memory node = abi.encodePacked(address(verifier));assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0001001c,0)}
        (bytes32 root, bytes memory proof) = _generateUCMT(node);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0001001d,0)}

        KeystoreAccount account = _createAccount(root);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0001001e,0)}
        bytes32 typedMessage = keccak256(abi.encodePacked(hex"1901", appDomainSeparator, contents));assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0000001f,typedMessage)}
        bytes memory data = bytes.concat(bytes20(address(account)));assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00010020,0)}
        bytes memory typedSignature = abi.encodePacked(
            abi.encode(proof, node, data), // original signature
            appDomainSeparator,
            contents,
            bytes(verifier.implicitContentsDesc()),
            uint16(bytes(verifier.implicitContentsDesc()).length)
        );assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00010021,0)}

        assertEq(account.isValidSignature(typedMessage, typedSignature), bytes4(0x1626ba7e));
    }

    function testFuzz_isValidSignatureFailed(bytes32 message, bytes calldata data) public {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00280000, 1037618708520) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00280001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00280005, 90) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00286101, data.offset) }
        // Use a non-zero gas price to ensure Solady's ERC1271 contract skips the
        // gas burn.
        vm.txGasPrice(1);

        bytes memory node = abi.encodePacked(address(new VerifierMock(SIG_VALIDATION_FAILED)));assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00010022,0)}
        (bytes32 root, bytes memory proof) = _generateUCMT(node);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00010023,0)}
        bytes memory signature = abi.encode(proof, node, data);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00010024,0)}

        KeystoreAccount account = _createAccount(root);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00010025,0)}
        assertEq(account.isValidSignature(message, signature), bytes4(0xffffffff));
    }

    function testFuzz_validateUserOp(
        bytes32 message,
        uint256 missingAccountFunds,
        uint256 validationData,
        bytes calldata data
    ) public {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff001e0000, 1037618708510) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff001e0001, 5) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff001e0005, 4698) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff001e6103, data.offset) }
        bytes memory node = abi.encodePacked(address(new VerifierMock(validationData)));assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00010026,0)}
        (bytes32 root, bytes memory proof) = _generateUCMT(node);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00010027,0)}
        PackedUserOperation memory userOp;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00010028,0)}
        userOp.signature = abi.encode(proof, node, data);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0002002c,0)}

        IAccount account = _createAccount(root);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00010029,0)}

        // Initial validation with proof registration
        vm.deal(address(account), missingAccountFunds);
        vm.prank(address(entryPoint));
        assertEq(account.validateUserOp(userOp, message, missingAccountFunds), validationData);

        // Subsequent validation with registered proof
        vm.deal(address(account), missingAccountFunds);
        userOp.signature = abi.encode("", abi.encode(keccak256(node)), data);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0002002d,0)}
        vm.prank(address(entryPoint));
        assertEq(account.validateUserOp(userOp, message, missingAccountFunds), validationData);
    }

    function testFuzz_deposit(bytes32 refHash, uint256 value) public {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff002b0000, 1037618708523) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff002b0001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff002b0005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff002b6001, value) }
        vm.deal(address(this), value);
        KeystoreAccount account = _createAccount(refHash);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0001002a,0)}

        assertEq(address(account).balance, 0);
        assertEq(account.getDeposit(), 0);

        account.addDeposit{value: value}();
        assertEq(address(account).balance, 0);
        assertEq(account.getDeposit(), value);

        vm.prank(address(entryPoint));
        account.withdrawDepositTo(payable(account), value);
        assertEq(address(account).balance, value);
        assertEq(account.getDeposit(), 0);
    }

    // ================================================================
    // Helper functions
    // ================================================================

    function _createAccount(bytes32 refHash) internal returns (KeystoreAccount) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00180000, 1037618708504) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00180001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00180005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00186000, refHash) }
        vm.prank(address(entryPoint.senderCreator()));
        return factory.createAccount(refHash, 0);
    }

    function _generateUCMT(bytes memory node) internal pure returns (bytes32 root, bytes memory proof) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00190000, 1037618708505) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00190001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00190005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00196000, node) }
        bytes32[] memory proofArray = new bytes32[](0);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0001002b,0)}
        root = keccak256(node);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0000002e,root)}
        proof = abi.encode(proofArray);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0002002f,0)}
    }
}

contract KeystoreAccountHarness is KeystoreAccount {
    constructor(IEntryPoint e, IKeystore k) KeystoreAccount(e, k) {}

    function expose_erc1271Signer() external pure returns (address) {
        return _erc1271Signer();
    }
}
