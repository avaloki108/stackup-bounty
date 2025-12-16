# Forwarding Address Development Commands

## Setup
```bash
forge install    # Install dependencies
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
```

## Deployment
```bash
source .env && forge script script/DeployForwardingAddressFactory.s.sol --rpc-url $ETH_RPC_URL --ledger --verify --broadcast
```

## Other
```bash
forge fmt                            # Format code
```
