// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts (last updated v5.3.0) (utils/Strings.sol)

pragma solidity ^0.8.20;

import {Math} from "./math/Math.sol";
import {SafeCast} from "./math/SafeCast.sol";
import {SignedMath} from "./math/SignedMath.sol";

/**
 * @dev String operations.
 */
library Strings {
    using SafeCast for *;

    bytes16 private constant HEX_DIGITS = "0123456789abcdef";
    uint8 private constant ADDRESS_LENGTH = 20;
    uint256 private constant SPECIAL_CHARS_LOOKUP =
        (1 << 0x08) | // backspace
            (1 << 0x09) | // tab
            (1 << 0x0a) | // newline
            (1 << 0x0c) | // form feed
            (1 << 0x0d) | // carriage return
            (1 << 0x22) | // double quote
            (1 << 0x5c); // backslash

    /**
     * @dev The `value` string doesn't fit in the specified `length`.
     */
    error StringsInsufficientHexLength(uint256 value, uint256 length);

    /**
     * @dev The string being parsed contains characters that are not in scope of the given base.
     */
    error StringsInvalidChar();

    /**
     * @dev The string being parsed is not a properly formatted address.
     */
    error StringsInvalidAddressFormat();

    /**
     * @dev Converts a `uint256` to its ASCII `string` decimal representation.
     */
    function toString(uint256 value) internal pure returns (string memory) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff019c0000, 1037618708892) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff019c0001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff019c0005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff019c6000, value) }
        unchecked {
            uint256 length = Math.log10(value) + 1;
            string memory buffer = new string(length);
            uint256 ptr;
            assembly ("memory-safe") {
                ptr := add(buffer, add(32, length))
            }
            while (true) {
                ptr--;
                assembly ("memory-safe") {
                    mstore8(ptr, byte(mod(value, 10), HEX_DIGITS))
                }
                value /= 10;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0000019b,value)}
                if (value == 0) break;
            }
            return buffer;
        }
    }

    /**
     * @dev Converts a `int256` to its ASCII `string` decimal representation.
     */
    function toStringSigned(int256 value) internal pure returns (string memory) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff019d0000, 1037618708893) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff019d0001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff019d0005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff019d6000, value) }
        return string.concat(value < 0 ? "-" : "", toString(SignedMath.abs(value)));
    }

    /**
     * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
     */
    function toHexString(uint256 value) internal pure returns (string memory) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff019f0000, 1037618708895) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff019f0001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff019f0005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff019f6000, value) }
        unchecked {
            return toHexString(value, Math.log256(value) + 1);
        }
    }

    /**
     * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
     */
    function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01a00000, 1037618708896) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01a00001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01a00005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01a06001, length) }
        uint256 localValue = value;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000176,localValue)}
        bytes memory buffer = new bytes(2 * length + 2);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00010177,0)}
        buffer[0] = "0";bytes1 certora_local400 = buffer[0];assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000190,certora_local400)}
        buffer[1] = "x";bytes1 certora_local401 = buffer[1];assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000191,certora_local401)}
        for (uint256 i = 2 * length + 1; i > 1; --i) {
            buffer[i] = HEX_DIGITS[localValue & 0xf];bytes1 certora_local405 = buffer[i];assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000195,certora_local405)}
            localValue >>= 4;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000196,localValue)}
        }
        if (localValue != 0) {
            revert StringsInsufficientHexLength(value, length);
        }
        return string(buffer);
    }

    /**
     * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal
     * representation.
     */
    function toHexString(address addr) internal pure returns (string memory) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff019e0000, 1037618708894) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff019e0001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff019e0005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff019e6000, addr) }
        return toHexString(uint256(uint160(addr)), ADDRESS_LENGTH);
    }

    /**
     * @dev Converts an `address` with fixed length of 20 bytes to its checksummed ASCII `string` hexadecimal
     * representation, according to EIP-55.
     */
    function toChecksumHexString(address addr) internal pure returns (string memory) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01a10000, 1037618708897) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01a10001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01a10005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01a16000, addr) }
        bytes memory buffer = bytes(toHexString(addr));assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00010178,0)}

        // hash the hex part of buffer (skip length + 2 bytes, length 40)
        uint256 hashValue;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000179,hashValue)}
        assembly ("memory-safe") {
            hashValue := shr(96, keccak256(add(buffer, 0x22), 40))
        }

        for (uint256 i = 41; i > 1; --i) {
            // possible values for buffer[i] are 48 (0) to 57 (9) and 97 (a) to 102 (f)
            if (hashValue & 0xf > 7 && uint8(buffer[i]) > 96) {
                // case shift by xoring with 0x20
                buffer[i] ^= 0x20;
            }
            hashValue >>= 4;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000197,hashValue)}
        }
        return string(buffer);
    }

    /**
     * @dev Returns true if the two strings are equal.
     */
    function equal(string memory a, string memory b) internal pure returns (bool) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01a20000, 1037618708898) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01a20001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01a20005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01a26001, b) }
        return bytes(a).length == bytes(b).length && keccak256(bytes(a)) == keccak256(bytes(b));
    }

    /**
     * @dev Parse a decimal string and returns the value as a `uint256`.
     *
     * Requirements:
     * - The string must be formatted as `[0-9]*`
     * - The result must fit into an `uint256` type
     */
    function parseUint(string memory input) internal pure returns (uint256) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01a30000, 1037618708899) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01a30001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01a30005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01a36000, input) }
        return parseUint(input, 0, bytes(input).length);
    }

    /**
     * @dev Variant of {parseUint-string} that parses a substring of `input` located between position `begin` (included) and
     * `end` (excluded).
     *
     * Requirements:
     * - The substring must be formatted as `[0-9]*`
     * - The result must fit into an `uint256` type
     */
    function parseUint(string memory input, uint256 begin, uint256 end) internal pure returns (uint256) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01a40000, 1037618708900) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01a40001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01a40005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01a46002, end) }
        (bool success, uint256 value) = tryParseUint(input, begin, end);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0001017a,0)}
        if (!success) revert StringsInvalidChar();
        return value;
    }

    /**
     * @dev Variant of {parseUint-string} that returns false if the parsing fails because of an invalid character.
     *
     * NOTE: This function will revert if the result does not fit in a `uint256`.
     */
    function tryParseUint(string memory input) internal pure returns (bool success, uint256 value) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01a50000, 1037618708901) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01a50001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01a50005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01a56000, input) }
        return _tryParseUintUncheckedBounds(input, 0, bytes(input).length);
    }

    /**
     * @dev Variant of {parseUint-string-uint256-uint256} that returns false if the parsing fails because of an invalid
     * character.
     *
     * NOTE: This function will revert if the result does not fit in a `uint256`.
     */
    function tryParseUint(
        string memory input,
        uint256 begin,
        uint256 end
    ) internal pure returns (bool success, uint256 value) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01a60000, 1037618708902) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01a60001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01a60005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01a66002, end) }
        if (end > bytes(input).length || begin > end) return (false, 0);
        return _tryParseUintUncheckedBounds(input, begin, end);
    }

    /**
     * @dev Implementation of {tryParseUint-string-uint256-uint256} that does not check bounds. Caller should make sure that
     * `begin <= end <= input.length`. Other inputs would result in undefined behavior.
     */
    function _tryParseUintUncheckedBounds(
        string memory input,
        uint256 begin,
        uint256 end
    ) private pure returns (bool success, uint256 value) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01a70000, 1037618708903) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01a70001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01a70005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01a76002, end) }
        bytes memory buffer = bytes(input);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0001017b,0)}

        uint256 result = 0;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0000017c,result)}
        for (uint256 i = begin; i < end; ++i) {
            uint8 chr = _tryParseChr(bytes1(_unsafeReadBytesOffset(buffer, i)));assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000192,chr)}
            if (chr > 9) return (false, 0);
            result *= 10;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000198,result)}
            result += chr;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000199,result)}
        }
        return (true, result);
    }

    /**
     * @dev Parse a decimal string and returns the value as a `int256`.
     *
     * Requirements:
     * - The string must be formatted as `[-+]?[0-9]*`
     * - The result must fit in an `int256` type.
     */
    function parseInt(string memory input) internal pure returns (int256) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01a80000, 1037618708904) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01a80001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01a80005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01a86000, input) }
        return parseInt(input, 0, bytes(input).length);
    }

    /**
     * @dev Variant of {parseInt-string} that parses a substring of `input` located between position `begin` (included) and
     * `end` (excluded).
     *
     * Requirements:
     * - The substring must be formatted as `[-+]?[0-9]*`
     * - The result must fit in an `int256` type.
     */
    function parseInt(string memory input, uint256 begin, uint256 end) internal pure returns (int256) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01a90000, 1037618708905) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01a90001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01a90005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01a96002, end) }
        (bool success, int256 value) = tryParseInt(input, begin, end);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0001017d,0)}
        if (!success) revert StringsInvalidChar();
        return value;
    }

    /**
     * @dev Variant of {parseInt-string} that returns false if the parsing fails because of an invalid character or if
     * the result does not fit in a `int256`.
     *
     * NOTE: This function will revert if the absolute value of the result does not fit in a `uint256`.
     */
    function tryParseInt(string memory input) internal pure returns (bool success, int256 value) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01aa0000, 1037618708906) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01aa0001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01aa0005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01aa6000, input) }
        return _tryParseIntUncheckedBounds(input, 0, bytes(input).length);
    }

    uint256 private constant ABS_MIN_INT256 = 2 ** 255;

    /**
     * @dev Variant of {parseInt-string-uint256-uint256} that returns false if the parsing fails because of an invalid
     * character or if the result does not fit in a `int256`.
     *
     * NOTE: This function will revert if the absolute value of the result does not fit in a `uint256`.
     */
    function tryParseInt(
        string memory input,
        uint256 begin,
        uint256 end
    ) internal pure returns (bool success, int256 value) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01ab0000, 1037618708907) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01ab0001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01ab0005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01ab6002, end) }
        if (end > bytes(input).length || begin > end) return (false, 0);
        return _tryParseIntUncheckedBounds(input, begin, end);
    }

    /**
     * @dev Implementation of {tryParseInt-string-uint256-uint256} that does not check bounds. Caller should make sure that
     * `begin <= end <= input.length`. Other inputs would result in undefined behavior.
     */
    function _tryParseIntUncheckedBounds(
        string memory input,
        uint256 begin,
        uint256 end
    ) private pure returns (bool success, int256 value) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01b10000, 1037618708913) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01b10001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01b10005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01b16002, end) }
        bytes memory buffer = bytes(input);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0001017e,0)}

        // Check presence of a negative sign.
        bytes1 sign = begin == end ? bytes1(0) : bytes1(_unsafeReadBytesOffset(buffer, begin));assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0000017f,sign)} // don't do out-of-bound (possibly unsafe) read if sub-string is empty
        bool positiveSign = sign == bytes1("+");assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000180,positiveSign)}
        bool negativeSign = sign == bytes1("-");assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000181,negativeSign)}
        uint256 offset = (positiveSign || negativeSign).toUint();assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000182,offset)}

        (bool absSuccess, uint256 absValue) = tryParseUint(input, begin + offset, end);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00010183,0)}

        if (absSuccess && absValue < ABS_MIN_INT256) {
            return (true, negativeSign ? -int256(absValue) : int256(absValue));
        } else if (absSuccess && negativeSign && absValue == ABS_MIN_INT256) {
            return (true, type(int256).min);
        } else return (false, 0);
    }

    /**
     * @dev Parse a hexadecimal string (with or without "0x" prefix), and returns the value as a `uint256`.
     *
     * Requirements:
     * - The string must be formatted as `(0x)?[0-9a-fA-F]*`
     * - The result must fit in an `uint256` type.
     */
    function parseHexUint(string memory input) internal pure returns (uint256) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01b00000, 1037618708912) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01b00001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01b00005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01b06000, input) }
        return parseHexUint(input, 0, bytes(input).length);
    }

    /**
     * @dev Variant of {parseHexUint-string} that parses a substring of `input` located between position `begin` (included) and
     * `end` (excluded).
     *
     * Requirements:
     * - The substring must be formatted as `(0x)?[0-9a-fA-F]*`
     * - The result must fit in an `uint256` type.
     */
    function parseHexUint(string memory input, uint256 begin, uint256 end) internal pure returns (uint256) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01af0000, 1037618708911) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01af0001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01af0005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01af6002, end) }
        (bool success, uint256 value) = tryParseHexUint(input, begin, end);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00010184,0)}
        if (!success) revert StringsInvalidChar();
        return value;
    }

    /**
     * @dev Variant of {parseHexUint-string} that returns false if the parsing fails because of an invalid character.
     *
     * NOTE: This function will revert if the result does not fit in a `uint256`.
     */
    function tryParseHexUint(string memory input) internal pure returns (bool success, uint256 value) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01b20000, 1037618708914) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01b20001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01b20005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01b26000, input) }
        return _tryParseHexUintUncheckedBounds(input, 0, bytes(input).length);
    }

    /**
     * @dev Variant of {parseHexUint-string-uint256-uint256} that returns false if the parsing fails because of an
     * invalid character.
     *
     * NOTE: This function will revert if the result does not fit in a `uint256`.
     */
    function tryParseHexUint(
        string memory input,
        uint256 begin,
        uint256 end
    ) internal pure returns (bool success, uint256 value) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01b30000, 1037618708915) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01b30001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01b30005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01b36002, end) }
        if (end > bytes(input).length || begin > end) return (false, 0);
        return _tryParseHexUintUncheckedBounds(input, begin, end);
    }

    /**
     * @dev Implementation of {tryParseHexUint-string-uint256-uint256} that does not check bounds. Caller should make sure that
     * `begin <= end <= input.length`. Other inputs would result in undefined behavior.
     */
    function _tryParseHexUintUncheckedBounds(
        string memory input,
        uint256 begin,
        uint256 end
    ) private pure returns (bool success, uint256 value) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01b40000, 1037618708916) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01b40001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01b40005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01b46002, end) }
        bytes memory buffer = bytes(input);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00010185,0)}

        // skip 0x prefix if present
        bool hasPrefix = (end > begin + 1) && bytes2(_unsafeReadBytesOffset(buffer, begin)) == bytes2("0x");assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000186,hasPrefix)} // don't do out-of-bound (possibly unsafe) read if sub-string is empty
        uint256 offset = hasPrefix.toUint() * 2;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000187,offset)}

        uint256 result = 0;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000188,result)}
        for (uint256 i = begin + offset; i < end; ++i) {
            uint8 chr = _tryParseChr(bytes1(_unsafeReadBytesOffset(buffer, i)));assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000193,chr)}
            if (chr > 15) return (false, 0);
            result *= 16;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0000019a,result)}
            unchecked {
                // Multiplying by 16 is equivalent to a shift of 4 bits (with additional overflow check).
                // This guarantees that adding a value < 16 will not cause an overflow, hence the unchecked.
                result += chr;
            }
        }
        return (true, result);
    }

    /**
     * @dev Parse a hexadecimal string (with or without "0x" prefix), and returns the value as an `address`.
     *
     * Requirements:
     * - The string must be formatted as `(0x)?[0-9a-fA-F]{40}`
     */
    function parseAddress(string memory input) internal pure returns (address) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01b50000, 1037618708917) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01b50001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01b50005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01b56000, input) }
        return parseAddress(input, 0, bytes(input).length);
    }

    /**
     * @dev Variant of {parseAddress-string} that parses a substring of `input` located between position `begin` (included) and
     * `end` (excluded).
     *
     * Requirements:
     * - The substring must be formatted as `(0x)?[0-9a-fA-F]{40}`
     */
    function parseAddress(string memory input, uint256 begin, uint256 end) internal pure returns (address) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01b60000, 1037618708918) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01b60001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01b60005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01b66002, end) }
        (bool success, address value) = tryParseAddress(input, begin, end);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00010189,0)}
        if (!success) revert StringsInvalidAddressFormat();
        return value;
    }

    /**
     * @dev Variant of {parseAddress-string} that returns false if the parsing fails because the input is not a properly
     * formatted address. See {parseAddress-string} requirements.
     */
    function tryParseAddress(string memory input) internal pure returns (bool success, address value) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01b70000, 1037618708919) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01b70001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01b70005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01b76000, input) }
        return tryParseAddress(input, 0, bytes(input).length);
    }

    /**
     * @dev Variant of {parseAddress-string-uint256-uint256} that returns false if the parsing fails because input is not a properly
     * formatted address. See {parseAddress-string-uint256-uint256} requirements.
     */
    function tryParseAddress(
        string memory input,
        uint256 begin,
        uint256 end
    ) internal pure returns (bool success, address value) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01b80000, 1037618708920) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01b80001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01b80005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01b86002, end) }
        if (end > bytes(input).length || begin > end) return (false, address(0));

        bool hasPrefix = (end > begin + 1) && bytes2(_unsafeReadBytesOffset(bytes(input), begin)) == bytes2("0x");assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0000018a,hasPrefix)} // don't do out-of-bound (possibly unsafe) read if sub-string is empty
        uint256 expectedLength = 40 + hasPrefix.toUint() * 2;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0000018b,expectedLength)}

        // check that input is the correct length
        if (end - begin == expectedLength) {
            // length guarantees that this does not overflow, and value is at most type(uint160).max
            (bool s, uint256 v) = _tryParseHexUintUncheckedBounds(input, begin, end);
            return (s, address(uint160(v)));
        } else {
            return (false, address(0));
        }
    }

    function _tryParseChr(bytes1 chr) private pure returns (uint8) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01ac0000, 1037618708908) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01ac0001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01ac0005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01ac6000, chr) }
        uint8 value = uint8(chr);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0000018c,value)}

        // Try to parse `chr`:
        // - Case 1: [0-9]
        // - Case 2: [a-f]
        // - Case 3: [A-F]
        // - otherwise not supported
        unchecked {
            if (value > 47 && value < 58) value -= 48;
            else if (value > 96 && value < 103) value -= 87;
            else if (value > 64 && value < 71) value -= 55;
            else return type(uint8).max;
        }

        return value;
    }

    /**
     * @dev Escape special characters in JSON strings. This can be useful to prevent JSON injection in NFT metadata.
     *
     * WARNING: This function should only be used in double quoted JSON strings. Single quotes are not escaped.
     *
     * NOTE: This function escapes all unicode characters, and not just the ones in ranges defined in section 2.5 of
     * RFC-4627 (U+0000 to U+001F, U+0022 and U+005C). ECMAScript's `JSON.parse` does recover escaped unicode
     * characters that are not in this range, but other tooling may provide different results.
     */
    function escapeJSON(string memory input) internal pure returns (string memory) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01ad0000, 1037618708909) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01ad0001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01ad0005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01ad6000, input) }
        bytes memory buffer = bytes(input);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0001018d,0)}
        bytes memory output = new bytes(2 * buffer.length);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0001018e,0)} // worst case scenario
        uint256 outputLength = 0;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0000018f,outputLength)}

        for (uint256 i; i < buffer.length; ++i) {
            bytes1 char = bytes1(_unsafeReadBytesOffset(buffer, i));assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000194,char)}
            if (((SPECIAL_CHARS_LOOKUP & (1 << uint8(char))) != 0)) {
                output[outputLength++] = "\\";
                if (char == 0x08) output[outputLength++] = "b";
                else if (char == 0x09) output[outputLength++] = "t";
                else if (char == 0x0a) output[outputLength++] = "n";
                else if (char == 0x0c) output[outputLength++] = "f";
                else if (char == 0x0d) output[outputLength++] = "r";
                else if (char == 0x5c) output[outputLength++] = "\\";
                else if (char == 0x22) {
                    // solhint-disable-next-line quotes
                    output[outputLength++] = '"';
                }
            } else {
                output[outputLength++] = char;bytes1 certora_local412 = output[outputLength++];assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0000019c,certora_local412)}
            }
        }
        // write the actual length and deallocate unused memory
        assembly ("memory-safe") {
            mstore(output, outputLength)
            mstore(0x40, add(output, shl(5, shr(5, add(outputLength, 63)))))
        }

        return string(output);
    }

    /**
     * @dev Reads a bytes32 from a bytes array without bounds checking.
     *
     * NOTE: making this function internal would mean it could be used with memory unsafe offset, and marking the
     * assembly block as such would prevent some optimizations.
     */
    function _unsafeReadBytesOffset(bytes memory buffer, uint256 offset) private pure returns (bytes32 value) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01ae0000, 1037618708910) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01ae0001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01ae0005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01ae6001, offset) }
        // This is not memory safe in the general case, but all calls to this private function are within bounds.
        assembly ("memory-safe") {
            value := mload(add(buffer, add(0x20, offset)))
        }
    }
}
