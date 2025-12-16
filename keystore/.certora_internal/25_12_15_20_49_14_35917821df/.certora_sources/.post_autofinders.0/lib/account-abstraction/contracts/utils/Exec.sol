// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

// solhint-disable no-inline-assembly

/**
 * Utility functions helpful when making different kinds of contract calls in Solidity.
 */
library Exec {

    function call(
        address to,
        uint256 value,
        bytes memory data,
        uint256 txGas
    ) internal returns (bool success) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff001a0000, 1037618708506) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff001a0001, 4) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff001a0005, 585) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff001a6003, txGas) }
        assembly ("memory-safe") {
            success := call(txGas, to, value, add(data, 0x20), mload(data), 0, 0)
        }
    }

    function staticcall(
        address to,
        bytes memory data,
        uint256 txGas
    ) internal view returns (bool success) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff001b0000, 1037618708507) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff001b0001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff001b0005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff001b6002, txGas) }
        assembly ("memory-safe") {
            success := staticcall(txGas, to, add(data, 0x20), mload(data), 0, 0)
        }
    }

    function delegateCall(
        address to,
        bytes memory data,
        uint256 txGas
    ) internal returns (bool success) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff001d0000, 1037618708509) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff001d0001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff001d0005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff001d6002, txGas) }
        assembly ("memory-safe") {
            success := delegatecall(txGas, to, add(data, 0x20), mload(data), 0, 0)
        }
    }

    // get returned data from last call or delegateCall
    // maxLen - maximum length of data to return, or zero, for the full length
    function getReturnData(uint256 maxLen) internal pure returns (bytes memory returnData) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff001e0000, 1037618708510) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff001e0001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff001e0005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff001e6000, maxLen) }
        assembly ("memory-safe") {
            let len := returndatasize()
            if gt(maxLen,0) {
                if gt(len, maxLen) {
                    len := maxLen
                }
            }
            let ptr := mload(0x40)
            mstore(0x40, add(ptr, add(len, 0x20)))
            mstore(ptr, len)
            returndatacopy(add(ptr, 0x20), 0, len)
            returnData := ptr
        }
    }

    // revert with explicit byte array (probably reverted info from call)
    function revertWithData(bytes memory returnData) internal pure {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff001c0000, 1037618708508) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff001c0001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff001c0005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff001c6000, returnData) }
        assembly ("memory-safe") {
            revert(add(returnData, 32), mload(returnData))
        }
    }

    // Propagate revert data from last call
    function revertWithReturnData() internal pure {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff001f0000, 1037618708511) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff001f0001, 0) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff001f0004, 0) }
        revertWithData(getReturnData(0));
    }
}
