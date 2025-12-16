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

    function sigs(string memory sigStr) internal pure returns (bytes4) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff071e0000, 1037618710302) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff071e0001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff071e0005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff071e6000, sigStr) }
        return bytes4(keccak256(bytes(sigStr)));
    }

    function getCallParams(StdStorage storage self) internal view returns (bytes memory) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff071f0000, 1037618710303) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff071f0001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff071f0005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff071f6000, self.slot) }
        if (self._calldata.length == 0) {
            return flatten(self._keys);
        } else {
            return self._calldata;
        }
    }

    // Calls target contract with configured parameters
    function callTarget(StdStorage storage self) internal view returns (bool, bytes32) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07210000, 1037618710305) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07210001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07210005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07216000, self.slot) }
        bytes memory cald = abi.encodePacked(self._sig, getCallParams(self));assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000100be,0)}
        (bool success, bytes memory rdat) = self._target.staticcall(cald);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000100bf,0)}
        bytes32 result = bytesToBytes32(rdat, 32 * self._depth);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000000c0,result)}

        return (success, result);
    }

    // Tries mutating slot value to determine if the targeted value is stored in it.
    // If current value is 0, then we are setting slot value to type(uint256).max
    // Otherwise, we set it to 0. That way, return value should always be affected.
    function checkSlotMutatesCall(StdStorage storage self, bytes32 slot) internal returns (bool) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07220000, 1037618710306) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07220001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07220005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07226001, slot) }
        bytes32 prevSlotValue = vm.load(self._target, slot);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000000c1,prevSlotValue)}
        (bool success, bytes32 prevReturnValue) = callTarget(self);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000100c2,0)}

        bytes32 testVal = prevReturnValue == bytes32(0) ? bytes32(UINT256_MAX) : bytes32(0);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000000c3,testVal)}
        vm.store(self._target, slot, testVal);

        (, bytes32 newReturnValue) = callTarget(self);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000100c4,0)}

        vm.store(self._target, slot, prevSlotValue);

        return (success && (prevReturnValue != newReturnValue));
    }

    // Tries setting one of the bits in slot to 1 until return value changes.
    // Index of resulted bit is an offset packed slot has from left/right side
    function findOffset(StdStorage storage self, bytes32 slot, bool left) internal returns (bool, uint256) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07200000, 1037618710304) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07200001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07200005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07206002, left) }
        for (uint256 offset = 0; offset < 256; offset++) {
            uint256 valueToPut = left ? (1 << (255 - offset)) : (1 << offset);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000000ef,valueToPut)}
            vm.store(self._target, slot, bytes32(valueToPut));

            (bool success, bytes32 data) = callTarget(self);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000100f0,0)}

            if (success && (uint256(data) > 0)) {
                return (true, offset);
            }
        }
        return (false, 0);
    }

    function findOffsets(StdStorage storage self, bytes32 slot) internal returns (bool, uint256, uint256) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07230000, 1037618710307) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07230001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07230005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07236001, slot) }
        bytes32 prevSlotValue = vm.load(self._target, slot);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000000c5,prevSlotValue)}

        (bool foundLeft, uint256 offsetLeft) = findOffset(self, slot, true);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000100c6,0)}
        (bool foundRight, uint256 offsetRight) = findOffset(self, slot, false);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000100c7,0)}

        // `findOffset` may mutate slot value, so we are setting it to initial value
        vm.store(self._target, slot, prevSlotValue);
        return (foundLeft && foundRight, offsetLeft, offsetRight);
    }

    function find(StdStorage storage self) internal returns (FindData storage) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07240000, 1037618710308) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07240001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07240005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07246000, self.slot) }
        return find(self, true);
    }

    /// @notice find an arbitrary storage slot given a function sig, input data, address of the contract and a value to check against
    // slot complexity:
    //  if flat, will be bytes32(uint256(uint));
    //  if map, will be keccak256(abi.encode(key, uint(slot)));
    //  if deep map, will be keccak256(abi.encode(key1, keccak256(abi.encode(key0, uint(slot)))));
    //  if map struct, will be bytes32(uint256(keccak256(abi.encode(key1, keccak256(abi.encode(key0, uint(slot)))))) + structFieldDepth);
    function find(StdStorage storage self, bool _clear) internal returns (FindData storage) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07250000, 1037618710309) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07250001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07250005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07256001, _clear) }
        address who = self._target;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000000c8,who)}
        bytes4 fsig = self._sig;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000000c9,fsig)}
        uint256 field_depth = self._depth;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000000ca,field_depth)}
        bytes memory params = getCallParams(self);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000100cb,0)}

        // calldata to test against
        if (self.finds[who][fsig][keccak256(abi.encodePacked(params, field_depth))].found) {
            if (_clear) {
                clear(self);
            }
            return self.finds[who][fsig][keccak256(abi.encodePacked(params, field_depth))];
        }
        vm.record();
        (, bytes32 callResult) = callTarget(self);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000100cc,0)}
        (bytes32[] memory reads,) = vm.accesses(address(who));assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000100cd,0)}

        if (reads.length == 0) {
            revert("stdStorage find(StdStorage): No storage use detected for target.");
        } else {
            for (uint256 i = reads.length; --i >= 0;) {
                bytes32 prev = vm.load(who, reads[i]);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000000f5,prev)}
                if (prev == bytes32(0)) {
                    emit WARNING_UninitedSlot(who, uint256(reads[i]));
                }

                if (!checkSlotMutatesCall(self, reads[i])) {
                    continue;
                }

                (uint256 offsetLeft, uint256 offsetRight) = (0, 0);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000100f6,0)}

                if (self._enable_packed_slots) {
                    bool found;
                    (found, offsetLeft, offsetRight) = findOffsets(self, reads[i]);
                    if (!found) {
                        continue;
                    }
                }

                // Check that value between found offsets is equal to the current call result
                uint256 curVal = (uint256(prev) & getMaskByOffsets(offsetLeft, offsetRight)) >> offsetRight;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000000f7,curVal)}

                if (uint256(callResult) != curVal) {
                    continue;
                }

                emit SlotFound(who, fsig, keccak256(abi.encodePacked(params, field_depth)), uint256(reads[i]));
                self.finds[who][fsig][keccak256(abi.encodePacked(params, field_depth))] =
                    FindData(uint256(reads[i]), offsetLeft, offsetRight, true);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000200f8,0)}
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

    function target(StdStorage storage self, address _target) internal returns (StdStorage storage) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07260000, 1037618710310) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07260001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07260005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07266001, _target) }
        self._target = _target;address certora_local232 = self._target;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000000e8,certora_local232)}
        return self;
    }

    function sig(StdStorage storage self, bytes4 _sig) internal returns (StdStorage storage) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07270000, 1037618710311) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07270001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07270005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07276001, _sig) }
        self._sig = _sig;bytes4 certora_local233 = self._sig;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000000e9,certora_local233)}
        return self;
    }

    function sig(StdStorage storage self, string memory _sig) internal returns (StdStorage storage) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07280000, 1037618710312) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07280001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07280005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07286001, _sig) }
        self._sig = sigs(_sig);bytes4 certora_local234 = self._sig;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000000ea,certora_local234)}
        return self;
    }

    function with_calldata(StdStorage storage self, bytes memory _calldata) internal returns (StdStorage storage) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07290000, 1037618710313) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07290001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07290005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07296001, _calldata) }
        self._calldata = _calldata;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000200eb,0)}
        return self;
    }

    function with_key(StdStorage storage self, address who) internal returns (StdStorage storage) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff072a0000, 1037618710314) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff072a0001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff072a0005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff072a6001, who) }
        self._keys.push(bytes32(uint256(uint160(who))));
        return self;
    }

    function with_key(StdStorage storage self, uint256 amt) internal returns (StdStorage storage) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff072b0000, 1037618710315) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff072b0001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff072b0005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff072b6001, amt) }
        self._keys.push(bytes32(amt));
        return self;
    }

    function with_key(StdStorage storage self, bytes32 key) internal returns (StdStorage storage) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff072c0000, 1037618710316) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff072c0001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff072c0005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff072c6001, key) }
        self._keys.push(key);
        return self;
    }

    function enable_packed_slots(StdStorage storage self) internal returns (StdStorage storage) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff072d0000, 1037618710317) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff072d0001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff072d0005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff072d6000, self.slot) }
        self._enable_packed_slots = true;bool certora_local236 = self._enable_packed_slots;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000000ec,certora_local236)}
        return self;
    }

    function depth(StdStorage storage self, uint256 _depth) internal returns (StdStorage storage) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07340000, 1037618710324) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07340001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07340005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07346001, _depth) }
        self._depth = _depth;uint256 certora_local237 = self._depth;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000000ed,certora_local237)}
        return self;
    }

    function read(StdStorage storage self) private returns (bytes memory) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07330000, 1037618710323) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07330001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07330005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07336000, self.slot) }
        FindData storage data = find(self, false);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000100ce,0)}
        uint256 mask = getMaskByOffsets(data.offsetLeft, data.offsetRight);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000000cf,mask)}
        uint256 value = (uint256(vm.load(self._target, bytes32(data.slot))) & mask) >> data.offsetRight;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000000d0,value)}
        clear(self);
        return abi.encode(value);
    }

    function read_bytes32(StdStorage storage self) internal returns (bytes32) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07320000, 1037618710322) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07320001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07320005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07326000, self.slot) }
        return abi.decode(read(self), (bytes32));
    }

    function read_bool(StdStorage storage self) internal returns (bool) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07350000, 1037618710325) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07350001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07350005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07356000, self.slot) }
        int256 v = read_int(self);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000000d1,v)}
        if (v == 0) return false;
        if (v == 1) return true;
        revert("stdStorage read_bool(StdStorage): Cannot decode. Make sure you are reading a bool.");
    }

    function read_address(StdStorage storage self) internal returns (address) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07360000, 1037618710326) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07360001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07360005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07366000, self.slot) }
        return abi.decode(read(self), (address));
    }

    function read_uint(StdStorage storage self) internal returns (uint256) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07370000, 1037618710327) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07370001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07370005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07376000, self.slot) }
        return abi.decode(read(self), (uint256));
    }

    function read_int(StdStorage storage self) internal returns (int256) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07380000, 1037618710328) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07380001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07380005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07386000, self.slot) }
        return abi.decode(read(self), (int256));
    }

    function parent(StdStorage storage self) internal returns (uint256, bytes32) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07390000, 1037618710329) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07390001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07390005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07396000, self.slot) }
        address who = self._target;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000000d2,who)}
        uint256 field_depth = self._depth;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000000d3,field_depth)}
        vm.startMappingRecording();
        uint256 child = find(self, true).slot - field_depth;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000000d4,child)}
        (bool found, bytes32 key, bytes32 parent_slot) = vm.getMappingKeyAndParentOf(who, bytes32(child));assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000100d5,0)}
        if (!found) {
            revert(
                "stdStorage read_bool(StdStorage): Cannot find parent. Make sure you give a slot and startMappingRecording() has been called."
            );
        }
        return (uint256(parent_slot), key);
    }

    function root(StdStorage storage self) internal returns (uint256) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff073a0000, 1037618710330) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff073a0001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff073a0005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff073a6000, self.slot) }
        address who = self._target;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000000d6,who)}
        uint256 field_depth = self._depth;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000000d7,field_depth)}
        vm.startMappingRecording();
        uint256 child = find(self, true).slot - field_depth;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000000d8,child)}
        bool found;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000000d9,found)}
        bytes32 root_slot;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000000da,root_slot)}
        bytes32 parent_slot;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000000db,parent_slot)}
        (found,, parent_slot) = vm.getMappingKeyAndParentOf(who, bytes32(child));assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000200ee,0)}
        if (!found) {
            revert(
                "stdStorage read_bool(StdStorage): Cannot find parent. Make sure you give a slot and startMappingRecording() has been called."
            );
        }
        while (found) {
            root_slot = parent_slot;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000000f2,root_slot)}
            (found,, parent_slot) = vm.getMappingKeyAndParentOf(who, bytes32(root_slot));assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000200f3,0)}
        }
        return uint256(root_slot);
    }

    function bytesToBytes32(bytes memory b, uint256 offset) private pure returns (bytes32) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff073b0000, 1037618710331) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff073b0001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff073b0005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff073b6001, offset) }
        bytes32 out;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000000dc,out)}

        uint256 max = b.length > 32 ? 32 : b.length;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000000dd,max)}
        for (uint256 i = 0; i < max; i++) {
            out |= bytes32(b[offset + i] & 0xFF) >> (i * 8);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000000f4,out)}
        }
        return out;
    }

    function flatten(bytes32[] memory b) private pure returns (bytes memory) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff072f0000, 1037618710319) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff072f0001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff072f0005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff072f6000, b) }
        bytes memory result = new bytes(b.length * 32);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000100de,0)}
        for (uint256 i = 0; i < b.length; i++) {
            bytes32 k = b[i];assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000000f1,k)}
            /// @solidity memory-safe-assembly
            assembly {
                mstore(add(result, add(32, mul(32, i))), k)
            }
        }

        return result;
    }

    function clear(StdStorage storage self) internal {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07300000, 1037618710320) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07300001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07300005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07306000, self.slot) }
        delete self._target;
        delete self._sig;
        delete self._keys;
        delete self._depth;
        delete self._enable_packed_slots;
        delete self._calldata;
    }

    // Returns mask which contains non-zero bits for values between `offsetLeft` and `offsetRight`
    // (slotValue & mask) >> offsetRight will be the value of the given packed variable
    function getMaskByOffsets(uint256 offsetLeft, uint256 offsetRight) internal pure returns (uint256 mask) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07310000, 1037618710321) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07310001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07310005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07316001, offsetRight) }
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
    {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff072e0000, 1037618710318) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff072e0001, 4) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff072e0005, 585) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff072e6003, offsetRight) }
        return bytes32((uint256(curValue) & ~getMaskByOffsets(offsetLeft, offsetRight)) | (varValue << offsetRight));
    }
}

