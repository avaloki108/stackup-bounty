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
    function assumeNotBlacklisted(address token, address addr) internal view virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05540000, 1037618709844) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05540001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05540005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05546001, addr) }
        // Nothing to check if `token` is not a contract.
        uint256 tokenCodeSize;
        assembly {
            tokenCodeSize := extcodesize(token)
        }
        require(tokenCodeSize > 0, "StdCheats assumeNotBlacklisted(address,address): Token address is not a contract.");

        bool success;
        bytes memory returnData;

        // 4-byte selector for `isBlacklisted(address)`, used by USDC.
        (success, returnData) = token.staticcall(abi.encodeWithSelector(0xfe575a87, addr));
        vm.assume(!success || abi.decode(returnData, (bool)) == false);

        // 4-byte selector for `isBlackListed(address)`, used by USDT.
        (success, returnData) = token.staticcall(abi.encodeWithSelector(0xe47d6060, addr));
        vm.assume(!success || abi.decode(returnData, (bool)) == false);
    }

    // Checks that `addr` is not blacklisted by token contracts that have a blacklist.
    // This is identical to `assumeNotBlacklisted(address,address)` but with a different name, for
    // backwards compatibility, since this name was used in the original PR which already has
    // a release. This function can be removed in a future release once we want a breaking change.
    function assumeNoBlacklisted(address token, address addr) internal view virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05550000, 1037618709845) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05550001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05550005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05556001, addr) }
        assumeNotBlacklisted(token, addr);
    }

    function assumeAddressIsNot(address addr, AddressType addressType) internal virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05570000, 1037618709847) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05570001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05570005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05576001, addressType) }
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

    function assumeAddressIsNot(address addr, AddressType addressType1, AddressType addressType2) internal virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05580000, 1037618709848) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05580001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05580005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05586002, addressType2) }
        assumeAddressIsNot(addr, addressType1);
        assumeAddressIsNot(addr, addressType2);
    }

    function assumeAddressIsNot(
        address addr,
        AddressType addressType1,
        AddressType addressType2,
        AddressType addressType3
    ) internal virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05560000, 1037618709846) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05560001, 4) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05560005, 585) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05566003, addressType3) }
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
    ) internal virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05590000, 1037618709849) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05590001, 5) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05590005, 4681) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05596004, addressType4) }
        assumeAddressIsNot(addr, addressType1);
        assumeAddressIsNot(addr, addressType2);
        assumeAddressIsNot(addr, addressType3);
        assumeAddressIsNot(addr, addressType4);
    }

    // This function checks whether an address, `addr`, is payable. It works by sending 1 wei to
    // `addr` and checking the `success` return value.
    // NOTE: This function may result in state changes depending on the fallback/receive logic
    // implemented by `addr`, which should be taken into account when this function is used.
    function _isPayable(address addr) private returns (bool) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff055a0000, 1037618709850) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff055a0001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff055a0005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff055a6000, addr) }
        require(
            addr.balance < UINT256_MAX,
            "StdCheats _isPayable(address): Balance equals max uint256, so it cannot receive any more funds"
        );
        uint256 origBalanceTest = address(this).balance;
        uint256 origBalanceAddr = address(addr).balance;

        vm.deal(address(this), 1);
        (bool success,) = payable(addr).call{value: 1}("");

        // reset balances
        vm.deal(address(this), origBalanceTest);
        vm.deal(addr, origBalanceAddr);

        return success;
    }

    // NOTE: This function may result in state changes depending on the fallback/receive logic
    // implemented by `addr`, which should be taken into account when this function is used. See the
    // `_isPayable` method for more information.
    function assumePayable(address addr) internal virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff055b0000, 1037618709851) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff055b0001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff055b0005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff055b6000, addr) }
        vm.assume(_isPayable(addr));
    }

    function assumeNotPayable(address addr) internal virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff055c0000, 1037618709852) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff055c0001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff055c0005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff055c6000, addr) }
        vm.assume(!_isPayable(addr));
    }

    function assumeNotZeroAddress(address addr) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff055d0000, 1037618709853) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff055d0001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff055d0005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff055d6000, addr) }
        vm.assume(addr != address(0));
    }

    function assumeNotPrecompile(address addr) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff055e0000, 1037618709854) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff055e0001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff055e0005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff055e6000, addr) }
        assumeNotPrecompile(addr, _pureChainId());
    }

    function assumeNotPrecompile(address addr, uint256 chainId) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff055f0000, 1037618709855) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff055f0001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff055f0005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff055f6001, chainId) }
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

    function assumeNotForgeAddress(address addr) internal pure virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05600000, 1037618709856) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05600001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05600005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05606000, addr) }
        // vm, console, and Create2Deployer addresses
        vm.assume(
            addr != address(vm) && addr != 0x000000000000000000636F6e736F6c652e6c6f67
                && addr != 0x4e59b44847b379578588920cA78FbF26c0B4956C
        );
    }

    function assumeUnusedAddress(address addr) internal view virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05610000, 1037618709857) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05610001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05610005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05616000, addr) }
        uint256 size;
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
    {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05620000, 1037618709858) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05620001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05620005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05626000, path) }
        string memory data = vm.readFile(path);
        bytes memory parsedData = vm.parseJson(data);
        RawEIP1559ScriptArtifact memory rawArtifact = abi.decode(parsedData, (RawEIP1559ScriptArtifact));
        EIP1559ScriptArtifact memory artifact;
        artifact.libraries = rawArtifact.libraries;
        artifact.path = rawArtifact.path;
        artifact.timestamp = rawArtifact.timestamp;
        artifact.pending = rawArtifact.pending;
        artifact.txReturns = rawArtifact.txReturns;
        artifact.receipts = rawToConvertedReceipts(rawArtifact.receipts);
        artifact.transactions = rawToConvertedEIPTx1559s(rawArtifact.transactions);
        return artifact;
    }

    function rawToConvertedEIPTx1559s(RawTx1559[] memory rawTxs) internal pure virtual returns (Tx1559[] memory) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05630000, 1037618709859) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05630001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05630005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05636000, rawTxs) }
        Tx1559[] memory txs = new Tx1559[](rawTxs.length);
        for (uint256 i; i < rawTxs.length; i++) {
            txs[i] = rawToConvertedEIPTx1559(rawTxs[i]);
        }
        return txs;
    }

    function rawToConvertedEIPTx1559(RawTx1559 memory rawTx) internal pure virtual returns (Tx1559 memory) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05700000, 1037618709872) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05700001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05700005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05706000, rawTx) }
        Tx1559 memory transaction;
        transaction.arguments = rawTx.arguments;
        transaction.contractName = rawTx.contractName;
        transaction.functionSig = rawTx.functionSig;
        transaction.hash = rawTx.hash;
        transaction.txDetail = rawToConvertedEIP1559Detail(rawTx.txDetail);
        transaction.opcode = rawTx.opcode;
        return transaction;
    }

    function rawToConvertedEIP1559Detail(RawTx1559Detail memory rawDetail)
        internal
        pure
        virtual
        returns (Tx1559Detail memory)
    {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff056f0000, 1037618709871) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff056f0001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff056f0005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff056f6000, rawDetail) }
        Tx1559Detail memory txDetail;
        txDetail.data = rawDetail.data;
        txDetail.from = rawDetail.from;
        txDetail.to = rawDetail.to;
        txDetail.nonce = _bytesToUint(rawDetail.nonce);
        txDetail.txType = _bytesToUint(rawDetail.txType);
        txDetail.value = _bytesToUint(rawDetail.value);
        txDetail.gas = _bytesToUint(rawDetail.gas);
        txDetail.accessList = rawDetail.accessList;
        return txDetail;
    }

    function readTx1559s(string memory path) internal view virtual returns (Tx1559[] memory) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff056e0000, 1037618709870) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff056e0001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff056e0005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff056e6000, path) }
        string memory deployData = vm.readFile(path);
        bytes memory parsedDeployData = vm.parseJson(deployData, ".transactions");
        RawTx1559[] memory rawTxs = abi.decode(parsedDeployData, (RawTx1559[]));
        return rawToConvertedEIPTx1559s(rawTxs);
    }

    function readTx1559(string memory path, uint256 index) internal view virtual returns (Tx1559 memory) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05710000, 1037618709873) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05710001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05710005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05716001, index) }
        string memory deployData = vm.readFile(path);
        string memory key = string(abi.encodePacked(".transactions[", vm.toString(index), "]"));
        bytes memory parsedDeployData = vm.parseJson(deployData, key);
        RawTx1559 memory rawTx = abi.decode(parsedDeployData, (RawTx1559));
        return rawToConvertedEIPTx1559(rawTx);
    }

    // Analogous to readTransactions, but for receipts.
    function readReceipts(string memory path) internal view virtual returns (Receipt[] memory) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05720000, 1037618709874) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05720001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05720005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05726000, path) }
        string memory deployData = vm.readFile(path);
        bytes memory parsedDeployData = vm.parseJson(deployData, ".receipts");
        RawReceipt[] memory rawReceipts = abi.decode(parsedDeployData, (RawReceipt[]));
        return rawToConvertedReceipts(rawReceipts);
    }

    function readReceipt(string memory path, uint256 index) internal view virtual returns (Receipt memory) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05730000, 1037618709875) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05730001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05730005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05736001, index) }
        string memory deployData = vm.readFile(path);
        string memory key = string(abi.encodePacked(".receipts[", vm.toString(index), "]"));
        bytes memory parsedDeployData = vm.parseJson(deployData, key);
        RawReceipt memory rawReceipt = abi.decode(parsedDeployData, (RawReceipt));
        return rawToConvertedReceipt(rawReceipt);
    }

    function rawToConvertedReceipts(RawReceipt[] memory rawReceipts) internal pure virtual returns (Receipt[] memory) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05740000, 1037618709876) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05740001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05740005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05746000, rawReceipts) }
        Receipt[] memory receipts = new Receipt[](rawReceipts.length);
        for (uint256 i; i < rawReceipts.length; i++) {
            receipts[i] = rawToConvertedReceipt(rawReceipts[i]);
        }
        return receipts;
    }

    function rawToConvertedReceipt(RawReceipt memory rawReceipt) internal pure virtual returns (Receipt memory) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05750000, 1037618709877) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05750001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05750005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05756000, rawReceipt) }
        Receipt memory receipt;
        receipt.blockHash = rawReceipt.blockHash;
        receipt.to = rawReceipt.to;
        receipt.from = rawReceipt.from;
        receipt.contractAddress = rawReceipt.contractAddress;
        receipt.effectiveGasPrice = _bytesToUint(rawReceipt.effectiveGasPrice);
        receipt.cumulativeGasUsed = _bytesToUint(rawReceipt.cumulativeGasUsed);
        receipt.gasUsed = _bytesToUint(rawReceipt.gasUsed);
        receipt.status = _bytesToUint(rawReceipt.status);
        receipt.transactionIndex = _bytesToUint(rawReceipt.transactionIndex);
        receipt.blockNumber = _bytesToUint(rawReceipt.blockNumber);
        receipt.logs = rawToConvertedReceiptLogs(rawReceipt.logs);
        receipt.logsBloom = rawReceipt.logsBloom;
        receipt.transactionHash = rawReceipt.transactionHash;
        return receipt;
    }

    function rawToConvertedReceiptLogs(RawReceiptLog[] memory rawLogs)
        internal
        pure
        virtual
        returns (ReceiptLog[] memory)
    {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05760000, 1037618709878) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05760001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05760005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05766000, rawLogs) }
        ReceiptLog[] memory logs = new ReceiptLog[](rawLogs.length);
        for (uint256 i; i < rawLogs.length; i++) {
            logs[i].logAddress = rawLogs[i].logAddress;
            logs[i].blockHash = rawLogs[i].blockHash;
            logs[i].blockNumber = _bytesToUint(rawLogs[i].blockNumber);
            logs[i].data = rawLogs[i].data;
            logs[i].logIndex = _bytesToUint(rawLogs[i].logIndex);
            logs[i].topics = rawLogs[i].topics;
            logs[i].transactionIndex = _bytesToUint(rawLogs[i].transactionIndex);
            logs[i].transactionLogIndex = _bytesToUint(rawLogs[i].transactionLogIndex);
            logs[i].removed = rawLogs[i].removed;
        }
        return logs;
    }

    // Deploy a contract by fetching the contract bytecode from
    // the artifacts directory
    // e.g. `deployCode(code, abi.encode(arg1,arg2,arg3))`
    function deployCode(string memory what, bytes memory args) internal virtual returns (address addr) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05770000, 1037618709879) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05770001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05770005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05776001, args) }
        bytes memory bytecode = abi.encodePacked(vm.getCode(what), args);
        /// @solidity memory-safe-assembly
        assembly {
            addr := create(0, add(bytecode, 0x20), mload(bytecode))
        }

        require(addr != address(0), "StdCheats deployCode(string,bytes): Deployment failed.");
    }

    function deployCode(string memory what) internal virtual returns (address addr) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff056b0000, 1037618709867) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff056b0001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff056b0005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff056b6000, what) }
        bytes memory bytecode = vm.getCode(what);
        /// @solidity memory-safe-assembly
        assembly {
            addr := create(0, add(bytecode, 0x20), mload(bytecode))
        }

        require(addr != address(0), "StdCheats deployCode(string): Deployment failed.");
    }

    /// @dev deploy contract with value on construction
    function deployCode(string memory what, bytes memory args, uint256 val) internal virtual returns (address addr) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff056c0000, 1037618709868) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff056c0001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff056c0005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff056c6002, val) }
        bytes memory bytecode = abi.encodePacked(vm.getCode(what), args);
        /// @solidity memory-safe-assembly
        assembly {
            addr := create(val, add(bytecode, 0x20), mload(bytecode))
        }

        require(addr != address(0), "StdCheats deployCode(string,bytes,uint256): Deployment failed.");
    }

    function deployCode(string memory what, uint256 val) internal virtual returns (address addr) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff056d0000, 1037618709869) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff056d0001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff056d0005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff056d6001, val) }
        bytes memory bytecode = vm.getCode(what);
        /// @solidity memory-safe-assembly
        assembly {
            addr := create(val, add(bytecode, 0x20), mload(bytecode))
        }

        require(addr != address(0), "StdCheats deployCode(string,uint256): Deployment failed.");
    }

    // creates a labeled address and the corresponding private key
    function makeAddrAndKey(string memory name) internal virtual returns (address addr, uint256 privateKey) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05640000, 1037618709860) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05640001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05640005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05646000, name) }
        privateKey = uint256(keccak256(abi.encodePacked(name)));
        addr = vm.addr(privateKey);
        vm.label(addr, name);
    }

    // creates a labeled address
    function makeAddr(string memory name) internal virtual returns (address addr) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05650000, 1037618709861) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05650001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05650005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05656000, name) }
        (addr,) = makeAddrAndKey(name);
    }

    // Destroys an account immediately, sending the balance to beneficiary.
    // Destroying means: balance will be zero, code will be empty, and nonce will be 0
    // This is similar to selfdestruct but not identical: selfdestruct destroys code and nonce
    // only after tx ends, this will run immediately.
    function destroyAccount(address who, address beneficiary) internal virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05660000, 1037618709862) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05660001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05660005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05666001, beneficiary) }
        uint256 currBalance = who.balance;
        vm.etch(who, abi.encode());
        vm.deal(who, 0);
        vm.resetNonce(who);

        uint256 beneficiaryBalance = beneficiary.balance;
        vm.deal(beneficiary, currBalance + beneficiaryBalance);
    }

    // creates a struct containing both a labeled address and the corresponding private key
    function makeAccount(string memory name) internal virtual returns (Account memory account) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05670000, 1037618709863) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05670001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05670005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05676000, name) }
        (account.addr, account.key) = makeAddrAndKey(name);
    }

    function deriveRememberKey(string memory mnemonic, uint32 index)
        internal
        virtual
        returns (address who, uint256 privateKey)
    {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05680000, 1037618709864) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05680001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05680005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05686001, index) }
        privateKey = vm.deriveKey(mnemonic, index);
        who = vm.rememberKey(privateKey);
    }

    function _bytesToUint(bytes memory b) private pure returns (uint256) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05690000, 1037618709865) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05690001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05690005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05696000, b) }
        require(b.length <= 32, "StdCheats _bytesToUint(bytes): Bytes length exceeds 32.");
        return abi.decode(abi.encodePacked(new bytes(32 - b.length), b), (uint256));
    }

    function isFork() internal view virtual returns (bool status) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff056a0000, 1037618709866) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff056a0001, 0) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff056a0004, 0) }
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
        bool gasStartedOff = gasMeteringOff;
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
    function _viewChainId() private view returns (uint256 chainId) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05780000, 1037618709880) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05780001, 0) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05780004, 0) }
        // Assembly required since `block.chainid` was introduced in 0.8.0.
        assembly {
            chainId := chainid()
        }

        address(this); // Silence warnings in older Solc versions.
    }

    function _pureChainId() private pure returns (uint256 chainId) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05790000, 1037618709881) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05790001, 0) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05790004, 0) }
        function() internal view returns (uint256) fnIn = _viewChainId;
        function() internal pure returns (uint256) pureChainId;
        assembly {
            pureChainId := fnIn
        }
        chainId = pureChainId();
    }
}

