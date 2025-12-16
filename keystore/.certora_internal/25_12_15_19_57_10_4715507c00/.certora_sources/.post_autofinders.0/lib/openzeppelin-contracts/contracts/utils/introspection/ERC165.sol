// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts (last updated v5.1.0) (utils/introspection/ERC165.sol)

pragma solidity ^0.8.20;

import {IERC165} from "./IERC165.sol";

/**
 * @dev Implementation of the {IERC165} interface.
 *
 * Contracts that want to implement ERC-165 should inherit from this contract and override {supportsInterface} to check
 * for the additional interface id that will be supported. For example:
 *
 * ```solidity
 * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
 *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
 * }
 * ```
 */
abstract contract ERC165 is IERC165 {
    /**
     * @dev See {IERC165-supportsInterface}.
     */
    function supportsInterface(bytes4 interfaceId) public view virtual returns (bool) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01d20000, 1037618708946) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01d20001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01d20005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff01d26000, interfaceId) }
        return interfaceId == type(IERC165).interfaceId;
    }
}
