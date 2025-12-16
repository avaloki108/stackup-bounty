// SPDX-License-Identifier: MIT
pragma solidity >=0.6.2 <0.9.0;
pragma experimental ABIEncoderV2;

import {Vm} from "./Vm.sol";

abstract contract StdAssertions {
    Vm private constant vm = Vm(address(uint160(uint256(keccak256("hevm cheat code")))));

    event log(string);
    event logs(bytes);

    event log_address(address);
    event log_bytes32(bytes32);
    event log_int(int256);
    event log_uint(uint256);
    event log_bytes(bytes);
    event log_string(string);

    event log_named_address(string key, address val);
    event log_named_bytes32(string key, bytes32 val);
    event log_named_decimal_int(string key, int256 val, uint256 decimals);
    event log_named_decimal_uint(string key, uint256 val, uint256 decimals);
    event log_named_int(string key, int256 val);
    event log_named_uint(string key, uint256 val);
    event log_named_bytes(string key, bytes val);
    event log_named_string(string key, string val);

    event log_array(uint256[] val);
    event log_array(int256[] val);
    event log_array(address[] val);
    event log_named_array(string key, uint256[] val);
    event log_named_array(string key, int256[] val);
    event log_named_array(string key, address[] val);

    bool private _failed;

    function failed() public view returns (bool) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a5d0000, 1037618711133) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a5d0001, 0) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a5d0004, 0) }
        if (_failed) {
            return _failed;
        } else {
            return vm.load(address(vm), bytes32("failed")) != bytes32(0);
        }
    }

    function fail() internal virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a6e0000, 1037618711150) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a6e0001, 0) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a6e0004, 0) }
        vm.store(address(vm), bytes32("failed"), bytes32(uint256(1)));
        _failed = true;
    }

    function assertTrue(bool data) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a6f0000, 1037618711151) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a6f0001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a6f0005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a6f6000, data) }
        vm.assertTrue(data);
    }

    function assertTrue(bool data, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a710000, 1037618711153) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a710001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a710005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a716001, err) }
        vm.assertTrue(data, err);
    }

    function assertFalse(bool data) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a720000, 1037618711154) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a720001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a720005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a726000, data) }
        vm.assertFalse(data);
    }

    function assertFalse(bool data, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a700000, 1037618711152) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a700001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a700005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a706001, err) }
        vm.assertFalse(data, err);
    }

    function assertEq(bool left, bool right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a730000, 1037618711155) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a730001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a730005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a736001, right) }
        vm.assertEq(left, right);
    }

    function assertEq(bool left, bool right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a740000, 1037618711156) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a740001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a740005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a746002, err) }
        vm.assertEq(left, right, err);
    }

    function assertEq(uint256 left, uint256 right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a750000, 1037618711157) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a750001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a750005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a756001, right) }
        vm.assertEq(left, right);
    }

    function assertEq(uint256 left, uint256 right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a760000, 1037618711158) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a760001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a760005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a766002, err) }
        vm.assertEq(left, right, err);
    }

    function assertEqDecimal(uint256 left, uint256 right, uint256 decimals) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a770000, 1037618711159) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a770001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a770005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a776002, decimals) }
        vm.assertEqDecimal(left, right, decimals);
    }

    function assertEqDecimal(uint256 left, uint256 right, uint256 decimals, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a780000, 1037618711160) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a780001, 4) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a780005, 585) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a786003, err) }
        vm.assertEqDecimal(left, right, decimals, err);
    }

    function assertEq(int256 left, int256 right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a790000, 1037618711161) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a790001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a790005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a796001, right) }
        vm.assertEq(left, right);
    }

    function assertEq(int256 left, int256 right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a7a0000, 1037618711162) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a7a0001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a7a0005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a7a6002, err) }
        vm.assertEq(left, right, err);
    }

    function assertEqDecimal(int256 left, int256 right, uint256 decimals) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a7b0000, 1037618711163) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a7b0001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a7b0005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a7b6002, decimals) }
        vm.assertEqDecimal(left, right, decimals);
    }

    function assertEqDecimal(int256 left, int256 right, uint256 decimals, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a7c0000, 1037618711164) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a7c0001, 4) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a7c0005, 585) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a7c6003, err) }
        vm.assertEqDecimal(left, right, decimals, err);
    }

    function assertEq(address left, address right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a7d0000, 1037618711165) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a7d0001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a7d0005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a7d6001, right) }
        vm.assertEq(left, right);
    }

    function assertEq(address left, address right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0aa30000, 1037618711203) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0aa30001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0aa30005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0aa36002, err) }
        vm.assertEq(left, right, err);
    }

    function assertEq(bytes32 left, bytes32 right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0aa20000, 1037618711202) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0aa20001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0aa20005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0aa26001, right) }
        vm.assertEq(left, right);
    }

    function assertEq(bytes32 left, bytes32 right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0aa10000, 1037618711201) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0aa10001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0aa10005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0aa16002, err) }
        vm.assertEq(left, right, err);
    }

    function assertEq32(bytes32 left, bytes32 right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0aa40000, 1037618711204) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0aa40001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0aa40005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0aa46001, right) }
        assertEq(left, right);
    }

    function assertEq32(bytes32 left, bytes32 right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0aa50000, 1037618711205) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0aa50001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0aa50005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0aa56002, err) }
        assertEq(left, right, err);
    }

    function assertEq(string memory left, string memory right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0aa60000, 1037618711206) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0aa60001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0aa60005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0aa66001, right) }
        vm.assertEq(left, right);
    }

    function assertEq(string memory left, string memory right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0aa70000, 1037618711207) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0aa70001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0aa70005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0aa76002, err) }
        vm.assertEq(left, right, err);
    }

    function assertEq(bytes memory left, bytes memory right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0aa80000, 1037618711208) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0aa80001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0aa80005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0aa86001, right) }
        vm.assertEq(left, right);
    }

    function assertEq(bytes memory left, bytes memory right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0aa90000, 1037618711209) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0aa90001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0aa90005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0aa96002, err) }
        vm.assertEq(left, right, err);
    }

    function assertEq(bool[] memory left, bool[] memory right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0aaa0000, 1037618711210) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0aaa0001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0aaa0005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0aaa6001, right) }
        vm.assertEq(left, right);
    }

    function assertEq(bool[] memory left, bool[] memory right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a850000, 1037618711173) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a850001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a850005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a856002, err) }
        vm.assertEq(left, right, err);
    }

    function assertEq(uint256[] memory left, uint256[] memory right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a860000, 1037618711174) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a860001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a860005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a866001, right) }
        vm.assertEq(left, right);
    }

    function assertEq(uint256[] memory left, uint256[] memory right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a870000, 1037618711175) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a870001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a870005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a876002, err) }
        vm.assertEq(left, right, err);
    }

    function assertEq(int256[] memory left, int256[] memory right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a7e0000, 1037618711166) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a7e0001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a7e0005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a7e6001, right) }
        vm.assertEq(left, right);
    }

    function assertEq(int256[] memory left, int256[] memory right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a7f0000, 1037618711167) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a7f0001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a7f0005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a7f6002, err) }
        vm.assertEq(left, right, err);
    }

    function assertEq(address[] memory left, address[] memory right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a800000, 1037618711168) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a800001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a800005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a806001, right) }
        vm.assertEq(left, right);
    }

    function assertEq(address[] memory left, address[] memory right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a810000, 1037618711169) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a810001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a810005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a816002, err) }
        vm.assertEq(left, right, err);
    }

    function assertEq(bytes32[] memory left, bytes32[] memory right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a820000, 1037618711170) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a820001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a820005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a826001, right) }
        vm.assertEq(left, right);
    }

    function assertEq(bytes32[] memory left, bytes32[] memory right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a830000, 1037618711171) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a830001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a830005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a836002, err) }
        vm.assertEq(left, right, err);
    }

    function assertEq(string[] memory left, string[] memory right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a840000, 1037618711172) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a840001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a840005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a846001, right) }
        vm.assertEq(left, right);
    }

    function assertEq(string[] memory left, string[] memory right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0aca0000, 1037618711242) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0aca0001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0aca0005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0aca6002, err) }
        vm.assertEq(left, right, err);
    }

    function assertEq(bytes[] memory left, bytes[] memory right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0acb0000, 1037618711243) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0acb0001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0acb0005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0acb6001, right) }
        vm.assertEq(left, right);
    }

    function assertEq(bytes[] memory left, bytes[] memory right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0acc0000, 1037618711244) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0acc0001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0acc0005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0acc6002, err) }
        vm.assertEq(left, right, err);
    }

    // Legacy helper
    function assertEqUint(uint256 left, uint256 right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0acd0000, 1037618711245) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0acd0001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0acd0005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0acd6001, right) }
        assertEq(left, right);
    }

    function assertNotEq(bool left, bool right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ace0000, 1037618711246) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ace0001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ace0005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ace6001, right) }
        vm.assertNotEq(left, right);
    }

    function assertNotEq(bool left, bool right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0acf0000, 1037618711247) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0acf0001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0acf0005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0acf6002, err) }
        vm.assertNotEq(left, right, err);
    }

    function assertNotEq(uint256 left, uint256 right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ad00000, 1037618711248) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ad00001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ad00005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ad06001, right) }
        vm.assertNotEq(left, right);
    }

    function assertNotEq(uint256 left, uint256 right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ad10000, 1037618711249) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ad10001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ad10005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ad16002, err) }
        vm.assertNotEq(left, right, err);
    }

    function assertNotEqDecimal(uint256 left, uint256 right, uint256 decimals) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ad20000, 1037618711250) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ad20001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ad20005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ad26002, decimals) }
        vm.assertNotEqDecimal(left, right, decimals);
    }

    function assertNotEqDecimal(uint256 left, uint256 right, uint256 decimals, string memory err)
        internal
        pure
        virtual
    {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a880000, 1037618711176) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a880001, 4) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a880005, 585) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a886003, err) }
        vm.assertNotEqDecimal(left, right, decimals, err);
    }

    function assertNotEq(int256 left, int256 right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a890000, 1037618711177) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a890001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a890005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a896001, right) }
        vm.assertNotEq(left, right);
    }

    function assertNotEq(int256 left, int256 right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a8a0000, 1037618711178) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a8a0001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a8a0005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a8a6002, err) }
        vm.assertNotEq(left, right, err);
    }

    function assertNotEqDecimal(int256 left, int256 right, uint256 decimals) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a8b0000, 1037618711179) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a8b0001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a8b0005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a8b6002, decimals) }
        vm.assertNotEqDecimal(left, right, decimals);
    }

    function assertNotEqDecimal(int256 left, int256 right, uint256 decimals, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a8c0000, 1037618711180) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a8c0001, 4) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a8c0005, 585) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a8c6003, err) }
        vm.assertNotEqDecimal(left, right, decimals, err);
    }

    function assertNotEq(address left, address right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a8d0000, 1037618711181) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a8d0001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a8d0005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a8d6001, right) }
        vm.assertNotEq(left, right);
    }

    function assertNotEq(address left, address right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a8e0000, 1037618711182) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a8e0001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a8e0005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a8e6002, err) }
        vm.assertNotEq(left, right, err);
    }

    function assertNotEq(bytes32 left, bytes32 right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a8f0000, 1037618711183) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a8f0001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a8f0005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a8f6001, right) }
        vm.assertNotEq(left, right);
    }

    function assertNotEq(bytes32 left, bytes32 right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a900000, 1037618711184) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a900001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a900005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a906002, err) }
        vm.assertNotEq(left, right, err);
    }

    function assertNotEq32(bytes32 left, bytes32 right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a910000, 1037618711185) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a910001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a910005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a916001, right) }
        assertNotEq(left, right);
    }

    function assertNotEq32(bytes32 left, bytes32 right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ad30000, 1037618711251) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ad30001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ad30005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ad36002, err) }
        assertNotEq(left, right, err);
    }

    function assertNotEq(string memory left, string memory right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0add0000, 1037618711261) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0add0001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0add0005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0add6001, right) }
        vm.assertNotEq(left, right);
    }

    function assertNotEq(string memory left, string memory right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ade0000, 1037618711262) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ade0001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ade0005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ade6002, err) }
        vm.assertNotEq(left, right, err);
    }

    function assertNotEq(bytes memory left, bytes memory right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0adf0000, 1037618711263) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0adf0001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0adf0005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0adf6001, right) }
        vm.assertNotEq(left, right);
    }

    function assertNotEq(bytes memory left, bytes memory right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ae00000, 1037618711264) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ae00001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ae00005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ae06002, err) }
        vm.assertNotEq(left, right, err);
    }

    function assertNotEq(bool[] memory left, bool[] memory right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ae10000, 1037618711265) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ae10001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ae10005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ae16001, right) }
        vm.assertNotEq(left, right);
    }

    function assertNotEq(bool[] memory left, bool[] memory right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ae20000, 1037618711266) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ae20001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ae20005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ae26002, err) }
        vm.assertNotEq(left, right, err);
    }

    function assertNotEq(uint256[] memory left, uint256[] memory right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ae30000, 1037618711267) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ae30001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ae30005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ae36001, right) }
        vm.assertNotEq(left, right);
    }

    function assertNotEq(uint256[] memory left, uint256[] memory right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ae40000, 1037618711268) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ae40001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ae40005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ae46002, err) }
        vm.assertNotEq(left, right, err);
    }

    function assertNotEq(int256[] memory left, int256[] memory right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ae50000, 1037618711269) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ae50001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ae50005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ae56001, right) }
        vm.assertNotEq(left, right);
    }

    function assertNotEq(int256[] memory left, int256[] memory right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ae60000, 1037618711270) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ae60001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ae60005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ae66002, err) }
        vm.assertNotEq(left, right, err);
    }

    function assertNotEq(address[] memory left, address[] memory right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ac60000, 1037618711238) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ac60001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ac60005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ac66001, right) }
        vm.assertNotEq(left, right);
    }

    function assertNotEq(address[] memory left, address[] memory right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ac70000, 1037618711239) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ac70001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ac70005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ac76002, err) }
        vm.assertNotEq(left, right, err);
    }

    function assertNotEq(bytes32[] memory left, bytes32[] memory right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ac80000, 1037618711240) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ac80001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ac80005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ac86001, right) }
        vm.assertNotEq(left, right);
    }

    function assertNotEq(bytes32[] memory left, bytes32[] memory right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ac90000, 1037618711241) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ac90001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ac90005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ac96002, err) }
        vm.assertNotEq(left, right, err);
    }

    function assertNotEq(string[] memory left, string[] memory right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0abf0000, 1037618711231) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0abf0001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0abf0005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0abf6001, right) }
        vm.assertNotEq(left, right);
    }

    function assertNotEq(string[] memory left, string[] memory right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ac00000, 1037618711232) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ac00001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ac00005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ac06002, err) }
        vm.assertNotEq(left, right, err);
    }

    function assertNotEq(bytes[] memory left, bytes[] memory right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ac10000, 1037618711233) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ac10001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ac10005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ac16001, right) }
        vm.assertNotEq(left, right);
    }

    function assertNotEq(bytes[] memory left, bytes[] memory right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ac20000, 1037618711234) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ac20001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ac20005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ac26002, err) }
        vm.assertNotEq(left, right, err);
    }

    function assertLt(uint256 left, uint256 right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ac30000, 1037618711235) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ac30001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ac30005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ac36001, right) }
        vm.assertLt(left, right);
    }

    function assertLt(uint256 left, uint256 right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ac40000, 1037618711236) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ac40001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ac40005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ac46002, err) }
        vm.assertLt(left, right, err);
    }

    function assertLtDecimal(uint256 left, uint256 right, uint256 decimals) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ac50000, 1037618711237) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ac50001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ac50005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ac56002, decimals) }
        vm.assertLtDecimal(left, right, decimals);
    }

    function assertLtDecimal(uint256 left, uint256 right, uint256 decimals, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ad40000, 1037618711252) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ad40001, 4) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ad40005, 585) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ad46003, err) }
        vm.assertLtDecimal(left, right, decimals, err);
    }

    function assertLt(int256 left, int256 right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ad50000, 1037618711253) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ad50001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ad50005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ad56001, right) }
        vm.assertLt(left, right);
    }

    function assertLt(int256 left, int256 right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ad60000, 1037618711254) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ad60001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ad60005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ad66002, err) }
        vm.assertLt(left, right, err);
    }

    function assertLtDecimal(int256 left, int256 right, uint256 decimals) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ad70000, 1037618711255) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ad70001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ad70005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ad76002, decimals) }
        vm.assertLtDecimal(left, right, decimals);
    }

    function assertLtDecimal(int256 left, int256 right, uint256 decimals, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ad80000, 1037618711256) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ad80001, 4) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ad80005, 585) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ad86003, err) }
        vm.assertLtDecimal(left, right, decimals, err);
    }

    function assertGt(uint256 left, uint256 right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ad90000, 1037618711257) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ad90001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ad90005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ad96001, right) }
        vm.assertGt(left, right);
    }

    function assertGt(uint256 left, uint256 right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ada0000, 1037618711258) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ada0001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ada0005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ada6002, err) }
        vm.assertGt(left, right, err);
    }

    function assertGtDecimal(uint256 left, uint256 right, uint256 decimals) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0adb0000, 1037618711259) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0adb0001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0adb0005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0adb6002, decimals) }
        vm.assertGtDecimal(left, right, decimals);
    }

    function assertGtDecimal(uint256 left, uint256 right, uint256 decimals, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0adc0000, 1037618711260) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0adc0001, 4) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0adc0005, 585) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0adc6003, err) }
        vm.assertGtDecimal(left, right, decimals, err);
    }

    function assertGt(int256 left, int256 right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0aab0000, 1037618711211) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0aab0001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0aab0005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0aab6001, right) }
        vm.assertGt(left, right);
    }

    function assertGt(int256 left, int256 right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0aac0000, 1037618711212) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0aac0001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0aac0005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0aac6002, err) }
        vm.assertGt(left, right, err);
    }

    function assertGtDecimal(int256 left, int256 right, uint256 decimals) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0aad0000, 1037618711213) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0aad0001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0aad0005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0aad6002, decimals) }
        vm.assertGtDecimal(left, right, decimals);
    }

    function assertGtDecimal(int256 left, int256 right, uint256 decimals, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0aae0000, 1037618711214) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0aae0001, 4) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0aae0005, 585) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0aae6003, err) }
        vm.assertGtDecimal(left, right, decimals, err);
    }

    function assertLe(uint256 left, uint256 right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0aaf0000, 1037618711215) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0aaf0001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0aaf0005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0aaf6001, right) }
        vm.assertLe(left, right);
    }

    function assertLe(uint256 left, uint256 right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ab00000, 1037618711216) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ab00001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ab00005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ab06002, err) }
        vm.assertLe(left, right, err);
    }

    function assertLeDecimal(uint256 left, uint256 right, uint256 decimals) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ab10000, 1037618711217) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ab10001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ab10005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ab16002, decimals) }
        vm.assertLeDecimal(left, right, decimals);
    }

    function assertLeDecimal(uint256 left, uint256 right, uint256 decimals, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ab20000, 1037618711218) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ab20001, 4) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ab20005, 585) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ab26003, err) }
        vm.assertLeDecimal(left, right, decimals, err);
    }

    function assertLe(int256 left, int256 right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ab30000, 1037618711219) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ab30001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ab30005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ab36001, right) }
        vm.assertLe(left, right);
    }

    function assertLe(int256 left, int256 right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ab40000, 1037618711220) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ab40001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ab40005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ab46002, err) }
        vm.assertLe(left, right, err);
    }

    function assertLeDecimal(int256 left, int256 right, uint256 decimals) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ae70000, 1037618711271) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ae70001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ae70005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ae76002, decimals) }
        vm.assertLeDecimal(left, right, decimals);
    }

    function assertLeDecimal(int256 left, int256 right, uint256 decimals, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ae80000, 1037618711272) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ae80001, 4) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ae80005, 585) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ae86003, err) }
        vm.assertLeDecimal(left, right, decimals, err);
    }

    function assertGe(uint256 left, uint256 right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ae90000, 1037618711273) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ae90001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ae90005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ae96001, right) }
        vm.assertGe(left, right);
    }

    function assertGe(uint256 left, uint256 right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0aea0000, 1037618711274) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0aea0001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0aea0005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0aea6002, err) }
        vm.assertGe(left, right, err);
    }

    function assertGeDecimal(uint256 left, uint256 right, uint256 decimals) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0aeb0000, 1037618711275) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0aeb0001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0aeb0005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0aeb6002, decimals) }
        vm.assertGeDecimal(left, right, decimals);
    }

    function assertGeDecimal(uint256 left, uint256 right, uint256 decimals, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0aec0000, 1037618711276) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0aec0001, 4) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0aec0005, 585) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0aec6003, err) }
        vm.assertGeDecimal(left, right, decimals, err);
    }

    function assertGe(int256 left, int256 right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0aed0000, 1037618711277) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0aed0001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0aed0005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0aed6001, right) }
        vm.assertGe(left, right);
    }

    function assertGe(int256 left, int256 right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0aee0000, 1037618711278) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0aee0001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0aee0005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0aee6002, err) }
        vm.assertGe(left, right, err);
    }

    function assertGeDecimal(int256 left, int256 right, uint256 decimals) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0aef0000, 1037618711279) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0aef0001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0aef0005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0aef6002, decimals) }
        vm.assertGeDecimal(left, right, decimals);
    }

    function assertGeDecimal(int256 left, int256 right, uint256 decimals, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0af00000, 1037618711280) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0af00001, 4) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0af00005, 585) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0af06003, err) }
        vm.assertGeDecimal(left, right, decimals, err);
    }

    function assertApproxEqAbs(uint256 left, uint256 right, uint256 maxDelta) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a990000, 1037618711193) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a990001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a990005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a996002, maxDelta) }
        vm.assertApproxEqAbs(left, right, maxDelta);
    }

    function assertApproxEqAbs(uint256 left, uint256 right, uint256 maxDelta, string memory err)
        internal
        pure
        virtual
    {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a9a0000, 1037618711194) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a9a0001, 4) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a9a0005, 585) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a9a6003, err) }
        vm.assertApproxEqAbs(left, right, maxDelta, err);
    }

    function assertApproxEqAbsDecimal(uint256 left, uint256 right, uint256 maxDelta, uint256 decimals)
        internal
        pure
        virtual
    {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a9b0000, 1037618711195) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a9b0001, 4) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a9b0005, 585) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a9b6003, decimals) }
        vm.assertApproxEqAbsDecimal(left, right, maxDelta, decimals);
    }

    function assertApproxEqAbsDecimal(
        uint256 left,
        uint256 right,
        uint256 maxDelta,
        uint256 decimals,
        string memory err
    ) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a9c0000, 1037618711196) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a9c0001, 5) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a9c0005, 4681) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a9c6004, err) }
        vm.assertApproxEqAbsDecimal(left, right, maxDelta, decimals, err);
    }

    function assertApproxEqAbs(int256 left, int256 right, uint256 maxDelta) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a9d0000, 1037618711197) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a9d0001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a9d0005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a9d6002, maxDelta) }
        vm.assertApproxEqAbs(left, right, maxDelta);
    }

    function assertApproxEqAbs(int256 left, int256 right, uint256 maxDelta, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a9e0000, 1037618711198) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a9e0001, 4) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a9e0005, 585) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a9e6003, err) }
        vm.assertApproxEqAbs(left, right, maxDelta, err);
    }

    function assertApproxEqAbsDecimal(int256 left, int256 right, uint256 maxDelta, uint256 decimals)
        internal
        pure
        virtual
    {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a9f0000, 1037618711199) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a9f0001, 4) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a9f0005, 585) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a9f6003, decimals) }
        vm.assertApproxEqAbsDecimal(left, right, maxDelta, decimals);
    }

    function assertApproxEqAbsDecimal(int256 left, int256 right, uint256 maxDelta, uint256 decimals, string memory err)
        internal
        pure
        virtual
    {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0aa00000, 1037618711200) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0aa00001, 5) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0aa00005, 4681) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0aa06004, err) }
        vm.assertApproxEqAbsDecimal(left, right, maxDelta, decimals, err);
    }

    function assertApproxEqRel(
        uint256 left,
        uint256 right,
        uint256 maxPercentDelta // An 18 decimal fixed point number, where 1e18 == 100%
    ) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ab50000, 1037618711221) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ab50001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ab50005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ab56002, maxPercentDelta) }
        vm.assertApproxEqRel(left, right, maxPercentDelta);
    }

    function assertApproxEqRel(
        uint256 left,
        uint256 right,
        uint256 maxPercentDelta, // An 18 decimal fixed point number, where 1e18 == 100%
        string memory err
    ) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ab60000, 1037618711222) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ab60001, 4) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ab60005, 585) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ab66003, err) }
        vm.assertApproxEqRel(left, right, maxPercentDelta, err);
    }

    function assertApproxEqRelDecimal(
        uint256 left,
        uint256 right,
        uint256 maxPercentDelta, // An 18 decimal fixed point number, where 1e18 == 100%
        uint256 decimals
    ) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ab70000, 1037618711223) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ab70001, 4) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ab70005, 585) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ab76003, decimals) }
        vm.assertApproxEqRelDecimal(left, right, maxPercentDelta, decimals);
    }

    function assertApproxEqRelDecimal(
        uint256 left,
        uint256 right,
        uint256 maxPercentDelta, // An 18 decimal fixed point number, where 1e18 == 100%
        uint256 decimals,
        string memory err
    ) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ab80000, 1037618711224) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ab80001, 5) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ab80005, 4681) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ab86004, err) }
        vm.assertApproxEqRelDecimal(left, right, maxPercentDelta, decimals, err);
    }

    function assertApproxEqRel(int256 left, int256 right, uint256 maxPercentDelta) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ab90000, 1037618711225) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ab90001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ab90005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ab96002, maxPercentDelta) }
        vm.assertApproxEqRel(left, right, maxPercentDelta);
    }

    function assertApproxEqRel(
        int256 left,
        int256 right,
        uint256 maxPercentDelta, // An 18 decimal fixed point number, where 1e18 == 100%
        string memory err
    ) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0aba0000, 1037618711226) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0aba0001, 4) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0aba0005, 585) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0aba6003, err) }
        vm.assertApproxEqRel(left, right, maxPercentDelta, err);
    }

    function assertApproxEqRelDecimal(
        int256 left,
        int256 right,
        uint256 maxPercentDelta, // An 18 decimal fixed point number, where 1e18 == 100%
        uint256 decimals
    ) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0abb0000, 1037618711227) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0abb0001, 4) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0abb0005, 585) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0abb6003, decimals) }
        vm.assertApproxEqRelDecimal(left, right, maxPercentDelta, decimals);
    }

    function assertApproxEqRelDecimal(
        int256 left,
        int256 right,
        uint256 maxPercentDelta, // An 18 decimal fixed point number, where 1e18 == 100%
        uint256 decimals,
        string memory err
    ) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0abc0000, 1037618711228) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0abc0001, 5) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0abc0005, 4681) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0abc6004, err) }
        vm.assertApproxEqRelDecimal(left, right, maxPercentDelta, decimals, err);
    }

    // Inherited from DSTest, not used but kept for backwards-compatibility
    function checkEq0(bytes memory left, bytes memory right) internal pure returns (bool) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0abd0000, 1037618711229) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0abd0001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0abd0005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0abd6001, right) }
        return keccak256(left) == keccak256(right);
    }

    function assertEq0(bytes memory left, bytes memory right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0abe0000, 1037618711230) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0abe0001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0abe0005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0abe6001, right) }
        assertEq(left, right);
    }

    function assertEq0(bytes memory left, bytes memory right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a920000, 1037618711186) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a920001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a920005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a926002, err) }
        assertEq(left, right, err);
    }

    function assertNotEq0(bytes memory left, bytes memory right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a930000, 1037618711187) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a930001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a930005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a936001, right) }
        assertNotEq(left, right);
    }

    function assertNotEq0(bytes memory left, bytes memory right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a940000, 1037618711188) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a940001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a940005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a946002, err) }
        assertNotEq(left, right, err);
    }

    function assertEqCall(address target, bytes memory callDataA, bytes memory callDataB) internal virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a950000, 1037618711189) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a950001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a950005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a956002, callDataB) }
        assertEqCall(target, callDataA, target, callDataB, true);
    }

    function assertEqCall(address targetA, bytes memory callDataA, address targetB, bytes memory callDataB)
        internal
        virtual
    {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a960000, 1037618711190) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a960001, 4) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a960005, 585) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a966003, callDataB) }
        assertEqCall(targetA, callDataA, targetB, callDataB, true);
    }

    function assertEqCall(address target, bytes memory callDataA, bytes memory callDataB, bool strictRevertData)
        internal
        virtual
    {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a970000, 1037618711191) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a970001, 4) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a970005, 585) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a976003, strictRevertData) }
        assertEqCall(target, callDataA, target, callDataB, strictRevertData);
    }

    function assertEqCall(
        address targetA,
        bytes memory callDataA,
        address targetB,
        bytes memory callDataB,
        bool strictRevertData
    ) internal virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a980000, 1037618711192) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a980001, 5) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a980005, 4681) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a986004, strictRevertData) }
        (bool successA, bytes memory returnDataA) = address(targetA).call(callDataA);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00010058,0)}
        (bool successB, bytes memory returnDataB) = address(targetB).call(callDataB);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00010059,0)}

        if (successA && successB) {
            assertEq(returnDataA, returnDataB, "Call return data does not match");
        }

        if (!successA && !successB && strictRevertData) {
            assertEq(returnDataA, returnDataB, "Call revert data does not match");
        }

        if (!successA && successB) {
            emit log("Error: Calls were not equal");
            emit log_named_bytes("  Left call revert data", returnDataA);
            emit log_named_bytes(" Right call return data", returnDataB);
            revert("assertion failed");
        }

        if (successA && !successB) {
            emit log("Error: Calls were not equal");
            emit log_named_bytes("  Left call return data", returnDataA);
            emit log_named_bytes(" Right call revert data", returnDataB);
            revert("assertion failed");
        }
    }
}
