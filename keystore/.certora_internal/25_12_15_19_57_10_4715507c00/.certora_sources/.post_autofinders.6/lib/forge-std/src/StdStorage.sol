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

    function sigs(string memory sigStr) internal pure returns (bytes4) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0b590000, 1037618711385) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0b590001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0b590005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0b596000, sigStr) }
        return bytes4(keccak256(bytes(sigStr)));
    }

    function getCallParams(StdStorage storage self) internal view returns (bytes memory) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0b5a0000, 1037618711386) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0b5a0001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0b5a0005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0b5a6000, self.slot) }
        if (self._calldata.length == 0) {
            return flatten(self._keys);
        } else {
            return self._calldata;
        }
    }

    // Calls target contract with configured parameters
    function callTarget(StdStorage storage self) internal view returns (bool, bytes32) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0b5c0000, 1037618711388) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0b5c0001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0b5c0005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0b5c6000, self.slot) }
        bytes memory cald = abi.encodePacked(self._sig, getCallParams(self));assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000100df,0)}
        (bool success, bytes memory rdat) = self._target.staticcall(cald);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000100e0,0)}
        bytes32 result = bytesToBytes32(rdat, 32 * self._depth);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000000e1,result)}

        return (success, result);
    }

    // Tries mutating slot value to determine if the targeted value is stored in it.
    // If current value is 0, then we are setting slot value to type(uint256).max
    // Otherwise, we set it to 0. That way, return value should always be affected.
    function checkSlotMutatesCall(StdStorage storage self, bytes32 slot) internal returns (bool) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0b5d0000, 1037618711389) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0b5d0001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0b5d0005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0b5d6001, slot) }
        bytes32 prevSlotValue = vm.load(self._target, slot);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000000e2,prevSlotValue)}
        (bool success, bytes32 prevReturnValue) = callTarget(self);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000100e3,0)}

        bytes32 testVal = prevReturnValue == bytes32(0) ? bytes32(UINT256_MAX) : bytes32(0);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000000e4,testVal)}
        vm.store(self._target, slot, testVal);

        (, bytes32 newReturnValue) = callTarget(self);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000100e5,0)}

        vm.store(self._target, slot, prevSlotValue);

        return (success && (prevReturnValue != newReturnValue));
    }

    // Tries setting one of the bits in slot to 1 until return value changes.
    // Index of resulted bit is an offset packed slot has from left/right side
    function findOffset(StdStorage storage self, bytes32 slot, bool left) internal returns (bool, uint256) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0b5b0000, 1037618711387) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0b5b0001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0b5b0005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0b5b6002, left) }
        for (uint256 offset = 0; offset < 256; offset++) {
            uint256 valueToPut = left ? (1 << (255 - offset)) : (1 << offset);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000110,valueToPut)}
            vm.store(self._target, slot, bytes32(valueToPut));

            (bool success, bytes32 data) = callTarget(self);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00010111,0)}

            if (success && (uint256(data) > 0)) {
                return (true, offset);
            }
        }
        return (false, 0);
    }

    function findOffsets(StdStorage storage self, bytes32 slot) internal returns (bool, uint256, uint256) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0b5e0000, 1037618711390) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0b5e0001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0b5e0005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0b5e6001, slot) }
        bytes32 prevSlotValue = vm.load(self._target, slot);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000000e6,prevSlotValue)}

        (bool foundLeft, uint256 offsetLeft) = findOffset(self, slot, true);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000100e7,0)}
        (bool foundRight, uint256 offsetRight) = findOffset(self, slot, false);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000100e8,0)}

        // `findOffset` may mutate slot value, so we are setting it to initial value
        vm.store(self._target, slot, prevSlotValue);
        return (foundLeft && foundRight, offsetLeft, offsetRight);
    }

    function find(StdStorage storage self) internal returns (FindData storage) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0b5f0000, 1037618711391) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0b5f0001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0b5f0005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0b5f6000, self.slot) }
        return find(self, true);
    }

    /// @notice find an arbitrary storage slot given a function sig, input data, address of the contract and a value to check against
    // slot complexity:
    //  if flat, will be bytes32(uint256(uint));
    //  if map, will be keccak256(abi.encode(key, uint(slot)));
    //  if deep map, will be keccak256(abi.encode(key1, keccak256(abi.encode(key0, uint(slot)))));
    //  if map struct, will be bytes32(uint256(keccak256(abi.encode(key1, keccak256(abi.encode(key0, uint(slot)))))) + structFieldDepth);
    function find(StdStorage storage self, bool _clear) internal returns (FindData storage) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0b600000, 1037618711392) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0b600001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0b600005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0b606001, _clear) }
        address who = self._target;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000000e9,who)}
        bytes4 fsig = self._sig;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000000ea,fsig)}
        uint256 field_depth = self._depth;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000000eb,field_depth)}
        bytes memory params = getCallParams(self);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000100ec,0)}

        // calldata to test against
        if (self.finds[who][fsig][keccak256(abi.encodePacked(params, field_depth))].found) {
            if (_clear) {
                clear(self);
            }
            return self.finds[who][fsig][keccak256(abi.encodePacked(params, field_depth))];
        }
        vm.record();
        (, bytes32 callResult) = callTarget(self);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000100ed,0)}
        (bytes32[] memory reads,) = vm.accesses(address(who));assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000100ee,0)}

        if (reads.length == 0) {
            revert("stdStorage find(StdStorage): No storage use detected for target.");
        } else {
            for (uint256 i = reads.length; --i >= 0;) {
                bytes32 prev = vm.load(who, reads[i]);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000116,prev)}
                if (prev == bytes32(0)) {
                    emit WARNING_UninitedSlot(who, uint256(reads[i]));
                }

                if (!checkSlotMutatesCall(self, reads[i])) {
                    continue;
                }

                (uint256 offsetLeft, uint256 offsetRight) = (0, 0);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00010117,0)}

                if (self._enable_packed_slots) {
                    bool found;
                    (found, offsetLeft, offsetRight) = findOffsets(self, reads[i]);
                    if (!found) {
                        continue;
                    }
                }

                // Check that value between found offsets is equal to the current call result
                uint256 curVal = (uint256(prev) & getMaskByOffsets(offsetLeft, offsetRight)) >> offsetRight;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000118,curVal)}

                if (uint256(callResult) != curVal) {
                    continue;
                }

                emit SlotFound(who, fsig, keccak256(abi.encodePacked(params, field_depth)), uint256(reads[i]));
                self.finds[who][fsig][keccak256(abi.encodePacked(params, field_depth))] =
                    FindData(uint256(reads[i]), offsetLeft, offsetRight, true);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00020119,0)}
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

    function target(StdStorage storage self, address _target) internal returns (StdStorage storage) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0b610000, 1037618711393) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0b610001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0b610005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0b616001, _target) }
        self._target = _target;address certora_local265 = self._target;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000109,certora_local265)}
        return self;
    }

    function sig(StdStorage storage self, bytes4 _sig) internal returns (StdStorage storage) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0b620000, 1037618711394) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0b620001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0b620005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0b626001, _sig) }
        self._sig = _sig;bytes4 certora_local266 = self._sig;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0000010a,certora_local266)}
        return self;
    }

    function sig(StdStorage storage self, string memory _sig) internal returns (StdStorage storage) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0b630000, 1037618711395) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0b630001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0b630005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0b636001, _sig) }
        self._sig = sigs(_sig);bytes4 certora_local267 = self._sig;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0000010b,certora_local267)}
        return self;
    }

    function with_calldata(StdStorage storage self, bytes memory _calldata) internal returns (StdStorage storage) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0b640000, 1037618711396) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0b640001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0b640005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0b646001, _calldata) }
        self._calldata = _calldata;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0002010c,0)}
        return self;
    }

    function with_key(StdStorage storage self, address who) internal returns (StdStorage storage) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0b650000, 1037618711397) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0b650001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0b650005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0b656001, who) }
        self._keys.push(bytes32(uint256(uint160(who))));
        return self;
    }

    function with_key(StdStorage storage self, uint256 amt) internal returns (StdStorage storage) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0b660000, 1037618711398) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0b660001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0b660005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0b666001, amt) }
        self._keys.push(bytes32(amt));
        return self;
    }

    function with_key(StdStorage storage self, bytes32 key) internal returns (StdStorage storage) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0b670000, 1037618711399) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0b670001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0b670005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0b676001, key) }
        self._keys.push(key);
        return self;
    }

    function enable_packed_slots(StdStorage storage self) internal returns (StdStorage storage) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0b680000, 1037618711400) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0b680001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0b680005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0b686000, self.slot) }
        self._enable_packed_slots = true;bool certora_local269 = self._enable_packed_slots;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0000010d,certora_local269)}
        return self;
    }

    function depth(StdStorage storage self, uint256 _depth) internal returns (StdStorage storage) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0b6f0000, 1037618711407) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0b6f0001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0b6f0005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0b6f6001, _depth) }
        self._depth = _depth;uint256 certora_local270 = self._depth;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0000010e,certora_local270)}
        return self;
    }

    function read(StdStorage storage self) private returns (bytes memory) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0b6e0000, 1037618711406) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0b6e0001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0b6e0005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0b6e6000, self.slot) }
        FindData storage data = find(self, false);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000100ef,0)}
        uint256 mask = getMaskByOffsets(data.offsetLeft, data.offsetRight);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000000f0,mask)}
        uint256 value = (uint256(vm.load(self._target, bytes32(data.slot))) & mask) >> data.offsetRight;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000000f1,value)}
        clear(self);
        return abi.encode(value);
    }

    function read_bytes32(StdStorage storage self) internal returns (bytes32) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0b6d0000, 1037618711405) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0b6d0001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0b6d0005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0b6d6000, self.slot) }
        return abi.decode(read(self), (bytes32));
    }

    function read_bool(StdStorage storage self) internal returns (bool) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0b700000, 1037618711408) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0b700001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0b700005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0b706000, self.slot) }
        int256 v = read_int(self);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000000f2,v)}
        if (v == 0) return false;
        if (v == 1) return true;
        revert("stdStorage read_bool(StdStorage): Cannot decode. Make sure you are reading a bool.");
    }

    function read_address(StdStorage storage self) internal returns (address) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0b710000, 1037618711409) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0b710001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0b710005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0b716000, self.slot) }
        return abi.decode(read(self), (address));
    }

    function read_uint(StdStorage storage self) internal returns (uint256) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0b720000, 1037618711410) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0b720001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0b720005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0b726000, self.slot) }
        return abi.decode(read(self), (uint256));
    }

    function read_int(StdStorage storage self) internal returns (int256) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0b730000, 1037618711411) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0b730001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0b730005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0b736000, self.slot) }
        return abi.decode(read(self), (int256));
    }

    function parent(StdStorage storage self) internal returns (uint256, bytes32) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0b740000, 1037618711412) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0b740001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0b740005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0b746000, self.slot) }
        address who = self._target;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000000f3,who)}
        uint256 field_depth = self._depth;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000000f4,field_depth)}
        vm.startMappingRecording();
        uint256 child = find(self, true).slot - field_depth;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000000f5,child)}
        (bool found, bytes32 key, bytes32 parent_slot) = vm.getMappingKeyAndParentOf(who, bytes32(child));assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000100f6,0)}
        if (!found) {
            revert(
                "stdStorage read_bool(StdStorage): Cannot find parent. Make sure you give a slot and startMappingRecording() has been called."
            );
        }
        return (uint256(parent_slot), key);
    }

    function root(StdStorage storage self) internal returns (uint256) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0b750000, 1037618711413) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0b750001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0b750005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0b756000, self.slot) }
        address who = self._target;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000000f7,who)}
        uint256 field_depth = self._depth;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000000f8,field_depth)}
        vm.startMappingRecording();
        uint256 child = find(self, true).slot - field_depth;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000000f9,child)}
        bool found;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000000fa,found)}
        bytes32 root_slot;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000000fb,root_slot)}
        bytes32 parent_slot;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000000fc,parent_slot)}
        (found,, parent_slot) = vm.getMappingKeyAndParentOf(who, bytes32(child));assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0002010f,0)}
        if (!found) {
            revert(
                "stdStorage read_bool(StdStorage): Cannot find parent. Make sure you give a slot and startMappingRecording() has been called."
            );
        }
        while (found) {
            root_slot = parent_slot;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000113,root_slot)}
            (found,, parent_slot) = vm.getMappingKeyAndParentOf(who, bytes32(root_slot));assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00020114,0)}
        }
        return uint256(root_slot);
    }

    function bytesToBytes32(bytes memory b, uint256 offset) private pure returns (bytes32) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0b760000, 1037618711414) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0b760001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0b760005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0b766001, offset) }
        bytes32 out;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000000fd,out)}

        uint256 max = b.length > 32 ? 32 : b.length;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000000fe,max)}
        for (uint256 i = 0; i < max; i++) {
            out |= bytes32(b[offset + i] & 0xFF) >> (i * 8);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000115,out)}
        }
        return out;
    }

    function flatten(bytes32[] memory b) private pure returns (bytes memory) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0b6a0000, 1037618711402) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0b6a0001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0b6a0005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0b6a6000, b) }
        bytes memory result = new bytes(b.length * 32);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000100ff,0)}
        for (uint256 i = 0; i < b.length; i++) {
            bytes32 k = b[i];assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000112,k)}
            /// @solidity memory-safe-assembly
            assembly {
                mstore(add(result, add(32, mul(32, i))), k)
            }
        }

        return result;
    }

    function clear(StdStorage storage self) internal {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0b6b0000, 1037618711403) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0b6b0001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0b6b0005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0b6b6000, self.slot) }
        delete self._target;
        delete self._sig;
        delete self._keys;
        delete self._depth;
        delete self._enable_packed_slots;
        delete self._calldata;
    }

    // Returns mask which contains non-zero bits for values between `offsetLeft` and `offsetRight`
    // (slotValue & mask) >> offsetRight will be the value of the given packed variable
    function getMaskByOffsets(uint256 offsetLeft, uint256 offsetRight) internal pure returns (uint256 mask) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0b6c0000, 1037618711404) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0b6c0001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0b6c0005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0b6c6001, offsetRight) }
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
    {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0b690000, 1037618711401) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0b690001, 4) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0b690005, 585) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0b696003, offsetRight) }
        return bytes32((uint256(curValue) & ~getMaskByOffsets(offsetLeft, offsetRight)) | (varValue << offsetRight));
    }
}

