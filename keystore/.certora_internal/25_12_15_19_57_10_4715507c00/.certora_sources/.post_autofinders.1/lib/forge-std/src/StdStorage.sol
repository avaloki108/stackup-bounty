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

    function sigs(string memory sigStr) internal pure returns (bytes4) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04010000, 1037618709505) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04010001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04010005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04016000, sigStr) }
        return bytes4(keccak256(bytes(sigStr)));
    }

    function getCallParams(StdStorage storage self) internal view returns (bytes memory) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04020000, 1037618709506) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04020001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04020005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04026000, self.slot) }
        if (self._calldata.length == 0) {
            return flatten(self._keys);
        } else {
            return self._calldata;
        }
    }

    // Calls target contract with configured parameters
    function callTarget(StdStorage storage self) internal view returns (bool, bytes32) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04040000, 1037618709508) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04040001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04040005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04046000, self.slot) }
        bytes memory cald = abi.encodePacked(self._sig, getCallParams(self));assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00010112,0)}
        (bool success, bytes memory rdat) = self._target.staticcall(cald);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00010113,0)}
        bytes32 result = bytesToBytes32(rdat, 32 * self._depth);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000114,result)}

        return (success, result);
    }

    // Tries mutating slot value to determine if the targeted value is stored in it.
    // If current value is 0, then we are setting slot value to type(uint256).max
    // Otherwise, we set it to 0. That way, return value should always be affected.
    function checkSlotMutatesCall(StdStorage storage self, bytes32 slot) internal returns (bool) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04050000, 1037618709509) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04050001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04050005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04056001, slot) }
        bytes32 prevSlotValue = vm.load(self._target, slot);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000115,prevSlotValue)}
        (bool success, bytes32 prevReturnValue) = callTarget(self);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00010116,0)}

        bytes32 testVal = prevReturnValue == bytes32(0) ? bytes32(UINT256_MAX) : bytes32(0);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000117,testVal)}
        vm.store(self._target, slot, testVal);

        (, bytes32 newReturnValue) = callTarget(self);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00010118,0)}

        vm.store(self._target, slot, prevSlotValue);

        return (success && (prevReturnValue != newReturnValue));
    }

    // Tries setting one of the bits in slot to 1 until return value changes.
    // Index of resulted bit is an offset packed slot has from left/right side
    function findOffset(StdStorage storage self, bytes32 slot, bool left) internal returns (bool, uint256) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04030000, 1037618709507) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04030001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04030005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04036002, left) }
        for (uint256 offset = 0; offset < 256; offset++) {
            uint256 valueToPut = left ? (1 << (255 - offset)) : (1 << offset);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000143,valueToPut)}
            vm.store(self._target, slot, bytes32(valueToPut));

            (bool success, bytes32 data) = callTarget(self);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00010144,0)}

            if (success && (uint256(data) > 0)) {
                return (true, offset);
            }
        }
        return (false, 0);
    }

    function findOffsets(StdStorage storage self, bytes32 slot) internal returns (bool, uint256, uint256) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04060000, 1037618709510) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04060001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04060005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04066001, slot) }
        bytes32 prevSlotValue = vm.load(self._target, slot);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000119,prevSlotValue)}

        (bool foundLeft, uint256 offsetLeft) = findOffset(self, slot, true);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0001011a,0)}
        (bool foundRight, uint256 offsetRight) = findOffset(self, slot, false);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0001011b,0)}

        // `findOffset` may mutate slot value, so we are setting it to initial value
        vm.store(self._target, slot, prevSlotValue);
        return (foundLeft && foundRight, offsetLeft, offsetRight);
    }

    function find(StdStorage storage self) internal returns (FindData storage) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04070000, 1037618709511) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04070001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04070005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04076000, self.slot) }
        return find(self, true);
    }

    /// @notice find an arbitrary storage slot given a function sig, input data, address of the contract and a value to check against
    // slot complexity:
    //  if flat, will be bytes32(uint256(uint));
    //  if map, will be keccak256(abi.encode(key, uint(slot)));
    //  if deep map, will be keccak256(abi.encode(key1, keccak256(abi.encode(key0, uint(slot)))));
    //  if map struct, will be bytes32(uint256(keccak256(abi.encode(key1, keccak256(abi.encode(key0, uint(slot)))))) + structFieldDepth);
    function find(StdStorage storage self, bool _clear) internal returns (FindData storage) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04080000, 1037618709512) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04080001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04080005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04086001, _clear) }
        address who = self._target;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0000011c,who)}
        bytes4 fsig = self._sig;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0000011d,fsig)}
        uint256 field_depth = self._depth;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0000011e,field_depth)}
        bytes memory params = getCallParams(self);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0001011f,0)}

        // calldata to test against
        if (self.finds[who][fsig][keccak256(abi.encodePacked(params, field_depth))].found) {
            if (_clear) {
                clear(self);
            }
            return self.finds[who][fsig][keccak256(abi.encodePacked(params, field_depth))];
        }
        vm.record();
        (, bytes32 callResult) = callTarget(self);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00010120,0)}
        (bytes32[] memory reads,) = vm.accesses(address(who));assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00010121,0)}

        if (reads.length == 0) {
            revert("stdStorage find(StdStorage): No storage use detected for target.");
        } else {
            for (uint256 i = reads.length; --i >= 0;) {
                bytes32 prev = vm.load(who, reads[i]);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000149,prev)}
                if (prev == bytes32(0)) {
                    emit WARNING_UninitedSlot(who, uint256(reads[i]));
                }

                if (!checkSlotMutatesCall(self, reads[i])) {
                    continue;
                }

                (uint256 offsetLeft, uint256 offsetRight) = (0, 0);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0001014a,0)}

                if (self._enable_packed_slots) {
                    bool found;
                    (found, offsetLeft, offsetRight) = findOffsets(self, reads[i]);
                    if (!found) {
                        continue;
                    }
                }

                // Check that value between found offsets is equal to the current call result
                uint256 curVal = (uint256(prev) & getMaskByOffsets(offsetLeft, offsetRight)) >> offsetRight;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0000014b,curVal)}

                if (uint256(callResult) != curVal) {
                    continue;
                }

                emit SlotFound(who, fsig, keccak256(abi.encodePacked(params, field_depth)), uint256(reads[i]));
                self.finds[who][fsig][keccak256(abi.encodePacked(params, field_depth))] =
                    FindData(uint256(reads[i]), offsetLeft, offsetRight, true);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0002014c,0)}
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

    function target(StdStorage storage self, address _target) internal returns (StdStorage storage) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04090000, 1037618709513) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04090001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04090005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04096001, _target) }
        self._target = _target;address certora_local316 = self._target;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0000013c,certora_local316)}
        return self;
    }

    function sig(StdStorage storage self, bytes4 _sig) internal returns (StdStorage storage) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff040a0000, 1037618709514) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff040a0001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff040a0005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff040a6001, _sig) }
        self._sig = _sig;bytes4 certora_local317 = self._sig;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0000013d,certora_local317)}
        return self;
    }

    function sig(StdStorage storage self, string memory _sig) internal returns (StdStorage storage) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff040b0000, 1037618709515) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff040b0001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff040b0005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff040b6001, _sig) }
        self._sig = sigs(_sig);bytes4 certora_local318 = self._sig;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0000013e,certora_local318)}
        return self;
    }

    function with_calldata(StdStorage storage self, bytes memory _calldata) internal returns (StdStorage storage) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff040c0000, 1037618709516) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff040c0001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff040c0005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff040c6001, _calldata) }
        self._calldata = _calldata;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0002013f,0)}
        return self;
    }

    function with_key(StdStorage storage self, address who) internal returns (StdStorage storage) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff040d0000, 1037618709517) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff040d0001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff040d0005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff040d6001, who) }
        self._keys.push(bytes32(uint256(uint160(who))));
        return self;
    }

    function with_key(StdStorage storage self, uint256 amt) internal returns (StdStorage storage) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff040e0000, 1037618709518) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff040e0001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff040e0005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff040e6001, amt) }
        self._keys.push(bytes32(amt));
        return self;
    }

    function with_key(StdStorage storage self, bytes32 key) internal returns (StdStorage storage) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff040f0000, 1037618709519) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff040f0001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff040f0005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff040f6001, key) }
        self._keys.push(key);
        return self;
    }

    function enable_packed_slots(StdStorage storage self) internal returns (StdStorage storage) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04100000, 1037618709520) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04100001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04100005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04106000, self.slot) }
        self._enable_packed_slots = true;bool certora_local320 = self._enable_packed_slots;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000140,certora_local320)}
        return self;
    }

    function depth(StdStorage storage self, uint256 _depth) internal returns (StdStorage storage) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04170000, 1037618709527) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04170001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04170005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04176001, _depth) }
        self._depth = _depth;uint256 certora_local321 = self._depth;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000141,certora_local321)}
        return self;
    }

    function read(StdStorage storage self) private returns (bytes memory) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04160000, 1037618709526) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04160001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04160005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04166000, self.slot) }
        FindData storage data = find(self, false);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00010122,0)}
        uint256 mask = getMaskByOffsets(data.offsetLeft, data.offsetRight);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000123,mask)}
        uint256 value = (uint256(vm.load(self._target, bytes32(data.slot))) & mask) >> data.offsetRight;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000124,value)}
        clear(self);
        return abi.encode(value);
    }

    function read_bytes32(StdStorage storage self) internal returns (bytes32) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04150000, 1037618709525) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04150001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04150005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04156000, self.slot) }
        return abi.decode(read(self), (bytes32));
    }

    function read_bool(StdStorage storage self) internal returns (bool) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04180000, 1037618709528) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04180001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04180005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04186000, self.slot) }
        int256 v = read_int(self);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000125,v)}
        if (v == 0) return false;
        if (v == 1) return true;
        revert("stdStorage read_bool(StdStorage): Cannot decode. Make sure you are reading a bool.");
    }

    function read_address(StdStorage storage self) internal returns (address) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04190000, 1037618709529) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04190001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04190005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04196000, self.slot) }
        return abi.decode(read(self), (address));
    }

    function read_uint(StdStorage storage self) internal returns (uint256) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff041a0000, 1037618709530) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff041a0001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff041a0005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff041a6000, self.slot) }
        return abi.decode(read(self), (uint256));
    }

    function read_int(StdStorage storage self) internal returns (int256) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff041b0000, 1037618709531) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff041b0001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff041b0005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff041b6000, self.slot) }
        return abi.decode(read(self), (int256));
    }

    function parent(StdStorage storage self) internal returns (uint256, bytes32) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff041c0000, 1037618709532) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff041c0001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff041c0005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff041c6000, self.slot) }
        address who = self._target;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000126,who)}
        uint256 field_depth = self._depth;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000127,field_depth)}
        vm.startMappingRecording();
        uint256 child = find(self, true).slot - field_depth;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000128,child)}
        (bool found, bytes32 key, bytes32 parent_slot) = vm.getMappingKeyAndParentOf(who, bytes32(child));assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00010129,0)}
        if (!found) {
            revert(
                "stdStorage read_bool(StdStorage): Cannot find parent. Make sure you give a slot and startMappingRecording() has been called."
            );
        }
        return (uint256(parent_slot), key);
    }

    function root(StdStorage storage self) internal returns (uint256) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff041d0000, 1037618709533) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff041d0001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff041d0005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff041d6000, self.slot) }
        address who = self._target;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0000012a,who)}
        uint256 field_depth = self._depth;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0000012b,field_depth)}
        vm.startMappingRecording();
        uint256 child = find(self, true).slot - field_depth;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0000012c,child)}
        bool found;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0000012d,found)}
        bytes32 root_slot;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0000012e,root_slot)}
        bytes32 parent_slot;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0000012f,parent_slot)}
        (found,, parent_slot) = vm.getMappingKeyAndParentOf(who, bytes32(child));assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00020142,0)}
        if (!found) {
            revert(
                "stdStorage read_bool(StdStorage): Cannot find parent. Make sure you give a slot and startMappingRecording() has been called."
            );
        }
        while (found) {
            root_slot = parent_slot;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000146,root_slot)}
            (found,, parent_slot) = vm.getMappingKeyAndParentOf(who, bytes32(root_slot));assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00020147,0)}
        }
        return uint256(root_slot);
    }

    function bytesToBytes32(bytes memory b, uint256 offset) private pure returns (bytes32) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff041e0000, 1037618709534) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff041e0001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff041e0005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff041e6001, offset) }
        bytes32 out;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000130,out)}

        uint256 max = b.length > 32 ? 32 : b.length;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000131,max)}
        for (uint256 i = 0; i < max; i++) {
            out |= bytes32(b[offset + i] & 0xFF) >> (i * 8);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000148,out)}
        }
        return out;
    }

    function flatten(bytes32[] memory b) private pure returns (bytes memory) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04120000, 1037618709522) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04120001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04120005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04126000, b) }
        bytes memory result = new bytes(b.length * 32);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00010132,0)}
        for (uint256 i = 0; i < b.length; i++) {
            bytes32 k = b[i];assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000145,k)}
            /// @solidity memory-safe-assembly
            assembly {
                mstore(add(result, add(32, mul(32, i))), k)
            }
        }

        return result;
    }

    function clear(StdStorage storage self) internal {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04130000, 1037618709523) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04130001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04130005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04136000, self.slot) }
        delete self._target;
        delete self._sig;
        delete self._keys;
        delete self._depth;
        delete self._enable_packed_slots;
        delete self._calldata;
    }

    // Returns mask which contains non-zero bits for values between `offsetLeft` and `offsetRight`
    // (slotValue & mask) >> offsetRight will be the value of the given packed variable
    function getMaskByOffsets(uint256 offsetLeft, uint256 offsetRight) internal pure returns (uint256 mask) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04140000, 1037618709524) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04140001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04140005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04146001, offsetRight) }
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
    {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04110000, 1037618709521) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04110001, 4) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04110005, 585) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04116003, offsetRight) }
        return bytes32((uint256(curValue) & ~getMaskByOffsets(offsetLeft, offsetRight)) | (varValue << offsetRight));
    }
}

