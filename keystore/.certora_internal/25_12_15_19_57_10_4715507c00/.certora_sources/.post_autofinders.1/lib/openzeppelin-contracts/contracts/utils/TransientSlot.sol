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
    function asAddress(bytes32 slot) internal pure returns (AddressSlot) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04390000, 1037618709561) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04390001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04390005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04396000, slot) }
        return AddressSlot.wrap(slot);
    }

    /**
     * @dev UDVT that represents a slot holding a bool.
     */
    type BooleanSlot is bytes32;

    /**
     * @dev Cast an arbitrary slot to a BooleanSlot.
     */
    function asBoolean(bytes32 slot) internal pure returns (BooleanSlot) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff043a0000, 1037618709562) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff043a0001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff043a0005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff043a6000, slot) }
        return BooleanSlot.wrap(slot);
    }

    /**
     * @dev UDVT that represents a slot holding a bytes32.
     */
    type Bytes32Slot is bytes32;

    /**
     * @dev Cast an arbitrary slot to a Bytes32Slot.
     */
    function asBytes32(bytes32 slot) internal pure returns (Bytes32Slot) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff043c0000, 1037618709564) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff043c0001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff043c0005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff043c6000, slot) }
        return Bytes32Slot.wrap(slot);
    }

    /**
     * @dev UDVT that represents a slot holding a uint256.
     */
    type Uint256Slot is bytes32;

    /**
     * @dev Cast an arbitrary slot to a Uint256Slot.
     */
    function asUint256(bytes32 slot) internal pure returns (Uint256Slot) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff043d0000, 1037618709565) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff043d0001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff043d0005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff043d6000, slot) }
        return Uint256Slot.wrap(slot);
    }

    /**
     * @dev UDVT that represents a slot holding a int256.
     */
    type Int256Slot is bytes32;

    /**
     * @dev Cast an arbitrary slot to a Int256Slot.
     */
    function asInt256(bytes32 slot) internal pure returns (Int256Slot) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff043b0000, 1037618709563) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff043b0001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff043b0005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff043b6000, slot) }
        return Int256Slot.wrap(slot);
    }

    /**
     * @dev Load the value held at location `slot` in transient storage.
     */
    function tload(AddressSlot slot) internal view returns (address value) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff043e0000, 1037618709566) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff043e0001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff043e0005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff043e6000, slot) }
        assembly ("memory-safe") {
            value := tload(slot)
        }
    }

    /**
     * @dev Store `value` at location `slot` in transient storage.
     */
    function tstore(AddressSlot slot, address value) internal {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff043f0000, 1037618709567) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff043f0001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff043f0005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff043f6001, value) }
        assembly ("memory-safe") {
            tstore(slot, value)
        }
    }

    /**
     * @dev Load the value held at location `slot` in transient storage.
     */
    function tload(BooleanSlot slot) internal view returns (bool value) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04400000, 1037618709568) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04400001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04400005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04406000, slot) }
        assembly ("memory-safe") {
            value := tload(slot)
        }
    }

    /**
     * @dev Store `value` at location `slot` in transient storage.
     */
    function tstore(BooleanSlot slot, bool value) internal {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04410000, 1037618709569) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04410001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04410005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04416001, value) }
        assembly ("memory-safe") {
            tstore(slot, value)
        }
    }

    /**
     * @dev Load the value held at location `slot` in transient storage.
     */
    function tload(Bytes32Slot slot) internal view returns (bytes32 value) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04420000, 1037618709570) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04420001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04420005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04426000, slot) }
        assembly ("memory-safe") {
            value := tload(slot)
        }
    }

    /**
     * @dev Store `value` at location `slot` in transient storage.
     */
    function tstore(Bytes32Slot slot, bytes32 value) internal {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04430000, 1037618709571) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04430001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04430005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04436001, value) }
        assembly ("memory-safe") {
            tstore(slot, value)
        }
    }

    /**
     * @dev Load the value held at location `slot` in transient storage.
     */
    function tload(Uint256Slot slot) internal view returns (uint256 value) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04440000, 1037618709572) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04440001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04440005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04446000, slot) }
        assembly ("memory-safe") {
            value := tload(slot)
        }
    }

    /**
     * @dev Store `value` at location `slot` in transient storage.
     */
    function tstore(Uint256Slot slot, uint256 value) internal {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04450000, 1037618709573) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04450001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04450005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04456001, value) }
        assembly ("memory-safe") {
            tstore(slot, value)
        }
    }

    /**
     * @dev Load the value held at location `slot` in transient storage.
     */
    function tload(Int256Slot slot) internal view returns (int256 value) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04460000, 1037618709574) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04460001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04460005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04466000, slot) }
        assembly ("memory-safe") {
            value := tload(slot)
        }
    }

    /**
     * @dev Store `value` at location `slot` in transient storage.
     */
    function tstore(Int256Slot slot, int256 value) internal {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04470000, 1037618709575) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04470001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04470005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04476001, value) }
        assembly ("memory-safe") {
            tstore(slot, value)
        }
    }
}
