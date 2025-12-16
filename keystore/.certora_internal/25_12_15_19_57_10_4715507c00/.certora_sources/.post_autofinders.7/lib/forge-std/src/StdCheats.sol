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
    function assumeNotBlacklisted(address token, address addr) internal view virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0cb10000, 1037618711729) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0cb10001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0cb10005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0cb16001, addr) }
        // Nothing to check if `token` is not a contract.
        uint256 tokenCodeSize;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000057,tokenCodeSize)}
        assembly {
            tokenCodeSize := extcodesize(token)
        }
        require(tokenCodeSize > 0, "StdCheats assumeNotBlacklisted(address,address): Token address is not a contract.");

        bool success;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000058,success)}
        bytes memory returnData;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00010059,0)}

        // 4-byte selector for `isBlacklisted(address)`, used by USDC.
        (success, returnData) = token.staticcall(abi.encodeWithSelector(0xfe575a87, addr));assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0002008b,0)}
        vm.assume(!success || abi.decode(returnData, (bool)) == false);

        // 4-byte selector for `isBlackListed(address)`, used by USDT.
        (success, returnData) = token.staticcall(abi.encodeWithSelector(0xe47d6060, addr));assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0002008c,0)}
        vm.assume(!success || abi.decode(returnData, (bool)) == false);
    }

    // Checks that `addr` is not blacklisted by token contracts that have a blacklist.
    // This is identical to `assumeNotBlacklisted(address,address)` but with a different name, for
    // backwards compatibility, since this name was used in the original PR which already has
    // a release. This function can be removed in a future release once we want a breaking change.
    function assumeNoBlacklisted(address token, address addr) internal view virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0cb20000, 1037618711730) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0cb20001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0cb20005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0cb26001, addr) }
        assumeNotBlacklisted(token, addr);
    }

    function assumeAddressIsNot(address addr, AddressType addressType) internal virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0cb40000, 1037618711732) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0cb40001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0cb40005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0cb46001, addressType) }
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

    function assumeAddressIsNot(address addr, AddressType addressType1, AddressType addressType2) internal virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0cb50000, 1037618711733) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0cb50001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0cb50005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0cb56002, addressType2) }
        assumeAddressIsNot(addr, addressType1);
        assumeAddressIsNot(addr, addressType2);
    }

    function assumeAddressIsNot(
        address addr,
        AddressType addressType1,
        AddressType addressType2,
        AddressType addressType3
    ) internal virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0cb30000, 1037618711731) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0cb30001, 4) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0cb30005, 585) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0cb36003, addressType3) }
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
    ) internal virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0cb60000, 1037618711734) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0cb60001, 5) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0cb60005, 4681) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0cb66004, addressType4) }
        assumeAddressIsNot(addr, addressType1);
        assumeAddressIsNot(addr, addressType2);
        assumeAddressIsNot(addr, addressType3);
        assumeAddressIsNot(addr, addressType4);
    }

    // This function checks whether an address, `addr`, is payable. It works by sending 1 wei to
    // `addr` and checking the `success` return value.
    // NOTE: This function may result in state changes depending on the fallback/receive logic
    // implemented by `addr`, which should be taken into account when this function is used.
    function _isPayable(address addr) private returns (bool) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0cb70000, 1037618711735) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0cb70001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0cb70005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0cb76000, addr) }
        require(
            addr.balance < UINT256_MAX,
            "StdCheats _isPayable(address): Balance equals max uint256, so it cannot receive any more funds"
        );
        uint256 origBalanceTest = address(this).balance;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0000005a,origBalanceTest)}
        uint256 origBalanceAddr = address(addr).balance;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0000005b,origBalanceAddr)}

        vm.deal(address(this), 1);
        (bool success,) = payable(addr).call{value: 1}("");assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0001005c,0)}

        // reset balances
        vm.deal(address(this), origBalanceTest);
        vm.deal(addr, origBalanceAddr);

        return success;
    }

    // NOTE: This function may result in state changes depending on the fallback/receive logic
    // implemented by `addr`, which should be taken into account when this function is used. See the
    // `_isPayable` method for more information.
    function assumePayable(address addr) internal virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0cb80000, 1037618711736) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0cb80001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0cb80005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0cb86000, addr) }
        vm.assume(_isPayable(addr));
    }

    function assumeNotPayable(address addr) internal virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0cb90000, 1037618711737) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0cb90001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0cb90005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0cb96000, addr) }
        vm.assume(!_isPayable(addr));
    }

    function assumeNotZeroAddress(address addr) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0cba0000, 1037618711738) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0cba0001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0cba0005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0cba6000, addr) }
        vm.assume(addr != address(0));
    }

    function assumeNotPrecompile(address addr) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0cbb0000, 1037618711739) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0cbb0001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0cbb0005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0cbb6000, addr) }
        assumeNotPrecompile(addr, _pureChainId());
    }

    function assumeNotPrecompile(address addr, uint256 chainId) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0cbc0000, 1037618711740) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0cbc0001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0cbc0005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0cbc6001, chainId) }
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

    function assumeNotForgeAddress(address addr) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0cbd0000, 1037618711741) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0cbd0001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0cbd0005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0cbd6000, addr) }
        // vm, console, and Create2Deployer addresses
        vm.assume(
            addr != address(vm) && addr != 0x000000000000000000636F6e736F6c652e6c6f67
                && addr != 0x4e59b44847b379578588920cA78FbF26c0B4956C
        );
    }

    function assumeUnusedAddress(address addr) internal view virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0cbe0000, 1037618711742) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0cbe0001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0cbe0005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0cbe6000, addr) }
        uint256 size;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0000005d,size)}
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
    {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0cbf0000, 1037618711743) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0cbf0001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0cbf0005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0cbf6000, path) }
        string memory data = vm.readFile(path);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0001005e,0)}
        bytes memory parsedData = vm.parseJson(data);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0001005f,0)}
        RawEIP1559ScriptArtifact memory rawArtifact = abi.decode(parsedData, (RawEIP1559ScriptArtifact));assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00010060,0)}
        EIP1559ScriptArtifact memory artifact;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00010061,0)}
        artifact.libraries = rawArtifact.libraries;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0002008d,0)}
        artifact.path = rawArtifact.path;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0002008e,0)}
        artifact.timestamp = rawArtifact.timestamp;uint256 certora_local143 = artifact.timestamp;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0000008f,certora_local143)}
        artifact.pending = rawArtifact.pending;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00020090,0)}
        artifact.txReturns = rawArtifact.txReturns;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00020091,0)}
        artifact.receipts = rawToConvertedReceipts(rawArtifact.receipts);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00020092,0)}
        artifact.transactions = rawToConvertedEIPTx1559s(rawArtifact.transactions);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00020093,0)}
        return artifact;
    }

    function rawToConvertedEIPTx1559s(RawTx1559[] memory rawTxs) internal pure virtual returns (Tx1559[] memory) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0cc00000, 1037618711744) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0cc00001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0cc00005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0cc06000, rawTxs) }
        Tx1559[] memory txs = new Tx1559[](rawTxs.length);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00010062,0)}
        for (uint256 i; i < rawTxs.length; i++) {
            txs[i] = rawToConvertedEIPTx1559(rawTxs[i]);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000200b6,0)}
        }
        return txs;
    }

    function rawToConvertedEIPTx1559(RawTx1559 memory rawTx) internal pure virtual returns (Tx1559 memory) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ccd0000, 1037618711757) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ccd0001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ccd0005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ccd6000, rawTx) }
        Tx1559 memory transaction;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00010063,0)}
        transaction.arguments = rawTx.arguments;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00020094,0)}
        transaction.contractName = rawTx.contractName;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00020095,0)}
        transaction.functionSig = rawTx.functionSig;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00020096,0)}
        transaction.hash = rawTx.hash;bytes32 certora_local151 = transaction.hash;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000097,certora_local151)}
        transaction.txDetail = rawToConvertedEIP1559Detail(rawTx.txDetail);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00020098,0)}
        transaction.opcode = rawTx.opcode;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00020099,0)}
        return transaction;
    }

    function rawToConvertedEIP1559Detail(RawTx1559Detail memory rawDetail)
        internal
        pure
        virtual
        returns (Tx1559Detail memory)
    {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ccc0000, 1037618711756) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ccc0001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ccc0005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ccc6000, rawDetail) }
        Tx1559Detail memory txDetail;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00010064,0)}
        txDetail.data = rawDetail.data;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0002009a,0)}
        txDetail.from = rawDetail.from;address certora_local155 = txDetail.from;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0000009b,certora_local155)}
        txDetail.to = rawDetail.to;address certora_local156 = txDetail.to;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0000009c,certora_local156)}
        txDetail.nonce = _bytesToUint(rawDetail.nonce);uint256 certora_local157 = txDetail.nonce;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0000009d,certora_local157)}
        txDetail.txType = _bytesToUint(rawDetail.txType);uint256 certora_local158 = txDetail.txType;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0000009e,certora_local158)}
        txDetail.value = _bytesToUint(rawDetail.value);uint256 certora_local159 = txDetail.value;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0000009f,certora_local159)}
        txDetail.gas = _bytesToUint(rawDetail.gas);uint256 certora_local160 = txDetail.gas;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000000a0,certora_local160)}
        txDetail.accessList = rawDetail.accessList;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000200a1,0)}
        return txDetail;
    }

    function readTx1559s(string memory path) internal view virtual returns (Tx1559[] memory) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ccb0000, 1037618711755) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ccb0001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ccb0005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ccb6000, path) }
        string memory deployData = vm.readFile(path);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00010065,0)}
        bytes memory parsedDeployData = vm.parseJson(deployData, ".transactions");assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00010066,0)}
        RawTx1559[] memory rawTxs = abi.decode(parsedDeployData, (RawTx1559[]));assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00010067,0)}
        return rawToConvertedEIPTx1559s(rawTxs);
    }

    function readTx1559(string memory path, uint256 index) internal view virtual returns (Tx1559 memory) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0cce0000, 1037618711758) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0cce0001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0cce0005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0cce6001, index) }
        string memory deployData = vm.readFile(path);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00010068,0)}
        string memory key = string(abi.encodePacked(".transactions[", vm.toString(index), "]"));assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00010069,0)}
        bytes memory parsedDeployData = vm.parseJson(deployData, key);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0001006a,0)}
        RawTx1559 memory rawTx = abi.decode(parsedDeployData, (RawTx1559));assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0001006b,0)}
        return rawToConvertedEIPTx1559(rawTx);
    }

    // Analogous to readTransactions, but for receipts.
    function readReceipts(string memory path) internal view virtual returns (Receipt[] memory) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ccf0000, 1037618711759) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ccf0001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ccf0005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ccf6000, path) }
        string memory deployData = vm.readFile(path);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0001006c,0)}
        bytes memory parsedDeployData = vm.parseJson(deployData, ".receipts");assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0001006d,0)}
        RawReceipt[] memory rawReceipts = abi.decode(parsedDeployData, (RawReceipt[]));assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0001006e,0)}
        return rawToConvertedReceipts(rawReceipts);
    }

    function readReceipt(string memory path, uint256 index) internal view virtual returns (Receipt memory) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0cd00000, 1037618711760) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0cd00001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0cd00005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0cd06001, index) }
        string memory deployData = vm.readFile(path);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0001006f,0)}
        string memory key = string(abi.encodePacked(".receipts[", vm.toString(index), "]"));assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00010070,0)}
        bytes memory parsedDeployData = vm.parseJson(deployData, key);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00010071,0)}
        RawReceipt memory rawReceipt = abi.decode(parsedDeployData, (RawReceipt));assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00010072,0)}
        return rawToConvertedReceipt(rawReceipt);
    }

    function rawToConvertedReceipts(RawReceipt[] memory rawReceipts) internal pure virtual returns (Receipt[] memory) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0cd10000, 1037618711761) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0cd10001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0cd10005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0cd16000, rawReceipts) }
        Receipt[] memory receipts = new Receipt[](rawReceipts.length);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00010073,0)}
        for (uint256 i; i < rawReceipts.length; i++) {
            receipts[i] = rawToConvertedReceipt(rawReceipts[i]);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000200b7,0)}
        }
        return receipts;
    }

    function rawToConvertedReceipt(RawReceipt memory rawReceipt) internal pure virtual returns (Receipt memory) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0cd20000, 1037618711762) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0cd20001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0cd20005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0cd26000, rawReceipt) }
        Receipt memory receipt;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00010074,0)}
        receipt.blockHash = rawReceipt.blockHash;bytes32 certora_local162 = receipt.blockHash;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000000a2,certora_local162)}
        receipt.to = rawReceipt.to;address certora_local163 = receipt.to;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000000a3,certora_local163)}
        receipt.from = rawReceipt.from;address certora_local164 = receipt.from;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000000a4,certora_local164)}
        receipt.contractAddress = rawReceipt.contractAddress;address certora_local165 = receipt.contractAddress;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000000a5,certora_local165)}
        receipt.effectiveGasPrice = _bytesToUint(rawReceipt.effectiveGasPrice);uint256 certora_local166 = receipt.effectiveGasPrice;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000000a6,certora_local166)}
        receipt.cumulativeGasUsed = _bytesToUint(rawReceipt.cumulativeGasUsed);uint256 certora_local167 = receipt.cumulativeGasUsed;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000000a7,certora_local167)}
        receipt.gasUsed = _bytesToUint(rawReceipt.gasUsed);uint256 certora_local168 = receipt.gasUsed;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000000a8,certora_local168)}
        receipt.status = _bytesToUint(rawReceipt.status);uint256 certora_local169 = receipt.status;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000000a9,certora_local169)}
        receipt.transactionIndex = _bytesToUint(rawReceipt.transactionIndex);uint256 certora_local170 = receipt.transactionIndex;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000000aa,certora_local170)}
        receipt.blockNumber = _bytesToUint(rawReceipt.blockNumber);uint256 certora_local171 = receipt.blockNumber;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000000ab,certora_local171)}
        receipt.logs = rawToConvertedReceiptLogs(rawReceipt.logs);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000200ac,0)}
        receipt.logsBloom = rawReceipt.logsBloom;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000200ad,0)}
        receipt.transactionHash = rawReceipt.transactionHash;bytes32 certora_local174 = receipt.transactionHash;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000000ae,certora_local174)}
        return receipt;
    }

    function rawToConvertedReceiptLogs(RawReceiptLog[] memory rawLogs)
        internal
        pure
        virtual
        returns (ReceiptLog[] memory)
    {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0cd30000, 1037618711763) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0cd30001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0cd30005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0cd36000, rawLogs) }
        ReceiptLog[] memory logs = new ReceiptLog[](rawLogs.length);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00010075,0)}
        for (uint256 i; i < rawLogs.length; i++) {
            logs[i].logAddress = rawLogs[i].logAddress;address certora_local184 = logs[i].logAddress;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000000b8,certora_local184)}
            logs[i].blockHash = rawLogs[i].blockHash;bytes32 certora_local185 = logs[i].blockHash;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000000b9,certora_local185)}
            logs[i].blockNumber = _bytesToUint(rawLogs[i].blockNumber);uint256 certora_local186 = logs[i].blockNumber;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000000ba,certora_local186)}
            logs[i].data = rawLogs[i].data;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000200bb,0)}
            logs[i].logIndex = _bytesToUint(rawLogs[i].logIndex);uint256 certora_local188 = logs[i].logIndex;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000000bc,certora_local188)}
            logs[i].topics = rawLogs[i].topics;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000200bd,0)}
            logs[i].transactionIndex = _bytesToUint(rawLogs[i].transactionIndex);uint256 certora_local190 = logs[i].transactionIndex;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000000be,certora_local190)}
            logs[i].transactionLogIndex = _bytesToUint(rawLogs[i].transactionLogIndex);uint256 certora_local191 = logs[i].transactionLogIndex;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000000bf,certora_local191)}
            logs[i].removed = rawLogs[i].removed;bool certora_local192 = logs[i].removed;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000000c0,certora_local192)}
        }
        return logs;
    }

    // Deploy a contract by fetching the contract bytecode from
    // the artifacts directory
    // e.g. `deployCode(code, abi.encode(arg1,arg2,arg3))`
    function deployCode(string memory what, bytes memory args) internal virtual returns (address addr) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0cd40000, 1037618711764) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0cd40001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0cd40005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0cd46001, args) }
        bytes memory bytecode = abi.encodePacked(vm.getCode(what), args);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00010076,0)}
        /// @solidity memory-safe-assembly
        assembly {
            addr := create(0, add(bytecode, 0x20), mload(bytecode))
        }

        require(addr != address(0), "StdCheats deployCode(string,bytes): Deployment failed.");
    }

    function deployCode(string memory what) internal virtual returns (address addr) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0cc80000, 1037618711752) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0cc80001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0cc80005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0cc86000, what) }
        bytes memory bytecode = vm.getCode(what);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00010077,0)}
        /// @solidity memory-safe-assembly
        assembly {
            addr := create(0, add(bytecode, 0x20), mload(bytecode))
        }

        require(addr != address(0), "StdCheats deployCode(string): Deployment failed.");
    }

    /// @dev deploy contract with value on construction
    function deployCode(string memory what, bytes memory args, uint256 val) internal virtual returns (address addr) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0cc90000, 1037618711753) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0cc90001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0cc90005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0cc96002, val) }
        bytes memory bytecode = abi.encodePacked(vm.getCode(what), args);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00010078,0)}
        /// @solidity memory-safe-assembly
        assembly {
            addr := create(val, add(bytecode, 0x20), mload(bytecode))
        }

        require(addr != address(0), "StdCheats deployCode(string,bytes,uint256): Deployment failed.");
    }

    function deployCode(string memory what, uint256 val) internal virtual returns (address addr) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0cca0000, 1037618711754) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0cca0001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0cca0005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0cca6001, val) }
        bytes memory bytecode = vm.getCode(what);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00010079,0)}
        /// @solidity memory-safe-assembly
        assembly {
            addr := create(val, add(bytecode, 0x20), mload(bytecode))
        }

        require(addr != address(0), "StdCheats deployCode(string,uint256): Deployment failed.");
    }

    // creates a labeled address and the corresponding private key
    function makeAddrAndKey(string memory name) internal virtual returns (address addr, uint256 privateKey) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0cc10000, 1037618711745) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0cc10001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0cc10005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0cc16000, name) }
        privateKey = uint256(keccak256(abi.encodePacked(name)));assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000000af,privateKey)}
        addr = vm.addr(privateKey);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000000b0,addr)}
        vm.label(addr, name);
    }

    // creates a labeled address
    function makeAddr(string memory name) internal virtual returns (address addr) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0cc20000, 1037618711746) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0cc20001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0cc20005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0cc26000, name) }
        (addr,) = makeAddrAndKey(name);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000200b1,0)}
    }

    // Destroys an account immediately, sending the balance to beneficiary.
    // Destroying means: balance will be zero, code will be empty, and nonce will be 0
    // This is similar to selfdestruct but not identical: selfdestruct destroys code and nonce
    // only after tx ends, this will run immediately.
    function destroyAccount(address who, address beneficiary) internal virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0cc30000, 1037618711747) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0cc30001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0cc30005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0cc36001, beneficiary) }
        uint256 currBalance = who.balance;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0000007a,currBalance)}
        vm.etch(who, abi.encode());
        vm.deal(who, 0);
        vm.resetNonce(who);

        uint256 beneficiaryBalance = beneficiary.balance;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0000007b,beneficiaryBalance)}
        vm.deal(beneficiary, currBalance + beneficiaryBalance);
    }

    // creates a struct containing both a labeled address and the corresponding private key
    function makeAccount(string memory name) internal virtual returns (Account memory account) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0cc40000, 1037618711748) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0cc40001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0cc40005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0cc46000, name) }
        (account.addr, account.key) = makeAddrAndKey(name);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000200b2,0)}
    }

    function deriveRememberKey(string memory mnemonic, uint32 index)
        internal
        virtual
        returns (address who, uint256 privateKey)
    {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0cc50000, 1037618711749) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0cc50001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0cc50005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0cc56001, index) }
        privateKey = vm.deriveKey(mnemonic, index);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000000b3,privateKey)}
        who = vm.rememberKey(privateKey);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000000b4,who)}
    }

    function _bytesToUint(bytes memory b) private pure returns (uint256) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0cc60000, 1037618711750) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0cc60001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0cc60005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0cc66000, b) }
        require(b.length <= 32, "StdCheats _bytesToUint(bytes): Bytes length exceeds 32.");
        return abi.decode(abi.encodePacked(new bytes(32 - b.length), b), (uint256));
    }

    function isFork() internal view virtual returns (bool status) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0cc70000, 1037618711751) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0cc70001, 0) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0cc70004, 0) }
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
        bool gasStartedOff = gasMeteringOff;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0000007c,gasStartedOff)}
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
    function _viewChainId() private view returns (uint256 chainId) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0cd50000, 1037618711765) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0cd50001, 0) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0cd50004, 0) }
        // Assembly required since `block.chainid` was introduced in 0.8.0.
        assembly {
            chainId := chainid()
        }

        address(this); // Silence warnings in older Solc versions.
    }

    function _pureChainId() private pure returns (uint256 chainId) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0cd60000, 1037618711766) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0cd60001, 0) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0cd60004, 0) }
        function() internal view returns (uint256) fnIn = _viewChainId;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0001007d,0)}
        function() internal pure returns (uint256) pureChainId;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0001007e,0)}
        assembly {
            pureChainId := fnIn
        }
        chainId = pureChainId();assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000000b5,chainId)}
    }
}

