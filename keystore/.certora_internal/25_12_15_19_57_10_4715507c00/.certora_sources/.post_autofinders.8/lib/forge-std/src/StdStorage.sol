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

    function sigs(string memory sigStr) internal pure returns (bytes4) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0eac0000, 1037618712236) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0eac0001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0eac0005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0eac6000, sigStr) }
        return bytes4(keccak256(bytes(sigStr)));
    }

    function getCallParams(StdStorage storage self) internal view returns (bytes memory) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ead0000, 1037618712237) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ead0001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ead0005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ead6000, self.slot) }
        if (self._calldata.length == 0) {
            return flatten(self._keys);
        } else {
            return self._calldata;
        }
    }

    // Calls target contract with configured parameters
    function callTarget(StdStorage storage self) internal view returns (bool, bytes32) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0eaf0000, 1037618712239) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0eaf0001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0eaf0005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0eaf6000, self.slot) }
        bytes memory cald = abi.encodePacked(self._sig, getCallParams(self));assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000100bb,0)}
        (bool success, bytes memory rdat) = self._target.staticcall(cald);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000100bc,0)}
        bytes32 result = bytesToBytes32(rdat, 32 * self._depth);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000000bd,result)}

        return (success, result);
    }

    // Tries mutating slot value to determine if the targeted value is stored in it.
    // If current value is 0, then we are setting slot value to type(uint256).max
    // Otherwise, we set it to 0. That way, return value should always be affected.
    function checkSlotMutatesCall(StdStorage storage self, bytes32 slot) internal returns (bool) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0eb00000, 1037618712240) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0eb00001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0eb00005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0eb06001, slot) }
        bytes32 prevSlotValue = vm.load(self._target, slot);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000000be,prevSlotValue)}
        (bool success, bytes32 prevReturnValue) = callTarget(self);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000100bf,0)}

        bytes32 testVal = prevReturnValue == bytes32(0) ? bytes32(UINT256_MAX) : bytes32(0);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000000c0,testVal)}
        vm.store(self._target, slot, testVal);

        (, bytes32 newReturnValue) = callTarget(self);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000100c1,0)}

        vm.store(self._target, slot, prevSlotValue);

        return (success && (prevReturnValue != newReturnValue));
    }

    // Tries setting one of the bits in slot to 1 until return value changes.
    // Index of resulted bit is an offset packed slot has from left/right side
    function findOffset(StdStorage storage self, bytes32 slot, bool left) internal returns (bool, uint256) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0eae0000, 1037618712238) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0eae0001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0eae0005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0eae6002, left) }
        for (uint256 offset = 0; offset < 256; offset++) {
            uint256 valueToPut = left ? (1 << (255 - offset)) : (1 << offset);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000000ec,valueToPut)}
            vm.store(self._target, slot, bytes32(valueToPut));

            (bool success, bytes32 data) = callTarget(self);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000100ed,0)}

            if (success && (uint256(data) > 0)) {
                return (true, offset);
            }
        }
        return (false, 0);
    }

    function findOffsets(StdStorage storage self, bytes32 slot) internal returns (bool, uint256, uint256) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0eb10000, 1037618712241) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0eb10001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0eb10005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0eb16001, slot) }
        bytes32 prevSlotValue = vm.load(self._target, slot);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000000c2,prevSlotValue)}

        (bool foundLeft, uint256 offsetLeft) = findOffset(self, slot, true);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000100c3,0)}
        (bool foundRight, uint256 offsetRight) = findOffset(self, slot, false);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000100c4,0)}

        // `findOffset` may mutate slot value, so we are setting it to initial value
        vm.store(self._target, slot, prevSlotValue);
        return (foundLeft && foundRight, offsetLeft, offsetRight);
    }

    function find(StdStorage storage self) internal returns (FindData storage) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0eb20000, 1037618712242) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0eb20001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0eb20005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0eb26000, self.slot) }
        return find(self, true);
    }

    /// @notice find an arbitrary storage slot given a function sig, input data, address of the contract and a value to check against
    // slot complexity:
    //  if flat, will be bytes32(uint256(uint));
    //  if map, will be keccak256(abi.encode(key, uint(slot)));
    //  if deep map, will be keccak256(abi.encode(key1, keccak256(abi.encode(key0, uint(slot)))));
    //  if map struct, will be bytes32(uint256(keccak256(abi.encode(key1, keccak256(abi.encode(key0, uint(slot)))))) + structFieldDepth);
    function find(StdStorage storage self, bool _clear) internal returns (FindData storage) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0eb30000, 1037618712243) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0eb30001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0eb30005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0eb36001, _clear) }
        address who = self._target;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000000c5,who)}
        bytes4 fsig = self._sig;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000000c6,fsig)}
        uint256 field_depth = self._depth;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000000c7,field_depth)}
        bytes memory params = getCallParams(self);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000100c8,0)}

        // calldata to test against
        if (self.finds[who][fsig][keccak256(abi.encodePacked(params, field_depth))].found) {
            if (_clear) {
                clear(self);
            }
            return self.finds[who][fsig][keccak256(abi.encodePacked(params, field_depth))];
        }
        vm.record();
        (, bytes32 callResult) = callTarget(self);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000100c9,0)}
        (bytes32[] memory reads,) = vm.accesses(address(who));assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000100ca,0)}

        if (reads.length == 0) {
            revert("stdStorage find(StdStorage): No storage use detected for target.");
        } else {
            for (uint256 i = reads.length; --i >= 0;) {
                bytes32 prev = vm.load(who, reads[i]);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000000f2,prev)}
                if (prev == bytes32(0)) {
                    emit WARNING_UninitedSlot(who, uint256(reads[i]));
                }

                if (!checkSlotMutatesCall(self, reads[i])) {
                    continue;
                }

                (uint256 offsetLeft, uint256 offsetRight) = (0, 0);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000100f3,0)}

                if (self._enable_packed_slots) {
                    bool found;
                    (found, offsetLeft, offsetRight) = findOffsets(self, reads[i]);
                    if (!found) {
                        continue;
                    }
                }

                // Check that value between found offsets is equal to the current call result
                uint256 curVal = (uint256(prev) & getMaskByOffsets(offsetLeft, offsetRight)) >> offsetRight;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000000f4,curVal)}

                if (uint256(callResult) != curVal) {
                    continue;
                }

                emit SlotFound(who, fsig, keccak256(abi.encodePacked(params, field_depth)), uint256(reads[i]));
                self.finds[who][fsig][keccak256(abi.encodePacked(params, field_depth))] =
                    FindData(uint256(reads[i]), offsetLeft, offsetRight, true);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000200f5,0)}
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

    function target(StdStorage storage self, address _target) internal returns (StdStorage storage) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0eb40000, 1037618712244) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0eb40001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0eb40005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0eb46001, _target) }
        self._target = _target;address certora_local229 = self._target;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000000e5,certora_local229)}
        return self;
    }

    function sig(StdStorage storage self, bytes4 _sig) internal returns (StdStorage storage) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0eb50000, 1037618712245) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0eb50001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0eb50005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0eb56001, _sig) }
        self._sig = _sig;bytes4 certora_local230 = self._sig;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000000e6,certora_local230)}
        return self;
    }

    function sig(StdStorage storage self, string memory _sig) internal returns (StdStorage storage) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0eb60000, 1037618712246) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0eb60001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0eb60005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0eb66001, _sig) }
        self._sig = sigs(_sig);bytes4 certora_local231 = self._sig;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000000e7,certora_local231)}
        return self;
    }

    function with_calldata(StdStorage storage self, bytes memory _calldata) internal returns (StdStorage storage) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0eb70000, 1037618712247) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0eb70001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0eb70005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0eb76001, _calldata) }
        self._calldata = _calldata;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000200e8,0)}
        return self;
    }

    function with_key(StdStorage storage self, address who) internal returns (StdStorage storage) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0eb80000, 1037618712248) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0eb80001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0eb80005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0eb86001, who) }
        self._keys.push(bytes32(uint256(uint160(who))));
        return self;
    }

    function with_key(StdStorage storage self, uint256 amt) internal returns (StdStorage storage) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0eb90000, 1037618712249) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0eb90001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0eb90005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0eb96001, amt) }
        self._keys.push(bytes32(amt));
        return self;
    }

    function with_key(StdStorage storage self, bytes32 key) internal returns (StdStorage storage) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0eba0000, 1037618712250) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0eba0001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0eba0005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0eba6001, key) }
        self._keys.push(key);
        return self;
    }

    function enable_packed_slots(StdStorage storage self) internal returns (StdStorage storage) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ebb0000, 1037618712251) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ebb0001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ebb0005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ebb6000, self.slot) }
        self._enable_packed_slots = true;bool certora_local233 = self._enable_packed_slots;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000000e9,certora_local233)}
        return self;
    }

    function depth(StdStorage storage self, uint256 _depth) internal returns (StdStorage storage) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ec20000, 1037618712258) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ec20001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ec20005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ec26001, _depth) }
        self._depth = _depth;uint256 certora_local234 = self._depth;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000000ea,certora_local234)}
        return self;
    }

    function read(StdStorage storage self) private returns (bytes memory) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ec10000, 1037618712257) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ec10001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ec10005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ec16000, self.slot) }
        FindData storage data = find(self, false);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000100cb,0)}
        uint256 mask = getMaskByOffsets(data.offsetLeft, data.offsetRight);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000000cc,mask)}
        uint256 value = (uint256(vm.load(self._target, bytes32(data.slot))) & mask) >> data.offsetRight;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000000cd,value)}
        clear(self);
        return abi.encode(value);
    }

    function read_bytes32(StdStorage storage self) internal returns (bytes32) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ec00000, 1037618712256) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ec00001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ec00005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ec06000, self.slot) }
        return abi.decode(read(self), (bytes32));
    }

    function read_bool(StdStorage storage self) internal returns (bool) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ec30000, 1037618712259) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ec30001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ec30005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ec36000, self.slot) }
        int256 v = read_int(self);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000000ce,v)}
        if (v == 0) return false;
        if (v == 1) return true;
        revert("stdStorage read_bool(StdStorage): Cannot decode. Make sure you are reading a bool.");
    }

    function read_address(StdStorage storage self) internal returns (address) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ec40000, 1037618712260) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ec40001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ec40005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ec46000, self.slot) }
        return abi.decode(read(self), (address));
    }

    function read_uint(StdStorage storage self) internal returns (uint256) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ec50000, 1037618712261) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ec50001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ec50005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ec56000, self.slot) }
        return abi.decode(read(self), (uint256));
    }

    function read_int(StdStorage storage self) internal returns (int256) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ec60000, 1037618712262) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ec60001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ec60005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ec66000, self.slot) }
        return abi.decode(read(self), (int256));
    }

    function parent(StdStorage storage self) internal returns (uint256, bytes32) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ec70000, 1037618712263) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ec70001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ec70005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ec76000, self.slot) }
        address who = self._target;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000000cf,who)}
        uint256 field_depth = self._depth;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000000d0,field_depth)}
        vm.startMappingRecording();
        uint256 child = find(self, true).slot - field_depth;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000000d1,child)}
        (bool found, bytes32 key, bytes32 parent_slot) = vm.getMappingKeyAndParentOf(who, bytes32(child));assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000100d2,0)}
        if (!found) {
            revert(
                "stdStorage read_bool(StdStorage): Cannot find parent. Make sure you give a slot and startMappingRecording() has been called."
            );
        }
        return (uint256(parent_slot), key);
    }

    function root(StdStorage storage self) internal returns (uint256) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ec80000, 1037618712264) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ec80001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ec80005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ec86000, self.slot) }
        address who = self._target;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000000d3,who)}
        uint256 field_depth = self._depth;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000000d4,field_depth)}
        vm.startMappingRecording();
        uint256 child = find(self, true).slot - field_depth;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000000d5,child)}
        bool found;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000000d6,found)}
        bytes32 root_slot;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000000d7,root_slot)}
        bytes32 parent_slot;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000000d8,parent_slot)}
        (found,, parent_slot) = vm.getMappingKeyAndParentOf(who, bytes32(child));assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000200eb,0)}
        if (!found) {
            revert(
                "stdStorage read_bool(StdStorage): Cannot find parent. Make sure you give a slot and startMappingRecording() has been called."
            );
        }
        while (found) {
            root_slot = parent_slot;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000000ef,root_slot)}
            (found,, parent_slot) = vm.getMappingKeyAndParentOf(who, bytes32(root_slot));assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000200f0,0)}
        }
        return uint256(root_slot);
    }

    function bytesToBytes32(bytes memory b, uint256 offset) private pure returns (bytes32) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ec90000, 1037618712265) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ec90001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ec90005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ec96001, offset) }
        bytes32 out;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000000d9,out)}

        uint256 max = b.length > 32 ? 32 : b.length;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000000da,max)}
        for (uint256 i = 0; i < max; i++) {
            out |= bytes32(b[offset + i] & 0xFF) >> (i * 8);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000000f1,out)}
        }
        return out;
    }

    function flatten(bytes32[] memory b) private pure returns (bytes memory) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ebd0000, 1037618712253) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ebd0001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ebd0005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ebd6000, b) }
        bytes memory result = new bytes(b.length * 32);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000100db,0)}
        for (uint256 i = 0; i < b.length; i++) {
            bytes32 k = b[i];assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000000ee,k)}
            /// @solidity memory-safe-assembly
            assembly {
                mstore(add(result, add(32, mul(32, i))), k)
            }
        }

        return result;
    }

    function clear(StdStorage storage self) internal {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ebe0000, 1037618712254) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ebe0001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ebe0005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ebe6000, self.slot) }
        delete self._target;
        delete self._sig;
        delete self._keys;
        delete self._depth;
        delete self._enable_packed_slots;
        delete self._calldata;
    }

    // Returns mask which contains non-zero bits for values between `offsetLeft` and `offsetRight`
    // (slotValue & mask) >> offsetRight will be the value of the given packed variable
    function getMaskByOffsets(uint256 offsetLeft, uint256 offsetRight) internal pure returns (uint256 mask) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ebf0000, 1037618712255) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ebf0001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ebf0005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ebf6001, offsetRight) }
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
    {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ebc0000, 1037618712252) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ebc0001, 4) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ebc0005, 585) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ebc6003, offsetRight) }
        return bytes32((uint256(curValue) & ~getMaskByOffsets(offsetLeft, offsetRight)) | (varValue << offsetRight));
    }
}

