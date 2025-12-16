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

    function sigs(string memory sigStr) internal pure returns (bytes4) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0cfa0000, 1037618711802) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0cfa0001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0cfa0005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0cfa6000, sigStr) }
        return bytes4(keccak256(bytes(sigStr)));
    }

    function getCallParams(StdStorage storage self) internal view returns (bytes memory) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0cfb0000, 1037618711803) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0cfb0001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0cfb0005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0cfb6000, self.slot) }
        if (self._calldata.length == 0) {
            return flatten(self._keys);
        } else {
            return self._calldata;
        }
    }

    // Calls target contract with configured parameters
    function callTarget(StdStorage storage self) internal view returns (bool, bytes32) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0cfd0000, 1037618711805) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0cfd0001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0cfd0005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0cfd6000, self.slot) }
        bytes memory cald = abi.encodePacked(self._sig, getCallParams(self));assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000100cd,0)}
        (bool success, bytes memory rdat) = self._target.staticcall(cald);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000100ce,0)}
        bytes32 result = bytesToBytes32(rdat, 32 * self._depth);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000000cf,result)}

        return (success, result);
    }

    // Tries mutating slot value to determine if the targeted value is stored in it.
    // If current value is 0, then we are setting slot value to type(uint256).max
    // Otherwise, we set it to 0. That way, return value should always be affected.
    function checkSlotMutatesCall(StdStorage storage self, bytes32 slot) internal returns (bool) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0cfe0000, 1037618711806) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0cfe0001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0cfe0005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0cfe6001, slot) }
        bytes32 prevSlotValue = vm.load(self._target, slot);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000000d0,prevSlotValue)}
        (bool success, bytes32 prevReturnValue) = callTarget(self);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000100d1,0)}

        bytes32 testVal = prevReturnValue == bytes32(0) ? bytes32(UINT256_MAX) : bytes32(0);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000000d2,testVal)}
        vm.store(self._target, slot, testVal);

        (, bytes32 newReturnValue) = callTarget(self);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000100d3,0)}

        vm.store(self._target, slot, prevSlotValue);

        return (success && (prevReturnValue != newReturnValue));
    }

    // Tries setting one of the bits in slot to 1 until return value changes.
    // Index of resulted bit is an offset packed slot has from left/right side
    function findOffset(StdStorage storage self, bytes32 slot, bool left) internal returns (bool, uint256) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0cfc0000, 1037618711804) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0cfc0001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0cfc0005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0cfc6002, left) }
        for (uint256 offset = 0; offset < 256; offset++) {
            uint256 valueToPut = left ? (1 << (255 - offset)) : (1 << offset);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000000fe,valueToPut)}
            vm.store(self._target, slot, bytes32(valueToPut));

            (bool success, bytes32 data) = callTarget(self);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000100ff,0)}

            if (success && (uint256(data) > 0)) {
                return (true, offset);
            }
        }
        return (false, 0);
    }

    function findOffsets(StdStorage storage self, bytes32 slot) internal returns (bool, uint256, uint256) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0cff0000, 1037618711807) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0cff0001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0cff0005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0cff6001, slot) }
        bytes32 prevSlotValue = vm.load(self._target, slot);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000000d4,prevSlotValue)}

        (bool foundLeft, uint256 offsetLeft) = findOffset(self, slot, true);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000100d5,0)}
        (bool foundRight, uint256 offsetRight) = findOffset(self, slot, false);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000100d6,0)}

        // `findOffset` may mutate slot value, so we are setting it to initial value
        vm.store(self._target, slot, prevSlotValue);
        return (foundLeft && foundRight, offsetLeft, offsetRight);
    }

    function find(StdStorage storage self) internal returns (FindData storage) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0d000000, 1037618711808) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0d000001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0d000005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0d006000, self.slot) }
        return find(self, true);
    }

    /// @notice find an arbitrary storage slot given a function sig, input data, address of the contract and a value to check against
    // slot complexity:
    //  if flat, will be bytes32(uint256(uint));
    //  if map, will be keccak256(abi.encode(key, uint(slot)));
    //  if deep map, will be keccak256(abi.encode(key1, keccak256(abi.encode(key0, uint(slot)))));
    //  if map struct, will be bytes32(uint256(keccak256(abi.encode(key1, keccak256(abi.encode(key0, uint(slot)))))) + structFieldDepth);
    function find(StdStorage storage self, bool _clear) internal returns (FindData storage) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0d010000, 1037618711809) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0d010001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0d010005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0d016001, _clear) }
        address who = self._target;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000000d7,who)}
        bytes4 fsig = self._sig;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000000d8,fsig)}
        uint256 field_depth = self._depth;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000000d9,field_depth)}
        bytes memory params = getCallParams(self);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000100da,0)}

        // calldata to test against
        if (self.finds[who][fsig][keccak256(abi.encodePacked(params, field_depth))].found) {
            if (_clear) {
                clear(self);
            }
            return self.finds[who][fsig][keccak256(abi.encodePacked(params, field_depth))];
        }
        vm.record();
        (, bytes32 callResult) = callTarget(self);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000100db,0)}
        (bytes32[] memory reads,) = vm.accesses(address(who));assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000100dc,0)}

        if (reads.length == 0) {
            revert("stdStorage find(StdStorage): No storage use detected for target.");
        } else {
            for (uint256 i = reads.length; --i >= 0;) {
                bytes32 prev = vm.load(who, reads[i]);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000104,prev)}
                if (prev == bytes32(0)) {
                    emit WARNING_UninitedSlot(who, uint256(reads[i]));
                }

                if (!checkSlotMutatesCall(self, reads[i])) {
                    continue;
                }

                (uint256 offsetLeft, uint256 offsetRight) = (0, 0);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00010105,0)}

                if (self._enable_packed_slots) {
                    bool found;
                    (found, offsetLeft, offsetRight) = findOffsets(self, reads[i]);
                    if (!found) {
                        continue;
                    }
                }

                // Check that value between found offsets is equal to the current call result
                uint256 curVal = (uint256(prev) & getMaskByOffsets(offsetLeft, offsetRight)) >> offsetRight;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000106,curVal)}

                if (uint256(callResult) != curVal) {
                    continue;
                }

                emit SlotFound(who, fsig, keccak256(abi.encodePacked(params, field_depth)), uint256(reads[i]));
                self.finds[who][fsig][keccak256(abi.encodePacked(params, field_depth))] =
                    FindData(uint256(reads[i]), offsetLeft, offsetRight, true);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00020107,0)}
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

    function target(StdStorage storage self, address _target) internal returns (StdStorage storage) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0d020000, 1037618711810) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0d020001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0d020005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0d026001, _target) }
        self._target = _target;address certora_local247 = self._target;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000000f7,certora_local247)}
        return self;
    }

    function sig(StdStorage storage self, bytes4 _sig) internal returns (StdStorage storage) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0d030000, 1037618711811) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0d030001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0d030005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0d036001, _sig) }
        self._sig = _sig;bytes4 certora_local248 = self._sig;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000000f8,certora_local248)}
        return self;
    }

    function sig(StdStorage storage self, string memory _sig) internal returns (StdStorage storage) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0d040000, 1037618711812) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0d040001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0d040005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0d046001, _sig) }
        self._sig = sigs(_sig);bytes4 certora_local249 = self._sig;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000000f9,certora_local249)}
        return self;
    }

    function with_calldata(StdStorage storage self, bytes memory _calldata) internal returns (StdStorage storage) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0d050000, 1037618711813) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0d050001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0d050005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0d056001, _calldata) }
        self._calldata = _calldata;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000200fa,0)}
        return self;
    }

    function with_key(StdStorage storage self, address who) internal returns (StdStorage storage) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0d060000, 1037618711814) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0d060001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0d060005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0d066001, who) }
        self._keys.push(bytes32(uint256(uint160(who))));
        return self;
    }

    function with_key(StdStorage storage self, uint256 amt) internal returns (StdStorage storage) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0d070000, 1037618711815) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0d070001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0d070005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0d076001, amt) }
        self._keys.push(bytes32(amt));
        return self;
    }

    function with_key(StdStorage storage self, bytes32 key) internal returns (StdStorage storage) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0d080000, 1037618711816) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0d080001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0d080005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0d086001, key) }
        self._keys.push(key);
        return self;
    }

    function enable_packed_slots(StdStorage storage self) internal returns (StdStorage storage) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0d090000, 1037618711817) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0d090001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0d090005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0d096000, self.slot) }
        self._enable_packed_slots = true;bool certora_local251 = self._enable_packed_slots;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000000fb,certora_local251)}
        return self;
    }

    function depth(StdStorage storage self, uint256 _depth) internal returns (StdStorage storage) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0d100000, 1037618711824) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0d100001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0d100005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0d106001, _depth) }
        self._depth = _depth;uint256 certora_local252 = self._depth;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000000fc,certora_local252)}
        return self;
    }

    function read(StdStorage storage self) private returns (bytes memory) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0d0f0000, 1037618711823) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0d0f0001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0d0f0005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0d0f6000, self.slot) }
        FindData storage data = find(self, false);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000100dd,0)}
        uint256 mask = getMaskByOffsets(data.offsetLeft, data.offsetRight);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000000de,mask)}
        uint256 value = (uint256(vm.load(self._target, bytes32(data.slot))) & mask) >> data.offsetRight;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000000df,value)}
        clear(self);
        return abi.encode(value);
    }

    function read_bytes32(StdStorage storage self) internal returns (bytes32) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0d0e0000, 1037618711822) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0d0e0001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0d0e0005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0d0e6000, self.slot) }
        return abi.decode(read(self), (bytes32));
    }

    function read_bool(StdStorage storage self) internal returns (bool) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0d110000, 1037618711825) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0d110001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0d110005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0d116000, self.slot) }
        int256 v = read_int(self);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000000e0,v)}
        if (v == 0) return false;
        if (v == 1) return true;
        revert("stdStorage read_bool(StdStorage): Cannot decode. Make sure you are reading a bool.");
    }

    function read_address(StdStorage storage self) internal returns (address) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0d120000, 1037618711826) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0d120001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0d120005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0d126000, self.slot) }
        return abi.decode(read(self), (address));
    }

    function read_uint(StdStorage storage self) internal returns (uint256) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0d130000, 1037618711827) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0d130001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0d130005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0d136000, self.slot) }
        return abi.decode(read(self), (uint256));
    }

    function read_int(StdStorage storage self) internal returns (int256) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0d140000, 1037618711828) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0d140001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0d140005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0d146000, self.slot) }
        return abi.decode(read(self), (int256));
    }

    function parent(StdStorage storage self) internal returns (uint256, bytes32) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0d150000, 1037618711829) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0d150001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0d150005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0d156000, self.slot) }
        address who = self._target;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000000e1,who)}
        uint256 field_depth = self._depth;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000000e2,field_depth)}
        vm.startMappingRecording();
        uint256 child = find(self, true).slot - field_depth;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000000e3,child)}
        (bool found, bytes32 key, bytes32 parent_slot) = vm.getMappingKeyAndParentOf(who, bytes32(child));assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000100e4,0)}
        if (!found) {
            revert(
                "stdStorage read_bool(StdStorage): Cannot find parent. Make sure you give a slot and startMappingRecording() has been called."
            );
        }
        return (uint256(parent_slot), key);
    }

    function root(StdStorage storage self) internal returns (uint256) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0d160000, 1037618711830) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0d160001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0d160005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0d166000, self.slot) }
        address who = self._target;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000000e5,who)}
        uint256 field_depth = self._depth;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000000e6,field_depth)}
        vm.startMappingRecording();
        uint256 child = find(self, true).slot - field_depth;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000000e7,child)}
        bool found;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000000e8,found)}
        bytes32 root_slot;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000000e9,root_slot)}
        bytes32 parent_slot;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000000ea,parent_slot)}
        (found,, parent_slot) = vm.getMappingKeyAndParentOf(who, bytes32(child));assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000200fd,0)}
        if (!found) {
            revert(
                "stdStorage read_bool(StdStorage): Cannot find parent. Make sure you give a slot and startMappingRecording() has been called."
            );
        }
        while (found) {
            root_slot = parent_slot;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000101,root_slot)}
            (found,, parent_slot) = vm.getMappingKeyAndParentOf(who, bytes32(root_slot));assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00020102,0)}
        }
        return uint256(root_slot);
    }

    function bytesToBytes32(bytes memory b, uint256 offset) private pure returns (bytes32) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0d170000, 1037618711831) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0d170001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0d170005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0d176001, offset) }
        bytes32 out;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000000eb,out)}

        uint256 max = b.length > 32 ? 32 : b.length;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000000ec,max)}
        for (uint256 i = 0; i < max; i++) {
            out |= bytes32(b[offset + i] & 0xFF) >> (i * 8);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000103,out)}
        }
        return out;
    }

    function flatten(bytes32[] memory b) private pure returns (bytes memory) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0d0b0000, 1037618711819) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0d0b0001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0d0b0005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0d0b6000, b) }
        bytes memory result = new bytes(b.length * 32);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000100ed,0)}
        for (uint256 i = 0; i < b.length; i++) {
            bytes32 k = b[i];assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000100,k)}
            /// @solidity memory-safe-assembly
            assembly {
                mstore(add(result, add(32, mul(32, i))), k)
            }
        }

        return result;
    }

    function clear(StdStorage storage self) internal {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0d0c0000, 1037618711820) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0d0c0001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0d0c0005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0d0c6000, self.slot) }
        delete self._target;
        delete self._sig;
        delete self._keys;
        delete self._depth;
        delete self._enable_packed_slots;
        delete self._calldata;
    }

    // Returns mask which contains non-zero bits for values between `offsetLeft` and `offsetRight`
    // (slotValue & mask) >> offsetRight will be the value of the given packed variable
    function getMaskByOffsets(uint256 offsetLeft, uint256 offsetRight) internal pure returns (uint256 mask) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0d0d0000, 1037618711821) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0d0d0001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0d0d0005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0d0d6001, offsetRight) }
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
    {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0d0a0000, 1037618711818) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0d0a0001, 4) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0d0a0005, 585) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0d0a6003, offsetRight) }
        return bytes32((uint256(curValue) & ~getMaskByOffsets(offsetLeft, offsetRight)) | (varValue << offsetRight));
    }
}

