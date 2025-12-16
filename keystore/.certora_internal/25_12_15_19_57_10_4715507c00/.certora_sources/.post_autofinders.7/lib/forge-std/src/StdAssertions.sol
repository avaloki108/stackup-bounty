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

    function failed() public view returns (bool) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c070000, 1037618711559) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c070001, 0) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c070004, 0) }
        if (_failed) {
            return _failed;
        } else {
            return vm.load(address(vm), bytes32("failed")) != bytes32(0);
        }
    }

    function fail() internal virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c0f0000, 1037618711567) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c0f0001, 0) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c0f0004, 0) }
        vm.store(address(vm), bytes32("failed"), bytes32(uint256(1)));
        _failed = true;
    }

    function assertTrue(bool data) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c100000, 1037618711568) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c100001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c100005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c106000, data) }
        vm.assertTrue(data);
    }

    function assertTrue(bool data, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c120000, 1037618711570) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c120001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c120005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c126001, err) }
        vm.assertTrue(data, err);
    }

    function assertFalse(bool data) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c130000, 1037618711571) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c130001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c130005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c136000, data) }
        vm.assertFalse(data);
    }

    function assertFalse(bool data, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c110000, 1037618711569) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c110001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c110005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c116001, err) }
        vm.assertFalse(data, err);
    }

    function assertEq(bool left, bool right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c140000, 1037618711572) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c140001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c140005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c146001, right) }
        vm.assertEq(left, right);
    }

    function assertEq(bool left, bool right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c150000, 1037618711573) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c150001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c150005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c156002, err) }
        vm.assertEq(left, right, err);
    }

    function assertEq(uint256 left, uint256 right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c160000, 1037618711574) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c160001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c160005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c166001, right) }
        vm.assertEq(left, right);
    }

    function assertEq(uint256 left, uint256 right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c170000, 1037618711575) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c170001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c170005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c176002, err) }
        vm.assertEq(left, right, err);
    }

    function assertEqDecimal(uint256 left, uint256 right, uint256 decimals) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c180000, 1037618711576) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c180001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c180005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c186002, decimals) }
        vm.assertEqDecimal(left, right, decimals);
    }

    function assertEqDecimal(uint256 left, uint256 right, uint256 decimals, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c190000, 1037618711577) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c190001, 4) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c190005, 585) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c196003, err) }
        vm.assertEqDecimal(left, right, decimals, err);
    }

    function assertEq(int256 left, int256 right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c1a0000, 1037618711578) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c1a0001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c1a0005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c1a6001, right) }
        vm.assertEq(left, right);
    }

    function assertEq(int256 left, int256 right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c1b0000, 1037618711579) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c1b0001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c1b0005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c1b6002, err) }
        vm.assertEq(left, right, err);
    }

    function assertEqDecimal(int256 left, int256 right, uint256 decimals) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c1c0000, 1037618711580) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c1c0001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c1c0005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c1c6002, decimals) }
        vm.assertEqDecimal(left, right, decimals);
    }

    function assertEqDecimal(int256 left, int256 right, uint256 decimals, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c1d0000, 1037618711581) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c1d0001, 4) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c1d0005, 585) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c1d6003, err) }
        vm.assertEqDecimal(left, right, decimals, err);
    }

    function assertEq(address left, address right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c1e0000, 1037618711582) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c1e0001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c1e0005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c1e6001, right) }
        vm.assertEq(left, right);
    }

    function assertEq(address left, address right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c440000, 1037618711620) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c440001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c440005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c446002, err) }
        vm.assertEq(left, right, err);
    }

    function assertEq(bytes32 left, bytes32 right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c430000, 1037618711619) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c430001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c430005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c436001, right) }
        vm.assertEq(left, right);
    }

    function assertEq(bytes32 left, bytes32 right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c420000, 1037618711618) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c420001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c420005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c426002, err) }
        vm.assertEq(left, right, err);
    }

    function assertEq32(bytes32 left, bytes32 right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c450000, 1037618711621) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c450001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c450005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c456001, right) }
        assertEq(left, right);
    }

    function assertEq32(bytes32 left, bytes32 right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c460000, 1037618711622) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c460001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c460005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c466002, err) }
        assertEq(left, right, err);
    }

    function assertEq(string memory left, string memory right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c470000, 1037618711623) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c470001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c470005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c476001, right) }
        vm.assertEq(left, right);
    }

    function assertEq(string memory left, string memory right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c480000, 1037618711624) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c480001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c480005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c486002, err) }
        vm.assertEq(left, right, err);
    }

    function assertEq(bytes memory left, bytes memory right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c490000, 1037618711625) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c490001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c490005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c496001, right) }
        vm.assertEq(left, right);
    }

    function assertEq(bytes memory left, bytes memory right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c4a0000, 1037618711626) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c4a0001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c4a0005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c4a6002, err) }
        vm.assertEq(left, right, err);
    }

    function assertEq(bool[] memory left, bool[] memory right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c4b0000, 1037618711627) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c4b0001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c4b0005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c4b6001, right) }
        vm.assertEq(left, right);
    }

    function assertEq(bool[] memory left, bool[] memory right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c260000, 1037618711590) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c260001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c260005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c266002, err) }
        vm.assertEq(left, right, err);
    }

    function assertEq(uint256[] memory left, uint256[] memory right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c270000, 1037618711591) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c270001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c270005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c276001, right) }
        vm.assertEq(left, right);
    }

    function assertEq(uint256[] memory left, uint256[] memory right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c280000, 1037618711592) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c280001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c280005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c286002, err) }
        vm.assertEq(left, right, err);
    }

    function assertEq(int256[] memory left, int256[] memory right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c1f0000, 1037618711583) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c1f0001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c1f0005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c1f6001, right) }
        vm.assertEq(left, right);
    }

    function assertEq(int256[] memory left, int256[] memory right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c200000, 1037618711584) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c200001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c200005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c206002, err) }
        vm.assertEq(left, right, err);
    }

    function assertEq(address[] memory left, address[] memory right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c210000, 1037618711585) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c210001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c210005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c216001, right) }
        vm.assertEq(left, right);
    }

    function assertEq(address[] memory left, address[] memory right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c220000, 1037618711586) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c220001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c220005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c226002, err) }
        vm.assertEq(left, right, err);
    }

    function assertEq(bytes32[] memory left, bytes32[] memory right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c230000, 1037618711587) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c230001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c230005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c236001, right) }
        vm.assertEq(left, right);
    }

    function assertEq(bytes32[] memory left, bytes32[] memory right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c240000, 1037618711588) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c240001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c240005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c246002, err) }
        vm.assertEq(left, right, err);
    }

    function assertEq(string[] memory left, string[] memory right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c250000, 1037618711589) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c250001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c250005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c256001, right) }
        vm.assertEq(left, right);
    }

    function assertEq(string[] memory left, string[] memory right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c6b0000, 1037618711659) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c6b0001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c6b0005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c6b6002, err) }
        vm.assertEq(left, right, err);
    }

    function assertEq(bytes[] memory left, bytes[] memory right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c6c0000, 1037618711660) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c6c0001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c6c0005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c6c6001, right) }
        vm.assertEq(left, right);
    }

    function assertEq(bytes[] memory left, bytes[] memory right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c6d0000, 1037618711661) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c6d0001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c6d0005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c6d6002, err) }
        vm.assertEq(left, right, err);
    }

    // Legacy helper
    function assertEqUint(uint256 left, uint256 right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c6e0000, 1037618711662) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c6e0001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c6e0005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c6e6001, right) }
        assertEq(left, right);
    }

    function assertNotEq(bool left, bool right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c6f0000, 1037618711663) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c6f0001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c6f0005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c6f6001, right) }
        vm.assertNotEq(left, right);
    }

    function assertNotEq(bool left, bool right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c700000, 1037618711664) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c700001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c700005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c706002, err) }
        vm.assertNotEq(left, right, err);
    }

    function assertNotEq(uint256 left, uint256 right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c710000, 1037618711665) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c710001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c710005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c716001, right) }
        vm.assertNotEq(left, right);
    }

    function assertNotEq(uint256 left, uint256 right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c720000, 1037618711666) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c720001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c720005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c726002, err) }
        vm.assertNotEq(left, right, err);
    }

    function assertNotEqDecimal(uint256 left, uint256 right, uint256 decimals) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c730000, 1037618711667) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c730001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c730005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c736002, decimals) }
        vm.assertNotEqDecimal(left, right, decimals);
    }

    function assertNotEqDecimal(uint256 left, uint256 right, uint256 decimals, string memory err)
        internal
        pure
        virtual
    {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c290000, 1037618711593) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c290001, 4) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c290005, 585) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c296003, err) }
        vm.assertNotEqDecimal(left, right, decimals, err);
    }

    function assertNotEq(int256 left, int256 right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c2a0000, 1037618711594) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c2a0001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c2a0005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c2a6001, right) }
        vm.assertNotEq(left, right);
    }

    function assertNotEq(int256 left, int256 right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c2b0000, 1037618711595) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c2b0001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c2b0005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c2b6002, err) }
        vm.assertNotEq(left, right, err);
    }

    function assertNotEqDecimal(int256 left, int256 right, uint256 decimals) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c2c0000, 1037618711596) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c2c0001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c2c0005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c2c6002, decimals) }
        vm.assertNotEqDecimal(left, right, decimals);
    }

    function assertNotEqDecimal(int256 left, int256 right, uint256 decimals, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c2d0000, 1037618711597) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c2d0001, 4) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c2d0005, 585) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c2d6003, err) }
        vm.assertNotEqDecimal(left, right, decimals, err);
    }

    function assertNotEq(address left, address right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c2e0000, 1037618711598) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c2e0001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c2e0005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c2e6001, right) }
        vm.assertNotEq(left, right);
    }

    function assertNotEq(address left, address right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c2f0000, 1037618711599) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c2f0001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c2f0005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c2f6002, err) }
        vm.assertNotEq(left, right, err);
    }

    function assertNotEq(bytes32 left, bytes32 right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c300000, 1037618711600) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c300001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c300005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c306001, right) }
        vm.assertNotEq(left, right);
    }

    function assertNotEq(bytes32 left, bytes32 right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c310000, 1037618711601) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c310001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c310005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c316002, err) }
        vm.assertNotEq(left, right, err);
    }

    function assertNotEq32(bytes32 left, bytes32 right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c320000, 1037618711602) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c320001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c320005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c326001, right) }
        assertNotEq(left, right);
    }

    function assertNotEq32(bytes32 left, bytes32 right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c740000, 1037618711668) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c740001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c740005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c746002, err) }
        assertNotEq(left, right, err);
    }

    function assertNotEq(string memory left, string memory right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c7e0000, 1037618711678) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c7e0001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c7e0005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c7e6001, right) }
        vm.assertNotEq(left, right);
    }

    function assertNotEq(string memory left, string memory right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c7f0000, 1037618711679) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c7f0001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c7f0005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c7f6002, err) }
        vm.assertNotEq(left, right, err);
    }

    function assertNotEq(bytes memory left, bytes memory right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c800000, 1037618711680) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c800001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c800005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c806001, right) }
        vm.assertNotEq(left, right);
    }

    function assertNotEq(bytes memory left, bytes memory right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c810000, 1037618711681) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c810001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c810005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c816002, err) }
        vm.assertNotEq(left, right, err);
    }

    function assertNotEq(bool[] memory left, bool[] memory right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c820000, 1037618711682) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c820001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c820005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c826001, right) }
        vm.assertNotEq(left, right);
    }

    function assertNotEq(bool[] memory left, bool[] memory right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c830000, 1037618711683) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c830001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c830005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c836002, err) }
        vm.assertNotEq(left, right, err);
    }

    function assertNotEq(uint256[] memory left, uint256[] memory right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c840000, 1037618711684) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c840001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c840005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c846001, right) }
        vm.assertNotEq(left, right);
    }

    function assertNotEq(uint256[] memory left, uint256[] memory right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c850000, 1037618711685) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c850001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c850005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c856002, err) }
        vm.assertNotEq(left, right, err);
    }

    function assertNotEq(int256[] memory left, int256[] memory right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c860000, 1037618711686) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c860001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c860005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c866001, right) }
        vm.assertNotEq(left, right);
    }

    function assertNotEq(int256[] memory left, int256[] memory right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c870000, 1037618711687) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c870001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c870005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c876002, err) }
        vm.assertNotEq(left, right, err);
    }

    function assertNotEq(address[] memory left, address[] memory right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c670000, 1037618711655) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c670001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c670005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c676001, right) }
        vm.assertNotEq(left, right);
    }

    function assertNotEq(address[] memory left, address[] memory right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c680000, 1037618711656) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c680001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c680005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c686002, err) }
        vm.assertNotEq(left, right, err);
    }

    function assertNotEq(bytes32[] memory left, bytes32[] memory right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c690000, 1037618711657) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c690001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c690005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c696001, right) }
        vm.assertNotEq(left, right);
    }

    function assertNotEq(bytes32[] memory left, bytes32[] memory right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c6a0000, 1037618711658) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c6a0001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c6a0005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c6a6002, err) }
        vm.assertNotEq(left, right, err);
    }

    function assertNotEq(string[] memory left, string[] memory right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c600000, 1037618711648) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c600001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c600005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c606001, right) }
        vm.assertNotEq(left, right);
    }

    function assertNotEq(string[] memory left, string[] memory right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c610000, 1037618711649) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c610001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c610005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c616002, err) }
        vm.assertNotEq(left, right, err);
    }

    function assertNotEq(bytes[] memory left, bytes[] memory right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c620000, 1037618711650) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c620001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c620005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c626001, right) }
        vm.assertNotEq(left, right);
    }

    function assertNotEq(bytes[] memory left, bytes[] memory right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c630000, 1037618711651) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c630001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c630005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c636002, err) }
        vm.assertNotEq(left, right, err);
    }

    function assertLt(uint256 left, uint256 right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c640000, 1037618711652) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c640001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c640005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c646001, right) }
        vm.assertLt(left, right);
    }

    function assertLt(uint256 left, uint256 right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c650000, 1037618711653) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c650001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c650005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c656002, err) }
        vm.assertLt(left, right, err);
    }

    function assertLtDecimal(uint256 left, uint256 right, uint256 decimals) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c660000, 1037618711654) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c660001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c660005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c666002, decimals) }
        vm.assertLtDecimal(left, right, decimals);
    }

    function assertLtDecimal(uint256 left, uint256 right, uint256 decimals, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c750000, 1037618711669) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c750001, 4) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c750005, 585) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c756003, err) }
        vm.assertLtDecimal(left, right, decimals, err);
    }

    function assertLt(int256 left, int256 right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c760000, 1037618711670) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c760001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c760005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c766001, right) }
        vm.assertLt(left, right);
    }

    function assertLt(int256 left, int256 right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c770000, 1037618711671) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c770001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c770005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c776002, err) }
        vm.assertLt(left, right, err);
    }

    function assertLtDecimal(int256 left, int256 right, uint256 decimals) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c780000, 1037618711672) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c780001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c780005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c786002, decimals) }
        vm.assertLtDecimal(left, right, decimals);
    }

    function assertLtDecimal(int256 left, int256 right, uint256 decimals, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c790000, 1037618711673) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c790001, 4) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c790005, 585) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c796003, err) }
        vm.assertLtDecimal(left, right, decimals, err);
    }

    function assertGt(uint256 left, uint256 right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c7a0000, 1037618711674) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c7a0001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c7a0005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c7a6001, right) }
        vm.assertGt(left, right);
    }

    function assertGt(uint256 left, uint256 right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c7b0000, 1037618711675) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c7b0001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c7b0005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c7b6002, err) }
        vm.assertGt(left, right, err);
    }

    function assertGtDecimal(uint256 left, uint256 right, uint256 decimals) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c7c0000, 1037618711676) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c7c0001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c7c0005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c7c6002, decimals) }
        vm.assertGtDecimal(left, right, decimals);
    }

    function assertGtDecimal(uint256 left, uint256 right, uint256 decimals, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c7d0000, 1037618711677) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c7d0001, 4) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c7d0005, 585) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c7d6003, err) }
        vm.assertGtDecimal(left, right, decimals, err);
    }

    function assertGt(int256 left, int256 right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c4c0000, 1037618711628) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c4c0001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c4c0005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c4c6001, right) }
        vm.assertGt(left, right);
    }

    function assertGt(int256 left, int256 right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c4d0000, 1037618711629) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c4d0001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c4d0005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c4d6002, err) }
        vm.assertGt(left, right, err);
    }

    function assertGtDecimal(int256 left, int256 right, uint256 decimals) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c4e0000, 1037618711630) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c4e0001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c4e0005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c4e6002, decimals) }
        vm.assertGtDecimal(left, right, decimals);
    }

    function assertGtDecimal(int256 left, int256 right, uint256 decimals, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c4f0000, 1037618711631) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c4f0001, 4) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c4f0005, 585) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c4f6003, err) }
        vm.assertGtDecimal(left, right, decimals, err);
    }

    function assertLe(uint256 left, uint256 right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c500000, 1037618711632) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c500001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c500005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c506001, right) }
        vm.assertLe(left, right);
    }

    function assertLe(uint256 left, uint256 right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c510000, 1037618711633) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c510001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c510005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c516002, err) }
        vm.assertLe(left, right, err);
    }

    function assertLeDecimal(uint256 left, uint256 right, uint256 decimals) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c520000, 1037618711634) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c520001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c520005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c526002, decimals) }
        vm.assertLeDecimal(left, right, decimals);
    }

    function assertLeDecimal(uint256 left, uint256 right, uint256 decimals, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c530000, 1037618711635) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c530001, 4) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c530005, 585) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c536003, err) }
        vm.assertLeDecimal(left, right, decimals, err);
    }

    function assertLe(int256 left, int256 right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c540000, 1037618711636) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c540001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c540005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c546001, right) }
        vm.assertLe(left, right);
    }

    function assertLe(int256 left, int256 right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c550000, 1037618711637) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c550001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c550005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c556002, err) }
        vm.assertLe(left, right, err);
    }

    function assertLeDecimal(int256 left, int256 right, uint256 decimals) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c880000, 1037618711688) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c880001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c880005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c886002, decimals) }
        vm.assertLeDecimal(left, right, decimals);
    }

    function assertLeDecimal(int256 left, int256 right, uint256 decimals, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c890000, 1037618711689) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c890001, 4) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c890005, 585) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c896003, err) }
        vm.assertLeDecimal(left, right, decimals, err);
    }

    function assertGe(uint256 left, uint256 right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c8a0000, 1037618711690) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c8a0001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c8a0005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c8a6001, right) }
        vm.assertGe(left, right);
    }

    function assertGe(uint256 left, uint256 right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c8b0000, 1037618711691) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c8b0001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c8b0005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c8b6002, err) }
        vm.assertGe(left, right, err);
    }

    function assertGeDecimal(uint256 left, uint256 right, uint256 decimals) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c8c0000, 1037618711692) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c8c0001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c8c0005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c8c6002, decimals) }
        vm.assertGeDecimal(left, right, decimals);
    }

    function assertGeDecimal(uint256 left, uint256 right, uint256 decimals, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c8d0000, 1037618711693) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c8d0001, 4) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c8d0005, 585) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c8d6003, err) }
        vm.assertGeDecimal(left, right, decimals, err);
    }

    function assertGe(int256 left, int256 right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c8e0000, 1037618711694) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c8e0001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c8e0005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c8e6001, right) }
        vm.assertGe(left, right);
    }

    function assertGe(int256 left, int256 right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c8f0000, 1037618711695) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c8f0001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c8f0005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c8f6002, err) }
        vm.assertGe(left, right, err);
    }

    function assertGeDecimal(int256 left, int256 right, uint256 decimals) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c900000, 1037618711696) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c900001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c900005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c906002, decimals) }
        vm.assertGeDecimal(left, right, decimals);
    }

    function assertGeDecimal(int256 left, int256 right, uint256 decimals, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c910000, 1037618711697) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c910001, 4) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c910005, 585) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c916003, err) }
        vm.assertGeDecimal(left, right, decimals, err);
    }

    function assertApproxEqAbs(uint256 left, uint256 right, uint256 maxDelta) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c3a0000, 1037618711610) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c3a0001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c3a0005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c3a6002, maxDelta) }
        vm.assertApproxEqAbs(left, right, maxDelta);
    }

    function assertApproxEqAbs(uint256 left, uint256 right, uint256 maxDelta, string memory err)
        internal
        pure
        virtual
    {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c3b0000, 1037618711611) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c3b0001, 4) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c3b0005, 585) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c3b6003, err) }
        vm.assertApproxEqAbs(left, right, maxDelta, err);
    }

    function assertApproxEqAbsDecimal(uint256 left, uint256 right, uint256 maxDelta, uint256 decimals)
        internal
        pure
        virtual
    {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c3c0000, 1037618711612) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c3c0001, 4) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c3c0005, 585) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c3c6003, decimals) }
        vm.assertApproxEqAbsDecimal(left, right, maxDelta, decimals);
    }

    function assertApproxEqAbsDecimal(
        uint256 left,
        uint256 right,
        uint256 maxDelta,
        uint256 decimals,
        string memory err
    ) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c3d0000, 1037618711613) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c3d0001, 5) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c3d0005, 4681) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c3d6004, err) }
        vm.assertApproxEqAbsDecimal(left, right, maxDelta, decimals, err);
    }

    function assertApproxEqAbs(int256 left, int256 right, uint256 maxDelta) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c3e0000, 1037618711614) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c3e0001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c3e0005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c3e6002, maxDelta) }
        vm.assertApproxEqAbs(left, right, maxDelta);
    }

    function assertApproxEqAbs(int256 left, int256 right, uint256 maxDelta, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c3f0000, 1037618711615) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c3f0001, 4) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c3f0005, 585) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c3f6003, err) }
        vm.assertApproxEqAbs(left, right, maxDelta, err);
    }

    function assertApproxEqAbsDecimal(int256 left, int256 right, uint256 maxDelta, uint256 decimals)
        internal
        pure
        virtual
    {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c400000, 1037618711616) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c400001, 4) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c400005, 585) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c406003, decimals) }
        vm.assertApproxEqAbsDecimal(left, right, maxDelta, decimals);
    }

    function assertApproxEqAbsDecimal(int256 left, int256 right, uint256 maxDelta, uint256 decimals, string memory err)
        internal
        pure
        virtual
    {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c410000, 1037618711617) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c410001, 5) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c410005, 4681) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c416004, err) }
        vm.assertApproxEqAbsDecimal(left, right, maxDelta, decimals, err);
    }

    function assertApproxEqRel(
        uint256 left,
        uint256 right,
        uint256 maxPercentDelta // An 18 decimal fixed point number, where 1e18 == 100%
    ) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c560000, 1037618711638) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c560001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c560005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c566002, maxPercentDelta) }
        vm.assertApproxEqRel(left, right, maxPercentDelta);
    }

    function assertApproxEqRel(
        uint256 left,
        uint256 right,
        uint256 maxPercentDelta, // An 18 decimal fixed point number, where 1e18 == 100%
        string memory err
    ) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c570000, 1037618711639) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c570001, 4) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c570005, 585) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c576003, err) }
        vm.assertApproxEqRel(left, right, maxPercentDelta, err);
    }

    function assertApproxEqRelDecimal(
        uint256 left,
        uint256 right,
        uint256 maxPercentDelta, // An 18 decimal fixed point number, where 1e18 == 100%
        uint256 decimals
    ) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c580000, 1037618711640) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c580001, 4) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c580005, 585) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c586003, decimals) }
        vm.assertApproxEqRelDecimal(left, right, maxPercentDelta, decimals);
    }

    function assertApproxEqRelDecimal(
        uint256 left,
        uint256 right,
        uint256 maxPercentDelta, // An 18 decimal fixed point number, where 1e18 == 100%
        uint256 decimals,
        string memory err
    ) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c590000, 1037618711641) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c590001, 5) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c590005, 4681) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c596004, err) }
        vm.assertApproxEqRelDecimal(left, right, maxPercentDelta, decimals, err);
    }

    function assertApproxEqRel(int256 left, int256 right, uint256 maxPercentDelta) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c5a0000, 1037618711642) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c5a0001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c5a0005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c5a6002, maxPercentDelta) }
        vm.assertApproxEqRel(left, right, maxPercentDelta);
    }

    function assertApproxEqRel(
        int256 left,
        int256 right,
        uint256 maxPercentDelta, // An 18 decimal fixed point number, where 1e18 == 100%
        string memory err
    ) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c5b0000, 1037618711643) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c5b0001, 4) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c5b0005, 585) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c5b6003, err) }
        vm.assertApproxEqRel(left, right, maxPercentDelta, err);
    }

    function assertApproxEqRelDecimal(
        int256 left,
        int256 right,
        uint256 maxPercentDelta, // An 18 decimal fixed point number, where 1e18 == 100%
        uint256 decimals
    ) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c5c0000, 1037618711644) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c5c0001, 4) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c5c0005, 585) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c5c6003, decimals) }
        vm.assertApproxEqRelDecimal(left, right, maxPercentDelta, decimals);
    }

    function assertApproxEqRelDecimal(
        int256 left,
        int256 right,
        uint256 maxPercentDelta, // An 18 decimal fixed point number, where 1e18 == 100%
        uint256 decimals,
        string memory err
    ) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c5d0000, 1037618711645) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c5d0001, 5) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c5d0005, 4681) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c5d6004, err) }
        vm.assertApproxEqRelDecimal(left, right, maxPercentDelta, decimals, err);
    }

    // Inherited from DSTest, not used but kept for backwards-compatibility
    function checkEq0(bytes memory left, bytes memory right) internal pure returns (bool) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c5e0000, 1037618711646) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c5e0001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c5e0005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c5e6001, right) }
        return keccak256(left) == keccak256(right);
    }

    function assertEq0(bytes memory left, bytes memory right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c5f0000, 1037618711647) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c5f0001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c5f0005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c5f6001, right) }
        assertEq(left, right);
    }

    function assertEq0(bytes memory left, bytes memory right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c330000, 1037618711603) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c330001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c330005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c336002, err) }
        assertEq(left, right, err);
    }

    function assertNotEq0(bytes memory left, bytes memory right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c340000, 1037618711604) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c340001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c340005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c346001, right) }
        assertNotEq(left, right);
    }

    function assertNotEq0(bytes memory left, bytes memory right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c350000, 1037618711605) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c350001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c350005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c356002, err) }
        assertNotEq(left, right, err);
    }

    function assertEqCall(address target, bytes memory callDataA, bytes memory callDataB) internal virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c360000, 1037618711606) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c360001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c360005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c366002, callDataB) }
        assertEqCall(target, callDataA, target, callDataB, true);
    }

    function assertEqCall(address targetA, bytes memory callDataA, address targetB, bytes memory callDataB)
        internal
        virtual
    {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c370000, 1037618711607) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c370001, 4) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c370005, 585) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c376003, callDataB) }
        assertEqCall(targetA, callDataA, targetB, callDataB, true);
    }

    function assertEqCall(address target, bytes memory callDataA, bytes memory callDataB, bool strictRevertData)
        internal
        virtual
    {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c380000, 1037618711608) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c380001, 4) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c380005, 585) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c386003, strictRevertData) }
        assertEqCall(target, callDataA, target, callDataB, strictRevertData);
    }

    function assertEqCall(
        address targetA,
        bytes memory callDataA,
        address targetB,
        bytes memory callDataB,
        bool strictRevertData
    ) internal virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c390000, 1037618711609) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c390001, 5) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c390005, 4681) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c396004, strictRevertData) }
        (bool successA, bytes memory returnDataA) = address(targetA).call(callDataA);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00010046,0)}
        (bool successB, bytes memory returnDataB) = address(targetB).call(callDataB);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00010047,0)}

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
