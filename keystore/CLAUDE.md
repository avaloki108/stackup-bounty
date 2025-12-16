# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Build & Test Commands

```bash
forge install          # Install Foundry dependencies
npm install            # Install npm dependencies (for TypeScript examples)
forge build            # Compile contracts
forge test             # Run all tests
forge test --mt <name> # Run specific test by name
forge test -vvv        # Verbose with stack traces
```

Example scripts:
```bash
npm run examples:verify-ucmt  # Generate and verify a User Configuration Merkle Tree
```

## Architecture

### Protocol Overview

The Keystore is a Merkle tree-based configuration management system for ERC-4337 smart accounts. It solves three problems: gas cost of storing complex account configurations, cross-chain configuration sync, and privacy of configuration details (e.g., guardian sets).

### Core Components

```
src/
├── core/Keystore.sol           # Singleton storing root hashes, handles updates & validation
├── account/
│   ├── KeystoreAccount.sol     # ERC-4337 account using Keystore for validation
│   └── KeystoreAccountFactory.sol
├── verifier/                   # Stateless signature verification contracts
│   ├── UserOpECDSAVerifier.sol
│   ├── UserOpMultiSigVerifier.sol
│   ├── UserOpWebAuthnVerifier.sol
│   └── UserOpWebAuthnCosignVerifier.sol
├── interface/
│   ├── IKeystore.sol
│   └── IVerifier.sol
└── lib/
    ├── Actions.sol             # UpdateAction, ValidateAction structs
    ├── KeystoreUserOperation.sol
    └── OnlyKeystore.sol        # Access control modifier for verifiers
```

### Key Concepts

- **User Configuration Merkle Tree (UCMT)**: Each node is `abi.encodePacked(verifier, config)` - 20 bytes verifier address + arbitrary config bytes. Only the root hash is stored onchain.
- **refHash**: Permanent reference to a user's configuration, used for deterministic account addresses. Never changes.
- **rootHash**: Current Merkle root, updated via `handleUpdates()`. Initially equals refHash.
- **2D Nonce**: `uint192 key | uint64 sequence` - enables cross-chain replay of updates without sequence conflicts.

### Validation Flow

1. Account calls `Keystore.validate(ValidateAction)`
2. Keystore verifies Merkle proof (or uses cached node if proof is empty)
3. Keystore extracts verifier address from node and calls `IVerifier.validateData(message, data, config)`
4. Verifier returns `SIG_VALIDATION_SUCCESS` (0) or `SIG_VALIDATION_FAILED` (1)

### Update Flow

1. Caller invokes `Keystore.handleUpdates(UpdateAction[])`
2. For each action: validate nonce, verify Merkle proof, call verifier
3. Verify next root hash has at least one accessible node (anti-bricking mechanism)
4. Update `_rootHash[refHash][account]` and increment nonce

## Code Style

- Solidity 0.8.28, optimizer 1,000,000 runs
- Internal functions: `_prefixed`
- Immutable storage: `_prefixed`
- Constructor params: `aParam` prefix when matching storage names
- Fuzz tests: `testFuzz_` prefix
- Uses Solady for gas efficiency (LibBytes, MerkleProofLib, ECDSA, WebAuthn)
- ReentrancyGuardTransient for state-modifying external calls

## Key Files for Security Review

**Critical paths:**
- `Keystore.handleUpdates()` - Root hash updates with Merkle proof verification
- `Keystore.validate()` - Transaction validation entry point
- `Keystore._fetchOrValidateNode()` - Cache vs proof validation logic (empty proof = use cache)
- `KeystoreAccount._validateSignature()` - ERC-4337 signature handling

## Specification

Full protocol specification: `doc/spec.md`
