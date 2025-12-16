// SPDX-License-Identifier: MIT
pragma solidity >=0.6.2 <0.9.0;

import {Vm} from "./Vm.sol";

struct FindData {
    uint256 slot;
    uint256 offsetLeft;
    uint256 offsetRight;
    bool found;
}

struct StdStorage {
    mapping(address => mapping(bytes4 => mapping(bytes32 => FindData))) finds;
    bytes32[] _keys;
    bytes4 _sig;
    uint256 _depth;
    address _target;
    bytes32 _set;
    bool _enable_packed_slots;
    bytes _calldata;
}

library stdStorageSafe {
    event SlotFound(address who, bytes4 fsig, bytes32 keysHash, uint256 slot);
    event WARNING_UninitedSlot(address who, uint256 slot);

    Vm private constant vm = Vm(address(uint160(uint256(keccak256("hevm cheat code")))));
    uint256 constant UINT256_MAX = 115792089237316195423570985008687907853269984665640564039457584007913129639935;

    function sigs(string memory sigStr) internal pure returns (bytes4) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff059d0000, 1037618709917) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff059d0001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff059d0005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff059d6000, sigStr) }
        return bytes4(keccak256(bytes(sigStr)));
    }

    function getCallParams(StdStorage storage self) internal view returns (bytes memory) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff059e0000, 1037618709918) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff059e0001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff059e0005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff059e6000, self.slot) }
        if (self._calldata.length == 0) {
            return flatten(self._keys);
        } else {
            return self._calldata;
        }
    }

    // Calls target contract with configured parameters
    function callTarget(StdStorage storage self) internal view returns (bool, bytes32) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05a00000, 1037618709920) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05a00001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05a00005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05a06000, self.slot) }
        bytes memory cald = abi.encodePacked(self._sig, getCallParams(self));
        (bool success, bytes memory rdat) = self._target.staticcall(cald);
        bytes32 result = bytesToBytes32(rdat, 32 * self._depth);

        return (success, result);
    }

    // Tries mutating slot value to determine if the targeted value is stored in it.
    // If current value is 0, then we are setting slot value to type(uint256).max
    // Otherwise, we set it to 0. That way, return value should always be affected.
    function checkSlotMutatesCall(StdStorage storage self, bytes32 slot) internal returns (bool) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05a10000, 1037618709921) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05a10001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05a10005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05a16001, slot) }
        bytes32 prevSlotValue = vm.load(self._target, slot);
        (bool success, bytes32 prevReturnValue) = callTarget(self);

        bytes32 testVal = prevReturnValue == bytes32(0) ? bytes32(UINT256_MAX) : bytes32(0);
        vm.store(self._target, slot, testVal);

        (, bytes32 newReturnValue) = callTarget(self);

        vm.store(self._target, slot, prevSlotValue);

        return (success && (prevReturnValue != newReturnValue));
    }

    // Tries setting one of the bits in slot to 1 until return value changes.
    // Index of resulted bit is an offset packed slot has from left/right side
    function findOffset(StdStorage storage self, bytes32 slot, bool left) internal returns (bool, uint256) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff059f0000, 1037618709919) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff059f0001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff059f0005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff059f6002, left) }
        for (uint256 offset = 0; offset < 256; offset++) {
            uint256 valueToPut = left ? (1 << (255 - offset)) : (1 << offset);
            vm.store(self._target, slot, bytes32(valueToPut));

            (bool success, bytes32 data) = callTarget(self);

            if (success && (uint256(data) > 0)) {
                return (true, offset);
            }
        }
        return (false, 0);
    }

    function findOffsets(StdStorage storage self, bytes32 slot) internal returns (bool, uint256, uint256) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05a20000, 1037618709922) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05a20001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05a20005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05a26001, slot) }
        bytes32 prevSlotValue = vm.load(self._target, slot);

        (bool foundLeft, uint256 offsetLeft) = findOffset(self, slot, true);
        (bool foundRight, uint256 offsetRight) = findOffset(self, slot, false);

        // `findOffset` may mutate slot value, so we are setting it to initial value
        vm.store(self._target, slot, prevSlotValue);
        return (foundLeft && foundRight, offsetLeft, offsetRight);
    }

    function find(StdStorage storage self) internal returns (FindData storage) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05a30000, 1037618709923) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05a30001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05a30005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05a36000, self.slot) }
        return find(self, true);
    }

    /// @notice find an arbitrary storage slot given a function sig, input data, address of the contract and a value to check against
    // slot complexity:
    //  if flat, will be bytes32(uint256(uint));
    //  if map, will be keccak256(abi.encode(key, uint(slot)));
    //  if deep map, will be keccak256(abi.encode(key1, keccak256(abi.encode(key0, uint(slot)))));
    //  if map struct, will be bytes32(uint256(keccak256(abi.encode(key1, keccak256(abi.encode(key0, uint(slot)))))) + structFieldDepth);
    function find(StdStorage storage self, bool _clear) internal returns (FindData storage) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05a40000, 1037618709924) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05a40001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05a40005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05a46001, _clear) }
        address who = self._target;
        bytes4 fsig = self._sig;
        uint256 field_depth = self._depth;
        bytes memory params = getCallParams(self);

        // calldata to test against
        if (self.finds[who][fsig][keccak256(abi.encodePacked(params, field_depth))].found) {
            if (_clear) {
                clear(self);
            }
            return self.finds[who][fsig][keccak256(abi.encodePacked(params, field_depth))];
        }
        vm.record();
        (, bytes32 callResult) = callTarget(self);
        (bytes32[] memory reads,) = vm.accesses(address(who));

        if (reads.length == 0) {
            revert("stdStorage find(StdStorage): No storage use detected for target.");
        } else {
            for (uint256 i = reads.length; --i >= 0;) {
                bytes32 prev = vm.load(who, reads[i]);
                if (prev == bytes32(0)) {
                    emit WARNING_UninitedSlot(who, uint256(reads[i]));
                }

                if (!checkSlotMutatesCall(self, reads[i])) {
                    continue;
                }

                (uint256 offsetLeft, uint256 offsetRight) = (0, 0);

                if (self._enable_packed_slots) {
                    bool found;
                    (found, offsetLeft, offsetRight) = findOffsets(self, reads[i]);
                    if (!found) {
                        continue;
                    }
                }

                // Check that value between found offsets is equal to the current call result
                uint256 curVal = (uint256(prev) & getMaskByOffsets(offsetLeft, offsetRight)) >> offsetRight;

                if (uint256(callResult) != curVal) {
                    continue;
                }

                emit SlotFound(who, fsig, keccak256(abi.encodePacked(params, field_depth)), uint256(reads[i]));
                self.finds[who][fsig][keccak256(abi.encodePacked(params, field_depth))] =
                    FindData(uint256(reads[i]), offsetLeft, offsetRight, true);
                break;
            }
        }

        require(
            self.finds[who][fsig][keccak256(abi.encodePacked(params, field_depth))].found,
            "stdStorage find(StdStorage): Slot(s) not found."
        );

        if (_clear) {
            clear(self);
        }
        return self.finds[who][fsig][keccak256(abi.encodePacked(params, field_depth))];
    }

    function target(StdStorage storage self, address _target) internal returns (StdStorage storage) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05a50000, 1037618709925) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05a50001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05a50005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05a56001, _target) }
        self._target = _target;
        return self;
    }

    function sig(StdStorage storage self, bytes4 _sig) internal returns (StdStorage storage) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05a60000, 1037618709926) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05a60001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05a60005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05a66001, _sig) }
        self._sig = _sig;
        return self;
    }

    function sig(StdStorage storage self, string memory _sig) internal returns (StdStorage storage) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05a70000, 1037618709927) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05a70001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05a70005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05a76001, _sig) }
        self._sig = sigs(_sig);
        return self;
    }

    function with_calldata(StdStorage storage self, bytes memory _calldata) internal returns (StdStorage storage) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05a80000, 1037618709928) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05a80001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05a80005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05a86001, _calldata) }
        self._calldata = _calldata;
        return self;
    }

    function with_key(StdStorage storage self, address who) internal returns (StdStorage storage) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05a90000, 1037618709929) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05a90001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05a90005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05a96001, who) }
        self._keys.push(bytes32(uint256(uint160(who))));
        return self;
    }

    function with_key(StdStorage storage self, uint256 amt) internal returns (StdStorage storage) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05aa0000, 1037618709930) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05aa0001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05aa0005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05aa6001, amt) }
        self._keys.push(bytes32(amt));
        return self;
    }

    function with_key(StdStorage storage self, bytes32 key) internal returns (StdStorage storage) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05ab0000, 1037618709931) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05ab0001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05ab0005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05ab6001, key) }
        self._keys.push(key);
        return self;
    }

    function enable_packed_slots(StdStorage storage self) internal returns (StdStorage storage) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05ac0000, 1037618709932) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05ac0001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05ac0005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05ac6000, self.slot) }
        self._enable_packed_slots = true;
        return self;
    }

    function depth(StdStorage storage self, uint256 _depth) internal returns (StdStorage storage) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05b30000, 1037618709939) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05b30001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05b30005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05b36001, _depth) }
        self._depth = _depth;
        return self;
    }

    function read(StdStorage storage self) private returns (bytes memory) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05b20000, 1037618709938) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05b20001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05b20005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05b26000, self.slot) }
        FindData storage data = find(self, false);
        uint256 mask = getMaskByOffsets(data.offsetLeft, data.offsetRight);
        uint256 value = (uint256(vm.load(self._target, bytes32(data.slot))) & mask) >> data.offsetRight;
        clear(self);
        return abi.encode(value);
    }

    function read_bytes32(StdStorage storage self) internal returns (bytes32) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05b10000, 1037618709937) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05b10001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05b10005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05b16000, self.slot) }
        return abi.decode(read(self), (bytes32));
    }

    function read_bool(StdStorage storage self) internal returns (bool) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05b40000, 1037618709940) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05b40001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05b40005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05b46000, self.slot) }
        int256 v = read_int(self);
        if (v == 0) return false;
        if (v == 1) return true;
        revert("stdStorage read_bool(StdStorage): Cannot decode. Make sure you are reading a bool.");
    }

    function read_address(StdStorage storage self) internal returns (address) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05b50000, 1037618709941) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05b50001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05b50005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05b56000, self.slot) }
        return abi.decode(read(self), (address));
    }

    function read_uint(StdStorage storage self) internal returns (uint256) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05b60000, 1037618709942) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05b60001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05b60005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05b66000, self.slot) }
        return abi.decode(read(self), (uint256));
    }

    function read_int(StdStorage storage self) internal returns (int256) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05b70000, 1037618709943) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05b70001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05b70005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05b76000, self.slot) }
        return abi.decode(read(self), (int256));
    }

    function parent(StdStorage storage self) internal returns (uint256, bytes32) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05b80000, 1037618709944) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05b80001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05b80005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05b86000, self.slot) }
        address who = self._target;
        uint256 field_depth = self._depth;
        vm.startMappingRecording();
        uint256 child = find(self, true).slot - field_depth;
        (bool found, bytes32 key, bytes32 parent_slot) = vm.getMappingKeyAndParentOf(who, bytes32(child));
        if (!found) {
            revert(
                "stdStorage read_bool(StdStorage): Cannot find parent. Make sure you give a slot and startMappingRecording() has been called."
            );
        }
        return (uint256(parent_slot), key);
    }

    function root(StdStorage storage self) internal returns (uint256) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05b90000, 1037618709945) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05b90001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05b90005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05b96000, self.slot) }
        address who = self._target;
        uint256 field_depth = self._depth;
        vm.startMappingRecording();
        uint256 child = find(self, true).slot - field_depth;
        bool found;
        bytes32 root_slot;
        bytes32 parent_slot;
        (found,, parent_slot) = vm.getMappingKeyAndParentOf(who, bytes32(child));
        if (!found) {
            revert(
                "stdStorage read_bool(StdStorage): Cannot find parent. Make sure you give a slot and startMappingRecording() has been called."
            );
        }
        while (found) {
            root_slot = parent_slot;
            (found,, parent_slot) = vm.getMappingKeyAndParentOf(who, bytes32(root_slot));
        }
        return uint256(root_slot);
    }

    function bytesToBytes32(bytes memory b, uint256 offset) private pure returns (bytes32) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05ba0000, 1037618709946) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05ba0001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05ba0005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05ba6001, offset) }
        bytes32 out;

        uint256 max = b.length > 32 ? 32 : b.length;
        for (uint256 i = 0; i < max; i++) {
            out |= bytes32(b[offset + i] & 0xFF) >> (i * 8);
        }
        return out;
    }

    function flatten(bytes32[] memory b) private pure returns (bytes memory) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05ae0000, 1037618709934) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05ae0001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05ae0005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05ae6000, b) }
        bytes memory result = new bytes(b.length * 32);
        for (uint256 i = 0; i < b.length; i++) {
            bytes32 k = b[i];
            /// @solidity memory-safe-assembly
            assembly {
                mstore(add(result, add(32, mul(32, i))), k)
            }
        }

        return result;
    }

    function clear(StdStorage storage self) internal {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05af0000, 1037618709935) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05af0001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05af0005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05af6000, self.slot) }
        delete self._target;
        delete self._sig;
        delete self._keys;
        delete self._depth;
        delete self._enable_packed_slots;
        delete self._calldata;
    }

    // Returns mask which contains non-zero bits for values between `offsetLeft` and `offsetRight`
    // (slotValue & mask) >> offsetRight will be the value of the given packed variable
    function getMaskByOffsets(uint256 offsetLeft, uint256 offsetRight) internal pure returns (uint256 mask) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05b00000, 1037618709936) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05b00001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05b00005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05b06001, offsetRight) }
        // mask = ((1 << (256 - (offsetRight + offsetLeft))) - 1) << offsetRight;
        // using assembly because (1 << 256) causes overflow
        assembly {
            mask := shl(offsetRight, sub(shl(sub(256, add(offsetRight, offsetLeft)), 1), 1))
        }
    }

    // Returns slot value with updated packed variable.
    function getUpdatedSlotValue(bytes32 curValue, uint256 varValue, uint256 offsetLeft, uint256 offsetRight)
        internal
        pure
        returns (bytes32 newValue)
    {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05ad0000, 1037618709933) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05ad0001, 4) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05ad0005, 585) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05ad6003, offsetRight) }
        return bytes32((uint256(curValue) & ~getMaskByOffsets(offsetLeft, offsetRight)) | (varValue << offsetRight));
    }
}

