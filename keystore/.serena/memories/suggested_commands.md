# Keystore Development Commands

## Setup
```bash
forge install    # Install Solidity dependencies
npm install      # Install Node.js dependencies
```

## Build
```bash
forge build
```

## Testing
```bash
forge test                           # Run all tests
forge test --mt testFunctionName     # Run specific test
forge test -vvv                      # Verbose output with traces
forge test --gas-report              # Include gas report
```

## Example Scripts
```bash
npm run examples:verify-ucmt         # Generate and verify a UCMT
```

## Deployment
```bash
source .env && forge script script/DeployKeystore.s.sol --rpc-url $ETH_RPC_URL --ledger --verify --broadcast
source .env && forge script script/DeployKeystoreAccountFactory.s.sol --rpc-url $ETH_RPC_URL --ledger --verify --broadcast
```

## Other
```bash
forge fmt                            # Format Solidity code
forge snapshot                       # Generate gas snapshot
```
