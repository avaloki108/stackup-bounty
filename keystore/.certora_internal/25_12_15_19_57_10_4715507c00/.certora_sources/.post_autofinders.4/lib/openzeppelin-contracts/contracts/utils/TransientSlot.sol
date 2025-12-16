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
    function asAddress(bytes32 slot) internal pure returns (AddressSlot) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08ce0000, 1037618710734) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08ce0001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08ce0005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08ce6000, slot) }
        return AddressSlot.wrap(slot);
    }

    /**
     * @dev UDVT that represents a slot holding a bool.
     */
    type BooleanSlot is bytes32;

    /**
     * @dev Cast an arbitrary slot to a BooleanSlot.
     */
    function asBoolean(bytes32 slot) internal pure returns (BooleanSlot) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08cf0000, 1037618710735) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08cf0001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08cf0005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08cf6000, slot) }
        return BooleanSlot.wrap(slot);
    }

    /**
     * @dev UDVT that represents a slot holding a bytes32.
     */
    type Bytes32Slot is bytes32;

    /**
     * @dev Cast an arbitrary slot to a Bytes32Slot.
     */
    function asBytes32(bytes32 slot) internal pure returns (Bytes32Slot) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08d10000, 1037618710737) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08d10001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08d10005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08d16000, slot) }
        return Bytes32Slot.wrap(slot);
    }

    /**
     * @dev UDVT that represents a slot holding a uint256.
     */
    type Uint256Slot is bytes32;

    /**
     * @dev Cast an arbitrary slot to a Uint256Slot.
     */
    function asUint256(bytes32 slot) internal pure returns (Uint256Slot) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08d20000, 1037618710738) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08d20001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08d20005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08d26000, slot) }
        return Uint256Slot.wrap(slot);
    }

    /**
     * @dev UDVT that represents a slot holding a int256.
     */
    type Int256Slot is bytes32;

    /**
     * @dev Cast an arbitrary slot to a Int256Slot.
     */
    function asInt256(bytes32 slot) internal pure returns (Int256Slot) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08d00000, 1037618710736) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08d00001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08d00005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08d06000, slot) }
        return Int256Slot.wrap(slot);
    }

    /**
     * @dev Load the value held at location `slot` in transient storage.
     */
    function tload(AddressSlot slot) internal view returns (address value) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08d30000, 1037618710739) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08d30001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08d30005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08d36000, slot) }
        assembly ("memory-safe") {
            value := tload(slot)
        }
    }

    /**
     * @dev Store `value` at location `slot` in transient storage.
     */
    function tstore(AddressSlot slot, address value) internal {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08d40000, 1037618710740) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08d40001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08d40005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08d46001, value) }
        assembly ("memory-safe") {
            tstore(slot, value)
        }
    }

    /**
     * @dev Load the value held at location `slot` in transient storage.
     */
    function tload(BooleanSlot slot) internal view returns (bool value) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08d50000, 1037618710741) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08d50001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08d50005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08d56000, slot) }
        assembly ("memory-safe") {
            value := tload(slot)
        }
    }

    /**
     * @dev Store `value` at location `slot` in transient storage.
     */
    function tstore(BooleanSlot slot, bool value) internal {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08d60000, 1037618710742) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08d60001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08d60005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08d66001, value) }
        assembly ("memory-safe") {
            tstore(slot, value)
        }
    }

    /**
     * @dev Load the value held at location `slot` in transient storage.
     */
    function tload(Bytes32Slot slot) internal view returns (bytes32 value) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08d70000, 1037618710743) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08d70001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08d70005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08d76000, slot) }
        assembly ("memory-safe") {
            value := tload(slot)
        }
    }

    /**
     * @dev Store `value` at location `slot` in transient storage.
     */
    function tstore(Bytes32Slot slot, bytes32 value) internal {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08d80000, 1037618710744) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08d80001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08d80005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08d86001, value) }
        assembly ("memory-safe") {
            tstore(slot, value)
        }
    }

    /**
     * @dev Load the value held at location `slot` in transient storage.
     */
    function tload(Uint256Slot slot) internal view returns (uint256 value) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08d90000, 1037618710745) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08d90001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08d90005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08d96000, slot) }
        assembly ("memory-safe") {
            value := tload(slot)
        }
    }

    /**
     * @dev Store `value` at location `slot` in transient storage.
     */
    function tstore(Uint256Slot slot, uint256 value) internal {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08da0000, 1037618710746) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08da0001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08da0005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08da6001, value) }
        assembly ("memory-safe") {
            tstore(slot, value)
        }
    }

    /**
     * @dev Load the value held at location `slot` in transient storage.
     */
    function tload(Int256Slot slot) internal view returns (int256 value) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08db0000, 1037618710747) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08db0001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08db0005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08db6000, slot) }
        assembly ("memory-safe") {
            value := tload(slot)
        }
    }

    /**
     * @dev Store `value` at location `slot` in transient storage.
     */
    function tstore(Int256Slot slot, int256 value) internal {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08dc0000, 1037618710748) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08dc0001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08dc0005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08dc6001, value) }
        assembly ("memory-safe") {
            tstore(slot, value)
        }
    }
}
