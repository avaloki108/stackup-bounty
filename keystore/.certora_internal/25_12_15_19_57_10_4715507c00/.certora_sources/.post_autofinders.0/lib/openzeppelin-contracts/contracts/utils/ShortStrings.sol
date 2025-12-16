// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts (last updated v5.3.0) (utils/ShortStrings.sol)

pragma solidity ^0.8.20;

import {StorageSlot} from "./StorageSlot.sol";

// | string  | 0xAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA   |
// | length  | 0x                                                              BB |
type ShortString is bytes32;

/**
 * @dev This library provides functions to convert short memory strings
 * into a `ShortString` type that can be used as an immutable variable.
 *
 * Strings of arbitrary length can be optimized using this library if
 * they are short enough (up to 31 bytes) by packing them with their
 * length (1 byte) in a single EVM word (32 bytes). Additionally, a
 * fallback mechanism can be used for every other case.
 *
 * Usage example:
 *
 * ```solidity
 * contract Named {
 *     using ShortStrings for *;
 *
 *     ShortString private immutable _name;
 *     string private _nameFallback;
 *
 *     constructor(string memory contractName) {
 *         _name = contractName.toShortStringWithFallback(_nameFallback);
 *     }
 *
 *     function name() external view returns (string memory) {
 *         return _name.toStringWithFallback(_nameFallback);
 *     }
 * }
 * ```
 */
library ShortStrings {
    // Used as an identifier for strings longer than 31 bytes.
    bytes32 private constant FALLBACK_SENTINEL = 0x00000000000000000000000000000000000000000000000000000000000000FF;

    error StringTooLong(string str);
    error InvalidShortString();

    /**
     * @dev Encode a string of at most 31 chars into a `ShortString`.
     *
     * This will trigger a `StringTooLong` error is the input string is too long.
     */
    function toShortString(string memory str) internal pure returns (ShortString) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff018d0000, 1037618708877) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff018d0001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff018d0005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff018d6000, str) }
        bytes memory bstr = bytes(str);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00010172,0)}
        if (bstr.length > 31) {
            revert StringTooLong(str);
        }
        return ShortString.wrap(bytes32(uint256(bytes32(bstr)) | bstr.length));
    }

    /**
     * @dev Decode a `ShortString` back to a "normal" string.
     */
    function toString(ShortString sstr) internal pure returns (string memory) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff018e0000, 1037618708878) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff018e0001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff018e0005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff018e6000, sstr) }
        uint256 len = byteLength(sstr);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000173,len)}
        // using `new string(len)` would work locally but is not memory safe.
        string memory str = new string(32);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00010174,0)}
        assembly ("memory-safe") {
            mstore(str, len)
            mstore(add(str, 0x20), sstr)
        }
        return str;
    }

    /**
     * @dev Return the length of a `ShortString`.
     */
    function byteLength(ShortString sstr) internal pure returns (uint256) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01900000, 1037618708880) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01900001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01900005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01906000, sstr) }
        uint256 result = uint256(ShortString.unwrap(sstr)) & 0xFF;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000175,result)}
        if (result > 31) {
            revert InvalidShortString();
        }
        return result;
    }

    /**
     * @dev Encode a string into a `ShortString`, or write it to storage if it is too long.
     */
    function toShortStringWithFallback(string memory value, string storage store) internal returns (ShortString) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01910000, 1037618708881) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01910001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01910005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01916001, store.slot) }
        if (bytes(value).length < 32) {
            return toShortString(value);
        } else {
            StorageSlot.getStringSlot(store).value = value;
            return ShortString.wrap(FALLBACK_SENTINEL);
        }
    }

    /**
     * @dev Decode a string that was encoded to `ShortString` or written to storage using {toShortStringWithFallback}.
     */
    function toStringWithFallback(ShortString value, string storage store) internal pure returns (string memory) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff018f0000, 1037618708879) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff018f0001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff018f0005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff018f6001, store.slot) }
        if (ShortString.unwrap(value) != FALLBACK_SENTINEL) {
            return toString(value);
        } else {
            return store;
        }
    }

    /**
     * @dev Return the length of a string that was encoded to `ShortString` or written to storage using
     * {toShortStringWithFallback}.
     *
     * WARNING: This will return the "byte length" of the string. This may not reflect the actual length in terms of
     * actual characters as the UTF-8 encoding of a single character can span over multiple bytes.
     */
    function byteLengthWithFallback(ShortString value, string storage store) internal view returns (uint256) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01920000, 1037618708882) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01920001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01920005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01926001, store.slot) }
        if (ShortString.unwrap(value) != FALLBACK_SENTINEL) {
            return byteLength(value);
        } else {
            return bytes(store).length;
        }
    }
}
