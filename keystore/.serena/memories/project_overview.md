# Keystore Project Overview

## Purpose
Keystore is a Merkle tree-based configuration management system for ERC-4337 smart accounts. It enables:
- Gas-efficient storage of account configuration (only root hash stored on-chain)
- Privacy-preserving verification (full config kept off-chain)
- Cross-chain configuration sync
- Arbitrary verification schemes via pluggable Verifiers

## Key Components
- **Keystore.sol** (core/): Singleton contract storing root hashes, handling updates and validation
- **KeystoreAccount.sol** (account/): ERC-4337 compatible account using Keystore for validation
- **KeystoreAccountFactory.sol** (account/): Factory for deterministic account deployment
- **Verifiers** (verifier/): ECDSA, MultiSig, WebAuthn, WebAuthnCosign verification contracts

## Architecture
```
UserConfiguration Merkle Tree (UCMT)
         |
    [Root Hash] --stored in--> Keystore Singleton
         |
    Verifier (stateless, validates signatures)
         |
    KeystoreAccount (ERC-4337 account)
```

## Tech Stack
- Solidity 0.8.28
- Foundry (forge, cast)
- Node.js/TypeScript for example scripts
- Dependencies: OpenZeppelin, Solady, account-abstraction (ERC-4337)
