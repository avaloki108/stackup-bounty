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
    function assumeNotBlacklisted(address token, address addr) internal view virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06d50000, 1037618710229) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06d50001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06d50005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06d56001, addr) }
        // Nothing to check if `token` is not a contract.
        uint256 tokenCodeSize;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000048,tokenCodeSize)}
        assembly {
            tokenCodeSize := extcodesize(token)
        }
        require(tokenCodeSize > 0, "StdCheats assumeNotBlacklisted(address,address): Token address is not a contract.");

        bool success;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000049,success)}
        bytes memory returnData;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0001004a,0)}

        // 4-byte selector for `isBlacklisted(address)`, used by USDC.
        (success, returnData) = token.staticcall(abi.encodeWithSelector(0xfe575a87, addr));assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0002007c,0)}
        vm.assume(!success || abi.decode(returnData, (bool)) == false);

        // 4-byte selector for `isBlackListed(address)`, used by USDT.
        (success, returnData) = token.staticcall(abi.encodeWithSelector(0xe47d6060, addr));assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0002007d,0)}
        vm.assume(!success || abi.decode(returnData, (bool)) == false);
    }

    // Checks that `addr` is not blacklisted by token contracts that have a blacklist.
    // This is identical to `assumeNotBlacklisted(address,address)` but with a different name, for
    // backwards compatibility, since this name was used in the original PR which already has
    // a release. This function can be removed in a future release once we want a breaking change.
    function assumeNoBlacklisted(address token, address addr) internal view virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06d60000, 1037618710230) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06d60001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06d60005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06d66001, addr) }
        assumeNotBlacklisted(token, addr);
    }

    function assumeAddressIsNot(address addr, AddressType addressType) internal virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06d80000, 1037618710232) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06d80001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06d80005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06d86001, addressType) }
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

    function assumeAddressIsNot(address addr, AddressType addressType1, AddressType addressType2) internal virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06d90000, 1037618710233) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06d90001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06d90005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06d96002, addressType2) }
        assumeAddressIsNot(addr, addressType1);
        assumeAddressIsNot(addr, addressType2);
    }

    function assumeAddressIsNot(
        address addr,
        AddressType addressType1,
        AddressType addressType2,
        AddressType addressType3
    ) internal virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06d70000, 1037618710231) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06d70001, 4) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06d70005, 585) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06d76003, addressType3) }
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
    ) internal virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06da0000, 1037618710234) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06da0001, 5) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06da0005, 4681) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06da6004, addressType4) }
        assumeAddressIsNot(addr, addressType1);
        assumeAddressIsNot(addr, addressType2);
        assumeAddressIsNot(addr, addressType3);
        assumeAddressIsNot(addr, addressType4);
    }

    // This function checks whether an address, `addr`, is payable. It works by sending 1 wei to
    // `addr` and checking the `success` return value.
    // NOTE: This function may result in state changes depending on the fallback/receive logic
    // implemented by `addr`, which should be taken into account when this function is used.
    function _isPayable(address addr) private returns (bool) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06db0000, 1037618710235) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06db0001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06db0005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06db6000, addr) }
        require(
            addr.balance < UINT256_MAX,
            "StdCheats _isPayable(address): Balance equals max uint256, so it cannot receive any more funds"
        );
        uint256 origBalanceTest = address(this).balance;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0000004b,origBalanceTest)}
        uint256 origBalanceAddr = address(addr).balance;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0000004c,origBalanceAddr)}

        vm.deal(address(this), 1);
        (bool success,) = payable(addr).call{value: 1}("");assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0001004d,0)}

        // reset balances
        vm.deal(address(this), origBalanceTest);
        vm.deal(addr, origBalanceAddr);

        return success;
    }

    // NOTE: This function may result in state changes depending on the fallback/receive logic
    // implemented by `addr`, which should be taken into account when this function is used. See the
    // `_isPayable` method for more information.
    function assumePayable(address addr) internal virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06dc0000, 1037618710236) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06dc0001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06dc0005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06dc6000, addr) }
        vm.assume(_isPayable(addr));
    }

    function assumeNotPayable(address addr) internal virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06dd0000, 1037618710237) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06dd0001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06dd0005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06dd6000, addr) }
        vm.assume(!_isPayable(addr));
    }

    function assumeNotZeroAddress(address addr) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06de0000, 1037618710238) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06de0001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06de0005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06de6000, addr) }
        vm.assume(addr != address(0));
    }

    function assumeNotPrecompile(address addr) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06df0000, 1037618710239) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06df0001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06df0005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06df6000, addr) }
        assumeNotPrecompile(addr, _pureChainId());
    }

    function assumeNotPrecompile(address addr, uint256 chainId) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06e00000, 1037618710240) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06e00001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06e00005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06e06001, chainId) }
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

    function assumeNotForgeAddress(address addr) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06e10000, 1037618710241) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06e10001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06e10005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06e16000, addr) }
        // vm, console, and Create2Deployer addresses
        vm.assume(
            addr != address(vm) && addr != 0x000000000000000000636F6e736F6c652e6c6f67
                && addr != 0x4e59b44847b379578588920cA78FbF26c0B4956C
        );
    }

    function assumeUnusedAddress(address addr) internal view virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06e20000, 1037618710242) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06e20001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06e20005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06e26000, addr) }
        uint256 size;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0000004e,size)}
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
    {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06e30000, 1037618710243) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06e30001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06e30005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06e36000, path) }
        string memory data = vm.readFile(path);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0001004f,0)}
        bytes memory parsedData = vm.parseJson(data);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00010050,0)}
        RawEIP1559ScriptArtifact memory rawArtifact = abi.decode(parsedData, (RawEIP1559ScriptArtifact));assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00010051,0)}
        EIP1559ScriptArtifact memory artifact;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00010052,0)}
        artifact.libraries = rawArtifact.libraries;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0002007e,0)}
        artifact.path = rawArtifact.path;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0002007f,0)}
        artifact.timestamp = rawArtifact.timestamp;uint256 certora_local128 = artifact.timestamp;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000080,certora_local128)}
        artifact.pending = rawArtifact.pending;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00020081,0)}
        artifact.txReturns = rawArtifact.txReturns;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00020082,0)}
        artifact.receipts = rawToConvertedReceipts(rawArtifact.receipts);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00020083,0)}
        artifact.transactions = rawToConvertedEIPTx1559s(rawArtifact.transactions);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00020084,0)}
        return artifact;
    }

    function rawToConvertedEIPTx1559s(RawTx1559[] memory rawTxs) internal pure virtual returns (Tx1559[] memory) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06e40000, 1037618710244) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06e40001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06e40005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06e46000, rawTxs) }
        Tx1559[] memory txs = new Tx1559[](rawTxs.length);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00010053,0)}
        for (uint256 i; i < rawTxs.length; i++) {
            txs[i] = rawToConvertedEIPTx1559(rawTxs[i]);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000200a7,0)}
        }
        return txs;
    }

    function rawToConvertedEIPTx1559(RawTx1559 memory rawTx) internal pure virtual returns (Tx1559 memory) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06f10000, 1037618710257) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06f10001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06f10005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06f16000, rawTx) }
        Tx1559 memory transaction;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00010054,0)}
        transaction.arguments = rawTx.arguments;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00020085,0)}
        transaction.contractName = rawTx.contractName;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00020086,0)}
        transaction.functionSig = rawTx.functionSig;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00020087,0)}
        transaction.hash = rawTx.hash;bytes32 certora_local136 = transaction.hash;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000088,certora_local136)}
        transaction.txDetail = rawToConvertedEIP1559Detail(rawTx.txDetail);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00020089,0)}
        transaction.opcode = rawTx.opcode;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0002008a,0)}
        return transaction;
    }

    function rawToConvertedEIP1559Detail(RawTx1559Detail memory rawDetail)
        internal
        pure
        virtual
        returns (Tx1559Detail memory)
    {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06f00000, 1037618710256) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06f00001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06f00005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06f06000, rawDetail) }
        Tx1559Detail memory txDetail;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00010055,0)}
        txDetail.data = rawDetail.data;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0002008b,0)}
        txDetail.from = rawDetail.from;address certora_local140 = txDetail.from;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0000008c,certora_local140)}
        txDetail.to = rawDetail.to;address certora_local141 = txDetail.to;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0000008d,certora_local141)}
        txDetail.nonce = _bytesToUint(rawDetail.nonce);uint256 certora_local142 = txDetail.nonce;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0000008e,certora_local142)}
        txDetail.txType = _bytesToUint(rawDetail.txType);uint256 certora_local143 = txDetail.txType;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0000008f,certora_local143)}
        txDetail.value = _bytesToUint(rawDetail.value);uint256 certora_local144 = txDetail.value;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000090,certora_local144)}
        txDetail.gas = _bytesToUint(rawDetail.gas);uint256 certora_local145 = txDetail.gas;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000091,certora_local145)}
        txDetail.accessList = rawDetail.accessList;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00020092,0)}
        return txDetail;
    }

    function readTx1559s(string memory path) internal view virtual returns (Tx1559[] memory) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06ef0000, 1037618710255) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06ef0001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06ef0005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06ef6000, path) }
        string memory deployData = vm.readFile(path);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00010056,0)}
        bytes memory parsedDeployData = vm.parseJson(deployData, ".transactions");assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00010057,0)}
        RawTx1559[] memory rawTxs = abi.decode(parsedDeployData, (RawTx1559[]));assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00010058,0)}
        return rawToConvertedEIPTx1559s(rawTxs);
    }

    function readTx1559(string memory path, uint256 index) internal view virtual returns (Tx1559 memory) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06f20000, 1037618710258) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06f20001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06f20005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06f26001, index) }
        string memory deployData = vm.readFile(path);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00010059,0)}
        string memory key = string(abi.encodePacked(".transactions[", vm.toString(index), "]"));assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0001005a,0)}
        bytes memory parsedDeployData = vm.parseJson(deployData, key);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0001005b,0)}
        RawTx1559 memory rawTx = abi.decode(parsedDeployData, (RawTx1559));assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0001005c,0)}
        return rawToConvertedEIPTx1559(rawTx);
    }

    // Analogous to readTransactions, but for receipts.
    function readReceipts(string memory path) internal view virtual returns (Receipt[] memory) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06f30000, 1037618710259) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06f30001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06f30005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06f36000, path) }
        string memory deployData = vm.readFile(path);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0001005d,0)}
        bytes memory parsedDeployData = vm.parseJson(deployData, ".receipts");assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0001005e,0)}
        RawReceipt[] memory rawReceipts = abi.decode(parsedDeployData, (RawReceipt[]));assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0001005f,0)}
        return rawToConvertedReceipts(rawReceipts);
    }

    function readReceipt(string memory path, uint256 index) internal view virtual returns (Receipt memory) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06f40000, 1037618710260) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06f40001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06f40005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06f46001, index) }
        string memory deployData = vm.readFile(path);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00010060,0)}
        string memory key = string(abi.encodePacked(".receipts[", vm.toString(index), "]"));assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00010061,0)}
        bytes memory parsedDeployData = vm.parseJson(deployData, key);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00010062,0)}
        RawReceipt memory rawReceipt = abi.decode(parsedDeployData, (RawReceipt));assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00010063,0)}
        return rawToConvertedReceipt(rawReceipt);
    }

    function rawToConvertedReceipts(RawReceipt[] memory rawReceipts) internal pure virtual returns (Receipt[] memory) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06f50000, 1037618710261) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06f50001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06f50005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06f56000, rawReceipts) }
        Receipt[] memory receipts = new Receipt[](rawReceipts.length);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00010064,0)}
        for (uint256 i; i < rawReceipts.length; i++) {
            receipts[i] = rawToConvertedReceipt(rawReceipts[i]);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000200a8,0)}
        }
        return receipts;
    }

    function rawToConvertedReceipt(RawReceipt memory rawReceipt) internal pure virtual returns (Receipt memory) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06f60000, 1037618710262) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06f60001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06f60005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06f66000, rawReceipt) }
        Receipt memory receipt;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00010065,0)}
        receipt.blockHash = rawReceipt.blockHash;bytes32 certora_local147 = receipt.blockHash;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000093,certora_local147)}
        receipt.to = rawReceipt.to;address certora_local148 = receipt.to;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000094,certora_local148)}
        receipt.from = rawReceipt.from;address certora_local149 = receipt.from;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000095,certora_local149)}
        receipt.contractAddress = rawReceipt.contractAddress;address certora_local150 = receipt.contractAddress;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000096,certora_local150)}
        receipt.effectiveGasPrice = _bytesToUint(rawReceipt.effectiveGasPrice);uint256 certora_local151 = receipt.effectiveGasPrice;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000097,certora_local151)}
        receipt.cumulativeGasUsed = _bytesToUint(rawReceipt.cumulativeGasUsed);uint256 certora_local152 = receipt.cumulativeGasUsed;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000098,certora_local152)}
        receipt.gasUsed = _bytesToUint(rawReceipt.gasUsed);uint256 certora_local153 = receipt.gasUsed;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000099,certora_local153)}
        receipt.status = _bytesToUint(rawReceipt.status);uint256 certora_local154 = receipt.status;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0000009a,certora_local154)}
        receipt.transactionIndex = _bytesToUint(rawReceipt.transactionIndex);uint256 certora_local155 = receipt.transactionIndex;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0000009b,certora_local155)}
        receipt.blockNumber = _bytesToUint(rawReceipt.blockNumber);uint256 certora_local156 = receipt.blockNumber;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0000009c,certora_local156)}
        receipt.logs = rawToConvertedReceiptLogs(rawReceipt.logs);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0002009d,0)}
        receipt.logsBloom = rawReceipt.logsBloom;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0002009e,0)}
        receipt.transactionHash = rawReceipt.transactionHash;bytes32 certora_local159 = receipt.transactionHash;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0000009f,certora_local159)}
        return receipt;
    }

    function rawToConvertedReceiptLogs(RawReceiptLog[] memory rawLogs)
        internal
        pure
        virtual
        returns (ReceiptLog[] memory)
    {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06f70000, 1037618710263) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06f70001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06f70005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06f76000, rawLogs) }
        ReceiptLog[] memory logs = new ReceiptLog[](rawLogs.length);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00010066,0)}
        for (uint256 i; i < rawLogs.length; i++) {
            logs[i].logAddress = rawLogs[i].logAddress;address certora_local169 = logs[i].logAddress;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000000a9,certora_local169)}
            logs[i].blockHash = rawLogs[i].blockHash;bytes32 certora_local170 = logs[i].blockHash;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000000aa,certora_local170)}
            logs[i].blockNumber = _bytesToUint(rawLogs[i].blockNumber);uint256 certora_local171 = logs[i].blockNumber;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000000ab,certora_local171)}
            logs[i].data = rawLogs[i].data;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000200ac,0)}
            logs[i].logIndex = _bytesToUint(rawLogs[i].logIndex);uint256 certora_local173 = logs[i].logIndex;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000000ad,certora_local173)}
            logs[i].topics = rawLogs[i].topics;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000200ae,0)}
            logs[i].transactionIndex = _bytesToUint(rawLogs[i].transactionIndex);uint256 certora_local175 = logs[i].transactionIndex;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000000af,certora_local175)}
            logs[i].transactionLogIndex = _bytesToUint(rawLogs[i].transactionLogIndex);uint256 certora_local176 = logs[i].transactionLogIndex;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000000b0,certora_local176)}
            logs[i].removed = rawLogs[i].removed;bool certora_local177 = logs[i].removed;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000000b1,certora_local177)}
        }
        return logs;
    }

    // Deploy a contract by fetching the contract bytecode from
    // the artifacts directory
    // e.g. `deployCode(code, abi.encode(arg1,arg2,arg3))`
    function deployCode(string memory what, bytes memory args) internal virtual returns (address addr) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06f80000, 1037618710264) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06f80001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06f80005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06f86001, args) }
        bytes memory bytecode = abi.encodePacked(vm.getCode(what), args);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00010067,0)}
        /// @solidity memory-safe-assembly
        assembly {
            addr := create(0, add(bytecode, 0x20), mload(bytecode))
        }

        require(addr != address(0), "StdCheats deployCode(string,bytes): Deployment failed.");
    }

    function deployCode(string memory what) internal virtual returns (address addr) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06ec0000, 1037618710252) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06ec0001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06ec0005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06ec6000, what) }
        bytes memory bytecode = vm.getCode(what);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00010068,0)}
        /// @solidity memory-safe-assembly
        assembly {
            addr := create(0, add(bytecode, 0x20), mload(bytecode))
        }

        require(addr != address(0), "StdCheats deployCode(string): Deployment failed.");
    }

    /// @dev deploy contract with value on construction
    function deployCode(string memory what, bytes memory args, uint256 val) internal virtual returns (address addr) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06ed0000, 1037618710253) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06ed0001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06ed0005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06ed6002, val) }
        bytes memory bytecode = abi.encodePacked(vm.getCode(what), args);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00010069,0)}
        /// @solidity memory-safe-assembly
        assembly {
            addr := create(val, add(bytecode, 0x20), mload(bytecode))
        }

        require(addr != address(0), "StdCheats deployCode(string,bytes,uint256): Deployment failed.");
    }

    function deployCode(string memory what, uint256 val) internal virtual returns (address addr) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06ee0000, 1037618710254) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06ee0001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06ee0005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06ee6001, val) }
        bytes memory bytecode = vm.getCode(what);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0001006a,0)}
        /// @solidity memory-safe-assembly
        assembly {
            addr := create(val, add(bytecode, 0x20), mload(bytecode))
        }

        require(addr != address(0), "StdCheats deployCode(string,uint256): Deployment failed.");
    }

    // creates a labeled address and the corresponding private key
    function makeAddrAndKey(string memory name) internal virtual returns (address addr, uint256 privateKey) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06e50000, 1037618710245) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06e50001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06e50005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06e56000, name) }
        privateKey = uint256(keccak256(abi.encodePacked(name)));assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000000a0,privateKey)}
        addr = vm.addr(privateKey);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000000a1,addr)}
        vm.label(addr, name);
    }

    // creates a labeled address
    function makeAddr(string memory name) internal virtual returns (address addr) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06e60000, 1037618710246) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06e60001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06e60005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06e66000, name) }
        (addr,) = makeAddrAndKey(name);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000200a2,0)}
    }

    // Destroys an account immediately, sending the balance to beneficiary.
    // Destroying means: balance will be zero, code will be empty, and nonce will be 0
    // This is similar to selfdestruct but not identical: selfdestruct destroys code and nonce
    // only after tx ends, this will run immediately.
    function destroyAccount(address who, address beneficiary) internal virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06e70000, 1037618710247) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06e70001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06e70005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06e76001, beneficiary) }
        uint256 currBalance = who.balance;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0000006b,currBalance)}
        vm.etch(who, abi.encode());
        vm.deal(who, 0);
        vm.resetNonce(who);

        uint256 beneficiaryBalance = beneficiary.balance;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0000006c,beneficiaryBalance)}
        vm.deal(beneficiary, currBalance + beneficiaryBalance);
    }

    // creates a struct containing both a labeled address and the corresponding private key
    function makeAccount(string memory name) internal virtual returns (Account memory account) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06e80000, 1037618710248) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06e80001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06e80005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06e86000, name) }
        (account.addr, account.key) = makeAddrAndKey(name);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000200a3,0)}
    }

    function deriveRememberKey(string memory mnemonic, uint32 index)
        internal
        virtual
        returns (address who, uint256 privateKey)
    {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06e90000, 1037618710249) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06e90001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06e90005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06e96001, index) }
        privateKey = vm.deriveKey(mnemonic, index);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000000a4,privateKey)}
        who = vm.rememberKey(privateKey);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000000a5,who)}
    }

    function _bytesToUint(bytes memory b) private pure returns (uint256) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06ea0000, 1037618710250) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06ea0001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06ea0005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06ea6000, b) }
        require(b.length <= 32, "StdCheats _bytesToUint(bytes): Bytes length exceeds 32.");
        return abi.decode(abi.encodePacked(new bytes(32 - b.length), b), (uint256));
    }

    function isFork() internal view virtual returns (bool status) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06eb0000, 1037618710251) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06eb0001, 0) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06eb0004, 0) }
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
        bool gasStartedOff = gasMeteringOff;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0000006d,gasStartedOff)}
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
    function _viewChainId() private view returns (uint256 chainId) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06f90000, 1037618710265) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06f90001, 0) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06f90004, 0) }
        // Assembly required since `block.chainid` was introduced in 0.8.0.
        assembly {
            chainId := chainid()
        }

        address(this); // Silence warnings in older Solc versions.
    }

    function _pureChainId() private pure returns (uint256 chainId) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06fa0000, 1037618710266) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06fa0001, 0) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06fa0004, 0) }
        function() internal view returns (uint256) fnIn = _viewChainId;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0001006e,0)}
        function() internal pure returns (uint256) pureChainId;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0001006f,0)}
        assembly {
            pureChainId := fnIn
        }
        chainId = pureChainId();assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000000a6,chainId)}
    }
}

