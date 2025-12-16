// SPDX-License-Identifier: MIT
pragma solidity >=0.6.2 <0.9.0;

pragma experimental ABIEncoderV2;

import {IMulticall3} from "./interfaces/IMulticall3.sol";
import {VmSafe} from "./Vm.sol";

abstract contract StdUtils {
    /*//////////////////////////////////////////////////////////////////////////
                                     CONSTANTS
    //////////////////////////////////////////////////////////////////////////*/

    IMulticall3 private constant multicall = IMulticall3(0xcA11bde05977b3631167028862bE2a173976CA11);
    VmSafe private constant vm = VmSafe(address(uint160(uint256(keccak256("hevm cheat code")))));
    address private constant CONSOLE2_ADDRESS = 0x000000000000000000636F6e736F6c652e6c6f67;
    uint256 private constant INT256_MIN_ABS =
        57896044618658097711785492504343953926634992332820282019728792003956564819968;
    uint256 private constant SECP256K1_ORDER =
        115792089237316195423570985008687907852837564279074904382605163141518161494337;
    uint256 private constant UINT256_MAX =
        115792089237316195423570985008687907853269984665640564039457584007913129639935;

    // Used by default when deploying with create2, https://github.com/Arachnid/deterministic-deployment-proxy.
    address private constant CREATE2_FACTORY = 0x4e59b44847b379578588920cA78FbF26c0B4956C;

    /*//////////////////////////////////////////////////////////////////////////
                                 INTERNAL FUNCTIONS
    //////////////////////////////////////////////////////////////////////////*/

    function _bound(uint256 x, uint256 min, uint256 max) internal pure virtual returns (uint256 result) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0d180000, 1037618711832) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0d180001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0d180005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0d186002, max) }
        require(min <= max, "StdUtils bound(uint256,uint256,uint256): Max is less than min.");
        // If x is between min and max, return x directly. This is to ensure that dictionary values
        // do not get shifted if the min is nonzero. More info: https://github.com/foundry-rs/forge-std/issues/188
        if (x >= min && x <= max) return x;

        uint256 size = max - min + 1;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000108,size)}

        // If the value is 0, 1, 2, 3, wrap that to min, min+1, min+2, min+3. Similarly for the UINT256_MAX side.
        // This helps ensure coverage of the min/max values.
        if (x <= 3 && size > x) return min + x;
        if (x >= UINT256_MAX - 3 && size > UINT256_MAX - x) return max - (UINT256_MAX - x);

        // Otherwise, wrap x into the range [min, max], i.e. the range is inclusive.
        if (x > max) {
            uint256 diff = x - max;
            uint256 rem = diff % size;
            if (rem == 0) return max;
            result = min + rem - 1;
        } else if (x < min) {
            uint256 diff = min - x;
            uint256 rem = diff % size;
            if (rem == 0) return min;
            result = max - rem + 1;
        }
    }

    function bound(uint256 x, uint256 min, uint256 max) internal pure virtual returns (uint256 result) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0d190000, 1037618711833) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0d190001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0d190005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0d196002, max) }
        result = _bound(x, min, max);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000113,result)}
        console2_log_StdUtils("Bound result", result);
    }

    function _bound(int256 x, int256 min, int256 max) internal pure virtual returns (int256 result) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0d1b0000, 1037618711835) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0d1b0001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0d1b0005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0d1b6002, max) }
        require(min <= max, "StdUtils bound(int256,int256,int256): Max is less than min.");

        // Shifting all int256 values to uint256 to use _bound function. The range of two types are:
        // int256 : -(2**255) ~ (2**255 - 1)
        // uint256:     0     ~ (2**256 - 1)
        // So, add 2**255, INT256_MIN_ABS to the integer values.
        //
        // If the given integer value is -2**255, we cannot use `-uint256(-x)` because of the overflow.
        // So, use `~uint256(x) + 1` instead.
        uint256 _x = x < 0 ? (INT256_MIN_ABS - ~uint256(x) - 1) : (uint256(x) + INT256_MIN_ABS);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000109,_x)}
        uint256 _min = min < 0 ? (INT256_MIN_ABS - ~uint256(min) - 1) : (uint256(min) + INT256_MIN_ABS);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0000010a,_min)}
        uint256 _max = max < 0 ? (INT256_MIN_ABS - ~uint256(max) - 1) : (uint256(max) + INT256_MIN_ABS);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0000010b,_max)}

        uint256 y = _bound(_x, _min, _max);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0000010c,y)}

        // To move it back to int256 value, subtract INT256_MIN_ABS at here.
        result = y < INT256_MIN_ABS ? int256(~(INT256_MIN_ABS - y) + 1) : int256(y - INT256_MIN_ABS);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000114,result)}
    }

    function bound(int256 x, int256 min, int256 max) internal pure virtual returns (int256 result) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0d1c0000, 1037618711836) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0d1c0001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0d1c0005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0d1c6002, max) }
        result = _bound(x, min, max);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000115,result)}
        console2_log_StdUtils("Bound result", vm.toString(result));
    }

    function boundPrivateKey(uint256 privateKey) internal pure virtual returns (uint256 result) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0d1a0000, 1037618711834) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0d1a0001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0d1a0005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0d1a6000, privateKey) }
        result = _bound(privateKey, 1, SECP256K1_ORDER - 1);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000116,result)}
    }

    function bytesToUint(bytes memory b) internal pure virtual returns (uint256) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0d1d0000, 1037618711837) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0d1d0001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0d1d0005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0d1d6000, b) }
        require(b.length <= 32, "StdUtils bytesToUint(bytes): Bytes length exceeds 32.");
        return abi.decode(abi.encodePacked(new bytes(32 - b.length), b), (uint256));
    }

    /// @dev Compute the address a contract will be deployed at for a given deployer address and nonce
    /// @notice adapted from Solmate implementation (https://github.com/Rari-Capital/solmate/blob/main/src/utils/LibRLP.sol)
    function computeCreateAddress(address deployer, uint256 nonce) internal pure virtual returns (address) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0d1e0000, 1037618711838) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0d1e0001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0d1e0005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0d1e6001, nonce) }
        console2_log_StdUtils("computeCreateAddress is deprecated. Please use vm.computeCreateAddress instead.");
        return vm.computeCreateAddress(deployer, nonce);
    }

    function computeCreate2Address(bytes32 salt, bytes32 initcodeHash, address deployer)
        internal
        pure
        virtual
        returns (address)
    {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0d1f0000, 1037618711839) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0d1f0001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0d1f0005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0d1f6002, deployer) }
        console2_log_StdUtils("computeCreate2Address is deprecated. Please use vm.computeCreate2Address instead.");
        return vm.computeCreate2Address(salt, initcodeHash, deployer);
    }

    /// @dev returns the address of a contract created with CREATE2 using the default CREATE2 deployer
    function computeCreate2Address(bytes32 salt, bytes32 initCodeHash) internal pure returns (address) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0d200000, 1037618711840) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0d200001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0d200005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0d206001, initCodeHash) }
        console2_log_StdUtils("computeCreate2Address is deprecated. Please use vm.computeCreate2Address instead.");
        return vm.computeCreate2Address(salt, initCodeHash);
    }

    /// @dev returns the hash of the init code (creation code + no args) used in CREATE2 with no constructor arguments
    /// @param creationCode the creation code of a contract C, as returned by type(C).creationCode
    function hashInitCode(bytes memory creationCode) internal pure returns (bytes32) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0d210000, 1037618711841) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0d210001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0d210005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0d216000, creationCode) }
        return hashInitCode(creationCode, "");
    }

    /// @dev returns the hash of the init code (creation code + ABI-encoded args) used in CREATE2
    /// @param creationCode the creation code of a contract C, as returned by type(C).creationCode
    /// @param args the ABI-encoded arguments to the constructor of C
    function hashInitCode(bytes memory creationCode, bytes memory args) internal pure returns (bytes32) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0d220000, 1037618711842) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0d220001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0d220005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0d226001, args) }
        return keccak256(abi.encodePacked(creationCode, args));
    }

    // Performs a single call with Multicall3 to query the ERC-20 token balances of the given addresses.
    function getTokenBalances(address token, address[] memory addresses)
        internal
        virtual
        returns (uint256[] memory balances)
    {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0d230000, 1037618711843) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0d230001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0d230005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0d236001, addresses) }
        uint256 tokenCodeSize;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0000010d,tokenCodeSize)}
        assembly {
            tokenCodeSize := extcodesize(token)
        }
        require(tokenCodeSize > 0, "StdUtils getTokenBalances(address,address[]): Token address is not a contract.");

        // ABI encode the aggregate call to Multicall3.
        uint256 length = addresses.length;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0000010e,length)}
        IMulticall3.Call[] memory calls = new IMulticall3.Call[](length);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0001010f,0)}
        for (uint256 i = 0; i < length; ++i) {
            // 0x70a08231 = bytes4("balanceOf(address)"))
            calls[i] = IMulticall3.Call({target: token, callData: abi.encodeWithSelector(0x70a08231, (addresses[i]))});assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00020118,0)}
        }

        // Make the aggregate call.
        (, bytes[] memory returnData) = multicall.aggregate(calls);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00010110,0)}

        // ABI decode the return data and return the balances.
        balances = new uint256[](length);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00020117,0)}
        for (uint256 i = 0; i < length; ++i) {
            balances[i] = abi.decode(returnData[i], (uint256));uint256 certora_local281 = balances[i];assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000119,certora_local281)}
        }
    }

    /*//////////////////////////////////////////////////////////////////////////
                                 PRIVATE FUNCTIONS
    //////////////////////////////////////////////////////////////////////////*/

    function addressFromLast20Bytes(bytes32 bytesValue) private pure returns (address) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0d240000, 1037618711844) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0d240001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0d240005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0d246000, bytesValue) }
        return address(uint160(uint256(bytesValue)));
    }

    // This section is used to prevent the compilation of console, which shortens the compilation time when console is
    // not used elsewhere. We also trick the compiler into letting us make the console log methods as `pure` to avoid
    // any breaking changes to function signatures.
    function _castLogPayloadViewToPure(function(bytes memory) internal view fnIn)
        internal
        pure
        returns (function(bytes memory) internal pure fnOut)
    {
        assembly {
            fnOut := fnIn
        }
    }

    function _sendLogPayload(bytes memory payload) internal pure {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0d250000, 1037618711845) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0d250001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0d250005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0d256000, payload) }
        _castLogPayloadViewToPure(_sendLogPayloadView)(payload);
    }

    function _sendLogPayloadView(bytes memory payload) private view {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0d260000, 1037618711846) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0d260001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0d260005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0d266000, payload) }
        uint256 payloadLength = payload.length;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000111,payloadLength)}
        address consoleAddress = CONSOLE2_ADDRESS;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000112,consoleAddress)}
        /// @solidity memory-safe-assembly
        assembly {
            let payloadStart := add(payload, 32)
            let r := staticcall(gas(), consoleAddress, payloadStart, payloadLength, 0, 0)
        }
    }

    function console2_log_StdUtils(string memory p0) private pure {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0d290000, 1037618711849) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0d290001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0d290005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0d296000, p0) }
        _sendLogPayload(abi.encodeWithSignature("log(string)", p0));
    }

    function console2_log_StdUtils(string memory p0, uint256 p1) private pure {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0d280000, 1037618711848) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0d280001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0d280005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0d286001, p1) }
        _sendLogPayload(abi.encodeWithSignature("log(string,uint256)", p0, p1));
    }

    function console2_log_StdUtils(string memory p0, string memory p1) private pure {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0d270000, 1037618711847) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0d270001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0d270005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0d276001, p1) }
        _sendLogPayload(abi.encodeWithSignature("log(string,string)", p0, p1));
    }
}
