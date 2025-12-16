// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import {SIG_VALIDATION_FAILED, SIG_VALIDATION_SUCCESS} from "account-abstraction/core/Helpers.sol";
import {PackedUserOperation} from "account-abstraction/interfaces/PackedUserOperation.sol";
import {Test} from "forge-std/Test.sol";
import {ECDSA} from "solady/utils/ECDSA.sol";
import {LibString} from "solady/utils/LibString.sol";

import {OnlyKeystore} from "../../src/lib/OnlyKeystore.sol";
import {UserOpMultiSigVerifier} from "../../src/verifier/UserOpMultiSigVerifier.sol";

contract UserOpMultiSigVerifierTest is Test {
    UserOpMultiSigVerifier public verifier;

    struct Signer {
        address addr;
        uint256 pk;
    }

    function setUp() public {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a680000, 1037618711144) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a680001, 0) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a680004, 0) }
        verifier = new UserOpMultiSigVerifier(address(this));
    }

    function testFuzz_validateData(bool withUserOp, uint8 threshold, uint8 offset, uint8 size) public {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a6a0000, 1037618711146) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a6a0001, 4) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a6a0005, 585) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a6a6003, size) }
        _assume(threshold, offset, size);
        Signer[] memory signers = _createSigners(size);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0001000c,0)}

        bytes32 message = keccak256("Signed by signer");assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0000000d,message)}
        bytes memory data = _createData(message, threshold, offset, signers);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0001000e,0)}
        if (withUserOp) {
            PackedUserOperation memory userOp;
            userOp.signature = data;
            data = abi.encode(userOp);
        } else {
            data = abi.encodePacked(verifier.SIGNATURES_ONLY_TAG(), data);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00020048,0)}
        }

        bytes memory config = _createConfig(threshold, signers);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0001000f,0)}

        uint256 validationData = verifier.validateData(message, data, config);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000010,validationData)}
        assertEq(validationData, SIG_VALIDATION_SUCCESS);
    }

    function testFuzz_validateDataValidationFailed(bool withUserOp, uint8 threshold, uint8 offset, uint8 size) public {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a5b0000, 1037618711131) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a5b0001, 4) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a5b0005, 585) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a5b6003, size) }
        _assume(threshold, offset, size);
        Signer[] memory signers = _createSigners(size);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00010011,0)}

        bytes32 message = keccak256("Signed by signer");assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000012,message)}
        bytes memory data = _createData(message, threshold - 1, offset, signers);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00010013,0)}
        if (withUserOp) {
            PackedUserOperation memory userOp;
            userOp.signature = data;
            data = abi.encode(userOp);
        } else {
            data = abi.encodePacked(verifier.SIGNATURES_ONLY_TAG(), data);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00020049,0)}
        }

        bytes memory config = _createConfig(threshold, signers);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00010014,0)}

        uint256 validationData = verifier.validateData(message, data, config);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000015,validationData)}
        assertEq(validationData, SIG_VALIDATION_FAILED);
    }

    function testFuzz_validateDataZeroThreshold(bool withUserOp, uint8 offset, uint8 size) public {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a5f0000, 1037618711135) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a5f0001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a5f0005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a5f6002, size) }
        uint8 threshold = 0;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000016,threshold)}
        Signer[] memory signers = _createSigners(size);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00010017,0)}

        bytes32 message = keccak256("Signed by signer");assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000018,message)}
        bytes memory data = _createData(message, threshold, offset, signers);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00010019,0)}
        if (withUserOp) {
            PackedUserOperation memory userOp;
            userOp.signature = data;
            data = abi.encode(userOp);
        } else {
            data = abi.encodePacked(verifier.SIGNATURES_ONLY_TAG(), data);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0002004a,0)}
        }

        bytes memory config = _createConfig(threshold, signers);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0001001a,0)}

        vm.expectRevert(UserOpMultiSigVerifier.ZeroThresholdNotAllowed.selector);
        verifier.validateData(message, data, config);
    }

    function testFuzz_validateDataMinOwners(bool withUserOp, uint8 threshold, uint8 size) public {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a610000, 1037618711137) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a610001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a610005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a616002, size) }
        vm.assume(threshold > 0 && size < threshold);
        Signer[] memory signers = _createSigners(size);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0001001b,0)}

        bytes32 message = keccak256("Signed by signer");assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0000001c,message)}
        bytes memory data = _createData(message, size, 0, signers);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0001001d,0)}
        if (withUserOp) {
            PackedUserOperation memory userOp;
            userOp.signature = data;
            data = abi.encode(userOp);
        } else {
            data = abi.encodePacked(verifier.SIGNATURES_ONLY_TAG(), data);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0002004b,0)}
        }

        bytes memory config = _createConfig(threshold, signers);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0001001e,0)}

        vm.expectRevert(UserOpMultiSigVerifier.InvalidNumberOfOwners.selector);
        verifier.validateData(message, data, config);
    }

    function testFuzz_validateDataMaxOwners(bool withUserOp, uint8 threshold, uint8 offset, uint8 excess) public {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a5e0000, 1037618711134) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a5e0001, 4) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a5e0005, 585) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a5e6003, excess) }
        uint16 size = _getSizeAndAssumeMaxOwnerLimitExceeded(threshold, offset, excess);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0000001f,size)}
        Signer[] memory signers = _createSigners(size);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00010020,0)}

        bytes32 message = keccak256("Signed by signer");assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000021,message)}
        bytes memory data = _createData(message, threshold, offset, signers);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00010022,0)}
        if (withUserOp) {
            PackedUserOperation memory userOp;
            userOp.signature = data;
            data = abi.encode(userOp);
        } else {
            data = abi.encodePacked(verifier.SIGNATURES_ONLY_TAG(), data);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0002004c,0)}
        }

        bytes memory config = _createConfig(threshold, signers);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00010023,0)}

        vm.expectRevert(UserOpMultiSigVerifier.InvalidNumberOfOwners.selector);
        verifier.validateData(message, data, config);
    }

    function testFuzz_validateDataIncorrectlySortedOwners(bool withUserOp, uint8 threshold, uint8 offset, uint8 size)
        public
    {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a570000, 1037618711127) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a570001, 4) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a570005, 585) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a576003, size) }
        vm.assume(size > 1);
        _assume(threshold, offset, size);
        Signer[] memory signers = _createSignersReverse(size);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00010024,0)}

        bytes32 message = keccak256("Signed by signer");assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000025,message)}
        bytes memory data = _createData(message, threshold, offset, signers);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00010026,0)}
        if (withUserOp) {
            PackedUserOperation memory userOp;
            userOp.signature = data;
            data = abi.encode(userOp);
        } else {
            data = abi.encodePacked(verifier.SIGNATURES_ONLY_TAG(), data);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0002004d,0)}
        }

        bytes memory config = _createConfig(threshold, signers);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00010027,0)}

        vm.expectRevert(UserOpMultiSigVerifier.OwnersUnsortedOrHasDuplicates.selector);
        verifier.validateData(message, data, config);
    }

    function testFuzz_validateDataDuplicateOwners(bool withUserOp, uint8 threshold, uint8 offset, uint8 size) public {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a660000, 1037618711142) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a660001, 4) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a660005, 585) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a666003, size) }
        vm.assume(threshold > 1);
        _assume(threshold, offset, size);

        (address addr, uint256 pk) = makeAddrAndKey("duplicate");assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00010028,0)}
        Signer[] memory signers = new Signer[](size);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00010029,0)}
        for (uint8 i = 0; i < size; i++) {
            signers[i] = Signer({addr: addr, pk: pk});assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0002004e,0)}
        }

        bytes32 message = keccak256("Signed by signer");assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0000002a,message)}
        bytes memory data = _createData(message, threshold, offset, signers);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0001002b,0)}
        if (withUserOp) {
            PackedUserOperation memory userOp;
            userOp.signature = data;
            data = abi.encode(userOp);
        } else {
            data = abi.encodePacked(verifier.SIGNATURES_ONLY_TAG(), data);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0002004f,0)}
        }

        bytes memory config = _createConfig(threshold, signers);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0001002c,0)}

        vm.expectRevert(UserOpMultiSigVerifier.OwnersUnsortedOrHasDuplicates.selector);
        verifier.validateData(message, data, config);
    }

    function testFuzz_validateDataDuplicateSignatures(
        bool withUserOp,
        uint8 threshold,
        uint8 offset,
        uint8 size,
        uint8 dup
    ) public {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a620000, 1037618711138) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a620001, 5) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a620005, 4681) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a626004, dup) }
        // Note: set threshold > 1 to show we can't recycle the same signature
        // multiple times.
        vm.assume(threshold > 1 && dup > 1 && dup <= threshold);
        _assume(threshold, offset, size);
        Signer[] memory signers = _createSigners(size);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0001002d,0)}

        bytes32 message = keccak256("Signed by signer");assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0000002e,message)}
        bytes memory data = _createData(message, threshold, offset, signers);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0001002f,0)}
        UserOpMultiSigVerifier.SignerData[] memory sd = abi.decode(data, (UserOpMultiSigVerifier.SignerData[]));assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00010030,0)}
        for (uint8 i; i < dup; i++) {
            sd[i] = sd[0];assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00020050,0)}
        }
        data = abi.encode(sd);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00020042,0)}
        if (withUserOp) {
            PackedUserOperation memory userOp;
            userOp.signature = data;
            data = abi.encode(userOp);
        } else {
            data = abi.encodePacked(verifier.SIGNATURES_ONLY_TAG(), data);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00020051,0)}
        }

        bytes memory config = _createConfig(threshold, signers);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00010031,0)}

        uint256 validationData = verifier.validateData(message, data, config);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000032,validationData)}
        assertEq(validationData, SIG_VALIDATION_FAILED);
    }

    function testFuzz_validateDataMaxSignatures(bool withUserOp, uint8 excess) public {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a580000, 1037618711128) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a580001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a580005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a586001, excess) }
        vm.assume(excess > 0);

        Signer[] memory signers = _createSigners(1);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00010033,0)}
        bytes32 message = keccak256("Signed by signer");assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000034,message)}
        (uint8 v, bytes32 r, bytes32 s) = vm.sign(signers[0].pk, ECDSA.toEthSignedMessageHash(message));assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00010035,0)}
        bytes memory signature = abi.encodePacked(r, s, v);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00010036,0)}

        uint16 count = uint16(type(uint8).max) + excess;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000037,count)}
        UserOpMultiSigVerifier.SignerData[] memory sd = new UserOpMultiSigVerifier.SignerData[](count);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00010038,0)}
        for (uint16 i = 0; i < count; i++) {
            sd[i] = UserOpMultiSigVerifier.SignerData({
                // Note: index will overflow back to 0 after max uint8.
                // This is ok since a MaxSignaturesExceeded() error is expected.
                index: 0,
                signature: signature
            });assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00020052,0)}
        }

        bytes memory data = abi.encode(sd);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00010039,0)}
        if (withUserOp) {
            PackedUserOperation memory userOp;
            userOp.signature = data;
            data = abi.encode(userOp);
        } else {
            data = abi.encodePacked(verifier.SIGNATURES_ONLY_TAG(), data);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00020053,0)}
        }

        bytes memory config = _createConfig(1, signers);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0001003a,0)}

        vm.expectRevert(UserOpMultiSigVerifier.MaxSignaturesExceeded.selector);
        verifier.validateData(message, data, config);
    }

    function testFuzz_validateDataInvalidCaller(address keystore) public {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a6c0000, 1037618711148) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a6c0001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a6c0005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a6c6000, keystore) }
        vm.assume(keystore != address(this));
        vm.prank(keystore);
        vm.expectRevert(OnlyKeystore.NotFromKeystore.selector);
        verifier.validateData(0, "", "");
    }

    function testFuzz_validateDataInvalidData(bytes calldata data) public {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a630000, 1037618711139) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a630001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a630005, 26) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a636100, data.offset) }
        vm.expectRevert();
        verifier.validateData(0, data, "");
    }

    // ================================================================
    // Helper functions
    // ================================================================

    function _assume(uint8 threshold, uint8 offset, uint8 size) internal pure {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a4f0000, 1037618711119) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a4f0001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a4f0005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a4f6002, size) }
        vm.assume(threshold > 0 && size > 0 && threshold <= size);
        vm.assume(uint16(threshold) + uint16(offset) <= size);
    }

    function _getSizeAndAssumeMaxOwnerLimitExceeded(uint8 threshold, uint8 offset, uint8 excess)
        internal
        pure
        returns (uint16 size)
    {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a500000, 1037618711120) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a500001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a500005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a506002, excess) }
        size = uint16(type(uint8).max) + excess;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000043,size)}
        vm.assume(threshold > 0 && excess > 0);
        vm.assume(uint16(threshold) + uint16(offset) <= size);
    }

    function _createSigners(uint16 size) internal returns (Signer[] memory) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a520000, 1037618711122) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a520001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a520005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a526000, size) }
        Signer[] memory signers = new Signer[](size);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0001003b,0)}
        for (uint16 i = 0; i < size; i++) {
            (address addr, uint256 pk) = makeAddrAndKey(LibString.toString(i));assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00010044,0)}
            signers[i] = Signer({addr: addr, pk: pk});assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00020054,0)}
        }
        _quickSortSigners(signers, true);
        return signers;
    }

    function _createSignersReverse(uint16 size) internal returns (Signer[] memory) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a530000, 1037618711123) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a530001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a530005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a536000, size) }
        Signer[] memory signers = new Signer[](size);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0001003c,0)}
        for (uint16 i = 0; i < size; i++) {
            (address addr, uint256 pk) = makeAddrAndKey(LibString.toString(i));assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00010045,0)}
            signers[i] = Signer({addr: addr, pk: pk});assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00020055,0)}
        }
        _quickSortSigners(signers, false);
        return signers;
    }

    function _createConfig(uint8 threshold, Signer[] memory signers) internal pure returns (bytes memory) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a510000, 1037618711121) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a510001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a510005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a516001, signers) }
        address[] memory signersAddr = new address[](signers.length);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0001003d,0)}
        for (uint256 i = 0; i < signers.length; i++) {
            signersAddr[i] = signers[i].addr;address certora_local86 = signersAddr[i];assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000056,certora_local86)}
        }

        return abi.encode(threshold, signersAddr);
    }

    function _createData(bytes32 message, uint8 threshold, uint8 offset, Signer[] memory signers)
        internal
        pure
        returns (bytes memory)
    {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a540000, 1037618711124) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a540001, 4) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a540005, 585) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a546003, signers) }
        UserOpMultiSigVerifier.SignerData[] memory sd = new UserOpMultiSigVerifier.SignerData[](threshold);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0001003e,0)}
        for (uint8 i = 0; i < threshold; i++) {
            uint16 index = uint16(i) + offset;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000046,index)}
            (uint8 v, bytes32 r, bytes32 s) = vm.sign(signers[index].pk, ECDSA.toEthSignedMessageHash(message));assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00010047,0)}
            sd[i] = UserOpMultiSigVerifier.SignerData({
                // Note: index will overflow back to 0 after max uint8.
                // This is ok since an InvalidNumberOfOwners() error is expected.
                index: uint8(index),
                signature: abi.encodePacked(r, s, v)
            });assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00020057,0)}
        }

        return abi.encode(sd);
    }

    function _quickSortSigners(Signer[] memory arr, bool asc) internal pure {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a550000, 1037618711125) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a550001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a550005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a556001, asc) }
        if (arr.length > 1) {
            _quickSortSigners(arr, asc, 0, int256(arr.length) - 1);
        }
    }

    function _quickSortSigners(Signer[] memory arr, bool asc, int256 left, int256 right) private pure {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a560000, 1037618711126) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a560001, 4) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a560005, 585) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a566003, right) }
        if (left >= right) return;

        Signer memory pivot = arr[uint256(left + (right - left) / 2)];assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0001003f,0)}
        int256 i = left;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000040,i)}
        int256 j = right;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000041,j)}

        while (i <= j) {
            if (asc) {
                while (arr[uint256(i)].addr < pivot.addr) i++;
                while (arr[uint256(j)].addr > pivot.addr) j--;
            } else {
                while (arr[uint256(i)].addr > pivot.addr) i++;
                while (arr[uint256(j)].addr < pivot.addr) j--;
            }

            if (i <= j) {
                (arr[uint256(i)], arr[uint256(j)]) = (arr[uint256(j)], arr[uint256(i)]);
                i++;
                j--;
            }
        }

        if (left < j) _quickSortSigners(arr, asc, left, j);
        if (i < right) _quickSortSigners(arr, asc, i, right);
    }
}