// Wrappers around cheatcodes to avoid footguns
abstract contract StdCheats is StdCheatsSafe {
    using stdStorage for StdStorage;

    StdStorage private stdstore;
    Vm private constant vm = Vm(address(uint160(uint256(keccak256("hevm cheat code")))));
    address private constant CONSOLE2_ADDRESS = 0x000000000000000000636F6e736F6c652e6c6f67;

    // Skip forward or rewind time by the specified number of seconds
    function skip(uint256 time) internal virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06bf0000, 1037618710207) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06bf0001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06bf0005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06bf6000, time) }
        vm.warp(vm.getBlockTimestamp() + time);
    }

    function rewind(uint256 time) internal virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06c00000, 1037618710208) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06c00001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06c00005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06c06000, time) }
        vm.warp(vm.getBlockTimestamp() - time);
    }

    // Setup a prank from an address that has some ether
    function hoax(address msgSender) internal virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06c20000, 1037618710210) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06c20001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06c20005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06c26000, msgSender) }
        vm.deal(msgSender, 1 << 128);
        vm.prank(msgSender);
    }

    function hoax(address msgSender, uint256 give) internal virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06c30000, 1037618710211) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06c30001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06c30005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06c36001, give) }
        vm.deal(msgSender, give);
        vm.prank(msgSender);
    }

    function hoax(address msgSender, address origin) internal virtual {address certoraRename1729_1 = origin;assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06c10000, 1037618710209) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06c10001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06c10005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06c16001, certoraRename1729_1) }
        vm.deal(msgSender, 1 << 128);
        vm.prank(msgSender, origin);
    }

    function hoax(address msgSender, address origin, uint256 give) internal virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06c40000, 1037618710212) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06c40001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06c40005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06c46002, give) }
        vm.deal(msgSender, give);
        vm.prank(msgSender, origin);
    }

    // Start perpetual prank from an address that has some ether
    function startHoax(address msgSender) internal virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06c50000, 1037618710213) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06c50001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06c50005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06c56000, msgSender) }
        vm.deal(msgSender, 1 << 128);
        vm.startPrank(msgSender);
    }

    function startHoax(address msgSender, uint256 give) internal virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06c60000, 1037618710214) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06c60001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06c60005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06c66001, give) }
        vm.deal(msgSender, give);
        vm.startPrank(msgSender);
    }

    // Start perpetual prank from an address that has some ether
    // tx.origin is set to the origin parameter
    function startHoax(address msgSender, address origin) internal virtual {address certoraRename1735_1 = origin;assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06c70000, 1037618710215) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06c70001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06c70005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06c76001, certoraRename1735_1) }
        vm.deal(msgSender, 1 << 128);
        vm.startPrank(msgSender, origin);
    }

    function startHoax(address msgSender, address origin, uint256 give) internal virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06c80000, 1037618710216) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06c80001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06c80005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06c86002, give) }
        vm.deal(msgSender, give);
        vm.startPrank(msgSender, origin);
    }

    function changePrank(address msgSender) internal virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06c90000, 1037618710217) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06c90001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06c90005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06c96000, msgSender) }
        console2_log_StdCheats("changePrank is deprecated. Please use vm.startPrank instead.");
        vm.stopPrank();
        vm.startPrank(msgSender);
    }

    function changePrank(address msgSender, address txOrigin) internal virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06ca0000, 1037618710218) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06ca0001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06ca0005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06ca6001, txOrigin) }
        vm.stopPrank();
        vm.startPrank(msgSender, txOrigin);
    }

    // The same as Vm's `deal`
    // Use the alternative signature for ERC20 tokens
    function deal(address to, uint256 give) internal virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06cb0000, 1037618710219) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06cb0001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06cb0005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06cb6001, give) }
        vm.deal(to, give);
    }

    // Set the balance of an account for any ERC20 token
    // Use the alternative signature to update `totalSupply`
    function deal(address token, address to, uint256 give) internal virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06cc0000, 1037618710220) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06cc0001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06cc0005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06cc6002, give) }
        deal(token, to, give, false);
    }

    // Set the balance of an account for any ERC1155 token
    // Use the alternative signature to update `totalSupply`
    function dealERC1155(address token, address to, uint256 id, uint256 give) internal virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06cd0000, 1037618710221) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06cd0001, 4) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06cd0005, 585) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06cd6003, give) }
        dealERC1155(token, to, id, give, false);
    }

    function deal(address token, address to, uint256 give, bool adjust) internal virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06ce0000, 1037618710222) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06ce0001, 4) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06ce0005, 585) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06ce6003, adjust) }
        // get current balance
        (, bytes memory balData) = token.staticcall(abi.encodeWithSelector(0x70a08231, to));assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00010070,0)}
        uint256 prevBal = abi.decode(balData, (uint256));assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000071,prevBal)}

        // update balance
        stdstore.target(token).sig(0x70a08231).with_key(to).checked_write(give);

        // update total supply
        if (adjust) {
            (, bytes memory totSupData) = token.staticcall(abi.encodeWithSelector(0x18160ddd));
            uint256 totSup = abi.decode(totSupData, (uint256));
            if (give < prevBal) {
                totSup -= (prevBal - give);
            } else {
                totSup += (give - prevBal);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000000b2,totSup)}
            }
            stdstore.target(token).sig(0x18160ddd).checked_write(totSup);
        }
    }

    function dealERC1155(address token, address to, uint256 id, uint256 give, bool adjust) internal virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06d10000, 1037618710225) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06d10001, 5) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06d10005, 4681) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06d16004, adjust) }
        // get current balance
        (, bytes memory balData) = token.staticcall(abi.encodeWithSelector(0x00fdd58e, to, id));assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00010072,0)}
        uint256 prevBal = abi.decode(balData, (uint256));assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000073,prevBal)}

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
                totSup += (give - prevBal);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000000b3,totSup)}
            }
            stdstore.target(token).sig(0xbd85b039).with_key(id).checked_write(totSup);
        }
    }

    function dealERC721(address token, address to, uint256 id) internal virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06d00000, 1037618710224) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06d00001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06d00005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06d06002, id) }
        // check if token id is already minted and the actual owner.
        (bool successMinted, bytes memory ownerData) = token.staticcall(abi.encodeWithSelector(0x6352211e, id));assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00010074,0)}
        require(successMinted, "StdCheats deal(address,address,uint,bool): id not minted.");

        // get owner current balance
        (, bytes memory fromBalData) =
            token.staticcall(abi.encodeWithSelector(0x70a08231, abi.decode(ownerData, (address))));assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00010075,0)}
        uint256 fromPrevBal = abi.decode(fromBalData, (uint256));assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000076,fromPrevBal)}

        // get new user current balance
        (, bytes memory toBalData) = token.staticcall(abi.encodeWithSelector(0x70a08231, to));assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00010077,0)}
        uint256 toPrevBal = abi.decode(toBalData, (uint256));assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000078,toPrevBal)}

        // update balances
        stdstore.target(token).sig(0x70a08231).with_key(abi.decode(ownerData, (address))).checked_write(--fromPrevBal);
        stdstore.target(token).sig(0x70a08231).with_key(to).checked_write(++toPrevBal);

        // update owner
        stdstore.target(token).sig(0x6352211e).with_key(id).checked_write(to);
    }

    function deployCodeTo(string memory what, address where) internal virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06cf0000, 1037618710223) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06cf0001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06cf0005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06cf6001, where) }
        deployCodeTo(what, "", 0, where);
    }

    function deployCodeTo(string memory what, bytes memory args, address where) internal virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06d20000, 1037618710226) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06d20001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06d20005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06d26002, where) }
        deployCodeTo(what, args, 0, where);
    }

    function deployCodeTo(string memory what, bytes memory args, uint256 value, address where) internal virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06d30000, 1037618710227) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06d30001, 4) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06d30005, 585) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06d36003, where) }
        bytes memory creationCode = vm.getCode(what);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00010079,0)}
        vm.etch(where, abi.encodePacked(creationCode, args));
        (bool success, bytes memory runtimeBytecode) = where.call{value: value}("");assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0001007a,0)}
        require(success, "StdCheats deployCodeTo(string,bytes,uint256,address): Failed to create runtime bytecode.");
        vm.etch(where, runtimeBytecode);
    }

    // Used to prevent the compilation of console, which shortens the compilation time when console is not used elsewhere.
    function console2_log_StdCheats(string memory p0) private view {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06d40000, 1037618710228) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06d40001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06d40005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06d46000, p0) }
        (bool status,) = address(CONSOLE2_ADDRESS).staticcall(abi.encodeWithSignature("log(string)", p0));assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0001007b,0)}
        status;
    }
}
