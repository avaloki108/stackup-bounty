// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.28;

import "../interfaces/INonceManager.sol";

/**
 * nonce management functionality
 */
abstract contract NonceManager is INonceManager {

    /**
     * The next valid sequence number for a given nonce key.
     */
    mapping(address => mapping(uint192 => uint256)) public nonceSequenceNumber;

    /// @inheritdoc INonceManager
    function getNonce(address sender, uint192 key)
    public view override returns (uint256 nonce) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff004b0000, 1037618708555) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff004b0001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff004b0005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff004b6001, key) }
        return nonceSequenceNumber[sender][key] | (uint256(key) << 64);
    }

    /// @inheritdoc INonceManager
    function incrementNonce(uint192 key) external override {
        nonceSequenceNumber[msg.sender][key]++;
    }

    /**
     * validate nonce uniqueness for this account.
     * called just after validateUserOp()
     * @return true if the nonce was incremented successfully.
     *         false if the current nonce doesn't match the given one.
     */
    function _validateAndUpdateNonce(address sender, uint256 nonce) internal returns (bool) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00570000, 1037618708567) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00570001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00570005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00576001, nonce) }

        uint192 key = uint192(nonce >> 64);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000080,key)}
        uint64 seq = uint64(nonce);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000081,seq)}
        return nonceSequenceNumber[sender][key]++ == seq;
    }

}
