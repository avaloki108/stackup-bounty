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

    function sigs(string memory sigStr) internal pure returns (bytes4) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a090000, 1037618711049) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a090001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a090005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a096000, sigStr) }
        return bytes4(keccak256(bytes(sigStr)));
    }

    function getCallParams(StdStorage storage self) internal view returns (bytes memory) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a0a0000, 1037618711050) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a0a0001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a0a0005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a0a6000, self.slot) }
        if (self._calldata.length == 0) {
            return flatten(self._keys);
        } else {
            return self._calldata;
        }
    }

    // Calls target contract with configured parameters
    function callTarget(StdStorage storage self) internal view returns (bool, bytes32) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a0c0000, 1037618711052) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a0c0001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a0c0005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a0c6000, self.slot) }
        bytes memory cald = abi.encodePacked(self._sig, getCallParams(self));assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00010093,0)}
        (bool success, bytes memory rdat) = self._target.staticcall(cald);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00010094,0)}
        bytes32 result = bytesToBytes32(rdat, 32 * self._depth);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000095,result)}

        return (success, result);
    }

    // Tries mutating slot value to determine if the targeted value is stored in it.
    // If current value is 0, then we are setting slot value to type(uint256).max
    // Otherwise, we set it to 0. That way, return value should always be affected.
    function checkSlotMutatesCall(StdStorage storage self, bytes32 slot) internal returns (bool) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a0d0000, 1037618711053) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a0d0001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a0d0005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a0d6001, slot) }
        bytes32 prevSlotValue = vm.load(self._target, slot);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000096,prevSlotValue)}
        (bool success, bytes32 prevReturnValue) = callTarget(self);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00010097,0)}

        bytes32 testVal = prevReturnValue == bytes32(0) ? bytes32(UINT256_MAX) : bytes32(0);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000098,testVal)}
        vm.store(self._target, slot, testVal);

        (, bytes32 newReturnValue) = callTarget(self);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00010099,0)}

        vm.store(self._target, slot, prevSlotValue);

        return (success && (prevReturnValue != newReturnValue));
    }

    // Tries setting one of the bits in slot to 1 until return value changes.
    // Index of resulted bit is an offset packed slot has from left/right side
    function findOffset(StdStorage storage self, bytes32 slot, bool left) internal returns (bool, uint256) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a0b0000, 1037618711051) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a0b0001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a0b0005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a0b6002, left) }
        for (uint256 offset = 0; offset < 256; offset++) {
            uint256 valueToPut = left ? (1 << (255 - offset)) : (1 << offset);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000000c4,valueToPut)}
            vm.store(self._target, slot, bytes32(valueToPut));

            (bool success, bytes32 data) = callTarget(self);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000100c5,0)}

            if (success && (uint256(data) > 0)) {
                return (true, offset);
            }
        }
        return (false, 0);
    }

    function findOffsets(StdStorage storage self, bytes32 slot) internal returns (bool, uint256, uint256) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a0e0000, 1037618711054) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a0e0001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a0e0005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a0e6001, slot) }
        bytes32 prevSlotValue = vm.load(self._target, slot);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0000009a,prevSlotValue)}

        (bool foundLeft, uint256 offsetLeft) = findOffset(self, slot, true);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0001009b,0)}
        (bool foundRight, uint256 offsetRight) = findOffset(self, slot, false);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0001009c,0)}

        // `findOffset` may mutate slot value, so we are setting it to initial value
        vm.store(self._target, slot, prevSlotValue);
        return (foundLeft && foundRight, offsetLeft, offsetRight);
    }

    function find(StdStorage storage self) internal returns (FindData storage) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a0f0000, 1037618711055) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a0f0001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a0f0005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a0f6000, self.slot) }
        return find(self, true);
    }

    /// @notice find an arbitrary storage slot given a function sig, input data, address of the contract and a value to check against
    // slot complexity:
    //  if flat, will be bytes32(uint256(uint));
    //  if map, will be keccak256(abi.encode(key, uint(slot)));
    //  if deep map, will be keccak256(abi.encode(key1, keccak256(abi.encode(key0, uint(slot)))));
    //  if map struct, will be bytes32(uint256(keccak256(abi.encode(key1, keccak256(abi.encode(key0, uint(slot)))))) + structFieldDepth);
    function find(StdStorage storage self, bool _clear) internal returns (FindData storage) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a100000, 1037618711056) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a100001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a100005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a106001, _clear) }
        address who = self._target;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0000009d,who)}
        bytes4 fsig = self._sig;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0000009e,fsig)}
        uint256 field_depth = self._depth;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0000009f,field_depth)}
        bytes memory params = getCallParams(self);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000100a0,0)}

        // calldata to test against
        if (self.finds[who][fsig][keccak256(abi.encodePacked(params, field_depth))].found) {
            if (_clear) {
                clear(self);
            }
            return self.finds[who][fsig][keccak256(abi.encodePacked(params, field_depth))];
        }
        vm.record();
        (, bytes32 callResult) = callTarget(self);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000100a1,0)}
        (bytes32[] memory reads,) = vm.accesses(address(who));assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000100a2,0)}

        if (reads.length == 0) {
            revert("stdStorage find(StdStorage): No storage use detected for target.");
        } else {
            for (uint256 i = reads.length; --i >= 0;) {
                bytes32 prev = vm.load(who, reads[i]);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000000ca,prev)}
                if (prev == bytes32(0)) {
                    emit WARNING_UninitedSlot(who, uint256(reads[i]));
                }

                if (!checkSlotMutatesCall(self, reads[i])) {
                    continue;
                }

                (uint256 offsetLeft, uint256 offsetRight) = (0, 0);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000100cb,0)}

                if (self._enable_packed_slots) {
                    bool found;
                    (found, offsetLeft, offsetRight) = findOffsets(self, reads[i]);
                    if (!found) {
                        continue;
                    }
                }

                // Check that value between found offsets is equal to the current call result
                uint256 curVal = (uint256(prev) & getMaskByOffsets(offsetLeft, offsetRight)) >> offsetRight;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000000cc,curVal)}

                if (uint256(callResult) != curVal) {
                    continue;
                }

                emit SlotFound(who, fsig, keccak256(abi.encodePacked(params, field_depth)), uint256(reads[i]));
                self.finds[who][fsig][keccak256(abi.encodePacked(params, field_depth))] =
                    FindData(uint256(reads[i]), offsetLeft, offsetRight, true);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000200cd,0)}
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

    function target(StdStorage storage self, address _target) internal returns (StdStorage storage) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a110000, 1037618711057) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a110001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a110005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a116001, _target) }
        self._target = _target;address certora_local189 = self._target;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000000bd,certora_local189)}
        return self;
    }

    function sig(StdStorage storage self, bytes4 _sig) internal returns (StdStorage storage) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a120000, 1037618711058) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a120001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a120005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a126001, _sig) }
        self._sig = _sig;bytes4 certora_local190 = self._sig;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000000be,certora_local190)}
        return self;
    }

    function sig(StdStorage storage self, string memory _sig) internal returns (StdStorage storage) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a130000, 1037618711059) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a130001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a130005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a136001, _sig) }
        self._sig = sigs(_sig);bytes4 certora_local191 = self._sig;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000000bf,certora_local191)}
        return self;
    }

    function with_calldata(StdStorage storage self, bytes memory _calldata) internal returns (StdStorage storage) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a140000, 1037618711060) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a140001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a140005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a146001, _calldata) }
        self._calldata = _calldata;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000200c0,0)}
        return self;
    }

    function with_key(StdStorage storage self, address who) internal returns (StdStorage storage) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a150000, 1037618711061) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a150001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a150005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a156001, who) }
        self._keys.push(bytes32(uint256(uint160(who))));
        return self;
    }

    function with_key(StdStorage storage self, uint256 amt) internal returns (StdStorage storage) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a160000, 1037618711062) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a160001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a160005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a166001, amt) }
        self._keys.push(bytes32(amt));
        return self;
    }

    function with_key(StdStorage storage self, bytes32 key) internal returns (StdStorage storage) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a170000, 1037618711063) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a170001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a170005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a176001, key) }
        self._keys.push(key);
        return self;
    }

    function enable_packed_slots(StdStorage storage self) internal returns (StdStorage storage) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a180000, 1037618711064) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a180001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a180005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a186000, self.slot) }
        self._enable_packed_slots = true;bool certora_local193 = self._enable_packed_slots;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000000c1,certora_local193)}
        return self;
    }

    function depth(StdStorage storage self, uint256 _depth) internal returns (StdStorage storage) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a1f0000, 1037618711071) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a1f0001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a1f0005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a1f6001, _depth) }
        self._depth = _depth;uint256 certora_local194 = self._depth;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000000c2,certora_local194)}
        return self;
    }

    function read(StdStorage storage self) private returns (bytes memory) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a1e0000, 1037618711070) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a1e0001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a1e0005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a1e6000, self.slot) }
        FindData storage data = find(self, false);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000100a3,0)}
        uint256 mask = getMaskByOffsets(data.offsetLeft, data.offsetRight);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000000a4,mask)}
        uint256 value = (uint256(vm.load(self._target, bytes32(data.slot))) & mask) >> data.offsetRight;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000000a5,value)}
        clear(self);
        return abi.encode(value);
    }

    function read_bytes32(StdStorage storage self) internal returns (bytes32) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a1d0000, 1037618711069) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a1d0001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a1d0005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a1d6000, self.slot) }
        return abi.decode(read(self), (bytes32));
    }

    function read_bool(StdStorage storage self) internal returns (bool) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a200000, 1037618711072) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a200001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a200005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a206000, self.slot) }
        int256 v = read_int(self);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000000a6,v)}
        if (v == 0) return false;
        if (v == 1) return true;
        revert("stdStorage read_bool(StdStorage): Cannot decode. Make sure you are reading a bool.");
    }

    function read_address(StdStorage storage self) internal returns (address) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a210000, 1037618711073) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a210001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a210005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a216000, self.slot) }
        return abi.decode(read(self), (address));
    }

    function read_uint(StdStorage storage self) internal returns (uint256) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a220000, 1037618711074) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a220001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a220005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a226000, self.slot) }
        return abi.decode(read(self), (uint256));
    }

    function read_int(StdStorage storage self) internal returns (int256) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a230000, 1037618711075) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a230001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a230005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a236000, self.slot) }
        return abi.decode(read(self), (int256));
    }

    function parent(StdStorage storage self) internal returns (uint256, bytes32) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a240000, 1037618711076) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a240001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a240005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a246000, self.slot) }
        address who = self._target;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000000a7,who)}
        uint256 field_depth = self._depth;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000000a8,field_depth)}
        vm.startMappingRecording();
        uint256 child = find(self, true).slot - field_depth;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000000a9,child)}
        (bool found, bytes32 key, bytes32 parent_slot) = vm.getMappingKeyAndParentOf(who, bytes32(child));assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000100aa,0)}
        if (!found) {
            revert(
                "stdStorage read_bool(StdStorage): Cannot find parent. Make sure you give a slot and startMappingRecording() has been called."
            );
        }
        return (uint256(parent_slot), key);
    }

    function root(StdStorage storage self) internal returns (uint256) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a250000, 1037618711077) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a250001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a250005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a256000, self.slot) }
        address who = self._target;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000000ab,who)}
        uint256 field_depth = self._depth;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000000ac,field_depth)}
        vm.startMappingRecording();
        uint256 child = find(self, true).slot - field_depth;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000000ad,child)}
        bool found;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000000ae,found)}
        bytes32 root_slot;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000000af,root_slot)}
        bytes32 parent_slot;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000000b0,parent_slot)}
        (found,, parent_slot) = vm.getMappingKeyAndParentOf(who, bytes32(child));assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000200c3,0)}
        if (!found) {
            revert(
                "stdStorage read_bool(StdStorage): Cannot find parent. Make sure you give a slot and startMappingRecording() has been called."
            );
        }
        while (found) {
            root_slot = parent_slot;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000000c7,root_slot)}
            (found,, parent_slot) = vm.getMappingKeyAndParentOf(who, bytes32(root_slot));assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000200c8,0)}
        }
        return uint256(root_slot);
    }

    function bytesToBytes32(bytes memory b, uint256 offset) private pure returns (bytes32) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a260000, 1037618711078) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a260001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a260005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a266001, offset) }
        bytes32 out;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000000b1,out)}

        uint256 max = b.length > 32 ? 32 : b.length;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000000b2,max)}
        for (uint256 i = 0; i < max; i++) {
            out |= bytes32(b[offset + i] & 0xFF) >> (i * 8);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000000c9,out)}
        }
        return out;
    }

    function flatten(bytes32[] memory b) private pure returns (bytes memory) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a1a0000, 1037618711066) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a1a0001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a1a0005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a1a6000, b) }
        bytes memory result = new bytes(b.length * 32);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000100b3,0)}
        for (uint256 i = 0; i < b.length; i++) {
            bytes32 k = b[i];assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000000c6,k)}
            /// @solidity memory-safe-assembly
            assembly {
                mstore(add(result, add(32, mul(32, i))), k)
            }
        }

        return result;
    }

    function clear(StdStorage storage self) internal {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a1b0000, 1037618711067) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a1b0001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a1b0005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a1b6000, self.slot) }
        delete self._target;
        delete self._sig;
        delete self._keys;
        delete self._depth;
        delete self._enable_packed_slots;
        delete self._calldata;
    }

    // Returns mask which contains non-zero bits for values between `offsetLeft` and `offsetRight`
    // (slotValue & mask) >> offsetRight will be the value of the given packed variable
    function getMaskByOffsets(uint256 offsetLeft, uint256 offsetRight) internal pure returns (uint256 mask) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a1c0000, 1037618711068) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a1c0001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a1c0005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a1c6001, offsetRight) }
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
    {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a190000, 1037618711065) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a190001, 4) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a190005, 585) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a196003, offsetRight) }
        return bytes32((uint256(curValue) & ~getMaskByOffsets(offsetLeft, offsetRight)) | (varValue << offsetRight));
    }
}

