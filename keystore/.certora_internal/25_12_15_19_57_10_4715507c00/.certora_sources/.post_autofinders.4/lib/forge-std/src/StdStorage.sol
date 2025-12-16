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

    function sigs(string memory sigStr) internal pure returns (bytes4) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff089b0000, 1037618710683) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff089b0001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff089b0005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff089b6000, sigStr) }
        return bytes4(keccak256(bytes(sigStr)));
    }

    function getCallParams(StdStorage storage self) internal view returns (bytes memory) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff089c0000, 1037618710684) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff089c0001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff089c0005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff089c6000, self.slot) }
        if (self._calldata.length == 0) {
            return flatten(self._keys);
        } else {
            return self._calldata;
        }
    }

    // Calls target contract with configured parameters
    function callTarget(StdStorage storage self) internal view returns (bool, bytes32) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff089e0000, 1037618710686) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff089e0001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff089e0005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff089e6000, self.slot) }
        bytes memory cald = abi.encodePacked(self._sig, getCallParams(self));assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000100bd,0)}
        (bool success, bytes memory rdat) = self._target.staticcall(cald);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000100be,0)}
        bytes32 result = bytesToBytes32(rdat, 32 * self._depth);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000000bf,result)}

        return (success, result);
    }

    // Tries mutating slot value to determine if the targeted value is stored in it.
    // If current value is 0, then we are setting slot value to type(uint256).max
    // Otherwise, we set it to 0. That way, return value should always be affected.
    function checkSlotMutatesCall(StdStorage storage self, bytes32 slot) internal returns (bool) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff089f0000, 1037618710687) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff089f0001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff089f0005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff089f6001, slot) }
        bytes32 prevSlotValue = vm.load(self._target, slot);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000000c0,prevSlotValue)}
        (bool success, bytes32 prevReturnValue) = callTarget(self);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000100c1,0)}

        bytes32 testVal = prevReturnValue == bytes32(0) ? bytes32(UINT256_MAX) : bytes32(0);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000000c2,testVal)}
        vm.store(self._target, slot, testVal);

        (, bytes32 newReturnValue) = callTarget(self);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000100c3,0)}

        vm.store(self._target, slot, prevSlotValue);

        return (success && (prevReturnValue != newReturnValue));
    }

    // Tries setting one of the bits in slot to 1 until return value changes.
    // Index of resulted bit is an offset packed slot has from left/right side
    function findOffset(StdStorage storage self, bytes32 slot, bool left) internal returns (bool, uint256) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff089d0000, 1037618710685) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff089d0001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff089d0005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff089d6002, left) }
        for (uint256 offset = 0; offset < 256; offset++) {
            uint256 valueToPut = left ? (1 << (255 - offset)) : (1 << offset);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000000ee,valueToPut)}
            vm.store(self._target, slot, bytes32(valueToPut));

            (bool success, bytes32 data) = callTarget(self);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000100ef,0)}

            if (success && (uint256(data) > 0)) {
                return (true, offset);
            }
        }
        return (false, 0);
    }

    function findOffsets(StdStorage storage self, bytes32 slot) internal returns (bool, uint256, uint256) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08a00000, 1037618710688) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08a00001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08a00005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08a06001, slot) }
        bytes32 prevSlotValue = vm.load(self._target, slot);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000000c4,prevSlotValue)}

        (bool foundLeft, uint256 offsetLeft) = findOffset(self, slot, true);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000100c5,0)}
        (bool foundRight, uint256 offsetRight) = findOffset(self, slot, false);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000100c6,0)}

        // `findOffset` may mutate slot value, so we are setting it to initial value
        vm.store(self._target, slot, prevSlotValue);
        return (foundLeft && foundRight, offsetLeft, offsetRight);
    }

    function find(StdStorage storage self) internal returns (FindData storage) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08a10000, 1037618710689) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08a10001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08a10005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08a16000, self.slot) }
        return find(self, true);
    }

    /// @notice find an arbitrary storage slot given a function sig, input data, address of the contract and a value to check against
    // slot complexity:
    //  if flat, will be bytes32(uint256(uint));
    //  if map, will be keccak256(abi.encode(key, uint(slot)));
    //  if deep map, will be keccak256(abi.encode(key1, keccak256(abi.encode(key0, uint(slot)))));
    //  if map struct, will be bytes32(uint256(keccak256(abi.encode(key1, keccak256(abi.encode(key0, uint(slot)))))) + structFieldDepth);
    function find(StdStorage storage self, bool _clear) internal returns (FindData storage) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08a20000, 1037618710690) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08a20001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08a20005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08a26001, _clear) }
        address who = self._target;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000000c7,who)}
        bytes4 fsig = self._sig;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000000c8,fsig)}
        uint256 field_depth = self._depth;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000000c9,field_depth)}
        bytes memory params = getCallParams(self);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000100ca,0)}

        // calldata to test against
        if (self.finds[who][fsig][keccak256(abi.encodePacked(params, field_depth))].found) {
            if (_clear) {
                clear(self);
            }
            return self.finds[who][fsig][keccak256(abi.encodePacked(params, field_depth))];
        }
        vm.record();
        (, bytes32 callResult) = callTarget(self);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000100cb,0)}
        (bytes32[] memory reads,) = vm.accesses(address(who));assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000100cc,0)}

        if (reads.length == 0) {
            revert("stdStorage find(StdStorage): No storage use detected for target.");
        } else {
            for (uint256 i = reads.length; --i >= 0;) {
                bytes32 prev = vm.load(who, reads[i]);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000000f4,prev)}
                if (prev == bytes32(0)) {
                    emit WARNING_UninitedSlot(who, uint256(reads[i]));
                }

                if (!checkSlotMutatesCall(self, reads[i])) {
                    continue;
                }

                (uint256 offsetLeft, uint256 offsetRight) = (0, 0);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000100f5,0)}

                if (self._enable_packed_slots) {
                    bool found;
                    (found, offsetLeft, offsetRight) = findOffsets(self, reads[i]);
                    if (!found) {
                        continue;
                    }
                }

                // Check that value between found offsets is equal to the current call result
                uint256 curVal = (uint256(prev) & getMaskByOffsets(offsetLeft, offsetRight)) >> offsetRight;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000000f6,curVal)}

                if (uint256(callResult) != curVal) {
                    continue;
                }

                emit SlotFound(who, fsig, keccak256(abi.encodePacked(params, field_depth)), uint256(reads[i]));
                self.finds[who][fsig][keccak256(abi.encodePacked(params, field_depth))] =
                    FindData(uint256(reads[i]), offsetLeft, offsetRight, true);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000200f7,0)}
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

    function target(StdStorage storage self, address _target) internal returns (StdStorage storage) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08a30000, 1037618710691) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08a30001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08a30005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08a36001, _target) }
        self._target = _target;address certora_local231 = self._target;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000000e7,certora_local231)}
        return self;
    }

    function sig(StdStorage storage self, bytes4 _sig) internal returns (StdStorage storage) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08a40000, 1037618710692) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08a40001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08a40005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08a46001, _sig) }
        self._sig = _sig;bytes4 certora_local232 = self._sig;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000000e8,certora_local232)}
        return self;
    }

    function sig(StdStorage storage self, string memory _sig) internal returns (StdStorage storage) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08a50000, 1037618710693) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08a50001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08a50005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08a56001, _sig) }
        self._sig = sigs(_sig);bytes4 certora_local233 = self._sig;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000000e9,certora_local233)}
        return self;
    }

    function with_calldata(StdStorage storage self, bytes memory _calldata) internal returns (StdStorage storage) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08a60000, 1037618710694) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08a60001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08a60005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08a66001, _calldata) }
        self._calldata = _calldata;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000200ea,0)}
        return self;
    }

    function with_key(StdStorage storage self, address who) internal returns (StdStorage storage) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08a70000, 1037618710695) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08a70001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08a70005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08a76001, who) }
        self._keys.push(bytes32(uint256(uint160(who))));
        return self;
    }

    function with_key(StdStorage storage self, uint256 amt) internal returns (StdStorage storage) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08a80000, 1037618710696) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08a80001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08a80005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08a86001, amt) }
        self._keys.push(bytes32(amt));
        return self;
    }

    function with_key(StdStorage storage self, bytes32 key) internal returns (StdStorage storage) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08a90000, 1037618710697) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08a90001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08a90005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08a96001, key) }
        self._keys.push(key);
        return self;
    }

    function enable_packed_slots(StdStorage storage self) internal returns (StdStorage storage) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08aa0000, 1037618710698) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08aa0001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08aa0005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08aa6000, self.slot) }
        self._enable_packed_slots = true;bool certora_local235 = self._enable_packed_slots;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000000eb,certora_local235)}
        return self;
    }

    function depth(StdStorage storage self, uint256 _depth) internal returns (StdStorage storage) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08b10000, 1037618710705) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08b10001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08b10005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08b16001, _depth) }
        self._depth = _depth;uint256 certora_local236 = self._depth;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000000ec,certora_local236)}
        return self;
    }

    function read(StdStorage storage self) private returns (bytes memory) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08b00000, 1037618710704) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08b00001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08b00005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08b06000, self.slot) }
        FindData storage data = find(self, false);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000100cd,0)}
        uint256 mask = getMaskByOffsets(data.offsetLeft, data.offsetRight);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000000ce,mask)}
        uint256 value = (uint256(vm.load(self._target, bytes32(data.slot))) & mask) >> data.offsetRight;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000000cf,value)}
        clear(self);
        return abi.encode(value);
    }

    function read_bytes32(StdStorage storage self) internal returns (bytes32) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08af0000, 1037618710703) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08af0001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08af0005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08af6000, self.slot) }
        return abi.decode(read(self), (bytes32));
    }

    function read_bool(StdStorage storage self) internal returns (bool) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08b20000, 1037618710706) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08b20001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08b20005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08b26000, self.slot) }
        int256 v = read_int(self);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000000d0,v)}
        if (v == 0) return false;
        if (v == 1) return true;
        revert("stdStorage read_bool(StdStorage): Cannot decode. Make sure you are reading a bool.");
    }

    function read_address(StdStorage storage self) internal returns (address) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08b30000, 1037618710707) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08b30001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08b30005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08b36000, self.slot) }
        return abi.decode(read(self), (address));
    }

    function read_uint(StdStorage storage self) internal returns (uint256) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08b40000, 1037618710708) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08b40001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08b40005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08b46000, self.slot) }
        return abi.decode(read(self), (uint256));
    }

    function read_int(StdStorage storage self) internal returns (int256) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08b50000, 1037618710709) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08b50001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08b50005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08b56000, self.slot) }
        return abi.decode(read(self), (int256));
    }

    function parent(StdStorage storage self) internal returns (uint256, bytes32) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08b60000, 1037618710710) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08b60001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08b60005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08b66000, self.slot) }
        address who = self._target;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000000d1,who)}
        uint256 field_depth = self._depth;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000000d2,field_depth)}
        vm.startMappingRecording();
        uint256 child = find(self, true).slot - field_depth;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000000d3,child)}
        (bool found, bytes32 key, bytes32 parent_slot) = vm.getMappingKeyAndParentOf(who, bytes32(child));assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000100d4,0)}
        if (!found) {
            revert(
                "stdStorage read_bool(StdStorage): Cannot find parent. Make sure you give a slot and startMappingRecording() has been called."
            );
        }
        return (uint256(parent_slot), key);
    }

    function root(StdStorage storage self) internal returns (uint256) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08b70000, 1037618710711) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08b70001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08b70005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08b76000, self.slot) }
        address who = self._target;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000000d5,who)}
        uint256 field_depth = self._depth;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000000d6,field_depth)}
        vm.startMappingRecording();
        uint256 child = find(self, true).slot - field_depth;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000000d7,child)}
        bool found;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000000d8,found)}
        bytes32 root_slot;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000000d9,root_slot)}
        bytes32 parent_slot;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000000da,parent_slot)}
        (found,, parent_slot) = vm.getMappingKeyAndParentOf(who, bytes32(child));assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000200ed,0)}
        if (!found) {
            revert(
                "stdStorage read_bool(StdStorage): Cannot find parent. Make sure you give a slot and startMappingRecording() has been called."
            );
        }
        while (found) {
            root_slot = parent_slot;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000000f1,root_slot)}
            (found,, parent_slot) = vm.getMappingKeyAndParentOf(who, bytes32(root_slot));assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000200f2,0)}
        }
        return uint256(root_slot);
    }

    function bytesToBytes32(bytes memory b, uint256 offset) private pure returns (bytes32) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08b80000, 1037618710712) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08b80001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08b80005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08b86001, offset) }
        bytes32 out;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000000db,out)}

        uint256 max = b.length > 32 ? 32 : b.length;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000000dc,max)}
        for (uint256 i = 0; i < max; i++) {
            out |= bytes32(b[offset + i] & 0xFF) >> (i * 8);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000000f3,out)}
        }
        return out;
    }

    function flatten(bytes32[] memory b) private pure returns (bytes memory) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08ac0000, 1037618710700) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08ac0001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08ac0005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08ac6000, b) }
        bytes memory result = new bytes(b.length * 32);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000100dd,0)}
        for (uint256 i = 0; i < b.length; i++) {
            bytes32 k = b[i];assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000000f0,k)}
            /// @solidity memory-safe-assembly
            assembly {
                mstore(add(result, add(32, mul(32, i))), k)
            }
        }

        return result;
    }

    function clear(StdStorage storage self) internal {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08ad0000, 1037618710701) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08ad0001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08ad0005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08ad6000, self.slot) }
        delete self._target;
        delete self._sig;
        delete self._keys;
        delete self._depth;
        delete self._enable_packed_slots;
        delete self._calldata;
    }

    // Returns mask which contains non-zero bits for values between `offsetLeft` and `offsetRight`
    // (slotValue & mask) >> offsetRight will be the value of the given packed variable
    function getMaskByOffsets(uint256 offsetLeft, uint256 offsetRight) internal pure returns (uint256 mask) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08ae0000, 1037618710702) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08ae0001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08ae0005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08ae6001, offsetRight) }
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
    {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08ab0000, 1037618710699) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08ab0001, 4) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08ab0005, 585) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08ab6003, offsetRight) }
        return bytes32((uint256(curValue) & ~getMaskByOffsets(offsetLeft, offsetRight)) | (varValue << offsetRight));
    }
}

