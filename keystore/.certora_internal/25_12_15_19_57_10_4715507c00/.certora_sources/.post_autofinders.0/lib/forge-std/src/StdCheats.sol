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
    function assumeNotBlacklisted(address token, address addr) internal view virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01100000, 1037618708752) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01100001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01100005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01106001, addr) }
        // Nothing to check if `token` is not a contract.
        uint256 tokenCodeSize;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000000af,tokenCodeSize)}
        assembly {
            tokenCodeSize := extcodesize(token)
        }
        require(tokenCodeSize > 0, "StdCheats assumeNotBlacklisted(address,address): Token address is not a contract.");

        bool success;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000000b0,success)}
        bytes memory returnData;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000100b1,0)}

        // 4-byte selector for `isBlacklisted(address)`, used by USDC.
        (success, returnData) = token.staticcall(abi.encodeWithSelector(0xfe575a87, addr));assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000200e3,0)}
        vm.assume(!success || abi.decode(returnData, (bool)) == false);

        // 4-byte selector for `isBlackListed(address)`, used by USDT.
        (success, returnData) = token.staticcall(abi.encodeWithSelector(0xe47d6060, addr));assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000200e4,0)}
        vm.assume(!success || abi.decode(returnData, (bool)) == false);
    }

    // Checks that `addr` is not blacklisted by token contracts that have a blacklist.
    // This is identical to `assumeNotBlacklisted(address,address)` but with a different name, for
    // backwards compatibility, since this name was used in the original PR which already has
    // a release. This function can be removed in a future release once we want a breaking change.
    function assumeNoBlacklisted(address token, address addr) internal view virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01110000, 1037618708753) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01110001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01110005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01116001, addr) }
        assumeNotBlacklisted(token, addr);
    }

    function assumeAddressIsNot(address addr, AddressType addressType) internal virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01130000, 1037618708755) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01130001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01130005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01136001, addressType) }
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

    function assumeAddressIsNot(address addr, AddressType addressType1, AddressType addressType2) internal virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01140000, 1037618708756) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01140001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01140005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01146002, addressType2) }
        assumeAddressIsNot(addr, addressType1);
        assumeAddressIsNot(addr, addressType2);
    }

    function assumeAddressIsNot(
        address addr,
        AddressType addressType1,
        AddressType addressType2,
        AddressType addressType3
    ) internal virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01120000, 1037618708754) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01120001, 4) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01120005, 585) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01126003, addressType3) }
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
    ) internal virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01150000, 1037618708757) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01150001, 5) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01150005, 4681) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01156004, addressType4) }
        assumeAddressIsNot(addr, addressType1);
        assumeAddressIsNot(addr, addressType2);
        assumeAddressIsNot(addr, addressType3);
        assumeAddressIsNot(addr, addressType4);
    }

    // This function checks whether an address, `addr`, is payable. It works by sending 1 wei to
    // `addr` and checking the `success` return value.
    // NOTE: This function may result in state changes depending on the fallback/receive logic
    // implemented by `addr`, which should be taken into account when this function is used.
    function _isPayable(address addr) private returns (bool) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01160000, 1037618708758) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01160001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01160005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01166000, addr) }
        require(
            addr.balance < UINT256_MAX,
            "StdCheats _isPayable(address): Balance equals max uint256, so it cannot receive any more funds"
        );
        uint256 origBalanceTest = address(this).balance;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000000b2,origBalanceTest)}
        uint256 origBalanceAddr = address(addr).balance;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000000b3,origBalanceAddr)}

        vm.deal(address(this), 1);
        (bool success,) = payable(addr).call{value: 1}("");assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000100b4,0)}

        // reset balances
        vm.deal(address(this), origBalanceTest);
        vm.deal(addr, origBalanceAddr);

        return success;
    }

    // NOTE: This function may result in state changes depending on the fallback/receive logic
    // implemented by `addr`, which should be taken into account when this function is used. See the
    // `_isPayable` method for more information.
    function assumePayable(address addr) internal virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01170000, 1037618708759) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01170001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01170005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01176000, addr) }
        vm.assume(_isPayable(addr));
    }

    function assumeNotPayable(address addr) internal virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01180000, 1037618708760) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01180001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01180005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01186000, addr) }
        vm.assume(!_isPayable(addr));
    }

    function assumeNotZeroAddress(address addr) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01190000, 1037618708761) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01190001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01190005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01196000, addr) }
        vm.assume(addr != address(0));
    }

    function assumeNotPrecompile(address addr) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff011a0000, 1037618708762) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff011a0001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff011a0005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff011a6000, addr) }
        assumeNotPrecompile(addr, _pureChainId());
    }

    function assumeNotPrecompile(address addr, uint256 chainId) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff011b0000, 1037618708763) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff011b0001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff011b0005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff011b6001, chainId) }
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

    function assumeNotForgeAddress(address addr) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff011c0000, 1037618708764) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff011c0001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff011c0005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff011c6000, addr) }
        // vm, console, and Create2Deployer addresses
        vm.assume(
            addr != address(vm) && addr != 0x000000000000000000636F6e736F6c652e6c6f67
                && addr != 0x4e59b44847b379578588920cA78FbF26c0B4956C
        );
    }

    function assumeUnusedAddress(address addr) internal view virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff011d0000, 1037618708765) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff011d0001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff011d0005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff011d6000, addr) }
        uint256 size;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000000b5,size)}
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
    {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff011e0000, 1037618708766) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff011e0001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff011e0005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff011e6000, path) }
        string memory data = vm.readFile(path);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000100b6,0)}
        bytes memory parsedData = vm.parseJson(data);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000100b7,0)}
        RawEIP1559ScriptArtifact memory rawArtifact = abi.decode(parsedData, (RawEIP1559ScriptArtifact));assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000100b8,0)}
        EIP1559ScriptArtifact memory artifact;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000100b9,0)}
        artifact.libraries = rawArtifact.libraries;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000200e5,0)}
        artifact.path = rawArtifact.path;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000200e6,0)}
        artifact.timestamp = rawArtifact.timestamp;uint256 certora_local231 = artifact.timestamp;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000000e7,certora_local231)}
        artifact.pending = rawArtifact.pending;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000200e8,0)}
        artifact.txReturns = rawArtifact.txReturns;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000200e9,0)}
        artifact.receipts = rawToConvertedReceipts(rawArtifact.receipts);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000200ea,0)}
        artifact.transactions = rawToConvertedEIPTx1559s(rawArtifact.transactions);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000200eb,0)}
        return artifact;
    }

    function rawToConvertedEIPTx1559s(RawTx1559[] memory rawTxs) internal pure virtual returns (Tx1559[] memory) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff011f0000, 1037618708767) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff011f0001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff011f0005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff011f6000, rawTxs) }
        Tx1559[] memory txs = new Tx1559[](rawTxs.length);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000100ba,0)}
        for (uint256 i; i < rawTxs.length; i++) {
            txs[i] = rawToConvertedEIPTx1559(rawTxs[i]);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0002010e,0)}
        }
        return txs;
    }

    function rawToConvertedEIPTx1559(RawTx1559 memory rawTx) internal pure virtual returns (Tx1559 memory) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff012c0000, 1037618708780) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff012c0001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff012c0005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff012c6000, rawTx) }
        Tx1559 memory transaction;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000100bb,0)}
        transaction.arguments = rawTx.arguments;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000200ec,0)}
        transaction.contractName = rawTx.contractName;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000200ed,0)}
        transaction.functionSig = rawTx.functionSig;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000200ee,0)}
        transaction.hash = rawTx.hash;bytes32 certora_local239 = transaction.hash;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000000ef,certora_local239)}
        transaction.txDetail = rawToConvertedEIP1559Detail(rawTx.txDetail);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000200f0,0)}
        transaction.opcode = rawTx.opcode;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000200f1,0)}
        return transaction;
    }

    function rawToConvertedEIP1559Detail(RawTx1559Detail memory rawDetail)
        internal
        pure
        virtual
        returns (Tx1559Detail memory)
    {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff012b0000, 1037618708779) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff012b0001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff012b0005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff012b6000, rawDetail) }
        Tx1559Detail memory txDetail;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000100bc,0)}
        txDetail.data = rawDetail.data;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000200f2,0)}
        txDetail.from = rawDetail.from;address certora_local243 = txDetail.from;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000000f3,certora_local243)}
        txDetail.to = rawDetail.to;address certora_local244 = txDetail.to;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000000f4,certora_local244)}
        txDetail.nonce = _bytesToUint(rawDetail.nonce);uint256 certora_local245 = txDetail.nonce;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000000f5,certora_local245)}
        txDetail.txType = _bytesToUint(rawDetail.txType);uint256 certora_local246 = txDetail.txType;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000000f6,certora_local246)}
        txDetail.value = _bytesToUint(rawDetail.value);uint256 certora_local247 = txDetail.value;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000000f7,certora_local247)}
        txDetail.gas = _bytesToUint(rawDetail.gas);uint256 certora_local248 = txDetail.gas;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000000f8,certora_local248)}
        txDetail.accessList = rawDetail.accessList;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000200f9,0)}
        return txDetail;
    }

    function readTx1559s(string memory path) internal view virtual returns (Tx1559[] memory) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff012a0000, 1037618708778) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff012a0001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff012a0005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff012a6000, path) }
        string memory deployData = vm.readFile(path);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000100bd,0)}
        bytes memory parsedDeployData = vm.parseJson(deployData, ".transactions");assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000100be,0)}
        RawTx1559[] memory rawTxs = abi.decode(parsedDeployData, (RawTx1559[]));assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000100bf,0)}
        return rawToConvertedEIPTx1559s(rawTxs);
    }

    function readTx1559(string memory path, uint256 index) internal view virtual returns (Tx1559 memory) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff012d0000, 1037618708781) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff012d0001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff012d0005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff012d6001, index) }
        string memory deployData = vm.readFile(path);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000100c0,0)}
        string memory key = string(abi.encodePacked(".transactions[", vm.toString(index), "]"));assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000100c1,0)}
        bytes memory parsedDeployData = vm.parseJson(deployData, key);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000100c2,0)}
        RawTx1559 memory rawTx = abi.decode(parsedDeployData, (RawTx1559));assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000100c3,0)}
        return rawToConvertedEIPTx1559(rawTx);
    }

    // Analogous to readTransactions, but for receipts.
    function readReceipts(string memory path) internal view virtual returns (Receipt[] memory) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff012e0000, 1037618708782) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff012e0001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff012e0005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff012e6000, path) }
        string memory deployData = vm.readFile(path);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000100c4,0)}
        bytes memory parsedDeployData = vm.parseJson(deployData, ".receipts");assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000100c5,0)}
        RawReceipt[] memory rawReceipts = abi.decode(parsedDeployData, (RawReceipt[]));assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000100c6,0)}
        return rawToConvertedReceipts(rawReceipts);
    }

    function readReceipt(string memory path, uint256 index) internal view virtual returns (Receipt memory) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff012f0000, 1037618708783) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff012f0001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff012f0005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff012f6001, index) }
        string memory deployData = vm.readFile(path);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000100c7,0)}
        string memory key = string(abi.encodePacked(".receipts[", vm.toString(index), "]"));assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000100c8,0)}
        bytes memory parsedDeployData = vm.parseJson(deployData, key);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000100c9,0)}
        RawReceipt memory rawReceipt = abi.decode(parsedDeployData, (RawReceipt));assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000100ca,0)}
        return rawToConvertedReceipt(rawReceipt);
    }

    function rawToConvertedReceipts(RawReceipt[] memory rawReceipts) internal pure virtual returns (Receipt[] memory) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01300000, 1037618708784) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01300001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01300005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01306000, rawReceipts) }
        Receipt[] memory receipts = new Receipt[](rawReceipts.length);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000100cb,0)}
        for (uint256 i; i < rawReceipts.length; i++) {
            receipts[i] = rawToConvertedReceipt(rawReceipts[i]);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0002010f,0)}
        }
        return receipts;
    }

    function rawToConvertedReceipt(RawReceipt memory rawReceipt) internal pure virtual returns (Receipt memory) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01310000, 1037618708785) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01310001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01310005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01316000, rawReceipt) }
        Receipt memory receipt;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000100cc,0)}
        receipt.blockHash = rawReceipt.blockHash;bytes32 certora_local250 = receipt.blockHash;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000000fa,certora_local250)}
        receipt.to = rawReceipt.to;address certora_local251 = receipt.to;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000000fb,certora_local251)}
        receipt.from = rawReceipt.from;address certora_local252 = receipt.from;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000000fc,certora_local252)}
        receipt.contractAddress = rawReceipt.contractAddress;address certora_local253 = receipt.contractAddress;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000000fd,certora_local253)}
        receipt.effectiveGasPrice = _bytesToUint(rawReceipt.effectiveGasPrice);uint256 certora_local254 = receipt.effectiveGasPrice;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000000fe,certora_local254)}
        receipt.cumulativeGasUsed = _bytesToUint(rawReceipt.cumulativeGasUsed);uint256 certora_local255 = receipt.cumulativeGasUsed;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000000ff,certora_local255)}
        receipt.gasUsed = _bytesToUint(rawReceipt.gasUsed);uint256 certora_local256 = receipt.gasUsed;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000100,certora_local256)}
        receipt.status = _bytesToUint(rawReceipt.status);uint256 certora_local257 = receipt.status;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000101,certora_local257)}
        receipt.transactionIndex = _bytesToUint(rawReceipt.transactionIndex);uint256 certora_local258 = receipt.transactionIndex;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000102,certora_local258)}
        receipt.blockNumber = _bytesToUint(rawReceipt.blockNumber);uint256 certora_local259 = receipt.blockNumber;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000103,certora_local259)}
        receipt.logs = rawToConvertedReceiptLogs(rawReceipt.logs);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00020104,0)}
        receipt.logsBloom = rawReceipt.logsBloom;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00020105,0)}
        receipt.transactionHash = rawReceipt.transactionHash;bytes32 certora_local262 = receipt.transactionHash;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000106,certora_local262)}
        return receipt;
    }

    function rawToConvertedReceiptLogs(RawReceiptLog[] memory rawLogs)
        internal
        pure
        virtual
        returns (ReceiptLog[] memory)
    {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01320000, 1037618708786) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01320001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01320005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01326000, rawLogs) }
        ReceiptLog[] memory logs = new ReceiptLog[](rawLogs.length);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000100cd,0)}
        for (uint256 i; i < rawLogs.length; i++) {
            logs[i].logAddress = rawLogs[i].logAddress;address certora_local272 = logs[i].logAddress;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000110,certora_local272)}
            logs[i].blockHash = rawLogs[i].blockHash;bytes32 certora_local273 = logs[i].blockHash;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000111,certora_local273)}
            logs[i].blockNumber = _bytesToUint(rawLogs[i].blockNumber);uint256 certora_local274 = logs[i].blockNumber;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000112,certora_local274)}
            logs[i].data = rawLogs[i].data;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00020113,0)}
            logs[i].logIndex = _bytesToUint(rawLogs[i].logIndex);uint256 certora_local276 = logs[i].logIndex;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000114,certora_local276)}
            logs[i].topics = rawLogs[i].topics;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00020115,0)}
            logs[i].transactionIndex = _bytesToUint(rawLogs[i].transactionIndex);uint256 certora_local278 = logs[i].transactionIndex;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000116,certora_local278)}
            logs[i].transactionLogIndex = _bytesToUint(rawLogs[i].transactionLogIndex);uint256 certora_local279 = logs[i].transactionLogIndex;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000117,certora_local279)}
            logs[i].removed = rawLogs[i].removed;bool certora_local280 = logs[i].removed;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000118,certora_local280)}
        }
        return logs;
    }

    // Deploy a contract by fetching the contract bytecode from
    // the artifacts directory
    // e.g. `deployCode(code, abi.encode(arg1,arg2,arg3))`
    function deployCode(string memory what, bytes memory args) internal virtual returns (address addr) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01330000, 1037618708787) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01330001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01330005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01336001, args) }
        bytes memory bytecode = abi.encodePacked(vm.getCode(what), args);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000100ce,0)}
        /// @solidity memory-safe-assembly
        assembly {
            addr := create(0, add(bytecode, 0x20), mload(bytecode))
        }

        require(addr != address(0), "StdCheats deployCode(string,bytes): Deployment failed.");
    }

    function deployCode(string memory what) internal virtual returns (address addr) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01270000, 1037618708775) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01270001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01270005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01276000, what) }
        bytes memory bytecode = vm.getCode(what);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000100cf,0)}
        /// @solidity memory-safe-assembly
        assembly {
            addr := create(0, add(bytecode, 0x20), mload(bytecode))
        }

        require(addr != address(0), "StdCheats deployCode(string): Deployment failed.");
    }

    /// @dev deploy contract with value on construction
    function deployCode(string memory what, bytes memory args, uint256 val) internal virtual returns (address addr) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01280000, 1037618708776) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01280001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01280005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01286002, val) }
        bytes memory bytecode = abi.encodePacked(vm.getCode(what), args);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000100d0,0)}
        /// @solidity memory-safe-assembly
        assembly {
            addr := create(val, add(bytecode, 0x20), mload(bytecode))
        }

        require(addr != address(0), "StdCheats deployCode(string,bytes,uint256): Deployment failed.");
    }

    function deployCode(string memory what, uint256 val) internal virtual returns (address addr) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01290000, 1037618708777) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01290001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01290005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01296001, val) }
        bytes memory bytecode = vm.getCode(what);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000100d1,0)}
        /// @solidity memory-safe-assembly
        assembly {
            addr := create(val, add(bytecode, 0x20), mload(bytecode))
        }

        require(addr != address(0), "StdCheats deployCode(string,uint256): Deployment failed.");
    }

    // creates a labeled address and the corresponding private key
    function makeAddrAndKey(string memory name) internal virtual returns (address addr, uint256 privateKey) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01200000, 1037618708768) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01200001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01200005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01206000, name) }
        privateKey = uint256(keccak256(abi.encodePacked(name)));assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000107,privateKey)}
        addr = vm.addr(privateKey);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000108,addr)}
        vm.label(addr, name);
    }

    // creates a labeled address
    function makeAddr(string memory name) internal virtual returns (address addr) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01210000, 1037618708769) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01210001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01210005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01216000, name) }
        (addr,) = makeAddrAndKey(name);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00020109,0)}
    }

    // Destroys an account immediately, sending the balance to beneficiary.
    // Destroying means: balance will be zero, code will be empty, and nonce will be 0
    // This is similar to selfdestruct but not identical: selfdestruct destroys code and nonce
    // only after tx ends, this will run immediately.
    function destroyAccount(address who, address beneficiary) internal virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01220000, 1037618708770) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01220001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01220005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01226001, beneficiary) }
        uint256 currBalance = who.balance;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000000d2,currBalance)}
        vm.etch(who, abi.encode());
        vm.deal(who, 0);
        vm.resetNonce(who);

        uint256 beneficiaryBalance = beneficiary.balance;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000000d3,beneficiaryBalance)}
        vm.deal(beneficiary, currBalance + beneficiaryBalance);
    }

    // creates a struct containing both a labeled address and the corresponding private key
    function makeAccount(string memory name) internal virtual returns (Account memory account) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01230000, 1037618708771) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01230001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01230005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01236000, name) }
        (account.addr, account.key) = makeAddrAndKey(name);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0002010a,0)}
    }

    function deriveRememberKey(string memory mnemonic, uint32 index)
        internal
        virtual
        returns (address who, uint256 privateKey)
    {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01240000, 1037618708772) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01240001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01240005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01246001, index) }
        privateKey = vm.deriveKey(mnemonic, index);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0000010b,privateKey)}
        who = vm.rememberKey(privateKey);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0000010c,who)}
    }

    function _bytesToUint(bytes memory b) private pure returns (uint256) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01250000, 1037618708773) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01250001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01250005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01256000, b) }
        require(b.length <= 32, "StdCheats _bytesToUint(bytes): Bytes length exceeds 32.");
        return abi.decode(abi.encodePacked(new bytes(32 - b.length), b), (uint256));
    }

    function isFork() internal view virtual returns (bool status) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01260000, 1037618708774) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01260001, 0) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01260004, 0) }
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
        bool gasStartedOff = gasMeteringOff;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000000d4,gasStartedOff)}
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
    function _viewChainId() private view returns (uint256 chainId) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01340000, 1037618708788) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01340001, 0) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01340004, 0) }
        // Assembly required since `block.chainid` was introduced in 0.8.0.
        assembly {
            chainId := chainid()
        }

        address(this); // Silence warnings in older Solc versions.
    }

    function _pureChainId() private pure returns (uint256 chainId) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01350000, 1037618708789) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01350001, 0) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01350004, 0) }
        function() internal view returns (uint256) fnIn = _viewChainId;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000100d5,0)}
        function() internal pure returns (uint256) pureChainId;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000100d6,0)}
        assembly {
            pureChainId := fnIn
        }
        chainId = pureChainId();assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0000010d,chainId)}
    }
}