library stdStorage {
    Vm private constant vm = Vm(address(uint160(uint256(keccak256("hevm cheat code")))));

    function sigs(string memory sigStr) internal pure returns (bytes4) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e930000, 1037618712211) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e930001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e930005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e936000, sigStr) }
        return stdStorageSafe.sigs(sigStr);
    }

    function find(StdStorage storage self) internal returns (uint256) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e940000, 1037618712212) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e940001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e940005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e946000, self.slot) }
        return find(self, true);
    }

    function find(StdStorage storage self, bool _clear) internal returns (uint256) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e960000, 1037618712214) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e960001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e960005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e966001, _clear) }
        return stdStorageSafe.find(self, _clear).slot;
    }

    function target(StdStorage storage self, address _target) internal returns (StdStorage storage) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e970000, 1037618712215) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e970001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e970005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e976001, _target) }
        return stdStorageSafe.target(self, _target);
    }

    function sig(StdStorage storage self, bytes4 _sig) internal returns (StdStorage storage) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e950000, 1037618712213) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e950001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e950005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e956001, _sig) }
        return stdStorageSafe.sig(self, _sig);
    }

    function sig(StdStorage storage self, string memory _sig) internal returns (StdStorage storage) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e980000, 1037618712216) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e980001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e980005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e986001, _sig) }
        return stdStorageSafe.sig(self, _sig);
    }

    function with_key(StdStorage storage self, address who) internal returns (StdStorage storage) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e990000, 1037618712217) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e990001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e990005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e996001, who) }
        return stdStorageSafe.with_key(self, who);
    }

    function with_key(StdStorage storage self, uint256 amt) internal returns (StdStorage storage) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e9a0000, 1037618712218) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e9a0001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e9a0005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e9a6001, amt) }
        return stdStorageSafe.with_key(self, amt);
    }

    function with_key(StdStorage storage self, bytes32 key) internal returns (StdStorage storage) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e9b0000, 1037618712219) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e9b0001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e9b0005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e9b6001, key) }
        return stdStorageSafe.with_key(self, key);
    }

    function with_calldata(StdStorage storage self, bytes memory _calldata) internal returns (StdStorage storage) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e9c0000, 1037618712220) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e9c0001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e9c0005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e9c6001, _calldata) }
        return stdStorageSafe.with_calldata(self, _calldata);
    }

    function enable_packed_slots(StdStorage storage self) internal returns (StdStorage storage) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e9d0000, 1037618712221) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e9d0001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e9d0005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e9d6000, self.slot) }
        return stdStorageSafe.enable_packed_slots(self);
    }

    function depth(StdStorage storage self, uint256 _depth) internal returns (StdStorage storage) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e9e0000, 1037618712222) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e9e0001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e9e0005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e9e6001, _depth) }
        return stdStorageSafe.depth(self, _depth);
    }

    function clear(StdStorage storage self) internal {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e9f0000, 1037618712223) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e9f0001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e9f0005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e9f6000, self.slot) }
        stdStorageSafe.clear(self);
    }

    function checked_write(StdStorage storage self, address who) internal {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ea00000, 1037618712224) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ea00001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ea00005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ea06001, who) }
        checked_write(self, bytes32(uint256(uint160(who))));
    }

    function checked_write(StdStorage storage self, uint256 amt) internal {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ea10000, 1037618712225) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ea10001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ea10005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ea16001, amt) }
        checked_write(self, bytes32(amt));
    }

    function checked_write_int(StdStorage storage self, int256 val) internal {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ea20000, 1037618712226) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ea20001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ea20005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ea26001, val) }
        checked_write(self, bytes32(uint256(val)));
    }

    function checked_write(StdStorage storage self, bool write) internal {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ea90000, 1037618712233) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ea90001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ea90005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ea96001, write) }
        bytes32 t;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000000dc,t)}
        /// @solidity memory-safe-assembly
        assembly {
            t := write
        }
        checked_write(self, t);
    }

    function checked_write(StdStorage storage self, bytes32 set) internal {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ea80000, 1037618712232) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ea80001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ea80005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ea86001, set) }
        address who = self._target;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000000dd,who)}
        bytes4 fsig = self._sig;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000000de,fsig)}
        uint256 field_depth = self._depth;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000000df,field_depth)}
        bytes memory params = stdStorageSafe.getCallParams(self);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000100e0,0)}

        if (!self.finds[who][fsig][keccak256(abi.encodePacked(params, field_depth))].found) {
            find(self, false);
        }
        FindData storage data = self.finds[who][fsig][keccak256(abi.encodePacked(params, field_depth))];assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000100e1,0)}
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
        bytes32 curVal = vm.load(who, bytes32(data.slot));assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000000e2,curVal)}
        bytes32 valToSet = stdStorageSafe.getUpdatedSlotValue(curVal, uint256(set), data.offsetLeft, data.offsetRight);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000000e3,valToSet)}

        vm.store(who, bytes32(data.slot), valToSet);

        (bool success, bytes32 callResult) = stdStorageSafe.callTarget(self);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000100e4,0)}

        if (!success || callResult != set) {
            vm.store(who, bytes32(data.slot), curVal);
            revert("stdStorage find(StdStorage): Failed to write value.");
        }
        clear(self);
    }

    function read_bytes32(StdStorage storage self) internal returns (bytes32) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ea70000, 1037618712231) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ea70001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ea70005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ea76000, self.slot) }
        return stdStorageSafe.read_bytes32(self);
    }

    function read_bool(StdStorage storage self) internal returns (bool) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0eaa0000, 1037618712234) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0eaa0001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0eaa0005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0eaa6000, self.slot) }
        return stdStorageSafe.read_bool(self);
    }

    function read_address(StdStorage storage self) internal returns (address) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0eab0000, 1037618712235) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0eab0001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0eab0005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0eab6000, self.slot) }
        return stdStorageSafe.read_address(self);
    }

    function read_uint(StdStorage storage self) internal returns (uint256) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ea40000, 1037618712228) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ea40001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ea40005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ea46000, self.slot) }
        return stdStorageSafe.read_uint(self);
    }

    function read_int(StdStorage storage self) internal returns (int256) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ea50000, 1037618712229) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ea50001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ea50005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ea56000, self.slot) }
        return stdStorageSafe.read_int(self);
    }

    function parent(StdStorage storage self) internal returns (uint256, bytes32) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ea60000, 1037618712230) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ea60001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ea60005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ea66000, self.slot) }
        return stdStorageSafe.parent(self);
    }

    function root(StdStorage storage self) internal returns (uint256) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ea30000, 1037618712227) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ea30001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ea30005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ea36000, self.slot) }
        return stdStorageSafe.root(self);
    }
}
