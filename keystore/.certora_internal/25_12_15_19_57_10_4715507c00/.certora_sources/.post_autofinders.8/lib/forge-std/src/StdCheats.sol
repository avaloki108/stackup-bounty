// SPDX-License-Identifier: MIT
pragma solidity >=0.6.2 <0.9.0;

pragma experimental ABIEncoderV2;

import {StdStorage, stdStorage} from "./StdStorage.sol";
import {console2} from "./console2.sol";
import {Vm} from "./Vm.sol";

abstract contract StdCheatsSafe {
    Vm private constant vm = Vm(address(uint160(uint256(keccak256("hevm cheat code")))));

    uint256 private constant UINT256_MAX =
        115792089237316195423570985008687907853269984665640564039457584007913129639935;

    bool private gasMeteringOff;

    // Data structures to parse Transaction objects from the broadcast artifact
    // that conform to EIP1559. The Raw structs is what is parsed from the JSON
    // and then converted to the one that is used by the user for better UX.

    struct RawTx1559 {
        string[] arguments;
        address contractAddress;
        string contractName;
        // json value name = function
        string functionSig;
        bytes32 hash;
        // json value name = tx
        RawTx1559Detail txDetail;
        // json value name = type
        string opcode;
    }

    struct RawTx1559Detail {
        AccessList[] accessList;
        bytes data;
        address from;
        bytes gas;
        bytes nonce;
        address to;
        bytes txType;
        bytes value;
    }

    struct Tx1559 {
        string[] arguments;
        address contractAddress;
        string contractName;
        string functionSig;
        bytes32 hash;
        Tx1559Detail txDetail;
        string opcode;
    }

    struct Tx1559Detail {
        AccessList[] accessList;
        bytes data;
        address from;
        uint256 gas;
        uint256 nonce;
        address to;
        uint256 txType;
        uint256 value;
    }

    // Data structures to parse Transaction objects from the broadcast artifact
    // that DO NOT conform to EIP1559. The Raw structs is what is parsed from the JSON
    // and then converted to the one that is used by the user for better UX.

    struct TxLegacy {
        string[] arguments;
        address contractAddress;
        string contractName;
        string functionSig;
        string hash;
        string opcode;
        TxDetailLegacy transaction;
    }

    struct TxDetailLegacy {
        AccessList[] accessList;
        uint256 chainId;
        bytes data;
        address from;
        uint256 gas;
        uint256 gasPrice;
        bytes32 hash;
        uint256 nonce;
        bytes1 opcode;
        bytes32 r;
        bytes32 s;
        uint256 txType;
        address to;
        uint8 v;
        uint256 value;
    }

    struct AccessList {
        address accessAddress;
        bytes32[] storageKeys;
    }

    // Data structures to parse Receipt objects from the broadcast artifact.
    // The Raw structs is what is parsed from the JSON
    // and then converted to the one that is used by the user for better UX.

    struct RawReceipt {
        bytes32 blockHash;
        bytes blockNumber;
        address contractAddress;
        bytes cumulativeGasUsed;
        bytes effectiveGasPrice;
        address from;
        bytes gasUsed;
        RawReceiptLog[] logs;
        bytes logsBloom;
        bytes status;
        address to;
        bytes32 transactionHash;
        bytes transactionIndex;
    }

    struct Receipt {
        bytes32 blockHash;
        uint256 blockNumber;
        address contractAddress;
        uint256 cumulativeGasUsed;
        uint256 effectiveGasPrice;
        address from;
        uint256 gasUsed;
        ReceiptLog[] logs;
        bytes logsBloom;
        uint256 status;
        address to;
        bytes32 transactionHash;
        uint256 transactionIndex;
    }

    // Data structures to parse the entire broadcast artifact, assuming the
    // transactions conform to EIP1559.

    struct EIP1559ScriptArtifact {
        string[] libraries;
        string path;
        string[] pending;
        Receipt[] receipts;
        uint256 timestamp;
        Tx1559[] transactions;
        TxReturn[] txReturns;
    }

    struct RawEIP1559ScriptArtifact {
        string[] libraries;
        string path;
        string[] pending;
        RawReceipt[] receipts;
        TxReturn[] txReturns;
        uint256 timestamp;
        RawTx1559[] transactions;
    }

    struct RawReceiptLog {
        // json value = address
        address logAddress;
        bytes32 blockHash;
        bytes blockNumber;
        bytes data;
        bytes logIndex;
        bool removed;
        bytes32[] topics;
        bytes32 transactionHash;
        bytes transactionIndex;
        bytes transactionLogIndex;
    }

    struct ReceiptLog {
        // json value = address
        address logAddress;
        bytes32 blockHash;
        uint256 blockNumber;
        bytes data;
        uint256 logIndex;
        bytes32[] topics;
        uint256 transactionIndex;
        uint256 transactionLogIndex;
        bool removed;
    }

    struct TxReturn {
        string internalType;
        string value;
    }

    struct Account {
        address addr;
        uint256 key;
    }

    enum AddressType {
        Payable,
        NonPayable,
        ZeroAddress,
        Precompile,
        ForgeAddress
    }

    // Checks that `addr` is not blacklisted by token contracts that have a blacklist.
    function assumeNotBlacklisted(address token, address addr) internal view virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e630000, 1037618712163) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e630001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e630005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e636001, addr) }
        // Nothing to check if `token` is not a contract.
        uint256 tokenCodeSize;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000045,tokenCodeSize)}
        assembly {
            tokenCodeSize := extcodesize(token)
        }
        require(tokenCodeSize > 0, "StdCheats assumeNotBlacklisted(address,address): Token address is not a contract.");

        bool success;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000046,success)}
        bytes memory returnData;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00010047,0)}

        // 4-byte selector for `isBlacklisted(address)`, used by USDC.
        (success, returnData) = token.staticcall(abi.encodeWithSelector(0xfe575a87, addr));assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00020079,0)}
        vm.assume(!success || abi.decode(returnData, (bool)) == false);

        // 4-byte selector for `isBlackListed(address)`, used by USDT.
        (success, returnData) = token.staticcall(abi.encodeWithSelector(0xe47d6060, addr));assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0002007a,0)}
        vm.assume(!success || abi.decode(returnData, (bool)) == false);
    }

    // Checks that `addr` is not blacklisted by token contracts that have a blacklist.
    // This is identical to `assumeNotBlacklisted(address,address)` but with a different name, for
    // backwards compatibility, since this name was used in the original PR which already has
    // a release. This function can be removed in a future release once we want a breaking change.
    function assumeNoBlacklisted(address token, address addr) internal view virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e640000, 1037618712164) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e640001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e640005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e646001, addr) }
        assumeNotBlacklisted(token, addr);
    }

    function assumeAddressIsNot(address addr, AddressType addressType) internal virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e660000, 1037618712166) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e660001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e660005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e666001, addressType) }
        if (addressType == AddressType.Payable) {
            assumeNotPayable(addr);
        } else if (addressType == AddressType.NonPayable) {
            assumePayable(addr);
        } else if (addressType == AddressType.ZeroAddress) {
            assumeNotZeroAddress(addr);
        } else if (addressType == AddressType.Precompile) {
            assumeNotPrecompile(addr);
        } else if (addressType == AddressType.ForgeAddress) {
            assumeNotForgeAddress(addr);
        }
    }

    function assumeAddressIsNot(address addr, AddressType addressType1, AddressType addressType2) internal virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e670000, 1037618712167) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e670001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e670005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e676002, addressType2) }
        assumeAddressIsNot(addr, addressType1);
        assumeAddressIsNot(addr, addressType2);
    }

    function assumeAddressIsNot(
        address addr,
        AddressType addressType1,
        AddressType addressType2,
        AddressType addressType3
    ) internal virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e650000, 1037618712165) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e650001, 4) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e650005, 585) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e656003, addressType3) }
        assumeAddressIsNot(addr, addressType1);
        assumeAddressIsNot(addr, addressType2);
        assumeAddressIsNot(addr, addressType3);
    }

    function assumeAddressIsNot(
        address addr,
        AddressType addressType1,
        AddressType addressType2,
        AddressType addressType3,
        AddressType addressType4
    ) internal virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e680000, 1037618712168) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e680001, 5) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e680005, 4681) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e686004, addressType4) }
        assumeAddressIsNot(addr, addressType1);
        assumeAddressIsNot(addr, addressType2);
        assumeAddressIsNot(addr, addressType3);
        assumeAddressIsNot(addr, addressType4);
    }

    // This function checks whether an address, `addr`, is payable. It works by sending 1 wei to
    // `addr` and checking the `success` return value.
    // NOTE: This function may result in state changes depending on the fallback/receive logic
    // implemented by `addr`, which should be taken into account when this function is used.
    function _isPayable(address addr) private returns (bool) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e690000, 1037618712169) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e690001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e690005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e696000, addr) }
        require(
            addr.balance < UINT256_MAX,
            "StdCheats _isPayable(address): Balance equals max uint256, so it cannot receive any more funds"
        );
        uint256 origBalanceTest = address(this).balance;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000048,origBalanceTest)}
        uint256 origBalanceAddr = address(addr).balance;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000049,origBalanceAddr)}

        vm.deal(address(this), 1);
        (bool success,) = payable(addr).call{value: 1}("");assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0001004a,0)}

        // reset balances
        vm.deal(address(this), origBalanceTest);
        vm.deal(addr, origBalanceAddr);

        return success;
    }

    // NOTE: This function may result in state changes depending on the fallback/receive logic
    // implemented by `addr`, which should be taken into account when this function is used. See the
    // `_isPayable` method for more information.
    function assumePayable(address addr) internal virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e6a0000, 1037618712170) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e6a0001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e6a0005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e6a6000, addr) }
        vm.assume(_isPayable(addr));
    }

    function assumeNotPayable(address addr) internal virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e6b0000, 1037618712171) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e6b0001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e6b0005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e6b6000, addr) }
        vm.assume(!_isPayable(addr));
    }

    function assumeNotZeroAddress(address addr) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e6c0000, 1037618712172) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e6c0001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e6c0005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e6c6000, addr) }
        vm.assume(addr != address(0));
    }

    function assumeNotPrecompile(address addr) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e6d0000, 1037618712173) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e6d0001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e6d0005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e6d6000, addr) }
        assumeNotPrecompile(addr, _pureChainId());
    }

    function assumeNotPrecompile(address addr, uint256 chainId) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e6e0000, 1037618712174) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e6e0001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e6e0005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e6e6001, chainId) }
        // Note: For some chains like Optimism these are technically predeploys (i.e. bytecode placed at a specific
        // address), but the same rationale for excluding them applies so we include those too.

        // These are reserved by Ethereum and may be on all EVM-compatible chains.
        vm.assume(addr < address(0x1) || addr > address(0xff));

        // forgefmt: disable-start
        if (chainId == 10 || chainId == 420) {
            // https://github.com/ethereum-optimism/optimism/blob/eaa371a0184b56b7ca6d9eb9cb0a2b78b2ccd864/op-bindings/predeploys/addresses.go#L6-L21
            vm.assume(addr < address(0x4200000000000000000000000000000000000000) || addr > address(0x4200000000000000000000000000000000000800));
        } else if (chainId == 42161 || chainId == 421613) {
            // https://developer.arbitrum.io/useful-addresses#arbitrum-precompiles-l2-same-on-all-arb-chains
            vm.assume(addr < address(0x0000000000000000000000000000000000000064) || addr > address(0x0000000000000000000000000000000000000068));
        } else if (chainId == 43114 || chainId == 43113) {
            // https://github.com/ava-labs/subnet-evm/blob/47c03fd007ecaa6de2c52ea081596e0a88401f58/precompile/params.go#L18-L59
            vm.assume(addr < address(0x0100000000000000000000000000000000000000) || addr > address(0x01000000000000000000000000000000000000ff));
            vm.assume(addr < address(0x0200000000000000000000000000000000000000) || addr > address(0x02000000000000000000000000000000000000FF));
            vm.assume(addr < address(0x0300000000000000000000000000000000000000) || addr > address(0x03000000000000000000000000000000000000Ff));
        }
        // forgefmt: disable-end
    }

    function assumeNotForgeAddress(address addr) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e6f0000, 1037618712175) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e6f0001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e6f0005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e6f6000, addr) }
        // vm, console, and Create2Deployer addresses
        vm.assume(
            addr != address(vm) && addr != 0x000000000000000000636F6e736F6c652e6c6f67
                && addr != 0x4e59b44847b379578588920cA78FbF26c0B4956C
        );
    }

    function assumeUnusedAddress(address addr) internal view virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e700000, 1037618712176) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e700001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e700005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e706000, addr) }
        uint256 size;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0000004b,size)}
        assembly {
            size := extcodesize(addr)
        }
        vm.assume(size == 0);

        assumeNotPrecompile(addr);
        assumeNotZeroAddress(addr);
        assumeNotForgeAddress(addr);
    }

    function readEIP1559ScriptArtifact(string memory path)
        internal
        view
        virtual
        returns (EIP1559ScriptArtifact memory)
    {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e710000, 1037618712177) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e710001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e710005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e716000, path) }
        string memory data = vm.readFile(path);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0001004c,0)}
        bytes memory parsedData = vm.parseJson(data);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0001004d,0)}
        RawEIP1559ScriptArtifact memory rawArtifact = abi.decode(parsedData, (RawEIP1559ScriptArtifact));assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0001004e,0)}
        EIP1559ScriptArtifact memory artifact;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0001004f,0)}
        artifact.libraries = rawArtifact.libraries;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0002007b,0)}
        artifact.path = rawArtifact.path;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0002007c,0)}
        artifact.timestamp = rawArtifact.timestamp;uint256 certora_local125 = artifact.timestamp;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0000007d,certora_local125)}
        artifact.pending = rawArtifact.pending;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0002007e,0)}
        artifact.txReturns = rawArtifact.txReturns;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0002007f,0)}
        artifact.receipts = rawToConvertedReceipts(rawArtifact.receipts);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00020080,0)}
        artifact.transactions = rawToConvertedEIPTx1559s(rawArtifact.transactions);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00020081,0)}
        return artifact;
    }

    function rawToConvertedEIPTx1559s(RawTx1559[] memory rawTxs) internal pure virtual returns (Tx1559[] memory) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e720000, 1037618712178) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e720001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e720005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e726000, rawTxs) }
        Tx1559[] memory txs = new Tx1559[](rawTxs.length);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00010050,0)}
        for (uint256 i; i < rawTxs.length; i++) {
            txs[i] = rawToConvertedEIPTx1559(rawTxs[i]);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000200a4,0)}
        }
        return txs;
    }

    function rawToConvertedEIPTx1559(RawTx1559 memory rawTx) internal pure virtual returns (Tx1559 memory) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e7f0000, 1037618712191) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e7f0001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e7f0005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e7f6000, rawTx) }
        Tx1559 memory transaction;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00010051,0)}
        transaction.arguments = rawTx.arguments;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00020082,0)}
        transaction.contractName = rawTx.contractName;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00020083,0)}
        transaction.functionSig = rawTx.functionSig;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00020084,0)}
        transaction.hash = rawTx.hash;bytes32 certora_local133 = transaction.hash;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000085,certora_local133)}
        transaction.txDetail = rawToConvertedEIP1559Detail(rawTx.txDetail);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00020086,0)}
        transaction.opcode = rawTx.opcode;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00020087,0)}
        return transaction;
    }

    function rawToConvertedEIP1559Detail(RawTx1559Detail memory rawDetail)
        internal
        pure
        virtual
        returns (Tx1559Detail memory)
    {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e7e0000, 1037618712190) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e7e0001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e7e0005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e7e6000, rawDetail) }
        Tx1559Detail memory txDetail;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00010052,0)}
        txDetail.data = rawDetail.data;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00020088,0)}
        txDetail.from = rawDetail.from;address certora_local137 = txDetail.from;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000089,certora_local137)}
        txDetail.to = rawDetail.to;address certora_local138 = txDetail.to;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0000008a,certora_local138)}
        txDetail.nonce = _bytesToUint(rawDetail.nonce);uint256 certora_local139 = txDetail.nonce;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0000008b,certora_local139)}
        txDetail.txType = _bytesToUint(rawDetail.txType);uint256 certora_local140 = txDetail.txType;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0000008c,certora_local140)}
        txDetail.value = _bytesToUint(rawDetail.value);uint256 certora_local141 = txDetail.value;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0000008d,certora_local141)}
        txDetail.gas = _bytesToUint(rawDetail.gas);uint256 certora_local142 = txDetail.gas;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0000008e,certora_local142)}
        txDetail.accessList = rawDetail.accessList;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0002008f,0)}
        return txDetail;
    }

    function readTx1559s(string memory path) internal view virtual returns (Tx1559[] memory) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e7d0000, 1037618712189) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e7d0001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e7d0005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e7d6000, path) }
        string memory deployData = vm.readFile(path);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00010053,0)}
        bytes memory parsedDeployData = vm.parseJson(deployData, ".transactions");assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00010054,0)}
        RawTx1559[] memory rawTxs = abi.decode(parsedDeployData, (RawTx1559[]));assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00010055,0)}
        return rawToConvertedEIPTx1559s(rawTxs);
    }

    function readTx1559(string memory path, uint256 index) internal view virtual returns (Tx1559 memory) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e800000, 1037618712192) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e800001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e800005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e806001, index) }
        string memory deployData = vm.readFile(path);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00010056,0)}
        string memory key = string(abi.encodePacked(".transactions[", vm.toString(index), "]"));assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00010057,0)}
        bytes memory parsedDeployData = vm.parseJson(deployData, key);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00010058,0)}
        RawTx1559 memory rawTx = abi.decode(parsedDeployData, (RawTx1559));assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00010059,0)}
        return rawToConvertedEIPTx1559(rawTx);
    }

    // Analogous to readTransactions, but for receipts.
    function readReceipts(string memory path) internal view virtual returns (Receipt[] memory) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e810000, 1037618712193) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e810001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e810005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e816000, path) }
        string memory deployData = vm.readFile(path);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0001005a,0)}
        bytes memory parsedDeployData = vm.parseJson(deployData, ".receipts");assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0001005b,0)}
        RawReceipt[] memory rawReceipts = abi.decode(parsedDeployData, (RawReceipt[]));assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0001005c,0)}
        return rawToConvertedReceipts(rawReceipts);
    }

    function readReceipt(string memory path, uint256 index) internal view virtual returns (Receipt memory) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e820000, 1037618712194) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e820001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e820005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e826001, index) }
        string memory deployData = vm.readFile(path);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0001005d,0)}
        string memory key = string(abi.encodePacked(".receipts[", vm.toString(index), "]"));assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0001005e,0)}
        bytes memory parsedDeployData = vm.parseJson(deployData, key);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0001005f,0)}
        RawReceipt memory rawReceipt = abi.decode(parsedDeployData, (RawReceipt));assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00010060,0)}
        return rawToConvertedReceipt(rawReceipt);
    }

    function rawToConvertedReceipts(RawReceipt[] memory rawReceipts) internal pure virtual returns (Receipt[] memory) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e830000, 1037618712195) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e830001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e830005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e836000, rawReceipts) }
        Receipt[] memory receipts = new Receipt[](rawReceipts.length);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00010061,0)}
        for (uint256 i; i < rawReceipts.length; i++) {
            receipts[i] = rawToConvertedReceipt(rawReceipts[i]);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000200a5,0)}
        }
        return receipts;
    }

    function rawToConvertedReceipt(RawReceipt memory rawReceipt) internal pure virtual returns (Receipt memory) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e840000, 1037618712196) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e840001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e840005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e846000, rawReceipt) }
        Receipt memory receipt;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00010062,0)}
        receipt.blockHash = rawReceipt.blockHash;bytes32 certora_local144 = receipt.blockHash;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000090,certora_local144)}
        receipt.to = rawReceipt.to;address certora_local145 = receipt.to;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000091,certora_local145)}
        receipt.from = rawReceipt.from;address certora_local146 = receipt.from;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000092,certora_local146)}
        receipt.contractAddress = rawReceipt.contractAddress;address certora_local147 = receipt.contractAddress;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000093,certora_local147)}
        receipt.effectiveGasPrice = _bytesToUint(rawReceipt.effectiveGasPrice);uint256 certora_local148 = receipt.effectiveGasPrice;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000094,certora_local148)}
        receipt.cumulativeGasUsed = _bytesToUint(rawReceipt.cumulativeGasUsed);uint256 certora_local149 = receipt.cumulativeGasUsed;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000095,certora_local149)}
        receipt.gasUsed = _bytesToUint(rawReceipt.gasUsed);uint256 certora_local150 = receipt.gasUsed;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000096,certora_local150)}
        receipt.status = _bytesToUint(rawReceipt.status);uint256 certora_local151 = receipt.status;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000097,certora_local151)}
        receipt.transactionIndex = _bytesToUint(rawReceipt.transactionIndex);uint256 certora_local152 = receipt.transactionIndex;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000098,certora_local152)}
        receipt.blockNumber = _bytesToUint(rawReceipt.blockNumber);uint256 certora_local153 = receipt.blockNumber;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000099,certora_local153)}
        receipt.logs = rawToConvertedReceiptLogs(rawReceipt.logs);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0002009a,0)}
        receipt.logsBloom = rawReceipt.logsBloom;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0002009b,0)}
        receipt.transactionHash = rawReceipt.transactionHash;bytes32 certora_local156 = receipt.transactionHash;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0000009c,certora_local156)}
        return receipt;
    }

    function rawToConvertedReceiptLogs(RawReceiptLog[] memory rawLogs)
        internal
        pure
        virtual
        returns (ReceiptLog[] memory)
    {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e850000, 1037618712197) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e850001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e850005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e856000, rawLogs) }
        ReceiptLog[] memory logs = new ReceiptLog[](rawLogs.length);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00010063,0)}
        for (uint256 i; i < rawLogs.length; i++) {
            logs[i].logAddress = rawLogs[i].logAddress;address certora_local166 = logs[i].logAddress;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000000a6,certora_local166)}
            logs[i].blockHash = rawLogs[i].blockHash;bytes32 certora_local167 = logs[i].blockHash;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000000a7,certora_local167)}
            logs[i].blockNumber = _bytesToUint(rawLogs[i].blockNumber);uint256 certora_local168 = logs[i].blockNumber;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000000a8,certora_local168)}
            logs[i].data = rawLogs[i].data;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000200a9,0)}
            logs[i].logIndex = _bytesToUint(rawLogs[i].logIndex);uint256 certora_local170 = logs[i].logIndex;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000000aa,certora_local170)}
            logs[i].topics = rawLogs[i].topics;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000200ab,0)}
            logs[i].transactionIndex = _bytesToUint(rawLogs[i].transactionIndex);uint256 certora_local172 = logs[i].transactionIndex;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000000ac,certora_local172)}
            logs[i].transactionLogIndex = _bytesToUint(rawLogs[i].transactionLogIndex);uint256 certora_local173 = logs[i].transactionLogIndex;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000000ad,certora_local173)}
            logs[i].removed = rawLogs[i].removed;bool certora_local174 = logs[i].removed;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000000ae,certora_local174)}
        }
        return logs;
    }

    // Deploy a contract by fetching the contract bytecode from
    // the artifacts directory
    // e.g. `deployCode(code, abi.encode(arg1,arg2,arg3))`
    function deployCode(string memory what, bytes memory args) internal virtual returns (address addr) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e860000, 1037618712198) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e860001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e860005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e866001, args) }
        bytes memory bytecode = abi.encodePacked(vm.getCode(what), args);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00010064,0)}
        /// @solidity memory-safe-assembly
        assembly {
            addr := create(0, add(bytecode, 0x20), mload(bytecode))
        }

        require(addr != address(0), "StdCheats deployCode(string,bytes): Deployment failed.");
    }

    function deployCode(string memory what) internal virtual returns (address addr) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e7a0000, 1037618712186) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e7a0001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e7a0005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e7a6000, what) }
        bytes memory bytecode = vm.getCode(what);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00010065,0)}
        /// @solidity memory-safe-assembly
        assembly {
            addr := create(0, add(bytecode, 0x20), mload(bytecode))
        }

        require(addr != address(0), "StdCheats deployCode(string): Deployment failed.");
    }

    /// @dev deploy contract with value on construction
    function deployCode(string memory what, bytes memory args, uint256 val) internal virtual returns (address addr) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e7b0000, 1037618712187) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e7b0001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e7b0005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e7b6002, val) }
        bytes memory bytecode = abi.encodePacked(vm.getCode(what), args);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00010066,0)}
        /// @solidity memory-safe-assembly
        assembly {
            addr := create(val, add(bytecode, 0x20), mload(bytecode))
        }

        require(addr != address(0), "StdCheats deployCode(string,bytes,uint256): Deployment failed.");
    }

    function deployCode(string memory what, uint256 val) internal virtual returns (address addr) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e7c0000, 1037618712188) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e7c0001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e7c0005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e7c6001, val) }
        bytes memory bytecode = vm.getCode(what);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00010067,0)}
        /// @solidity memory-safe-assembly
        assembly {
            addr := create(val, add(bytecode, 0x20), mload(bytecode))
        }

        require(addr != address(0), "StdCheats deployCode(string,uint256): Deployment failed.");
    }

    // creates a labeled address and the corresponding private key
    function makeAddrAndKey(string memory name) internal virtual returns (address addr, uint256 privateKey) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e730000, 1037618712179) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e730001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e730005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e736000, name) }
        privateKey = uint256(keccak256(abi.encodePacked(name)));assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0000009d,privateKey)}
        addr = vm.addr(privateKey);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0000009e,addr)}
        vm.label(addr, name);
    }

    // creates a labeled address
    function makeAddr(string memory name) internal virtual returns (address addr) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e740000, 1037618712180) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e740001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e740005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e746000, name) }
        (addr,) = makeAddrAndKey(name);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0002009f,0)}
    }

    // Destroys an account immediately, sending the balance to beneficiary.
    // Destroying means: balance will be zero, code will be empty, and nonce will be 0
    // This is similar to selfdestruct but not identical: selfdestruct destroys code and nonce
    // only after tx ends, this will run immediately.
    function destroyAccount(address who, address beneficiary) internal virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e750000, 1037618712181) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e750001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e750005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e756001, beneficiary) }
        uint256 currBalance = who.balance;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000068,currBalance)}
        vm.etch(who, abi.encode());
        vm.deal(who, 0);
        vm.resetNonce(who);

        uint256 beneficiaryBalance = beneficiary.balance;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000069,beneficiaryBalance)}
        vm.deal(beneficiary, currBalance + beneficiaryBalance);
    }

    // creates a struct containing both a labeled address and the corresponding private key
    function makeAccount(string memory name) internal virtual returns (Account memory account) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e760000, 1037618712182) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e760001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e760005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e766000, name) }
        (account.addr, account.key) = makeAddrAndKey(name);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000200a0,0)}
    }

    function deriveRememberKey(string memory mnemonic, uint32 index)
        internal
        virtual
        returns (address who, uint256 privateKey)
    {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e770000, 1037618712183) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e770001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e770005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e776001, index) }
        privateKey = vm.deriveKey(mnemonic, index);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000000a1,privateKey)}
        who = vm.rememberKey(privateKey);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000000a2,who)}
    }

    function _bytesToUint(bytes memory b) private pure returns (uint256) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e780000, 1037618712184) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e780001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e780005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e786000, b) }
        require(b.length <= 32, "StdCheats _bytesToUint(bytes): Bytes length exceeds 32.");
        return abi.decode(abi.encodePacked(new bytes(32 - b.length), b), (uint256));
    }

    function isFork() internal view virtual returns (bool status) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e790000, 1037618712185) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e790001, 0) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e790004, 0) }
        try vm.activeFork() {
            status = true;
        } catch (bytes memory) {}
    }

    modifier skipWhenForking() {
        if (!isFork()) {
            _;
        }
    }

    modifier skipWhenNotForking() {
        if (isFork()) {
            _;
        }
    }

    modifier noGasMetering() {
        vm.pauseGasMetering();
        // To prevent turning gas monitoring back on with nested functions that use this modifier,
        // we check if gasMetering started in the off position. If it did, we don't want to turn
        // it back on until we exit the top level function that used the modifier
        //
        // i.e. funcA() noGasMetering { funcB() }, where funcB has noGasMetering as well.
        // funcA will have `gasStartedOff` as false, funcB will have it as true,
        // so we only turn metering back on at the end of the funcA
        bool gasStartedOff = gasMeteringOff;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0000006a,gasStartedOff)}
        gasMeteringOff = true;

        _;

        // if gas metering was on when this modifier was called, turn it back on at the end
        if (!gasStartedOff) {
            gasMeteringOff = false;
            vm.resumeGasMetering();
        }
    }

    // We use this complex approach of `_viewChainId` and `_pureChainId` to ensure there are no
    // compiler warnings when accessing chain ID in any solidity version supported by forge-std. We
    // can't simply access the chain ID in a normal view or pure function because the solc View Pure
    // Checker changed `chainid` from pure to view in 0.8.0.
    function _viewChainId() private view returns (uint256 chainId) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e870000, 1037618712199) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e870001, 0) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e870004, 0) }
        // Assembly required since `block.chainid` was introduced in 0.8.0.
        assembly {
            chainId := chainid()
        }

        address(this); // Silence warnings in older Solc versions.
    }

    function _pureChainId() private pure returns (uint256 chainId) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e880000, 1037618712200) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e880001, 0) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e880004, 0) }
        function() internal view returns (uint256) fnIn = _viewChainId;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0001006b,0)}
        function() internal pure returns (uint256) pureChainId;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0001006c,0)}
        assembly {
            pureChainId := fnIn
        }
        chainId = pureChainId();assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000000a3,chainId)}
    }
}

