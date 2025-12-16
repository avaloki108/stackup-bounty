// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.28;
/* solhint-disable avoid-low-level-calls */
/* solhint-disable no-inline-assembly */

import "../interfaces/IAccount.sol";
import "../interfaces/IAccountExecute.sol";
import "../interfaces/IEntryPoint.sol";
import "../interfaces/IPaymaster.sol";

import "./UserOperationLib.sol";
import "./StakeManager.sol";
import "./NonceManager.sol";
import "./Helpers.sol";
import "./SenderCreator.sol";
import "./Eip7702Support.sol";
import "../utils/Exec.sol";

import "@openzeppelin/contracts/utils/ReentrancyGuardTransient.sol";
import "@openzeppelin/contracts/utils/introspection/ERC165.sol";
import "@openzeppelin/contracts/utils/cryptography/EIP712.sol";

/**
 * Account-Abstraction (EIP-4337) singleton EntryPoint v0.8 implementation.
 * Only one instance required on each chain.
 * @custom:security-contact https://bounty.ethereum.org
 */
contract EntryPoint is IEntryPoint, StakeManager, NonceManager, ReentrancyGuardTransient, ERC165, EIP712 {

    using UserOperationLib for PackedUserOperation;

    /**
     * internal-use constants
     */

    // allow some slack for future gas price changes.
    uint256 private constant INNER_GAS_OVERHEAD = 10000;

    // Marker for inner call revert on out of gas
    bytes32 private constant INNER_OUT_OF_GAS = hex"deaddead";
    bytes32 private constant INNER_REVERT_LOW_PREFUND = hex"deadaa51";

    uint256 private constant REVERT_REASON_MAX_LEN = 2048;
    // Penalty charged for either unused execution gas or postOp gas
    uint256 private constant UNUSED_GAS_PENALTY_PERCENT = 10;
    // Threshold below which no penalty would be charged
    uint256 private constant PENALTY_GAS_THRESHOLD = 40000;

    SenderCreator private immutable _senderCreator = new SenderCreator();

    string constant internal DOMAIN_NAME = "ERC4337";
    string constant internal DOMAIN_VERSION = "1";

    constructor() EIP712(DOMAIN_NAME, DOMAIN_VERSION)  {
    }

    /// @inheritdoc IEntryPoint
    function handleOps(
        PackedUserOperation[] calldata ops,
        address payable beneficiary
    ) external nonReentrant {
        uint256 opslen = ops.length;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0000003a,opslen)}
        UserOpInfo[] memory opInfos = new UserOpInfo[](opslen);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0001003b,0)}
        unchecked {
            _iterateValidationPhase(ops, opInfos, address(0), 0);

            uint256 collected = 0;
            emit BeforeExecution();

            for (uint256 i = 0; i < opslen; i++) {
                collected += _executeUserOp(i, ops[i], opInfos[i]);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000077,collected)}
            }

            _compensate(beneficiary, collected);
        }
    }

    /// @inheritdoc IEntryPoint
    function handleAggregatedOps(
        UserOpsPerAggregator[] calldata opsPerAggregator,
        address payable beneficiary
    ) external nonReentrant {

        unchecked {
            uint256 opasLen = opsPerAggregator.length;
            uint256 totalOps = 0;
            for (uint256 i = 0; i < opasLen; i++) {
                UserOpsPerAggregator calldata opa = opsPerAggregator[i];assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0001006a,0)}
                PackedUserOperation[] calldata ops = opa.userOps;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0001006b,0)}
                IAggregator aggregator = opa.aggregator;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0001006c,0)}

                // address(1) is special marker of "signature error"
                require(
                    address(aggregator) != address(1),
                    SignatureValidationFailed(address(aggregator))
                );

                if (address(aggregator) != address(0)) {
                    // solhint-disable-next-line no-empty-blocks
                    try aggregator.validateSignatures(ops, opa.signature) {} catch {
                        revert SignatureValidationFailed(address(aggregator));
                    }
                }

                totalOps += ops.length;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000078,totalOps)}
            }

            UserOpInfo[] memory opInfos = new UserOpInfo[](totalOps);

            uint256 opIndex = 0;
            for (uint256 a = 0; a < opasLen; a++) {
                UserOpsPerAggregator calldata opa = opsPerAggregator[a];assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0001006d,0)}
                PackedUserOperation[] calldata ops = opa.userOps;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0001006e,0)}
                IAggregator aggregator = opa.aggregator;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0001006f,0)}

                opIndex += _iterateValidationPhase(ops, opInfos, address(aggregator), opIndex);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000079,opIndex)}
            }

            emit BeforeExecution();

            uint256 collected = 0;
            opIndex = 0;
            for (uint256 a = 0; a < opasLen; a++) {
                UserOpsPerAggregator calldata opa = opsPerAggregator[a];assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00010070,0)}
                emit SignatureAggregatorChanged(address(opa.aggregator));
                PackedUserOperation[] calldata ops = opa.userOps;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00010071,0)}
                uint256 opslen = ops.length;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000072,opslen)}

                for (uint256 i = 0; i < opslen; i++) {
                    collected += _executeUserOp(opIndex, ops[i], opInfos[opIndex]);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0000007e,collected)}
                    opIndex++;
                }
            }

            _compensate(beneficiary, collected);
        }
    }

    /// @inheritdoc IEntryPoint
    function getUserOpHash(
        PackedUserOperation calldata userOp
    ) public view returns (bytes32) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff004a0000, 1037618708554) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff004a0001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff004a0005, 4) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff004a6200, userOp) }
        bytes32 overrideInitCodeHash = Eip7702Support._getEip7702InitCodeHashOverride(userOp);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0000003c,overrideInitCodeHash)}
        return
            MessageHashUtils.toTypedDataHash(getDomainSeparatorV4(), userOp.hash(overrideInitCodeHash));
    }

    /// @inheritdoc IEntryPoint
    function getSenderAddress(bytes calldata initCode) external {
        address sender = senderCreator().createSender(initCode);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0000003d,sender)}
        revert SenderAddressResult(sender);
    }

    /// @inheritdoc IEntryPoint
    function senderCreator() public view virtual returns (ISenderCreator) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00490000, 1037618708553) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00490001, 0) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00490004, 0) }
        return _senderCreator;
    }

    /// @inheritdoc IEntryPoint
    function delegateAndRevert(address target, bytes calldata data) external {
        (bool success, bytes memory ret) = target.delegatecall(data);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0001003e,0)}
        revert DelegateAndRevert(success, ret);
    }

    function getPackedUserOpTypeHash() external pure returns (bytes32) {
        return UserOperationLib.PACKED_USEROP_TYPEHASH;
    }

    function getDomainSeparatorV4() public virtual view returns (bytes32) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00530000, 1037618708563) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00530001, 0) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00530004, 0) }
        return _domainSeparatorV4();
    }

    /// @inheritdoc IERC165
    function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00520000, 1037618708562) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00520001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00520005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00526000, interfaceId) }
        // note: solidity "type(IEntryPoint).interfaceId" is without inherited methods but we want to check everything
        return interfaceId == (type(IEntryPoint).interfaceId ^ type(IStakeManager).interfaceId ^ type(INonceManager).interfaceId) ||
        interfaceId == type(IEntryPoint).interfaceId ||
        interfaceId == type(IStakeManager).interfaceId ||
        interfaceId == type(INonceManager).interfaceId ||
            super.supportsInterface(interfaceId);
    }

    /**
     * Compensate the caller's beneficiary address with the collected fees of all UserOperations.
     * @param beneficiary - The address to receive the fees.
     * @param amount      - Amount to transfer.
     */
    function _compensate(address payable beneficiary, uint256 amount) internal virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00390000, 1037618708537) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00390001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00390005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00396001, amount) }
        require(beneficiary != address(0), "AA90 invalid beneficiary");
        (bool success,) = beneficiary.call{value: amount}("");assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0001003f,0)}
        require(success, "AA91 failed send to beneficiary");
    }

    /**
     * Execute a user operation.
     * @param opIndex    - Index into the opInfo array.
     * @param userOp     - The userOp to execute.
     * @param opInfo     - The opInfo filled by validatePrepayment for this userOp.
     * @return collected - The total amount this userOp paid.
     */
    function _executeUserOp(
        uint256 opIndex,
        PackedUserOperation calldata userOp,
        UserOpInfo memory opInfo
    )
    internal virtual
    returns (uint256 collected) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff003a0000, 1037618708538) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff003a0001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff003a0005, 97) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff003a6002, opInfo) }
        uint256 preGas = gasleft();assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000040,preGas)}
        bytes memory context = _getMemoryBytesFromOffset(opInfo.contextOffset);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00010041,0)}
        bool success;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000042,success)}
        {
            uint256 saveFreePtr = _getFreePtr();
            bytes calldata callData = userOp.callData;
            bytes memory innerCall;
            bytes4 methodSig;
            assembly ("memory-safe") {
                let len := callData.length
                if gt(len, 3) {
                    methodSig := calldataload(callData.offset)
                }
            }
            if (methodSig == IAccountExecute.executeUserOp.selector) {
                bytes memory executeUserOp = abi.encodeCall(IAccountExecute.executeUserOp, (userOp, opInfo.userOpHash));
                innerCall = abi.encodeCall(this.innerHandleOp, (executeUserOp, opInfo, context));
            } else
            {
                innerCall = abi.encodeCall(this.innerHandleOp, (callData, opInfo, context));assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0002007a,0)}
            }
            assembly ("memory-safe") {
                success := call(gas(), address(), 0, add(innerCall, 0x20), mload(innerCall), 0, 32)
                collected := mload(0)
            }
            _restoreFreePtr(saveFreePtr);
        }
        if (!success) {
            bytes32 innerRevertCode;
            assembly ("memory-safe") {
                let len := returndatasize()
                if eq(32, len) {
                    returndatacopy(0, 0, 32)
                    innerRevertCode := mload(0)
                }
            }
            if (innerRevertCode == INNER_OUT_OF_GAS) {
                // handleOps was called with gas limit too low. abort entire bundle.
                // can only be caused by bundler (leaving not enough gas for inner call)
                revert FailedOp(opIndex, "AA95 out of gas");
            } else if (innerRevertCode == INNER_REVERT_LOW_PREFUND) {
                // innerCall reverted on prefund too low. treat entire prefund as "gas cost"
                uint256 actualGas = preGas - gasleft() + opInfo.preOpGas;
                uint256 actualGasCost = opInfo.prefund;
                _emitPrefundTooLow(opInfo);
                _emitUserOperationEvent(opInfo, false, actualGasCost, actualGas);
                collected = actualGasCost;
            } else {
                uint256 freePtr = _getFreePtr();assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0000007c,freePtr)}
                emit PostOpRevertReason(
                    opInfo.userOpHash,
                    opInfo.mUserOp.sender,
                    opInfo.mUserOp.nonce,
                    Exec.getReturnData(REVERT_REASON_MAX_LEN)
                );
                _restoreFreePtr(freePtr);

                uint256 actualGas = preGas - gasleft() + opInfo.preOpGas;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0000007d,actualGas)}
                collected = _postExecution(
                    IPaymaster.PostOpMode.postOpReverted,
                    opInfo,
                    context,
                    actualGas
                );assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0000007f,collected)}
            }
        }
    }

    /**
     * Emit the UserOperationEvent for the given UserOperation.
     *
     * @param opInfo         - The details of the current UserOperation.
     * @param success        - Whether the execution of the UserOperation has succeeded or not.
     * @param actualGasCost  - The actual cost of the consumed gas charged from the sender or the paymaster.
     * @param actualGas      - The actual amount of gas used.
     */
    function _emitUserOperationEvent(UserOpInfo memory opInfo, bool success, uint256 actualGasCost, uint256 actualGas) internal virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff003c0000, 1037618708540) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff003c0001, 4) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff003c0005, 585) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff003c6003, actualGas) }
        emit UserOperationEvent(
            opInfo.userOpHash,
            opInfo.mUserOp.sender,
            opInfo.mUserOp.paymaster,
            opInfo.mUserOp.nonce,
            success,
            actualGasCost,
            actualGas
        );
    }

    /**
     * Emit the UserOperationPrefundTooLow event for the given UserOperation.
     *
     * @param opInfo - The details of the current UserOperation.
     */
    function _emitPrefundTooLow(UserOpInfo memory opInfo) internal virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff003d0000, 1037618708541) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff003d0001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff003d0005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff003d6000, opInfo) }
        emit UserOperationPrefundTooLow(
            opInfo.userOpHash,
            opInfo.mUserOp.sender,
            opInfo.mUserOp.nonce
        );
    }

    /**
     * Iterate over calldata PackedUserOperation array and perform account and paymaster validation.
     * @notice UserOpInfo is a global array of all UserOps while PackedUserOperation is grouped per aggregator.
     *
     * @param ops - an array of UserOps to be validated
     * @param opInfos - an array of UserOp metadata being read and filled in during this function's execution
     * @param expectedAggregator - an address of the aggregator specified for a given UserOp if any, or address(0)
     * @param opIndexOffset - an offset for the index between 'ops' and 'opInfos' arrays, see the notice.
     * @return opsLen - processed UserOps (length of "ops" array)
     */
    function _iterateValidationPhase(
        PackedUserOperation[] calldata ops,
        UserOpInfo[] memory opInfos,
        address expectedAggregator,
        uint256 opIndexOffset
    ) internal returns (uint256 opsLen){assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff003b0000, 1037618708539) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff003b0001, 5) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff003b0005, 13385) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff003b6004, opIndexOffset) }
        unchecked {
            opsLen = ops.length;
            for (uint256 i = 0; i < opsLen; i++) {
                UserOpInfo memory opInfo = opInfos[opIndexOffset + i];assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00010073,0)}
                (
                    uint256 validationData,
                    uint256 pmValidationData
                ) = _validatePrepayment(opIndexOffset + i, ops[i], opInfo);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00010074,0)}
                _validateAccountAndPaymasterValidationData(
                    opIndexOffset + i,
                    validationData,
                    pmValidationData,
                    expectedAggregator
                );
            }
        }
    }

    /**
     * A memory copy of UserOp static fields only.
     * Excluding: callData, initCode and signature. Replacing paymasterAndData with paymaster.
     */
    struct MemoryUserOp {
        address sender;
        uint256 nonce;
        uint256 verificationGasLimit;
        uint256 callGasLimit;
        uint256 paymasterVerificationGasLimit;
        uint256 paymasterPostOpGasLimit;
        uint256 preVerificationGas;
        address paymaster;
        uint256 maxFeePerGas;
        uint256 maxPriorityFeePerGas;
    }

    struct UserOpInfo {
        MemoryUserOp mUserOp;
        bytes32 userOpHash;
        uint256 prefund;
        uint256 contextOffset;
        uint256 preOpGas;
    }

    /**
     * Inner function to handle a UserOperation.
     * Must be declared "external" to open a call context, but it can only be called by handleOps.
     * @param callData - The callData to execute.
     * @param opInfo   - The UserOpInfo struct.
     * @param context  - The context bytes.
     * @return actualGasCost - the actual cost in eth this UserOperation paid for gas
     */
    function innerHandleOp(
        bytes memory callData,
        UserOpInfo memory opInfo,
        bytes calldata context
    ) external returns (uint256 actualGasCost) {
        uint256 preGas = gasleft();assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000043,preGas)}
        require(msg.sender == address(this), "AA92 internal call only");
        MemoryUserOp memory mUserOp = opInfo.mUserOp;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00010044,0)}

        uint256 callGasLimit = mUserOp.callGasLimit;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000045,callGasLimit)}
        unchecked {
        // handleOps was called with gas limit too low. abort entire bundle.
            if (
                gasleft() * 63 / 64 <
                callGasLimit +
                mUserOp.paymasterPostOpGasLimit +
                INNER_GAS_OVERHEAD
            ) {
                assembly ("memory-safe") {
                    mstore(0, INNER_OUT_OF_GAS)
                    revert(0, 32)
                }
            }
        }

        IPaymaster.PostOpMode mode = IPaymaster.PostOpMode.opSucceeded;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00010046,0)}
        if (callData.length > 0) {
            bool success = Exec.call(mUserOp.sender, 0, callData, callGasLimit);
            if (!success) {
                uint256 freePtr = _getFreePtr();
                bytes memory result = Exec.getReturnData(REVERT_REASON_MAX_LEN);
                if (result.length > 0) {
                    emit UserOperationRevertReason(
                        opInfo.userOpHash,
                        mUserOp.sender,
                        mUserOp.nonce,
                        result
                    );
                }
                _restoreFreePtr(freePtr);
                mode = IPaymaster.PostOpMode.opReverted;
            }
        }

        unchecked {
            uint256 actualGas = preGas - gasleft() + opInfo.preOpGas;
            return _postExecution(mode, opInfo, context, actualGas);
        }
    }

    /**
     * Copy general fields from userOp into the memory opInfo structure.
     * @param userOp  - The user operation.
     * @param mUserOp - The memory user operation.
     */
    function _copyUserOpToMemory(
        PackedUserOperation calldata userOp,
        MemoryUserOp memory mUserOp
    ) internal virtual pure {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff003e0000, 1037618708542) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff003e0001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff003e0005, 33) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff003e6001, mUserOp) }
        mUserOp.sender = userOp.sender;address certora_local95 = mUserOp.sender;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0000005f,certora_local95)}
        mUserOp.nonce = userOp.nonce;uint256 certora_local96 = mUserOp.nonce;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000060,certora_local96)}
        (mUserOp.verificationGasLimit, mUserOp.callGasLimit) = UserOperationLib.unpackUints(userOp.accountGasLimits);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00020061,0)}
        mUserOp.preVerificationGas = userOp.preVerificationGas;uint256 certora_local98 = mUserOp.preVerificationGas;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000062,certora_local98)}
        (mUserOp.maxPriorityFeePerGas, mUserOp.maxFeePerGas) = UserOperationLib.unpackUints(userOp.gasFees);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00020063,0)}
        bytes calldata paymasterAndData = userOp.paymasterAndData;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00010047,0)}
        if (paymasterAndData.length > 0) {
            require(
                paymasterAndData.length >= UserOperationLib.PAYMASTER_DATA_OFFSET,
                "AA93 invalid paymasterAndData"
            );
            address paymaster;
            (paymaster, mUserOp.paymasterVerificationGasLimit, mUserOp.paymasterPostOpGasLimit) = UserOperationLib.unpackPaymasterStaticFields(paymasterAndData);
            require(paymaster != address(0), "AA98 invalid paymaster");
            mUserOp.paymaster = paymaster;
        }
    }

    /**
     * Get the required prefunded gas fee amount for an operation.
     *
     * @param mUserOp - The user operation in memory.
     * @return requiredPrefund - the required amount.
     */
    function _getRequiredPrefund(
        MemoryUserOp memory mUserOp
    ) internal virtual pure returns (uint256 requiredPrefund) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff003f0000, 1037618708543) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff003f0001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff003f0005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff003f6000, mUserOp) }
        unchecked {
            uint256 requiredGas = mUserOp.verificationGasLimit +
                            mUserOp.callGasLimit +
                            mUserOp.paymasterVerificationGasLimit +
                            mUserOp.paymasterPostOpGasLimit +
                            mUserOp.preVerificationGas;

            requiredPrefund = requiredGas * mUserOp.maxFeePerGas;
        }
    }

    /**
     * Create sender smart contract account if init code is provided.
     * @param opIndex  - The operation index.
     * @param opInfo   - The operation info.
     * @param initCode - The init code for the smart contract account.
     */
    function _createSenderIfNeeded(
        uint256 opIndex,
        UserOpInfo memory opInfo,
        bytes calldata initCode
    ) internal virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00400000, 1037618708544) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00400001, 4) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00400005, 602) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00406102, initCode.offset) }
        if (initCode.length != 0) {
            address sender = opInfo.mUserOp.sender;
            if (Eip7702Support._isEip7702InitCode(initCode)) {
                if (initCode.length > 20) {
                    // Already validated it is an EIP-7702 delegate (and hence, already has code) - see getUserOpHash()
                    // Note: Can be called multiple times as long as an appropriate initCode is supplied
                    senderCreator().initEip7702Sender{
                            gas: opInfo.mUserOp.verificationGasLimit
                        }(sender, initCode[20 :]);
                }
                return;
            }
            if (sender.code.length != 0)
                revert FailedOp(opIndex, "AA10 sender already constructed");
            if (initCode.length < 20) {
                revert FailedOp(opIndex, "AA99 initCode too small");
            }
            address sender1 = senderCreator().createSender{
                    gas: opInfo.mUserOp.verificationGasLimit
                }(initCode);
            if (sender1 == address(0))
                revert FailedOp(opIndex, "AA13 initCode failed or OOG");
            if (sender1 != sender)
                revert FailedOp(opIndex, "AA14 initCode must return sender");
            if (sender1.code.length == 0)
                revert FailedOp(opIndex, "AA15 initCode must create sender");
            address factory = address(bytes20(initCode[0 : 20]));
            emit AccountDeployed(
                opInfo.userOpHash,
                sender,
                factory,
                opInfo.mUserOp.paymaster
            );
        }
    }

    /**
     * Call account.validateUserOp.
     * Revert (with FailedOp) in case validateUserOp reverts, or account didn't send required prefund.
     * Decrement account's deposit if needed.
     * @param opIndex         - The operation index.
     * @param op              - The user operation.
     * @param opInfo          - The operation info.
     * @param requiredPrefund - The required prefund amount.
     * @return validationData - The account's validationData.
     */
    function _validateAccountPrepayment(
        uint256 opIndex,
        PackedUserOperation calldata op,
        UserOpInfo memory opInfo,
        uint256 requiredPrefund
    )
    internal virtual
    returns (
        uint256 validationData
    )
    {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00410000, 1037618708545) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00410001, 4) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00410005, 777) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00416003, requiredPrefund) }
        unchecked {
            MemoryUserOp memory mUserOp = opInfo.mUserOp;
            address sender = mUserOp.sender;
            _createSenderIfNeeded(opIndex, opInfo, op.initCode);
            address paymaster = mUserOp.paymaster;
            uint256 missingAccountFunds = 0;
            if (paymaster == address(0)) {
                uint256 bal = balanceOf(sender);
                missingAccountFunds = bal > requiredPrefund
                    ? 0
                    : requiredPrefund - bal;
            }
            validationData = _callValidateUserOp(opIndex, op, opInfo, missingAccountFunds);
            if (paymaster == address(0)) {
                if (!_tryDecrementDeposit(sender, requiredPrefund)) {
                    revert FailedOp(opIndex, "AA21 didn't pay prefund");
                }
            }
        }
    }

    /**
     * Make a call to the sender.validateUserOp() function.
     * Handle wrong output size by reverting with a FailedOp error.
     *
     * @param opIndex - index of the UserOperation in the bundle.
     * @param op - the packed UserOperation object.
     * @param opInfo - the in-memory UserOperation information.
     * @param missingAccountFunds - the amount of deposit the account has to make to cover the UserOperation gas.
     */
    function _callValidateUserOp(
        uint256 opIndex,
        PackedUserOperation calldata op,
        UserOpInfo memory opInfo,
        uint256 missingAccountFunds
    )
    internal virtual returns (uint256 validationData) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00420000, 1037618708546) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00420001, 4) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00420005, 777) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00426003, missingAccountFunds) }
        uint256 gasLimit = opInfo.mUserOp.verificationGasLimit;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000048,gasLimit)}
        address sender = opInfo.mUserOp.sender;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000049,sender)}
        bool success;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0000004a,success)}
        {
            uint256 saveFreePtr = _getFreePtr();
            bytes memory callData = abi.encodeCall(IAccount.validateUserOp, (op, opInfo.userOpHash, missingAccountFunds));
            assembly ("memory-safe"){
                success := call(gasLimit, sender, 0, add(callData, 0x20), mload(callData), 0, 32)
                validationData := mload(0)
            // any return data size other than 32 is considered failure
                if iszero(eq(returndatasize(), 32)) {
                    success := 0
                }
            }
            _restoreFreePtr(saveFreePtr);
        }
        if (!success) {
            if (sender.code.length == 0) {
                revert FailedOp(opIndex, "AA20 account not deployed");
            } else {
                revert FailedOpWithRevert(opIndex, "AA23 reverted", Exec.getReturnData(REVERT_REASON_MAX_LEN));
            }
        }
    }

    /**
     * In case the request has a paymaster:
     *  - Validate paymaster has enough deposit.
     *  - Call paymaster.validatePaymasterUserOp.
     *  - Revert with proper FailedOp in case paymaster reverts.
     *  - Decrement paymaster's deposit.
     * @param opIndex                            - The operation index.
     * @param op                                 - The user operation.
     * @param opInfo                             - The operation info.
     * @return context                           - The Paymaster-provided value to be passed to the 'postOp' function later
     * @return validationData                    - The Paymaster's validationData.
     */
    function _validatePaymasterPrepayment(
        uint256 opIndex,
        PackedUserOperation calldata op,
        UserOpInfo memory opInfo
    ) internal virtual returns (bytes memory context, uint256 validationData) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00430000, 1037618708547) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00430001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00430005, 97) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00436002, opInfo) }
        unchecked {
            uint256 preGas = gasleft();
            MemoryUserOp memory mUserOp = opInfo.mUserOp;
            address paymaster = mUserOp.paymaster;
            uint256 requiredPreFund = opInfo.prefund;
            if (!_tryDecrementDeposit(paymaster, requiredPreFund)) {
                revert FailedOp(opIndex, "AA31 paymaster deposit too low");
            }
            uint256 pmVerificationGasLimit = mUserOp.paymasterVerificationGasLimit;
            (context, validationData) = _callValidatePaymasterUserOp(opIndex, op, opInfo);
            if (preGas - gasleft() > pmVerificationGasLimit) {
                revert FailedOp(opIndex, "AA36 over paymasterVerificationGasLimit");
            }
        }
    }

    function _callValidatePaymasterUserOp(
        uint256 opIndex,
        PackedUserOperation calldata op,
        UserOpInfo memory opInfo
    ) internal returns (bytes memory context, uint256 validationData)  {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00440000, 1037618708548) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00440001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00440005, 97) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00446002, opInfo) }
        uint256 freePtr = _getFreePtr();assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0000004b,freePtr)}
        bytes memory validatePaymasterCall = abi.encodeCall(
            IPaymaster.validatePaymasterUserOp,
            (op, opInfo.userOpHash, opInfo.prefund)
        );assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0001004c,0)}
        address paymaster = opInfo.mUserOp.paymaster;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0000004d,paymaster)}
        uint256 paymasterVerificationGasLimit = opInfo.mUserOp.paymasterVerificationGasLimit;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0000004e,paymasterVerificationGasLimit)}
        bool success;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0000004f,success)}
        uint256 contextLength;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000050,contextLength)}
        uint256 contextOffset;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000051,contextOffset)}
        uint256 maxContextLength;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000052,maxContextLength)}
        uint256 len;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000053,len)}
        assembly ("memory-safe") {
            success := call(paymasterVerificationGasLimit, paymaster, 0, add(validatePaymasterCall, 0x20), mload(validatePaymasterCall), 0, 0)
            len := returndatasize()
            // return data from validatePaymasterUserOp is (bytes context, validationData)
            // encoded as:
            // 32 bytes offset of context (always 64)
            // 32 bytes of validationData
            // 32 bytes of context length
            // context data (rounded up, to 32 bytes boundary)
            // so entire buffer size is (at least) 96+content.length.
            //
            // we use freePtr, fetched before calling encodeCall, as return data pointer.
            // this way we reuse that memory without unnecessary memory expansion
            returndatacopy(freePtr, 0, len)
            validationData := mload(add(freePtr, 32))
            contextOffset := mload(freePtr)
            maxContextLength := sub(len, 96)
            context := add(freePtr, 64)
            contextLength := mload(context)
        }

        unchecked {
            if (!success || contextOffset != 64 || contextLength + 31 < maxContextLength) {
                revert FailedOpWithRevert(opIndex, "AA33 reverted", Exec.getReturnData(REVERT_REASON_MAX_LEN));
            }
        }
        finalizeAllocation(freePtr, len);
    }

    /**
     * Revert if either account validationData or paymaster validationData is expired.
     * @param opIndex                 - The operation index.
     * @param validationData          - The account validationData.
     * @param paymasterValidationData - The paymaster validationData.
     * @param expectedAggregator      - The expected aggregator.
     */
    function _validateAccountAndPaymasterValidationData(
        uint256 opIndex,
        uint256 validationData,
        uint256 paymasterValidationData,
        address expectedAggregator
    ) internal virtual view {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00450000, 1037618708549) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00450001, 4) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00450005, 585) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00456003, expectedAggregator) }
        (address aggregator, bool outOfTimeRange) = _getValidationData(
            validationData
        );assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00010054,0)}
        if (expectedAggregator != aggregator) {
            revert FailedOp(opIndex, "AA24 signature error");
        }
        if (outOfTimeRange) {
            revert FailedOp(opIndex, "AA22 expired or not due");
        }
        // pmAggregator is not a real signature aggregator: we don't have logic to handle it as address.
        // Non-zero address means that the paymaster fails due to some signature check (which is ok only during estimation).
        address pmAggregator;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000055,pmAggregator)}
        (pmAggregator, outOfTimeRange) = _getValidationData(
            paymasterValidationData
        );assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00020064,0)}
        if (pmAggregator != address(0)) {
            revert FailedOp(opIndex, "AA34 signature error");
        }
        if (outOfTimeRange) {
            revert FailedOp(opIndex, "AA32 paymaster expired or not due");
        }
    }

    /**
     * Parse validationData into its components.
     * @param validationData - The packed validation data (sigFailed, validAfter, validUntil).
     * @return aggregator the aggregator of the validationData
     * @return outOfTimeRange true if current time is outside the time range of this validationData.
     */
    function _getValidationData(
        uint256 validationData
    ) internal virtual view returns (address aggregator, bool outOfTimeRange) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00460000, 1037618708550) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00460001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00460005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00466000, validationData) }
        if (validationData == 0) {
            return (address(0), false);
        }
        ValidationData memory data = _parseValidationData(validationData);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00010056,0)}
        // solhint-disable-next-line not-rely-on-time
        outOfTimeRange = block.timestamp > data.validUntil || block.timestamp <= data.validAfter;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000065,outOfTimeRange)}
        aggregator = data.aggregator;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000066,aggregator)}
    }

    /**
     * Validate account and paymaster (if defined) and
     * also make sure total validation doesn't exceed verificationGasLimit.
     * This method is called off-chain (simulateValidation()) and on-chain (from handleOps)
     * @param opIndex    - The index of this userOp into the "opInfos" array.
     * @param userOp     - The packed calldata UserOperation structure to validate.
     * @param outOpInfo  - The empty unpacked in-memory UserOperation structure that will be filled in here.
     *
     * @return validationData          - The account's validationData.
     * @return paymasterValidationData - The paymaster's validationData.
     */
    function _validatePrepayment(
        uint256 opIndex,
        PackedUserOperation calldata userOp,
        UserOpInfo memory outOpInfo
    )
    internal virtual
    returns (uint256 validationData, uint256 paymasterValidationData)
    {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00470000, 1037618708551) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00470001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00470005, 97) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00476002, outOpInfo) }
        uint256 preGas = gasleft();assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000057,preGas)}
        MemoryUserOp memory mUserOp = outOpInfo.mUserOp;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00010058,0)}
        _copyUserOpToMemory(userOp, mUserOp);

        // getUserOpHash uses temporary allocations, no required after it returns
        uint256 freePtr = _getFreePtr();assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000059,freePtr)}
        outOpInfo.userOpHash = getUserOpHash(userOp);bytes32 certora_local103 = outOpInfo.userOpHash;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000067,certora_local103)}
        _restoreFreePtr(freePtr);

        // Validate all numeric values in userOp are well below 128 bit, so they can safely be added
        // and multiplied without causing overflow.
        uint256 verificationGasLimit = mUserOp.verificationGasLimit;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0000005a,verificationGasLimit)}
        uint256 maxGasValues = mUserOp.preVerificationGas |
                    verificationGasLimit |
                        mUserOp.callGasLimit |
                        mUserOp.paymasterVerificationGasLimit |
                        mUserOp.paymasterPostOpGasLimit |
                        mUserOp.maxFeePerGas |
                        mUserOp.maxPriorityFeePerGas;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0000005b,maxGasValues)}
        require(maxGasValues <= type(uint120).max, FailedOp(opIndex, "AA94 gas values overflow"));

        uint256 requiredPreFund = _getRequiredPrefund(mUserOp);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0000005c,requiredPreFund)}
        outOpInfo.prefund = requiredPreFund;uint256 certora_local104 = outOpInfo.prefund;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000068,certora_local104)}
        validationData = _validateAccountPrepayment(
            opIndex,
            userOp,
            outOpInfo,
            requiredPreFund
        );assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000069,validationData)}

        require(
            _validateAndUpdateNonce(mUserOp.sender, mUserOp.nonce),
            FailedOp(opIndex, "AA25 invalid account nonce")
        );

        unchecked {
            if (preGas - gasleft() > verificationGasLimit) {
                revert FailedOp(opIndex, "AA26 over verificationGasLimit");
            }
        }

        bytes memory context;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0001005d,0)}
        if (mUserOp.paymaster != address(0)) {
            (context, paymasterValidationData) = _validatePaymasterPrepayment(
                opIndex,
                userOp,
                outOpInfo
            );
        }
        unchecked {
            outOpInfo.contextOffset = _getOffsetOfMemoryBytes(context);
            outOpInfo.preOpGas = preGas - gasleft() + userOp.preVerificationGas;
        }
    }

    /**
     * Process post-operation, called just after the callData is executed.
     * If a paymaster is defined and its validation returned a non-empty context, its postOp is called.
     * The excess amount is refunded to the account (or paymaster - if it was used in the request).
     * @param mode      - Whether is called from innerHandleOp, or outside (postOpReverted).
     * @param opInfo    - UserOp fields and info collected during validation.
     * @param context   - The context returned in validatePaymasterUserOp.
     * @param actualGas - The gas used so far by this user operation.
     *
     * @return actualGasCost - the actual cost in eth this UserOperation paid for gas
     */
    function _postExecution(
        IPaymaster.PostOpMode mode,
        UserOpInfo memory opInfo,
        bytes memory context,
        uint256 actualGas
    ) internal virtual returns (uint256 actualGasCost) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00480000, 1037618708552) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00480001, 4) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00480005, 585) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00486003, actualGas) }
        uint256 preGas = gasleft();assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0000005e,preGas)}
        unchecked {
            address refundAddress;
            MemoryUserOp memory mUserOp = opInfo.mUserOp;
            uint256 gasPrice = _getUserOpGasPrice(mUserOp);

            address paymaster = mUserOp.paymaster;
        // Calculating a penalty for unused execution gas
            {
                uint256 executionGasUsed = actualGas - opInfo.preOpGas;
                // this check is required for the gas used within EntryPoint and not covered by explicit gas limits
                actualGas += _getUnusedGasPenalty(executionGasUsed, mUserOp.callGasLimit);
            }
            uint256 postOpUnusedGasPenalty;
            if (paymaster == address(0)) {
                refundAddress = mUserOp.sender;
            } else {
                refundAddress = paymaster;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0000007b,refundAddress)}
                if (context.length > 0) {
                    actualGasCost = actualGas * gasPrice;
                    uint256 postOpPreGas = gasleft();
                    if (mode != IPaymaster.PostOpMode.postOpReverted) {
                        try IPaymaster(paymaster).postOp{
                                gas: mUserOp.paymasterPostOpGasLimit
                            }(mode, context, actualGasCost, gasPrice)
                        // solhint-disable-next-line no-empty-blocks
                        {} catch {
                            bytes memory reason = Exec.getReturnData(REVERT_REASON_MAX_LEN);
                            revert PostOpReverted(reason);
                        }
                    }
                    // Calculating a penalty for unused postOp gas
                    // note that if postOp is reverted, the maximum penalty (10% of postOpGasLimit) is charged.
                    uint256 postOpGasUsed = postOpPreGas - gasleft();
                    postOpUnusedGasPenalty = _getUnusedGasPenalty(postOpGasUsed, mUserOp.paymasterPostOpGasLimit);
                }
            }
            actualGas += preGas - gasleft() + postOpUnusedGasPenalty;
            actualGasCost = actualGas * gasPrice;
            uint256 prefund = opInfo.prefund;
            if (prefund < actualGasCost) {
                if (mode == IPaymaster.PostOpMode.postOpReverted) {
                    actualGasCost = prefund;
                    _emitPrefundTooLow(opInfo);
                    _emitUserOperationEvent(opInfo, false, actualGasCost, actualGas);
                } else {
                    assembly ("memory-safe") {
                        mstore(0, INNER_REVERT_LOW_PREFUND)
                        revert(0, 32)
                    }
                }
            } else {
                uint256 refund = prefund - actualGasCost;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000075,refund)}
                _incrementDeposit(refundAddress, refund);
                bool success = mode == IPaymaster.PostOpMode.opSucceeded;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000076,success)}
                _emitUserOperationEvent(opInfo, success, actualGasCost, actualGas);
            }
        } // unchecked
    }

    /**
     * The gas price this UserOp agrees to pay.
     * Relayer/block builder might submit the TX with higher priorityFee, but the user should not be affected.
     * @param mUserOp - The userOp to get the gas price from.
     */
    function _getUserOpGasPrice(
        MemoryUserOp memory mUserOp
    ) internal view returns (uint256) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff004e0000, 1037618708558) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff004e0001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff004e0005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff004e6000, mUserOp) }
        unchecked {
            uint256 maxFeePerGas = mUserOp.maxFeePerGas;
            uint256 maxPriorityFeePerGas = mUserOp.maxPriorityFeePerGas;
            return min(maxFeePerGas, maxPriorityFeePerGas + block.basefee);
        }
    }

    /**
     * The offset of the given bytes in memory.
     * @param data - The bytes to get the offset of.
     */
    function _getOffsetOfMemoryBytes(
        bytes memory data
    ) internal pure returns (uint256 offset) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff004d0000, 1037618708557) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff004d0001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff004d0005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff004d6000, data) }
        assembly ("memory-safe") {
            offset := data
        }
    }

    /**
     * The bytes in memory at the given offset.
     * @param offset - The offset to get the bytes from.
     */
    function _getMemoryBytesFromOffset(
        uint256 offset
    ) internal pure returns (bytes memory data) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff004c0000, 1037618708556) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff004c0001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff004c0005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff004c6000, offset) }
        assembly ("memory-safe") {
            data := offset
        }
    }

    /**
     * save free memory pointer.
     * save "free memory" pointer, so that it can be restored later using restoreFreePtr.
     * This reduce unneeded memory expansion, and reduce memory expansion cost.
     * NOTE: all dynamic allocations between saveFreePtr and restoreFreePtr MUST NOT be used after restoreFreePtr is called.
     */
    function _getFreePtr() internal pure returns (uint256 ptr) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff004f0000, 1037618708559) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff004f0001, 0) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff004f0004, 0) }
        assembly ("memory-safe") {
            ptr := mload(0x40)
        }
    }

    /**
     * restore free memory pointer.
     * any allocated memory since saveFreePtr is cleared, and MUST NOT be accessed later.
     */
    function _restoreFreePtr(uint256 ptr) internal pure {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00500000, 1037618708560) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00500001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00500005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00506000, ptr) }
        assembly ("memory-safe") {
            mstore(0x40, ptr)
        }
    }

    function _getUnusedGasPenalty(uint256 gasUsed, uint256 gasLimit) internal pure returns (uint256) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00510000, 1037618708561) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00510001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00510005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00516001, gasLimit) }
        unchecked {
            if (gasLimit <= gasUsed + PENALTY_GAS_THRESHOLD) {
                return 0;
            }
            uint256 unusedGas = gasLimit - gasUsed;
            uint256 unusedGasPenalty = (unusedGas * UNUSED_GAS_PENALTY_PERCENT) / 100;
            return unusedGasPenalty;
        }
    }
}
