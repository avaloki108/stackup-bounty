// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import {SIG_VALIDATION_FAILED, SIG_VALIDATION_SUCCESS} from "account-abstraction/core/Helpers.sol";
import {PackedUserOperation} from "account-abstraction/interfaces/PackedUserOperation.sol";
import {Test} from "forge-std/Test.sol";
import {ECDSA} from "solady/utils/ECDSA.sol";

import {OnlyKeystore} from "../../src/lib/OnlyKeystore.sol";
import {UserOpECDSAVerifier} from "../../src/verifier/UserOpECDSAVerifier.sol";

contract UserOpECDSAVerifierTest is Test {
    UserOpECDSAVerifier public verifier;

    function setUp() public {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09170000, 1037618710807) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09170001, 0) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09170004, 0) }
        verifier = new UserOpECDSAVerifier(address(this));
    }

    function testFuzz_validateData(bool withUserOp) public {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09120000, 1037618710802) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09120001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09120005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09126000, withUserOp) }
        (address signer, uint256 signerPK) = makeAddrAndKey("signer");assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00010002,0)}
        bytes32 message = keccak256("Signed by signer");assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000003,message)}
        (uint8 v, bytes32 r, bytes32 s) = vm.sign(signerPK, ECDSA.toEthSignedMessageHash(message));assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00010004,0)}

        bytes memory data = abi.encodePacked(r, s, v);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00010005,0)}
        if (withUserOp) {
            PackedUserOperation memory userOp;
            userOp.signature = abi.encodePacked(r, s, v);
            data = abi.encode(userOp);
        }

        uint256 validationData = verifier.validateData(message, data, abi.encodePacked(signer));assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000006,validationData)}
        assertEq(validationData, SIG_VALIDATION_SUCCESS);
    }

    function testFuzz_validateDataValidationFailed(bool withUserOp, address config) public {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09100000, 1037618710800) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09100001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09100005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09106001, config) }
        (, uint256 signerPK) = makeAddrAndKey("signer");assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00010007,0)}
        bytes32 message = keccak256("Signed by signer");assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000008,message)}
        (uint8 v, bytes32 r, bytes32 s) = vm.sign(signerPK, ECDSA.toEthSignedMessageHash(message));assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00010009,0)}

        bytes memory data = abi.encodePacked(r, s, v);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0001000a,0)}
        if (withUserOp) {
            PackedUserOperation memory userOp;
            userOp.signature = abi.encodePacked(r, s, v);
            data = abi.encode(userOp);
        }

        uint256 validationData = verifier.validateData(message, data, abi.encodePacked(config));assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0000000b,validationData)}
        assertEq(validationData, SIG_VALIDATION_FAILED);
    }

    function testFuzz_validateDataInvalidCaller(address keystore) public {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff091b0000, 1037618710811) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff091b0001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff091b0005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff091b6000, keystore) }
        vm.assume(keystore != address(this));
        vm.prank(keystore);
        vm.expectRevert(OnlyKeystore.NotFromKeystore.selector);
        verifier.validateData(0, "", "");
    }

    function testFuzz_validateDataInvalidData(bytes calldata data) public {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff091d0000, 1037618710813) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff091d0001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff091d0005, 26) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff091d6100, data.offset) }
        vm.assume(data.length < 64);
        vm.expectRevert(ECDSA.InvalidSignature.selector);
        verifier.validateData(0, data, "");
    }
}