library stdStorage {
    Vm private constant vm = Vm(address(uint160(uint256(keccak256("hevm cheat code")))));

    function sigs(string memory sigStr) internal pure returns (bytes4) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03e80000, 1037618709480) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03e80001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03e80005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03e86000, sigStr) }
        return stdStorageSafe.sigs(sigStr);
    }

    function find(StdStorage storage self) internal returns (uint256) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03e90000, 1037618709481) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03e90001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03e90005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03e96000, self.slot) }
        return find(self, true);
    }

    function find(StdStorage storage self, bool _clear) internal returns (uint256) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03eb0000, 1037618709483) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03eb0001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03eb0005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03eb6001, _clear) }
        return stdStorageSafe.find(self, _clear).slot;
    }

    function target(StdStorage storage self, address _target) internal returns (StdStorage storage) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03ec0000, 1037618709484) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03ec0001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03ec0005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03ec6001, _target) }
        return stdStorageSafe.target(self, _target);
    }

    function sig(StdStorage storage self, bytes4 _sig) internal returns (StdStorage storage) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03ea0000, 1037618709482) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03ea0001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03ea0005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03ea6001, _sig) }
        return stdStorageSafe.sig(self, _sig);
    }

    function sig(StdStorage storage self, string memory _sig) internal returns (StdStorage storage) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03ed0000, 1037618709485) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03ed0001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03ed0005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03ed6001, _sig) }
        return stdStorageSafe.sig(self, _sig);
    }

    function with_key(StdStorage storage self, address who) internal returns (StdStorage storage) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03ee0000, 1037618709486) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03ee0001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03ee0005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03ee6001, who) }
        return stdStorageSafe.with_key(self, who);
    }

    function with_key(StdStorage storage self, uint256 amt) internal returns (StdStorage storage) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03ef0000, 1037618709487) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03ef0001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03ef0005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03ef6001, amt) }
        return stdStorageSafe.with_key(self, amt);
    }

    function with_key(StdStorage storage self, bytes32 key) internal returns (StdStorage storage) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03f00000, 1037618709488) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03f00001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03f00005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03f06001, key) }
        return stdStorageSafe.with_key(self, key);
    }

    function with_calldata(StdStorage storage self, bytes memory _calldata) internal returns (StdStorage storage) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03f10000, 1037618709489) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03f10001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03f10005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03f16001, _calldata) }
        return stdStorageSafe.with_calldata(self, _calldata);
    }

    function enable_packed_slots(StdStorage storage self) internal returns (StdStorage storage) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03f20000, 1037618709490) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03f20001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03f20005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03f26000, self.slot) }
        return stdStorageSafe.enable_packed_slots(self);
    }

    function depth(StdStorage storage self, uint256 _depth) internal returns (StdStorage storage) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03f30000, 1037618709491) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03f30001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03f30005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03f36001, _depth) }
        return stdStorageSafe.depth(self, _depth);
    }

    function clear(StdStorage storage self) internal {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03f40000, 1037618709492) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03f40001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03f40005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03f46000, self.slot) }
        stdStorageSafe.clear(self);
    }

    function checked_write(StdStorage storage self, address who) internal {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03f50000, 1037618709493) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03f50001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03f50005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03f56001, who) }
        checked_write(self, bytes32(uint256(uint160(who))));
    }

    function checked_write(StdStorage storage self, uint256 amt) internal {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03f60000, 1037618709494) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03f60001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03f60005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03f66001, amt) }
        checked_write(self, bytes32(amt));
    }

    function checked_write_int(StdStorage storage self, int256 val) internal {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03f70000, 1037618709495) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03f70001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03f70005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03f76001, val) }
        checked_write(self, bytes32(uint256(val)));
    }

    function checked_write(StdStorage storage self, bool write) internal {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03fe0000, 1037618709502) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03fe0001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03fe0005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03fe6001, write) }
        bytes32 t;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000133,t)}
        /// @solidity memory-safe-assembly
        assembly {
            t := write
        }
        checked_write(self, t);
    }

    function checked_write(StdStorage storage self, bytes32 set) internal {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03fd0000, 1037618709501) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03fd0001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03fd0005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03fd6001, set) }
        address who = self._target;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000134,who)}
        bytes4 fsig = self._sig;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000135,fsig)}
        uint256 field_depth = self._depth;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000136,field_depth)}
        bytes memory params = stdStorageSafe.getCallParams(self);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00010137,0)}

        if (!self.finds[who][fsig][keccak256(abi.encodePacked(params, field_depth))].found) {
            find(self, false);
        }
        FindData storage data = self.finds[who][fsig][keccak256(abi.encodePacked(params, field_depth))];assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00010138,0)}
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
        bytes32 curVal = vm.load(who, bytes32(data.slot));assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000139,curVal)}
        bytes32 valToSet = stdStorageSafe.getUpdatedSlotValue(curVal, uint256(set), data.offsetLeft, data.offsetRight);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0000013a,valToSet)}

        vm.store(who, bytes32(data.slot), valToSet);

        (bool success, bytes32 callResult) = stdStorageSafe.callTarget(self);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0001013b,0)}

        if (!success || callResult != set) {
            vm.store(who, bytes32(data.slot), curVal);
            revert("stdStorage find(StdStorage): Failed to write value.");
        }
        clear(self);
    }

    function read_bytes32(StdStorage storage self) internal returns (bytes32) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03fc0000, 1037618709500) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03fc0001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03fc0005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03fc6000, self.slot) }
        return stdStorageSafe.read_bytes32(self);
    }

    function read_bool(StdStorage storage self) internal returns (bool) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03ff0000, 1037618709503) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03ff0001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03ff0005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03ff6000, self.slot) }
        return stdStorageSafe.read_bool(self);
    }

    function read_address(StdStorage storage self) internal returns (address) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04000000, 1037618709504) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04000001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04000005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04006000, self.slot) }
        return stdStorageSafe.read_address(self);
    }

    function read_uint(StdStorage storage self) internal returns (uint256) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03f90000, 1037618709497) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03f90001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03f90005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03f96000, self.slot) }
        return stdStorageSafe.read_uint(self);
    }

    function read_int(StdStorage storage self) internal returns (int256) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03fa0000, 1037618709498) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03fa0001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03fa0005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03fa6000, self.slot) }
        return stdStorageSafe.read_int(self);
    }

    function parent(StdStorage storage self) internal returns (uint256, bytes32) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03fb0000, 1037618709499) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03fb0001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03fb0005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03fb6000, self.slot) }
        return stdStorageSafe.parent(self);
    }

    function root(StdStorage storage self) internal returns (uint256) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03f80000, 1037618709496) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03f80001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03f80005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03f86000, self.slot) }
        return stdStorageSafe.root(self);
    }
}
