// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import {TokenCallbackHandler} from "account-abstraction/accounts/callback/TokenCallbackHandler.sol";
import {BaseAccount} from "account-abstraction/core/BaseAccount.sol";
import {SIG_VALIDATION_FAILED} from "account-abstraction/core/Helpers.sol";
import {IEntryPoint} from "account-abstraction/interfaces/IEntryPoint.sol";
import {PackedUserOperation} from "account-abstraction/interfaces/PackedUserOperation.sol";
import {ERC1271} from "solady/accounts/ERC1271.sol";
import {Initializable} from "solady/utils/Initializable.sol";

import {IKeystore} from "../interface/IKeystore.sol";
import {ValidateAction} from "../lib/Actions.sol";
import {KeystoreUserOperation} from "../lib/KeystoreUserOperation.sol";

contract KeystoreAccount is BaseAccount, TokenCallbackHandler, ERC1271, Initializable {
    error ERC1271SignerUnused();

    bytes32 public refHash;

    IEntryPoint private immutable _entryPoint;
    IKeystore private immutable _keystore;

    event KeystoreAccountInitialized(
        IEntryPoint indexed entryPoint, IKeystore indexed keystore, bytes32 indexed refHash
    );

    function entryPoint() public view virtual override returns (IEntryPoint) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff000e0000, 1037618708494) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff000e0001, 0) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff000e0004, 0) }
        return _entryPoint;
    }

    function keystore() public view returns (IKeystore) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff000a0000, 1037618708490) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff000a0001, 0) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff000a0004, 0) }
        return _keystore;
    }

    receive() external payable {}

    constructor(IEntryPoint anEntryPoint, IKeystore aKeystore) {
        _entryPoint = anEntryPoint;
        _keystore = aKeystore;
        _disableInitializers();
    }

    function initialize(bytes32 aRefHash) public virtual logInternal49(aRefHash)initializer {
        refHash = aRefHash;
        emit KeystoreAccountInitialized(_entryPoint, _keystore, refHash);
    }modifier logInternal49(bytes32 aRefHash) { assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00310000, 1037618708529) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00310001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00310005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00316000, aRefHash) } _; }

    function _validateSignature(PackedUserOperation calldata userOp, bytes32 userOpHash)
        internal
        virtual
        override
        returns (uint256 validationData)
    {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00000000, 1037618708480) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00000001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00000005, 33) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00006001, userOpHash) }
        ValidateAction memory action = KeystoreUserOperation.prepareValidateAction(userOp, userOpHash, refHash);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00010001,0)}
        if (action.proof.length != 0) {
            IKeystore(_keystore).registerNode(refHash, abi.decode(action.proof, (bytes32[])), action.node);
            action.proof = "";
            action.node = bytes.concat(keccak256(action.node)); // convert from bytes32 to bytes
        }

        return IKeystore(_keystore).validate(action);
    }

    function getDeposit() public view returns (uint256) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff000b0000, 1037618708491) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff000b0001, 0) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff000b0004, 0) }
        return entryPoint().balanceOf(address(this));
    }

    function addDeposit() public payable {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff000f0000, 1037618708495) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff000f0001, 0) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff000f0004, 0) }
        entryPoint().depositTo{value: msg.value}(address(this));
    }

    function withdrawDepositTo(address payable withdrawAddress, uint256 amount) public {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff000d0000, 1037618708493) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff000d0001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff000d0005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff000d6001, amount) }
        _requireForExecute();
        entryPoint().withdrawTo(withdrawAddress, amount);
    }

    // ================================================================
    // Internal functions
    // ================================================================

    function _domainNameAndVersion() internal pure override returns (string memory name, string memory version) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00010000, 1037618708481) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00010001, 0) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00010004, 0) }
        name = "KeystoreAccount";assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00020004,0)}
        version = "1";assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00020005,0)}
    }

    function _erc1271IsValidSignatureNowCalldata(bytes32 hash, bytes calldata signature)
        internal
        view
        override
        returns (bool)
    {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00030000, 1037618708483) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00030001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00030005, 90) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00036101, signature.offset) }
        (bytes memory proof, bytes memory node, bytes memory data) = abi.decode(signature, (bytes, bytes, bytes));assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00010002,0)}
        ValidateAction memory action =
            ValidateAction({refHash: refHash, message: hash, proof: proof, node: node, data: data});assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00010003,0)}
        return IKeystore(_keystore).validate(action) != SIG_VALIDATION_FAILED;
    }

    /**
     * @dev This override is required by the ERC1271 inheritance but will NEVER
     * be called. Signature validation is always handled by the Keystore contract
     * via the _erc1271IsValidSignatureNowCalldata override and never through a
     * signer address check as seen in the abstract implementation.
     */
    function _erc1271Signer() internal pure override returns (address) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00040000, 1037618708484) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00040001, 0) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00040004, 0) }
        revert ERC1271SignerUnused();
    }
}
