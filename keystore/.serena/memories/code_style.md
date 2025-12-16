# Keystore Code Style and Conventions

## Solidity
- Version: 0.8.28
- Optimizer: enabled with 1,000,000 runs
- SPDX License: MIT

## Naming
- Contracts: PascalCase (e.g., `KeystoreAccount`, `UserOpECDSAVerifier`)
- Functions: camelCase
- Internal functions: prefixed with underscore (e.g., `_unpackNode`, `_getCurrentRootHash`)
- Immutable variables: prefixed with underscore (e.g., `_entryPoint`, `_keystore`)
- Function parameters: prefixed with 'a' when matching storage (e.g., `aRefHash`, `aKeystore`)
- Constants: UPPER_SNAKE_CASE (e.g., `NODE_VERIFIER_LENGTH`)

## Patterns
- ReentrancyGuardTransient for state-modifying external calls
- Initializable pattern for proxy-compatible contracts
- ERC-4337 validation returns `SIG_VALIDATION_SUCCESS` (0) or `SIG_VALIDATION_FAILED` (1)
- Use Solady libraries for gas efficiency (LibBytes, MerkleProofLib, ECDSA, WebAuthn)

## Testing
- Fuzz testing with `testFuzz_` prefix
- Use Murky library for Merkle tree operations in tests
- Mock contracts in `test/mock/` directory
