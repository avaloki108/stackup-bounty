// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts (last updated v5.3.0) (utils/TransientSlot.sol)
// This file was procedurally generated from scripts/generate/templates/TransientSlot.js.

pragma solidity ^0.8.24;

/**
 * @dev Library for reading and writing value-types to specific transient storage slots.
 *
 * Transient slots are often used to store temporary values that are removed after the current transaction.
 * This library helps with reading and writing to such slots without the need for inline assembly.
 *
 *  * Example reading and writing values using transient storage:
 * ```solidity
 * contract Lock {
 *     using TransientSlot for *;
 *
 *     // Define the slot. Alternatively, use the SlotDerivation library to derive the slot.
 *     bytes32 internal constant _LOCK_SLOT = 0xf4678858b2b588224636b8522b729e7722d32fc491da849ed75b3fdf3c84f542;
 *
 *     modifier locked() {
 *         require(!_LOCK_SLOT.asBoolean().tload());
 *
 *         _LOCK_SLOT.asBoolean().tstore(true);
 *         _;
 *         _LOCK_SLOT.asBoolean().tstore(false);
 *     }
 * }
 * ```
 *
 * TIP: Consider using this library along with {SlotDerivation}.
 */
library TransientSlot {
    /**
     * @dev UDVT that represents a slot holding an address.
     */
    type AddressSlot is bytes32;

    /**
     * @dev Cast an arbitrary slot to a AddressSlot.
     */
    function asAddress(bytes32 slot) internal pure returns (AddressSlot) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07510000, 1037618710353) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07510001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07510005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07516000, slot) }
        return AddressSlot.wrap(slot);
    }

    /**
     * @dev UDVT that represents a slot holding a bool.
     */
    type BooleanSlot is bytes32;

    /**
     * @dev Cast an arbitrary slot to a BooleanSlot.
     */
    function asBoolean(bytes32 slot) internal pure returns (BooleanSlot) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07520000, 1037618710354) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07520001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07520005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07526000, slot) }
        return BooleanSlot.wrap(slot);
    }

    /**
     * @dev UDVT that represents a slot holding a bytes32.
     */
    type Bytes32Slot is bytes32;

    /**
     * @dev Cast an arbitrary slot to a Bytes32Slot.
     */
    function asBytes32(bytes32 slot) internal pure returns (Bytes32Slot) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07540000, 1037618710356) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07540001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07540005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07546000, slot) }
        return Bytes32Slot.wrap(slot);
    }

    /**
     * @dev UDVT that represents a slot holding a uint256.
     */
    type Uint256Slot is bytes32;

    /**
     * @dev Cast an arbitrary slot to a Uint256Slot.
     */
    function asUint256(bytes32 slot) internal pure returns (Uint256Slot) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07550000, 1037618710357) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07550001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07550005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07556000, slot) }
        return Uint256Slot.wrap(slot);
    }

    /**
     * @dev UDVT that represents a slot holding a int256.
     */
    type Int256Slot is bytes32;

    /**
     * @dev Cast an arbitrary slot to a Int256Slot.
     */
    function asInt256(bytes32 slot) internal pure returns (Int256Slot) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07530000, 1037618710355) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07530001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07530005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07536000, slot) }
        return Int256Slot.wrap(slot);
    }

    /**
     * @dev Load the value held at location `slot` in transient storage.
     */
    function tload(AddressSlot slot) internal view returns (address value) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07560000, 1037618710358) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07560001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07560005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07566000, slot) }
        assembly ("memory-safe") {
            value := tload(slot)
        }
    }

    /**
     * @dev Store `value` at location `slot` in transient storage.
     */
    function tstore(AddressSlot slot, address value) internal {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07570000, 1037618710359) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07570001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07570005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07576001, value) }
        assembly ("memory-safe") {
            tstore(slot, value)
        }
    }

    /**
     * @dev Load the value held at location `slot` in transient storage.
     */
    function tload(BooleanSlot slot) internal view returns (bool value) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07580000, 1037618710360) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07580001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07580005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07586000, slot) }
        assembly ("memory-safe") {
            value := tload(slot)
        }
    }

    /**
     * @dev Store `value` at location `slot` in transient storage.
     */
    function tstore(BooleanSlot slot, bool value) internal {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07590000, 1037618710361) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07590001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07590005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07596001, value) }
        assembly ("memory-safe") {
            tstore(slot, value)
        }
    }

    /**
     * @dev Load the value held at location `slot` in transient storage.
     */
    function tload(Bytes32Slot slot) internal view returns (bytes32 value) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff075a0000, 1037618710362) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff075a0001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff075a0005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff075a6000, slot) }
        assembly ("memory-safe") {
            value := tload(slot)
        }
    }

    /**
     * @dev Store `value` at location `slot` in transient storage.
     */
    function tstore(Bytes32Slot slot, bytes32 value) internal {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff075b0000, 1037618710363) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff075b0001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff075b0005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff075b6001, value) }
        assembly ("memory-safe") {
            tstore(slot, value)
        }
    }

    /**
     * @dev Load the value held at location `slot` in transient storage.
     */
    function tload(Uint256Slot slot) internal view returns (uint256 value) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff075c0000, 1037618710364) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff075c0001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff075c0005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff075c6000, slot) }
        assembly ("memory-safe") {
            value := tload(slot)
        }
    }

    /**
     * @dev Store `value` at location `slot` in transient storage.
     */
    function tstore(Uint256Slot slot, uint256 value) internal {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff075d0000, 1037618710365) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff075d0001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff075d0005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff075d6001, value) }
        assembly ("memory-safe") {
            tstore(slot, value)
        }
    }

    /**
     * @dev Load the value held at location `slot` in transient storage.
     */
    function tload(Int256Slot slot) internal view returns (int256 value) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff075e0000, 1037618710366) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff075e0001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff075e0005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff075e6000, slot) }
        assembly ("memory-safe") {
            value := tload(slot)
        }
    }

    /**
     * @dev Store `value` at location `slot` in transient storage.
     */
    function tstore(Int256Slot slot, int256 value) internal {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff075f0000, 1037618710367) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff075f0001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff075f0005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff075f6001, value) }
        assembly ("memory-safe") {
            tstore(slot, value)
        }
    }
}
