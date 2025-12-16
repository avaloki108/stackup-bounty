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

    function failed() public view returns (bool) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff02f80000, 1037618709240) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff02f80001, 0) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff02f80004, 0) }
        if (_failed) {
            return _failed;
        } else {
            return vm.load(address(vm), bytes32("failed")) != bytes32(0);
        }
    }

    function fail() internal virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03160000, 1037618709270) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03160001, 0) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03160004, 0) }
        vm.store(address(vm), bytes32("failed"), bytes32(uint256(1)));
        _failed = true;
    }

    function assertTrue(bool data) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03170000, 1037618709271) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03170001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03170005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03176000, data) }
        vm.assertTrue(data);
    }

    function assertTrue(bool data, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03190000, 1037618709273) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03190001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03190005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03196001, err) }
        vm.assertTrue(data, err);
    }

    function assertFalse(bool data) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff031a0000, 1037618709274) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff031a0001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff031a0005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff031a6000, data) }
        vm.assertFalse(data);
    }

    function assertFalse(bool data, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03180000, 1037618709272) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03180001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03180005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03186001, err) }
        vm.assertFalse(data, err);
    }

    function assertEq(bool left, bool right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff031b0000, 1037618709275) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff031b0001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff031b0005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff031b6001, right) }
        vm.assertEq(left, right);
    }

    function assertEq(bool left, bool right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff031c0000, 1037618709276) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff031c0001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff031c0005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff031c6002, err) }
        vm.assertEq(left, right, err);
    }

    function assertEq(uint256 left, uint256 right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff031d0000, 1037618709277) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff031d0001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff031d0005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff031d6001, right) }
        vm.assertEq(left, right);
    }

    function assertEq(uint256 left, uint256 right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff031e0000, 1037618709278) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff031e0001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff031e0005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff031e6002, err) }
        vm.assertEq(left, right, err);
    }

    function assertEqDecimal(uint256 left, uint256 right, uint256 decimals) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff031f0000, 1037618709279) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff031f0001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff031f0005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff031f6002, decimals) }
        vm.assertEqDecimal(left, right, decimals);
    }

    function assertEqDecimal(uint256 left, uint256 right, uint256 decimals, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03200000, 1037618709280) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03200001, 4) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03200005, 585) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03206003, err) }
        vm.assertEqDecimal(left, right, decimals, err);
    }

    function assertEq(int256 left, int256 right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03210000, 1037618709281) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03210001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03210005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03216001, right) }
        vm.assertEq(left, right);
    }

    function assertEq(int256 left, int256 right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03220000, 1037618709282) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03220001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03220005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03226002, err) }
        vm.assertEq(left, right, err);
    }

    function assertEqDecimal(int256 left, int256 right, uint256 decimals) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03230000, 1037618709283) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03230001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03230005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03236002, decimals) }
        vm.assertEqDecimal(left, right, decimals);
    }

    function assertEqDecimal(int256 left, int256 right, uint256 decimals, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03240000, 1037618709284) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03240001, 4) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03240005, 585) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03246003, err) }
        vm.assertEqDecimal(left, right, decimals, err);
    }

    function assertEq(address left, address right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03250000, 1037618709285) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03250001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03250005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03256001, right) }
        vm.assertEq(left, right);
    }

    function assertEq(address left, address right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff034b0000, 1037618709323) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff034b0001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff034b0005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff034b6002, err) }
        vm.assertEq(left, right, err);
    }

    function assertEq(bytes32 left, bytes32 right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff034a0000, 1037618709322) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff034a0001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff034a0005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff034a6001, right) }
        vm.assertEq(left, right);
    }

    function assertEq(bytes32 left, bytes32 right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03490000, 1037618709321) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03490001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03490005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03496002, err) }
        vm.assertEq(left, right, err);
    }

    function assertEq32(bytes32 left, bytes32 right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff034c0000, 1037618709324) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff034c0001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff034c0005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff034c6001, right) }
        assertEq(left, right);
    }

    function assertEq32(bytes32 left, bytes32 right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff034d0000, 1037618709325) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff034d0001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff034d0005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff034d6002, err) }
        assertEq(left, right, err);
    }

    function assertEq(string memory left, string memory right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff034e0000, 1037618709326) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff034e0001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff034e0005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff034e6001, right) }
        vm.assertEq(left, right);
    }

    function assertEq(string memory left, string memory right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff034f0000, 1037618709327) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff034f0001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff034f0005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff034f6002, err) }
        vm.assertEq(left, right, err);
    }

    function assertEq(bytes memory left, bytes memory right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03500000, 1037618709328) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03500001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03500005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03506001, right) }
        vm.assertEq(left, right);
    }

    function assertEq(bytes memory left, bytes memory right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03510000, 1037618709329) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03510001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03510005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03516002, err) }
        vm.assertEq(left, right, err);
    }

    function assertEq(bool[] memory left, bool[] memory right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03520000, 1037618709330) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03520001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03520005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03526001, right) }
        vm.assertEq(left, right);
    }

    function assertEq(bool[] memory left, bool[] memory right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff032d0000, 1037618709293) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff032d0001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff032d0005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff032d6002, err) }
        vm.assertEq(left, right, err);
    }

    function assertEq(uint256[] memory left, uint256[] memory right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff032e0000, 1037618709294) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff032e0001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff032e0005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff032e6001, right) }
        vm.assertEq(left, right);
    }

    function assertEq(uint256[] memory left, uint256[] memory right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff032f0000, 1037618709295) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff032f0001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff032f0005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff032f6002, err) }
        vm.assertEq(left, right, err);
    }

    function assertEq(int256[] memory left, int256[] memory right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03260000, 1037618709286) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03260001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03260005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03266001, right) }
        vm.assertEq(left, right);
    }

    function assertEq(int256[] memory left, int256[] memory right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03270000, 1037618709287) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03270001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03270005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03276002, err) }
        vm.assertEq(left, right, err);
    }

    function assertEq(address[] memory left, address[] memory right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03280000, 1037618709288) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03280001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03280005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03286001, right) }
        vm.assertEq(left, right);
    }

    function assertEq(address[] memory left, address[] memory right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03290000, 1037618709289) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03290001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03290005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03296002, err) }
        vm.assertEq(left, right, err);
    }

    function assertEq(bytes32[] memory left, bytes32[] memory right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff032a0000, 1037618709290) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff032a0001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff032a0005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff032a6001, right) }
        vm.assertEq(left, right);
    }

    function assertEq(bytes32[] memory left, bytes32[] memory right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff032b0000, 1037618709291) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff032b0001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff032b0005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff032b6002, err) }
        vm.assertEq(left, right, err);
    }

    function assertEq(string[] memory left, string[] memory right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff032c0000, 1037618709292) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff032c0001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff032c0005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff032c6001, right) }
        vm.assertEq(left, right);
    }

    function assertEq(string[] memory left, string[] memory right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03720000, 1037618709362) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03720001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03720005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03726002, err) }
        vm.assertEq(left, right, err);
    }

    function assertEq(bytes[] memory left, bytes[] memory right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03730000, 1037618709363) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03730001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03730005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03736001, right) }
        vm.assertEq(left, right);
    }

    function assertEq(bytes[] memory left, bytes[] memory right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03740000, 1037618709364) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03740001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03740005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03746002, err) }
        vm.assertEq(left, right, err);
    }

    // Legacy helper
    function assertEqUint(uint256 left, uint256 right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03750000, 1037618709365) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03750001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03750005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03756001, right) }
        assertEq(left, right);
    }

    function assertNotEq(bool left, bool right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03760000, 1037618709366) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03760001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03760005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03766001, right) }
        vm.assertNotEq(left, right);
    }

    function assertNotEq(bool left, bool right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03770000, 1037618709367) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03770001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03770005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03776002, err) }
        vm.assertNotEq(left, right, err);
    }

    function assertNotEq(uint256 left, uint256 right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03780000, 1037618709368) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03780001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03780005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03786001, right) }
        vm.assertNotEq(left, right);
    }

    function assertNotEq(uint256 left, uint256 right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03790000, 1037618709369) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03790001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03790005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03796002, err) }
        vm.assertNotEq(left, right, err);
    }

    function assertNotEqDecimal(uint256 left, uint256 right, uint256 decimals) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff037a0000, 1037618709370) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff037a0001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff037a0005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff037a6002, decimals) }
        vm.assertNotEqDecimal(left, right, decimals);
    }

    function assertNotEqDecimal(uint256 left, uint256 right, uint256 decimals, string memory err)
        internal
        pure
        virtual
    {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03300000, 1037618709296) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03300001, 4) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03300005, 585) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03306003, err) }
        vm.assertNotEqDecimal(left, right, decimals, err);
    }

    function assertNotEq(int256 left, int256 right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03310000, 1037618709297) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03310001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03310005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03316001, right) }
        vm.assertNotEq(left, right);
    }

    function assertNotEq(int256 left, int256 right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03320000, 1037618709298) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03320001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03320005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03326002, err) }
        vm.assertNotEq(left, right, err);
    }

    function assertNotEqDecimal(int256 left, int256 right, uint256 decimals) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03330000, 1037618709299) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03330001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03330005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03336002, decimals) }
        vm.assertNotEqDecimal(left, right, decimals);
    }

    function assertNotEqDecimal(int256 left, int256 right, uint256 decimals, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03340000, 1037618709300) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03340001, 4) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03340005, 585) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03346003, err) }
        vm.assertNotEqDecimal(left, right, decimals, err);
    }

    function assertNotEq(address left, address right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03350000, 1037618709301) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03350001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03350005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03356001, right) }
        vm.assertNotEq(left, right);
    }

    function assertNotEq(address left, address right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03360000, 1037618709302) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03360001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03360005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03366002, err) }
        vm.assertNotEq(left, right, err);
    }

    function assertNotEq(bytes32 left, bytes32 right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03370000, 1037618709303) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03370001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03370005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03376001, right) }
        vm.assertNotEq(left, right);
    }

    function assertNotEq(bytes32 left, bytes32 right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03380000, 1037618709304) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03380001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03380005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03386002, err) }
        vm.assertNotEq(left, right, err);
    }

    function assertNotEq32(bytes32 left, bytes32 right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03390000, 1037618709305) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03390001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03390005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03396001, right) }
        assertNotEq(left, right);
    }

    function assertNotEq32(bytes32 left, bytes32 right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff037b0000, 1037618709371) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff037b0001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff037b0005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff037b6002, err) }
        assertNotEq(left, right, err);
    }

    function assertNotEq(string memory left, string memory right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03850000, 1037618709381) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03850001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03850005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03856001, right) }
        vm.assertNotEq(left, right);
    }

    function assertNotEq(string memory left, string memory right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03860000, 1037618709382) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03860001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03860005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03866002, err) }
        vm.assertNotEq(left, right, err);
    }

    function assertNotEq(bytes memory left, bytes memory right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03870000, 1037618709383) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03870001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03870005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03876001, right) }
        vm.assertNotEq(left, right);
    }

    function assertNotEq(bytes memory left, bytes memory right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03880000, 1037618709384) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03880001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03880005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03886002, err) }
        vm.assertNotEq(left, right, err);
    }

    function assertNotEq(bool[] memory left, bool[] memory right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03890000, 1037618709385) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03890001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03890005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03896001, right) }
        vm.assertNotEq(left, right);
    }

    function assertNotEq(bool[] memory left, bool[] memory right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff038a0000, 1037618709386) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff038a0001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff038a0005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff038a6002, err) }
        vm.assertNotEq(left, right, err);
    }

    function assertNotEq(uint256[] memory left, uint256[] memory right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff038b0000, 1037618709387) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff038b0001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff038b0005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff038b6001, right) }
        vm.assertNotEq(left, right);
    }

    function assertNotEq(uint256[] memory left, uint256[] memory right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff038c0000, 1037618709388) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff038c0001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff038c0005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff038c6002, err) }
        vm.assertNotEq(left, right, err);
    }

    function assertNotEq(int256[] memory left, int256[] memory right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff038d0000, 1037618709389) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff038d0001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff038d0005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff038d6001, right) }
        vm.assertNotEq(left, right);
    }

    function assertNotEq(int256[] memory left, int256[] memory right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff038e0000, 1037618709390) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff038e0001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff038e0005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff038e6002, err) }
        vm.assertNotEq(left, right, err);
    }

    function assertNotEq(address[] memory left, address[] memory right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff036e0000, 1037618709358) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff036e0001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff036e0005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff036e6001, right) }
        vm.assertNotEq(left, right);
    }

    function assertNotEq(address[] memory left, address[] memory right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff036f0000, 1037618709359) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff036f0001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff036f0005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff036f6002, err) }
        vm.assertNotEq(left, right, err);
    }

    function assertNotEq(bytes32[] memory left, bytes32[] memory right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03700000, 1037618709360) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03700001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03700005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03706001, right) }
        vm.assertNotEq(left, right);
    }

    function assertNotEq(bytes32[] memory left, bytes32[] memory right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03710000, 1037618709361) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03710001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03710005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03716002, err) }
        vm.assertNotEq(left, right, err);
    }

    function assertNotEq(string[] memory left, string[] memory right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03670000, 1037618709351) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03670001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03670005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03676001, right) }
        vm.assertNotEq(left, right);
    }

    function assertNotEq(string[] memory left, string[] memory right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03680000, 1037618709352) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03680001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03680005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03686002, err) }
        vm.assertNotEq(left, right, err);
    }

    function assertNotEq(bytes[] memory left, bytes[] memory right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03690000, 1037618709353) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03690001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03690005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03696001, right) }
        vm.assertNotEq(left, right);
    }

    function assertNotEq(bytes[] memory left, bytes[] memory right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff036a0000, 1037618709354) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff036a0001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff036a0005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff036a6002, err) }
        vm.assertNotEq(left, right, err);
    }

    function assertLt(uint256 left, uint256 right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff036b0000, 1037618709355) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff036b0001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff036b0005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff036b6001, right) }
        vm.assertLt(left, right);
    }

    function assertLt(uint256 left, uint256 right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff036c0000, 1037618709356) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff036c0001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff036c0005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff036c6002, err) }
        vm.assertLt(left, right, err);
    }

    function assertLtDecimal(uint256 left, uint256 right, uint256 decimals) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff036d0000, 1037618709357) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff036d0001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff036d0005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff036d6002, decimals) }
        vm.assertLtDecimal(left, right, decimals);
    }

    function assertLtDecimal(uint256 left, uint256 right, uint256 decimals, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff037c0000, 1037618709372) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff037c0001, 4) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff037c0005, 585) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff037c6003, err) }
        vm.assertLtDecimal(left, right, decimals, err);
    }

    function assertLt(int256 left, int256 right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff037d0000, 1037618709373) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff037d0001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff037d0005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff037d6001, right) }
        vm.assertLt(left, right);
    }

    function assertLt(int256 left, int256 right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff037e0000, 1037618709374) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff037e0001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff037e0005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff037e6002, err) }
        vm.assertLt(left, right, err);
    }

    function assertLtDecimal(int256 left, int256 right, uint256 decimals) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff037f0000, 1037618709375) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff037f0001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff037f0005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff037f6002, decimals) }
        vm.assertLtDecimal(left, right, decimals);
    }

    function assertLtDecimal(int256 left, int256 right, uint256 decimals, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03800000, 1037618709376) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03800001, 4) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03800005, 585) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03806003, err) }
        vm.assertLtDecimal(left, right, decimals, err);
    }

    function assertGt(uint256 left, uint256 right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03810000, 1037618709377) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03810001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03810005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03816001, right) }
        vm.assertGt(left, right);
    }

    function assertGt(uint256 left, uint256 right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03820000, 1037618709378) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03820001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03820005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03826002, err) }
        vm.assertGt(left, right, err);
    }

    function assertGtDecimal(uint256 left, uint256 right, uint256 decimals) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03830000, 1037618709379) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03830001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03830005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03836002, decimals) }
        vm.assertGtDecimal(left, right, decimals);
    }

    function assertGtDecimal(uint256 left, uint256 right, uint256 decimals, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03840000, 1037618709380) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03840001, 4) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03840005, 585) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03846003, err) }
        vm.assertGtDecimal(left, right, decimals, err);
    }

    function assertGt(int256 left, int256 right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03530000, 1037618709331) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03530001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03530005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03536001, right) }
        vm.assertGt(left, right);
    }

    function assertGt(int256 left, int256 right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03540000, 1037618709332) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03540001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03540005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03546002, err) }
        vm.assertGt(left, right, err);
    }

    function assertGtDecimal(int256 left, int256 right, uint256 decimals) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03550000, 1037618709333) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03550001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03550005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03556002, decimals) }
        vm.assertGtDecimal(left, right, decimals);
    }

    function assertGtDecimal(int256 left, int256 right, uint256 decimals, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03560000, 1037618709334) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03560001, 4) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03560005, 585) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03566003, err) }
        vm.assertGtDecimal(left, right, decimals, err);
    }

    function assertLe(uint256 left, uint256 right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03570000, 1037618709335) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03570001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03570005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03576001, right) }
        vm.assertLe(left, right);
    }

    function assertLe(uint256 left, uint256 right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03580000, 1037618709336) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03580001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03580005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03586002, err) }
        vm.assertLe(left, right, err);
    }

    function assertLeDecimal(uint256 left, uint256 right, uint256 decimals) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03590000, 1037618709337) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03590001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03590005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03596002, decimals) }
        vm.assertLeDecimal(left, right, decimals);
    }

    function assertLeDecimal(uint256 left, uint256 right, uint256 decimals, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff035a0000, 1037618709338) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff035a0001, 4) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff035a0005, 585) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff035a6003, err) }
        vm.assertLeDecimal(left, right, decimals, err);
    }

    function assertLe(int256 left, int256 right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff035b0000, 1037618709339) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff035b0001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff035b0005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff035b6001, right) }
        vm.assertLe(left, right);
    }

    function assertLe(int256 left, int256 right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff035c0000, 1037618709340) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff035c0001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff035c0005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff035c6002, err) }
        vm.assertLe(left, right, err);
    }

    function assertLeDecimal(int256 left, int256 right, uint256 decimals) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff038f0000, 1037618709391) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff038f0001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff038f0005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff038f6002, decimals) }
        vm.assertLeDecimal(left, right, decimals);
    }

    function assertLeDecimal(int256 left, int256 right, uint256 decimals, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03900000, 1037618709392) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03900001, 4) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03900005, 585) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03906003, err) }
        vm.assertLeDecimal(left, right, decimals, err);
    }

    function assertGe(uint256 left, uint256 right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03910000, 1037618709393) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03910001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03910005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03916001, right) }
        vm.assertGe(left, right);
    }

    function assertGe(uint256 left, uint256 right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03920000, 1037618709394) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03920001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03920005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03926002, err) }
        vm.assertGe(left, right, err);
    }

    function assertGeDecimal(uint256 left, uint256 right, uint256 decimals) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03930000, 1037618709395) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03930001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03930005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03936002, decimals) }
        vm.assertGeDecimal(left, right, decimals);
    }

    function assertGeDecimal(uint256 left, uint256 right, uint256 decimals, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03940000, 1037618709396) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03940001, 4) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03940005, 585) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03946003, err) }
        vm.assertGeDecimal(left, right, decimals, err);
    }

    function assertGe(int256 left, int256 right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03950000, 1037618709397) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03950001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03950005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03956001, right) }
        vm.assertGe(left, right);
    }

    function assertGe(int256 left, int256 right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03960000, 1037618709398) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03960001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03960005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03966002, err) }
        vm.assertGe(left, right, err);
    }

    function assertGeDecimal(int256 left, int256 right, uint256 decimals) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03970000, 1037618709399) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03970001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03970005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03976002, decimals) }
        vm.assertGeDecimal(left, right, decimals);
    }

    function assertGeDecimal(int256 left, int256 right, uint256 decimals, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03980000, 1037618709400) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03980001, 4) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03980005, 585) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03986003, err) }
        vm.assertGeDecimal(left, right, decimals, err);
    }

    function assertApproxEqAbs(uint256 left, uint256 right, uint256 maxDelta) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03410000, 1037618709313) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03410001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03410005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03416002, maxDelta) }
        vm.assertApproxEqAbs(left, right, maxDelta);
    }

    function assertApproxEqAbs(uint256 left, uint256 right, uint256 maxDelta, string memory err)
        internal
        pure
        virtual
    {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03420000, 1037618709314) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03420001, 4) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03420005, 585) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03426003, err) }
        vm.assertApproxEqAbs(left, right, maxDelta, err);
    }

    function assertApproxEqAbsDecimal(uint256 left, uint256 right, uint256 maxDelta, uint256 decimals)
        internal
        pure
        virtual
    {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03430000, 1037618709315) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03430001, 4) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03430005, 585) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03436003, decimals) }
        vm.assertApproxEqAbsDecimal(left, right, maxDelta, decimals);
    }

    function assertApproxEqAbsDecimal(
        uint256 left,
        uint256 right,
        uint256 maxDelta,
        uint256 decimals,
        string memory err
    ) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03440000, 1037618709316) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03440001, 5) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03440005, 4681) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03446004, err) }
        vm.assertApproxEqAbsDecimal(left, right, maxDelta, decimals, err);
    }

    function assertApproxEqAbs(int256 left, int256 right, uint256 maxDelta) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03450000, 1037618709317) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03450001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03450005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03456002, maxDelta) }
        vm.assertApproxEqAbs(left, right, maxDelta);
    }

    function assertApproxEqAbs(int256 left, int256 right, uint256 maxDelta, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03460000, 1037618709318) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03460001, 4) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03460005, 585) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03466003, err) }
        vm.assertApproxEqAbs(left, right, maxDelta, err);
    }

    function assertApproxEqAbsDecimal(int256 left, int256 right, uint256 maxDelta, uint256 decimals)
        internal
        pure
        virtual
    {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03470000, 1037618709319) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03470001, 4) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03470005, 585) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03476003, decimals) }
        vm.assertApproxEqAbsDecimal(left, right, maxDelta, decimals);
    }

    function assertApproxEqAbsDecimal(int256 left, int256 right, uint256 maxDelta, uint256 decimals, string memory err)
        internal
        pure
        virtual
    {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03480000, 1037618709320) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03480001, 5) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03480005, 4681) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03486004, err) }
        vm.assertApproxEqAbsDecimal(left, right, maxDelta, decimals, err);
    }

    function assertApproxEqRel(
        uint256 left,
        uint256 right,
        uint256 maxPercentDelta // An 18 decimal fixed point number, where 1e18 == 100%
    ) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff035d0000, 1037618709341) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff035d0001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff035d0005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff035d6002, maxPercentDelta) }
        vm.assertApproxEqRel(left, right, maxPercentDelta);
    }

    function assertApproxEqRel(
        uint256 left,
        uint256 right,
        uint256 maxPercentDelta, // An 18 decimal fixed point number, where 1e18 == 100%
        string memory err
    ) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff035e0000, 1037618709342) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff035e0001, 4) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff035e0005, 585) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff035e6003, err) }
        vm.assertApproxEqRel(left, right, maxPercentDelta, err);
    }

    function assertApproxEqRelDecimal(
        uint256 left,
        uint256 right,
        uint256 maxPercentDelta, // An 18 decimal fixed point number, where 1e18 == 100%
        uint256 decimals
    ) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff035f0000, 1037618709343) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff035f0001, 4) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff035f0005, 585) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff035f6003, decimals) }
        vm.assertApproxEqRelDecimal(left, right, maxPercentDelta, decimals);
    }

    function assertApproxEqRelDecimal(
        uint256 left,
        uint256 right,
        uint256 maxPercentDelta, // An 18 decimal fixed point number, where 1e18 == 100%
        uint256 decimals,
        string memory err
    ) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03600000, 1037618709344) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03600001, 5) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03600005, 4681) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03606004, err) }
        vm.assertApproxEqRelDecimal(left, right, maxPercentDelta, decimals, err);
    }

    function assertApproxEqRel(int256 left, int256 right, uint256 maxPercentDelta) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03610000, 1037618709345) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03610001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03610005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03616002, maxPercentDelta) }
        vm.assertApproxEqRel(left, right, maxPercentDelta);
    }

    function assertApproxEqRel(
        int256 left,
        int256 right,
        uint256 maxPercentDelta, // An 18 decimal fixed point number, where 1e18 == 100%
        string memory err
    ) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03620000, 1037618709346) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03620001, 4) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03620005, 585) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03626003, err) }
        vm.assertApproxEqRel(left, right, maxPercentDelta, err);
    }

    function assertApproxEqRelDecimal(
        int256 left,
        int256 right,
        uint256 maxPercentDelta, // An 18 decimal fixed point number, where 1e18 == 100%
        uint256 decimals
    ) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03630000, 1037618709347) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03630001, 4) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03630005, 585) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03636003, decimals) }
        vm.assertApproxEqRelDecimal(left, right, maxPercentDelta, decimals);
    }

    function assertApproxEqRelDecimal(
        int256 left,
        int256 right,
        uint256 maxPercentDelta, // An 18 decimal fixed point number, where 1e18 == 100%
        uint256 decimals,
        string memory err
    ) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03640000, 1037618709348) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03640001, 5) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03640005, 4681) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03646004, err) }
        vm.assertApproxEqRelDecimal(left, right, maxPercentDelta, decimals, err);
    }

    // Inherited from DSTest, not used but kept for backwards-compatibility
    function checkEq0(bytes memory left, bytes memory right) internal pure returns (bool) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03650000, 1037618709349) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03650001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03650005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03656001, right) }
        return keccak256(left) == keccak256(right);
    }

    function assertEq0(bytes memory left, bytes memory right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03660000, 1037618709350) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03660001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03660005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03666001, right) }
        assertEq(left, right);
    }

    function assertEq0(bytes memory left, bytes memory right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff033a0000, 1037618709306) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff033a0001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff033a0005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff033a6002, err) }
        assertEq(left, right, err);
    }

    function assertNotEq0(bytes memory left, bytes memory right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff033b0000, 1037618709307) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff033b0001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff033b0005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff033b6001, right) }
        assertNotEq(left, right);
    }

    function assertNotEq0(bytes memory left, bytes memory right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff033c0000, 1037618709308) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff033c0001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff033c0005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff033c6002, err) }
        assertNotEq(left, right, err);
    }

    function assertEqCall(address target, bytes memory callDataA, bytes memory callDataB) internal virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff033d0000, 1037618709309) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff033d0001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff033d0005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff033d6002, callDataB) }
        assertEqCall(target, callDataA, target, callDataB, true);
    }

    function assertEqCall(address targetA, bytes memory callDataA, address targetB, bytes memory callDataB)
        internal
        virtual
    {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff033e0000, 1037618709310) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff033e0001, 4) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff033e0005, 585) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff033e6003, callDataB) }
        assertEqCall(targetA, callDataA, targetB, callDataB, true);
    }

    function assertEqCall(address target, bytes memory callDataA, bytes memory callDataB, bool strictRevertData)
        internal
        virtual
    {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff033f0000, 1037618709311) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff033f0001, 4) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff033f0005, 585) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff033f6003, strictRevertData) }
        assertEqCall(target, callDataA, target, callDataB, strictRevertData);
    }

    function assertEqCall(
        address targetA,
        bytes memory callDataA,
        address targetB,
        bytes memory callDataB,
        bool strictRevertData
    ) internal virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03400000, 1037618709312) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03400001, 5) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03400005, 4681) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03406004, strictRevertData) }
        (bool successA, bytes memory returnDataA) = address(targetA).call(callDataA);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0001008b,0)}
        (bool successB, bytes memory returnDataB) = address(targetB).call(callDataB);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0001008c,0)}

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
