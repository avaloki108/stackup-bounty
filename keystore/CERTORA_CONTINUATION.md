# Certora Testing Continuation Context

## Project: Stackup Keystore
- Path: `/home/dok/web3/stackup/keystore`
- Solidity 0.8.28, Foundry project
- Bug bounty target - Merkle tree-based config management for ERC-4337 accounts

## Architecture Summary
```
Keystore.sol (singleton) -> stores rootHash per (refHash, account)
  - handleUpdates(UpdateAction[]) - changes rootHash, increments nonce
  - validate(ValidateAction) - view, calls verifier
  - registerNode() - caches Merkle nodes

KeystoreAccount.sol - ERC-4337 account using Keystore for validation
Verifiers (UserOpECDSAVerifier, MultiSig, WebAuthn) - stateless sig verification
```

## Key State Variables
- `_rootHash[refHash][account]` - current root (defaults to refHash if 0)
- `_nonceSequence[refHash][key][account]` - 64-bit sequence per 192-bit key
- `_nodeCache[rootHash][nodeHash][account]` - cached Merkle nodes

## Message Hash Structure (critical for domain separation)
```solidity
// useChainId=true:
keccak256(abi.encode(refHash, nextHash, account, nonce, nodeHash, keccak256(nextNode), chainid))

// useChainId=false (cross-chain replay allowed by design):
keccak256(abi.encode(refHash, nextHash, account, nonce, nodeHash, keccak256(nextNode)))
```

## Files Created

### 1. CVL Spec: `cvl/keystore.cvl`
- 12 rules targeting: nonce monotonicity, root hash integrity, state isolation, verifier validity
- Uses method summaries for external calls
- Submitted to Certora: https://prover.certora.com/output/10398964/1824e736dad840d3a206af19599449d9

### 2. Foundry Invariant Tests: `test/invariant/KeystoreInvariant.t.sol`
- 8 invariants, ALL PASSING with 128K+ calls each:
  - invariant_nonceCanOnlyIncrease
  - invariant_nonceIncrementsCorrectly
  - invariant_stateIsolation
  - invariant_refHashIsolation
  - invariant_rootHashNeverZero
  - invariant_rootHashOnlyChangesViaHandleUpdates
  - invariant_noZeroVerifierNodes
  - invariant_nonceKeyIndependence

### 3. Adversarial Tests: `test/invariant/KeystoreAdversarial.t.sol`
- Handler with hostile verifiers
- Tests: revert=no state change, verifier reject=no nonce increment, reentrancy protection, batch atomicity
- **NEEDS FIX**: Verifier mocks must be `view` (IVerifier.validateData is view)

### 4. Adversarial Verifiers: `test/mock/AdversarialVerifiers.sol`
- AlwaysSuccessVerifier, AlwaysFailVerifier, CalldataLengthVerifier, RevertingVerifier
- GasGriefingVerifier, ReentrantVerifier (partially fixed to view)
- **INCOMPLETE**: StatefulVerifier still needs view fix

### 5. ECDSA Edge Cases: `test/invariant/ECDSAEdgeCases.t.sol`
- Domain separation tests (refHash, account, nonce, nextHash, nodeHash all committed)
- Signature malleability (Solady rejects high s)
- Cross-chain replay documentation (useChainId=false is intentional)
- Compiles and passes

### 6. Merkle Proof Tests: `test/invariant/MerkleProofEdgeCases.t.sol`
- Bit flip, sibling swap, truncated/extended proof rejection
- Proof-for-A-cannot-validate-B
- Node cache isolation
- Compiles and passes

### 7. Config: `certora.conf`
```json
{
    "files": ["src/core/Keystore.sol"],
    "verify": "Keystore:cvl/keystore.cvl",
    "packages": [
        "@openzeppelin/contracts=lib/openzeppelin-contracts/contracts",
        "account-abstraction=lib/account-abstraction/contracts",
        "solady=lib/solady/src"
    ]
}
```

### 8. Remappings: `remappings.txt` (generated from forge remappings)

## TODO - Immediate Fixes Needed

1. **Fix AdversarialVerifiers.sol** - StatefulVerifier needs view:
```solidity
// Change from:
function validateData(...) external returns (uint256) {
    callCount++;
// To view-compatible version (can't actually be stateful in view)
```

2. **Run tests after fix**:
```bash
forge test --match-path "test/invariant/*.sol" -vv
```

3. **Run Certora focused on Keystore only**:
```bash
source .env && certoraRun certora.conf --wait_for_results
```

## Critical Invariants to Prove (Bounty-Grade)

1. **Nonce monotonicity** - nonces only increase, never reset ($100K+ replay)
2. **State isolation** - account A cannot affect account B ($200K+ auth bypass)
3. **Root hash integrity** - only handleUpdates can change it ($200K+ sig bypass)
4. **Verifier non-zero** - zero verifier = anyone can sign ($200K+ auth bypass)
5. **Revert atomicity** - if handleUpdates reverts, no state changes
6. **Verifier reject** - if verifier returns FAILED, nonce must NOT increment

## Cross-Chain Replay Analysis

When `useChainId=false`:
- Replay IS allowed by design (cross-chain sync feature)
- Protection: refHash + account + nonce (per-chain nonce sequences)
- NOT a vulnerability unless nonces can somehow be shared across chains

## Certora Job Status
- Job URL: https://prover.certora.com/output/10398964/1824e736dad840d3a206af19599449d9
- Need to check results for pass/fail/vacuous rules
- If vacuous: add satisfy statements
- If failing: reproduce in Foundry

## Commands
```bash
# Compile
forge build

# Run invariant tests
forge test --match-contract KeystoreInvariant -vv
forge test --match-contract KeystoreAdversarial -vv
forge test --match-contract ECDSAEdgeCases -vv
forge test --match-contract MerkleProofEdgeCases -vv

# Certora
source .env && certoraRun certora.conf --wait_for_results
```

## Key Code Locations
- Keystore core: `src/core/Keystore.sol:35` (handleUpdates), `:62` (validate), `:69` (registerNode)
- Message hash: `src/core/Keystore.sol:150` (_getUpdateActionHash)
- Nonce logic: `src/core/Keystore.sol:100-116`
- ECDSA verifier: `src/verifier/UserOpECDSAVerifier.sol:28-44`
- Merkle proof: uses Solady MerkleProofLib

## Next Steps After Fix
1. Fix StatefulVerifier to be view-compatible (or remove - can't have stateful view)
2. Run all invariant tests
3. Check Certora job results
4. Align CVL rules 1:1 with Foundry invariants
5. Add explicit negative testing for verifier edge cases
6. Focus on "weird + specific" for bounty: verifier edge behavior, config footguns
