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

    function sigs(string memory sigStr) internal pure returns (bytes4) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01590000, 1037618708825) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01590001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01590005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01596000, sigStr) }
        return bytes4(keccak256(bytes(sigStr)));
    }

    function getCallParams(StdStorage storage self) internal view returns (bytes memory) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff015a0000, 1037618708826) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff015a0001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff015a0005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff015a6000, self.slot) }
        if (self._calldata.length == 0) {
            return flatten(self._keys);
        } else {
            return self._calldata;
        }
    }

    // Calls target contract with configured parameters
    function callTarget(StdStorage storage self) internal view returns (bool, bytes32) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff015c0000, 1037618708828) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff015c0001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff015c0005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff015c6000, self.slot) }
        bytes memory cald = abi.encodePacked(self._sig, getCallParams(self));assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00010125,0)}
        (bool success, bytes memory rdat) = self._target.staticcall(cald);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00010126,0)}
        bytes32 result = bytesToBytes32(rdat, 32 * self._depth);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000127,result)}

        return (success, result);
    }

    // Tries mutating slot value to determine if the targeted value is stored in it.
    // If current value is 0, then we are setting slot value to type(uint256).max
    // Otherwise, we set it to 0. That way, return value should always be affected.
    function checkSlotMutatesCall(StdStorage storage self, bytes32 slot) internal returns (bool) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff015d0000, 1037618708829) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff015d0001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff015d0005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff015d6001, slot) }
        bytes32 prevSlotValue = vm.load(self._target, slot);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000128,prevSlotValue)}
        (bool success, bytes32 prevReturnValue) = callTarget(self);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00010129,0)}

        bytes32 testVal = prevReturnValue == bytes32(0) ? bytes32(UINT256_MAX) : bytes32(0);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0000012a,testVal)}
        vm.store(self._target, slot, testVal);

        (, bytes32 newReturnValue) = callTarget(self);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0001012b,0)}

        vm.store(self._target, slot, prevSlotValue);

        return (success && (prevReturnValue != newReturnValue));
    }

    // Tries setting one of the bits in slot to 1 until return value changes.
    // Index of resulted bit is an offset packed slot has from left/right side
    function findOffset(StdStorage storage self, bytes32 slot, bool left) internal returns (bool, uint256) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff015b0000, 1037618708827) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff015b0001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff015b0005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff015b6002, left) }
        for (uint256 offset = 0; offset < 256; offset++) {
            uint256 valueToPut = left ? (1 << (255 - offset)) : (1 << offset);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000156,valueToPut)}
            vm.store(self._target, slot, bytes32(valueToPut));

            (bool success, bytes32 data) = callTarget(self);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00010157,0)}

            if (success && (uint256(data) > 0)) {
                return (true, offset);
            }
        }
        return (false, 0);
    }

    function findOffsets(StdStorage storage self, bytes32 slot) internal returns (bool, uint256, uint256) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff015e0000, 1037618708830) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff015e0001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff015e0005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff015e6001, slot) }
        bytes32 prevSlotValue = vm.load(self._target, slot);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0000012c,prevSlotValue)}

        (bool foundLeft, uint256 offsetLeft) = findOffset(self, slot, true);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0001012d,0)}
        (bool foundRight, uint256 offsetRight) = findOffset(self, slot, false);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0001012e,0)}

        // `findOffset` may mutate slot value, so we are setting it to initial value
        vm.store(self._target, slot, prevSlotValue);
        return (foundLeft && foundRight, offsetLeft, offsetRight);
    }

    function find(StdStorage storage self) internal returns (FindData storage) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff015f0000, 1037618708831) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff015f0001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff015f0005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff015f6000, self.slot) }
        return find(self, true);
    }

    /// @notice find an arbitrary storage slot given a function sig, input data, address of the contract and a value to check against
    // slot complexity:
    //  if flat, will be bytes32(uint256(uint));
    //  if map, will be keccak256(abi.encode(key, uint(slot)));
    //  if deep map, will be keccak256(abi.encode(key1, keccak256(abi.encode(key0, uint(slot)))));
    //  if map struct, will be bytes32(uint256(keccak256(abi.encode(key1, keccak256(abi.encode(key0, uint(slot)))))) + structFieldDepth);
    function find(StdStorage storage self, bool _clear) internal returns (FindData storage) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01600000, 1037618708832) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01600001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01600005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01606001, _clear) }
        address who = self._target;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0000012f,who)}
        bytes4 fsig = self._sig;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000130,fsig)}
        uint256 field_depth = self._depth;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000131,field_depth)}
        bytes memory params = getCallParams(self);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00010132,0)}

        // calldata to test against
        if (self.finds[who][fsig][keccak256(abi.encodePacked(params, field_depth))].found) {
            if (_clear) {
                clear(self);
            }
            return self.finds[who][fsig][keccak256(abi.encodePacked(params, field_depth))];
        }
        vm.record();
        (, bytes32 callResult) = callTarget(self);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00010133,0)}
        (bytes32[] memory reads,) = vm.accesses(address(who));assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00010134,0)}

        if (reads.length == 0) {
            revert("stdStorage find(StdStorage): No storage use detected for target.");
        } else {
            for (uint256 i = reads.length; --i >= 0;) {
                bytes32 prev = vm.load(who, reads[i]);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0000015c,prev)}
                if (prev == bytes32(0)) {
                    emit WARNING_UninitedSlot(who, uint256(reads[i]));
                }

                if (!checkSlotMutatesCall(self, reads[i])) {
                    continue;
                }

                (uint256 offsetLeft, uint256 offsetRight) = (0, 0);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0001015d,0)}

                if (self._enable_packed_slots) {
                    bool found;
                    (found, offsetLeft, offsetRight) = findOffsets(self, reads[i]);
                    if (!found) {
                        continue;
                    }
                }

                // Check that value between found offsets is equal to the current call result
                uint256 curVal = (uint256(prev) & getMaskByOffsets(offsetLeft, offsetRight)) >> offsetRight;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0000015e,curVal)}

                if (uint256(callResult) != curVal) {
                    continue;
                }

                emit SlotFound(who, fsig, keccak256(abi.encodePacked(params, field_depth)), uint256(reads[i]));
                self.finds[who][fsig][keccak256(abi.encodePacked(params, field_depth))] =
                    FindData(uint256(reads[i]), offsetLeft, offsetRight, true);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0002015f,0)}
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

    function target(StdStorage storage self, address _target) internal returns (StdStorage storage) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01610000, 1037618708833) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01610001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01610005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01616001, _target) }
        self._target = _target;address certora_local335 = self._target;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0000014f,certora_local335)}
        return self;
    }

    function sig(StdStorage storage self, bytes4 _sig) internal returns (StdStorage storage) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01620000, 1037618708834) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01620001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01620005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01626001, _sig) }
        self._sig = _sig;bytes4 certora_local336 = self._sig;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000150,certora_local336)}
        return self;
    }

    function sig(StdStorage storage self, string memory _sig) internal returns (StdStorage storage) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01630000, 1037618708835) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01630001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01630005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01636001, _sig) }
        self._sig = sigs(_sig);bytes4 certora_local337 = self._sig;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000151,certora_local337)}
        return self;
    }

    function with_calldata(StdStorage storage self, bytes memory _calldata) internal returns (StdStorage storage) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01640000, 1037618708836) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01640001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01640005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01646001, _calldata) }
        self._calldata = _calldata;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00020152,0)}
        return self;
    }

    function with_key(StdStorage storage self, address who) internal returns (StdStorage storage) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01650000, 1037618708837) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01650001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01650005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01656001, who) }
        self._keys.push(bytes32(uint256(uint160(who))));
        return self;
    }

    function with_key(StdStorage storage self, uint256 amt) internal returns (StdStorage storage) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01660000, 1037618708838) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01660001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01660005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01666001, amt) }
        self._keys.push(bytes32(amt));
        return self;
    }

    function with_key(StdStorage storage self, bytes32 key) internal returns (StdStorage storage) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01670000, 1037618708839) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01670001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01670005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01676001, key) }
        self._keys.push(key);
        return self;
    }

    function enable_packed_slots(StdStorage storage self) internal returns (StdStorage storage) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01680000, 1037618708840) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01680001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01680005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01686000, self.slot) }
        self._enable_packed_slots = true;bool certora_local339 = self._enable_packed_slots;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000153,certora_local339)}
        return self;
    }

    function depth(StdStorage storage self, uint256 _depth) internal returns (StdStorage storage) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff016f0000, 1037618708847) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff016f0001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff016f0005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff016f6001, _depth) }
        self._depth = _depth;uint256 certora_local340 = self._depth;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000154,certora_local340)}
        return self;
    }

    function read(StdStorage storage self) private returns (bytes memory) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff016e0000, 1037618708846) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff016e0001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff016e0005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff016e6000, self.slot) }
        FindData storage data = find(self, false);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00010135,0)}
        uint256 mask = getMaskByOffsets(data.offsetLeft, data.offsetRight);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000136,mask)}
        uint256 value = (uint256(vm.load(self._target, bytes32(data.slot))) & mask) >> data.offsetRight;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000137,value)}
        clear(self);
        return abi.encode(value);
    }

    function read_bytes32(StdStorage storage self) internal returns (bytes32) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff016d0000, 1037618708845) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff016d0001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff016d0005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff016d6000, self.slot) }
        return abi.decode(read(self), (bytes32));
    }

    function read_bool(StdStorage storage self) internal returns (bool) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01700000, 1037618708848) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01700001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01700005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01706000, self.slot) }
        int256 v = read_int(self);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000138,v)}
        if (v == 0) return false;
        if (v == 1) return true;
        revert("stdStorage read_bool(StdStorage): Cannot decode. Make sure you are reading a bool.");
    }

    function read_address(StdStorage storage self) internal returns (address) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01710000, 1037618708849) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01710001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01710005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01716000, self.slot) }
        return abi.decode(read(self), (address));
    }

    function read_uint(StdStorage storage self) internal returns (uint256) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01720000, 1037618708850) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01720001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01720005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01726000, self.slot) }
        return abi.decode(read(self), (uint256));
    }

    function read_int(StdStorage storage self) internal returns (int256) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01730000, 1037618708851) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01730001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01730005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01736000, self.slot) }
        return abi.decode(read(self), (int256));
    }

    function parent(StdStorage storage self) internal returns (uint256, bytes32) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01740000, 1037618708852) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01740001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01740005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01746000, self.slot) }
        address who = self._target;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000139,who)}
        uint256 field_depth = self._depth;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0000013a,field_depth)}
        vm.startMappingRecording();
        uint256 child = find(self, true).slot - field_depth;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0000013b,child)}
        (bool found, bytes32 key, bytes32 parent_slot) = vm.getMappingKeyAndParentOf(who, bytes32(child));assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0001013c,0)}
        if (!found) {
            revert(
                "stdStorage read_bool(StdStorage): Cannot find parent. Make sure you give a slot and startMappingRecording() has been called."
            );
        }
        return (uint256(parent_slot), key);
    }

    function root(StdStorage storage self) internal returns (uint256) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01750000, 1037618708853) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01750001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01750005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01756000, self.slot) }
        address who = self._target;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0000013d,who)}
        uint256 field_depth = self._depth;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0000013e,field_depth)}
        vm.startMappingRecording();
        uint256 child = find(self, true).slot - field_depth;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0000013f,child)}
        bool found;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000140,found)}
        bytes32 root_slot;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000141,root_slot)}
        bytes32 parent_slot;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000142,parent_slot)}
        (found,, parent_slot) = vm.getMappingKeyAndParentOf(who, bytes32(child));assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00020155,0)}
        if (!found) {
            revert(
                "stdStorage read_bool(StdStorage): Cannot find parent. Make sure you give a slot and startMappingRecording() has been called."
            );
        }
        while (found) {
            root_slot = parent_slot;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000159,root_slot)}
            (found,, parent_slot) = vm.getMappingKeyAndParentOf(who, bytes32(root_slot));assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0002015a,0)}
        }
        return uint256(root_slot);
    }

    function bytesToBytes32(bytes memory b, uint256 offset) private pure returns (bytes32) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01760000, 1037618708854) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01760001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01760005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01766001, offset) }
        bytes32 out;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000143,out)}

        uint256 max = b.length > 32 ? 32 : b.length;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000144,max)}
        for (uint256 i = 0; i < max; i++) {
            out |= bytes32(b[offset + i] & 0xFF) >> (i * 8);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0000015b,out)}
        }
        return out;
    }

    function flatten(bytes32[] memory b) private pure returns (bytes memory) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff016a0000, 1037618708842) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff016a0001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff016a0005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff016a6000, b) }
        bytes memory result = new bytes(b.length * 32);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00010145,0)}
        for (uint256 i = 0; i < b.length; i++) {
            bytes32 k = b[i];assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000158,k)}
            /// @solidity memory-safe-assembly
            assembly {
                mstore(add(result, add(32, mul(32, i))), k)
            }
        }

        return result;
    }

    function clear(StdStorage storage self) internal {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff016b0000, 1037618708843) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff016b0001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff016b0005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff016b6000, self.slot) }
        delete self._target;
        delete self._sig;
        delete self._keys;
        delete self._depth;
        delete self._enable_packed_slots;
        delete self._calldata;
    }

    // Returns mask which contains non-zero bits for values between `offsetLeft` and `offsetRight`
    // (slotValue & mask) >> offsetRight will be the value of the given packed variable
    function getMaskByOffsets(uint256 offsetLeft, uint256 offsetRight) internal pure returns (uint256 mask) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff016c0000, 1037618708844) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff016c0001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff016c0005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff016c6001, offsetRight) }
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
    {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01690000, 1037618708841) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01690001, 4) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01690005, 585) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01696003, offsetRight) }
        return bytes32((uint256(curValue) & ~getMaskByOffsets(offsetLeft, offsetRight)) | (varValue << offsetRight));
    }
}

