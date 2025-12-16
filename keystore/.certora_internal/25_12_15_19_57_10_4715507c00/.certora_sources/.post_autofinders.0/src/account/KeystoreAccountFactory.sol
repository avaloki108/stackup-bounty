// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import {IEntryPoint} from "account-abstraction/interfaces/IEntryPoint.sol";
import {ISenderCreator} from "account-abstraction/interfaces/ISenderCreator.sol";
import {LibClone} from "solady/utils/LibClone.sol";

import {IKeystore} from "../interface/IKeystore.sol";
import {KeystoreAccount} from "./KeystoreAccount.sol";

/**
 * @dev This factory uses ERC-1167 minimal proxies to deploy each instance of a
 * KeystoreAccount. For maximum simplicity, the KeystoreAccount does NOT have a
 * built-in path for upgradability.
 */
contract KeystoreAccountFactory {
    error NotFromSenderCreator();

    KeystoreAccount public immutable accountImplementation;
    IEntryPoint public immutable entryPoint;
    ISenderCreator public immutable senderCreator;

    constructor(IEntryPoint _entryPoint, IKeystore _keystore) {
        accountImplementation = new KeystoreAccount(_entryPoint, _keystore);
        entryPoint = _entryPoint;
        senderCreator = _entryPoint.senderCreator();
    }

    /**
     * @dev refHash may not be unique for every account if the same initial
     * UserConfiguration Merkle Tree is used. In this case a unique salt value
     * must be used to avoid address collision.
     */
    function createAccount(bytes32 refHash, uint256 salt) public returns (KeystoreAccount ret) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00130000, 1037618708499) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00130001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00130005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00136001, salt) }
        require(msg.sender == address(senderCreator), NotFromSenderCreator());
        address addr = getAddress(refHash, salt);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000006,addr)}
        uint256 codeSize = addr.code.length;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000007,codeSize)}
        if (codeSize > 0) {
            return KeystoreAccount(payable(addr));
        }
        ret = KeystoreAccount(
            payable(LibClone.cloneDeterministic(address(accountImplementation), keccak256(abi.encode(refHash, salt))))
        );assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00020008,0)}
        ret.initialize(refHash);
    }

    function getAddress(bytes32 refHash, uint256 salt) public view returns (address) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00140000, 1037618708500) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00140001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00140005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00146001, salt) }
        return LibClone.predictDeterministicAddress(
            address(accountImplementation), keccak256(abi.encode(refHash, salt)), address(this)
        );
    }

    function addPermanentEntryPointStake() external payable {
        entryPoint.addStake{value: msg.value}(type(uint32).max);
    }
}