// Wrappers around cheatcodes to avoid footguns
abstract contract StdCheats is StdCheatsSafe {
    using stdStorage for StdStorage;

    StdStorage private stdstore;
    Vm private constant vm = Vm(address(uint160(uint256(keccak256("hevm cheat code")))));
    address private constant CONSOLE2_ADDRESS = 0x000000000000000000636F6e736F6c652e6c6f67;

    // Skip forward or rewind time by the specified number of seconds
    function skip(uint256 time) internal virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e4d0000, 1037618712141) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e4d0001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e4d0005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e4d6000, time) }
        vm.warp(vm.getBlockTimestamp() + time);
    }

    function rewind(uint256 time) internal virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e4e0000, 1037618712142) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e4e0001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e4e0005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e4e6000, time) }
        vm.warp(vm.getBlockTimestamp() - time);
    }

    // Setup a prank from an address that has some ether
    function hoax(address msgSender) internal virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e500000, 1037618712144) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e500001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e500005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e506000, msgSender) }
        vm.deal(msgSender, 1 << 128);
        vm.prank(msgSender);
    }

    function hoax(address msgSender, uint256 give) internal virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e510000, 1037618712145) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e510001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e510005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e516001, give) }
        vm.deal(msgSender, give);
        vm.prank(msgSender);
    }

    function hoax(address msgSender, address origin) internal virtual {address certoraRename3663_1 = origin;assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e4f0000, 1037618712143) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e4f0001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e4f0005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e4f6001, certoraRename3663_1) }
        vm.deal(msgSender, 1 << 128);
        vm.prank(msgSender, origin);
    }

    function hoax(address msgSender, address origin, uint256 give) internal virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e520000, 1037618712146) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e520001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e520005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e526002, give) }
        vm.deal(msgSender, give);
        vm.prank(msgSender, origin);
    }

    // Start perpetual prank from an address that has some ether
    function startHoax(address msgSender) internal virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e530000, 1037618712147) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e530001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e530005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e536000, msgSender) }
        vm.deal(msgSender, 1 << 128);
        vm.startPrank(msgSender);
    }

    function startHoax(address msgSender, uint256 give) internal virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e540000, 1037618712148) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e540001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e540005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e546001, give) }
        vm.deal(msgSender, give);
        vm.startPrank(msgSender);
    }

    // Start perpetual prank from an address that has some ether
    // tx.origin is set to the origin parameter
    function startHoax(address msgSender, address origin) internal virtual {address certoraRename3669_1 = origin;assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e550000, 1037618712149) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e550001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e550005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e556001, certoraRename3669_1) }
        vm.deal(msgSender, 1 << 128);
        vm.startPrank(msgSender, origin);
    }

    function startHoax(address msgSender, address origin, uint256 give) internal virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e560000, 1037618712150) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e560001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e560005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e566002, give) }
        vm.deal(msgSender, give);
        vm.startPrank(msgSender, origin);
    }

    function changePrank(address msgSender) internal virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e570000, 1037618712151) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e570001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e570005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e576000, msgSender) }
        console2_log_StdCheats("changePrank is deprecated. Please use vm.startPrank instead.");
        vm.stopPrank();
        vm.startPrank(msgSender);
    }

    function changePrank(address msgSender, address txOrigin) internal virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e580000, 1037618712152) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e580001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e580005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e586001, txOrigin) }
        vm.stopPrank();
        vm.startPrank(msgSender, txOrigin);
    }

    // The same as Vm's `deal`
    // Use the alternative signature for ERC20 tokens
    function deal(address to, uint256 give) internal virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e590000, 1037618712153) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e590001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e590005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e596001, give) }
        vm.deal(to, give);
    }

    // Set the balance of an account for any ERC20 token
    // Use the alternative signature to update `totalSupply`
    function deal(address token, address to, uint256 give) internal virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e5a0000, 1037618712154) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e5a0001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e5a0005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e5a6002, give) }
        deal(token, to, give, false);
    }

    // Set the balance of an account for any ERC1155 token
    // Use the alternative signature to update `totalSupply`
    function dealERC1155(address token, address to, uint256 id, uint256 give) internal virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e5b0000, 1037618712155) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e5b0001, 4) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e5b0005, 585) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e5b6003, give) }
        dealERC1155(token, to, id, give, false);
    }

    function deal(address token, address to, uint256 give, bool adjust) internal virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e5c0000, 1037618712156) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e5c0001, 4) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e5c0005, 585) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e5c6003, adjust) }
        // get current balance
        (, bytes memory balData) = token.staticcall(abi.encodeWithSelector(0x70a08231, to));assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0001006d,0)}
        uint256 prevBal = abi.decode(balData, (uint256));assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0000006e,prevBal)}

        // update balance
        stdstore.target(token).sig(0x70a08231).with_key(to).checked_write(give);

        // update total supply
        if (adjust) {
            (, bytes memory totSupData) = token.staticcall(abi.encodeWithSelector(0x18160ddd));
            uint256 totSup = abi.decode(totSupData, (uint256));
            if (give < prevBal) {
                totSup -= (prevBal - give);
            } else {
                totSup += (give - prevBal);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000000af,totSup)}
            }
            stdstore.target(token).sig(0x18160ddd).checked_write(totSup);
        }
    }

    function dealERC1155(address token, address to, uint256 id, uint256 give, bool adjust) internal virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e5f0000, 1037618712159) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e5f0001, 5) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e5f0005, 4681) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e5f6004, adjust) }
        // get current balance
        (, bytes memory balData) = token.staticcall(abi.encodeWithSelector(0x00fdd58e, to, id));assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0001006f,0)}
        uint256 prevBal = abi.decode(balData, (uint256));assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000070,prevBal)}

        // update balance
        stdstore.target(token).sig(0x00fdd58e).with_key(to).with_key(id).checked_write(give);

        // update total supply
        if (adjust) {
            (, bytes memory totSupData) = token.staticcall(abi.encodeWithSelector(0xbd85b039, id));
            require(
                totSupData.length != 0,
                "StdCheats deal(address,address,uint,uint,bool): target contract is not ERC1155Supply."
            );
            uint256 totSup = abi.decode(totSupData, (uint256));
            if (give < prevBal) {
                totSup -= (prevBal - give);
            } else {
                totSup += (give - prevBal);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000000b0,totSup)}
            }
            stdstore.target(token).sig(0xbd85b039).with_key(id).checked_write(totSup);
        }
    }

    function dealERC721(address token, address to, uint256 id) internal virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e5e0000, 1037618712158) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e5e0001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e5e0005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e5e6002, id) }
        // check if token id is already minted and the actual owner.
        (bool successMinted, bytes memory ownerData) = token.staticcall(abi.encodeWithSelector(0x6352211e, id));assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00010071,0)}
        require(successMinted, "StdCheats deal(address,address,uint,bool): id not minted.");

        // get owner current balance
        (, bytes memory fromBalData) =
            token.staticcall(abi.encodeWithSelector(0x70a08231, abi.decode(ownerData, (address))));assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00010072,0)}
        uint256 fromPrevBal = abi.decode(fromBalData, (uint256));assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000073,fromPrevBal)}

        // get new user current balance
        (, bytes memory toBalData) = token.staticcall(abi.encodeWithSelector(0x70a08231, to));assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00010074,0)}
        uint256 toPrevBal = abi.decode(toBalData, (uint256));assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000075,toPrevBal)}

        // update balances
        stdstore.target(token).sig(0x70a08231).with_key(abi.decode(ownerData, (address))).checked_write(--fromPrevBal);
        stdstore.target(token).sig(0x70a08231).with_key(to).checked_write(++toPrevBal);

        // update owner
        stdstore.target(token).sig(0x6352211e).with_key(id).checked_write(to);
    }

    function deployCodeTo(string memory what, address where) internal virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e5d0000, 1037618712157) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e5d0001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e5d0005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e5d6001, where) }
        deployCodeTo(what, "", 0, where);
    }

    function deployCodeTo(string memory what, bytes memory args, address where) internal virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e600000, 1037618712160) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e600001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e600005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e606002, where) }
        deployCodeTo(what, args, 0, where);
    }

    function deployCodeTo(string memory what, bytes memory args, uint256 value, address where) internal virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e610000, 1037618712161) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e610001, 4) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e610005, 585) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e616003, where) }
        bytes memory creationCode = vm.getCode(what);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00010076,0)}
        vm.etch(where, abi.encodePacked(creationCode, args));
        (bool success, bytes memory runtimeBytecode) = where.call{value: value}("");assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00010077,0)}
        require(success, "StdCheats deployCodeTo(string,bytes,uint256,address): Failed to create runtime bytecode.");
        vm.etch(where, runtimeBytecode);
    }

    // Used to prevent the compilation of console, which shortens the compilation time when console is not used elsewhere.
    function console2_log_StdCheats(string memory p0) private view {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e620000, 1037618712162) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e620001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e620005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e626000, p0) }
        (bool status,) = address(CONSOLE2_ADDRESS).staticcall(abi.encodeWithSignature("log(string)", p0));assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00010078,0)}
        status;
    }
}