library stdStorage {
    Vm private constant vm = Vm(address(uint160(uint256(keccak256("hevm cheat code")))));

    function sigs(string memory sigStr) internal pure returns (bytes4) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08820000, 1037618710658) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08820001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08820005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08826000, sigStr) }
        return stdStorageSafe.sigs(sigStr);
    }

    function find(StdStorage storage self) internal returns (uint256) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08830000, 1037618710659) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08830001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08830005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08836000, self.slot) }
        return find(self, true);
    }

    function find(StdStorage storage self, bool _clear) internal returns (uint256) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08850000, 1037618710661) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08850001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08850005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08856001, _clear) }
        return stdStorageSafe.find(self, _clear).slot;
    }

    function target(StdStorage storage self, address _target) internal returns (StdStorage storage) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08860000, 1037618710662) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08860001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08860005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08866001, _target) }
        return stdStorageSafe.target(self, _target);
    }

    function sig(StdStorage storage self, bytes4 _sig) internal returns (StdStorage storage) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08840000, 1037618710660) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08840001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08840005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08846001, _sig) }
        return stdStorageSafe.sig(self, _sig);
    }

    function sig(StdStorage storage self, string memory _sig) internal returns (StdStorage storage) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08870000, 1037618710663) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08870001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08870005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08876001, _sig) }
        return stdStorageSafe.sig(self, _sig);
    }

    function with_key(StdStorage storage self, address who) internal returns (StdStorage storage) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08880000, 1037618710664) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08880001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08880005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08886001, who) }
        return stdStorageSafe.with_key(self, who);
    }

    function with_key(StdStorage storage self, uint256 amt) internal returns (StdStorage storage) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08890000, 1037618710665) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08890001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08890005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08896001, amt) }
        return stdStorageSafe.with_key(self, amt);
    }

    function with_key(StdStorage storage self, bytes32 key) internal returns (StdStorage storage) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff088a0000, 1037618710666) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff088a0001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff088a0005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff088a6001, key) }
        return stdStorageSafe.with_key(self, key);
    }

    function with_calldata(StdStorage storage self, bytes memory _calldata) internal returns (StdStorage storage) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff088b0000, 1037618710667) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff088b0001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff088b0005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff088b6001, _calldata) }
        return stdStorageSafe.with_calldata(self, _calldata);
    }

    function enable_packed_slots(StdStorage storage self) internal returns (StdStorage storage) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff088c0000, 1037618710668) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff088c0001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff088c0005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff088c6000, self.slot) }
        return stdStorageSafe.enable_packed_slots(self);
    }

    function depth(StdStorage storage self, uint256 _depth) internal returns (StdStorage storage) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff088d0000, 1037618710669) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff088d0001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff088d0005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff088d6001, _depth) }
        return stdStorageSafe.depth(self, _depth);
    }

    function clear(StdStorage storage self) internal {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff088e0000, 1037618710670) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff088e0001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff088e0005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff088e6000, self.slot) }
        stdStorageSafe.clear(self);
    }

    function checked_write(StdStorage storage self, address who) internal {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff088f0000, 1037618710671) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff088f0001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff088f0005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff088f6001, who) }
        checked_write(self, bytes32(uint256(uint160(who))));
    }

    function checked_write(StdStorage storage self, uint256 amt) internal {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08900000, 1037618710672) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08900001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08900005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08906001, amt) }
        checked_write(self, bytes32(amt));
    }

    function checked_write_int(StdStorage storage self, int256 val) internal {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08910000, 1037618710673) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08910001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08910005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08916001, val) }
        checked_write(self, bytes32(uint256(val)));
    }

    function checked_write(StdStorage storage self, bool write) internal {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08980000, 1037618710680) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08980001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08980005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08986001, write) }
        bytes32 t;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000000de,t)}
        /// @solidity memory-safe-assembly
        assembly {
            t := write
        }
        checked_write(self, t);
    }

    function checked_write(StdStorage storage self, bytes32 set) internal {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08970000, 1037618710679) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08970001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08970005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08976001, set) }
        address who = self._target;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000000df,who)}
        bytes4 fsig = self._sig;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000000e0,fsig)}
        uint256 field_depth = self._depth;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000000e1,field_depth)}
        bytes memory params = stdStorageSafe.getCallParams(self);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000100e2,0)}

        if (!self.finds[who][fsig][keccak256(abi.encodePacked(params, field_depth))].found) {
            find(self, false);
        }
        FindData storage data = self.finds[who][fsig][keccak256(abi.encodePacked(params, field_depth))];assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000100e3,0)}
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
        bytes32 curVal = vm.load(who, bytes32(data.slot));assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000000e4,curVal)}
        bytes32 valToSet = stdStorageSafe.getUpdatedSlotValue(curVal, uint256(set), data.offsetLeft, data.offsetRight);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000000e5,valToSet)}

        vm.store(who, bytes32(data.slot), valToSet);

        (bool success, bytes32 callResult) = stdStorageSafe.callTarget(self);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000100e6,0)}

        if (!success || callResult != set) {
            vm.store(who, bytes32(data.slot), curVal);
            revert("stdStorage find(StdStorage): Failed to write value.");
        }
        clear(self);
    }

    function read_bytes32(StdStorage storage self) internal returns (bytes32) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08960000, 1037618710678) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08960001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08960005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08966000, self.slot) }
        return stdStorageSafe.read_bytes32(self);
    }

    function read_bool(StdStorage storage self) internal returns (bool) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08990000, 1037618710681) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08990001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08990005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08996000, self.slot) }
        return stdStorageSafe.read_bool(self);
    }

    function read_address(StdStorage storage self) internal returns (address) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff089a0000, 1037618710682) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff089a0001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff089a0005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff089a6000, self.slot) }
        return stdStorageSafe.read_address(self);
    }

    function read_uint(StdStorage storage self) internal returns (uint256) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08930000, 1037618710675) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08930001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08930005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08936000, self.slot) }
        return stdStorageSafe.read_uint(self);
    }

    function read_int(StdStorage storage self) internal returns (int256) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08940000, 1037618710676) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08940001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08940005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08946000, self.slot) }
        return stdStorageSafe.read_int(self);
    }

    function parent(StdStorage storage self) internal returns (uint256, bytes32) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08950000, 1037618710677) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08950001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08950005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08956000, self.slot) }
        return stdStorageSafe.parent(self);
    }

    function root(StdStorage storage self) internal returns (uint256) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08920000, 1037618710674) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08920001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08920005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08926000, self.slot) }
        return stdStorageSafe.root(self);
    }
}
