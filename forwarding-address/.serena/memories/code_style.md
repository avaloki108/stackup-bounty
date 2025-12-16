# Forwarding Address Code Style

## Solidity
- Version: 0.8.28
- Optimizer: enabled with 1,000,000 runs
- SPDX License: MIT

## Patterns
- ReentrancyGuardTransient for external calls
- Initializable for proxy pattern
- SafeERC20 for token transfers
- LibClone for minimal proxy deployment

## Testing
- Fuzz testing with `testFuzz_` prefix
- Test various ERC20 edge cases (no return, false return)