library stdStorage {
    Vm private constant vm = Vm(address(uint160(uint256(keccak256("hevm cheat code")))));

    function sigs(string memory sigStr) internal pure returns (bytes4) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05840000, 1037618709892) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05840001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05840005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05846000, sigStr) }
        return stdStorageSafe.sigs(sigStr);
    }

    function find(StdStorage storage self) internal returns (uint256) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05850000, 1037618709893) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05850001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05850005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05856000, self.slot) }
        return find(self, true);
    }

    function find(StdStorage storage self, bool _clear) internal returns (uint256) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05870000, 1037618709895) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05870001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05870005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05876001, _clear) }
        return stdStorageSafe.find(self, _clear).slot;
    }

    function target(StdStorage storage self, address _target) internal returns (StdStorage storage) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05880000, 1037618709896) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05880001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05880005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05886001, _target) }
        return stdStorageSafe.target(self, _target);
    }

    function sig(StdStorage storage self, bytes4 _sig) internal returns (StdStorage storage) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05860000, 1037618709894) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05860001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05860005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05866001, _sig) }
        return stdStorageSafe.sig(self, _sig);
    }

    function sig(StdStorage storage self, string memory _sig) internal returns (StdStorage storage) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05890000, 1037618709897) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05890001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05890005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05896001, _sig) }
        return stdStorageSafe.sig(self, _sig);
    }

    function with_key(StdStorage storage self, address who) internal returns (StdStorage storage) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff058a0000, 1037618709898) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff058a0001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff058a0005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff058a6001, who) }
        return stdStorageSafe.with_key(self, who);
    }

    function with_key(StdStorage storage self, uint256 amt) internal returns (StdStorage storage) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff058b0000, 1037618709899) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff058b0001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff058b0005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff058b6001, amt) }
        return stdStorageSafe.with_key(self, amt);
    }

    function with_key(StdStorage storage self, bytes32 key) internal returns (StdStorage storage) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff058c0000, 1037618709900) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff058c0001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff058c0005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff058c6001, key) }
        return stdStorageSafe.with_key(self, key);
    }

    function with_calldata(StdStorage storage self, bytes memory _calldata) internal returns (StdStorage storage) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff058d0000, 1037618709901) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff058d0001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff058d0005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff058d6001, _calldata) }
        return stdStorageSafe.with_calldata(self, _calldata);
    }

    function enable_packed_slots(StdStorage storage self) internal returns (StdStorage storage) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff058e0000, 1037618709902) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff058e0001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff058e0005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff058e6000, self.slot) }
        return stdStorageSafe.enable_packed_slots(self);
    }

    function depth(StdStorage storage self, uint256 _depth) internal returns (StdStorage storage) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff058f0000, 1037618709903) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff058f0001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff058f0005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff058f6001, _depth) }
        return stdStorageSafe.depth(self, _depth);
    }

    function clear(StdStorage storage self) internal {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05900000, 1037618709904) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05900001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05900005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05906000, self.slot) }
        stdStorageSafe.clear(self);
    }

    function checked_write(StdStorage storage self, address who) internal {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05910000, 1037618709905) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05910001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05910005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05916001, who) }
        checked_write(self, bytes32(uint256(uint160(who))));
    }

    function checked_write(StdStorage storage self, uint256 amt) internal {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05920000, 1037618709906) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05920001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05920005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05926001, amt) }
        checked_write(self, bytes32(amt));
    }

    function checked_write_int(StdStorage storage self, int256 val) internal {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05930000, 1037618709907) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05930001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05930005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05936001, val) }
        checked_write(self, bytes32(uint256(val)));
    }

    function checked_write(StdStorage storage self, bool write) internal {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff059a0000, 1037618709914) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff059a0001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff059a0005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff059a6001, write) }
        bytes32 t;
        /// @solidity memory-safe-assembly
        assembly {
            t := write
        }
        checked_write(self, t);
    }

    function checked_write(StdStorage storage self, bytes32 set) internal {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05990000, 1037618709913) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05990001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05990005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05996001, set) }
        address who = self._target;
        bytes4 fsig = self._sig;
        uint256 field_depth = self._depth;
        bytes memory params = stdStorageSafe.getCallParams(self);

        if (!self.finds[who][fsig][keccak256(abi.encodePacked(params, field_depth))].found) {
            find(self, false);
        }
        FindData storage data = self.finds[who][fsig][keccak256(abi.encodePacked(params, field_depth))];
        if ((data.offsetLeft + data.offsetRight) > 0) {
            uint256 maxVal = 2 ** (256 - (data.offsetLeft + data.offsetRight));
            require(
                uint256(set) < maxVal,
                string(
                    abi.encodePacked(
                        "stdStorage find(StdStorage): Packed slot. We can't fit value greater than ",
                        vm.toString(maxVal)
                    )
                )
            );
        }
        bytes32 curVal = vm.load(who, bytes32(data.slot));
        bytes32 valToSet = stdStorageSafe.getUpdatedSlotValue(curVal, uint256(set), data.offsetLeft, data.offsetRight);

        vm.store(who, bytes32(data.slot), valToSet);

        (bool success, bytes32 callResult) = stdStorageSafe.callTarget(self);

        if (!success || callResult != set) {
            vm.store(who, bytes32(data.slot), curVal);
            revert("stdStorage find(StdStorage): Failed to write value.");
        }
        clear(self);
    }

    function read_bytes32(StdStorage storage self) internal returns (bytes32) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05980000, 1037618709912) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05980001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05980005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05986000, self.slot) }
        return stdStorageSafe.read_bytes32(self);
    }

    function read_bool(StdStorage storage self) internal returns (bool) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff059b0000, 1037618709915) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff059b0001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff059b0005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff059b6000, self.slot) }
        return stdStorageSafe.read_bool(self);
    }

    function read_address(StdStorage storage self) internal returns (address) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff059c0000, 1037618709916) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff059c0001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff059c0005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff059c6000, self.slot) }
        return stdStorageSafe.read_address(self);
    }

    function read_uint(StdStorage storage self) internal returns (uint256) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05950000, 1037618709909) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05950001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05950005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05956000, self.slot) }
        return stdStorageSafe.read_uint(self);
    }

    function read_int(StdStorage storage self) internal returns (int256) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05960000, 1037618709910) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05960001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05960005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05966000, self.slot) }
        return stdStorageSafe.read_int(self);
    }

    function parent(StdStorage storage self) internal returns (uint256, bytes32) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05970000, 1037618709911) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05970001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05970005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05976000, self.slot) }
        return stdStorageSafe.parent(self);
    }

    function root(StdStorage storage self) internal returns (uint256) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05940000, 1037618709908) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05940001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05940005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05946000, self.slot) }
        return stdStorageSafe.root(self);
    }
}
