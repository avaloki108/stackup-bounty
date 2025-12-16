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
    function asAddress(bytes32 slot) internal pure returns (AddressSlot) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01b90000, 1037618708921) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01b90001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01b90005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01b96000, slot) }
        return AddressSlot.wrap(slot);
    }

    /**
     * @dev UDVT that represents a slot holding a bool.
     */
    type BooleanSlot is bytes32;

    /**
     * @dev Cast an arbitrary slot to a BooleanSlot.
     */
    function asBoolean(bytes32 slot) internal pure returns (BooleanSlot) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01ba0000, 1037618708922) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01ba0001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01ba0005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01ba6000, slot) }
        return BooleanSlot.wrap(slot);
    }

    /**
     * @dev UDVT that represents a slot holding a bytes32.
     */
    type Bytes32Slot is bytes32;

    /**
     * @dev Cast an arbitrary slot to a Bytes32Slot.
     */
    function asBytes32(bytes32 slot) internal pure returns (Bytes32Slot) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01bc0000, 1037618708924) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01bc0001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01bc0005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01bc6000, slot) }
        return Bytes32Slot.wrap(slot);
    }

    /**
     * @dev UDVT that represents a slot holding a uint256.
     */
    type Uint256Slot is bytes32;

    /**
     * @dev Cast an arbitrary slot to a Uint256Slot.
     */
    function asUint256(bytes32 slot) internal pure returns (Uint256Slot) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01bd0000, 1037618708925) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01bd0001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01bd0005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01bd6000, slot) }
        return Uint256Slot.wrap(slot);
    }

    /**
     * @dev UDVT that represents a slot holding a int256.
     */
    type Int256Slot is bytes32;

    /**
     * @dev Cast an arbitrary slot to a Int256Slot.
     */
    function asInt256(bytes32 slot) internal pure returns (Int256Slot) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01bb0000, 1037618708923) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01bb0001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01bb0005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01bb6000, slot) }
        return Int256Slot.wrap(slot);
    }

    /**
     * @dev Load the value held at location `slot` in transient storage.
     */
    function tload(AddressSlot slot) internal view returns (address value) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01be0000, 1037618708926) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01be0001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01be0005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01be6000, slot) }
        assembly ("memory-safe") {
            value := tload(slot)
        }
    }

    /**
     * @dev Store `value` at location `slot` in transient storage.
     */
    function tstore(AddressSlot slot, address value) internal {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01bf0000, 1037618708927) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01bf0001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01bf0005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01bf6001, value) }
        assembly ("memory-safe") {
            tstore(slot, value)
        }
    }

    /**
     * @dev Load the value held at location `slot` in transient storage.
     */
    function tload(BooleanSlot slot) internal view returns (bool value) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01c00000, 1037618708928) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01c00001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01c00005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01c06000, slot) }
        assembly ("memory-safe") {
            value := tload(slot)
        }
    }

    /**
     * @dev Store `value` at location `slot` in transient storage.
     */
    function tstore(BooleanSlot slot, bool value) internal {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01c10000, 1037618708929) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01c10001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01c10005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01c16001, value) }
        assembly ("memory-safe") {
            tstore(slot, value)
        }
    }

    /**
     * @dev Load the value held at location `slot` in transient storage.
     */
    function tload(Bytes32Slot slot) internal view returns (bytes32 value) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01c20000, 1037618708930) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01c20001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01c20005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01c26000, slot) }
        assembly ("memory-safe") {
            value := tload(slot)
        }
    }

    /**
     * @dev Store `value` at location `slot` in transient storage.
     */
    function tstore(Bytes32Slot slot, bytes32 value) internal {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01c30000, 1037618708931) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01c30001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01c30005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01c36001, value) }
        assembly ("memory-safe") {
            tstore(slot, value)
        }
    }

    /**
     * @dev Load the value held at location `slot` in transient storage.
     */
    function tload(Uint256Slot slot) internal view returns (uint256 value) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01c40000, 1037618708932) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01c40001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01c40005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01c46000, slot) }
        assembly ("memory-safe") {
            value := tload(slot)
        }
    }

    /**
     * @dev Store `value` at location `slot` in transient storage.
     */
    function tstore(Uint256Slot slot, uint256 value) internal {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01c50000, 1037618708933) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01c50001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01c50005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01c56001, value) }
        assembly ("memory-safe") {
            tstore(slot, value)
        }
    }

    /**
     * @dev Load the value held at location `slot` in transient storage.
     */
    function tload(Int256Slot slot) internal view returns (int256 value) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01c60000, 1037618708934) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01c60001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01c60005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01c66000, slot) }
        assembly ("memory-safe") {
            value := tload(slot)
        }
    }

    /**
     * @dev Store `value` at location `slot` in transient storage.
     */
    function tstore(Int256Slot slot, int256 value) internal {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01c70000, 1037618708935) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01c70001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01c70005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01c76001, value) }
        assembly ("memory-safe") {
            tstore(slot, value)
        }
    }
}
