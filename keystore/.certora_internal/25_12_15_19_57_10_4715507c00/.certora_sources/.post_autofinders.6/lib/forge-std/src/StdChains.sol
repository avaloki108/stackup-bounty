// SPDX-License-Identifier: MIT
pragma solidity >=0.6.2 <0.9.0;

import {VmSafe} from "./Vm.sol";

/**
 * StdChains provides information about EVM compatible chains that can be used in scripts/tests.
 * For each chain, the chain's name, chain ID, and a default RPC URL are provided. Chains are
 * identified by their alias, which is the same as the alias in the `[rpc_endpoints]` section of
 * the `foundry.toml` file. For best UX, ensure the alias in the `foundry.toml` file match the
 * alias used in this contract, which can be found as the first argument to the
 * `setChainWithDefaultRpcUrl` call in the `initializeStdChains` function.
 *
 * There are two main ways to use this contract:
 *   1. Set a chain with `setChain(string memory chainAlias, ChainData memory chain)` or
 *      `setChain(string memory chainAlias, Chain memory chain)`
 *   2. Get a chain with `getChain(string memory chainAlias)` or `getChain(uint256 chainId)`.
 *
 * The first time either of those are used, chains are initialized with the default set of RPC URLs.
 * This is done in `initializeStdChains`, which uses `setChainWithDefaultRpcUrl`. Defaults are recorded in
 * `defaultRpcUrls`.
 *
 * The `setChain` function is straightforward, and it simply saves off the given chain data.
 *
 * The `getChain` methods use `getChainWithUpdatedRpcUrl` to return a chain. For example, let's say
 * we want to retrieve the RPC URL for `mainnet`:
 *   - If you have specified data with `setChain`, it will return that.
 *   - If you have configured a mainnet RPC URL in `foundry.toml`, it will return the URL, provided it
 *     is valid (e.g. a URL is specified, or an environment variable is given and exists).
 *   - If neither of the above conditions is met, the default data is returned.
 *
 * Summarizing the above, the prioritization hierarchy is `setChain` -> `foundry.toml` -> environment variable -> defaults.
 */