library stdStorage {
    Vm private constant vm = Vm(address(uint160(uint256(keccak256("hevm cheat code")))));

    function sigs(string memory sigStr) internal pure returns (bytes4) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09f00000, 1037618711024) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09f00001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09f00005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09f06000, sigStr) }
        return stdStorageSafe.sigs(sigStr);
    }

    function find(StdStorage storage self) internal returns (uint256) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09f10000, 1037618711025) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09f10001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09f10005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09f16000, self.slot) }
        return find(self, true);
    }

    function find(StdStorage storage self, bool _clear) internal returns (uint256) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09f30000, 1037618711027) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09f30001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09f30005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09f36001, _clear) }
        return stdStorageSafe.find(self, _clear).slot;
    }

    function target(StdStorage storage self, address _target) internal returns (StdStorage storage) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09f40000, 1037618711028) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09f40001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09f40005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09f46001, _target) }
        return stdStorageSafe.target(self, _target);
    }

    function sig(StdStorage storage self, bytes4 _sig) internal returns (StdStorage storage) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09f20000, 1037618711026) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09f20001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09f20005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09f26001, _sig) }
        return stdStorageSafe.sig(self, _sig);
    }

    function sig(StdStorage storage self, string memory _sig) internal returns (StdStorage storage) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09f50000, 1037618711029) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09f50001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09f50005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09f56001, _sig) }
        return stdStorageSafe.sig(self, _sig);
    }

    function with_key(StdStorage storage self, address who) internal returns (StdStorage storage) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09f60000, 1037618711030) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09f60001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09f60005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09f66001, who) }
        return stdStorageSafe.with_key(self, who);
    }

    function with_key(StdStorage storage self, uint256 amt) internal returns (StdStorage storage) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09f70000, 1037618711031) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09f70001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09f70005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09f76001, amt) }
        return stdStorageSafe.with_key(self, amt);
    }

    function with_key(StdStorage storage self, bytes32 key) internal returns (StdStorage storage) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09f80000, 1037618711032) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09f80001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09f80005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09f86001, key) }
        return stdStorageSafe.with_key(self, key);
    }

    function with_calldata(StdStorage storage self, bytes memory _calldata) internal returns (StdStorage storage) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09f90000, 1037618711033) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09f90001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09f90005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09f96001, _calldata) }
        return stdStorageSafe.with_calldata(self, _calldata);
    }

    function enable_packed_slots(StdStorage storage self) internal returns (StdStorage storage) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09fa0000, 1037618711034) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09fa0001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09fa0005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09fa6000, self.slot) }
        return stdStorageSafe.enable_packed_slots(self);
    }

    function depth(StdStorage storage self, uint256 _depth) internal returns (StdStorage storage) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09fb0000, 1037618711035) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09fb0001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09fb0005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09fb6001, _depth) }
        return stdStorageSafe.depth(self, _depth);
    }

    function clear(StdStorage storage self) internal {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09fc0000, 1037618711036) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09fc0001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09fc0005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09fc6000, self.slot) }
        stdStorageSafe.clear(self);
    }

    function checked_write(StdStorage storage self, address who) internal {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09fd0000, 1037618711037) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09fd0001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09fd0005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09fd6001, who) }
        checked_write(self, bytes32(uint256(uint160(who))));
    }

    function checked_write(StdStorage storage self, uint256 amt) internal {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09fe0000, 1037618711038) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09fe0001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09fe0005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09fe6001, amt) }
        checked_write(self, bytes32(amt));
    }

    function checked_write_int(StdStorage storage self, int256 val) internal {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09ff0000, 1037618711039) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09ff0001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09ff0005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09ff6001, val) }
        checked_write(self, bytes32(uint256(val)));
    }

    function checked_write(StdStorage storage self, bool write) internal {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a060000, 1037618711046) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a060001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a060005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a066001, write) }
        bytes32 t;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000000b4,t)}
        /// @solidity memory-safe-assembly
        assembly {
            t := write
        }
        checked_write(self, t);
    }

    function checked_write(StdStorage storage self, bytes32 set) internal {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a050000, 1037618711045) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a050001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a050005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a056001, set) }
        address who = self._target;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000000b5,who)}
        bytes4 fsig = self._sig;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000000b6,fsig)}
        uint256 field_depth = self._depth;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000000b7,field_depth)}
        bytes memory params = stdStorageSafe.getCallParams(self);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000100b8,0)}

        if (!self.finds[who][fsig][keccak256(abi.encodePacked(params, field_depth))].found) {
            find(self, false);
        }
        FindData storage data = self.finds[who][fsig][keccak256(abi.encodePacked(params, field_depth))];assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000100b9,0)}
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
        bytes32 curVal = vm.load(who, bytes32(data.slot));assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000000ba,curVal)}
        bytes32 valToSet = stdStorageSafe.getUpdatedSlotValue(curVal, uint256(set), data.offsetLeft, data.offsetRight);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000000bb,valToSet)}

        vm.store(who, bytes32(data.slot), valToSet);

        (bool success, bytes32 callResult) = stdStorageSafe.callTarget(self);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000100bc,0)}

        if (!success || callResult != set) {
            vm.store(who, bytes32(data.slot), curVal);
            revert("stdStorage find(StdStorage): Failed to write value.");
        }
        clear(self);
    }

    function read_bytes32(StdStorage storage self) internal returns (bytes32) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a040000, 1037618711044) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a040001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a040005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a046000, self.slot) }
        return stdStorageSafe.read_bytes32(self);
    }

    function read_bool(StdStorage storage self) internal returns (bool) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a070000, 1037618711047) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a070001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a070005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a076000, self.slot) }
        return stdStorageSafe.read_bool(self);
    }

    function read_address(StdStorage storage self) internal returns (address) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a080000, 1037618711048) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a080001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a080005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a086000, self.slot) }
        return stdStorageSafe.read_address(self);
    }

    function read_uint(StdStorage storage self) internal returns (uint256) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a010000, 1037618711041) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a010001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a010005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a016000, self.slot) }
        return stdStorageSafe.read_uint(self);
    }

    function read_int(StdStorage storage self) internal returns (int256) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a020000, 1037618711042) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a020001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a020005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a026000, self.slot) }
        return stdStorageSafe.read_int(self);
    }

    function parent(StdStorage storage self) internal returns (uint256, bytes32) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a030000, 1037618711043) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a030001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a030005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a036000, self.slot) }
        return stdStorageSafe.parent(self);
    }

    function root(StdStorage storage self) internal returns (uint256) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a000000, 1037618711040) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a000001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a000005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a006000, self.slot) }
        return stdStorageSafe.root(self);
    }
}
