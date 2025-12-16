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
    function assumeNotBlacklisted(address token, address addr) internal view virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03b80000, 1037618709432) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03b80001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03b80005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03b86001, addr) }
        // Nothing to check if `token` is not a contract.
        uint256 tokenCodeSize;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0000009c,tokenCodeSize)}
        assembly {
            tokenCodeSize := extcodesize(token)
        }
        require(tokenCodeSize > 0, "StdCheats assumeNotBlacklisted(address,address): Token address is not a contract.");

        bool success;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0000009d,success)}
        bytes memory returnData;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0001009e,0)}

        // 4-byte selector for `isBlacklisted(address)`, used by USDC.
        (success, returnData) = token.staticcall(abi.encodeWithSelector(0xfe575a87, addr));assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000200d0,0)}
        vm.assume(!success || abi.decode(returnData, (bool)) == false);

        // 4-byte selector for `isBlackListed(address)`, used by USDT.
        (success, returnData) = token.staticcall(abi.encodeWithSelector(0xe47d6060, addr));assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000200d1,0)}
        vm.assume(!success || abi.decode(returnData, (bool)) == false);
    }

    // Checks that `addr` is not blacklisted by token contracts that have a blacklist.
    // This is identical to `assumeNotBlacklisted(address,address)` but with a different name, for
    // backwards compatibility, since this name was used in the original PR which already has
    // a release. This function can be removed in a future release once we want a breaking change.
    function assumeNoBlacklisted(address token, address addr) internal view virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03b90000, 1037618709433) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03b90001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03b90005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03b96001, addr) }
        assumeNotBlacklisted(token, addr);
    }

    function assumeAddressIsNot(address addr, AddressType addressType) internal virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03bb0000, 1037618709435) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03bb0001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03bb0005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03bb6001, addressType) }
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

    function assumeAddressIsNot(address addr, AddressType addressType1, AddressType addressType2) internal virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03bc0000, 1037618709436) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03bc0001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03bc0005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03bc6002, addressType2) }
        assumeAddressIsNot(addr, addressType1);
        assumeAddressIsNot(addr, addressType2);
    }

    function assumeAddressIsNot(
        address addr,
        AddressType addressType1,
        AddressType addressType2,
        AddressType addressType3
    ) internal virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03ba0000, 1037618709434) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03ba0001, 4) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03ba0005, 585) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03ba6003, addressType3) }
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
    ) internal virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03bd0000, 1037618709437) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03bd0001, 5) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03bd0005, 4681) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03bd6004, addressType4) }
        assumeAddressIsNot(addr, addressType1);
        assumeAddressIsNot(addr, addressType2);
        assumeAddressIsNot(addr, addressType3);
        assumeAddressIsNot(addr, addressType4);
    }

    // This function checks whether an address, `addr`, is payable. It works by sending 1 wei to
    // `addr` and checking the `success` return value.
    // NOTE: This function may result in state changes depending on the fallback/receive logic
    // implemented by `addr`, which should be taken into account when this function is used.
    function _isPayable(address addr) private returns (bool) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03be0000, 1037618709438) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03be0001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03be0005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03be6000, addr) }
        require(
            addr.balance < UINT256_MAX,
            "StdCheats _isPayable(address): Balance equals max uint256, so it cannot receive any more funds"
        );
        uint256 origBalanceTest = address(this).balance;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0000009f,origBalanceTest)}
        uint256 origBalanceAddr = address(addr).balance;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000000a0,origBalanceAddr)}

        vm.deal(address(this), 1);
        (bool success,) = payable(addr).call{value: 1}("");assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000100a1,0)}

        // reset balances
        vm.deal(address(this), origBalanceTest);
        vm.deal(addr, origBalanceAddr);

        return success;
    }

    // NOTE: This function may result in state changes depending on the fallback/receive logic
    // implemented by `addr`, which should be taken into account when this function is used. See the
    // `_isPayable` method for more information.
    function assumePayable(address addr) internal virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03bf0000, 1037618709439) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03bf0001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03bf0005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03bf6000, addr) }
        vm.assume(_isPayable(addr));
    }

    function assumeNotPayable(address addr) internal virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03c00000, 1037618709440) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03c00001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03c00005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03c06000, addr) }
        vm.assume(!_isPayable(addr));
    }

    function assumeNotZeroAddress(address addr) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03c10000, 1037618709441) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03c10001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03c10005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03c16000, addr) }
        vm.assume(addr != address(0));
    }

    function assumeNotPrecompile(address addr) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03c20000, 1037618709442) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03c20001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03c20005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03c26000, addr) }
        assumeNotPrecompile(addr, _pureChainId());
    }

    function assumeNotPrecompile(address addr, uint256 chainId) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03c30000, 1037618709443) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03c30001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03c30005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03c36001, chainId) }
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

    function assumeNotForgeAddress(address addr) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03c40000, 1037618709444) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03c40001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03c40005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03c46000, addr) }
        // vm, console, and Create2Deployer addresses
        vm.assume(
            addr != address(vm) && addr != 0x000000000000000000636F6e736F6c652e6c6f67
                && addr != 0x4e59b44847b379578588920cA78FbF26c0B4956C
        );
    }

    function assumeUnusedAddress(address addr) internal view virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03c50000, 1037618709445) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03c50001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03c50005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03c56000, addr) }
        uint256 size;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000000a2,size)}
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
    {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03c60000, 1037618709446) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03c60001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03c60005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03c66000, path) }
        string memory data = vm.readFile(path);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000100a3,0)}
        bytes memory parsedData = vm.parseJson(data);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000100a4,0)}
        RawEIP1559ScriptArtifact memory rawArtifact = abi.decode(parsedData, (RawEIP1559ScriptArtifact));assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000100a5,0)}
        EIP1559ScriptArtifact memory artifact;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000100a6,0)}
        artifact.libraries = rawArtifact.libraries;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000200d2,0)}
        artifact.path = rawArtifact.path;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000200d3,0)}
        artifact.timestamp = rawArtifact.timestamp;uint256 certora_local212 = artifact.timestamp;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000000d4,certora_local212)}
        artifact.pending = rawArtifact.pending;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000200d5,0)}
        artifact.txReturns = rawArtifact.txReturns;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000200d6,0)}
        artifact.receipts = rawToConvertedReceipts(rawArtifact.receipts);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000200d7,0)}
        artifact.transactions = rawToConvertedEIPTx1559s(rawArtifact.transactions);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000200d8,0)}
        return artifact;
    }

    function rawToConvertedEIPTx1559s(RawTx1559[] memory rawTxs) internal pure virtual returns (Tx1559[] memory) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03c70000, 1037618709447) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03c70001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03c70005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03c76000, rawTxs) }
        Tx1559[] memory txs = new Tx1559[](rawTxs.length);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000100a7,0)}
        for (uint256 i; i < rawTxs.length; i++) {
            txs[i] = rawToConvertedEIPTx1559(rawTxs[i]);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000200fb,0)}
        }
        return txs;
    }

    function rawToConvertedEIPTx1559(RawTx1559 memory rawTx) internal pure virtual returns (Tx1559 memory) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03d40000, 1037618709460) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03d40001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03d40005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03d46000, rawTx) }
        Tx1559 memory transaction;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000100a8,0)}
        transaction.arguments = rawTx.arguments;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000200d9,0)}
        transaction.contractName = rawTx.contractName;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000200da,0)}
        transaction.functionSig = rawTx.functionSig;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000200db,0)}
        transaction.hash = rawTx.hash;bytes32 certora_local220 = transaction.hash;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000000dc,certora_local220)}
        transaction.txDetail = rawToConvertedEIP1559Detail(rawTx.txDetail);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000200dd,0)}
        transaction.opcode = rawTx.opcode;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000200de,0)}
        return transaction;
    }

    function rawToConvertedEIP1559Detail(RawTx1559Detail memory rawDetail)
        internal
        pure
        virtual
        returns (Tx1559Detail memory)
    {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03d30000, 1037618709459) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03d30001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03d30005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03d36000, rawDetail) }
        Tx1559Detail memory txDetail;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000100a9,0)}
        txDetail.data = rawDetail.data;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000200df,0)}
        txDetail.from = rawDetail.from;address certora_local224 = txDetail.from;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000000e0,certora_local224)}
        txDetail.to = rawDetail.to;address certora_local225 = txDetail.to;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000000e1,certora_local225)}
        txDetail.nonce = _bytesToUint(rawDetail.nonce);uint256 certora_local226 = txDetail.nonce;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000000e2,certora_local226)}
        txDetail.txType = _bytesToUint(rawDetail.txType);uint256 certora_local227 = txDetail.txType;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000000e3,certora_local227)}
        txDetail.value = _bytesToUint(rawDetail.value);uint256 certora_local228 = txDetail.value;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000000e4,certora_local228)}
        txDetail.gas = _bytesToUint(rawDetail.gas);uint256 certora_local229 = txDetail.gas;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000000e5,certora_local229)}
        txDetail.accessList = rawDetail.accessList;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000200e6,0)}
        return txDetail;
    }

    function readTx1559s(string memory path) internal view virtual returns (Tx1559[] memory) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03d20000, 1037618709458) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03d20001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03d20005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03d26000, path) }
        string memory deployData = vm.readFile(path);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000100aa,0)}
        bytes memory parsedDeployData = vm.parseJson(deployData, ".transactions");assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000100ab,0)}
        RawTx1559[] memory rawTxs = abi.decode(parsedDeployData, (RawTx1559[]));assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000100ac,0)}
        return rawToConvertedEIPTx1559s(rawTxs);
    }

    function readTx1559(string memory path, uint256 index) internal view virtual returns (Tx1559 memory) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03d50000, 1037618709461) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03d50001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03d50005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03d56001, index) }
        string memory deployData = vm.readFile(path);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000100ad,0)}
        string memory key = string(abi.encodePacked(".transactions[", vm.toString(index), "]"));assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000100ae,0)}
        bytes memory parsedDeployData = vm.parseJson(deployData, key);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000100af,0)}
        RawTx1559 memory rawTx = abi.decode(parsedDeployData, (RawTx1559));assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000100b0,0)}
        return rawToConvertedEIPTx1559(rawTx);
    }

    // Analogous to readTransactions, but for receipts.
    function readReceipts(string memory path) internal view virtual returns (Receipt[] memory) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03d60000, 1037618709462) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03d60001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03d60005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03d66000, path) }
        string memory deployData = vm.readFile(path);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000100b1,0)}
        bytes memory parsedDeployData = vm.parseJson(deployData, ".receipts");assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000100b2,0)}
        RawReceipt[] memory rawReceipts = abi.decode(parsedDeployData, (RawReceipt[]));assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000100b3,0)}
        return rawToConvertedReceipts(rawReceipts);
    }

    function readReceipt(string memory path, uint256 index) internal view virtual returns (Receipt memory) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03d70000, 1037618709463) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03d70001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03d70005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03d76001, index) }
        string memory deployData = vm.readFile(path);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000100b4,0)}
        string memory key = string(abi.encodePacked(".receipts[", vm.toString(index), "]"));assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000100b5,0)}
        bytes memory parsedDeployData = vm.parseJson(deployData, key);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000100b6,0)}
        RawReceipt memory rawReceipt = abi.decode(parsedDeployData, (RawReceipt));assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000100b7,0)}
        return rawToConvertedReceipt(rawReceipt);
    }

    function rawToConvertedReceipts(RawReceipt[] memory rawReceipts) internal pure virtual returns (Receipt[] memory) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03d80000, 1037618709464) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03d80001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03d80005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03d86000, rawReceipts) }
        Receipt[] memory receipts = new Receipt[](rawReceipts.length);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000100b8,0)}
        for (uint256 i; i < rawReceipts.length; i++) {
            receipts[i] = rawToConvertedReceipt(rawReceipts[i]);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000200fc,0)}
        }
        return receipts;
    }

    function rawToConvertedReceipt(RawReceipt memory rawReceipt) internal pure virtual returns (Receipt memory) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03d90000, 1037618709465) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03d90001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03d90005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03d96000, rawReceipt) }
        Receipt memory receipt;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000100b9,0)}
        receipt.blockHash = rawReceipt.blockHash;bytes32 certora_local231 = receipt.blockHash;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000000e7,certora_local231)}
        receipt.to = rawReceipt.to;address certora_local232 = receipt.to;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000000e8,certora_local232)}
        receipt.from = rawReceipt.from;address certora_local233 = receipt.from;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000000e9,certora_local233)}
        receipt.contractAddress = rawReceipt.contractAddress;address certora_local234 = receipt.contractAddress;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000000ea,certora_local234)}
        receipt.effectiveGasPrice = _bytesToUint(rawReceipt.effectiveGasPrice);uint256 certora_local235 = receipt.effectiveGasPrice;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000000eb,certora_local235)}
        receipt.cumulativeGasUsed = _bytesToUint(rawReceipt.cumulativeGasUsed);uint256 certora_local236 = receipt.cumulativeGasUsed;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000000ec,certora_local236)}
        receipt.gasUsed = _bytesToUint(rawReceipt.gasUsed);uint256 certora_local237 = receipt.gasUsed;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000000ed,certora_local237)}
        receipt.status = _bytesToUint(rawReceipt.status);uint256 certora_local238 = receipt.status;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000000ee,certora_local238)}
        receipt.transactionIndex = _bytesToUint(rawReceipt.transactionIndex);uint256 certora_local239 = receipt.transactionIndex;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000000ef,certora_local239)}
        receipt.blockNumber = _bytesToUint(rawReceipt.blockNumber);uint256 certora_local240 = receipt.blockNumber;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000000f0,certora_local240)}
        receipt.logs = rawToConvertedReceiptLogs(rawReceipt.logs);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000200f1,0)}
        receipt.logsBloom = rawReceipt.logsBloom;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000200f2,0)}
        receipt.transactionHash = rawReceipt.transactionHash;bytes32 certora_local243 = receipt.transactionHash;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000000f3,certora_local243)}
        return receipt;
    }

    function rawToConvertedReceiptLogs(RawReceiptLog[] memory rawLogs)
        internal
        pure
        virtual
        returns (ReceiptLog[] memory)
    {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03da0000, 1037618709466) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03da0001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03da0005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03da6000, rawLogs) }
        ReceiptLog[] memory logs = new ReceiptLog[](rawLogs.length);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000100ba,0)}
        for (uint256 i; i < rawLogs.length; i++) {
            logs[i].logAddress = rawLogs[i].logAddress;address certora_local253 = logs[i].logAddress;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000000fd,certora_local253)}
            logs[i].blockHash = rawLogs[i].blockHash;bytes32 certora_local254 = logs[i].blockHash;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000000fe,certora_local254)}
            logs[i].blockNumber = _bytesToUint(rawLogs[i].blockNumber);uint256 certora_local255 = logs[i].blockNumber;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000000ff,certora_local255)}
            logs[i].data = rawLogs[i].data;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00020100,0)}
            logs[i].logIndex = _bytesToUint(rawLogs[i].logIndex);uint256 certora_local257 = logs[i].logIndex;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000101,certora_local257)}
            logs[i].topics = rawLogs[i].topics;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00020102,0)}
            logs[i].transactionIndex = _bytesToUint(rawLogs[i].transactionIndex);uint256 certora_local259 = logs[i].transactionIndex;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000103,certora_local259)}
            logs[i].transactionLogIndex = _bytesToUint(rawLogs[i].transactionLogIndex);uint256 certora_local260 = logs[i].transactionLogIndex;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000104,certora_local260)}
            logs[i].removed = rawLogs[i].removed;bool certora_local261 = logs[i].removed;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000105,certora_local261)}
        }
        return logs;
    }

    // Deploy a contract by fetching the contract bytecode from
    // the artifacts directory
    // e.g. `deployCode(code, abi.encode(arg1,arg2,arg3))`
    function deployCode(string memory what, bytes memory args) internal virtual returns (address addr) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03db0000, 1037618709467) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03db0001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03db0005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03db6001, args) }
        bytes memory bytecode = abi.encodePacked(vm.getCode(what), args);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000100bb,0)}
        /// @solidity memory-safe-assembly
        assembly {
            addr := create(0, add(bytecode, 0x20), mload(bytecode))
        }

        require(addr != address(0), "StdCheats deployCode(string,bytes): Deployment failed.");
    }

    function deployCode(string memory what) internal virtual returns (address addr) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03cf0000, 1037618709455) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03cf0001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03cf0005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03cf6000, what) }
        bytes memory bytecode = vm.getCode(what);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000100bc,0)}
        /// @solidity memory-safe-assembly
        assembly {
            addr := create(0, add(bytecode, 0x20), mload(bytecode))
        }

        require(addr != address(0), "StdCheats deployCode(string): Deployment failed.");
    }

    /// @dev deploy contract with value on construction
    function deployCode(string memory what, bytes memory args, uint256 val) internal virtual returns (address addr) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03d00000, 1037618709456) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03d00001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03d00005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03d06002, val) }
        bytes memory bytecode = abi.encodePacked(vm.getCode(what), args);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000100bd,0)}
        /// @solidity memory-safe-assembly
        assembly {
            addr := create(val, add(bytecode, 0x20), mload(bytecode))
        }

        require(addr != address(0), "StdCheats deployCode(string,bytes,uint256): Deployment failed.");
    }

    function deployCode(string memory what, uint256 val) internal virtual returns (address addr) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03d10000, 1037618709457) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03d10001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03d10005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03d16001, val) }
        bytes memory bytecode = vm.getCode(what);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000100be,0)}
        /// @solidity memory-safe-assembly
        assembly {
            addr := create(val, add(bytecode, 0x20), mload(bytecode))
        }

        require(addr != address(0), "StdCheats deployCode(string,uint256): Deployment failed.");
    }

    // creates a labeled address and the corresponding private key
    function makeAddrAndKey(string memory name) internal virtual returns (address addr, uint256 privateKey) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03c80000, 1037618709448) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03c80001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03c80005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03c86000, name) }
        privateKey = uint256(keccak256(abi.encodePacked(name)));assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000000f4,privateKey)}
        addr = vm.addr(privateKey);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000000f5,addr)}
        vm.label(addr, name);
    }

    // creates a labeled address
    function makeAddr(string memory name) internal virtual returns (address addr) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03c90000, 1037618709449) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03c90001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03c90005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03c96000, name) }
        (addr,) = makeAddrAndKey(name);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000200f6,0)}
    }

    // Destroys an account immediately, sending the balance to beneficiary.
    // Destroying means: balance will be zero, code will be empty, and nonce will be 0
    // This is similar to selfdestruct but not identical: selfdestruct destroys code and nonce
    // only after tx ends, this will run immediately.
    function destroyAccount(address who, address beneficiary) internal virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03ca0000, 1037618709450) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03ca0001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03ca0005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03ca6001, beneficiary) }
        uint256 currBalance = who.balance;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000000bf,currBalance)}
        vm.etch(who, abi.encode());
        vm.deal(who, 0);
        vm.resetNonce(who);

        uint256 beneficiaryBalance = beneficiary.balance;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000000c0,beneficiaryBalance)}
        vm.deal(beneficiary, currBalance + beneficiaryBalance);
    }

    // creates a struct containing both a labeled address and the corresponding private key
    function makeAccount(string memory name) internal virtual returns (Account memory account) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03cb0000, 1037618709451) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03cb0001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03cb0005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03cb6000, name) }
        (account.addr, account.key) = makeAddrAndKey(name);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000200f7,0)}
    }

    function deriveRememberKey(string memory mnemonic, uint32 index)
        internal
        virtual
        returns (address who, uint256 privateKey)
    {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03cc0000, 1037618709452) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03cc0001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03cc0005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03cc6001, index) }
        privateKey = vm.deriveKey(mnemonic, index);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000000f8,privateKey)}
        who = vm.rememberKey(privateKey);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000000f9,who)}
    }

    function _bytesToUint(bytes memory b) private pure returns (uint256) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03cd0000, 1037618709453) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03cd0001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03cd0005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03cd6000, b) }
        require(b.length <= 32, "StdCheats _bytesToUint(bytes): Bytes length exceeds 32.");
        return abi.decode(abi.encodePacked(new bytes(32 - b.length), b), (uint256));
    }

    function isFork() internal view virtual returns (bool status) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03ce0000, 1037618709454) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03ce0001, 0) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03ce0004, 0) }
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
        bool gasStartedOff = gasMeteringOff;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000000c1,gasStartedOff)}
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
    function _viewChainId() private view returns (uint256 chainId) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03dc0000, 1037618709468) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03dc0001, 0) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03dc0004, 0) }
        // Assembly required since `block.chainid` was introduced in 0.8.0.
        assembly {
            chainId := chainid()
        }

        address(this); // Silence warnings in older Solc versions.
    }

    function _pureChainId() private pure returns (uint256 chainId) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03dd0000, 1037618709469) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03dd0001, 0) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03dd0004, 0) }
        function() internal view returns (uint256) fnIn = _viewChainId;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000100c2,0)}
        function() internal pure returns (uint256) pureChainId;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000100c3,0)}
        assembly {
            pureChainId := fnIn
        }
        chainId = pureChainId();assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000000fa,chainId)}
    }
}

