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

    function failed() public view returns (bool) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0dba0000, 1037618711994) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0dba0001, 0) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0dba0004, 0) }
        if (_failed) {
            return _failed;
        } else {
            return vm.load(address(vm), bytes32("failed")) != bytes32(0);
        }
    }

    function fail() internal virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0dc10000, 1037618712001) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0dc10001, 0) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0dc10004, 0) }
        vm.store(address(vm), bytes32("failed"), bytes32(uint256(1)));
        _failed = true;
    }

    function assertTrue(bool data) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0dc20000, 1037618712002) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0dc20001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0dc20005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0dc26000, data) }
        vm.assertTrue(data);
    }

    function assertTrue(bool data, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0dc40000, 1037618712004) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0dc40001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0dc40005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0dc46001, err) }
        vm.assertTrue(data, err);
    }

    function assertFalse(bool data) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0dc50000, 1037618712005) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0dc50001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0dc50005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0dc56000, data) }
        vm.assertFalse(data);
    }

    function assertFalse(bool data, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0dc30000, 1037618712003) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0dc30001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0dc30005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0dc36001, err) }
        vm.assertFalse(data, err);
    }

    function assertEq(bool left, bool right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0dc60000, 1037618712006) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0dc60001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0dc60005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0dc66001, right) }
        vm.assertEq(left, right);
    }

    function assertEq(bool left, bool right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0dc70000, 1037618712007) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0dc70001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0dc70005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0dc76002, err) }
        vm.assertEq(left, right, err);
    }

    function assertEq(uint256 left, uint256 right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0dc80000, 1037618712008) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0dc80001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0dc80005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0dc86001, right) }
        vm.assertEq(left, right);
    }

    function assertEq(uint256 left, uint256 right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0dc90000, 1037618712009) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0dc90001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0dc90005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0dc96002, err) }
        vm.assertEq(left, right, err);
    }

    function assertEqDecimal(uint256 left, uint256 right, uint256 decimals) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0dca0000, 1037618712010) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0dca0001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0dca0005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0dca6002, decimals) }
        vm.assertEqDecimal(left, right, decimals);
    }

    function assertEqDecimal(uint256 left, uint256 right, uint256 decimals, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0dcb0000, 1037618712011) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0dcb0001, 4) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0dcb0005, 585) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0dcb6003, err) }
        vm.assertEqDecimal(left, right, decimals, err);
    }

    function assertEq(int256 left, int256 right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0dcc0000, 1037618712012) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0dcc0001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0dcc0005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0dcc6001, right) }
        vm.assertEq(left, right);
    }

    function assertEq(int256 left, int256 right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0dcd0000, 1037618712013) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0dcd0001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0dcd0005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0dcd6002, err) }
        vm.assertEq(left, right, err);
    }

    function assertEqDecimal(int256 left, int256 right, uint256 decimals) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0dce0000, 1037618712014) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0dce0001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0dce0005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0dce6002, decimals) }
        vm.assertEqDecimal(left, right, decimals);
    }

    function assertEqDecimal(int256 left, int256 right, uint256 decimals, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0dcf0000, 1037618712015) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0dcf0001, 4) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0dcf0005, 585) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0dcf6003, err) }
        vm.assertEqDecimal(left, right, decimals, err);
    }

    function assertEq(address left, address right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0dd00000, 1037618712016) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0dd00001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0dd00005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0dd06001, right) }
        vm.assertEq(left, right);
    }

    function assertEq(address left, address right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0df60000, 1037618712054) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0df60001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0df60005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0df66002, err) }
        vm.assertEq(left, right, err);
    }

    function assertEq(bytes32 left, bytes32 right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0df50000, 1037618712053) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0df50001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0df50005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0df56001, right) }
        vm.assertEq(left, right);
    }

    function assertEq(bytes32 left, bytes32 right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0df40000, 1037618712052) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0df40001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0df40005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0df46002, err) }
        vm.assertEq(left, right, err);
    }

    function assertEq32(bytes32 left, bytes32 right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0df70000, 1037618712055) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0df70001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0df70005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0df76001, right) }
        assertEq(left, right);
    }

    function assertEq32(bytes32 left, bytes32 right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0df80000, 1037618712056) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0df80001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0df80005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0df86002, err) }
        assertEq(left, right, err);
    }

    function assertEq(string memory left, string memory right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0df90000, 1037618712057) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0df90001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0df90005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0df96001, right) }
        vm.assertEq(left, right);
    }

    function assertEq(string memory left, string memory right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0dfa0000, 1037618712058) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0dfa0001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0dfa0005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0dfa6002, err) }
        vm.assertEq(left, right, err);
    }

    function assertEq(bytes memory left, bytes memory right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0dfb0000, 1037618712059) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0dfb0001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0dfb0005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0dfb6001, right) }
        vm.assertEq(left, right);
    }

    function assertEq(bytes memory left, bytes memory right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0dfc0000, 1037618712060) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0dfc0001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0dfc0005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0dfc6002, err) }
        vm.assertEq(left, right, err);
    }

    function assertEq(bool[] memory left, bool[] memory right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0dfd0000, 1037618712061) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0dfd0001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0dfd0005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0dfd6001, right) }
        vm.assertEq(left, right);
    }

    function assertEq(bool[] memory left, bool[] memory right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0dd80000, 1037618712024) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0dd80001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0dd80005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0dd86002, err) }
        vm.assertEq(left, right, err);
    }

    function assertEq(uint256[] memory left, uint256[] memory right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0dd90000, 1037618712025) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0dd90001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0dd90005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0dd96001, right) }
        vm.assertEq(left, right);
    }

    function assertEq(uint256[] memory left, uint256[] memory right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0dda0000, 1037618712026) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0dda0001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0dda0005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0dda6002, err) }
        vm.assertEq(left, right, err);
    }

    function assertEq(int256[] memory left, int256[] memory right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0dd10000, 1037618712017) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0dd10001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0dd10005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0dd16001, right) }
        vm.assertEq(left, right);
    }

    function assertEq(int256[] memory left, int256[] memory right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0dd20000, 1037618712018) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0dd20001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0dd20005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0dd26002, err) }
        vm.assertEq(left, right, err);
    }

    function assertEq(address[] memory left, address[] memory right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0dd30000, 1037618712019) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0dd30001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0dd30005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0dd36001, right) }
        vm.assertEq(left, right);
    }

    function assertEq(address[] memory left, address[] memory right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0dd40000, 1037618712020) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0dd40001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0dd40005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0dd46002, err) }
        vm.assertEq(left, right, err);
    }

    function assertEq(bytes32[] memory left, bytes32[] memory right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0dd50000, 1037618712021) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0dd50001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0dd50005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0dd56001, right) }
        vm.assertEq(left, right);
    }

    function assertEq(bytes32[] memory left, bytes32[] memory right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0dd60000, 1037618712022) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0dd60001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0dd60005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0dd66002, err) }
        vm.assertEq(left, right, err);
    }

    function assertEq(string[] memory left, string[] memory right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0dd70000, 1037618712023) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0dd70001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0dd70005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0dd76001, right) }
        vm.assertEq(left, right);
    }

    function assertEq(string[] memory left, string[] memory right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e1d0000, 1037618712093) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e1d0001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e1d0005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e1d6002, err) }
        vm.assertEq(left, right, err);
    }

    function assertEq(bytes[] memory left, bytes[] memory right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e1e0000, 1037618712094) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e1e0001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e1e0005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e1e6001, right) }
        vm.assertEq(left, right);
    }

    function assertEq(bytes[] memory left, bytes[] memory right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e1f0000, 1037618712095) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e1f0001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e1f0005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e1f6002, err) }
        vm.assertEq(left, right, err);
    }

    // Legacy helper
    function assertEqUint(uint256 left, uint256 right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e200000, 1037618712096) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e200001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e200005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e206001, right) }
        assertEq(left, right);
    }

    function assertNotEq(bool left, bool right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e210000, 1037618712097) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e210001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e210005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e216001, right) }
        vm.assertNotEq(left, right);
    }

    function assertNotEq(bool left, bool right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e220000, 1037618712098) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e220001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e220005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e226002, err) }
        vm.assertNotEq(left, right, err);
    }

    function assertNotEq(uint256 left, uint256 right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e230000, 1037618712099) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e230001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e230005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e236001, right) }
        vm.assertNotEq(left, right);
    }

    function assertNotEq(uint256 left, uint256 right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e240000, 1037618712100) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e240001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e240005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e246002, err) }
        vm.assertNotEq(left, right, err);
    }

    function assertNotEqDecimal(uint256 left, uint256 right, uint256 decimals) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e250000, 1037618712101) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e250001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e250005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e256002, decimals) }
        vm.assertNotEqDecimal(left, right, decimals);
    }

    function assertNotEqDecimal(uint256 left, uint256 right, uint256 decimals, string memory err)
        internal
        pure
        virtual
    {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ddb0000, 1037618712027) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ddb0001, 4) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ddb0005, 585) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ddb6003, err) }
        vm.assertNotEqDecimal(left, right, decimals, err);
    }

    function assertNotEq(int256 left, int256 right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ddc0000, 1037618712028) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ddc0001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ddc0005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ddc6001, right) }
        vm.assertNotEq(left, right);
    }

    function assertNotEq(int256 left, int256 right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ddd0000, 1037618712029) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ddd0001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ddd0005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ddd6002, err) }
        vm.assertNotEq(left, right, err);
    }

    function assertNotEqDecimal(int256 left, int256 right, uint256 decimals) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0dde0000, 1037618712030) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0dde0001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0dde0005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0dde6002, decimals) }
        vm.assertNotEqDecimal(left, right, decimals);
    }

    function assertNotEqDecimal(int256 left, int256 right, uint256 decimals, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ddf0000, 1037618712031) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ddf0001, 4) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ddf0005, 585) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ddf6003, err) }
        vm.assertNotEqDecimal(left, right, decimals, err);
    }

    function assertNotEq(address left, address right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0de00000, 1037618712032) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0de00001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0de00005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0de06001, right) }
        vm.assertNotEq(left, right);
    }

    function assertNotEq(address left, address right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0de10000, 1037618712033) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0de10001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0de10005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0de16002, err) }
        vm.assertNotEq(left, right, err);
    }

    function assertNotEq(bytes32 left, bytes32 right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0de20000, 1037618712034) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0de20001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0de20005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0de26001, right) }
        vm.assertNotEq(left, right);
    }

    function assertNotEq(bytes32 left, bytes32 right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0de30000, 1037618712035) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0de30001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0de30005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0de36002, err) }
        vm.assertNotEq(left, right, err);
    }

    function assertNotEq32(bytes32 left, bytes32 right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0de40000, 1037618712036) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0de40001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0de40005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0de46001, right) }
        assertNotEq(left, right);
    }

    function assertNotEq32(bytes32 left, bytes32 right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e260000, 1037618712102) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e260001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e260005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e266002, err) }
        assertNotEq(left, right, err);
    }

    function assertNotEq(string memory left, string memory right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e300000, 1037618712112) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e300001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e300005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e306001, right) }
        vm.assertNotEq(left, right);
    }

    function assertNotEq(string memory left, string memory right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e310000, 1037618712113) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e310001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e310005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e316002, err) }
        vm.assertNotEq(left, right, err);
    }

    function assertNotEq(bytes memory left, bytes memory right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e320000, 1037618712114) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e320001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e320005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e326001, right) }
        vm.assertNotEq(left, right);
    }

    function assertNotEq(bytes memory left, bytes memory right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e330000, 1037618712115) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e330001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e330005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e336002, err) }
        vm.assertNotEq(left, right, err);
    }

    function assertNotEq(bool[] memory left, bool[] memory right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e340000, 1037618712116) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e340001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e340005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e346001, right) }
        vm.assertNotEq(left, right);
    }

    function assertNotEq(bool[] memory left, bool[] memory right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e350000, 1037618712117) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e350001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e350005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e356002, err) }
        vm.assertNotEq(left, right, err);
    }

    function assertNotEq(uint256[] memory left, uint256[] memory right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e360000, 1037618712118) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e360001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e360005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e366001, right) }
        vm.assertNotEq(left, right);
    }

    function assertNotEq(uint256[] memory left, uint256[] memory right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e370000, 1037618712119) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e370001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e370005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e376002, err) }
        vm.assertNotEq(left, right, err);
    }

    function assertNotEq(int256[] memory left, int256[] memory right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e380000, 1037618712120) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e380001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e380005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e386001, right) }
        vm.assertNotEq(left, right);
    }

    function assertNotEq(int256[] memory left, int256[] memory right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e390000, 1037618712121) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e390001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e390005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e396002, err) }
        vm.assertNotEq(left, right, err);
    }

    function assertNotEq(address[] memory left, address[] memory right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e190000, 1037618712089) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e190001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e190005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e196001, right) }
        vm.assertNotEq(left, right);
    }

    function assertNotEq(address[] memory left, address[] memory right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e1a0000, 1037618712090) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e1a0001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e1a0005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e1a6002, err) }
        vm.assertNotEq(left, right, err);
    }

    function assertNotEq(bytes32[] memory left, bytes32[] memory right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e1b0000, 1037618712091) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e1b0001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e1b0005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e1b6001, right) }
        vm.assertNotEq(left, right);
    }

    function assertNotEq(bytes32[] memory left, bytes32[] memory right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e1c0000, 1037618712092) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e1c0001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e1c0005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e1c6002, err) }
        vm.assertNotEq(left, right, err);
    }

    function assertNotEq(string[] memory left, string[] memory right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e120000, 1037618712082) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e120001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e120005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e126001, right) }
        vm.assertNotEq(left, right);
    }

    function assertNotEq(string[] memory left, string[] memory right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e130000, 1037618712083) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e130001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e130005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e136002, err) }
        vm.assertNotEq(left, right, err);
    }

    function assertNotEq(bytes[] memory left, bytes[] memory right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e140000, 1037618712084) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e140001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e140005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e146001, right) }
        vm.assertNotEq(left, right);
    }

    function assertNotEq(bytes[] memory left, bytes[] memory right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e150000, 1037618712085) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e150001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e150005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e156002, err) }
        vm.assertNotEq(left, right, err);
    }

    function assertLt(uint256 left, uint256 right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e160000, 1037618712086) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e160001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e160005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e166001, right) }
        vm.assertLt(left, right);
    }

    function assertLt(uint256 left, uint256 right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e170000, 1037618712087) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e170001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e170005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e176002, err) }
        vm.assertLt(left, right, err);
    }

    function assertLtDecimal(uint256 left, uint256 right, uint256 decimals) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e180000, 1037618712088) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e180001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e180005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e186002, decimals) }
        vm.assertLtDecimal(left, right, decimals);
    }

    function assertLtDecimal(uint256 left, uint256 right, uint256 decimals, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e270000, 1037618712103) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e270001, 4) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e270005, 585) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e276003, err) }
        vm.assertLtDecimal(left, right, decimals, err);
    }

    function assertLt(int256 left, int256 right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e280000, 1037618712104) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e280001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e280005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e286001, right) }
        vm.assertLt(left, right);
    }

    function assertLt(int256 left, int256 right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e290000, 1037618712105) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e290001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e290005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e296002, err) }
        vm.assertLt(left, right, err);
    }

    function assertLtDecimal(int256 left, int256 right, uint256 decimals) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e2a0000, 1037618712106) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e2a0001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e2a0005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e2a6002, decimals) }
        vm.assertLtDecimal(left, right, decimals);
    }

    function assertLtDecimal(int256 left, int256 right, uint256 decimals, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e2b0000, 1037618712107) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e2b0001, 4) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e2b0005, 585) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e2b6003, err) }
        vm.assertLtDecimal(left, right, decimals, err);
    }

    function assertGt(uint256 left, uint256 right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e2c0000, 1037618712108) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e2c0001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e2c0005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e2c6001, right) }
        vm.assertGt(left, right);
    }

    function assertGt(uint256 left, uint256 right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e2d0000, 1037618712109) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e2d0001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e2d0005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e2d6002, err) }
        vm.assertGt(left, right, err);
    }

    function assertGtDecimal(uint256 left, uint256 right, uint256 decimals) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e2e0000, 1037618712110) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e2e0001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e2e0005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e2e6002, decimals) }
        vm.assertGtDecimal(left, right, decimals);
    }

    function assertGtDecimal(uint256 left, uint256 right, uint256 decimals, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e2f0000, 1037618712111) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e2f0001, 4) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e2f0005, 585) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e2f6003, err) }
        vm.assertGtDecimal(left, right, decimals, err);
    }

    function assertGt(int256 left, int256 right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0dfe0000, 1037618712062) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0dfe0001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0dfe0005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0dfe6001, right) }
        vm.assertGt(left, right);
    }

    function assertGt(int256 left, int256 right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0dff0000, 1037618712063) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0dff0001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0dff0005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0dff6002, err) }
        vm.assertGt(left, right, err);
    }

    function assertGtDecimal(int256 left, int256 right, uint256 decimals) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e000000, 1037618712064) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e000001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e000005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e006002, decimals) }
        vm.assertGtDecimal(left, right, decimals);
    }

    function assertGtDecimal(int256 left, int256 right, uint256 decimals, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e010000, 1037618712065) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e010001, 4) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e010005, 585) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e016003, err) }
        vm.assertGtDecimal(left, right, decimals, err);
    }

    function assertLe(uint256 left, uint256 right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e020000, 1037618712066) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e020001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e020005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e026001, right) }
        vm.assertLe(left, right);
    }

    function assertLe(uint256 left, uint256 right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e030000, 1037618712067) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e030001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e030005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e036002, err) }
        vm.assertLe(left, right, err);
    }

    function assertLeDecimal(uint256 left, uint256 right, uint256 decimals) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e040000, 1037618712068) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e040001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e040005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e046002, decimals) }
        vm.assertLeDecimal(left, right, decimals);
    }

    function assertLeDecimal(uint256 left, uint256 right, uint256 decimals, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e050000, 1037618712069) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e050001, 4) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e050005, 585) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e056003, err) }
        vm.assertLeDecimal(left, right, decimals, err);
    }

    function assertLe(int256 left, int256 right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e060000, 1037618712070) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e060001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e060005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e066001, right) }
        vm.assertLe(left, right);
    }

    function assertLe(int256 left, int256 right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e070000, 1037618712071) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e070001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e070005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e076002, err) }
        vm.assertLe(left, right, err);
    }

    function assertLeDecimal(int256 left, int256 right, uint256 decimals) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e3a0000, 1037618712122) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e3a0001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e3a0005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e3a6002, decimals) }
        vm.assertLeDecimal(left, right, decimals);
    }

    function assertLeDecimal(int256 left, int256 right, uint256 decimals, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e3b0000, 1037618712123) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e3b0001, 4) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e3b0005, 585) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e3b6003, err) }
        vm.assertLeDecimal(left, right, decimals, err);
    }

    function assertGe(uint256 left, uint256 right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e3c0000, 1037618712124) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e3c0001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e3c0005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e3c6001, right) }
        vm.assertGe(left, right);
    }

    function assertGe(uint256 left, uint256 right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e3d0000, 1037618712125) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e3d0001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e3d0005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e3d6002, err) }
        vm.assertGe(left, right, err);
    }

    function assertGeDecimal(uint256 left, uint256 right, uint256 decimals) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e3e0000, 1037618712126) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e3e0001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e3e0005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e3e6002, decimals) }
        vm.assertGeDecimal(left, right, decimals);
    }

    function assertGeDecimal(uint256 left, uint256 right, uint256 decimals, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e3f0000, 1037618712127) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e3f0001, 4) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e3f0005, 585) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e3f6003, err) }
        vm.assertGeDecimal(left, right, decimals, err);
    }

    function assertGe(int256 left, int256 right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e400000, 1037618712128) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e400001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e400005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e406001, right) }
        vm.assertGe(left, right);
    }

    function assertGe(int256 left, int256 right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e410000, 1037618712129) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e410001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e410005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e416002, err) }
        vm.assertGe(left, right, err);
    }

    function assertGeDecimal(int256 left, int256 right, uint256 decimals) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e420000, 1037618712130) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e420001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e420005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e426002, decimals) }
        vm.assertGeDecimal(left, right, decimals);
    }

    function assertGeDecimal(int256 left, int256 right, uint256 decimals, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e430000, 1037618712131) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e430001, 4) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e430005, 585) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e436003, err) }
        vm.assertGeDecimal(left, right, decimals, err);
    }

    function assertApproxEqAbs(uint256 left, uint256 right, uint256 maxDelta) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0dec0000, 1037618712044) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0dec0001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0dec0005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0dec6002, maxDelta) }
        vm.assertApproxEqAbs(left, right, maxDelta);
    }

    function assertApproxEqAbs(uint256 left, uint256 right, uint256 maxDelta, string memory err)
        internal
        pure
        virtual
    {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ded0000, 1037618712045) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ded0001, 4) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ded0005, 585) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ded6003, err) }
        vm.assertApproxEqAbs(left, right, maxDelta, err);
    }

    function assertApproxEqAbsDecimal(uint256 left, uint256 right, uint256 maxDelta, uint256 decimals)
        internal
        pure
        virtual
    {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0dee0000, 1037618712046) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0dee0001, 4) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0dee0005, 585) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0dee6003, decimals) }
        vm.assertApproxEqAbsDecimal(left, right, maxDelta, decimals);
    }

    function assertApproxEqAbsDecimal(
        uint256 left,
        uint256 right,
        uint256 maxDelta,
        uint256 decimals,
        string memory err
    ) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0def0000, 1037618712047) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0def0001, 5) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0def0005, 4681) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0def6004, err) }
        vm.assertApproxEqAbsDecimal(left, right, maxDelta, decimals, err);
    }

    function assertApproxEqAbs(int256 left, int256 right, uint256 maxDelta) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0df00000, 1037618712048) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0df00001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0df00005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0df06002, maxDelta) }
        vm.assertApproxEqAbs(left, right, maxDelta);
    }

    function assertApproxEqAbs(int256 left, int256 right, uint256 maxDelta, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0df10000, 1037618712049) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0df10001, 4) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0df10005, 585) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0df16003, err) }
        vm.assertApproxEqAbs(left, right, maxDelta, err);
    }

    function assertApproxEqAbsDecimal(int256 left, int256 right, uint256 maxDelta, uint256 decimals)
        internal
        pure
        virtual
    {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0df20000, 1037618712050) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0df20001, 4) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0df20005, 585) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0df26003, decimals) }
        vm.assertApproxEqAbsDecimal(left, right, maxDelta, decimals);
    }

    function assertApproxEqAbsDecimal(int256 left, int256 right, uint256 maxDelta, uint256 decimals, string memory err)
        internal
        pure
        virtual
    {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0df30000, 1037618712051) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0df30001, 5) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0df30005, 4681) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0df36004, err) }
        vm.assertApproxEqAbsDecimal(left, right, maxDelta, decimals, err);
    }

    function assertApproxEqRel(
        uint256 left,
        uint256 right,
        uint256 maxPercentDelta // An 18 decimal fixed point number, where 1e18 == 100%
    ) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e080000, 1037618712072) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e080001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e080005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e086002, maxPercentDelta) }
        vm.assertApproxEqRel(left, right, maxPercentDelta);
    }

    function assertApproxEqRel(
        uint256 left,
        uint256 right,
        uint256 maxPercentDelta, // An 18 decimal fixed point number, where 1e18 == 100%
        string memory err
    ) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e090000, 1037618712073) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e090001, 4) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e090005, 585) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e096003, err) }
        vm.assertApproxEqRel(left, right, maxPercentDelta, err);
    }

    function assertApproxEqRelDecimal(
        uint256 left,
        uint256 right,
        uint256 maxPercentDelta, // An 18 decimal fixed point number, where 1e18 == 100%
        uint256 decimals
    ) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e0a0000, 1037618712074) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e0a0001, 4) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e0a0005, 585) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e0a6003, decimals) }
        vm.assertApproxEqRelDecimal(left, right, maxPercentDelta, decimals);
    }

    function assertApproxEqRelDecimal(
        uint256 left,
        uint256 right,
        uint256 maxPercentDelta, // An 18 decimal fixed point number, where 1e18 == 100%
        uint256 decimals,
        string memory err
    ) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e0b0000, 1037618712075) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e0b0001, 5) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e0b0005, 4681) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e0b6004, err) }
        vm.assertApproxEqRelDecimal(left, right, maxPercentDelta, decimals, err);
    }

    function assertApproxEqRel(int256 left, int256 right, uint256 maxPercentDelta) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e0c0000, 1037618712076) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e0c0001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e0c0005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e0c6002, maxPercentDelta) }
        vm.assertApproxEqRel(left, right, maxPercentDelta);
    }

    function assertApproxEqRel(
        int256 left,
        int256 right,
        uint256 maxPercentDelta, // An 18 decimal fixed point number, where 1e18 == 100%
        string memory err
    ) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e0d0000, 1037618712077) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e0d0001, 4) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e0d0005, 585) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e0d6003, err) }
        vm.assertApproxEqRel(left, right, maxPercentDelta, err);
    }

    function assertApproxEqRelDecimal(
        int256 left,
        int256 right,
        uint256 maxPercentDelta, // An 18 decimal fixed point number, where 1e18 == 100%
        uint256 decimals
    ) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e0e0000, 1037618712078) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e0e0001, 4) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e0e0005, 585) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e0e6003, decimals) }
        vm.assertApproxEqRelDecimal(left, right, maxPercentDelta, decimals);
    }

    function assertApproxEqRelDecimal(
        int256 left,
        int256 right,
        uint256 maxPercentDelta, // An 18 decimal fixed point number, where 1e18 == 100%
        uint256 decimals,
        string memory err
    ) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e0f0000, 1037618712079) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e0f0001, 5) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e0f0005, 4681) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e0f6004, err) }
        vm.assertApproxEqRelDecimal(left, right, maxPercentDelta, decimals, err);
    }

    // Inherited from DSTest, not used but kept for backwards-compatibility
    function checkEq0(bytes memory left, bytes memory right) internal pure returns (bool) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e100000, 1037618712080) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e100001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e100005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e106001, right) }
        return keccak256(left) == keccak256(right);
    }

    function assertEq0(bytes memory left, bytes memory right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e110000, 1037618712081) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e110001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e110005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e116001, right) }
        assertEq(left, right);
    }

    function assertEq0(bytes memory left, bytes memory right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0de50000, 1037618712037) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0de50001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0de50005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0de56002, err) }
        assertEq(left, right, err);
    }

    function assertNotEq0(bytes memory left, bytes memory right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0de60000, 1037618712038) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0de60001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0de60005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0de66001, right) }
        assertNotEq(left, right);
    }

    function assertNotEq0(bytes memory left, bytes memory right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0de70000, 1037618712039) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0de70001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0de70005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0de76002, err) }
        assertNotEq(left, right, err);
    }

    function assertEqCall(address target, bytes memory callDataA, bytes memory callDataB) internal virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0de80000, 1037618712040) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0de80001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0de80005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0de86002, callDataB) }
        assertEqCall(target, callDataA, target, callDataB, true);
    }

    function assertEqCall(address targetA, bytes memory callDataA, address targetB, bytes memory callDataB)
        internal
        virtual
    {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0de90000, 1037618712041) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0de90001, 4) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0de90005, 585) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0de96003, callDataB) }
        assertEqCall(targetA, callDataA, targetB, callDataB, true);
    }

    function assertEqCall(address target, bytes memory callDataA, bytes memory callDataB, bool strictRevertData)
        internal
        virtual
    {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0dea0000, 1037618712042) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0dea0001, 4) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0dea0005, 585) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0dea6003, strictRevertData) }
        assertEqCall(target, callDataA, target, callDataB, strictRevertData);
    }

    function assertEqCall(
        address targetA,
        bytes memory callDataA,
        address targetB,
        bytes memory callDataB,
        bool strictRevertData
    ) internal virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0deb0000, 1037618712043) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0deb0001, 5) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0deb0005, 4681) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0deb6004, strictRevertData) }
        (bool successA, bytes memory returnDataA) = address(targetA).call(callDataA);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00010034,0)}
        (bool successB, bytes memory returnDataB) = address(targetB).call(callDataB);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00010035,0)}

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
