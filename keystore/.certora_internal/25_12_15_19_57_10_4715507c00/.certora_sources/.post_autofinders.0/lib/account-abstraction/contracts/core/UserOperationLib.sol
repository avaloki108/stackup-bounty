// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

/* solhint-disable no-inline-assembly */

import "../interfaces/PackedUserOperation.sol";
import {calldataKeccak, min} from "./Helpers.sol";

/**
 * Utility functions helpful when working with UserOperation structs.
 */
library UserOperationLib {

    uint256 public constant PAYMASTER_VALIDATION_GAS_OFFSET = 20;
    uint256 public constant PAYMASTER_POSTOP_GAS_OFFSET = 36;
    uint256 public constant PAYMASTER_DATA_OFFSET = 52;

    /**
     * Relayer/block builder might submit the TX with higher priorityFee,
     * but the user should not pay above what he signed for.
     * @param userOp - The user operation data.
     */
    function gasPrice(
        PackedUserOperation calldata userOp
    ) internal view returns (uint256) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff005b0000, 1037618708571) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff005b0001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff005b0005, 4) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff005b6200, userOp) }
        unchecked {
            (uint256 maxPriorityFeePerGas, uint256 maxFeePerGas) = unpackUints(userOp.gasFees);
            return min(maxFeePerGas, maxPriorityFeePerGas + block.basefee);
        }
    }

    bytes32 internal constant PACKED_USEROP_TYPEHASH =
    keccak256(
        "PackedUserOperation(address sender,uint256 nonce,bytes initCode,bytes callData,bytes32 accountGasLimits,uint256 preVerificationGas,bytes32 gasFees,bytes paymasterAndData)"
    );

    /**
     * Pack the user operation data into bytes for hashing.
     * @param userOp - The user operation data.
     * @param overrideInitCodeHash - If set, encode this instead of the initCode field in the userOp.
     */
    function encode(
        PackedUserOperation calldata userOp,
        bytes32 overrideInitCodeHash
    ) internal pure returns (bytes memory ret) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff005c0000, 1037618708572) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff005c0001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff005c0005, 33) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff005c6001, overrideInitCodeHash) }
        address sender = userOp.sender;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000096,sender)}
        uint256 nonce = userOp.nonce;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000097,nonce)}
        bytes32 hashInitCode = overrideInitCodeHash != 0 ? overrideInitCodeHash : calldataKeccak(userOp.initCode);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000098,hashInitCode)}
        bytes32 hashCallData = calldataKeccak(userOp.callData);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000099,hashCallData)}
        bytes32 accountGasLimits = userOp.accountGasLimits;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0000009a,accountGasLimits)}
        uint256 preVerificationGas = userOp.preVerificationGas;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0000009b,preVerificationGas)}
        bytes32 gasFees = userOp.gasFees;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0000009c,gasFees)}
        bytes32 hashPaymasterAndData = calldataKeccak(userOp.paymasterAndData);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0000009d,hashPaymasterAndData)}

        return abi.encode(
            UserOperationLib.PACKED_USEROP_TYPEHASH,
            sender, nonce,
            hashInitCode, hashCallData,
            accountGasLimits, preVerificationGas, gasFees,
            hashPaymasterAndData
        );
    }

    function unpackUints(
        bytes32 packed
    ) internal pure returns (uint256 high128, uint256 low128) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff005e0000, 1037618708574) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff005e0001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff005e0005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff005e6000, packed) }
        return (unpackHigh128(packed), unpackLow128(packed));
    }

    // Unpack just the high 128-bits from a packed value
    function unpackHigh128(bytes32 packed) internal pure returns (uint256) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff005f0000, 1037618708575) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff005f0001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff005f0005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff005f6000, packed) }
        return uint256(packed) >> 128;
    }

    // Unpack just the low 128-bits from a packed value
    function unpackLow128(bytes32 packed) internal pure returns (uint256) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff005d0000, 1037618708573) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff005d0001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff005d0005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff005d6000, packed) }
        return uint128(uint256(packed));
    }

    function unpackMaxPriorityFeePerGas(PackedUserOperation calldata userOp)
    internal pure returns (uint256) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00600000, 1037618708576) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00600001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00600005, 4) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00606200, userOp) }
        return unpackHigh128(userOp.gasFees);
    }

    function unpackMaxFeePerGas(PackedUserOperation calldata userOp)
    internal pure returns (uint256) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00610000, 1037618708577) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00610001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00610005, 4) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00616200, userOp) }
        return unpackLow128(userOp.gasFees);
    }

    function unpackVerificationGasLimit(PackedUserOperation calldata userOp)
    internal pure returns (uint256) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00620000, 1037618708578) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00620001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00620005, 4) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00626200, userOp) }
        return unpackHigh128(userOp.accountGasLimits);
    }

    function unpackCallGasLimit(PackedUserOperation calldata userOp)
    internal pure returns (uint256) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00630000, 1037618708579) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00630001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00630005, 4) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00636200, userOp) }
        return unpackLow128(userOp.accountGasLimits);
    }

    function unpackPaymasterVerificationGasLimit(PackedUserOperation calldata userOp)
    internal pure returns (uint256) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00640000, 1037618708580) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00640001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00640005, 4) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00646200, userOp) }
        return uint128(bytes16(userOp.paymasterAndData[PAYMASTER_VALIDATION_GAS_OFFSET : PAYMASTER_POSTOP_GAS_OFFSET]));
    }

    function unpackPostOpGasLimit(PackedUserOperation calldata userOp)
    internal pure returns (uint256) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00650000, 1037618708581) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00650001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00650005, 4) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00656200, userOp) }
        return uint128(bytes16(userOp.paymasterAndData[PAYMASTER_POSTOP_GAS_OFFSET : PAYMASTER_DATA_OFFSET]));
    }

    function unpackPaymasterStaticFields(
        bytes calldata paymasterAndData
    ) internal pure returns (address paymaster, uint256 validationGasLimit, uint256 postOpGasLimit) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00660000, 1037618708582) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00660001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00660005, 26) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00666100, paymasterAndData.offset) }
        return (
            address(bytes20(paymasterAndData[: PAYMASTER_VALIDATION_GAS_OFFSET])),
            uint128(bytes16(paymasterAndData[PAYMASTER_VALIDATION_GAS_OFFSET : PAYMASTER_POSTOP_GAS_OFFSET])),
            uint128(bytes16(paymasterAndData[PAYMASTER_POSTOP_GAS_OFFSET : PAYMASTER_DATA_OFFSET]))
        );
    }

    /**
     * Hash the user operation data.
     * @param userOp - The user operation data.
     * @param overrideInitCodeHash - If set, the initCode hash will be replaced with this value just for UserOp hashing.
     */
    function hash(
        PackedUserOperation calldata userOp,
        bytes32 overrideInitCodeHash
    ) internal pure returns (bytes32) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00670000, 1037618708583) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00670001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00670005, 33) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00676001, overrideInitCodeHash) }
        return keccak256(encode(userOp, overrideInitCodeHash));
    }
}
