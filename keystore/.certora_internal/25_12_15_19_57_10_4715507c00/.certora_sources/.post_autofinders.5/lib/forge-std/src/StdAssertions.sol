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

    function failed() public view returns (bool) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09180000, 1037618710808) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09180001, 0) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09180004, 0) }
        if (_failed) {
            return _failed;
        } else {
            return vm.load(address(vm), bytes32("failed")) != bytes32(0);
        }
    }

    function fail() internal virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff091e0000, 1037618710814) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff091e0001, 0) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff091e0004, 0) }
        vm.store(address(vm), bytes32("failed"), bytes32(uint256(1)));
        _failed = true;
    }

    function assertTrue(bool data) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff091f0000, 1037618710815) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff091f0001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff091f0005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff091f6000, data) }
        vm.assertTrue(data);
    }

    function assertTrue(bool data, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09210000, 1037618710817) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09210001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09210005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09216001, err) }
        vm.assertTrue(data, err);
    }

    function assertFalse(bool data) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09220000, 1037618710818) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09220001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09220005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09226000, data) }
        vm.assertFalse(data);
    }

    function assertFalse(bool data, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09200000, 1037618710816) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09200001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09200005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09206001, err) }
        vm.assertFalse(data, err);
    }

    function assertEq(bool left, bool right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09230000, 1037618710819) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09230001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09230005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09236001, right) }
        vm.assertEq(left, right);
    }

    function assertEq(bool left, bool right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09240000, 1037618710820) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09240001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09240005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09246002, err) }
        vm.assertEq(left, right, err);
    }

    function assertEq(uint256 left, uint256 right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09250000, 1037618710821) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09250001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09250005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09256001, right) }
        vm.assertEq(left, right);
    }

    function assertEq(uint256 left, uint256 right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09260000, 1037618710822) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09260001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09260005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09266002, err) }
        vm.assertEq(left, right, err);
    }

    function assertEqDecimal(uint256 left, uint256 right, uint256 decimals) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09270000, 1037618710823) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09270001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09270005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09276002, decimals) }
        vm.assertEqDecimal(left, right, decimals);
    }

    function assertEqDecimal(uint256 left, uint256 right, uint256 decimals, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09280000, 1037618710824) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09280001, 4) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09280005, 585) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09286003, err) }
        vm.assertEqDecimal(left, right, decimals, err);
    }

    function assertEq(int256 left, int256 right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09290000, 1037618710825) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09290001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09290005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09296001, right) }
        vm.assertEq(left, right);
    }

    function assertEq(int256 left, int256 right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff092a0000, 1037618710826) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff092a0001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff092a0005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff092a6002, err) }
        vm.assertEq(left, right, err);
    }

    function assertEqDecimal(int256 left, int256 right, uint256 decimals) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff092b0000, 1037618710827) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff092b0001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff092b0005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff092b6002, decimals) }
        vm.assertEqDecimal(left, right, decimals);
    }

    function assertEqDecimal(int256 left, int256 right, uint256 decimals, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff092c0000, 1037618710828) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff092c0001, 4) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff092c0005, 585) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff092c6003, err) }
        vm.assertEqDecimal(left, right, decimals, err);
    }

    function assertEq(address left, address right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff092d0000, 1037618710829) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff092d0001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff092d0005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff092d6001, right) }
        vm.assertEq(left, right);
    }

    function assertEq(address left, address right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09530000, 1037618710867) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09530001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09530005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09536002, err) }
        vm.assertEq(left, right, err);
    }

    function assertEq(bytes32 left, bytes32 right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09520000, 1037618710866) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09520001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09520005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09526001, right) }
        vm.assertEq(left, right);
    }

    function assertEq(bytes32 left, bytes32 right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09510000, 1037618710865) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09510001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09510005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09516002, err) }
        vm.assertEq(left, right, err);
    }

    function assertEq32(bytes32 left, bytes32 right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09540000, 1037618710868) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09540001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09540005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09546001, right) }
        assertEq(left, right);
    }

    function assertEq32(bytes32 left, bytes32 right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09550000, 1037618710869) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09550001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09550005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09556002, err) }
        assertEq(left, right, err);
    }

    function assertEq(string memory left, string memory right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09560000, 1037618710870) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09560001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09560005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09566001, right) }
        vm.assertEq(left, right);
    }

    function assertEq(string memory left, string memory right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09570000, 1037618710871) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09570001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09570005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09576002, err) }
        vm.assertEq(left, right, err);
    }

    function assertEq(bytes memory left, bytes memory right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09580000, 1037618710872) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09580001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09580005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09586001, right) }
        vm.assertEq(left, right);
    }

    function assertEq(bytes memory left, bytes memory right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09590000, 1037618710873) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09590001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09590005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09596002, err) }
        vm.assertEq(left, right, err);
    }

    function assertEq(bool[] memory left, bool[] memory right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff095a0000, 1037618710874) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff095a0001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff095a0005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff095a6001, right) }
        vm.assertEq(left, right);
    }

    function assertEq(bool[] memory left, bool[] memory right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09350000, 1037618710837) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09350001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09350005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09356002, err) }
        vm.assertEq(left, right, err);
    }

    function assertEq(uint256[] memory left, uint256[] memory right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09360000, 1037618710838) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09360001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09360005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09366001, right) }
        vm.assertEq(left, right);
    }

    function assertEq(uint256[] memory left, uint256[] memory right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09370000, 1037618710839) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09370001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09370005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09376002, err) }
        vm.assertEq(left, right, err);
    }

    function assertEq(int256[] memory left, int256[] memory right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff092e0000, 1037618710830) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff092e0001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff092e0005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff092e6001, right) }
        vm.assertEq(left, right);
    }

    function assertEq(int256[] memory left, int256[] memory right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff092f0000, 1037618710831) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff092f0001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff092f0005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff092f6002, err) }
        vm.assertEq(left, right, err);
    }

    function assertEq(address[] memory left, address[] memory right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09300000, 1037618710832) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09300001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09300005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09306001, right) }
        vm.assertEq(left, right);
    }

    function assertEq(address[] memory left, address[] memory right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09310000, 1037618710833) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09310001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09310005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09316002, err) }
        vm.assertEq(left, right, err);
    }

    function assertEq(bytes32[] memory left, bytes32[] memory right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09320000, 1037618710834) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09320001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09320005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09326001, right) }
        vm.assertEq(left, right);
    }

    function assertEq(bytes32[] memory left, bytes32[] memory right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09330000, 1037618710835) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09330001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09330005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09336002, err) }
        vm.assertEq(left, right, err);
    }

    function assertEq(string[] memory left, string[] memory right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09340000, 1037618710836) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09340001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09340005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09346001, right) }
        vm.assertEq(left, right);
    }

    function assertEq(string[] memory left, string[] memory right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff097a0000, 1037618710906) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff097a0001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff097a0005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff097a6002, err) }
        vm.assertEq(left, right, err);
    }

    function assertEq(bytes[] memory left, bytes[] memory right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff097b0000, 1037618710907) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff097b0001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff097b0005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff097b6001, right) }
        vm.assertEq(left, right);
    }

    function assertEq(bytes[] memory left, bytes[] memory right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff097c0000, 1037618710908) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff097c0001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff097c0005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff097c6002, err) }
        vm.assertEq(left, right, err);
    }

    // Legacy helper
    function assertEqUint(uint256 left, uint256 right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff097d0000, 1037618710909) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff097d0001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff097d0005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff097d6001, right) }
        assertEq(left, right);
    }

    function assertNotEq(bool left, bool right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff097e0000, 1037618710910) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff097e0001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff097e0005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff097e6001, right) }
        vm.assertNotEq(left, right);
    }

    function assertNotEq(bool left, bool right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff097f0000, 1037618710911) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff097f0001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff097f0005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff097f6002, err) }
        vm.assertNotEq(left, right, err);
    }

    function assertNotEq(uint256 left, uint256 right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09800000, 1037618710912) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09800001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09800005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09806001, right) }
        vm.assertNotEq(left, right);
    }

    function assertNotEq(uint256 left, uint256 right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09810000, 1037618710913) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09810001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09810005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09816002, err) }
        vm.assertNotEq(left, right, err);
    }

    function assertNotEqDecimal(uint256 left, uint256 right, uint256 decimals) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09820000, 1037618710914) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09820001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09820005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09826002, decimals) }
        vm.assertNotEqDecimal(left, right, decimals);
    }

    function assertNotEqDecimal(uint256 left, uint256 right, uint256 decimals, string memory err)
        internal
        pure
        virtual
    {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09380000, 1037618710840) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09380001, 4) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09380005, 585) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09386003, err) }
        vm.assertNotEqDecimal(left, right, decimals, err);
    }

    function assertNotEq(int256 left, int256 right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09390000, 1037618710841) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09390001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09390005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09396001, right) }
        vm.assertNotEq(left, right);
    }

    function assertNotEq(int256 left, int256 right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff093a0000, 1037618710842) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff093a0001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff093a0005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff093a6002, err) }
        vm.assertNotEq(left, right, err);
    }

    function assertNotEqDecimal(int256 left, int256 right, uint256 decimals) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff093b0000, 1037618710843) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff093b0001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff093b0005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff093b6002, decimals) }
        vm.assertNotEqDecimal(left, right, decimals);
    }

    function assertNotEqDecimal(int256 left, int256 right, uint256 decimals, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff093c0000, 1037618710844) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff093c0001, 4) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff093c0005, 585) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff093c6003, err) }
        vm.assertNotEqDecimal(left, right, decimals, err);
    }

    function assertNotEq(address left, address right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff093d0000, 1037618710845) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff093d0001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff093d0005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff093d6001, right) }
        vm.assertNotEq(left, right);
    }

    function assertNotEq(address left, address right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff093e0000, 1037618710846) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff093e0001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff093e0005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff093e6002, err) }
        vm.assertNotEq(left, right, err);
    }

    function assertNotEq(bytes32 left, bytes32 right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff093f0000, 1037618710847) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff093f0001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff093f0005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff093f6001, right) }
        vm.assertNotEq(left, right);
    }

    function assertNotEq(bytes32 left, bytes32 right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09400000, 1037618710848) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09400001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09400005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09406002, err) }
        vm.assertNotEq(left, right, err);
    }

    function assertNotEq32(bytes32 left, bytes32 right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09410000, 1037618710849) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09410001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09410005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09416001, right) }
        assertNotEq(left, right);
    }

    function assertNotEq32(bytes32 left, bytes32 right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09830000, 1037618710915) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09830001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09830005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09836002, err) }
        assertNotEq(left, right, err);
    }

    function assertNotEq(string memory left, string memory right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff098d0000, 1037618710925) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff098d0001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff098d0005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff098d6001, right) }
        vm.assertNotEq(left, right);
    }

    function assertNotEq(string memory left, string memory right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff098e0000, 1037618710926) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff098e0001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff098e0005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff098e6002, err) }
        vm.assertNotEq(left, right, err);
    }

    function assertNotEq(bytes memory left, bytes memory right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff098f0000, 1037618710927) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff098f0001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff098f0005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff098f6001, right) }
        vm.assertNotEq(left, right);
    }

    function assertNotEq(bytes memory left, bytes memory right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09900000, 1037618710928) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09900001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09900005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09906002, err) }
        vm.assertNotEq(left, right, err);
    }

    function assertNotEq(bool[] memory left, bool[] memory right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09910000, 1037618710929) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09910001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09910005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09916001, right) }
        vm.assertNotEq(left, right);
    }

    function assertNotEq(bool[] memory left, bool[] memory right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09920000, 1037618710930) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09920001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09920005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09926002, err) }
        vm.assertNotEq(left, right, err);
    }

    function assertNotEq(uint256[] memory left, uint256[] memory right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09930000, 1037618710931) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09930001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09930005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09936001, right) }
        vm.assertNotEq(left, right);
    }

    function assertNotEq(uint256[] memory left, uint256[] memory right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09940000, 1037618710932) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09940001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09940005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09946002, err) }
        vm.assertNotEq(left, right, err);
    }

    function assertNotEq(int256[] memory left, int256[] memory right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09950000, 1037618710933) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09950001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09950005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09956001, right) }
        vm.assertNotEq(left, right);
    }

    function assertNotEq(int256[] memory left, int256[] memory right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09960000, 1037618710934) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09960001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09960005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09966002, err) }
        vm.assertNotEq(left, right, err);
    }

    function assertNotEq(address[] memory left, address[] memory right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09760000, 1037618710902) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09760001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09760005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09766001, right) }
        vm.assertNotEq(left, right);
    }

    function assertNotEq(address[] memory left, address[] memory right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09770000, 1037618710903) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09770001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09770005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09776002, err) }
        vm.assertNotEq(left, right, err);
    }

    function assertNotEq(bytes32[] memory left, bytes32[] memory right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09780000, 1037618710904) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09780001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09780005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09786001, right) }
        vm.assertNotEq(left, right);
    }

    function assertNotEq(bytes32[] memory left, bytes32[] memory right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09790000, 1037618710905) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09790001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09790005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09796002, err) }
        vm.assertNotEq(left, right, err);
    }

    function assertNotEq(string[] memory left, string[] memory right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff096f0000, 1037618710895) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff096f0001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff096f0005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff096f6001, right) }
        vm.assertNotEq(left, right);
    }

    function assertNotEq(string[] memory left, string[] memory right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09700000, 1037618710896) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09700001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09700005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09706002, err) }
        vm.assertNotEq(left, right, err);
    }

    function assertNotEq(bytes[] memory left, bytes[] memory right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09710000, 1037618710897) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09710001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09710005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09716001, right) }
        vm.assertNotEq(left, right);
    }

    function assertNotEq(bytes[] memory left, bytes[] memory right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09720000, 1037618710898) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09720001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09720005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09726002, err) }
        vm.assertNotEq(left, right, err);
    }

    function assertLt(uint256 left, uint256 right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09730000, 1037618710899) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09730001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09730005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09736001, right) }
        vm.assertLt(left, right);
    }

    function assertLt(uint256 left, uint256 right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09740000, 1037618710900) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09740001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09740005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09746002, err) }
        vm.assertLt(left, right, err);
    }

    function assertLtDecimal(uint256 left, uint256 right, uint256 decimals) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09750000, 1037618710901) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09750001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09750005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09756002, decimals) }
        vm.assertLtDecimal(left, right, decimals);
    }

    function assertLtDecimal(uint256 left, uint256 right, uint256 decimals, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09840000, 1037618710916) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09840001, 4) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09840005, 585) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09846003, err) }
        vm.assertLtDecimal(left, right, decimals, err);
    }

    function assertLt(int256 left, int256 right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09850000, 1037618710917) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09850001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09850005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09856001, right) }
        vm.assertLt(left, right);
    }

    function assertLt(int256 left, int256 right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09860000, 1037618710918) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09860001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09860005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09866002, err) }
        vm.assertLt(left, right, err);
    }

    function assertLtDecimal(int256 left, int256 right, uint256 decimals) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09870000, 1037618710919) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09870001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09870005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09876002, decimals) }
        vm.assertLtDecimal(left, right, decimals);
    }

    function assertLtDecimal(int256 left, int256 right, uint256 decimals, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09880000, 1037618710920) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09880001, 4) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09880005, 585) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09886003, err) }
        vm.assertLtDecimal(left, right, decimals, err);
    }

    function assertGt(uint256 left, uint256 right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09890000, 1037618710921) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09890001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09890005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09896001, right) }
        vm.assertGt(left, right);
    }

    function assertGt(uint256 left, uint256 right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff098a0000, 1037618710922) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff098a0001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff098a0005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff098a6002, err) }
        vm.assertGt(left, right, err);
    }

    function assertGtDecimal(uint256 left, uint256 right, uint256 decimals) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff098b0000, 1037618710923) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff098b0001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff098b0005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff098b6002, decimals) }
        vm.assertGtDecimal(left, right, decimals);
    }

    function assertGtDecimal(uint256 left, uint256 right, uint256 decimals, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff098c0000, 1037618710924) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff098c0001, 4) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff098c0005, 585) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff098c6003, err) }
        vm.assertGtDecimal(left, right, decimals, err);
    }

    function assertGt(int256 left, int256 right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff095b0000, 1037618710875) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff095b0001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff095b0005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff095b6001, right) }
        vm.assertGt(left, right);
    }

    function assertGt(int256 left, int256 right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff095c0000, 1037618710876) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff095c0001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff095c0005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff095c6002, err) }
        vm.assertGt(left, right, err);
    }

    function assertGtDecimal(int256 left, int256 right, uint256 decimals) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff095d0000, 1037618710877) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff095d0001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff095d0005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff095d6002, decimals) }
        vm.assertGtDecimal(left, right, decimals);
    }

    function assertGtDecimal(int256 left, int256 right, uint256 decimals, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff095e0000, 1037618710878) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff095e0001, 4) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff095e0005, 585) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff095e6003, err) }
        vm.assertGtDecimal(left, right, decimals, err);
    }

    function assertLe(uint256 left, uint256 right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff095f0000, 1037618710879) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff095f0001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff095f0005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff095f6001, right) }
        vm.assertLe(left, right);
    }

    function assertLe(uint256 left, uint256 right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09600000, 1037618710880) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09600001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09600005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09606002, err) }
        vm.assertLe(left, right, err);
    }

    function assertLeDecimal(uint256 left, uint256 right, uint256 decimals) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09610000, 1037618710881) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09610001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09610005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09616002, decimals) }
        vm.assertLeDecimal(left, right, decimals);
    }

    function assertLeDecimal(uint256 left, uint256 right, uint256 decimals, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09620000, 1037618710882) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09620001, 4) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09620005, 585) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09626003, err) }
        vm.assertLeDecimal(left, right, decimals, err);
    }

    function assertLe(int256 left, int256 right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09630000, 1037618710883) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09630001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09630005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09636001, right) }
        vm.assertLe(left, right);
    }

    function assertLe(int256 left, int256 right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09640000, 1037618710884) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09640001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09640005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09646002, err) }
        vm.assertLe(left, right, err);
    }

    function assertLeDecimal(int256 left, int256 right, uint256 decimals) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09970000, 1037618710935) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09970001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09970005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09976002, decimals) }
        vm.assertLeDecimal(left, right, decimals);
    }

    function assertLeDecimal(int256 left, int256 right, uint256 decimals, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09980000, 1037618710936) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09980001, 4) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09980005, 585) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09986003, err) }
        vm.assertLeDecimal(left, right, decimals, err);
    }

    function assertGe(uint256 left, uint256 right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09990000, 1037618710937) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09990001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09990005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09996001, right) }
        vm.assertGe(left, right);
    }

    function assertGe(uint256 left, uint256 right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff099a0000, 1037618710938) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff099a0001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff099a0005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff099a6002, err) }
        vm.assertGe(left, right, err);
    }

    function assertGeDecimal(uint256 left, uint256 right, uint256 decimals) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff099b0000, 1037618710939) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff099b0001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff099b0005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff099b6002, decimals) }
        vm.assertGeDecimal(left, right, decimals);
    }

    function assertGeDecimal(uint256 left, uint256 right, uint256 decimals, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff099c0000, 1037618710940) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff099c0001, 4) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff099c0005, 585) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff099c6003, err) }
        vm.assertGeDecimal(left, right, decimals, err);
    }

    function assertGe(int256 left, int256 right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff099d0000, 1037618710941) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff099d0001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff099d0005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff099d6001, right) }
        vm.assertGe(left, right);
    }

    function assertGe(int256 left, int256 right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff099e0000, 1037618710942) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff099e0001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff099e0005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff099e6002, err) }
        vm.assertGe(left, right, err);
    }

    function assertGeDecimal(int256 left, int256 right, uint256 decimals) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff099f0000, 1037618710943) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff099f0001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff099f0005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff099f6002, decimals) }
        vm.assertGeDecimal(left, right, decimals);
    }

    function assertGeDecimal(int256 left, int256 right, uint256 decimals, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09a00000, 1037618710944) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09a00001, 4) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09a00005, 585) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09a06003, err) }
        vm.assertGeDecimal(left, right, decimals, err);
    }

    function assertApproxEqAbs(uint256 left, uint256 right, uint256 maxDelta) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09490000, 1037618710857) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09490001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09490005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09496002, maxDelta) }
        vm.assertApproxEqAbs(left, right, maxDelta);
    }

    function assertApproxEqAbs(uint256 left, uint256 right, uint256 maxDelta, string memory err)
        internal
        pure
        virtual
    {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff094a0000, 1037618710858) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff094a0001, 4) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff094a0005, 585) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff094a6003, err) }
        vm.assertApproxEqAbs(left, right, maxDelta, err);
    }

    function assertApproxEqAbsDecimal(uint256 left, uint256 right, uint256 maxDelta, uint256 decimals)
        internal
        pure
        virtual
    {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff094b0000, 1037618710859) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff094b0001, 4) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff094b0005, 585) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff094b6003, decimals) }
        vm.assertApproxEqAbsDecimal(left, right, maxDelta, decimals);
    }

    function assertApproxEqAbsDecimal(
        uint256 left,
        uint256 right,
        uint256 maxDelta,
        uint256 decimals,
        string memory err
    ) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff094c0000, 1037618710860) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff094c0001, 5) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff094c0005, 4681) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff094c6004, err) }
        vm.assertApproxEqAbsDecimal(left, right, maxDelta, decimals, err);
    }

    function assertApproxEqAbs(int256 left, int256 right, uint256 maxDelta) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff094d0000, 1037618710861) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff094d0001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff094d0005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff094d6002, maxDelta) }
        vm.assertApproxEqAbs(left, right, maxDelta);
    }

    function assertApproxEqAbs(int256 left, int256 right, uint256 maxDelta, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff094e0000, 1037618710862) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff094e0001, 4) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff094e0005, 585) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff094e6003, err) }
        vm.assertApproxEqAbs(left, right, maxDelta, err);
    }

    function assertApproxEqAbsDecimal(int256 left, int256 right, uint256 maxDelta, uint256 decimals)
        internal
        pure
        virtual
    {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff094f0000, 1037618710863) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff094f0001, 4) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff094f0005, 585) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff094f6003, decimals) }
        vm.assertApproxEqAbsDecimal(left, right, maxDelta, decimals);
    }

    function assertApproxEqAbsDecimal(int256 left, int256 right, uint256 maxDelta, uint256 decimals, string memory err)
        internal
        pure
        virtual
    {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09500000, 1037618710864) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09500001, 5) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09500005, 4681) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09506004, err) }
        vm.assertApproxEqAbsDecimal(left, right, maxDelta, decimals, err);
    }

    function assertApproxEqRel(
        uint256 left,
        uint256 right,
        uint256 maxPercentDelta // An 18 decimal fixed point number, where 1e18 == 100%
    ) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09650000, 1037618710885) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09650001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09650005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09656002, maxPercentDelta) }
        vm.assertApproxEqRel(left, right, maxPercentDelta);
    }

    function assertApproxEqRel(
        uint256 left,
        uint256 right,
        uint256 maxPercentDelta, // An 18 decimal fixed point number, where 1e18 == 100%
        string memory err
    ) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09660000, 1037618710886) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09660001, 4) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09660005, 585) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09666003, err) }
        vm.assertApproxEqRel(left, right, maxPercentDelta, err);
    }

    function assertApproxEqRelDecimal(
        uint256 left,
        uint256 right,
        uint256 maxPercentDelta, // An 18 decimal fixed point number, where 1e18 == 100%
        uint256 decimals
    ) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09670000, 1037618710887) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09670001, 4) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09670005, 585) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09676003, decimals) }
        vm.assertApproxEqRelDecimal(left, right, maxPercentDelta, decimals);
    }

    function assertApproxEqRelDecimal(
        uint256 left,
        uint256 right,
        uint256 maxPercentDelta, // An 18 decimal fixed point number, where 1e18 == 100%
        uint256 decimals,
        string memory err
    ) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09680000, 1037618710888) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09680001, 5) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09680005, 4681) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09686004, err) }
        vm.assertApproxEqRelDecimal(left, right, maxPercentDelta, decimals, err);
    }

    function assertApproxEqRel(int256 left, int256 right, uint256 maxPercentDelta) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09690000, 1037618710889) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09690001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09690005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09696002, maxPercentDelta) }
        vm.assertApproxEqRel(left, right, maxPercentDelta);
    }

    function assertApproxEqRel(
        int256 left,
        int256 right,
        uint256 maxPercentDelta, // An 18 decimal fixed point number, where 1e18 == 100%
        string memory err
    ) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff096a0000, 1037618710890) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff096a0001, 4) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff096a0005, 585) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff096a6003, err) }
        vm.assertApproxEqRel(left, right, maxPercentDelta, err);
    }

    function assertApproxEqRelDecimal(
        int256 left,
        int256 right,
        uint256 maxPercentDelta, // An 18 decimal fixed point number, where 1e18 == 100%
        uint256 decimals
    ) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff096b0000, 1037618710891) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff096b0001, 4) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff096b0005, 585) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff096b6003, decimals) }
        vm.assertApproxEqRelDecimal(left, right, maxPercentDelta, decimals);
    }

    function assertApproxEqRelDecimal(
        int256 left,
        int256 right,
        uint256 maxPercentDelta, // An 18 decimal fixed point number, where 1e18 == 100%
        uint256 decimals,
        string memory err
    ) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff096c0000, 1037618710892) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff096c0001, 5) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff096c0005, 4681) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff096c6004, err) }
        vm.assertApproxEqRelDecimal(left, right, maxPercentDelta, decimals, err);
    }

    // Inherited from DSTest, not used but kept for backwards-compatibility
    function checkEq0(bytes memory left, bytes memory right) internal pure returns (bool) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff096d0000, 1037618710893) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff096d0001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff096d0005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff096d6001, right) }
        return keccak256(left) == keccak256(right);
    }

    function assertEq0(bytes memory left, bytes memory right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff096e0000, 1037618710894) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff096e0001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff096e0005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff096e6001, right) }
        assertEq(left, right);
    }

    function assertEq0(bytes memory left, bytes memory right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09420000, 1037618710850) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09420001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09420005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09426002, err) }
        assertEq(left, right, err);
    }

    function assertNotEq0(bytes memory left, bytes memory right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09430000, 1037618710851) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09430001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09430005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09436001, right) }
        assertNotEq(left, right);
    }

    function assertNotEq0(bytes memory left, bytes memory right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09440000, 1037618710852) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09440001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09440005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09446002, err) }
        assertNotEq(left, right, err);
    }

    function assertEqCall(address target, bytes memory callDataA, bytes memory callDataB) internal virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09450000, 1037618710853) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09450001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09450005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09456002, callDataB) }
        assertEqCall(target, callDataA, target, callDataB, true);
    }

    function assertEqCall(address targetA, bytes memory callDataA, address targetB, bytes memory callDataB)
        internal
        virtual
    {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09460000, 1037618710854) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09460001, 4) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09460005, 585) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09466003, callDataB) }
        assertEqCall(targetA, callDataA, targetB, callDataB, true);
    }

    function assertEqCall(address target, bytes memory callDataA, bytes memory callDataB, bool strictRevertData)
        internal
        virtual
    {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09470000, 1037618710855) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09470001, 4) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09470005, 585) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09476003, strictRevertData) }
        assertEqCall(target, callDataA, target, callDataB, strictRevertData);
    }

    function assertEqCall(
        address targetA,
        bytes memory callDataA,
        address targetB,
        bytes memory callDataB,
        bool strictRevertData
    ) internal virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09480000, 1037618710856) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09480001, 5) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09480005, 4681) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09486004, strictRevertData) }
        (bool successA, bytes memory returnDataA) = address(targetA).call(callDataA);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0001000c,0)}
        (bool successB, bytes memory returnDataB) = address(targetB).call(callDataB);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0001000d,0)}

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
