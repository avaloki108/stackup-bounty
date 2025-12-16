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

    function failed() public view returns (bool) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07a90000, 1037618710441) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07a90001, 0) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07a90004, 0) }
        if (_failed) {
            return _failed;
        } else {
            return vm.load(address(vm), bytes32("failed")) != bytes32(0);
        }
    }

    function fail() internal virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07b00000, 1037618710448) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07b00001, 0) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07b00004, 0) }
        vm.store(address(vm), bytes32("failed"), bytes32(uint256(1)));
        _failed = true;
    }

    function assertTrue(bool data) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07b10000, 1037618710449) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07b10001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07b10005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07b16000, data) }
        vm.assertTrue(data);
    }

    function assertTrue(bool data, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07b30000, 1037618710451) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07b30001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07b30005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07b36001, err) }
        vm.assertTrue(data, err);
    }

    function assertFalse(bool data) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07b40000, 1037618710452) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07b40001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07b40005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07b46000, data) }
        vm.assertFalse(data);
    }

    function assertFalse(bool data, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07b20000, 1037618710450) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07b20001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07b20005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07b26001, err) }
        vm.assertFalse(data, err);
    }

    function assertEq(bool left, bool right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07b50000, 1037618710453) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07b50001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07b50005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07b56001, right) }
        vm.assertEq(left, right);
    }

    function assertEq(bool left, bool right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07b60000, 1037618710454) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07b60001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07b60005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07b66002, err) }
        vm.assertEq(left, right, err);
    }

    function assertEq(uint256 left, uint256 right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07b70000, 1037618710455) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07b70001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07b70005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07b76001, right) }
        vm.assertEq(left, right);
    }

    function assertEq(uint256 left, uint256 right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07b80000, 1037618710456) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07b80001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07b80005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07b86002, err) }
        vm.assertEq(left, right, err);
    }

    function assertEqDecimal(uint256 left, uint256 right, uint256 decimals) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07b90000, 1037618710457) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07b90001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07b90005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07b96002, decimals) }
        vm.assertEqDecimal(left, right, decimals);
    }

    function assertEqDecimal(uint256 left, uint256 right, uint256 decimals, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07ba0000, 1037618710458) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07ba0001, 4) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07ba0005, 585) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07ba6003, err) }
        vm.assertEqDecimal(left, right, decimals, err);
    }

    function assertEq(int256 left, int256 right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07bb0000, 1037618710459) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07bb0001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07bb0005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07bb6001, right) }
        vm.assertEq(left, right);
    }

    function assertEq(int256 left, int256 right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07bc0000, 1037618710460) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07bc0001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07bc0005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07bc6002, err) }
        vm.assertEq(left, right, err);
    }

    function assertEqDecimal(int256 left, int256 right, uint256 decimals) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07bd0000, 1037618710461) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07bd0001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07bd0005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07bd6002, decimals) }
        vm.assertEqDecimal(left, right, decimals);
    }

    function assertEqDecimal(int256 left, int256 right, uint256 decimals, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07be0000, 1037618710462) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07be0001, 4) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07be0005, 585) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07be6003, err) }
        vm.assertEqDecimal(left, right, decimals, err);
    }

    function assertEq(address left, address right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07bf0000, 1037618710463) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07bf0001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07bf0005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07bf6001, right) }
        vm.assertEq(left, right);
    }

    function assertEq(address left, address right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07e50000, 1037618710501) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07e50001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07e50005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07e56002, err) }
        vm.assertEq(left, right, err);
    }

    function assertEq(bytes32 left, bytes32 right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07e40000, 1037618710500) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07e40001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07e40005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07e46001, right) }
        vm.assertEq(left, right);
    }

    function assertEq(bytes32 left, bytes32 right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07e30000, 1037618710499) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07e30001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07e30005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07e36002, err) }
        vm.assertEq(left, right, err);
    }

    function assertEq32(bytes32 left, bytes32 right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07e60000, 1037618710502) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07e60001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07e60005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07e66001, right) }
        assertEq(left, right);
    }

    function assertEq32(bytes32 left, bytes32 right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07e70000, 1037618710503) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07e70001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07e70005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07e76002, err) }
        assertEq(left, right, err);
    }

    function assertEq(string memory left, string memory right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07e80000, 1037618710504) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07e80001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07e80005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07e86001, right) }
        vm.assertEq(left, right);
    }

    function assertEq(string memory left, string memory right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07e90000, 1037618710505) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07e90001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07e90005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07e96002, err) }
        vm.assertEq(left, right, err);
    }

    function assertEq(bytes memory left, bytes memory right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07ea0000, 1037618710506) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07ea0001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07ea0005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07ea6001, right) }
        vm.assertEq(left, right);
    }

    function assertEq(bytes memory left, bytes memory right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07eb0000, 1037618710507) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07eb0001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07eb0005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07eb6002, err) }
        vm.assertEq(left, right, err);
    }

    function assertEq(bool[] memory left, bool[] memory right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07ec0000, 1037618710508) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07ec0001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07ec0005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07ec6001, right) }
        vm.assertEq(left, right);
    }

    function assertEq(bool[] memory left, bool[] memory right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07c70000, 1037618710471) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07c70001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07c70005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07c76002, err) }
        vm.assertEq(left, right, err);
    }

    function assertEq(uint256[] memory left, uint256[] memory right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07c80000, 1037618710472) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07c80001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07c80005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07c86001, right) }
        vm.assertEq(left, right);
    }

    function assertEq(uint256[] memory left, uint256[] memory right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07c90000, 1037618710473) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07c90001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07c90005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07c96002, err) }
        vm.assertEq(left, right, err);
    }

    function assertEq(int256[] memory left, int256[] memory right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07c00000, 1037618710464) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07c00001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07c00005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07c06001, right) }
        vm.assertEq(left, right);
    }

    function assertEq(int256[] memory left, int256[] memory right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07c10000, 1037618710465) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07c10001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07c10005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07c16002, err) }
        vm.assertEq(left, right, err);
    }

    function assertEq(address[] memory left, address[] memory right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07c20000, 1037618710466) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07c20001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07c20005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07c26001, right) }
        vm.assertEq(left, right);
    }

    function assertEq(address[] memory left, address[] memory right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07c30000, 1037618710467) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07c30001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07c30005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07c36002, err) }
        vm.assertEq(left, right, err);
    }

    function assertEq(bytes32[] memory left, bytes32[] memory right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07c40000, 1037618710468) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07c40001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07c40005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07c46001, right) }
        vm.assertEq(left, right);
    }

    function assertEq(bytes32[] memory left, bytes32[] memory right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07c50000, 1037618710469) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07c50001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07c50005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07c56002, err) }
        vm.assertEq(left, right, err);
    }

    function assertEq(string[] memory left, string[] memory right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07c60000, 1037618710470) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07c60001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07c60005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07c66001, right) }
        vm.assertEq(left, right);
    }

    function assertEq(string[] memory left, string[] memory right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff080c0000, 1037618710540) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff080c0001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff080c0005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff080c6002, err) }
        vm.assertEq(left, right, err);
    }

    function assertEq(bytes[] memory left, bytes[] memory right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff080d0000, 1037618710541) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff080d0001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff080d0005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff080d6001, right) }
        vm.assertEq(left, right);
    }

    function assertEq(bytes[] memory left, bytes[] memory right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff080e0000, 1037618710542) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff080e0001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff080e0005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff080e6002, err) }
        vm.assertEq(left, right, err);
    }

    // Legacy helper
    function assertEqUint(uint256 left, uint256 right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff080f0000, 1037618710543) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff080f0001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff080f0005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff080f6001, right) }
        assertEq(left, right);
    }

    function assertNotEq(bool left, bool right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08100000, 1037618710544) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08100001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08100005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08106001, right) }
        vm.assertNotEq(left, right);
    }

    function assertNotEq(bool left, bool right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08110000, 1037618710545) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08110001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08110005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08116002, err) }
        vm.assertNotEq(left, right, err);
    }

    function assertNotEq(uint256 left, uint256 right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08120000, 1037618710546) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08120001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08120005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08126001, right) }
        vm.assertNotEq(left, right);
    }

    function assertNotEq(uint256 left, uint256 right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08130000, 1037618710547) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08130001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08130005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08136002, err) }
        vm.assertNotEq(left, right, err);
    }

    function assertNotEqDecimal(uint256 left, uint256 right, uint256 decimals) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08140000, 1037618710548) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08140001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08140005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08146002, decimals) }
        vm.assertNotEqDecimal(left, right, decimals);
    }

    function assertNotEqDecimal(uint256 left, uint256 right, uint256 decimals, string memory err)
        internal
        pure
        virtual
    {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07ca0000, 1037618710474) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07ca0001, 4) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07ca0005, 585) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07ca6003, err) }
        vm.assertNotEqDecimal(left, right, decimals, err);
    }

    function assertNotEq(int256 left, int256 right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07cb0000, 1037618710475) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07cb0001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07cb0005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07cb6001, right) }
        vm.assertNotEq(left, right);
    }

    function assertNotEq(int256 left, int256 right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07cc0000, 1037618710476) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07cc0001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07cc0005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07cc6002, err) }
        vm.assertNotEq(left, right, err);
    }

    function assertNotEqDecimal(int256 left, int256 right, uint256 decimals) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07cd0000, 1037618710477) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07cd0001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07cd0005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07cd6002, decimals) }
        vm.assertNotEqDecimal(left, right, decimals);
    }

    function assertNotEqDecimal(int256 left, int256 right, uint256 decimals, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07ce0000, 1037618710478) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07ce0001, 4) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07ce0005, 585) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07ce6003, err) }
        vm.assertNotEqDecimal(left, right, decimals, err);
    }

    function assertNotEq(address left, address right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07cf0000, 1037618710479) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07cf0001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07cf0005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07cf6001, right) }
        vm.assertNotEq(left, right);
    }

    function assertNotEq(address left, address right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07d00000, 1037618710480) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07d00001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07d00005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07d06002, err) }
        vm.assertNotEq(left, right, err);
    }

    function assertNotEq(bytes32 left, bytes32 right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07d10000, 1037618710481) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07d10001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07d10005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07d16001, right) }
        vm.assertNotEq(left, right);
    }

    function assertNotEq(bytes32 left, bytes32 right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07d20000, 1037618710482) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07d20001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07d20005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07d26002, err) }
        vm.assertNotEq(left, right, err);
    }

    function assertNotEq32(bytes32 left, bytes32 right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07d30000, 1037618710483) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07d30001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07d30005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07d36001, right) }
        assertNotEq(left, right);
    }

    function assertNotEq32(bytes32 left, bytes32 right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08150000, 1037618710549) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08150001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08150005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08156002, err) }
        assertNotEq(left, right, err);
    }

    function assertNotEq(string memory left, string memory right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff081f0000, 1037618710559) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff081f0001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff081f0005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff081f6001, right) }
        vm.assertNotEq(left, right);
    }

    function assertNotEq(string memory left, string memory right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08200000, 1037618710560) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08200001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08200005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08206002, err) }
        vm.assertNotEq(left, right, err);
    }

    function assertNotEq(bytes memory left, bytes memory right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08210000, 1037618710561) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08210001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08210005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08216001, right) }
        vm.assertNotEq(left, right);
    }

    function assertNotEq(bytes memory left, bytes memory right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08220000, 1037618710562) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08220001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08220005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08226002, err) }
        vm.assertNotEq(left, right, err);
    }

    function assertNotEq(bool[] memory left, bool[] memory right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08230000, 1037618710563) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08230001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08230005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08236001, right) }
        vm.assertNotEq(left, right);
    }

    function assertNotEq(bool[] memory left, bool[] memory right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08240000, 1037618710564) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08240001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08240005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08246002, err) }
        vm.assertNotEq(left, right, err);
    }

    function assertNotEq(uint256[] memory left, uint256[] memory right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08250000, 1037618710565) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08250001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08250005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08256001, right) }
        vm.assertNotEq(left, right);
    }

    function assertNotEq(uint256[] memory left, uint256[] memory right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08260000, 1037618710566) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08260001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08260005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08266002, err) }
        vm.assertNotEq(left, right, err);
    }

    function assertNotEq(int256[] memory left, int256[] memory right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08270000, 1037618710567) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08270001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08270005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08276001, right) }
        vm.assertNotEq(left, right);
    }

    function assertNotEq(int256[] memory left, int256[] memory right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08280000, 1037618710568) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08280001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08280005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08286002, err) }
        vm.assertNotEq(left, right, err);
    }

    function assertNotEq(address[] memory left, address[] memory right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08080000, 1037618710536) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08080001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08080005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08086001, right) }
        vm.assertNotEq(left, right);
    }

    function assertNotEq(address[] memory left, address[] memory right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08090000, 1037618710537) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08090001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08090005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08096002, err) }
        vm.assertNotEq(left, right, err);
    }

    function assertNotEq(bytes32[] memory left, bytes32[] memory right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff080a0000, 1037618710538) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff080a0001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff080a0005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff080a6001, right) }
        vm.assertNotEq(left, right);
    }

    function assertNotEq(bytes32[] memory left, bytes32[] memory right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff080b0000, 1037618710539) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff080b0001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff080b0005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff080b6002, err) }
        vm.assertNotEq(left, right, err);
    }

    function assertNotEq(string[] memory left, string[] memory right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08010000, 1037618710529) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08010001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08010005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08016001, right) }
        vm.assertNotEq(left, right);
    }

    function assertNotEq(string[] memory left, string[] memory right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08020000, 1037618710530) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08020001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08020005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08026002, err) }
        vm.assertNotEq(left, right, err);
    }

    function assertNotEq(bytes[] memory left, bytes[] memory right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08030000, 1037618710531) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08030001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08030005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08036001, right) }
        vm.assertNotEq(left, right);
    }

    function assertNotEq(bytes[] memory left, bytes[] memory right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08040000, 1037618710532) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08040001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08040005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08046002, err) }
        vm.assertNotEq(left, right, err);
    }

    function assertLt(uint256 left, uint256 right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08050000, 1037618710533) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08050001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08050005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08056001, right) }
        vm.assertLt(left, right);
    }

    function assertLt(uint256 left, uint256 right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08060000, 1037618710534) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08060001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08060005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08066002, err) }
        vm.assertLt(left, right, err);
    }

    function assertLtDecimal(uint256 left, uint256 right, uint256 decimals) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08070000, 1037618710535) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08070001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08070005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08076002, decimals) }
        vm.assertLtDecimal(left, right, decimals);
    }

    function assertLtDecimal(uint256 left, uint256 right, uint256 decimals, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08160000, 1037618710550) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08160001, 4) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08160005, 585) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08166003, err) }
        vm.assertLtDecimal(left, right, decimals, err);
    }

    function assertLt(int256 left, int256 right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08170000, 1037618710551) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08170001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08170005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08176001, right) }
        vm.assertLt(left, right);
    }

    function assertLt(int256 left, int256 right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08180000, 1037618710552) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08180001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08180005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08186002, err) }
        vm.assertLt(left, right, err);
    }

    function assertLtDecimal(int256 left, int256 right, uint256 decimals) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08190000, 1037618710553) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08190001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08190005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08196002, decimals) }
        vm.assertLtDecimal(left, right, decimals);
    }

    function assertLtDecimal(int256 left, int256 right, uint256 decimals, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff081a0000, 1037618710554) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff081a0001, 4) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff081a0005, 585) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff081a6003, err) }
        vm.assertLtDecimal(left, right, decimals, err);
    }

    function assertGt(uint256 left, uint256 right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff081b0000, 1037618710555) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff081b0001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff081b0005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff081b6001, right) }
        vm.assertGt(left, right);
    }

    function assertGt(uint256 left, uint256 right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff081c0000, 1037618710556) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff081c0001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff081c0005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff081c6002, err) }
        vm.assertGt(left, right, err);
    }

    function assertGtDecimal(uint256 left, uint256 right, uint256 decimals) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff081d0000, 1037618710557) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff081d0001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff081d0005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff081d6002, decimals) }
        vm.assertGtDecimal(left, right, decimals);
    }

    function assertGtDecimal(uint256 left, uint256 right, uint256 decimals, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff081e0000, 1037618710558) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff081e0001, 4) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff081e0005, 585) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff081e6003, err) }
        vm.assertGtDecimal(left, right, decimals, err);
    }

    function assertGt(int256 left, int256 right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07ed0000, 1037618710509) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07ed0001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07ed0005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07ed6001, right) }
        vm.assertGt(left, right);
    }

    function assertGt(int256 left, int256 right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07ee0000, 1037618710510) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07ee0001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07ee0005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07ee6002, err) }
        vm.assertGt(left, right, err);
    }

    function assertGtDecimal(int256 left, int256 right, uint256 decimals) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07ef0000, 1037618710511) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07ef0001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07ef0005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07ef6002, decimals) }
        vm.assertGtDecimal(left, right, decimals);
    }

    function assertGtDecimal(int256 left, int256 right, uint256 decimals, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07f00000, 1037618710512) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07f00001, 4) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07f00005, 585) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07f06003, err) }
        vm.assertGtDecimal(left, right, decimals, err);
    }

    function assertLe(uint256 left, uint256 right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07f10000, 1037618710513) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07f10001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07f10005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07f16001, right) }
        vm.assertLe(left, right);
    }

    function assertLe(uint256 left, uint256 right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07f20000, 1037618710514) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07f20001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07f20005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07f26002, err) }
        vm.assertLe(left, right, err);
    }

    function assertLeDecimal(uint256 left, uint256 right, uint256 decimals) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07f30000, 1037618710515) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07f30001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07f30005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07f36002, decimals) }
        vm.assertLeDecimal(left, right, decimals);
    }

    function assertLeDecimal(uint256 left, uint256 right, uint256 decimals, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07f40000, 1037618710516) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07f40001, 4) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07f40005, 585) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07f46003, err) }
        vm.assertLeDecimal(left, right, decimals, err);
    }

    function assertLe(int256 left, int256 right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07f50000, 1037618710517) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07f50001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07f50005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07f56001, right) }
        vm.assertLe(left, right);
    }

    function assertLe(int256 left, int256 right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07f60000, 1037618710518) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07f60001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07f60005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07f66002, err) }
        vm.assertLe(left, right, err);
    }

    function assertLeDecimal(int256 left, int256 right, uint256 decimals) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08290000, 1037618710569) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08290001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08290005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08296002, decimals) }
        vm.assertLeDecimal(left, right, decimals);
    }

    function assertLeDecimal(int256 left, int256 right, uint256 decimals, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff082a0000, 1037618710570) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff082a0001, 4) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff082a0005, 585) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff082a6003, err) }
        vm.assertLeDecimal(left, right, decimals, err);
    }

    function assertGe(uint256 left, uint256 right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff082b0000, 1037618710571) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff082b0001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff082b0005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff082b6001, right) }
        vm.assertGe(left, right);
    }

    function assertGe(uint256 left, uint256 right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff082c0000, 1037618710572) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff082c0001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff082c0005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff082c6002, err) }
        vm.assertGe(left, right, err);
    }

    function assertGeDecimal(uint256 left, uint256 right, uint256 decimals) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff082d0000, 1037618710573) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff082d0001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff082d0005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff082d6002, decimals) }
        vm.assertGeDecimal(left, right, decimals);
    }

    function assertGeDecimal(uint256 left, uint256 right, uint256 decimals, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff082e0000, 1037618710574) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff082e0001, 4) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff082e0005, 585) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff082e6003, err) }
        vm.assertGeDecimal(left, right, decimals, err);
    }

    function assertGe(int256 left, int256 right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff082f0000, 1037618710575) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff082f0001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff082f0005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff082f6001, right) }
        vm.assertGe(left, right);
    }

    function assertGe(int256 left, int256 right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08300000, 1037618710576) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08300001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08300005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08306002, err) }
        vm.assertGe(left, right, err);
    }

    function assertGeDecimal(int256 left, int256 right, uint256 decimals) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08310000, 1037618710577) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08310001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08310005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08316002, decimals) }
        vm.assertGeDecimal(left, right, decimals);
    }

    function assertGeDecimal(int256 left, int256 right, uint256 decimals, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08320000, 1037618710578) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08320001, 4) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08320005, 585) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08326003, err) }
        vm.assertGeDecimal(left, right, decimals, err);
    }

    function assertApproxEqAbs(uint256 left, uint256 right, uint256 maxDelta) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07db0000, 1037618710491) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07db0001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07db0005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07db6002, maxDelta) }
        vm.assertApproxEqAbs(left, right, maxDelta);
    }

    function assertApproxEqAbs(uint256 left, uint256 right, uint256 maxDelta, string memory err)
        internal
        pure
        virtual
    {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07dc0000, 1037618710492) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07dc0001, 4) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07dc0005, 585) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07dc6003, err) }
        vm.assertApproxEqAbs(left, right, maxDelta, err);
    }

    function assertApproxEqAbsDecimal(uint256 left, uint256 right, uint256 maxDelta, uint256 decimals)
        internal
        pure
        virtual
    {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07dd0000, 1037618710493) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07dd0001, 4) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07dd0005, 585) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07dd6003, decimals) }
        vm.assertApproxEqAbsDecimal(left, right, maxDelta, decimals);
    }

    function assertApproxEqAbsDecimal(
        uint256 left,
        uint256 right,
        uint256 maxDelta,
        uint256 decimals,
        string memory err
    ) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07de0000, 1037618710494) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07de0001, 5) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07de0005, 4681) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07de6004, err) }
        vm.assertApproxEqAbsDecimal(left, right, maxDelta, decimals, err);
    }

    function assertApproxEqAbs(int256 left, int256 right, uint256 maxDelta) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07df0000, 1037618710495) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07df0001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07df0005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07df6002, maxDelta) }
        vm.assertApproxEqAbs(left, right, maxDelta);
    }

    function assertApproxEqAbs(int256 left, int256 right, uint256 maxDelta, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07e00000, 1037618710496) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07e00001, 4) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07e00005, 585) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07e06003, err) }
        vm.assertApproxEqAbs(left, right, maxDelta, err);
    }

    function assertApproxEqAbsDecimal(int256 left, int256 right, uint256 maxDelta, uint256 decimals)
        internal
        pure
        virtual
    {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07e10000, 1037618710497) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07e10001, 4) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07e10005, 585) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07e16003, decimals) }
        vm.assertApproxEqAbsDecimal(left, right, maxDelta, decimals);
    }

    function assertApproxEqAbsDecimal(int256 left, int256 right, uint256 maxDelta, uint256 decimals, string memory err)
        internal
        pure
        virtual
    {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07e20000, 1037618710498) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07e20001, 5) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07e20005, 4681) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07e26004, err) }
        vm.assertApproxEqAbsDecimal(left, right, maxDelta, decimals, err);
    }

    function assertApproxEqRel(
        uint256 left,
        uint256 right,
        uint256 maxPercentDelta // An 18 decimal fixed point number, where 1e18 == 100%
    ) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07f70000, 1037618710519) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07f70001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07f70005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07f76002, maxPercentDelta) }
        vm.assertApproxEqRel(left, right, maxPercentDelta);
    }

    function assertApproxEqRel(
        uint256 left,
        uint256 right,
        uint256 maxPercentDelta, // An 18 decimal fixed point number, where 1e18 == 100%
        string memory err
    ) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07f80000, 1037618710520) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07f80001, 4) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07f80005, 585) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07f86003, err) }
        vm.assertApproxEqRel(left, right, maxPercentDelta, err);
    }

    function assertApproxEqRelDecimal(
        uint256 left,
        uint256 right,
        uint256 maxPercentDelta, // An 18 decimal fixed point number, where 1e18 == 100%
        uint256 decimals
    ) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07f90000, 1037618710521) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07f90001, 4) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07f90005, 585) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07f96003, decimals) }
        vm.assertApproxEqRelDecimal(left, right, maxPercentDelta, decimals);
    }

    function assertApproxEqRelDecimal(
        uint256 left,
        uint256 right,
        uint256 maxPercentDelta, // An 18 decimal fixed point number, where 1e18 == 100%
        uint256 decimals,
        string memory err
    ) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07fa0000, 1037618710522) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07fa0001, 5) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07fa0005, 4681) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07fa6004, err) }
        vm.assertApproxEqRelDecimal(left, right, maxPercentDelta, decimals, err);
    }

    function assertApproxEqRel(int256 left, int256 right, uint256 maxPercentDelta) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07fb0000, 1037618710523) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07fb0001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07fb0005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07fb6002, maxPercentDelta) }
        vm.assertApproxEqRel(left, right, maxPercentDelta);
    }

    function assertApproxEqRel(
        int256 left,
        int256 right,
        uint256 maxPercentDelta, // An 18 decimal fixed point number, where 1e18 == 100%
        string memory err
    ) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07fc0000, 1037618710524) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07fc0001, 4) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07fc0005, 585) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07fc6003, err) }
        vm.assertApproxEqRel(left, right, maxPercentDelta, err);
    }

    function assertApproxEqRelDecimal(
        int256 left,
        int256 right,
        uint256 maxPercentDelta, // An 18 decimal fixed point number, where 1e18 == 100%
        uint256 decimals
    ) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07fd0000, 1037618710525) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07fd0001, 4) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07fd0005, 585) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07fd6003, decimals) }
        vm.assertApproxEqRelDecimal(left, right, maxPercentDelta, decimals);
    }

    function assertApproxEqRelDecimal(
        int256 left,
        int256 right,
        uint256 maxPercentDelta, // An 18 decimal fixed point number, where 1e18 == 100%
        uint256 decimals,
        string memory err
    ) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07fe0000, 1037618710526) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07fe0001, 5) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07fe0005, 4681) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07fe6004, err) }
        vm.assertApproxEqRelDecimal(left, right, maxPercentDelta, decimals, err);
    }

    // Inherited from DSTest, not used but kept for backwards-compatibility
    function checkEq0(bytes memory left, bytes memory right) internal pure returns (bool) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07ff0000, 1037618710527) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07ff0001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07ff0005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07ff6001, right) }
        return keccak256(left) == keccak256(right);
    }

    function assertEq0(bytes memory left, bytes memory right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08000000, 1037618710528) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08000001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08000005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08006001, right) }
        assertEq(left, right);
    }

    function assertEq0(bytes memory left, bytes memory right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07d40000, 1037618710484) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07d40001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07d40005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07d46002, err) }
        assertEq(left, right, err);
    }

    function assertNotEq0(bytes memory left, bytes memory right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07d50000, 1037618710485) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07d50001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07d50005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07d56001, right) }
        assertNotEq(left, right);
    }

    function assertNotEq0(bytes memory left, bytes memory right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07d60000, 1037618710486) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07d60001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07d60005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07d66002, err) }
        assertNotEq(left, right, err);
    }

    function assertEqCall(address target, bytes memory callDataA, bytes memory callDataB) internal virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07d70000, 1037618710487) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07d70001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07d70005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07d76002, callDataB) }
        assertEqCall(target, callDataA, target, callDataB, true);
    }

    function assertEqCall(address targetA, bytes memory callDataA, address targetB, bytes memory callDataB)
        internal
        virtual
    {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07d80000, 1037618710488) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07d80001, 4) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07d80005, 585) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07d86003, callDataB) }
        assertEqCall(targetA, callDataA, targetB, callDataB, true);
    }

    function assertEqCall(address target, bytes memory callDataA, bytes memory callDataB, bool strictRevertData)
        internal
        virtual
    {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07d90000, 1037618710489) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07d90001, 4) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07d90005, 585) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07d96003, strictRevertData) }
        assertEqCall(target, callDataA, target, callDataB, strictRevertData);
    }

    function assertEqCall(
        address targetA,
        bytes memory callDataA,
        address targetB,
        bytes memory callDataB,
        bool strictRevertData
    ) internal virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07da0000, 1037618710490) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07da0001, 5) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07da0005, 4681) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07da6004, strictRevertData) }
        (bool successA, bytes memory returnDataA) = address(targetA).call(callDataA);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00010036,0)}
        (bool successB, bytes memory returnDataB) = address(targetB).call(callDataB);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00010037,0)}

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