// Wrappers around cheatcodes to avoid footguns
abstract contract StdCheats is StdCheatsSafe {
    using stdStorage for StdStorage;

    StdStorage private stdstore;
    Vm private constant vm = Vm(address(uint160(uint256(keccak256("hevm cheat code")))));
    address private constant CONSOLE2_ADDRESS = 0x000000000000000000636F6e736F6c652e6c6f67;

    // Skip forward or rewind time by the specified number of seconds
    function skip(uint256 time) internal virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03a20000, 1037618709410) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03a20001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03a20005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03a26000, time) }
        vm.warp(vm.getBlockTimestamp() + time);
    }

    function rewind(uint256 time) internal virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03a30000, 1037618709411) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03a30001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03a30005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03a36000, time) }
        vm.warp(vm.getBlockTimestamp() - time);
    }

    // Setup a prank from an address that has some ether
    function hoax(address msgSender) internal virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03a50000, 1037618709413) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03a50001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03a50005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03a56000, msgSender) }
        vm.deal(msgSender, 1 << 128);
        vm.prank(msgSender);
    }

    function hoax(address msgSender, uint256 give) internal virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03a60000, 1037618709414) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03a60001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03a60005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03a66001, give) }
        vm.deal(msgSender, give);
        vm.prank(msgSender);
    }

    function hoax(address msgSender, address origin) internal virtual {address certoraRename932_1 = origin;assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03a40000, 1037618709412) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03a40001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03a40005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03a46001, certoraRename932_1) }
        vm.deal(msgSender, 1 << 128);
        vm.prank(msgSender, origin);
    }

    function hoax(address msgSender, address origin, uint256 give) internal virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03a70000, 1037618709415) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03a70001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03a70005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03a76002, give) }
        vm.deal(msgSender, give);
        vm.prank(msgSender, origin);
    }

    // Start perpetual prank from an address that has some ether
    function startHoax(address msgSender) internal virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03a80000, 1037618709416) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03a80001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03a80005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03a86000, msgSender) }
        vm.deal(msgSender, 1 << 128);
        vm.startPrank(msgSender);
    }

    function startHoax(address msgSender, uint256 give) internal virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03a90000, 1037618709417) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03a90001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03a90005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03a96001, give) }
        vm.deal(msgSender, give);
        vm.startPrank(msgSender);
    }

    // Start perpetual prank from an address that has some ether
    // tx.origin is set to the origin parameter
    function startHoax(address msgSender, address origin) internal virtual {address certoraRename938_1 = origin;assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03aa0000, 1037618709418) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03aa0001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03aa0005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03aa6001, certoraRename938_1) }
        vm.deal(msgSender, 1 << 128);
        vm.startPrank(msgSender, origin);
    }

    function startHoax(address msgSender, address origin, uint256 give) internal virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03ab0000, 1037618709419) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03ab0001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03ab0005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03ab6002, give) }
        vm.deal(msgSender, give);
        vm.startPrank(msgSender, origin);
    }

    function changePrank(address msgSender) internal virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03ac0000, 1037618709420) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03ac0001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03ac0005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03ac6000, msgSender) }
        console2_log_StdCheats("changePrank is deprecated. Please use vm.startPrank instead.");
        vm.stopPrank();
        vm.startPrank(msgSender);
    }

    function changePrank(address msgSender, address txOrigin) internal virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03ad0000, 1037618709421) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03ad0001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03ad0005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03ad6001, txOrigin) }
        vm.stopPrank();
        vm.startPrank(msgSender, txOrigin);
    }

    // The same as Vm's `deal`
    // Use the alternative signature for ERC20 tokens
    function deal(address to, uint256 give) internal virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03ae0000, 1037618709422) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03ae0001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03ae0005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03ae6001, give) }
        vm.deal(to, give);
    }

    // Set the balance of an account for any ERC20 token
    // Use the alternative signature to update `totalSupply`
    function deal(address token, address to, uint256 give) internal virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03af0000, 1037618709423) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03af0001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03af0005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03af6002, give) }
        deal(token, to, give, false);
    }

    // Set the balance of an account for any ERC1155 token
    // Use the alternative signature to update `totalSupply`
    function dealERC1155(address token, address to, uint256 id, uint256 give) internal virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03b00000, 1037618709424) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03b00001, 4) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03b00005, 585) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03b06003, give) }
        dealERC1155(token, to, id, give, false);
    }

    function deal(address token, address to, uint256 give, bool adjust) internal virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03b10000, 1037618709425) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03b10001, 4) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03b10005, 585) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03b16003, adjust) }
        // get current balance
        (, bytes memory balData) = token.staticcall(abi.encodeWithSelector(0x70a08231, to));assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000100c4,0)}
        uint256 prevBal = abi.decode(balData, (uint256));assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000000c5,prevBal)}

        // update balance
        stdstore.target(token).sig(0x70a08231).with_key(to).checked_write(give);

        // update total supply
        if (adjust) {
            (, bytes memory totSupData) = token.staticcall(abi.encodeWithSelector(0x18160ddd));
            uint256 totSup = abi.decode(totSupData, (uint256));
            if (give < prevBal) {
                totSup -= (prevBal - give);
            } else {
                totSup += (give - prevBal);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000106,totSup)}
            }
            stdstore.target(token).sig(0x18160ddd).checked_write(totSup);
        }
    }

    function dealERC1155(address token, address to, uint256 id, uint256 give, bool adjust) internal virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03b40000, 1037618709428) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03b40001, 5) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03b40005, 4681) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03b46004, adjust) }
        // get current balance
        (, bytes memory balData) = token.staticcall(abi.encodeWithSelector(0x00fdd58e, to, id));assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000100c6,0)}
        uint256 prevBal = abi.decode(balData, (uint256));assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000000c7,prevBal)}

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
                totSup += (give - prevBal);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000107,totSup)}
            }
            stdstore.target(token).sig(0xbd85b039).with_key(id).checked_write(totSup);
        }
    }

    function dealERC721(address token, address to, uint256 id) internal virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03b30000, 1037618709427) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03b30001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03b30005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03b36002, id) }
        // check if token id is already minted and the actual owner.
        (bool successMinted, bytes memory ownerData) = token.staticcall(abi.encodeWithSelector(0x6352211e, id));assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000100c8,0)}
        require(successMinted, "StdCheats deal(address,address,uint,bool): id not minted.");

        // get owner current balance
        (, bytes memory fromBalData) =
            token.staticcall(abi.encodeWithSelector(0x70a08231, abi.decode(ownerData, (address))));assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000100c9,0)}
        uint256 fromPrevBal = abi.decode(fromBalData, (uint256));assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000000ca,fromPrevBal)}

        // get new user current balance
        (, bytes memory toBalData) = token.staticcall(abi.encodeWithSelector(0x70a08231, to));assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000100cb,0)}
        uint256 toPrevBal = abi.decode(toBalData, (uint256));assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000000cc,toPrevBal)}

        // update balances
        stdstore.target(token).sig(0x70a08231).with_key(abi.decode(ownerData, (address))).checked_write(--fromPrevBal);
        stdstore.target(token).sig(0x70a08231).with_key(to).checked_write(++toPrevBal);

        // update owner
        stdstore.target(token).sig(0x6352211e).with_key(id).checked_write(to);
    }

    function deployCodeTo(string memory what, address where) internal virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03b20000, 1037618709426) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03b20001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03b20005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03b26001, where) }
        deployCodeTo(what, "", 0, where);
    }

    function deployCodeTo(string memory what, bytes memory args, address where) internal virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03b50000, 1037618709429) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03b50001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03b50005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03b56002, where) }
        deployCodeTo(what, args, 0, where);
    }

    function deployCodeTo(string memory what, bytes memory args, uint256 value, address where) internal virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03b60000, 1037618709430) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03b60001, 4) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03b60005, 585) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03b66003, where) }
        bytes memory creationCode = vm.getCode(what);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000100cd,0)}
        vm.etch(where, abi.encodePacked(creationCode, args));
        (bool success, bytes memory runtimeBytecode) = where.call{value: value}("");assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000100ce,0)}
        require(success, "StdCheats deployCodeTo(string,bytes,uint256,address): Failed to create runtime bytecode.");
        vm.etch(where, runtimeBytecode);
    }

    // Used to prevent the compilation of console, which shortens the compilation time when console is not used elsewhere.
    function console2_log_StdCheats(string memory p0) private view {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03b70000, 1037618709431) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03b70001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03b70005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03b76000, p0) }
        (bool status,) = address(CONSOLE2_ADDRESS).staticcall(abi.encodeWithSignature("log(string)", p0));assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000100cf,0)}
        status;
    }
}
