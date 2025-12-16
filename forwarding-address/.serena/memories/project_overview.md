# Forwarding Address Project Overview

## Purpose
A lightweight protocol for payment attribution through deterministically generated addresses. Solves the challenge of linking incoming on-chain payments to users without requiring:
- Controlled frontend with off-chain authentication
- Users submitting sending addresses ahead of time

## Key Components
- **ForwardingAddress.sol**: Minimal proxy contract that receives payments and sweeps them to a designated receiver
- **ForwardingAddressFactory.sol**: Factory creating deterministic forwarding addresses via CREATE2

## How It Works
1. Factory generates counterfactual addresses tied to a (receiver, salt) pair
2. Users send payments to the forwarding address (even before deployment)
3. Anyone can call `sweepFor()` to deploy and sweep funds to the receiver
4. Supports ETH and ERC20 tokens

## Tech Stack
- Solidity 0.8.28
- Foundry (forge)
- Dependencies: OpenZeppelin (ERC20, SafeERC20, ReentrancyGuard), Solady (LibClone, Initializable)
