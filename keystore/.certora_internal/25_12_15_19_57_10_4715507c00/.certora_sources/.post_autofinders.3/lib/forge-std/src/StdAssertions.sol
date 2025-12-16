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

    function failed() public view returns (bool) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06260000, 1037618710054) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06260001, 0) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06260004, 0) }
        if (_failed) {
            return _failed;
        } else {
            return vm.load(address(vm), bytes32("failed")) != bytes32(0);
        }
    }

    function fail() internal virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06330000, 1037618710067) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06330001, 0) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06330004, 0) }
        vm.store(address(vm), bytes32("failed"), bytes32(uint256(1)));
        _failed = true;
    }

    function assertTrue(bool data) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06340000, 1037618710068) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06340001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06340005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06346000, data) }
        vm.assertTrue(data);
    }

    function assertTrue(bool data, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06360000, 1037618710070) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06360001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06360005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06366001, err) }
        vm.assertTrue(data, err);
    }

    function assertFalse(bool data) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06370000, 1037618710071) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06370001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06370005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06376000, data) }
        vm.assertFalse(data);
    }

    function assertFalse(bool data, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06350000, 1037618710069) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06350001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06350005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06356001, err) }
        vm.assertFalse(data, err);
    }

    function assertEq(bool left, bool right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06380000, 1037618710072) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06380001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06380005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06386001, right) }
        vm.assertEq(left, right);
    }

    function assertEq(bool left, bool right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06390000, 1037618710073) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06390001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06390005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06396002, err) }
        vm.assertEq(left, right, err);
    }

    function assertEq(uint256 left, uint256 right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff063a0000, 1037618710074) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff063a0001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff063a0005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff063a6001, right) }
        vm.assertEq(left, right);
    }

    function assertEq(uint256 left, uint256 right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff063b0000, 1037618710075) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff063b0001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff063b0005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff063b6002, err) }
        vm.assertEq(left, right, err);
    }

    function assertEqDecimal(uint256 left, uint256 right, uint256 decimals) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff063c0000, 1037618710076) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff063c0001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff063c0005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff063c6002, decimals) }
        vm.assertEqDecimal(left, right, decimals);
    }

    function assertEqDecimal(uint256 left, uint256 right, uint256 decimals, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff063d0000, 1037618710077) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff063d0001, 4) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff063d0005, 585) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff063d6003, err) }
        vm.assertEqDecimal(left, right, decimals, err);
    }

    function assertEq(int256 left, int256 right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff063e0000, 1037618710078) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff063e0001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff063e0005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff063e6001, right) }
        vm.assertEq(left, right);
    }

    function assertEq(int256 left, int256 right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff063f0000, 1037618710079) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff063f0001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff063f0005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff063f6002, err) }
        vm.assertEq(left, right, err);
    }

    function assertEqDecimal(int256 left, int256 right, uint256 decimals) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06400000, 1037618710080) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06400001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06400005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06406002, decimals) }
        vm.assertEqDecimal(left, right, decimals);
    }

    function assertEqDecimal(int256 left, int256 right, uint256 decimals, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06410000, 1037618710081) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06410001, 4) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06410005, 585) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06416003, err) }
        vm.assertEqDecimal(left, right, decimals, err);
    }

    function assertEq(address left, address right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06420000, 1037618710082) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06420001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06420005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06426001, right) }
        vm.assertEq(left, right);
    }

    function assertEq(address left, address right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06680000, 1037618710120) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06680001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06680005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06686002, err) }
        vm.assertEq(left, right, err);
    }

    function assertEq(bytes32 left, bytes32 right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06670000, 1037618710119) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06670001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06670005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06676001, right) }
        vm.assertEq(left, right);
    }

    function assertEq(bytes32 left, bytes32 right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06660000, 1037618710118) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06660001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06660005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06666002, err) }
        vm.assertEq(left, right, err);
    }

    function assertEq32(bytes32 left, bytes32 right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06690000, 1037618710121) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06690001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06690005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06696001, right) }
        assertEq(left, right);
    }

    function assertEq32(bytes32 left, bytes32 right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff066a0000, 1037618710122) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff066a0001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff066a0005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff066a6002, err) }
        assertEq(left, right, err);
    }

    function assertEq(string memory left, string memory right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff066b0000, 1037618710123) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff066b0001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff066b0005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff066b6001, right) }
        vm.assertEq(left, right);
    }

    function assertEq(string memory left, string memory right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff066c0000, 1037618710124) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff066c0001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff066c0005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff066c6002, err) }
        vm.assertEq(left, right, err);
    }

    function assertEq(bytes memory left, bytes memory right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff066d0000, 1037618710125) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff066d0001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff066d0005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff066d6001, right) }
        vm.assertEq(left, right);
    }

    function assertEq(bytes memory left, bytes memory right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff066e0000, 1037618710126) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff066e0001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff066e0005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff066e6002, err) }
        vm.assertEq(left, right, err);
    }

    function assertEq(bool[] memory left, bool[] memory right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff066f0000, 1037618710127) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff066f0001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff066f0005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff066f6001, right) }
        vm.assertEq(left, right);
    }

    function assertEq(bool[] memory left, bool[] memory right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff064a0000, 1037618710090) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff064a0001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff064a0005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff064a6002, err) }
        vm.assertEq(left, right, err);
    }

    function assertEq(uint256[] memory left, uint256[] memory right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff064b0000, 1037618710091) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff064b0001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff064b0005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff064b6001, right) }
        vm.assertEq(left, right);
    }

    function assertEq(uint256[] memory left, uint256[] memory right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff064c0000, 1037618710092) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff064c0001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff064c0005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff064c6002, err) }
        vm.assertEq(left, right, err);
    }

    function assertEq(int256[] memory left, int256[] memory right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06430000, 1037618710083) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06430001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06430005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06436001, right) }
        vm.assertEq(left, right);
    }

    function assertEq(int256[] memory left, int256[] memory right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06440000, 1037618710084) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06440001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06440005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06446002, err) }
        vm.assertEq(left, right, err);
    }

    function assertEq(address[] memory left, address[] memory right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06450000, 1037618710085) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06450001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06450005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06456001, right) }
        vm.assertEq(left, right);
    }

    function assertEq(address[] memory left, address[] memory right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06460000, 1037618710086) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06460001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06460005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06466002, err) }
        vm.assertEq(left, right, err);
    }

    function assertEq(bytes32[] memory left, bytes32[] memory right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06470000, 1037618710087) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06470001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06470005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06476001, right) }
        vm.assertEq(left, right);
    }

    function assertEq(bytes32[] memory left, bytes32[] memory right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06480000, 1037618710088) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06480001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06480005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06486002, err) }
        vm.assertEq(left, right, err);
    }

    function assertEq(string[] memory left, string[] memory right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06490000, 1037618710089) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06490001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06490005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06496001, right) }
        vm.assertEq(left, right);
    }

    function assertEq(string[] memory left, string[] memory right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff068f0000, 1037618710159) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff068f0001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff068f0005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff068f6002, err) }
        vm.assertEq(left, right, err);
    }

    function assertEq(bytes[] memory left, bytes[] memory right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06900000, 1037618710160) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06900001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06900005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06906001, right) }
        vm.assertEq(left, right);
    }

    function assertEq(bytes[] memory left, bytes[] memory right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06910000, 1037618710161) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06910001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06910005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06916002, err) }
        vm.assertEq(left, right, err);
    }

    // Legacy helper
    function assertEqUint(uint256 left, uint256 right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06920000, 1037618710162) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06920001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06920005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06926001, right) }
        assertEq(left, right);
    }

    function assertNotEq(bool left, bool right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06930000, 1037618710163) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06930001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06930005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06936001, right) }
        vm.assertNotEq(left, right);
    }

    function assertNotEq(bool left, bool right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06940000, 1037618710164) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06940001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06940005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06946002, err) }
        vm.assertNotEq(left, right, err);
    }

    function assertNotEq(uint256 left, uint256 right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06950000, 1037618710165) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06950001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06950005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06956001, right) }
        vm.assertNotEq(left, right);
    }

    function assertNotEq(uint256 left, uint256 right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06960000, 1037618710166) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06960001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06960005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06966002, err) }
        vm.assertNotEq(left, right, err);
    }

    function assertNotEqDecimal(uint256 left, uint256 right, uint256 decimals) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06970000, 1037618710167) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06970001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06970005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06976002, decimals) }
        vm.assertNotEqDecimal(left, right, decimals);
    }

    function assertNotEqDecimal(uint256 left, uint256 right, uint256 decimals, string memory err)
        internal
        pure
        virtual
    {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff064d0000, 1037618710093) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff064d0001, 4) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff064d0005, 585) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff064d6003, err) }
        vm.assertNotEqDecimal(left, right, decimals, err);
    }

    function assertNotEq(int256 left, int256 right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff064e0000, 1037618710094) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff064e0001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff064e0005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff064e6001, right) }
        vm.assertNotEq(left, right);
    }

    function assertNotEq(int256 left, int256 right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff064f0000, 1037618710095) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff064f0001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff064f0005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff064f6002, err) }
        vm.assertNotEq(left, right, err);
    }

    function assertNotEqDecimal(int256 left, int256 right, uint256 decimals) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06500000, 1037618710096) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06500001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06500005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06506002, decimals) }
        vm.assertNotEqDecimal(left, right, decimals);
    }

    function assertNotEqDecimal(int256 left, int256 right, uint256 decimals, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06510000, 1037618710097) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06510001, 4) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06510005, 585) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06516003, err) }
        vm.assertNotEqDecimal(left, right, decimals, err);
    }

    function assertNotEq(address left, address right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06520000, 1037618710098) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06520001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06520005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06526001, right) }
        vm.assertNotEq(left, right);
    }

    function assertNotEq(address left, address right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06530000, 1037618710099) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06530001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06530005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06536002, err) }
        vm.assertNotEq(left, right, err);
    }

    function assertNotEq(bytes32 left, bytes32 right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06540000, 1037618710100) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06540001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06540005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06546001, right) }
        vm.assertNotEq(left, right);
    }

    function assertNotEq(bytes32 left, bytes32 right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06550000, 1037618710101) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06550001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06550005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06556002, err) }
        vm.assertNotEq(left, right, err);
    }

    function assertNotEq32(bytes32 left, bytes32 right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06560000, 1037618710102) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06560001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06560005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06566001, right) }
        assertNotEq(left, right);
    }

    function assertNotEq32(bytes32 left, bytes32 right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06980000, 1037618710168) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06980001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06980005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06986002, err) }
        assertNotEq(left, right, err);
    }

    function assertNotEq(string memory left, string memory right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06a20000, 1037618710178) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06a20001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06a20005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06a26001, right) }
        vm.assertNotEq(left, right);
    }

    function assertNotEq(string memory left, string memory right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06a30000, 1037618710179) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06a30001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06a30005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06a36002, err) }
        vm.assertNotEq(left, right, err);
    }

    function assertNotEq(bytes memory left, bytes memory right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06a40000, 1037618710180) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06a40001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06a40005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06a46001, right) }
        vm.assertNotEq(left, right);
    }

    function assertNotEq(bytes memory left, bytes memory right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06a50000, 1037618710181) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06a50001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06a50005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06a56002, err) }
        vm.assertNotEq(left, right, err);
    }

    function assertNotEq(bool[] memory left, bool[] memory right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06a60000, 1037618710182) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06a60001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06a60005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06a66001, right) }
        vm.assertNotEq(left, right);
    }

    function assertNotEq(bool[] memory left, bool[] memory right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06a70000, 1037618710183) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06a70001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06a70005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06a76002, err) }
        vm.assertNotEq(left, right, err);
    }

    function assertNotEq(uint256[] memory left, uint256[] memory right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06a80000, 1037618710184) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06a80001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06a80005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06a86001, right) }
        vm.assertNotEq(left, right);
    }

    function assertNotEq(uint256[] memory left, uint256[] memory right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06a90000, 1037618710185) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06a90001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06a90005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06a96002, err) }
        vm.assertNotEq(left, right, err);
    }

    function assertNotEq(int256[] memory left, int256[] memory right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06aa0000, 1037618710186) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06aa0001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06aa0005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06aa6001, right) }
        vm.assertNotEq(left, right);
    }

    function assertNotEq(int256[] memory left, int256[] memory right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06ab0000, 1037618710187) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06ab0001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06ab0005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06ab6002, err) }
        vm.assertNotEq(left, right, err);
    }

    function assertNotEq(address[] memory left, address[] memory right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff068b0000, 1037618710155) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff068b0001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff068b0005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff068b6001, right) }
        vm.assertNotEq(left, right);
    }

    function assertNotEq(address[] memory left, address[] memory right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff068c0000, 1037618710156) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff068c0001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff068c0005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff068c6002, err) }
        vm.assertNotEq(left, right, err);
    }

    function assertNotEq(bytes32[] memory left, bytes32[] memory right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff068d0000, 1037618710157) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff068d0001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff068d0005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff068d6001, right) }
        vm.assertNotEq(left, right);
    }

    function assertNotEq(bytes32[] memory left, bytes32[] memory right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff068e0000, 1037618710158) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff068e0001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff068e0005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff068e6002, err) }
        vm.assertNotEq(left, right, err);
    }

    function assertNotEq(string[] memory left, string[] memory right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06840000, 1037618710148) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06840001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06840005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06846001, right) }
        vm.assertNotEq(left, right);
    }

    function assertNotEq(string[] memory left, string[] memory right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06850000, 1037618710149) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06850001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06850005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06856002, err) }
        vm.assertNotEq(left, right, err);
    }

    function assertNotEq(bytes[] memory left, bytes[] memory right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06860000, 1037618710150) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06860001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06860005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06866001, right) }
        vm.assertNotEq(left, right);
    }

    function assertNotEq(bytes[] memory left, bytes[] memory right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06870000, 1037618710151) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06870001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06870005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06876002, err) }
        vm.assertNotEq(left, right, err);
    }

    function assertLt(uint256 left, uint256 right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06880000, 1037618710152) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06880001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06880005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06886001, right) }
        vm.assertLt(left, right);
    }

    function assertLt(uint256 left, uint256 right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06890000, 1037618710153) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06890001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06890005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06896002, err) }
        vm.assertLt(left, right, err);
    }

    function assertLtDecimal(uint256 left, uint256 right, uint256 decimals) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff068a0000, 1037618710154) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff068a0001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff068a0005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff068a6002, decimals) }
        vm.assertLtDecimal(left, right, decimals);
    }

    function assertLtDecimal(uint256 left, uint256 right, uint256 decimals, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06990000, 1037618710169) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06990001, 4) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06990005, 585) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06996003, err) }
        vm.assertLtDecimal(left, right, decimals, err);
    }

    function assertLt(int256 left, int256 right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff069a0000, 1037618710170) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff069a0001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff069a0005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff069a6001, right) }
        vm.assertLt(left, right);
    }

    function assertLt(int256 left, int256 right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff069b0000, 1037618710171) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff069b0001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff069b0005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff069b6002, err) }
        vm.assertLt(left, right, err);
    }

    function assertLtDecimal(int256 left, int256 right, uint256 decimals) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff069c0000, 1037618710172) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff069c0001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff069c0005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff069c6002, decimals) }
        vm.assertLtDecimal(left, right, decimals);
    }

    function assertLtDecimal(int256 left, int256 right, uint256 decimals, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff069d0000, 1037618710173) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff069d0001, 4) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff069d0005, 585) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff069d6003, err) }
        vm.assertLtDecimal(left, right, decimals, err);
    }

    function assertGt(uint256 left, uint256 right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff069e0000, 1037618710174) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff069e0001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff069e0005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff069e6001, right) }
        vm.assertGt(left, right);
    }

    function assertGt(uint256 left, uint256 right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff069f0000, 1037618710175) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff069f0001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff069f0005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff069f6002, err) }
        vm.assertGt(left, right, err);
    }

    function assertGtDecimal(uint256 left, uint256 right, uint256 decimals) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06a00000, 1037618710176) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06a00001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06a00005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06a06002, decimals) }
        vm.assertGtDecimal(left, right, decimals);
    }

    function assertGtDecimal(uint256 left, uint256 right, uint256 decimals, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06a10000, 1037618710177) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06a10001, 4) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06a10005, 585) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06a16003, err) }
        vm.assertGtDecimal(left, right, decimals, err);
    }

    function assertGt(int256 left, int256 right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06700000, 1037618710128) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06700001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06700005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06706001, right) }
        vm.assertGt(left, right);
    }

    function assertGt(int256 left, int256 right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06710000, 1037618710129) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06710001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06710005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06716002, err) }
        vm.assertGt(left, right, err);
    }

    function assertGtDecimal(int256 left, int256 right, uint256 decimals) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06720000, 1037618710130) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06720001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06720005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06726002, decimals) }
        vm.assertGtDecimal(left, right, decimals);
    }

    function assertGtDecimal(int256 left, int256 right, uint256 decimals, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06730000, 1037618710131) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06730001, 4) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06730005, 585) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06736003, err) }
        vm.assertGtDecimal(left, right, decimals, err);
    }

    function assertLe(uint256 left, uint256 right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06740000, 1037618710132) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06740001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06740005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06746001, right) }
        vm.assertLe(left, right);
    }

    function assertLe(uint256 left, uint256 right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06750000, 1037618710133) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06750001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06750005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06756002, err) }
        vm.assertLe(left, right, err);
    }

    function assertLeDecimal(uint256 left, uint256 right, uint256 decimals) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06760000, 1037618710134) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06760001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06760005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06766002, decimals) }
        vm.assertLeDecimal(left, right, decimals);
    }

    function assertLeDecimal(uint256 left, uint256 right, uint256 decimals, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06770000, 1037618710135) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06770001, 4) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06770005, 585) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06776003, err) }
        vm.assertLeDecimal(left, right, decimals, err);
    }

    function assertLe(int256 left, int256 right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06780000, 1037618710136) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06780001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06780005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06786001, right) }
        vm.assertLe(left, right);
    }

    function assertLe(int256 left, int256 right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06790000, 1037618710137) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06790001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06790005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06796002, err) }
        vm.assertLe(left, right, err);
    }

    function assertLeDecimal(int256 left, int256 right, uint256 decimals) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06ac0000, 1037618710188) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06ac0001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06ac0005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06ac6002, decimals) }
        vm.assertLeDecimal(left, right, decimals);
    }

    function assertLeDecimal(int256 left, int256 right, uint256 decimals, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06ad0000, 1037618710189) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06ad0001, 4) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06ad0005, 585) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06ad6003, err) }
        vm.assertLeDecimal(left, right, decimals, err);
    }

    function assertGe(uint256 left, uint256 right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06ae0000, 1037618710190) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06ae0001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06ae0005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06ae6001, right) }
        vm.assertGe(left, right);
    }

    function assertGe(uint256 left, uint256 right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06af0000, 1037618710191) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06af0001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06af0005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06af6002, err) }
        vm.assertGe(left, right, err);
    }

    function assertGeDecimal(uint256 left, uint256 right, uint256 decimals) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06b00000, 1037618710192) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06b00001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06b00005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06b06002, decimals) }
        vm.assertGeDecimal(left, right, decimals);
    }

    function assertGeDecimal(uint256 left, uint256 right, uint256 decimals, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06b10000, 1037618710193) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06b10001, 4) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06b10005, 585) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06b16003, err) }
        vm.assertGeDecimal(left, right, decimals, err);
    }

    function assertGe(int256 left, int256 right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06b20000, 1037618710194) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06b20001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06b20005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06b26001, right) }
        vm.assertGe(left, right);
    }

    function assertGe(int256 left, int256 right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06b30000, 1037618710195) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06b30001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06b30005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06b36002, err) }
        vm.assertGe(left, right, err);
    }

    function assertGeDecimal(int256 left, int256 right, uint256 decimals) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06b40000, 1037618710196) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06b40001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06b40005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06b46002, decimals) }
        vm.assertGeDecimal(left, right, decimals);
    }

    function assertGeDecimal(int256 left, int256 right, uint256 decimals, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06b50000, 1037618710197) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06b50001, 4) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06b50005, 585) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06b56003, err) }
        vm.assertGeDecimal(left, right, decimals, err);
    }

    function assertApproxEqAbs(uint256 left, uint256 right, uint256 maxDelta) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff065e0000, 1037618710110) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff065e0001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff065e0005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff065e6002, maxDelta) }
        vm.assertApproxEqAbs(left, right, maxDelta);
    }

    function assertApproxEqAbs(uint256 left, uint256 right, uint256 maxDelta, string memory err)
        internal
        pure
        virtual
    {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff065f0000, 1037618710111) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff065f0001, 4) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff065f0005, 585) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff065f6003, err) }
        vm.assertApproxEqAbs(left, right, maxDelta, err);
    }

    function assertApproxEqAbsDecimal(uint256 left, uint256 right, uint256 maxDelta, uint256 decimals)
        internal
        pure
        virtual
    {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06600000, 1037618710112) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06600001, 4) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06600005, 585) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06606003, decimals) }
        vm.assertApproxEqAbsDecimal(left, right, maxDelta, decimals);
    }

    function assertApproxEqAbsDecimal(
        uint256 left,
        uint256 right,
        uint256 maxDelta,
        uint256 decimals,
        string memory err
    ) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06610000, 1037618710113) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06610001, 5) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06610005, 4681) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06616004, err) }
        vm.assertApproxEqAbsDecimal(left, right, maxDelta, decimals, err);
    }

    function assertApproxEqAbs(int256 left, int256 right, uint256 maxDelta) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06620000, 1037618710114) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06620001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06620005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06626002, maxDelta) }
        vm.assertApproxEqAbs(left, right, maxDelta);
    }

    function assertApproxEqAbs(int256 left, int256 right, uint256 maxDelta, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06630000, 1037618710115) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06630001, 4) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06630005, 585) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06636003, err) }
        vm.assertApproxEqAbs(left, right, maxDelta, err);
    }

    function assertApproxEqAbsDecimal(int256 left, int256 right, uint256 maxDelta, uint256 decimals)
        internal
        pure
        virtual
    {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06640000, 1037618710116) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06640001, 4) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06640005, 585) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06646003, decimals) }
        vm.assertApproxEqAbsDecimal(left, right, maxDelta, decimals);
    }

    function assertApproxEqAbsDecimal(int256 left, int256 right, uint256 maxDelta, uint256 decimals, string memory err)
        internal
        pure
        virtual
    {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06650000, 1037618710117) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06650001, 5) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06650005, 4681) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06656004, err) }
        vm.assertApproxEqAbsDecimal(left, right, maxDelta, decimals, err);
    }

    function assertApproxEqRel(
        uint256 left,
        uint256 right,
        uint256 maxPercentDelta // An 18 decimal fixed point number, where 1e18 == 100%
    ) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff067a0000, 1037618710138) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff067a0001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff067a0005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff067a6002, maxPercentDelta) }
        vm.assertApproxEqRel(left, right, maxPercentDelta);
    }

    function assertApproxEqRel(
        uint256 left,
        uint256 right,
        uint256 maxPercentDelta, // An 18 decimal fixed point number, where 1e18 == 100%
        string memory err
    ) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff067b0000, 1037618710139) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff067b0001, 4) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff067b0005, 585) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff067b6003, err) }
        vm.assertApproxEqRel(left, right, maxPercentDelta, err);
    }

    function assertApproxEqRelDecimal(
        uint256 left,
        uint256 right,
        uint256 maxPercentDelta, // An 18 decimal fixed point number, where 1e18 == 100%
        uint256 decimals
    ) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff067c0000, 1037618710140) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff067c0001, 4) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff067c0005, 585) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff067c6003, decimals) }
        vm.assertApproxEqRelDecimal(left, right, maxPercentDelta, decimals);
    }

    function assertApproxEqRelDecimal(
        uint256 left,
        uint256 right,
        uint256 maxPercentDelta, // An 18 decimal fixed point number, where 1e18 == 100%
        uint256 decimals,
        string memory err
    ) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff067d0000, 1037618710141) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff067d0001, 5) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff067d0005, 4681) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff067d6004, err) }
        vm.assertApproxEqRelDecimal(left, right, maxPercentDelta, decimals, err);
    }

    function assertApproxEqRel(int256 left, int256 right, uint256 maxPercentDelta) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff067e0000, 1037618710142) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff067e0001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff067e0005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff067e6002, maxPercentDelta) }
        vm.assertApproxEqRel(left, right, maxPercentDelta);
    }

    function assertApproxEqRel(
        int256 left,
        int256 right,
        uint256 maxPercentDelta, // An 18 decimal fixed point number, where 1e18 == 100%
        string memory err
    ) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff067f0000, 1037618710143) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff067f0001, 4) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff067f0005, 585) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff067f6003, err) }
        vm.assertApproxEqRel(left, right, maxPercentDelta, err);
    }

    function assertApproxEqRelDecimal(
        int256 left,
        int256 right,
        uint256 maxPercentDelta, // An 18 decimal fixed point number, where 1e18 == 100%
        uint256 decimals
    ) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06800000, 1037618710144) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06800001, 4) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06800005, 585) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06806003, decimals) }
        vm.assertApproxEqRelDecimal(left, right, maxPercentDelta, decimals);
    }

    function assertApproxEqRelDecimal(
        int256 left,
        int256 right,
        uint256 maxPercentDelta, // An 18 decimal fixed point number, where 1e18 == 100%
        uint256 decimals,
        string memory err
    ) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06810000, 1037618710145) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06810001, 5) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06810005, 4681) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06816004, err) }
        vm.assertApproxEqRelDecimal(left, right, maxPercentDelta, decimals, err);
    }

    // Inherited from DSTest, not used but kept for backwards-compatibility
    function checkEq0(bytes memory left, bytes memory right) internal pure returns (bool) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06820000, 1037618710146) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06820001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06820005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06826001, right) }
        return keccak256(left) == keccak256(right);
    }

    function assertEq0(bytes memory left, bytes memory right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06830000, 1037618710147) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06830001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06830005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06836001, right) }
        assertEq(left, right);
    }

    function assertEq0(bytes memory left, bytes memory right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06570000, 1037618710103) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06570001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06570005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06576002, err) }
        assertEq(left, right, err);
    }

    function assertNotEq0(bytes memory left, bytes memory right) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06580000, 1037618710104) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06580001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06580005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06586001, right) }
        assertNotEq(left, right);
    }

    function assertNotEq0(bytes memory left, bytes memory right, string memory err) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06590000, 1037618710105) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06590001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06590005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06596002, err) }
        assertNotEq(left, right, err);
    }

    function assertEqCall(address target, bytes memory callDataA, bytes memory callDataB) internal virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff065a0000, 1037618710106) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff065a0001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff065a0005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff065a6002, callDataB) }
        assertEqCall(target, callDataA, target, callDataB, true);
    }

    function assertEqCall(address targetA, bytes memory callDataA, address targetB, bytes memory callDataB)
        internal
        virtual
    {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff065b0000, 1037618710107) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff065b0001, 4) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff065b0005, 585) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff065b6003, callDataB) }
        assertEqCall(targetA, callDataA, targetB, callDataB, true);
    }

    function assertEqCall(address target, bytes memory callDataA, bytes memory callDataB, bool strictRevertData)
        internal
        virtual
    {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff065c0000, 1037618710108) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff065c0001, 4) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff065c0005, 585) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff065c6003, strictRevertData) }
        assertEqCall(target, callDataA, target, callDataB, strictRevertData);
    }

    function assertEqCall(
        address targetA,
        bytes memory callDataA,
        address targetB,
        bytes memory callDataB,
        bool strictRevertData
    ) internal virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff065d0000, 1037618710109) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff065d0001, 5) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff065d0005, 4681) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff065d6004, strictRevertData) }
        (bool successA, bytes memory returnDataA) = address(targetA).call(callDataA);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00010037,0)}
        (bool successB, bytes memory returnDataB) = address(targetB).call(callDataB);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00010038,0)}

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
