// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

/* solhint-disable no-inline-assembly */


 /*
  * For simulation purposes, validateUserOp (and validatePaymasterUserOp)
  * must return this value in case of signature failure, instead of revert.
  */
uint256 constant SIG_VALIDATION_FAILED = 1;


/*
 * For simulation purposes, validateUserOp (and validatePaymasterUserOp)
 * return this value on success.
 */
uint256 constant SIG_VALIDATION_SUCCESS = 0;


/**
 * Returned data from validateUserOp.
 * validateUserOp returns a uint256, which is created by `_packedValidationData` and
 * parsed by `_parseValidationData`.
 * @param aggregator  - address(0) - The account validated the signature by itself.
 *                      address(1) - The account failed to validate the signature.
 *                      otherwise - This is an address of a signature aggregator that must
 *                                  be used to validate the signature.
 * @param validAfter  - This UserOp is valid only after this timestamp.
 * @param validUntil - Last timestamp this operation is valid at, or 0 for "indefinitely".
 */
struct ValidationData {
    address aggregator;
    uint48 validAfter;
    uint48 validUntil;
}

/**
 * Extract aggregator/sigFailed, validAfter, validUntil.
 * Also convert zero validUntil to type(uint48).max.
 * @param validationData - The packed validation data.
 * @return data - The unpacked in-memory validation data.
 */
function _parseValidationData(
    uint256 validationData
) pure returns (ValidationData memory data) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a480000, 1037618711112) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a480001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a480005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a486000, validationData) }
    address aggregator = address(uint160(validationData));
    uint48 validUntil = uint48(validationData >> 160);
    if (validUntil == 0) {
        validUntil = type(uint48).max;
    }
    uint48 validAfter = uint48(validationData >> (48 + 160));
    return ValidationData(aggregator, validAfter, validUntil);
}

/**
 * Helper to pack the return value for validateUserOp.
 * @param data - The ValidationData to pack.
 * @return the packed validation data.
 */
function _packValidationData(
    ValidationData memory data
) pure returns (uint256) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a490000, 1037618711113) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a490001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a490005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a496000, data) }
    return
        uint160(data.aggregator) |
        (uint256(data.validUntil) << 160) |
        (uint256(data.validAfter) << (160 + 48));
}

/**
 * Helper to pack the return value for validateUserOp, when not using an aggregator.
 * @param sigFailed  - True for signature failure, false for success.
 * @param validUntil - Last timestamp this operation is valid at, or 0 for "indefinitely".
 * @param validAfter - First timestamp this UserOperation is valid.
 * @return the packed validation data.
 */
function _packValidationData(
    bool sigFailed,
    uint48 validUntil,
    uint48 validAfter
) pure returns (uint256) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a4b0000, 1037618711115) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a4b0001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a4b0005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a4b6002, validAfter) }
    return
        (sigFailed ?  SIG_VALIDATION_FAILED : SIG_VALIDATION_SUCCESS) |
        (uint256(validUntil) << 160) |
        (uint256(validAfter) << (160 + 48));
}

/**
 * keccak function over calldata.
 * @dev copy calldata into memory, do keccak and drop allocated memory. Strangely, this is more efficient than letting solidity do it.
 *
 * @param data - the calldata bytes array to perform keccak on.
 * @return ret - the keccak hash of the 'data' array.
 */
    function calldataKeccak(bytes calldata data) pure returns (bytes32 ret) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a4c0000, 1037618711116) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a4c0001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a4c0005, 26) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a4c6100, data.offset) }
        assembly ("memory-safe") {
            let mem := mload(0x40)
            let len := data.length
            calldatacopy(mem, data.offset, len)
            ret := keccak256(mem, len)
        }
    }


/**
 * The minimum of two numbers.
 * @param a - First number.
 * @param b - Second number.
 * @return - the minimum value.
 */
    function min(uint256 a, uint256 b) pure returns (uint256) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a4a0000, 1037618711114) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a4a0001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a4a0005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a4a6001, b) }
        return a < b ? a : b;
    }

/**
 * standard solidity memory allocation finalization.
 * copied from solidity generated code
 * @param memPointer - The current memory pointer
 * @param allocationSize - Bytes allocated from memPointer.
 */
    function finalizeAllocation(uint256 memPointer, uint256 allocationSize) pure {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a4d0000, 1037618711117) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a4d0001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a4d0005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a4d6001, allocationSize) }

        assembly ("memory-safe"){
            finalize_allocation(memPointer, allocationSize)

            function finalize_allocation(memPtr, size) {
                let newFreePtr := add(memPtr, round_up_to_mul_of_32(size))
                mstore(64, newFreePtr)
            }

            function round_up_to_mul_of_32(value) -> result {
                result := and(add(value, 31), not(31))
            }
        }
    }