library stdStorage {
    Vm private constant vm = Vm(address(uint160(uint256(keccak256("hevm cheat code")))));

    function sigs(string memory sigStr) internal pure returns (bytes4) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0b400000, 1037618711360) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0b400001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0b400005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0b406000, sigStr) }
        return stdStorageSafe.sigs(sigStr);
    }

    function find(StdStorage storage self) internal returns (uint256) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0b410000, 1037618711361) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0b410001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0b410005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0b416000, self.slot) }
        return find(self, true);
    }

    function find(StdStorage storage self, bool _clear) internal returns (uint256) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0b430000, 1037618711363) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0b430001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0b430005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0b436001, _clear) }
        return stdStorageSafe.find(self, _clear).slot;
    }

    function target(StdStorage storage self, address _target) internal returns (StdStorage storage) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0b440000, 1037618711364) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0b440001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0b440005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0b446001, _target) }
        return stdStorageSafe.target(self, _target);
    }

    function sig(StdStorage storage self, bytes4 _sig) internal returns (StdStorage storage) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0b420000, 1037618711362) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0b420001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0b420005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0b426001, _sig) }
        return stdStorageSafe.sig(self, _sig);
    }

    function sig(StdStorage storage self, string memory _sig) internal returns (StdStorage storage) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0b450000, 1037618711365) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0b450001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0b450005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0b456001, _sig) }
        return stdStorageSafe.sig(self, _sig);
    }

    function with_key(StdStorage storage self, address who) internal returns (StdStorage storage) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0b460000, 1037618711366) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0b460001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0b460005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0b466001, who) }
        return stdStorageSafe.with_key(self, who);
    }

    function with_key(StdStorage storage self, uint256 amt) internal returns (StdStorage storage) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0b470000, 1037618711367) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0b470001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0b470005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0b476001, amt) }
        return stdStorageSafe.with_key(self, amt);
    }

    function with_key(StdStorage storage self, bytes32 key) internal returns (StdStorage storage) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0b480000, 1037618711368) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0b480001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0b480005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0b486001, key) }
        return stdStorageSafe.with_key(self, key);
    }

    function with_calldata(StdStorage storage self, bytes memory _calldata) internal returns (StdStorage storage) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0b490000, 1037618711369) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0b490001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0b490005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0b496001, _calldata) }
        return stdStorageSafe.with_calldata(self, _calldata);
    }

    function enable_packed_slots(StdStorage storage self) internal returns (StdStorage storage) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0b4a0000, 1037618711370) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0b4a0001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0b4a0005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0b4a6000, self.slot) }
        return stdStorageSafe.enable_packed_slots(self);
    }

    function depth(StdStorage storage self, uint256 _depth) internal returns (StdStorage storage) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0b4b0000, 1037618711371) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0b4b0001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0b4b0005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0b4b6001, _depth) }
        return stdStorageSafe.depth(self, _depth);
    }

    function clear(StdStorage storage self) internal {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0b4c0000, 1037618711372) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0b4c0001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0b4c0005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0b4c6000, self.slot) }
        stdStorageSafe.clear(self);
    }

    function checked_write(StdStorage storage self, address who) internal {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0b4d0000, 1037618711373) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0b4d0001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0b4d0005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0b4d6001, who) }
        checked_write(self, bytes32(uint256(uint160(who))));
    }

    function checked_write(StdStorage storage self, uint256 amt) internal {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0b4e0000, 1037618711374) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0b4e0001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0b4e0005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0b4e6001, amt) }
        checked_write(self, bytes32(amt));
    }

    function checked_write_int(StdStorage storage self, int256 val) internal {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0b4f0000, 1037618711375) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0b4f0001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0b4f0005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0b4f6001, val) }
        checked_write(self, bytes32(uint256(val)));
    }

    function checked_write(StdStorage storage self, bool write) internal {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0b560000, 1037618711382) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0b560001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0b560005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0b566001, write) }
        bytes32 t;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000100,t)}
        /// @solidity memory-safe-assembly
        assembly {
            t := write
        }
        checked_write(self, t);
    }

    function checked_write(StdStorage storage self, bytes32 set) internal {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0b550000, 1037618711381) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0b550001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0b550005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0b556001, set) }
        address who = self._target;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000101,who)}
        bytes4 fsig = self._sig;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000102,fsig)}
        uint256 field_depth = self._depth;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000103,field_depth)}
        bytes memory params = stdStorageSafe.getCallParams(self);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00010104,0)}

        if (!self.finds[who][fsig][keccak256(abi.encodePacked(params, field_depth))].found) {
            find(self, false);
        }
        FindData storage data = self.finds[who][fsig][keccak256(abi.encodePacked(params, field_depth))];assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00010105,0)}
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
        bytes32 curVal = vm.load(who, bytes32(data.slot));assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000106,curVal)}
        bytes32 valToSet = stdStorageSafe.getUpdatedSlotValue(curVal, uint256(set), data.offsetLeft, data.offsetRight);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000107,valToSet)}

        vm.store(who, bytes32(data.slot), valToSet);

        (bool success, bytes32 callResult) = stdStorageSafe.callTarget(self);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00010108,0)}

        if (!success || callResult != set) {
            vm.store(who, bytes32(data.slot), curVal);
            revert("stdStorage find(StdStorage): Failed to write value.");
        }
        clear(self);
    }

    function read_bytes32(StdStorage storage self) internal returns (bytes32) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0b540000, 1037618711380) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0b540001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0b540005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0b546000, self.slot) }
        return stdStorageSafe.read_bytes32(self);
    }

    function read_bool(StdStorage storage self) internal returns (bool) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0b570000, 1037618711383) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0b570001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0b570005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0b576000, self.slot) }
        return stdStorageSafe.read_bool(self);
    }

    function read_address(StdStorage storage self) internal returns (address) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0b580000, 1037618711384) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0b580001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0b580005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0b586000, self.slot) }
        return stdStorageSafe.read_address(self);
    }

    function read_uint(StdStorage storage self) internal returns (uint256) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0b510000, 1037618711377) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0b510001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0b510005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0b516000, self.slot) }
        return stdStorageSafe.read_uint(self);
    }

    function read_int(StdStorage storage self) internal returns (int256) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0b520000, 1037618711378) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0b520001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0b520005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0b526000, self.slot) }
        return stdStorageSafe.read_int(self);
    }

    function parent(StdStorage storage self) internal returns (uint256, bytes32) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0b530000, 1037618711379) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0b530001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0b530005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0b536000, self.slot) }
        return stdStorageSafe.parent(self);
    }

    function root(StdStorage storage self) internal returns (uint256) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0b500000, 1037618711376) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0b500001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0b500005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0b506000, self.slot) }
        return stdStorageSafe.root(self);
    }
}