library stdStorage {
    Vm private constant vm = Vm(address(uint160(uint256(keccak256("hevm cheat code")))));

    function sigs(string memory sigStr) internal pure returns (bytes4) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ce10000, 1037618711777) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ce10001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ce10005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ce16000, sigStr) }
        return stdStorageSafe.sigs(sigStr);
    }

    function find(StdStorage storage self) internal returns (uint256) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ce20000, 1037618711778) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ce20001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ce20005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ce26000, self.slot) }
        return find(self, true);
    }

    function find(StdStorage storage self, bool _clear) internal returns (uint256) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ce40000, 1037618711780) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ce40001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ce40005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ce46001, _clear) }
        return stdStorageSafe.find(self, _clear).slot;
    }

    function target(StdStorage storage self, address _target) internal returns (StdStorage storage) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ce50000, 1037618711781) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ce50001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ce50005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ce56001, _target) }
        return stdStorageSafe.target(self, _target);
    }

    function sig(StdStorage storage self, bytes4 _sig) internal returns (StdStorage storage) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ce30000, 1037618711779) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ce30001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ce30005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ce36001, _sig) }
        return stdStorageSafe.sig(self, _sig);
    }

    function sig(StdStorage storage self, string memory _sig) internal returns (StdStorage storage) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ce60000, 1037618711782) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ce60001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ce60005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ce66001, _sig) }
        return stdStorageSafe.sig(self, _sig);
    }

    function with_key(StdStorage storage self, address who) internal returns (StdStorage storage) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ce70000, 1037618711783) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ce70001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ce70005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ce76001, who) }
        return stdStorageSafe.with_key(self, who);
    }

    function with_key(StdStorage storage self, uint256 amt) internal returns (StdStorage storage) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ce80000, 1037618711784) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ce80001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ce80005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ce86001, amt) }
        return stdStorageSafe.with_key(self, amt);
    }

    function with_key(StdStorage storage self, bytes32 key) internal returns (StdStorage storage) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ce90000, 1037618711785) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ce90001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ce90005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ce96001, key) }
        return stdStorageSafe.with_key(self, key);
    }

    function with_calldata(StdStorage storage self, bytes memory _calldata) internal returns (StdStorage storage) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0cea0000, 1037618711786) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0cea0001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0cea0005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0cea6001, _calldata) }
        return stdStorageSafe.with_calldata(self, _calldata);
    }

    function enable_packed_slots(StdStorage storage self) internal returns (StdStorage storage) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ceb0000, 1037618711787) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ceb0001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ceb0005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ceb6000, self.slot) }
        return stdStorageSafe.enable_packed_slots(self);
    }

    function depth(StdStorage storage self, uint256 _depth) internal returns (StdStorage storage) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0cec0000, 1037618711788) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0cec0001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0cec0005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0cec6001, _depth) }
        return stdStorageSafe.depth(self, _depth);
    }

    function clear(StdStorage storage self) internal {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ced0000, 1037618711789) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ced0001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ced0005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ced6000, self.slot) }
        stdStorageSafe.clear(self);
    }

    function checked_write(StdStorage storage self, address who) internal {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0cee0000, 1037618711790) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0cee0001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0cee0005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0cee6001, who) }
        checked_write(self, bytes32(uint256(uint160(who))));
    }

    function checked_write(StdStorage storage self, uint256 amt) internal {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0cef0000, 1037618711791) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0cef0001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0cef0005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0cef6001, amt) }
        checked_write(self, bytes32(amt));
    }

    function checked_write_int(StdStorage storage self, int256 val) internal {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0cf00000, 1037618711792) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0cf00001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0cf00005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0cf06001, val) }
        checked_write(self, bytes32(uint256(val)));
    }

    function checked_write(StdStorage storage self, bool write) internal {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0cf70000, 1037618711799) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0cf70001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0cf70005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0cf76001, write) }
        bytes32 t;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000000ee,t)}
        /// @solidity memory-safe-assembly
        assembly {
            t := write
        }
        checked_write(self, t);
    }

    function checked_write(StdStorage storage self, bytes32 set) internal {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0cf60000, 1037618711798) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0cf60001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0cf60005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0cf66001, set) }
        address who = self._target;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000000ef,who)}
        bytes4 fsig = self._sig;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000000f0,fsig)}
        uint256 field_depth = self._depth;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000000f1,field_depth)}
        bytes memory params = stdStorageSafe.getCallParams(self);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000100f2,0)}

        if (!self.finds[who][fsig][keccak256(abi.encodePacked(params, field_depth))].found) {
            find(self, false);
        }
        FindData storage data = self.finds[who][fsig][keccak256(abi.encodePacked(params, field_depth))];assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000100f3,0)}
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
        bytes32 curVal = vm.load(who, bytes32(data.slot));assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000000f4,curVal)}
        bytes32 valToSet = stdStorageSafe.getUpdatedSlotValue(curVal, uint256(set), data.offsetLeft, data.offsetRight);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000000f5,valToSet)}

        vm.store(who, bytes32(data.slot), valToSet);

        (bool success, bytes32 callResult) = stdStorageSafe.callTarget(self);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000100f6,0)}

        if (!success || callResult != set) {
            vm.store(who, bytes32(data.slot), curVal);
            revert("stdStorage find(StdStorage): Failed to write value.");
        }
        clear(self);
    }

    function read_bytes32(StdStorage storage self) internal returns (bytes32) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0cf50000, 1037618711797) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0cf50001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0cf50005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0cf56000, self.slot) }
        return stdStorageSafe.read_bytes32(self);
    }

    function read_bool(StdStorage storage self) internal returns (bool) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0cf80000, 1037618711800) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0cf80001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0cf80005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0cf86000, self.slot) }
        return stdStorageSafe.read_bool(self);
    }

    function read_address(StdStorage storage self) internal returns (address) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0cf90000, 1037618711801) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0cf90001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0cf90005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0cf96000, self.slot) }
        return stdStorageSafe.read_address(self);
    }

    function read_uint(StdStorage storage self) internal returns (uint256) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0cf20000, 1037618711794) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0cf20001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0cf20005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0cf26000, self.slot) }
        return stdStorageSafe.read_uint(self);
    }

    function read_int(StdStorage storage self) internal returns (int256) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0cf30000, 1037618711795) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0cf30001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0cf30005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0cf36000, self.slot) }
        return stdStorageSafe.read_int(self);
    }

    function parent(StdStorage storage self) internal returns (uint256, bytes32) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0cf40000, 1037618711796) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0cf40001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0cf40005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0cf46000, self.slot) }
        return stdStorageSafe.parent(self);
    }

    function root(StdStorage storage self) internal returns (uint256) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0cf10000, 1037618711793) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0cf10001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0cf10005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0cf16000, self.slot) }
        return stdStorageSafe.root(self);
    }
}
