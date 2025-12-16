// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

abstract contract MurkyBase {
    /**
     *
     * CONSTRUCTOR *
     *
     */
    constructor() {}

    /**
     *
     * VIRTUAL HASHING FUNCTIONS *
     *
     */
    function hashLeafPairs(bytes32 left, bytes32 right) public pure virtual returns (bytes32 _hash);

    /**
     *
     * PROOF VERIFICATION *
     *
     */
    function verifyProof(bytes32 root, bytes32[] memory proof, bytes32 valueToProve)
        external
        pure
        virtual
        returns (bool)
    {
        // proof length must be less than max array size
        bytes32 rollingHash = valueToProve;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0000015f,rollingHash)}
        uint256 length = proof.length;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000160,length)}
        unchecked {
            for (uint256 i = 0; i < length; ++i) {
                rollingHash = hashLeafPairs(rollingHash, proof[i]);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0000016b,rollingHash)}
            }
        }
        return root == rollingHash;
    }

    /**
     *
     * PROOF GENERATION *
     *
     */
    function getRoot(bytes32[] memory data) public pure virtual returns (bytes32) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04320000, 1037618709554) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04320001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04320005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04326000, data) }
        require(data.length > 1, "won't generate root for single leaf");
        while (data.length > 1) {
            data = hashLevel(data);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00020169,0)}
        }
        return data[0];
    }

    function getProof(bytes32[] memory data, uint256 node) public pure virtual returns (bytes32[] memory) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04340000, 1037618709556) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04340001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04340005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04346001, node) }
        require(data.length > 1, "won't generate proof for single leaf");
        // The size of the proof is equal to the ceiling of log2(numLeaves)
        bytes32[] memory result = new bytes32[](log2ceilBitMagic(data.length));assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00010161,0)}
        uint256 pos = 0;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000162,pos)}

        // Two overflow risks: node, pos
        // node: max array size is 2**256-1. Largest index in the array will be 1 less than that. Also,
        // for dynamic arrays, size is limited to 2**64-1
        // pos: pos is bounded by log2(data.length), which should be less than type(uint256).max
        while (data.length > 1) {
            unchecked {
                if (node & 0x1 == 1) {
                    result[pos] = data[node - 1];
                } else if (node + 1 == data.length) {
                    result[pos] = bytes32(0);
                } else {
                    result[pos] = data[node + 1];bytes32 certora_local367 = result[pos];assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0000016f,certora_local367)}
                }
                ++pos;
                node /= 2;
            }
            data = hashLevel(data);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0002016a,0)}
        }
        return result;
    }

    ///@dev function is private to prevent unsafe data from being passed
    function hashLevel(bytes32[] memory data) private pure returns (bytes32[] memory) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04310000, 1037618709553) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04310001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04310005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04316000, data) }
        bytes32[] memory result;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00010163,0)}

        // Function is private, and all internal callers check that data.length >=2.
        // Underflow is not possible as lowest possible value for data/result index is 1
        // overflow should be safe as length is / 2 always.
        unchecked {
            uint256 length = data.length;
            if (length & 0x1 == 1) {
                result = new bytes32[](length / 2 + 1);
                result[result.length - 1] = hashLeafPairs(data[length - 1], bytes32(0));
            } else {
                result = new bytes32[](length / 2);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0002016c,0)}
            }
            // pos is upper bounded by data.length / 2, so safe even if array is at max size
            uint256 pos = 0;
            for (uint256 i = 0; i < length - 1; i += 2) {
                result[pos] = hashLeafPairs(data[i], data[i + 1]);bytes32 certora_local365 = result[pos];assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0000016d,certora_local365)}
                ++pos;
            }
        }
        return result;
    }

    /**
     *
     * MATH "LIBRARY" *
     *
     */

    /// @dev  Note that x is assumed > 0
    function log2ceil(uint256 x) public pure returns (uint256) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04330000, 1037618709555) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04330001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04330005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04336000, x) }
        uint256 ceil = 0;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000164,ceil)}
        uint256 pOf2;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000165,pOf2)}
        // If x is a power of 2, then this function will return a ceiling
        // that is 1 greater than the actual ceiling. So we need to check if
        // x is a power of 2, and subtract one from ceil if so.
        assembly {
            // we check by seeing if x == (~x + 1) & x. This applies a mask
            // to find the lowest set bit of x and then checks it for equality
            // with x. If they are equal, then x is a power of 2.

            /* Example
                x has single bit set
                x := 0000_1000
                (~x + 1) = (1111_0111) + 1 = 1111_1000
                (1111_1000 & 0000_1000) = 0000_1000 == x

                x has multiple bits set
                x := 1001_0010
                (~x + 1) = (0110_1101 + 1) = 0110_1110
                (0110_1110 & x) = 0000_0010 != x
            */

            // we do some assembly magic to treat the bool as an integer later on
            pOf2 := eq(and(add(not(x), 1), x), x)
        }

        // if x == type(uint256).max, than ceil is capped at 256
        // if x == 0, then pO2 == 0, so ceil won't underflow
        unchecked {
            while (x > 0) {
                x >>= 1;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0000016e,x)}
                ceil++;
            }
            ceil -= pOf2; // see above
        }
        return ceil;
    }

    /// Original bitmagic adapted from https://github.com/paulrberg/prb-math/blob/main/contracts/PRBMath.sol
    /// @dev Note that x assumed > 1
    function log2ceilBitMagic(uint256 x) public pure returns (uint256) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04350000, 1037618709557) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04350001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04350005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04356000, x) }
        if (x <= 1) {
            return 0;
        }
        uint256 msb = 0;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000166,msb)}
        uint256 _x = x;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000167,_x)}
        if (x >= 2 ** 128) {
            x >>= 128;
            msb += 128;
        }
        if (x >= 2 ** 64) {
            x >>= 64;
            msb += 64;
        }
        if (x >= 2 ** 32) {
            x >>= 32;
            msb += 32;
        }
        if (x >= 2 ** 16) {
            x >>= 16;
            msb += 16;
        }
        if (x >= 2 ** 8) {
            x >>= 8;
            msb += 8;
        }
        if (x >= 2 ** 4) {
            x >>= 4;
            msb += 4;
        }
        if (x >= 2 ** 2) {
            x >>= 2;
            msb += 2;
        }
        if (x >= 2 ** 1) {
            msb += 1;
        }

        uint256 lsb = (~_x + 1) & _x;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000168,lsb)}
        if ((lsb == _x) && (msb > 0)) {
            return msb;
        } else {
            return msb + 1;
        }
    }
}
