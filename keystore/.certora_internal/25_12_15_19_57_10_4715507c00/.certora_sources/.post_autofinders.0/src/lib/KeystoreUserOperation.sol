// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import {PackedUserOperation} from "account-abstraction/interfaces/PackedUserOperation.sol";

import {ValidateAction} from "../lib/Actions.sol";

library KeystoreUserOperation {
    function unpackOriginalUserOpSignature(bytes calldata userOpSignature)
        internal
        pure
        returns (bytes memory proof, bytes memory node, bytes memory signature)
    {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00150000, 1037618708501) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00150001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00150005, 26) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00156100, userOpSignature.offset) }
        (proof, node, signature) = abi.decode(userOpSignature, (bytes, bytes, bytes));assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0002000c,0)}
    }

    function repackUserOpForValidateAction(PackedUserOperation calldata userOp, bytes memory signature)
        internal
        pure
        returns (bytes memory data)
    {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00160000, 1037618708502) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00160001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00160005, 33) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00166001, signature) }
        PackedUserOperation memory newUserOp = PackedUserOperation({
            sender: userOp.sender,
            nonce: userOp.nonce,
            initCode: userOp.initCode,
            callData: userOp.callData,
            accountGasLimits: userOp.accountGasLimits,
            preVerificationGas: userOp.preVerificationGas,
            gasFees: userOp.gasFees,
            paymasterAndData: userOp.paymasterAndData,
            signature: signature
        });assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00010009,0)}
        data = abi.encode(newUserOp);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0002000d,0)}
    }

    function prepareValidateAction(PackedUserOperation calldata userOp, bytes32 userOpHash, bytes32 refHash)
        internal
        pure
        returns (ValidateAction memory)
    {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00170000, 1037618708503) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00170001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00170005, 265) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00176002, refHash) }
        (bytes memory proof, bytes memory node, bytes memory signature) =
            unpackOriginalUserOpSignature(userOp.signature);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0001000a,0)}
        bytes memory data = repackUserOpForValidateAction(userOp, signature);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0001000b,0)}

        return ValidateAction({refHash: refHash, message: userOpHash, proof: proof, node: node, data: data});
    }
}
