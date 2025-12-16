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

    function failed() public view returns (bool) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04940000, 1037618709652) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04940001, 0) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04940004, 0) }
        if (_failed) {
            return _failed;
        } else {
            return vm.load(address(vm), bytes32("failed")) != bytes32(0);
        }
    }

    function fail() internal virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04b20000, 1037618709682) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04b20001, 0) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04b20004, 0) }
        vm.store(address(vm), bytes32("failed"), bytes32(uint256(1)));
        _failed = true;
    }

    function assertTrue(bool data) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04b30000, 1037618709683) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04b30001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04b30005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04b36000, data) }
        vm.assertTrue(data);
    }

    function assertTrue(bool data, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04b50000, 1037618709685) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04b50001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04b50005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04b56001, err) }
        vm.assertTrue(data, err);
    }

    function assertFalse(bool data) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04b60000, 1037618709686) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04b60001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04b60005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04b66000, data) }
        vm.assertFalse(data);
    }

    function assertFalse(bool data, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04b40000, 1037618709684) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04b40001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04b40005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04b46001, err) }
        vm.assertFalse(data, err);
    }

    function assertEq(bool left, bool right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04b70000, 1037618709687) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04b70001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04b70005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04b76001, right) }
        vm.assertEq(left, right);
    }

    function assertEq(bool left, bool right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04b80000, 1037618709688) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04b80001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04b80005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04b86002, err) }
        vm.assertEq(left, right, err);
    }

    function assertEq(uint256 left, uint256 right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04b90000, 1037618709689) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04b90001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04b90005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04b96001, right) }
        vm.assertEq(left, right);
    }

    function assertEq(uint256 left, uint256 right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04ba0000, 1037618709690) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04ba0001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04ba0005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04ba6002, err) }
        vm.assertEq(left, right, err);
    }

    function assertEqDecimal(uint256 left, uint256 right, uint256 decimals) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04bb0000, 1037618709691) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04bb0001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04bb0005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04bb6002, decimals) }
        vm.assertEqDecimal(left, right, decimals);
    }

    function assertEqDecimal(uint256 left, uint256 right, uint256 decimals, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04bc0000, 1037618709692) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04bc0001, 4) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04bc0005, 585) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04bc6003, err) }
        vm.assertEqDecimal(left, right, decimals, err);
    }

    function assertEq(int256 left, int256 right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04bd0000, 1037618709693) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04bd0001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04bd0005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04bd6001, right) }
        vm.assertEq(left, right);
    }

    function assertEq(int256 left, int256 right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04be0000, 1037618709694) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04be0001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04be0005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04be6002, err) }
        vm.assertEq(left, right, err);
    }

    function assertEqDecimal(int256 left, int256 right, uint256 decimals) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04bf0000, 1037618709695) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04bf0001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04bf0005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04bf6002, decimals) }
        vm.assertEqDecimal(left, right, decimals);
    }

    function assertEqDecimal(int256 left, int256 right, uint256 decimals, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04c00000, 1037618709696) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04c00001, 4) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04c00005, 585) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04c06003, err) }
        vm.assertEqDecimal(left, right, decimals, err);
    }

    function assertEq(address left, address right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04c10000, 1037618709697) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04c10001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04c10005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04c16001, right) }
        vm.assertEq(left, right);
    }

    function assertEq(address left, address right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04e70000, 1037618709735) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04e70001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04e70005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04e76002, err) }
        vm.assertEq(left, right, err);
    }

    function assertEq(bytes32 left, bytes32 right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04e60000, 1037618709734) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04e60001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04e60005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04e66001, right) }
        vm.assertEq(left, right);
    }

    function assertEq(bytes32 left, bytes32 right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04e50000, 1037618709733) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04e50001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04e50005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04e56002, err) }
        vm.assertEq(left, right, err);
    }

    function assertEq32(bytes32 left, bytes32 right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04e80000, 1037618709736) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04e80001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04e80005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04e86001, right) }
        assertEq(left, right);
    }

    function assertEq32(bytes32 left, bytes32 right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04e90000, 1037618709737) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04e90001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04e90005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04e96002, err) }
        assertEq(left, right, err);
    }

    function assertEq(string memory left, string memory right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04ea0000, 1037618709738) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04ea0001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04ea0005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04ea6001, right) }
        vm.assertEq(left, right);
    }

    function assertEq(string memory left, string memory right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04eb0000, 1037618709739) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04eb0001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04eb0005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04eb6002, err) }
        vm.assertEq(left, right, err);
    }

    function assertEq(bytes memory left, bytes memory right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04ec0000, 1037618709740) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04ec0001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04ec0005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04ec6001, right) }
        vm.assertEq(left, right);
    }

    function assertEq(bytes memory left, bytes memory right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04ed0000, 1037618709741) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04ed0001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04ed0005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04ed6002, err) }
        vm.assertEq(left, right, err);
    }

    function assertEq(bool[] memory left, bool[] memory right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04ee0000, 1037618709742) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04ee0001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04ee0005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04ee6001, right) }
        vm.assertEq(left, right);
    }

    function assertEq(bool[] memory left, bool[] memory right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04c90000, 1037618709705) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04c90001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04c90005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04c96002, err) }
        vm.assertEq(left, right, err);
    }

    function assertEq(uint256[] memory left, uint256[] memory right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04ca0000, 1037618709706) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04ca0001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04ca0005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04ca6001, right) }
        vm.assertEq(left, right);
    }

    function assertEq(uint256[] memory left, uint256[] memory right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04cb0000, 1037618709707) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04cb0001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04cb0005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04cb6002, err) }
        vm.assertEq(left, right, err);
    }

    function assertEq(int256[] memory left, int256[] memory right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04c20000, 1037618709698) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04c20001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04c20005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04c26001, right) }
        vm.assertEq(left, right);
    }

    function assertEq(int256[] memory left, int256[] memory right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04c30000, 1037618709699) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04c30001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04c30005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04c36002, err) }
        vm.assertEq(left, right, err);
    }

    function assertEq(address[] memory left, address[] memory right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04c40000, 1037618709700) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04c40001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04c40005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04c46001, right) }
        vm.assertEq(left, right);
    }

    function assertEq(address[] memory left, address[] memory right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04c50000, 1037618709701) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04c50001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04c50005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04c56002, err) }
        vm.assertEq(left, right, err);
    }

    function assertEq(bytes32[] memory left, bytes32[] memory right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04c60000, 1037618709702) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04c60001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04c60005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04c66001, right) }
        vm.assertEq(left, right);
    }

    function assertEq(bytes32[] memory left, bytes32[] memory right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04c70000, 1037618709703) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04c70001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04c70005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04c76002, err) }
        vm.assertEq(left, right, err);
    }

    function assertEq(string[] memory left, string[] memory right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04c80000, 1037618709704) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04c80001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04c80005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04c86001, right) }
        vm.assertEq(left, right);
    }

    function assertEq(string[] memory left, string[] memory right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff050e0000, 1037618709774) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff050e0001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff050e0005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff050e6002, err) }
        vm.assertEq(left, right, err);
    }

    function assertEq(bytes[] memory left, bytes[] memory right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff050f0000, 1037618709775) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff050f0001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff050f0005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff050f6001, right) }
        vm.assertEq(left, right);
    }

    function assertEq(bytes[] memory left, bytes[] memory right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05100000, 1037618709776) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05100001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05100005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05106002, err) }
        vm.assertEq(left, right, err);
    }

    // Legacy helper
    function assertEqUint(uint256 left, uint256 right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05110000, 1037618709777) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05110001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05110005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05116001, right) }
        assertEq(left, right);
    }

    function assertNotEq(bool left, bool right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05120000, 1037618709778) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05120001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05120005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05126001, right) }
        vm.assertNotEq(left, right);
    }

    function assertNotEq(bool left, bool right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05130000, 1037618709779) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05130001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05130005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05136002, err) }
        vm.assertNotEq(left, right, err);
    }

    function assertNotEq(uint256 left, uint256 right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05140000, 1037618709780) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05140001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05140005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05146001, right) }
        vm.assertNotEq(left, right);
    }

    function assertNotEq(uint256 left, uint256 right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05150000, 1037618709781) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05150001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05150005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05156002, err) }
        vm.assertNotEq(left, right, err);
    }

    function assertNotEqDecimal(uint256 left, uint256 right, uint256 decimals) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05160000, 1037618709782) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05160001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05160005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05166002, decimals) }
        vm.assertNotEqDecimal(left, right, decimals);
    }

    function assertNotEqDecimal(uint256 left, uint256 right, uint256 decimals, string memory err)
        internal
        pure
        virtual
    {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04cc0000, 1037618709708) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04cc0001, 4) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04cc0005, 585) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04cc6003, err) }
        vm.assertNotEqDecimal(left, right, decimals, err);
    }

    function assertNotEq(int256 left, int256 right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04cd0000, 1037618709709) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04cd0001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04cd0005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04cd6001, right) }
        vm.assertNotEq(left, right);
    }

    function assertNotEq(int256 left, int256 right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04ce0000, 1037618709710) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04ce0001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04ce0005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04ce6002, err) }
        vm.assertNotEq(left, right, err);
    }

    function assertNotEqDecimal(int256 left, int256 right, uint256 decimals) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04cf0000, 1037618709711) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04cf0001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04cf0005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04cf6002, decimals) }
        vm.assertNotEqDecimal(left, right, decimals);
    }

    function assertNotEqDecimal(int256 left, int256 right, uint256 decimals, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04d00000, 1037618709712) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04d00001, 4) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04d00005, 585) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04d06003, err) }
        vm.assertNotEqDecimal(left, right, decimals, err);
    }

    function assertNotEq(address left, address right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04d10000, 1037618709713) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04d10001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04d10005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04d16001, right) }
        vm.assertNotEq(left, right);
    }

    function assertNotEq(address left, address right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04d20000, 1037618709714) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04d20001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04d20005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04d26002, err) }
        vm.assertNotEq(left, right, err);
    }

    function assertNotEq(bytes32 left, bytes32 right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04d30000, 1037618709715) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04d30001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04d30005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04d36001, right) }
        vm.assertNotEq(left, right);
    }

    function assertNotEq(bytes32 left, bytes32 right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04d40000, 1037618709716) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04d40001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04d40005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04d46002, err) }
        vm.assertNotEq(left, right, err);
    }

    function assertNotEq32(bytes32 left, bytes32 right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04d50000, 1037618709717) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04d50001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04d50005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04d56001, right) }
        assertNotEq(left, right);
    }

    function assertNotEq32(bytes32 left, bytes32 right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05170000, 1037618709783) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05170001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05170005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05176002, err) }
        assertNotEq(left, right, err);
    }

    function assertNotEq(string memory left, string memory right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05210000, 1037618709793) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05210001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05210005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05216001, right) }
        vm.assertNotEq(left, right);
    }

    function assertNotEq(string memory left, string memory right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05220000, 1037618709794) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05220001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05220005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05226002, err) }
        vm.assertNotEq(left, right, err);
    }

    function assertNotEq(bytes memory left, bytes memory right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05230000, 1037618709795) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05230001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05230005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05236001, right) }
        vm.assertNotEq(left, right);
    }

    function assertNotEq(bytes memory left, bytes memory right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05240000, 1037618709796) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05240001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05240005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05246002, err) }
        vm.assertNotEq(left, right, err);
    }

    function assertNotEq(bool[] memory left, bool[] memory right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05250000, 1037618709797) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05250001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05250005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05256001, right) }
        vm.assertNotEq(left, right);
    }

    function assertNotEq(bool[] memory left, bool[] memory right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05260000, 1037618709798) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05260001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05260005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05266002, err) }
        vm.assertNotEq(left, right, err);
    }

    function assertNotEq(uint256[] memory left, uint256[] memory right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05270000, 1037618709799) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05270001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05270005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05276001, right) }
        vm.assertNotEq(left, right);
    }

    function assertNotEq(uint256[] memory left, uint256[] memory right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05280000, 1037618709800) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05280001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05280005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05286002, err) }
        vm.assertNotEq(left, right, err);
    }

    function assertNotEq(int256[] memory left, int256[] memory right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05290000, 1037618709801) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05290001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05290005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05296001, right) }
        vm.assertNotEq(left, right);
    }

    function assertNotEq(int256[] memory left, int256[] memory right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff052a0000, 1037618709802) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff052a0001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff052a0005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff052a6002, err) }
        vm.assertNotEq(left, right, err);
    }

    function assertNotEq(address[] memory left, address[] memory right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff050a0000, 1037618709770) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff050a0001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff050a0005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff050a6001, right) }
        vm.assertNotEq(left, right);
    }

    function assertNotEq(address[] memory left, address[] memory right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff050b0000, 1037618709771) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff050b0001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff050b0005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff050b6002, err) }
        vm.assertNotEq(left, right, err);
    }

    function assertNotEq(bytes32[] memory left, bytes32[] memory right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff050c0000, 1037618709772) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff050c0001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff050c0005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff050c6001, right) }
        vm.assertNotEq(left, right);
    }

    function assertNotEq(bytes32[] memory left, bytes32[] memory right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff050d0000, 1037618709773) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff050d0001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff050d0005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff050d6002, err) }
        vm.assertNotEq(left, right, err);
    }

    function assertNotEq(string[] memory left, string[] memory right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05030000, 1037618709763) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05030001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05030005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05036001, right) }
        vm.assertNotEq(left, right);
    }

    function assertNotEq(string[] memory left, string[] memory right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05040000, 1037618709764) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05040001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05040005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05046002, err) }
        vm.assertNotEq(left, right, err);
    }

    function assertNotEq(bytes[] memory left, bytes[] memory right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05050000, 1037618709765) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05050001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05050005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05056001, right) }
        vm.assertNotEq(left, right);
    }

    function assertNotEq(bytes[] memory left, bytes[] memory right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05060000, 1037618709766) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05060001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05060005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05066002, err) }
        vm.assertNotEq(left, right, err);
    }

    function assertLt(uint256 left, uint256 right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05070000, 1037618709767) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05070001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05070005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05076001, right) }
        vm.assertLt(left, right);
    }

    function assertLt(uint256 left, uint256 right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05080000, 1037618709768) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05080001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05080005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05086002, err) }
        vm.assertLt(left, right, err);
    }

    function assertLtDecimal(uint256 left, uint256 right, uint256 decimals) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05090000, 1037618709769) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05090001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05090005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05096002, decimals) }
        vm.assertLtDecimal(left, right, decimals);
    }

    function assertLtDecimal(uint256 left, uint256 right, uint256 decimals, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05180000, 1037618709784) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05180001, 4) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05180005, 585) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05186003, err) }
        vm.assertLtDecimal(left, right, decimals, err);
    }

    function assertLt(int256 left, int256 right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05190000, 1037618709785) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05190001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05190005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05196001, right) }
        vm.assertLt(left, right);
    }

    function assertLt(int256 left, int256 right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff051a0000, 1037618709786) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff051a0001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff051a0005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff051a6002, err) }
        vm.assertLt(left, right, err);
    }

    function assertLtDecimal(int256 left, int256 right, uint256 decimals) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff051b0000, 1037618709787) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff051b0001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff051b0005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff051b6002, decimals) }
        vm.assertLtDecimal(left, right, decimals);
    }

    function assertLtDecimal(int256 left, int256 right, uint256 decimals, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff051c0000, 1037618709788) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff051c0001, 4) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff051c0005, 585) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff051c6003, err) }
        vm.assertLtDecimal(left, right, decimals, err);
    }

    function assertGt(uint256 left, uint256 right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff051d0000, 1037618709789) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff051d0001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff051d0005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff051d6001, right) }
        vm.assertGt(left, right);
    }

    function assertGt(uint256 left, uint256 right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff051e0000, 1037618709790) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff051e0001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff051e0005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff051e6002, err) }
        vm.assertGt(left, right, err);
    }

    function assertGtDecimal(uint256 left, uint256 right, uint256 decimals) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff051f0000, 1037618709791) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff051f0001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff051f0005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff051f6002, decimals) }
        vm.assertGtDecimal(left, right, decimals);
    }

    function assertGtDecimal(uint256 left, uint256 right, uint256 decimals, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05200000, 1037618709792) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05200001, 4) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05200005, 585) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05206003, err) }
        vm.assertGtDecimal(left, right, decimals, err);
    }

    function assertGt(int256 left, int256 right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04ef0000, 1037618709743) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04ef0001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04ef0005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04ef6001, right) }
        vm.assertGt(left, right);
    }

    function assertGt(int256 left, int256 right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04f00000, 1037618709744) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04f00001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04f00005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04f06002, err) }
        vm.assertGt(left, right, err);
    }

    function assertGtDecimal(int256 left, int256 right, uint256 decimals) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04f10000, 1037618709745) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04f10001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04f10005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04f16002, decimals) }
        vm.assertGtDecimal(left, right, decimals);
    }

    function assertGtDecimal(int256 left, int256 right, uint256 decimals, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04f20000, 1037618709746) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04f20001, 4) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04f20005, 585) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04f26003, err) }
        vm.assertGtDecimal(left, right, decimals, err);
    }

    function assertLe(uint256 left, uint256 right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04f30000, 1037618709747) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04f30001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04f30005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04f36001, right) }
        vm.assertLe(left, right);
    }

    function assertLe(uint256 left, uint256 right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04f40000, 1037618709748) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04f40001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04f40005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04f46002, err) }
        vm.assertLe(left, right, err);
    }

    function assertLeDecimal(uint256 left, uint256 right, uint256 decimals) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04f50000, 1037618709749) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04f50001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04f50005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04f56002, decimals) }
        vm.assertLeDecimal(left, right, decimals);
    }

    function assertLeDecimal(uint256 left, uint256 right, uint256 decimals, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04f60000, 1037618709750) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04f60001, 4) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04f60005, 585) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04f66003, err) }
        vm.assertLeDecimal(left, right, decimals, err);
    }

    function assertLe(int256 left, int256 right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04f70000, 1037618709751) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04f70001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04f70005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04f76001, right) }
        vm.assertLe(left, right);
    }

    function assertLe(int256 left, int256 right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04f80000, 1037618709752) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04f80001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04f80005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04f86002, err) }
        vm.assertLe(left, right, err);
    }

    function assertLeDecimal(int256 left, int256 right, uint256 decimals) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff052b0000, 1037618709803) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff052b0001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff052b0005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff052b6002, decimals) }
        vm.assertLeDecimal(left, right, decimals);
    }

    function assertLeDecimal(int256 left, int256 right, uint256 decimals, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff052c0000, 1037618709804) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff052c0001, 4) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff052c0005, 585) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff052c6003, err) }
        vm.assertLeDecimal(left, right, decimals, err);
    }

    function assertGe(uint256 left, uint256 right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff052d0000, 1037618709805) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff052d0001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff052d0005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff052d6001, right) }
        vm.assertGe(left, right);
    }

    function assertGe(uint256 left, uint256 right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff052e0000, 1037618709806) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff052e0001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff052e0005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff052e6002, err) }
        vm.assertGe(left, right, err);
    }

    function assertGeDecimal(uint256 left, uint256 right, uint256 decimals) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff052f0000, 1037618709807) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff052f0001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff052f0005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff052f6002, decimals) }
        vm.assertGeDecimal(left, right, decimals);
    }

    function assertGeDecimal(uint256 left, uint256 right, uint256 decimals, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05300000, 1037618709808) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05300001, 4) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05300005, 585) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05306003, err) }
        vm.assertGeDecimal(left, right, decimals, err);
    }

    function assertGe(int256 left, int256 right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05310000, 1037618709809) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05310001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05310005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05316001, right) }
        vm.assertGe(left, right);
    }

    function assertGe(int256 left, int256 right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05320000, 1037618709810) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05320001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05320005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05326002, err) }
        vm.assertGe(left, right, err);
    }

    function assertGeDecimal(int256 left, int256 right, uint256 decimals) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05330000, 1037618709811) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05330001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05330005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05336002, decimals) }
        vm.assertGeDecimal(left, right, decimals);
    }

    function assertGeDecimal(int256 left, int256 right, uint256 decimals, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05340000, 1037618709812) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05340001, 4) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05340005, 585) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05346003, err) }
        vm.assertGeDecimal(left, right, decimals, err);
    }

    function assertApproxEqAbs(uint256 left, uint256 right, uint256 maxDelta) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04dd0000, 1037618709725) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04dd0001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04dd0005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04dd6002, maxDelta) }
        vm.assertApproxEqAbs(left, right, maxDelta);
    }

    function assertApproxEqAbs(uint256 left, uint256 right, uint256 maxDelta, string memory err)
        internal
        pure
        virtual
    {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04de0000, 1037618709726) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04de0001, 4) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04de0005, 585) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04de6003, err) }
        vm.assertApproxEqAbs(left, right, maxDelta, err);
    }

    function assertApproxEqAbsDecimal(uint256 left, uint256 right, uint256 maxDelta, uint256 decimals)
        internal
        pure
        virtual
    {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04df0000, 1037618709727) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04df0001, 4) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04df0005, 585) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04df6003, decimals) }
        vm.assertApproxEqAbsDecimal(left, right, maxDelta, decimals);
    }

    function assertApproxEqAbsDecimal(
        uint256 left,
        uint256 right,
        uint256 maxDelta,
        uint256 decimals,
        string memory err
    ) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04e00000, 1037618709728) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04e00001, 5) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04e00005, 4681) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04e06004, err) }
        vm.assertApproxEqAbsDecimal(left, right, maxDelta, decimals, err);
    }

    function assertApproxEqAbs(int256 left, int256 right, uint256 maxDelta) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04e10000, 1037618709729) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04e10001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04e10005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04e16002, maxDelta) }
        vm.assertApproxEqAbs(left, right, maxDelta);
    }

    function assertApproxEqAbs(int256 left, int256 right, uint256 maxDelta, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04e20000, 1037618709730) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04e20001, 4) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04e20005, 585) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04e26003, err) }
        vm.assertApproxEqAbs(left, right, maxDelta, err);
    }

    function assertApproxEqAbsDecimal(int256 left, int256 right, uint256 maxDelta, uint256 decimals)
        internal
        pure
        virtual
    {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04e30000, 1037618709731) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04e30001, 4) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04e30005, 585) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04e36003, decimals) }
        vm.assertApproxEqAbsDecimal(left, right, maxDelta, decimals);
    }

    function assertApproxEqAbsDecimal(int256 left, int256 right, uint256 maxDelta, uint256 decimals, string memory err)
        internal
        pure
        virtual
    {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04e40000, 1037618709732) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04e40001, 5) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04e40005, 4681) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04e46004, err) }
        vm.assertApproxEqAbsDecimal(left, right, maxDelta, decimals, err);
    }

    function assertApproxEqRel(
        uint256 left,
        uint256 right,
        uint256 maxPercentDelta // An 18 decimal fixed point number, where 1e18 == 100%
    ) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04f90000, 1037618709753) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04f90001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04f90005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04f96002, maxPercentDelta) }
        vm.assertApproxEqRel(left, right, maxPercentDelta);
    }

    function assertApproxEqRel(
        uint256 left,
        uint256 right,
        uint256 maxPercentDelta, // An 18 decimal fixed point number, where 1e18 == 100%
        string memory err
    ) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04fa0000, 1037618709754) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04fa0001, 4) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04fa0005, 585) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04fa6003, err) }
        vm.assertApproxEqRel(left, right, maxPercentDelta, err);
    }

    function assertApproxEqRelDecimal(
        uint256 left,
        uint256 right,
        uint256 maxPercentDelta, // An 18 decimal fixed point number, where 1e18 == 100%
        uint256 decimals
    ) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04fb0000, 1037618709755) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04fb0001, 4) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04fb0005, 585) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04fb6003, decimals) }
        vm.assertApproxEqRelDecimal(left, right, maxPercentDelta, decimals);
    }

    function assertApproxEqRelDecimal(
        uint256 left,
        uint256 right,
        uint256 maxPercentDelta, // An 18 decimal fixed point number, where 1e18 == 100%
        uint256 decimals,
        string memory err
    ) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04fc0000, 1037618709756) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04fc0001, 5) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04fc0005, 4681) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04fc6004, err) }
        vm.assertApproxEqRelDecimal(left, right, maxPercentDelta, decimals, err);
    }

    function assertApproxEqRel(int256 left, int256 right, uint256 maxPercentDelta) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04fd0000, 1037618709757) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04fd0001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04fd0005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04fd6002, maxPercentDelta) }
        vm.assertApproxEqRel(left, right, maxPercentDelta);
    }

    function assertApproxEqRel(
        int256 left,
        int256 right,
        uint256 maxPercentDelta, // An 18 decimal fixed point number, where 1e18 == 100%
        string memory err
    ) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04fe0000, 1037618709758) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04fe0001, 4) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04fe0005, 585) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04fe6003, err) }
        vm.assertApproxEqRel(left, right, maxPercentDelta, err);
    }

    function assertApproxEqRelDecimal(
        int256 left,
        int256 right,
        uint256 maxPercentDelta, // An 18 decimal fixed point number, where 1e18 == 100%
        uint256 decimals
    ) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04ff0000, 1037618709759) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04ff0001, 4) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04ff0005, 585) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04ff6003, decimals) }
        vm.assertApproxEqRelDecimal(left, right, maxPercentDelta, decimals);
    }

    function assertApproxEqRelDecimal(
        int256 left,
        int256 right,
        uint256 maxPercentDelta, // An 18 decimal fixed point number, where 1e18 == 100%
        uint256 decimals,
        string memory err
    ) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05000000, 1037618709760) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05000001, 5) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05000005, 4681) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05006004, err) }
        vm.assertApproxEqRelDecimal(left, right, maxPercentDelta, decimals, err);
    }

    // Inherited from DSTest, not used but kept for backwards-compatibility
    function checkEq0(bytes memory left, bytes memory right) internal pure returns (bool) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05010000, 1037618709761) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05010001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05010005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05016001, right) }
        return keccak256(left) == keccak256(right);
    }

    function assertEq0(bytes memory left, bytes memory right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05020000, 1037618709762) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05020001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05020005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05026001, right) }
        assertEq(left, right);
    }

    function assertEq0(bytes memory left, bytes memory right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04d60000, 1037618709718) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04d60001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04d60005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04d66002, err) }
        assertEq(left, right, err);
    }

    function assertNotEq0(bytes memory left, bytes memory right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04d70000, 1037618709719) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04d70001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04d70005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04d76001, right) }
        assertNotEq(left, right);
    }

    function assertNotEq0(bytes memory left, bytes memory right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04d80000, 1037618709720) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04d80001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04d80005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04d86002, err) }
        assertNotEq(left, right, err);
    }

    function assertEqCall(address target, bytes memory callDataA, bytes memory callDataB) internal virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04d90000, 1037618709721) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04d90001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04d90005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04d96002, callDataB) }
        assertEqCall(target, callDataA, target, callDataB, true);
    }

    function assertEqCall(address targetA, bytes memory callDataA, address targetB, bytes memory callDataB)
        internal
        virtual
    {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04da0000, 1037618709722) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04da0001, 4) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04da0005, 585) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04da6003, callDataB) }
        assertEqCall(targetA, callDataA, targetB, callDataB, true);
    }

    function assertEqCall(address target, bytes memory callDataA, bytes memory callDataB, bool strictRevertData)
        internal
        virtual
    {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04db0000, 1037618709723) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04db0001, 4) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04db0005, 585) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04db6003, strictRevertData) }
        assertEqCall(target, callDataA, target, callDataB, strictRevertData);
    }

    function assertEqCall(
        address targetA,
        bytes memory callDataA,
        address targetB,
        bytes memory callDataB,
        bool strictRevertData
    ) internal virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04dc0000, 1037618709724) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04dc0001, 5) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04dc0005, 4681) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04dc6004, strictRevertData) }
        (bool successA, bytes memory returnDataA) = address(targetA).call(callDataA);
        (bool successB, bytes memory returnDataB) = address(targetB).call(callDataB);

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
