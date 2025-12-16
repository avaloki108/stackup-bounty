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
    function asAddress(bytes32 slot) internal pure returns (AddressSlot) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05d50000, 1037618709973) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05d50001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05d50005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05d56000, slot) }
        return AddressSlot.wrap(slot);
    }

    /**
     * @dev UDVT that represents a slot holding a bool.
     */
    type BooleanSlot is bytes32;

    /**
     * @dev Cast an arbitrary slot to a BooleanSlot.
     */
    function asBoolean(bytes32 slot) internal pure returns (BooleanSlot) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05d60000, 1037618709974) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05d60001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05d60005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05d66000, slot) }
        return BooleanSlot.wrap(slot);
    }

    /**
     * @dev UDVT that represents a slot holding a bytes32.
     */
    type Bytes32Slot is bytes32;

    /**
     * @dev Cast an arbitrary slot to a Bytes32Slot.
     */
    function asBytes32(bytes32 slot) internal pure returns (Bytes32Slot) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05d80000, 1037618709976) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05d80001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05d80005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05d86000, slot) }
        return Bytes32Slot.wrap(slot);
    }

    /**
     * @dev UDVT that represents a slot holding a uint256.
     */
    type Uint256Slot is bytes32;

    /**
     * @dev Cast an arbitrary slot to a Uint256Slot.
     */
    function asUint256(bytes32 slot) internal pure returns (Uint256Slot) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05d90000, 1037618709977) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05d90001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05d90005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05d96000, slot) }
        return Uint256Slot.wrap(slot);
    }

    /**
     * @dev UDVT that represents a slot holding a int256.
     */
    type Int256Slot is bytes32;

    /**
     * @dev Cast an arbitrary slot to a Int256Slot.
     */
    function asInt256(bytes32 slot) internal pure returns (Int256Slot) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05d70000, 1037618709975) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05d70001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05d70005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05d76000, slot) }
        return Int256Slot.wrap(slot);
    }

    /**
     * @dev Load the value held at location `slot` in transient storage.
     */
    function tload(AddressSlot slot) internal view returns (address value) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05da0000, 1037618709978) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05da0001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05da0005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05da6000, slot) }
        assembly ("memory-safe") {
            value := tload(slot)
        }
    }

    /**
     * @dev Store `value` at location `slot` in transient storage.
     */
    function tstore(AddressSlot slot, address value) internal {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05db0000, 1037618709979) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05db0001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05db0005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05db6001, value) }
        assembly ("memory-safe") {
            tstore(slot, value)
        }
    }

    /**
     * @dev Load the value held at location `slot` in transient storage.
     */
    function tload(BooleanSlot slot) internal view returns (bool value) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05dc0000, 1037618709980) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05dc0001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05dc0005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05dc6000, slot) }
        assembly ("memory-safe") {
            value := tload(slot)
        }
    }

    /**
     * @dev Store `value` at location `slot` in transient storage.
     */
    function tstore(BooleanSlot slot, bool value) internal {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05dd0000, 1037618709981) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05dd0001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05dd0005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05dd6001, value) }
        assembly ("memory-safe") {
            tstore(slot, value)
        }
    }

    /**
     * @dev Load the value held at location `slot` in transient storage.
     */
    function tload(Bytes32Slot slot) internal view returns (bytes32 value) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05de0000, 1037618709982) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05de0001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05de0005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05de6000, slot) }
        assembly ("memory-safe") {
            value := tload(slot)
        }
    }

    /**
     * @dev Store `value` at location `slot` in transient storage.
     */
    function tstore(Bytes32Slot slot, bytes32 value) internal {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05df0000, 1037618709983) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05df0001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05df0005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05df6001, value) }
        assembly ("memory-safe") {
            tstore(slot, value)
        }
    }

    /**
     * @dev Load the value held at location `slot` in transient storage.
     */
    function tload(Uint256Slot slot) internal view returns (uint256 value) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05e00000, 1037618709984) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05e00001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05e00005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05e06000, slot) }
        assembly ("memory-safe") {
            value := tload(slot)
        }
    }

    /**
     * @dev Store `value` at location `slot` in transient storage.
     */
    function tstore(Uint256Slot slot, uint256 value) internal {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05e10000, 1037618709985) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05e10001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05e10005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05e16001, value) }
        assembly ("memory-safe") {
            tstore(slot, value)
        }
    }

    /**
     * @dev Load the value held at location `slot` in transient storage.
     */
    function tload(Int256Slot slot) internal view returns (int256 value) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05e20000, 1037618709986) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05e20001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05e20005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05e26000, slot) }
        assembly ("memory-safe") {
            value := tload(slot)
        }
    }

    /**
     * @dev Store `value` at location `slot` in transient storage.
     */
    function tstore(Int256Slot slot, int256 value) internal {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05e30000, 1037618709987) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05e30001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05e30005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05e36001, value) }
        assembly ("memory-safe") {
            tstore(slot, value)
        }
    }
}
