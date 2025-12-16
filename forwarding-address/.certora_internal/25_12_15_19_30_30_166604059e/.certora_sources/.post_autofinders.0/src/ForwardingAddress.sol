// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {SafeERC20} from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import {ReentrancyGuardTransient} from "@openzeppelin/contracts/utils/ReentrancyGuardTransient.sol";
import {Initializable} from "solady/utils/Initializable.sol";

contract ForwardingAddress is ReentrancyGuardTransient, Initializable {
    using SafeERC20 for IERC20;

    error FailedETHWithdraw(address receiver, address token);

    address payable public receiver;

    receive() external payable {}

    constructor() {
        _disableInitializers();
    }

    function initialize(address payable aReceiver) public logInternal1(aReceiver)initializer {
        receiver = aReceiver;
    }modifier logInternal1(address payable aReceiver) { assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00010000, 1037618708481) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00010001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00010005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00016000, aReceiver) } _; }

    function sweep(address token) public logInternal0(token)nonReentrant {
        if (token == address(0)) {
            (bool success,) = receiver.call{value: address(this).balance}("");
            require(success, FailedETHWithdraw(receiver, token));
        } else {
            IERC20(token).safeTransfer(receiver, IERC20(token).balanceOf(address(this)));
        }
    }modifier logInternal0(address token) { assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00000000, 1037618708480) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00000001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00000005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00006000, token) } _; }
}