library stdStorage {
    Vm private constant vm = Vm(address(uint160(uint256(keccak256("hevm cheat code")))));

    function sigs(string memory sigStr) internal pure returns (bytes4) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01400000, 1037618708800) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01400001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01400005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01406000, sigStr) }
        return stdStorageSafe.sigs(sigStr);
    }

    function find(StdStorage storage self) internal returns (uint256) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01410000, 1037618708801) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01410001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01410005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01416000, self.slot) }
        return find(self, true);
    }

    function find(StdStorage storage self, bool _clear) internal returns (uint256) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01430000, 1037618708803) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01430001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01430005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01436001, _clear) }
        return stdStorageSafe.find(self, _clear).slot;
    }

    function target(StdStorage storage self, address _target) internal returns (StdStorage storage) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01440000, 1037618708804) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01440001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01440005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01446001, _target) }
        return stdStorageSafe.target(self, _target);
    }

    function sig(StdStorage storage self, bytes4 _sig) internal returns (StdStorage storage) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01420000, 1037618708802) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01420001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01420005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01426001, _sig) }
        return stdStorageSafe.sig(self, _sig);
    }

    function sig(StdStorage storage self, string memory _sig) internal returns (StdStorage storage) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01450000, 1037618708805) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01450001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01450005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01456001, _sig) }
        return stdStorageSafe.sig(self, _sig);
    }

    function with_key(StdStorage storage self, address who) internal returns (StdStorage storage) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01460000, 1037618708806) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01460001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01460005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01466001, who) }
        return stdStorageSafe.with_key(self, who);
    }

    function with_key(StdStorage storage self, uint256 amt) internal returns (StdStorage storage) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01470000, 1037618708807) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01470001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01470005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01476001, amt) }
        return stdStorageSafe.with_key(self, amt);
    }

    function with_key(StdStorage storage self, bytes32 key) internal returns (StdStorage storage) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01480000, 1037618708808) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01480001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01480005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01486001, key) }
        return stdStorageSafe.with_key(self, key);
    }

    function with_calldata(StdStorage storage self, bytes memory _calldata) internal returns (StdStorage storage) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01490000, 1037618708809) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01490001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01490005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01496001, _calldata) }
        return stdStorageSafe.with_calldata(self, _calldata);
    }

    function enable_packed_slots(StdStorage storage self) internal returns (StdStorage storage) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff014a0000, 1037618708810) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff014a0001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff014a0005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff014a6000, self.slot) }
        return stdStorageSafe.enable_packed_slots(self);
    }

    function depth(StdStorage storage self, uint256 _depth) internal returns (StdStorage storage) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff014b0000, 1037618708811) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff014b0001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff014b0005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff014b6001, _depth) }
        return stdStorageSafe.depth(self, _depth);
    }

    function clear(StdStorage storage self) internal {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff014c0000, 1037618708812) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff014c0001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff014c0005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff014c6000, self.slot) }
        stdStorageSafe.clear(self);
    }

    function checked_write(StdStorage storage self, address who) internal {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff014d0000, 1037618708813) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff014d0001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff014d0005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff014d6001, who) }
        checked_write(self, bytes32(uint256(uint160(who))));
    }

    function checked_write(StdStorage storage self, uint256 amt) internal {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff014e0000, 1037618708814) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff014e0001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff014e0005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff014e6001, amt) }
        checked_write(self, bytes32(amt));
    }

    function checked_write_int(StdStorage storage self, int256 val) internal {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff014f0000, 1037618708815) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff014f0001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff014f0005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff014f6001, val) }
        checked_write(self, bytes32(uint256(val)));
    }

    function checked_write(StdStorage storage self, bool write) internal {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01560000, 1037618708822) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01560001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01560005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01566001, write) }
        bytes32 t;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000146,t)}
        /// @solidity memory-safe-assembly
        assembly {
            t := write
        }
        checked_write(self, t);
    }

    function checked_write(StdStorage storage self, bytes32 set) internal {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01550000, 1037618708821) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01550001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01550005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01556001, set) }
        address who = self._target;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000147,who)}
        bytes4 fsig = self._sig;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000148,fsig)}
        uint256 field_depth = self._depth;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000149,field_depth)}
        bytes memory params = stdStorageSafe.getCallParams(self);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0001014a,0)}

        if (!self.finds[who][fsig][keccak256(abi.encodePacked(params, field_depth))].found) {
            find(self, false);
        }
        FindData storage data = self.finds[who][fsig][keccak256(abi.encodePacked(params, field_depth))];assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0001014b,0)}
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
        bytes32 curVal = vm.load(who, bytes32(data.slot));assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0000014c,curVal)}
        bytes32 valToSet = stdStorageSafe.getUpdatedSlotValue(curVal, uint256(set), data.offsetLeft, data.offsetRight);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0000014d,valToSet)}

        vm.store(who, bytes32(data.slot), valToSet);

        (bool success, bytes32 callResult) = stdStorageSafe.callTarget(self);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0001014e,0)}

        if (!success || callResult != set) {
            vm.store(who, bytes32(data.slot), curVal);
            revert("stdStorage find(StdStorage): Failed to write value.");
        }
        clear(self);
    }

    function read_bytes32(StdStorage storage self) internal returns (bytes32) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01540000, 1037618708820) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01540001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01540005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01546000, self.slot) }
        return stdStorageSafe.read_bytes32(self);
    }

    function read_bool(StdStorage storage self) internal returns (bool) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01570000, 1037618708823) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01570001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01570005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01576000, self.slot) }
        return stdStorageSafe.read_bool(self);
    }

    function read_address(StdStorage storage self) internal returns (address) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01580000, 1037618708824) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01580001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01580005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01586000, self.slot) }
        return stdStorageSafe.read_address(self);
    }

    function read_uint(StdStorage storage self) internal returns (uint256) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01510000, 1037618708817) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01510001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01510005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01516000, self.slot) }
        return stdStorageSafe.read_uint(self);
    }

    function read_int(StdStorage storage self) internal returns (int256) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01520000, 1037618708818) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01520001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01520005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01526000, self.slot) }
        return stdStorageSafe.read_int(self);
    }

    function parent(StdStorage storage self) internal returns (uint256, bytes32) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01530000, 1037618708819) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01530001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01530005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01536000, self.slot) }
        return stdStorageSafe.parent(self);
    }

    function root(StdStorage storage self) internal returns (uint256) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01500000, 1037618708816) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01500001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01500005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01506000, self.slot) }
        return stdStorageSafe.root(self);
    }
}
