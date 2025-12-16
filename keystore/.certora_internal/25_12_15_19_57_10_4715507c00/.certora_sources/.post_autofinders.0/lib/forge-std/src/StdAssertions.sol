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

    function failed() public view returns (bool) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00290000, 1037618708521) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00290001, 0) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00290004, 0) }
        if (_failed) {
            return _failed;
        } else {
            return vm.load(address(vm), bytes32("failed")) != bytes32(0);
        }
    }

    function fail() internal virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff006e0000, 1037618708590) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff006e0001, 0) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff006e0004, 0) }
        vm.store(address(vm), bytes32("failed"), bytes32(uint256(1)));
        _failed = true;
    }

    function assertTrue(bool data) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff006f0000, 1037618708591) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff006f0001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff006f0005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff006f6000, data) }
        vm.assertTrue(data);
    }

    function assertTrue(bool data, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00710000, 1037618708593) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00710001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00710005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00716001, err) }
        vm.assertTrue(data, err);
    }

    function assertFalse(bool data) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00720000, 1037618708594) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00720001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00720005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00726000, data) }
        vm.assertFalse(data);
    }

    function assertFalse(bool data, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00700000, 1037618708592) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00700001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00700005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00706001, err) }
        vm.assertFalse(data, err);
    }

    function assertEq(bool left, bool right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00730000, 1037618708595) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00730001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00730005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00736001, right) }
        vm.assertEq(left, right);
    }

    function assertEq(bool left, bool right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00740000, 1037618708596) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00740001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00740005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00746002, err) }
        vm.assertEq(left, right, err);
    }

    function assertEq(uint256 left, uint256 right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00750000, 1037618708597) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00750001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00750005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00756001, right) }
        vm.assertEq(left, right);
    }

    function assertEq(uint256 left, uint256 right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00760000, 1037618708598) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00760001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00760005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00766002, err) }
        vm.assertEq(left, right, err);
    }

    function assertEqDecimal(uint256 left, uint256 right, uint256 decimals) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00770000, 1037618708599) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00770001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00770005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00776002, decimals) }
        vm.assertEqDecimal(left, right, decimals);
    }

    function assertEqDecimal(uint256 left, uint256 right, uint256 decimals, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00780000, 1037618708600) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00780001, 4) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00780005, 585) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00786003, err) }
        vm.assertEqDecimal(left, right, decimals, err);
    }

    function assertEq(int256 left, int256 right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00790000, 1037618708601) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00790001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00790005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00796001, right) }
        vm.assertEq(left, right);
    }

    function assertEq(int256 left, int256 right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff007a0000, 1037618708602) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff007a0001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff007a0005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff007a6002, err) }
        vm.assertEq(left, right, err);
    }

    function assertEqDecimal(int256 left, int256 right, uint256 decimals) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff007b0000, 1037618708603) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff007b0001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff007b0005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff007b6002, decimals) }
        vm.assertEqDecimal(left, right, decimals);
    }

    function assertEqDecimal(int256 left, int256 right, uint256 decimals, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff007c0000, 1037618708604) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff007c0001, 4) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff007c0005, 585) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff007c6003, err) }
        vm.assertEqDecimal(left, right, decimals, err);
    }

    function assertEq(address left, address right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff007d0000, 1037618708605) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff007d0001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff007d0005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff007d6001, right) }
        vm.assertEq(left, right);
    }

    function assertEq(address left, address right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00a30000, 1037618708643) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00a30001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00a30005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00a36002, err) }
        vm.assertEq(left, right, err);
    }

    function assertEq(bytes32 left, bytes32 right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00a20000, 1037618708642) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00a20001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00a20005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00a26001, right) }
        vm.assertEq(left, right);
    }

    function assertEq(bytes32 left, bytes32 right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00a10000, 1037618708641) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00a10001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00a10005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00a16002, err) }
        vm.assertEq(left, right, err);
    }

    function assertEq32(bytes32 left, bytes32 right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00a40000, 1037618708644) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00a40001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00a40005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00a46001, right) }
        assertEq(left, right);
    }

    function assertEq32(bytes32 left, bytes32 right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00a50000, 1037618708645) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00a50001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00a50005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00a56002, err) }
        assertEq(left, right, err);
    }

    function assertEq(string memory left, string memory right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00a60000, 1037618708646) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00a60001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00a60005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00a66001, right) }
        vm.assertEq(left, right);
    }

    function assertEq(string memory left, string memory right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00a70000, 1037618708647) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00a70001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00a70005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00a76002, err) }
        vm.assertEq(left, right, err);
    }

    function assertEq(bytes memory left, bytes memory right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00a80000, 1037618708648) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00a80001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00a80005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00a86001, right) }
        vm.assertEq(left, right);
    }

    function assertEq(bytes memory left, bytes memory right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00a90000, 1037618708649) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00a90001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00a90005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00a96002, err) }
        vm.assertEq(left, right, err);
    }

    function assertEq(bool[] memory left, bool[] memory right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00aa0000, 1037618708650) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00aa0001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00aa0005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00aa6001, right) }
        vm.assertEq(left, right);
    }

    function assertEq(bool[] memory left, bool[] memory right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00850000, 1037618708613) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00850001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00850005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00856002, err) }
        vm.assertEq(left, right, err);
    }

    function assertEq(uint256[] memory left, uint256[] memory right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00860000, 1037618708614) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00860001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00860005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00866001, right) }
        vm.assertEq(left, right);
    }

    function assertEq(uint256[] memory left, uint256[] memory right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00870000, 1037618708615) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00870001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00870005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00876002, err) }
        vm.assertEq(left, right, err);
    }

    function assertEq(int256[] memory left, int256[] memory right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff007e0000, 1037618708606) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff007e0001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff007e0005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff007e6001, right) }
        vm.assertEq(left, right);
    }

    function assertEq(int256[] memory left, int256[] memory right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff007f0000, 1037618708607) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff007f0001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff007f0005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff007f6002, err) }
        vm.assertEq(left, right, err);
    }

    function assertEq(address[] memory left, address[] memory right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00800000, 1037618708608) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00800001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00800005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00806001, right) }
        vm.assertEq(left, right);
    }

    function assertEq(address[] memory left, address[] memory right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00810000, 1037618708609) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00810001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00810005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00816002, err) }
        vm.assertEq(left, right, err);
    }

    function assertEq(bytes32[] memory left, bytes32[] memory right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00820000, 1037618708610) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00820001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00820005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00826001, right) }
        vm.assertEq(left, right);
    }

    function assertEq(bytes32[] memory left, bytes32[] memory right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00830000, 1037618708611) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00830001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00830005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00836002, err) }
        vm.assertEq(left, right, err);
    }

    function assertEq(string[] memory left, string[] memory right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00840000, 1037618708612) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00840001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00840005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00846001, right) }
        vm.assertEq(left, right);
    }

    function assertEq(string[] memory left, string[] memory right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00ca0000, 1037618708682) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00ca0001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00ca0005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00ca6002, err) }
        vm.assertEq(left, right, err);
    }

    function assertEq(bytes[] memory left, bytes[] memory right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00cb0000, 1037618708683) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00cb0001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00cb0005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00cb6001, right) }
        vm.assertEq(left, right);
    }

    function assertEq(bytes[] memory left, bytes[] memory right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00cc0000, 1037618708684) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00cc0001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00cc0005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00cc6002, err) }
        vm.assertEq(left, right, err);
    }

    // Legacy helper
    function assertEqUint(uint256 left, uint256 right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00cd0000, 1037618708685) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00cd0001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00cd0005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00cd6001, right) }
        assertEq(left, right);
    }

    function assertNotEq(bool left, bool right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00ce0000, 1037618708686) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00ce0001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00ce0005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00ce6001, right) }
        vm.assertNotEq(left, right);
    }

    function assertNotEq(bool left, bool right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00cf0000, 1037618708687) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00cf0001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00cf0005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00cf6002, err) }
        vm.assertNotEq(left, right, err);
    }

    function assertNotEq(uint256 left, uint256 right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00d00000, 1037618708688) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00d00001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00d00005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00d06001, right) }
        vm.assertNotEq(left, right);
    }

    function assertNotEq(uint256 left, uint256 right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00d10000, 1037618708689) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00d10001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00d10005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00d16002, err) }
        vm.assertNotEq(left, right, err);
    }

    function assertNotEqDecimal(uint256 left, uint256 right, uint256 decimals) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00d20000, 1037618708690) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00d20001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00d20005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00d26002, decimals) }
        vm.assertNotEqDecimal(left, right, decimals);
    }

    function assertNotEqDecimal(uint256 left, uint256 right, uint256 decimals, string memory err)
        internal
        pure
        virtual
    {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00880000, 1037618708616) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00880001, 4) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00880005, 585) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00886003, err) }
        vm.assertNotEqDecimal(left, right, decimals, err);
    }

    function assertNotEq(int256 left, int256 right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00890000, 1037618708617) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00890001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00890005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00896001, right) }
        vm.assertNotEq(left, right);
    }

    function assertNotEq(int256 left, int256 right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff008a0000, 1037618708618) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff008a0001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff008a0005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff008a6002, err) }
        vm.assertNotEq(left, right, err);
    }

    function assertNotEqDecimal(int256 left, int256 right, uint256 decimals) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff008b0000, 1037618708619) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff008b0001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff008b0005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff008b6002, decimals) }
        vm.assertNotEqDecimal(left, right, decimals);
    }

    function assertNotEqDecimal(int256 left, int256 right, uint256 decimals, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff008c0000, 1037618708620) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff008c0001, 4) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff008c0005, 585) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff008c6003, err) }
        vm.assertNotEqDecimal(left, right, decimals, err);
    }

    function assertNotEq(address left, address right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff008d0000, 1037618708621) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff008d0001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff008d0005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff008d6001, right) }
        vm.assertNotEq(left, right);
    }

    function assertNotEq(address left, address right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff008e0000, 1037618708622) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff008e0001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff008e0005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff008e6002, err) }
        vm.assertNotEq(left, right, err);
    }

    function assertNotEq(bytes32 left, bytes32 right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff008f0000, 1037618708623) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff008f0001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff008f0005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff008f6001, right) }
        vm.assertNotEq(left, right);
    }

    function assertNotEq(bytes32 left, bytes32 right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00900000, 1037618708624) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00900001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00900005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00906002, err) }
        vm.assertNotEq(left, right, err);
    }

    function assertNotEq32(bytes32 left, bytes32 right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00910000, 1037618708625) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00910001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00910005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00916001, right) }
        assertNotEq(left, right);
    }

    function assertNotEq32(bytes32 left, bytes32 right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00d30000, 1037618708691) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00d30001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00d30005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00d36002, err) }
        assertNotEq(left, right, err);
    }

    function assertNotEq(string memory left, string memory right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00dd0000, 1037618708701) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00dd0001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00dd0005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00dd6001, right) }
        vm.assertNotEq(left, right);
    }

    function assertNotEq(string memory left, string memory right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00de0000, 1037618708702) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00de0001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00de0005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00de6002, err) }
        vm.assertNotEq(left, right, err);
    }

    function assertNotEq(bytes memory left, bytes memory right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00df0000, 1037618708703) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00df0001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00df0005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00df6001, right) }
        vm.assertNotEq(left, right);
    }

    function assertNotEq(bytes memory left, bytes memory right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00e00000, 1037618708704) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00e00001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00e00005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00e06002, err) }
        vm.assertNotEq(left, right, err);
    }

    function assertNotEq(bool[] memory left, bool[] memory right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00e10000, 1037618708705) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00e10001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00e10005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00e16001, right) }
        vm.assertNotEq(left, right);
    }

    function assertNotEq(bool[] memory left, bool[] memory right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00e20000, 1037618708706) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00e20001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00e20005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00e26002, err) }
        vm.assertNotEq(left, right, err);
    }

    function assertNotEq(uint256[] memory left, uint256[] memory right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00e30000, 1037618708707) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00e30001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00e30005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00e36001, right) }
        vm.assertNotEq(left, right);
    }

    function assertNotEq(uint256[] memory left, uint256[] memory right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00e40000, 1037618708708) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00e40001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00e40005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00e46002, err) }
        vm.assertNotEq(left, right, err);
    }

    function assertNotEq(int256[] memory left, int256[] memory right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00e50000, 1037618708709) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00e50001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00e50005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00e56001, right) }
        vm.assertNotEq(left, right);
    }

    function assertNotEq(int256[] memory left, int256[] memory right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00e60000, 1037618708710) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00e60001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00e60005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00e66002, err) }
        vm.assertNotEq(left, right, err);
    }

    function assertNotEq(address[] memory left, address[] memory right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00c60000, 1037618708678) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00c60001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00c60005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00c66001, right) }
        vm.assertNotEq(left, right);
    }

    function assertNotEq(address[] memory left, address[] memory right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00c70000, 1037618708679) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00c70001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00c70005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00c76002, err) }
        vm.assertNotEq(left, right, err);
    }

    function assertNotEq(bytes32[] memory left, bytes32[] memory right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00c80000, 1037618708680) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00c80001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00c80005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00c86001, right) }
        vm.assertNotEq(left, right);
    }

    function assertNotEq(bytes32[] memory left, bytes32[] memory right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00c90000, 1037618708681) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00c90001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00c90005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00c96002, err) }
        vm.assertNotEq(left, right, err);
    }

    function assertNotEq(string[] memory left, string[] memory right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00bf0000, 1037618708671) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00bf0001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00bf0005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00bf6001, right) }
        vm.assertNotEq(left, right);
    }

    function assertNotEq(string[] memory left, string[] memory right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00c00000, 1037618708672) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00c00001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00c00005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00c06002, err) }
        vm.assertNotEq(left, right, err);
    }

    function assertNotEq(bytes[] memory left, bytes[] memory right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00c10000, 1037618708673) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00c10001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00c10005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00c16001, right) }
        vm.assertNotEq(left, right);
    }

    function assertNotEq(bytes[] memory left, bytes[] memory right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00c20000, 1037618708674) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00c20001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00c20005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00c26002, err) }
        vm.assertNotEq(left, right, err);
    }

    function assertLt(uint256 left, uint256 right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00c30000, 1037618708675) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00c30001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00c30005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00c36001, right) }
        vm.assertLt(left, right);
    }

    function assertLt(uint256 left, uint256 right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00c40000, 1037618708676) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00c40001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00c40005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00c46002, err) }
        vm.assertLt(left, right, err);
    }

    function assertLtDecimal(uint256 left, uint256 right, uint256 decimals) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00c50000, 1037618708677) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00c50001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00c50005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00c56002, decimals) }
        vm.assertLtDecimal(left, right, decimals);
    }

    function assertLtDecimal(uint256 left, uint256 right, uint256 decimals, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00d40000, 1037618708692) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00d40001, 4) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00d40005, 585) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00d46003, err) }
        vm.assertLtDecimal(left, right, decimals, err);
    }

    function assertLt(int256 left, int256 right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00d50000, 1037618708693) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00d50001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00d50005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00d56001, right) }
        vm.assertLt(left, right);
    }

    function assertLt(int256 left, int256 right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00d60000, 1037618708694) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00d60001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00d60005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00d66002, err) }
        vm.assertLt(left, right, err);
    }

    function assertLtDecimal(int256 left, int256 right, uint256 decimals) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00d70000, 1037618708695) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00d70001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00d70005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00d76002, decimals) }
        vm.assertLtDecimal(left, right, decimals);
    }

    function assertLtDecimal(int256 left, int256 right, uint256 decimals, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00d80000, 1037618708696) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00d80001, 4) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00d80005, 585) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00d86003, err) }
        vm.assertLtDecimal(left, right, decimals, err);
    }

    function assertGt(uint256 left, uint256 right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00d90000, 1037618708697) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00d90001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00d90005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00d96001, right) }
        vm.assertGt(left, right);
    }

    function assertGt(uint256 left, uint256 right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00da0000, 1037618708698) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00da0001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00da0005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00da6002, err) }
        vm.assertGt(left, right, err);
    }

    function assertGtDecimal(uint256 left, uint256 right, uint256 decimals) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00db0000, 1037618708699) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00db0001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00db0005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00db6002, decimals) }
        vm.assertGtDecimal(left, right, decimals);
    }

    function assertGtDecimal(uint256 left, uint256 right, uint256 decimals, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00dc0000, 1037618708700) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00dc0001, 4) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00dc0005, 585) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00dc6003, err) }
        vm.assertGtDecimal(left, right, decimals, err);
    }

    function assertGt(int256 left, int256 right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00ab0000, 1037618708651) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00ab0001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00ab0005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00ab6001, right) }
        vm.assertGt(left, right);
    }

    function assertGt(int256 left, int256 right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00ac0000, 1037618708652) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00ac0001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00ac0005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00ac6002, err) }
        vm.assertGt(left, right, err);
    }

    function assertGtDecimal(int256 left, int256 right, uint256 decimals) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00ad0000, 1037618708653) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00ad0001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00ad0005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00ad6002, decimals) }
        vm.assertGtDecimal(left, right, decimals);
    }

    function assertGtDecimal(int256 left, int256 right, uint256 decimals, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00ae0000, 1037618708654) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00ae0001, 4) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00ae0005, 585) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00ae6003, err) }
        vm.assertGtDecimal(left, right, decimals, err);
    }

    function assertLe(uint256 left, uint256 right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00af0000, 1037618708655) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00af0001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00af0005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00af6001, right) }
        vm.assertLe(left, right);
    }

    function assertLe(uint256 left, uint256 right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00b00000, 1037618708656) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00b00001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00b00005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00b06002, err) }
        vm.assertLe(left, right, err);
    }

    function assertLeDecimal(uint256 left, uint256 right, uint256 decimals) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00b10000, 1037618708657) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00b10001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00b10005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00b16002, decimals) }
        vm.assertLeDecimal(left, right, decimals);
    }

    function assertLeDecimal(uint256 left, uint256 right, uint256 decimals, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00b20000, 1037618708658) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00b20001, 4) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00b20005, 585) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00b26003, err) }
        vm.assertLeDecimal(left, right, decimals, err);
    }

    function assertLe(int256 left, int256 right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00b30000, 1037618708659) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00b30001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00b30005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00b36001, right) }
        vm.assertLe(left, right);
    }

    function assertLe(int256 left, int256 right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00b40000, 1037618708660) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00b40001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00b40005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00b46002, err) }
        vm.assertLe(left, right, err);
    }

    function assertLeDecimal(int256 left, int256 right, uint256 decimals) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00e70000, 1037618708711) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00e70001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00e70005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00e76002, decimals) }
        vm.assertLeDecimal(left, right, decimals);
    }

    function assertLeDecimal(int256 left, int256 right, uint256 decimals, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00e80000, 1037618708712) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00e80001, 4) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00e80005, 585) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00e86003, err) }
        vm.assertLeDecimal(left, right, decimals, err);
    }

    function assertGe(uint256 left, uint256 right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00e90000, 1037618708713) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00e90001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00e90005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00e96001, right) }
        vm.assertGe(left, right);
    }

    function assertGe(uint256 left, uint256 right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00ea0000, 1037618708714) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00ea0001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00ea0005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00ea6002, err) }
        vm.assertGe(left, right, err);
    }

    function assertGeDecimal(uint256 left, uint256 right, uint256 decimals) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00eb0000, 1037618708715) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00eb0001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00eb0005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00eb6002, decimals) }
        vm.assertGeDecimal(left, right, decimals);
    }

    function assertGeDecimal(uint256 left, uint256 right, uint256 decimals, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00ec0000, 1037618708716) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00ec0001, 4) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00ec0005, 585) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00ec6003, err) }
        vm.assertGeDecimal(left, right, decimals, err);
    }

    function assertGe(int256 left, int256 right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00ed0000, 1037618708717) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00ed0001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00ed0005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00ed6001, right) }
        vm.assertGe(left, right);
    }

    function assertGe(int256 left, int256 right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00ee0000, 1037618708718) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00ee0001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00ee0005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00ee6002, err) }
        vm.assertGe(left, right, err);
    }

    function assertGeDecimal(int256 left, int256 right, uint256 decimals) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00ef0000, 1037618708719) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00ef0001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00ef0005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00ef6002, decimals) }
        vm.assertGeDecimal(left, right, decimals);
    }

    function assertGeDecimal(int256 left, int256 right, uint256 decimals, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00f00000, 1037618708720) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00f00001, 4) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00f00005, 585) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00f06003, err) }
        vm.assertGeDecimal(left, right, decimals, err);
    }

    function assertApproxEqAbs(uint256 left, uint256 right, uint256 maxDelta) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00990000, 1037618708633) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00990001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00990005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00996002, maxDelta) }
        vm.assertApproxEqAbs(left, right, maxDelta);
    }

    function assertApproxEqAbs(uint256 left, uint256 right, uint256 maxDelta, string memory err)
        internal
        pure
        virtual
    {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff009a0000, 1037618708634) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff009a0001, 4) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff009a0005, 585) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff009a6003, err) }
        vm.assertApproxEqAbs(left, right, maxDelta, err);
    }

    function assertApproxEqAbsDecimal(uint256 left, uint256 right, uint256 maxDelta, uint256 decimals)
        internal
        pure
        virtual
    {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff009b0000, 1037618708635) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff009b0001, 4) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff009b0005, 585) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff009b6003, decimals) }
        vm.assertApproxEqAbsDecimal(left, right, maxDelta, decimals);
    }

    function assertApproxEqAbsDecimal(
        uint256 left,
        uint256 right,
        uint256 maxDelta,
        uint256 decimals,
        string memory err
    ) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff009c0000, 1037618708636) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff009c0001, 5) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff009c0005, 4681) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff009c6004, err) }
        vm.assertApproxEqAbsDecimal(left, right, maxDelta, decimals, err);
    }

    function assertApproxEqAbs(int256 left, int256 right, uint256 maxDelta) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff009d0000, 1037618708637) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff009d0001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff009d0005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff009d6002, maxDelta) }
        vm.assertApproxEqAbs(left, right, maxDelta);
    }

    function assertApproxEqAbs(int256 left, int256 right, uint256 maxDelta, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff009e0000, 1037618708638) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff009e0001, 4) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff009e0005, 585) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff009e6003, err) }
        vm.assertApproxEqAbs(left, right, maxDelta, err);
    }

    function assertApproxEqAbsDecimal(int256 left, int256 right, uint256 maxDelta, uint256 decimals)
        internal
        pure
        virtual
    {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff009f0000, 1037618708639) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff009f0001, 4) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff009f0005, 585) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff009f6003, decimals) }
        vm.assertApproxEqAbsDecimal(left, right, maxDelta, decimals);
    }

    function assertApproxEqAbsDecimal(int256 left, int256 right, uint256 maxDelta, uint256 decimals, string memory err)
        internal
        pure
        virtual
    {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00a00000, 1037618708640) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00a00001, 5) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00a00005, 4681) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00a06004, err) }
        vm.assertApproxEqAbsDecimal(left, right, maxDelta, decimals, err);
    }

    function assertApproxEqRel(
        uint256 left,
        uint256 right,
        uint256 maxPercentDelta // An 18 decimal fixed point number, where 1e18 == 100%
    ) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00b50000, 1037618708661) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00b50001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00b50005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00b56002, maxPercentDelta) }
        vm.assertApproxEqRel(left, right, maxPercentDelta);
    }

    function assertApproxEqRel(
        uint256 left,
        uint256 right,
        uint256 maxPercentDelta, // An 18 decimal fixed point number, where 1e18 == 100%
        string memory err
    ) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00b60000, 1037618708662) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00b60001, 4) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00b60005, 585) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00b66003, err) }
        vm.assertApproxEqRel(left, right, maxPercentDelta, err);
    }

    function assertApproxEqRelDecimal(
        uint256 left,
        uint256 right,
        uint256 maxPercentDelta, // An 18 decimal fixed point number, where 1e18 == 100%
        uint256 decimals
    ) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00b70000, 1037618708663) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00b70001, 4) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00b70005, 585) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00b76003, decimals) }
        vm.assertApproxEqRelDecimal(left, right, maxPercentDelta, decimals);
    }

    function assertApproxEqRelDecimal(
        uint256 left,
        uint256 right,
        uint256 maxPercentDelta, // An 18 decimal fixed point number, where 1e18 == 100%
        uint256 decimals,
        string memory err
    ) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00b80000, 1037618708664) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00b80001, 5) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00b80005, 4681) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00b86004, err) }
        vm.assertApproxEqRelDecimal(left, right, maxPercentDelta, decimals, err);
    }

    function assertApproxEqRel(int256 left, int256 right, uint256 maxPercentDelta) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00b90000, 1037618708665) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00b90001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00b90005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00b96002, maxPercentDelta) }
        vm.assertApproxEqRel(left, right, maxPercentDelta);
    }

    function assertApproxEqRel(
        int256 left,
        int256 right,
        uint256 maxPercentDelta, // An 18 decimal fixed point number, where 1e18 == 100%
        string memory err
    ) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00ba0000, 1037618708666) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00ba0001, 4) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00ba0005, 585) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00ba6003, err) }
        vm.assertApproxEqRel(left, right, maxPercentDelta, err);
    }

    function assertApproxEqRelDecimal(
        int256 left,
        int256 right,
        uint256 maxPercentDelta, // An 18 decimal fixed point number, where 1e18 == 100%
        uint256 decimals
    ) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00bb0000, 1037618708667) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00bb0001, 4) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00bb0005, 585) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00bb6003, decimals) }
        vm.assertApproxEqRelDecimal(left, right, maxPercentDelta, decimals);
    }

    function assertApproxEqRelDecimal(
        int256 left,
        int256 right,
        uint256 maxPercentDelta, // An 18 decimal fixed point number, where 1e18 == 100%
        uint256 decimals,
        string memory err
    ) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00bc0000, 1037618708668) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00bc0001, 5) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00bc0005, 4681) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00bc6004, err) }
        vm.assertApproxEqRelDecimal(left, right, maxPercentDelta, decimals, err);
    }

    // Inherited from DSTest, not used but kept for backwards-compatibility
    function checkEq0(bytes memory left, bytes memory right) internal pure returns (bool) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00bd0000, 1037618708669) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00bd0001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00bd0005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00bd6001, right) }
        return keccak256(left) == keccak256(right);
    }

    function assertEq0(bytes memory left, bytes memory right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00be0000, 1037618708670) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00be0001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00be0005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00be6001, right) }
        assertEq(left, right);
    }

    function assertEq0(bytes memory left, bytes memory right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00920000, 1037618708626) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00920001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00920005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00926002, err) }
        assertEq(left, right, err);
    }

    function assertNotEq0(bytes memory left, bytes memory right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00930000, 1037618708627) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00930001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00930005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00936001, right) }
        assertNotEq(left, right);
    }

    function assertNotEq0(bytes memory left, bytes memory right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00940000, 1037618708628) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00940001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00940005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00946002, err) }
        assertNotEq(left, right, err);
    }

    function assertEqCall(address target, bytes memory callDataA, bytes memory callDataB) internal virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00950000, 1037618708629) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00950001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00950005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00956002, callDataB) }
        assertEqCall(target, callDataA, target, callDataB, true);
    }

    function assertEqCall(address targetA, bytes memory callDataA, address targetB, bytes memory callDataB)
        internal
        virtual
    {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00960000, 1037618708630) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00960001, 4) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00960005, 585) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00966003, callDataB) }
        assertEqCall(targetA, callDataA, targetB, callDataB, true);
    }

    function assertEqCall(address target, bytes memory callDataA, bytes memory callDataB, bool strictRevertData)
        internal
        virtual
    {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00970000, 1037618708631) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00970001, 4) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00970005, 585) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00976003, strictRevertData) }
        assertEqCall(target, callDataA, target, callDataB, strictRevertData);
    }

    function assertEqCall(
        address targetA,
        bytes memory callDataA,
        address targetB,
        bytes memory callDataB,
        bool strictRevertData
    ) internal virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00980000, 1037618708632) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00980001, 5) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00980005, 4681) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00986004, strictRevertData) }
        (bool successA, bytes memory returnDataA) = address(targetA).call(callDataA);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0001009e,0)}
        (bool successB, bytes memory returnDataB) = address(targetB).call(callDataB);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0001009f,0)}

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