abstract contract StdChains {
    VmSafe private constant vm = VmSafe(address(uint160(uint256(keccak256("hevm cheat code")))));

    bool private stdChainsInitialized;

    struct ChainData {
        string name;
        uint256 chainId;
        string rpcUrl;
    }

    struct Chain {
        // The chain name.
        string name;
        // The chain's Chain ID.
        uint256 chainId;
        // The chain's alias. (i.e. what gets specified in `foundry.toml`).
        string chainAlias;
        // A default RPC endpoint for this chain.
        // NOTE: This default RPC URL is included for convenience to facilitate quick tests and
        // experimentation. Do not use this RPC URL for production test suites, CI, or other heavy
        // usage as you will be throttled and this is a disservice to others who need this endpoint.
        string rpcUrl;
    }

    // Maps from the chain's alias (matching the alias in the `foundry.toml` file) to chain data.
    mapping(string => Chain) private chains;
    // Maps from the chain's alias to it's default RPC URL.
    mapping(string => string) private defaultRpcUrls;
    // Maps from a chain ID to it's alias.
    mapping(uint256 => string) private idToAlias;

    bool private fallbackToDefaultRpcUrls = true;

    // The RPC URL will be fetched from config or defaultRpcUrls if possible.
    function getChain(string memory chainAlias) internal virtual returns (Chain memory chain) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0af10000, 1037618711281) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0af10001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0af10005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0af16000, chainAlias) }
        require(bytes(chainAlias).length != 0, "StdChains getChain(string): Chain alias cannot be the empty string.");

        initializeStdChains();
        chain = chains[chainAlias];assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00020060,0)}
        require(
            chain.chainId != 0,
            string(abi.encodePacked("StdChains getChain(string): Chain with alias \"", chainAlias, "\" not found."))
        );

        chain = getChainWithUpdatedRpcUrl(chainAlias, chain);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00020061,0)}
    }

    function getChain(uint256 chainId) internal virtual returns (Chain memory chain) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0af20000, 1037618711282) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0af20001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0af20005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0af26000, chainId) }
        require(chainId != 0, "StdChains getChain(uint256): Chain ID cannot be 0.");
        initializeStdChains();
        string memory chainAlias = idToAlias[chainId];assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0001005a,0)}

        chain = chains[chainAlias];assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00020062,0)}

        require(
            chain.chainId != 0,
            string(abi.encodePacked("StdChains getChain(uint256): Chain with ID ", vm.toString(chainId), " not found."))
        );

        chain = getChainWithUpdatedRpcUrl(chainAlias, chain);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00020063,0)}
    }

    // set chain info, with priority to argument's rpcUrl field.
    function setChain(string memory chainAlias, ChainData memory chain) internal virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0af40000, 1037618711284) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0af40001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0af40005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0af46001, chain) }
        require(
            bytes(chainAlias).length != 0,
            "StdChains setChain(string,ChainData): Chain alias cannot be the empty string."
        );

        require(chain.chainId != 0, "StdChains setChain(string,ChainData): Chain ID cannot be 0.");

        initializeStdChains();
        string memory foundAlias = idToAlias[chain.chainId];assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0001005b,0)}

        require(
            bytes(foundAlias).length == 0 || keccak256(bytes(foundAlias)) == keccak256(bytes(chainAlias)),
            string(
                abi.encodePacked(
                    "StdChains setChain(string,ChainData): Chain ID ",
                    vm.toString(chain.chainId),
                    " already used by \"",
                    foundAlias,
                    "\"."
                )
            )
        );

        uint256 oldChainId = chains[chainAlias].chainId;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0000005c,oldChainId)}
        delete idToAlias[oldChainId];

        chains[chainAlias] =
            Chain({name: chain.name, chainId: chain.chainId, chainAlias: chainAlias, rpcUrl: chain.rpcUrl});
        idToAlias[chain.chainId] = chainAlias;
    }

    // set chain info, with priority to argument's rpcUrl field.
    function setChain(string memory chainAlias, Chain memory chain) internal virtual {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0af50000, 1037618711285) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0af50001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0af50005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0af56001, chain) }
        setChain(chainAlias, ChainData({name: chain.name, chainId: chain.chainId, rpcUrl: chain.rpcUrl}));
    }

    function _toUpper(string memory str) private pure returns (string memory) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0af30000, 1037618711283) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0af30001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0af30005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0af36000, str) }
        bytes memory strb = bytes(str);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0001005d,0)}
        bytes memory copy = new bytes(strb.length);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0001005e,0)}
        for (uint256 i = 0; i < strb.length; i++) {
            bytes1 b = strb[i];assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000066,b)}
            if (b >= 0x61 && b <= 0x7A) {
                copy[i] = bytes1(uint8(b) - 32);
            } else {
                copy[i] = b;bytes1 certora_local103 = copy[i];assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000067,certora_local103)}
            }
        }
        return string(copy);
    }

    // lookup rpcUrl, in descending order of priority:
    // current -> config (foundry.toml) -> environment variable -> default
    function getChainWithUpdatedRpcUrl(string memory chainAlias, Chain memory chain)
        private
        view
        returns (Chain memory)
    {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0af60000, 1037618711286) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0af60001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0af60005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0af66001, chain) }
        if (bytes(chain.rpcUrl).length == 0) {
            try vm.rpcUrl(chainAlias) returns (string memory configRpcUrl) {
                chain.rpcUrl = configRpcUrl;
            } catch (bytes memory err) {
                string memory envName = string(abi.encodePacked(_toUpper(chainAlias), "_RPC_URL"));
                if (fallbackToDefaultRpcUrls) {
                    chain.rpcUrl = vm.envOr(envName, defaultRpcUrls[chainAlias]);
                } else {
                    chain.rpcUrl = vm.envString(envName);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00020068,0)}
                }
                // Distinguish 'not found' from 'cannot read'
                // The upstream error thrown by forge for failing cheats changed so we check both the old and new versions
                bytes memory oldNotFoundError =
                    abi.encodeWithSignature("CheatCodeError", string(abi.encodePacked("invalid rpc url ", chainAlias)));
                bytes memory newNotFoundError = abi.encodeWithSignature(
                    "CheatcodeError(string)", string(abi.encodePacked("invalid rpc url: ", chainAlias))
                );
                bytes32 errHash = keccak256(err);
                if (
                    (errHash != keccak256(oldNotFoundError) && errHash != keccak256(newNotFoundError))
                        || bytes(chain.rpcUrl).length == 0
                ) {
                    /// @solidity memory-safe-assembly
                    assembly {
                        revert(add(32, err), mload(err))
                    }
                }
            }
        }
        return chain;
    }

    function setFallbackToDefaultRpcUrls(bool useDefault) internal {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0af70000, 1037618711287) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0af70001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0af70005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0af76000, useDefault) }
        fallbackToDefaultRpcUrls = useDefault;
    }

    function initializeStdChains() private {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0af80000, 1037618711288) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0af80001, 0) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0af80004, 0) }
        if (stdChainsInitialized) return;

        stdChainsInitialized = true;

        // If adding an RPC here, make sure to test the default RPC URL in `test_Rpcs` in `StdChains.t.sol`
        setChainWithDefaultRpcUrl("anvil", ChainData("Anvil", 31337, "http://127.0.0.1:8545"));
        setChainWithDefaultRpcUrl("mainnet", ChainData("Mainnet", 1, "https://eth.llamarpc.com"));
        setChainWithDefaultRpcUrl(
            "sepolia", ChainData("Sepolia", 11155111, "https://sepolia.infura.io/v3/b9794ad1ddf84dfb8c34d6bb5dca2001")
        );
        setChainWithDefaultRpcUrl("holesky", ChainData("Holesky", 17000, "https://rpc.holesky.ethpandaops.io"));
        setChainWithDefaultRpcUrl("hoodi", ChainData("Hoodi", 560048, "https://rpc.hoodi.ethpandaops.io"));
        setChainWithDefaultRpcUrl("optimism", ChainData("Optimism", 10, "https://mainnet.optimism.io"));
        setChainWithDefaultRpcUrl(
            "optimism_sepolia", ChainData("Optimism Sepolia", 11155420, "https://sepolia.optimism.io")
        );
        setChainWithDefaultRpcUrl("arbitrum_one", ChainData("Arbitrum One", 42161, "https://arb1.arbitrum.io/rpc"));
        setChainWithDefaultRpcUrl(
            "arbitrum_one_sepolia", ChainData("Arbitrum One Sepolia", 421614, "https://sepolia-rollup.arbitrum.io/rpc")
        );
        setChainWithDefaultRpcUrl("arbitrum_nova", ChainData("Arbitrum Nova", 42170, "https://nova.arbitrum.io/rpc"));
        setChainWithDefaultRpcUrl("polygon", ChainData("Polygon", 137, "https://polygon-rpc.com"));
        setChainWithDefaultRpcUrl(
            "polygon_amoy", ChainData("Polygon Amoy", 80002, "https://rpc-amoy.polygon.technology")
        );
        setChainWithDefaultRpcUrl("avalanche", ChainData("Avalanche", 43114, "https://api.avax.network/ext/bc/C/rpc"));
        setChainWithDefaultRpcUrl(
            "avalanche_fuji", ChainData("Avalanche Fuji", 43113, "https://api.avax-test.network/ext/bc/C/rpc")
        );
        setChainWithDefaultRpcUrl(
            "bnb_smart_chain", ChainData("BNB Smart Chain", 56, "https://bsc-dataseed1.binance.org")
        );
        setChainWithDefaultRpcUrl(
            "bnb_smart_chain_testnet",
            ChainData("BNB Smart Chain Testnet", 97, "https://rpc.ankr.com/bsc_testnet_chapel")
        );
        setChainWithDefaultRpcUrl("gnosis_chain", ChainData("Gnosis Chain", 100, "https://rpc.gnosischain.com"));
        setChainWithDefaultRpcUrl("moonbeam", ChainData("Moonbeam", 1284, "https://rpc.api.moonbeam.network"));
        setChainWithDefaultRpcUrl(
            "moonriver", ChainData("Moonriver", 1285, "https://rpc.api.moonriver.moonbeam.network")
        );
        setChainWithDefaultRpcUrl("moonbase", ChainData("Moonbase", 1287, "https://rpc.testnet.moonbeam.network"));
        setChainWithDefaultRpcUrl("base_sepolia", ChainData("Base Sepolia", 84532, "https://sepolia.base.org"));
        setChainWithDefaultRpcUrl("base", ChainData("Base", 8453, "https://mainnet.base.org"));
        setChainWithDefaultRpcUrl("blast_sepolia", ChainData("Blast Sepolia", 168587773, "https://sepolia.blast.io"));
        setChainWithDefaultRpcUrl("blast", ChainData("Blast", 81457, "https://rpc.blast.io"));
        setChainWithDefaultRpcUrl("fantom_opera", ChainData("Fantom Opera", 250, "https://rpc.ankr.com/fantom/"));
        setChainWithDefaultRpcUrl(
            "fantom_opera_testnet", ChainData("Fantom Opera Testnet", 4002, "https://rpc.ankr.com/fantom_testnet/")
        );
        setChainWithDefaultRpcUrl("fraxtal", ChainData("Fraxtal", 252, "https://rpc.frax.com"));
        setChainWithDefaultRpcUrl("fraxtal_testnet", ChainData("Fraxtal Testnet", 2522, "https://rpc.testnet.frax.com"));
        setChainWithDefaultRpcUrl(
            "berachain_bartio_testnet", ChainData("Berachain bArtio Testnet", 80084, "https://bartio.rpc.berachain.com")
        );
        setChainWithDefaultRpcUrl("flare", ChainData("Flare", 14, "https://flare-api.flare.network/ext/C/rpc"));
        setChainWithDefaultRpcUrl(
            "flare_coston2", ChainData("Flare Coston2", 114, "https://coston2-api.flare.network/ext/C/rpc")
        );

        setChainWithDefaultRpcUrl("mode", ChainData("Mode", 34443, "https://mode.drpc.org"));
        setChainWithDefaultRpcUrl("mode_sepolia", ChainData("Mode Sepolia", 919, "https://sepolia.mode.network"));

        setChainWithDefaultRpcUrl("zora", ChainData("Zora", 7777777, "https://zora.drpc.org"));
        setChainWithDefaultRpcUrl(
            "zora_sepolia", ChainData("Zora Sepolia", 999999999, "https://sepolia.rpc.zora.energy")
        );

        setChainWithDefaultRpcUrl("race", ChainData("Race", 6805, "https://racemainnet.io"));
        setChainWithDefaultRpcUrl("race_sepolia", ChainData("Race Sepolia", 6806, "https://racemainnet.io"));

        setChainWithDefaultRpcUrl("metal", ChainData("Metal", 1750, "https://metall2.drpc.org"));
        setChainWithDefaultRpcUrl("metal_sepolia", ChainData("Metal Sepolia", 1740, "https://testnet.rpc.metall2.com"));

        setChainWithDefaultRpcUrl("binary", ChainData("Binary", 624, "https://rpc.zero.thebinaryholdings.com"));
        setChainWithDefaultRpcUrl(
            "binary_sepolia", ChainData("Binary Sepolia", 625, "https://rpc.zero.thebinaryholdings.com")
        );

        setChainWithDefaultRpcUrl("orderly", ChainData("Orderly", 291, "https://rpc.orderly.network"));
        setChainWithDefaultRpcUrl(
            "orderly_sepolia", ChainData("Orderly Sepolia", 4460, "https://testnet-rpc.orderly.org")
        );
    }

    // set chain info, with priority to chainAlias' rpc url in foundry.toml
    function setChainWithDefaultRpcUrl(string memory chainAlias, ChainData memory chain) private {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0af90000, 1037618711289) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0af90001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0af90005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0af96001, chain) }
        string memory rpcUrl = chain.rpcUrl;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0001005f,0)}
        defaultRpcUrls[chainAlias] = rpcUrl;
        chain.rpcUrl = "";assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00020064,0)}
        setChain(chainAlias, chain);
        chain.rpcUrl = rpcUrl;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00020065,0)} // restore argument
    }
}