// Wrappers around cheatcodes to avoid footguns
abstract contract StdCheats is StdCheatsSafe {
    using stdStorage for StdStorage;

    StdStorage private stdstore;
    Vm private constant vm = Vm(address(uint160(uint256(keccak256("hevm cheat code")))));
    address private constant CONSOLE2_ADDRESS = 0x000000000000000000636F6e736F6c652e6c6f67;

    // Skip forward or rewind time by the specified number of seconds
    function skip(uint256 time) internal virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c9b0000, 1037618711707) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c9b0001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c9b0005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c9b6000, time) }
        vm.warp(vm.getBlockTimestamp() + time);
    }

    function rewind(uint256 time) internal virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c9c0000, 1037618711708) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c9c0001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c9c0005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c9c6000, time) }
        vm.warp(vm.getBlockTimestamp() - time);
    }

    // Setup a prank from an address that has some ether
    function hoax(address msgSender) internal virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c9e0000, 1037618711710) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c9e0001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c9e0005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c9e6000, msgSender) }
        vm.deal(msgSender, 1 << 128);
        vm.prank(msgSender);
    }

    function hoax(address msgSender, uint256 give) internal virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c9f0000, 1037618711711) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c9f0001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c9f0005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c9f6001, give) }
        vm.deal(msgSender, give);
        vm.prank(msgSender);
    }

    function hoax(address msgSender, address origin) internal virtual {address certoraRename3229_1 = origin;assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c9d0000, 1037618711709) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c9d0001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c9d0005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c9d6001, certoraRename3229_1) }
        vm.deal(msgSender, 1 << 128);
        vm.prank(msgSender, origin);
    }

    function hoax(address msgSender, address origin, uint256 give) internal virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ca00000, 1037618711712) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ca00001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ca00005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ca06002, give) }
        vm.deal(msgSender, give);
        vm.prank(msgSender, origin);
    }

    // Start perpetual prank from an address that has some ether
    function startHoax(address msgSender) internal virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ca10000, 1037618711713) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ca10001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ca10005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ca16000, msgSender) }
        vm.deal(msgSender, 1 << 128);
        vm.startPrank(msgSender);
    }

    function startHoax(address msgSender, uint256 give) internal virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ca20000, 1037618711714) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ca20001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ca20005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ca26001, give) }
        vm.deal(msgSender, give);
        vm.startPrank(msgSender);
    }

    // Start perpetual prank from an address that has some ether
    // tx.origin is set to the origin parameter
    function startHoax(address msgSender, address origin) internal virtual {address certoraRename3235_1 = origin;assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ca30000, 1037618711715) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ca30001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ca30005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ca36001, certoraRename3235_1) }
        vm.deal(msgSender, 1 << 128);
        vm.startPrank(msgSender, origin);
    }

    function startHoax(address msgSender, address origin, uint256 give) internal virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ca40000, 1037618711716) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ca40001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ca40005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ca46002, give) }
        vm.deal(msgSender, give);
        vm.startPrank(msgSender, origin);
    }

    function changePrank(address msgSender) internal virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ca50000, 1037618711717) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ca50001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ca50005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ca56000, msgSender) }
        console2_log_StdCheats("changePrank is deprecated. Please use vm.startPrank instead.");
        vm.stopPrank();
        vm.startPrank(msgSender);
    }

    function changePrank(address msgSender, address txOrigin) internal virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ca60000, 1037618711718) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ca60001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ca60005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ca66001, txOrigin) }
        vm.stopPrank();
        vm.startPrank(msgSender, txOrigin);
    }

    // The same as Vm's `deal`
    // Use the alternative signature for ERC20 tokens
    function deal(address to, uint256 give) internal virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ca70000, 1037618711719) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ca70001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ca70005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ca76001, give) }
        vm.deal(to, give);
    }

    // Set the balance of an account for any ERC20 token
    // Use the alternative signature to update `totalSupply`
    function deal(address token, address to, uint256 give) internal virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ca80000, 1037618711720) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ca80001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ca80005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ca86002, give) }
        deal(token, to, give, false);
    }

    // Set the balance of an account for any ERC1155 token
    // Use the alternative signature to update `totalSupply`
    function dealERC1155(address token, address to, uint256 id, uint256 give) internal virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ca90000, 1037618711721) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ca90001, 4) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ca90005, 585) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ca96003, give) }
        dealERC1155(token, to, id, give, false);
    }

    function deal(address token, address to, uint256 give, bool adjust) internal virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0caa0000, 1037618711722) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0caa0001, 4) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0caa0005, 585) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0caa6003, adjust) }
        // get current balance
        (, bytes memory balData) = token.staticcall(abi.encodeWithSelector(0x70a08231, to));assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0001007f,0)}
        uint256 prevBal = abi.decode(balData, (uint256));assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000080,prevBal)}

        // update balance
        stdstore.target(token).sig(0x70a08231).with_key(to).checked_write(give);

        // update total supply
        if (adjust) {
            (, bytes memory totSupData) = token.staticcall(abi.encodeWithSelector(0x18160ddd));
            uint256 totSup = abi.decode(totSupData, (uint256));
            if (give < prevBal) {
                totSup -= (prevBal - give);
            } else {
                totSup += (give - prevBal);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000000c1,totSup)}
            }
            stdstore.target(token).sig(0x18160ddd).checked_write(totSup);
        }
    }

    function dealERC1155(address token, address to, uint256 id, uint256 give, bool adjust) internal virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0cad0000, 1037618711725) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0cad0001, 5) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0cad0005, 4681) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0cad6004, adjust) }
        // get current balance
        (, bytes memory balData) = token.staticcall(abi.encodeWithSelector(0x00fdd58e, to, id));assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00010081,0)}
        uint256 prevBal = abi.decode(balData, (uint256));assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000082,prevBal)}

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
                totSup += (give - prevBal);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000000c2,totSup)}
            }
            stdstore.target(token).sig(0xbd85b039).with_key(id).checked_write(totSup);
        }
    }

    function dealERC721(address token, address to, uint256 id) internal virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0cac0000, 1037618711724) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0cac0001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0cac0005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0cac6002, id) }
        // check if token id is already minted and the actual owner.
        (bool successMinted, bytes memory ownerData) = token.staticcall(abi.encodeWithSelector(0x6352211e, id));assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00010083,0)}
        require(successMinted, "StdCheats deal(address,address,uint,bool): id not minted.");

        // get owner current balance
        (, bytes memory fromBalData) =
            token.staticcall(abi.encodeWithSelector(0x70a08231, abi.decode(ownerData, (address))));assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00010084,0)}
        uint256 fromPrevBal = abi.decode(fromBalData, (uint256));assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000085,fromPrevBal)}

        // get new user current balance
        (, bytes memory toBalData) = token.staticcall(abi.encodeWithSelector(0x70a08231, to));assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00010086,0)}
        uint256 toPrevBal = abi.decode(toBalData, (uint256));assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000087,toPrevBal)}

        // update balances
        stdstore.target(token).sig(0x70a08231).with_key(abi.decode(ownerData, (address))).checked_write(--fromPrevBal);
        stdstore.target(token).sig(0x70a08231).with_key(to).checked_write(++toPrevBal);

        // update owner
        stdstore.target(token).sig(0x6352211e).with_key(id).checked_write(to);
    }

    function deployCodeTo(string memory what, address where) internal virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0cab0000, 1037618711723) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0cab0001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0cab0005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0cab6001, where) }
        deployCodeTo(what, "", 0, where);
    }

    function deployCodeTo(string memory what, bytes memory args, address where) internal virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0cae0000, 1037618711726) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0cae0001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0cae0005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0cae6002, where) }
        deployCodeTo(what, args, 0, where);
    }

    function deployCodeTo(string memory what, bytes memory args, uint256 value, address where) internal virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0caf0000, 1037618711727) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0caf0001, 4) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0caf0005, 585) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0caf6003, where) }
        bytes memory creationCode = vm.getCode(what);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00010088,0)}
        vm.etch(where, abi.encodePacked(creationCode, args));
        (bool success, bytes memory runtimeBytecode) = where.call{value: value}("");assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00010089,0)}
        require(success, "StdCheats deployCodeTo(string,bytes,uint256,address): Failed to create runtime bytecode.");
        vm.etch(where, runtimeBytecode);
    }

    // Used to prevent the compilation of console, which shortens the compilation time when console is not used elsewhere.
    function console2_log_StdCheats(string memory p0) private view {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0cb00000, 1037618711728) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0cb00001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0cb00005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0cb06000, p0) }
        (bool status,) = address(CONSOLE2_ADDRESS).staticcall(abi.encodeWithSignature("log(string)", p0));assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0001008a,0)}
        status;
    }
}