library stdStorage {
    Vm private constant vm = Vm(address(uint160(uint256(keccak256("hevm cheat code")))));

    function sigs(string memory sigStr) internal pure returns (bytes4) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07050000, 1037618710277) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07050001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07050005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07056000, sigStr) }
        return stdStorageSafe.sigs(sigStr);
    }

    function find(StdStorage storage self) internal returns (uint256) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07060000, 1037618710278) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07060001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07060005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07066000, self.slot) }
        return find(self, true);
    }

    function find(StdStorage storage self, bool _clear) internal returns (uint256) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07080000, 1037618710280) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07080001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07080005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07086001, _clear) }
        return stdStorageSafe.find(self, _clear).slot;
    }

    function target(StdStorage storage self, address _target) internal returns (StdStorage storage) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07090000, 1037618710281) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07090001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07090005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07096001, _target) }
        return stdStorageSafe.target(self, _target);
    }

    function sig(StdStorage storage self, bytes4 _sig) internal returns (StdStorage storage) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07070000, 1037618710279) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07070001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07070005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07076001, _sig) }
        return stdStorageSafe.sig(self, _sig);
    }

    function sig(StdStorage storage self, string memory _sig) internal returns (StdStorage storage) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff070a0000, 1037618710282) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff070a0001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff070a0005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff070a6001, _sig) }
        return stdStorageSafe.sig(self, _sig);
    }

    function with_key(StdStorage storage self, address who) internal returns (StdStorage storage) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff070b0000, 1037618710283) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff070b0001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff070b0005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff070b6001, who) }
        return stdStorageSafe.with_key(self, who);
    }

    function with_key(StdStorage storage self, uint256 amt) internal returns (StdStorage storage) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff070c0000, 1037618710284) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff070c0001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff070c0005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff070c6001, amt) }
        return stdStorageSafe.with_key(self, amt);
    }

    function with_key(StdStorage storage self, bytes32 key) internal returns (StdStorage storage) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff070d0000, 1037618710285) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff070d0001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff070d0005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff070d6001, key) }
        return stdStorageSafe.with_key(self, key);
    }

    function with_calldata(StdStorage storage self, bytes memory _calldata) internal returns (StdStorage storage) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff070e0000, 1037618710286) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff070e0001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff070e0005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff070e6001, _calldata) }
        return stdStorageSafe.with_calldata(self, _calldata);
    }

    function enable_packed_slots(StdStorage storage self) internal returns (StdStorage storage) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff070f0000, 1037618710287) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff070f0001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff070f0005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff070f6000, self.slot) }
        return stdStorageSafe.enable_packed_slots(self);
    }

    function depth(StdStorage storage self, uint256 _depth) internal returns (StdStorage storage) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07100000, 1037618710288) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07100001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07100005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07106001, _depth) }
        return stdStorageSafe.depth(self, _depth);
    }

    function clear(StdStorage storage self) internal {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07110000, 1037618710289) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07110001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07110005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07116000, self.slot) }
        stdStorageSafe.clear(self);
    }

    function checked_write(StdStorage storage self, address who) internal {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07120000, 1037618710290) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07120001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07120005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07126001, who) }
        checked_write(self, bytes32(uint256(uint160(who))));
    }

    function checked_write(StdStorage storage self, uint256 amt) internal {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07130000, 1037618710291) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07130001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07130005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07136001, amt) }
        checked_write(self, bytes32(amt));
    }

    function checked_write_int(StdStorage storage self, int256 val) internal {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07140000, 1037618710292) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07140001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07140005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07146001, val) }
        checked_write(self, bytes32(uint256(val)));
    }

    function checked_write(StdStorage storage self, bool write) internal {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff071b0000, 1037618710299) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff071b0001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff071b0005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff071b6001, write) }
        bytes32 t;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000000df,t)}
        /// @solidity memory-safe-assembly
        assembly {
            t := write
        }
        checked_write(self, t);
    }

    function checked_write(StdStorage storage self, bytes32 set) internal {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff071a0000, 1037618710298) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff071a0001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff071a0005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff071a6001, set) }
        address who = self._target;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000000e0,who)}
        bytes4 fsig = self._sig;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000000e1,fsig)}
        uint256 field_depth = self._depth;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000000e2,field_depth)}
        bytes memory params = stdStorageSafe.getCallParams(self);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000100e3,0)}

        if (!self.finds[who][fsig][keccak256(abi.encodePacked(params, field_depth))].found) {
            find(self, false);
        }
        FindData storage data = self.finds[who][fsig][keccak256(abi.encodePacked(params, field_depth))];assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000100e4,0)}
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
        bytes32 curVal = vm.load(who, bytes32(data.slot));assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000000e5,curVal)}
        bytes32 valToSet = stdStorageSafe.getUpdatedSlotValue(curVal, uint256(set), data.offsetLeft, data.offsetRight);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000000e6,valToSet)}

        vm.store(who, bytes32(data.slot), valToSet);

        (bool success, bytes32 callResult) = stdStorageSafe.callTarget(self);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000100e7,0)}

        if (!success || callResult != set) {
            vm.store(who, bytes32(data.slot), curVal);
            revert("stdStorage find(StdStorage): Failed to write value.");
        }
        clear(self);
    }

    function read_bytes32(StdStorage storage self) internal returns (bytes32) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07190000, 1037618710297) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07190001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07190005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07196000, self.slot) }
        return stdStorageSafe.read_bytes32(self);
    }

    function read_bool(StdStorage storage self) internal returns (bool) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff071c0000, 1037618710300) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff071c0001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff071c0005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff071c6000, self.slot) }
        return stdStorageSafe.read_bool(self);
    }

    function read_address(StdStorage storage self) internal returns (address) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff071d0000, 1037618710301) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff071d0001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff071d0005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff071d6000, self.slot) }
        return stdStorageSafe.read_address(self);
    }

    function read_uint(StdStorage storage self) internal returns (uint256) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07160000, 1037618710294) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07160001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07160005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07166000, self.slot) }
        return stdStorageSafe.read_uint(self);
    }

    function read_int(StdStorage storage self) internal returns (int256) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07170000, 1037618710295) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07170001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07170005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07176000, self.slot) }
        return stdStorageSafe.read_int(self);
    }

    function parent(StdStorage storage self) internal returns (uint256, bytes32) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07180000, 1037618710296) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07180001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07180005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07186000, self.slot) }
        return stdStorageSafe.parent(self);
    }

    function root(StdStorage storage self) internal returns (uint256) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07150000, 1037618710293) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07150001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07150005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07156000, self.slot) }
        return stdStorageSafe.root(self);
    }
}