// Wrappers around cheatcodes to avoid footguns
abstract contract StdCheats is StdCheatsSafe {
    using stdStorage for StdStorage;

    StdStorage private stdstore;
    Vm private constant vm = Vm(address(uint160(uint256(keccak256("hevm cheat code")))));
    address private constant CONSOLE2_ADDRESS = 0x000000000000000000636F6e736F6c652e6c6f67;

    // Skip forward or rewind time by the specified number of seconds
    function skip(uint256 time) internal virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00fa0000, 1037618708730) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00fa0001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00fa0005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00fa6000, time) }
        vm.warp(vm.getBlockTimestamp() + time);
    }

    function rewind(uint256 time) internal virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00fb0000, 1037618708731) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00fb0001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00fb0005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00fb6000, time) }
        vm.warp(vm.getBlockTimestamp() - time);
    }

    // Setup a prank from an address that has some ether
    function hoax(address msgSender) internal virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00fd0000, 1037618708733) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00fd0001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00fd0005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00fd6000, msgSender) }
        vm.deal(msgSender, 1 << 128);
        vm.prank(msgSender);
    }

    function hoax(address msgSender, uint256 give) internal virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00fe0000, 1037618708734) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00fe0001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00fe0005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00fe6001, give) }
        vm.deal(msgSender, give);
        vm.prank(msgSender);
    }

    function hoax(address msgSender, address origin) internal virtual {address certoraRename252_1 = origin;assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00fc0000, 1037618708732) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00fc0001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00fc0005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00fc6001, certoraRename252_1) }
        vm.deal(msgSender, 1 << 128);
        vm.prank(msgSender, origin);
    }

    function hoax(address msgSender, address origin, uint256 give) internal virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00ff0000, 1037618708735) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00ff0001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00ff0005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00ff6002, give) }
        vm.deal(msgSender, give);
        vm.prank(msgSender, origin);
    }

    // Start perpetual prank from an address that has some ether
    function startHoax(address msgSender) internal virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01000000, 1037618708736) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01000001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01000005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01006000, msgSender) }
        vm.deal(msgSender, 1 << 128);
        vm.startPrank(msgSender);
    }

    function startHoax(address msgSender, uint256 give) internal virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01010000, 1037618708737) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01010001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01010005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01016001, give) }
        vm.deal(msgSender, give);
        vm.startPrank(msgSender);
    }

    // Start perpetual prank from an address that has some ether
    // tx.origin is set to the origin parameter
    function startHoax(address msgSender, address origin) internal virtual {address certoraRename258_1 = origin;assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01020000, 1037618708738) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01020001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01020005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01026001, certoraRename258_1) }
        vm.deal(msgSender, 1 << 128);
        vm.startPrank(msgSender, origin);
    }

    function startHoax(address msgSender, address origin, uint256 give) internal virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01030000, 1037618708739) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01030001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01030005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01036002, give) }
        vm.deal(msgSender, give);
        vm.startPrank(msgSender, origin);
    }

    function changePrank(address msgSender) internal virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01040000, 1037618708740) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01040001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01040005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01046000, msgSender) }
        console2_log_StdCheats("changePrank is deprecated. Please use vm.startPrank instead.");
        vm.stopPrank();
        vm.startPrank(msgSender);
    }

    function changePrank(address msgSender, address txOrigin) internal virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01050000, 1037618708741) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01050001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01050005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01056001, txOrigin) }
        vm.stopPrank();
        vm.startPrank(msgSender, txOrigin);
    }

    // The same as Vm's `deal`
    // Use the alternative signature for ERC20 tokens
    function deal(address to, uint256 give) internal virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01060000, 1037618708742) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01060001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01060005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01066001, give) }
        vm.deal(to, give);
    }

    // Set the balance of an account for any ERC20 token
    // Use the alternative signature to update `totalSupply`
    function deal(address token, address to, uint256 give) internal virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01070000, 1037618708743) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01070001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01070005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01076002, give) }
        deal(token, to, give, false);
    }

    // Set the balance of an account for any ERC1155 token
    // Use the alternative signature to update `totalSupply`
    function dealERC1155(address token, address to, uint256 id, uint256 give) internal virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01080000, 1037618708744) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01080001, 4) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01080005, 585) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01086003, give) }
        dealERC1155(token, to, id, give, false);
    }

    function deal(address token, address to, uint256 give, bool adjust) internal virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01090000, 1037618708745) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01090001, 4) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01090005, 585) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01096003, adjust) }
        // get current balance
        (, bytes memory balData) = token.staticcall(abi.encodeWithSelector(0x70a08231, to));assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000100d7,0)}
        uint256 prevBal = abi.decode(balData, (uint256));assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000000d8,prevBal)}

        // update balance
        stdstore.target(token).sig(0x70a08231).with_key(to).checked_write(give);

        // update total supply
        if (adjust) {
            (, bytes memory totSupData) = token.staticcall(abi.encodeWithSelector(0x18160ddd));
            uint256 totSup = abi.decode(totSupData, (uint256));
            if (give < prevBal) {
                totSup -= (prevBal - give);
            } else {
                totSup += (give - prevBal);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000119,totSup)}
            }
            stdstore.target(token).sig(0x18160ddd).checked_write(totSup);
        }
    }

    function dealERC1155(address token, address to, uint256 id, uint256 give, bool adjust) internal virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff010c0000, 1037618708748) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff010c0001, 5) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff010c0005, 4681) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff010c6004, adjust) }
        // get current balance
        (, bytes memory balData) = token.staticcall(abi.encodeWithSelector(0x00fdd58e, to, id));assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000100d9,0)}
        uint256 prevBal = abi.decode(balData, (uint256));assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000000da,prevBal)}

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
                totSup += (give - prevBal);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0000011a,totSup)}
            }
            stdstore.target(token).sig(0xbd85b039).with_key(id).checked_write(totSup);
        }
    }

    function dealERC721(address token, address to, uint256 id) internal virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff010b0000, 1037618708747) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff010b0001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff010b0005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff010b6002, id) }
        // check if token id is already minted and the actual owner.
        (bool successMinted, bytes memory ownerData) = token.staticcall(abi.encodeWithSelector(0x6352211e, id));assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000100db,0)}
        require(successMinted, "StdCheats deal(address,address,uint,bool): id not minted.");

        // get owner current balance
        (, bytes memory fromBalData) =
            token.staticcall(abi.encodeWithSelector(0x70a08231, abi.decode(ownerData, (address))));assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000100dc,0)}
        uint256 fromPrevBal = abi.decode(fromBalData, (uint256));assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000000dd,fromPrevBal)}

        // get new user current balance
        (, bytes memory toBalData) = token.staticcall(abi.encodeWithSelector(0x70a08231, to));assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000100de,0)}
        uint256 toPrevBal = abi.decode(toBalData, (uint256));assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000000df,toPrevBal)}

        // update balances
        stdstore.target(token).sig(0x70a08231).with_key(abi.decode(ownerData, (address))).checked_write(--fromPrevBal);
        stdstore.target(token).sig(0x70a08231).with_key(to).checked_write(++toPrevBal);

        // update owner
        stdstore.target(token).sig(0x6352211e).with_key(id).checked_write(to);
    }

    function deployCodeTo(string memory what, address where) internal virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff010a0000, 1037618708746) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff010a0001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff010a0005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff010a6001, where) }
        deployCodeTo(what, "", 0, where);
    }

    function deployCodeTo(string memory what, bytes memory args, address where) internal virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff010d0000, 1037618708749) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff010d0001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff010d0005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff010d6002, where) }
        deployCodeTo(what, args, 0, where);
    }

    function deployCodeTo(string memory what, bytes memory args, uint256 value, address where) internal virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff010e0000, 1037618708750) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff010e0001, 4) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff010e0005, 585) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff010e6003, where) }
        bytes memory creationCode = vm.getCode(what);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000100e0,0)}
        vm.etch(where, abi.encodePacked(creationCode, args));
        (bool success, bytes memory runtimeBytecode) = where.call{value: value}("");assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000100e1,0)}
        require(success, "StdCheats deployCodeTo(string,bytes,uint256,address): Failed to create runtime bytecode.");
        vm.etch(where, runtimeBytecode);
    }

    // Used to prevent the compilation of console, which shortens the compilation time when console is not used elsewhere.
    function console2_log_StdCheats(string memory p0) private view {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff010f0000, 1037618708751) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff010f0001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff010f0005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff010f6000, p0) }
        (bool status,) = address(CONSOLE2_ADDRESS).staticcall(abi.encodeWithSignature("log(string)", p0));assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000100e2,0)}
        status;
    }
}
