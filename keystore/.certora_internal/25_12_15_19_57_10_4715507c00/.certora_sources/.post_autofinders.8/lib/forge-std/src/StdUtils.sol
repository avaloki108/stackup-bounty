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

    function _bound(uint256 x, uint256 min, uint256 max) internal pure virtual returns (uint256 result) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0eca0000, 1037618712266) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0eca0001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0eca0005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0eca6002, max) }
        require(min <= max, "StdUtils bound(uint256,uint256,uint256): Max is less than min.");
        // If x is between min and max, return x directly. This is to ensure that dictionary values
        // do not get shifted if the min is nonzero. More info: https://github.com/foundry-rs/forge-std/issues/188
        if (x >= min && x <= max) return x;

        uint256 size = max - min + 1;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000000f6,size)}

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

    function bound(uint256 x, uint256 min, uint256 max) internal pure virtual returns (uint256 result) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ecb0000, 1037618712267) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ecb0001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ecb0005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ecb6002, max) }
        result = _bound(x, min, max);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000101,result)}
        console2_log_StdUtils("Bound result", result);
    }

    function _bound(int256 x, int256 min, int256 max) internal pure virtual returns (int256 result) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ecd0000, 1037618712269) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ecd0001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ecd0005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ecd6002, max) }
        require(min <= max, "StdUtils bound(int256,int256,int256): Max is less than min.");

        // Shifting all int256 values to uint256 to use _bound function. The range of two types are:
        // int256 : -(2**255) ~ (2**255 - 1)
        // uint256:     0     ~ (2**256 - 1)
        // So, add 2**255, INT256_MIN_ABS to the integer values.
        //
        // If the given integer value is -2**255, we cannot use `-uint256(-x)` because of the overflow.
        // So, use `~uint256(x) + 1` instead.
        uint256 _x = x < 0 ? (INT256_MIN_ABS - ~uint256(x) - 1) : (uint256(x) + INT256_MIN_ABS);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000000f7,_x)}
        uint256 _min = min < 0 ? (INT256_MIN_ABS - ~uint256(min) - 1) : (uint256(min) + INT256_MIN_ABS);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000000f8,_min)}
        uint256 _max = max < 0 ? (INT256_MIN_ABS - ~uint256(max) - 1) : (uint256(max) + INT256_MIN_ABS);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000000f9,_max)}

        uint256 y = _bound(_x, _min, _max);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000000fa,y)}

        // To move it back to int256 value, subtract INT256_MIN_ABS at here.
        result = y < INT256_MIN_ABS ? int256(~(INT256_MIN_ABS - y) + 1) : int256(y - INT256_MIN_ABS);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000102,result)}
    }

    function bound(int256 x, int256 min, int256 max) internal pure virtual returns (int256 result) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ece0000, 1037618712270) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ece0001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ece0005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ece6002, max) }
        result = _bound(x, min, max);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000103,result)}
        console2_log_StdUtils("Bound result", vm.toString(result));
    }

    function boundPrivateKey(uint256 privateKey) internal pure virtual returns (uint256 result) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ecc0000, 1037618712268) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ecc0001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ecc0005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ecc6000, privateKey) }
        result = _bound(privateKey, 1, SECP256K1_ORDER - 1);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000104,result)}
    }

    function bytesToUint(bytes memory b) internal pure virtual returns (uint256) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ecf0000, 1037618712271) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ecf0001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ecf0005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ecf6000, b) }
        require(b.length <= 32, "StdUtils bytesToUint(bytes): Bytes length exceeds 32.");
        return abi.decode(abi.encodePacked(new bytes(32 - b.length), b), (uint256));
    }

    /// @dev Compute the address a contract will be deployed at for a given deployer address and nonce
    /// @notice adapted from Solmate implementation (https://github.com/Rari-Capital/solmate/blob/main/src/utils/LibRLP.sol)
    function computeCreateAddress(address deployer, uint256 nonce) internal pure virtual returns (address) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ed00000, 1037618712272) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ed00001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ed00005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ed06001, nonce) }
        console2_log_StdUtils("computeCreateAddress is deprecated. Please use vm.computeCreateAddress instead.");
        return vm.computeCreateAddress(deployer, nonce);
    }

    function computeCreate2Address(bytes32 salt, bytes32 initcodeHash, address deployer)
        internal
        pure
        virtual
        returns (address)
    {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ed10000, 1037618712273) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ed10001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ed10005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ed16002, deployer) }
        console2_log_StdUtils("computeCreate2Address is deprecated. Please use vm.computeCreate2Address instead.");
        return vm.computeCreate2Address(salt, initcodeHash, deployer);
    }

    /// @dev returns the address of a contract created with CREATE2 using the default CREATE2 deployer
    function computeCreate2Address(bytes32 salt, bytes32 initCodeHash) internal pure returns (address) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ed20000, 1037618712274) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ed20001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ed20005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ed26001, initCodeHash) }
        console2_log_StdUtils("computeCreate2Address is deprecated. Please use vm.computeCreate2Address instead.");
        return vm.computeCreate2Address(salt, initCodeHash);
    }

    /// @dev returns the hash of the init code (creation code + no args) used in CREATE2 with no constructor arguments
    /// @param creationCode the creation code of a contract C, as returned by type(C).creationCode
    function hashInitCode(bytes memory creationCode) internal pure returns (bytes32) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ed30000, 1037618712275) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ed30001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ed30005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ed36000, creationCode) }
        return hashInitCode(creationCode, "");
    }

    /// @dev returns the hash of the init code (creation code + ABI-encoded args) used in CREATE2
    /// @param creationCode the creation code of a contract C, as returned by type(C).creationCode
    /// @param args the ABI-encoded arguments to the constructor of C
    function hashInitCode(bytes memory creationCode, bytes memory args) internal pure returns (bytes32) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ed40000, 1037618712276) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ed40001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ed40005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ed46001, args) }
        return keccak256(abi.encodePacked(creationCode, args));
    }

    // Performs a single call with Multicall3 to query the ERC-20 token balances of the given addresses.
    function getTokenBalances(address token, address[] memory addresses)
        internal
        virtual
        returns (uint256[] memory balances)
    {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ed50000, 1037618712277) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ed50001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ed50005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ed56001, addresses) }
        uint256 tokenCodeSize;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000000fb,tokenCodeSize)}
        assembly {
            tokenCodeSize := extcodesize(token)
        }
        require(tokenCodeSize > 0, "StdUtils getTokenBalances(address,address[]): Token address is not a contract.");

        // ABI encode the aggregate call to Multicall3.
        uint256 length = addresses.length;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000000fc,length)}
        IMulticall3.Call[] memory calls = new IMulticall3.Call[](length);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000100fd,0)}
        for (uint256 i = 0; i < length; ++i) {
            // 0x70a08231 = bytes4("balanceOf(address)"))
            calls[i] = IMulticall3.Call({target: token, callData: abi.encodeWithSelector(0x70a08231, (addresses[i]))});assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00020106,0)}
        }

        // Make the aggregate call.
        (, bytes[] memory returnData) = multicall.aggregate(calls);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000100fe,0)}

        // ABI decode the return data and return the balances.
        balances = new uint256[](length);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00020105,0)}
        for (uint256 i = 0; i < length; ++i) {
            balances[i] = abi.decode(returnData[i], (uint256));uint256 certora_local263 = balances[i];assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000107,certora_local263)}
        }
    }

    /*//////////////////////////////////////////////////////////////////////////
                                 PRIVATE FUNCTIONS
    //////////////////////////////////////////////////////////////////////////*/

    function addressFromLast20Bytes(bytes32 bytesValue) private pure returns (address) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ed60000, 1037618712278) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ed60001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ed60005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ed66000, bytesValue) }
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

    function _sendLogPayload(bytes memory payload) internal pure {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ed70000, 1037618712279) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ed70001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ed70005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ed76000, payload) }
        _castLogPayloadViewToPure(_sendLogPayloadView)(payload);
    }

    function _sendLogPayloadView(bytes memory payload) private view {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ed80000, 1037618712280) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ed80001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ed80005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ed86000, payload) }
        uint256 payloadLength = payload.length;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000000ff,payloadLength)}
        address consoleAddress = CONSOLE2_ADDRESS;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000100,consoleAddress)}
        /// @solidity memory-safe-assembly
        assembly {
            let payloadStart := add(payload, 32)
            let r := staticcall(gas(), consoleAddress, payloadStart, payloadLength, 0, 0)
        }
    }

    function console2_log_StdUtils(string memory p0) private pure {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0edb0000, 1037618712283) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0edb0001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0edb0005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0edb6000, p0) }
        _sendLogPayload(abi.encodeWithSignature("log(string)", p0));
    }

    function console2_log_StdUtils(string memory p0, uint256 p1) private pure {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0eda0000, 1037618712282) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0eda0001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0eda0005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0eda6001, p1) }
        _sendLogPayload(abi.encodeWithSignature("log(string,uint256)", p0, p1));
    }

    function console2_log_StdUtils(string memory p0, string memory p1) private pure {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ed90000, 1037618712281) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ed90001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ed90005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ed96001, p1) }
        _sendLogPayload(abi.encodeWithSignature("log(string,string)", p0, p1));
    }
}