// Wrappers around cheatcodes to avoid footguns
abstract contract StdCheats is StdCheatsSafe {
    using stdStorage for StdStorage;

    StdStorage private stdstore;
    Vm private constant vm = Vm(address(uint160(uint256(keccak256("hevm cheat code")))));
    address private constant CONSOLE2_ADDRESS = 0x000000000000000000636F6e736F6c652e6c6f67;

    // Skip forward or rewind time by the specified number of seconds
    function skip(uint256 time) internal virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff053e0000, 1037618709822) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff053e0001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff053e0005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff053e6000, time) }
        vm.warp(vm.getBlockTimestamp() + time);
    }

    function rewind(uint256 time) internal virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff053f0000, 1037618709823) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff053f0001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff053f0005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff053f6000, time) }
        vm.warp(vm.getBlockTimestamp() - time);
    }

    // Setup a prank from an address that has some ether
    function hoax(address msgSender) internal virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05410000, 1037618709825) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05410001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05410005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05416000, msgSender) }
        vm.deal(msgSender, 1 << 128);
        vm.prank(msgSender);
    }

    function hoax(address msgSender, uint256 give) internal virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05420000, 1037618709826) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05420001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05420005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05426001, give) }
        vm.deal(msgSender, give);
        vm.prank(msgSender);
    }

    function hoax(address msgSender, address origin) internal virtual {address certoraRename1344_1 = origin;assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05400000, 1037618709824) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05400001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05400005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05406001, certoraRename1344_1) }
        vm.deal(msgSender, 1 << 128);
        vm.prank(msgSender, origin);
    }

    function hoax(address msgSender, address origin, uint256 give) internal virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05430000, 1037618709827) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05430001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05430005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05436002, give) }
        vm.deal(msgSender, give);
        vm.prank(msgSender, origin);
    }

    // Start perpetual prank from an address that has some ether
    function startHoax(address msgSender) internal virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05440000, 1037618709828) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05440001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05440005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05446000, msgSender) }
        vm.deal(msgSender, 1 << 128);
        vm.startPrank(msgSender);
    }

    function startHoax(address msgSender, uint256 give) internal virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05450000, 1037618709829) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05450001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05450005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05456001, give) }
        vm.deal(msgSender, give);
        vm.startPrank(msgSender);
    }

    // Start perpetual prank from an address that has some ether
    // tx.origin is set to the origin parameter
    function startHoax(address msgSender, address origin) internal virtual {address certoraRename1350_1 = origin;assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05460000, 1037618709830) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05460001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05460005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05466001, certoraRename1350_1) }
        vm.deal(msgSender, 1 << 128);
        vm.startPrank(msgSender, origin);
    }

    function startHoax(address msgSender, address origin, uint256 give) internal virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05470000, 1037618709831) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05470001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05470005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05476002, give) }
        vm.deal(msgSender, give);
        vm.startPrank(msgSender, origin);
    }

    function changePrank(address msgSender) internal virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05480000, 1037618709832) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05480001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05480005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05486000, msgSender) }
        console2_log_StdCheats("changePrank is deprecated. Please use vm.startPrank instead.");
        vm.stopPrank();
        vm.startPrank(msgSender);
    }

    function changePrank(address msgSender, address txOrigin) internal virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05490000, 1037618709833) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05490001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05490005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05496001, txOrigin) }
        vm.stopPrank();
        vm.startPrank(msgSender, txOrigin);
    }

    // The same as Vm's `deal`
    // Use the alternative signature for ERC20 tokens
    function deal(address to, uint256 give) internal virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff054a0000, 1037618709834) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff054a0001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff054a0005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff054a6001, give) }
        vm.deal(to, give);
    }

    // Set the balance of an account for any ERC20 token
    // Use the alternative signature to update `totalSupply`
    function deal(address token, address to, uint256 give) internal virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff054b0000, 1037618709835) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff054b0001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff054b0005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff054b6002, give) }
        deal(token, to, give, false);
    }

    // Set the balance of an account for any ERC1155 token
    // Use the alternative signature to update `totalSupply`
    function dealERC1155(address token, address to, uint256 id, uint256 give) internal virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff054c0000, 1037618709836) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff054c0001, 4) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff054c0005, 585) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff054c6003, give) }
        dealERC1155(token, to, id, give, false);
    }

    function deal(address token, address to, uint256 give, bool adjust) internal virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff054d0000, 1037618709837) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff054d0001, 4) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff054d0005, 585) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff054d6003, adjust) }
        // get current balance
        (, bytes memory balData) = token.staticcall(abi.encodeWithSelector(0x70a08231, to));
        uint256 prevBal = abi.decode(balData, (uint256));

        // update balance
        stdstore.target(token).sig(0x70a08231).with_key(to).checked_write(give);

        // update total supply
        if (adjust) {
            (, bytes memory totSupData) = token.staticcall(abi.encodeWithSelector(0x18160ddd));
            uint256 totSup = abi.decode(totSupData, (uint256));
            if (give < prevBal) {
                totSup -= (prevBal - give);
            } else {
                totSup += (give - prevBal);
            }
            stdstore.target(token).sig(0x18160ddd).checked_write(totSup);
        }
    }

    function dealERC1155(address token, address to, uint256 id, uint256 give, bool adjust) internal virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05500000, 1037618709840) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05500001, 5) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05500005, 4681) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05506004, adjust) }
        // get current balance
        (, bytes memory balData) = token.staticcall(abi.encodeWithSelector(0x00fdd58e, to, id));
        uint256 prevBal = abi.decode(balData, (uint256));

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
                totSup += (give - prevBal);
            }
            stdstore.target(token).sig(0xbd85b039).with_key(id).checked_write(totSup);
        }
    }

    function dealERC721(address token, address to, uint256 id) internal virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff054f0000, 1037618709839) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff054f0001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff054f0005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff054f6002, id) }
        // check if token id is already minted and the actual owner.
        (bool successMinted, bytes memory ownerData) = token.staticcall(abi.encodeWithSelector(0x6352211e, id));
        require(successMinted, "StdCheats deal(address,address,uint,bool): id not minted.");

        // get owner current balance
        (, bytes memory fromBalData) =
            token.staticcall(abi.encodeWithSelector(0x70a08231, abi.decode(ownerData, (address))));
        uint256 fromPrevBal = abi.decode(fromBalData, (uint256));

        // get new user current balance
        (, bytes memory toBalData) = token.staticcall(abi.encodeWithSelector(0x70a08231, to));
        uint256 toPrevBal = abi.decode(toBalData, (uint256));

        // update balances
        stdstore.target(token).sig(0x70a08231).with_key(abi.decode(ownerData, (address))).checked_write(--fromPrevBal);
        stdstore.target(token).sig(0x70a08231).with_key(to).checked_write(++toPrevBal);

        // update owner
        stdstore.target(token).sig(0x6352211e).with_key(id).checked_write(to);
    }

    function deployCodeTo(string memory what, address where) internal virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff054e0000, 1037618709838) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff054e0001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff054e0005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff054e6001, where) }
        deployCodeTo(what, "", 0, where);
    }

    function deployCodeTo(string memory what, bytes memory args, address where) internal virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05510000, 1037618709841) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05510001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05510005, 73) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05516002, where) }
        deployCodeTo(what, args, 0, where);
    }

    function deployCodeTo(string memory what, bytes memory args, uint256 value, address where) internal virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05520000, 1037618709842) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05520001, 4) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05520005, 585) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05526003, where) }
        bytes memory creationCode = vm.getCode(what);
        vm.etch(where, abi.encodePacked(creationCode, args));
        (bool success, bytes memory runtimeBytecode) = where.call{value: value}("");
        require(success, "StdCheats deployCodeTo(string,bytes,uint256,address): Failed to create runtime bytecode.");
        vm.etch(where, runtimeBytecode);
    }

    // Used to prevent the compilation of console, which shortens the compilation time when console is not used elsewhere.
    function console2_log_StdCheats(string memory p0) private view {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05530000, 1037618709843) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05530001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05530005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05536000, p0) }
        (bool status,) = address(CONSOLE2_ADDRESS).staticcall(abi.encodeWithSignature("log(string)", p0));
        status;
    }
}
