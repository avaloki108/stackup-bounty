# Stackup Protocol Security Audit Report

**Date:** December 15, 2025
**Scope:** Keystore Protocol + ForwardingAddress Protocol
**Auditor:** Claude Code Security Pipeline
**Bug Bounty:** Cantina - Max $100K Critical, $25K High, $5K Medium

---

## Executive Summary

This comprehensive security audit analyzed the Stackup Keystore and ForwardingAddress protocols using multiple specialized analysis agents, static analysis tools (Slither), and manual code review. The protocols demonstrate solid security architecture with proper reentrancy guards, access controls, and cryptographic validation.

**Overall Assessment:** The codebase is well-designed with no Critical or High severity vulnerabilities identified in the in-scope contracts. Several Medium/Low/Informational findings are documented below.

---

## Scope

### Keystore Protocol (`/home/dok/web3/stackup/keystore/src/`)
| Contract | Lines | Description |
|----------|-------|-------------|
| `core/Keystore.sol` | 181 | Singleton managing root hashes and validation |
| `account/KeystoreAccount.sol` | 97 | ERC-4337 account using Keystore |
| `account/KeystoreAccountFactory.sol` | 57 | CREATE2 factory for accounts |
| `verifier/UserOpECDSAVerifier.sol` | 46 | ECDSA signature verification |
| `verifier/UserOpMultiSigVerifier.sol` | 95 | Multi-signature verification |
| `verifier/UserOpWebAuthnVerifier.sol` | 54 | WebAuthn verification |
| `verifier/UserOpWebAuthnCosignVerifier.sol` | 68 | WebAuthn + ECDSA cosigner |

### ForwardingAddress Protocol (`/home/dok/web3/stackup/forwarding-address/src/`)
| Contract | Lines | Description |
|----------|-------|-------------|
| `ForwardingAddress.sol` | 34 | Receives and sweeps funds |
| `ForwardingAddressFactory.sol` | 40 | CREATE2 factory with sweepFor |

---

## Tools Used

- **Slither** - Static analysis (reentrancy, access control, etc.)
- **Mythril** - Symbolic execution (connection issues encountered)
- **Manual Review** - 5 specialized security agents
- **Slither Printers** - Function summary, vars-and-auth analysis

---

## Findings Summary

| Severity | Count | Description |
|----------|-------|-------------|
| Critical | 0 | - |
| High | 0 | - |
| Medium | 1 | Locked ETH in ForwardingAddress |
| Low | 4 | Various edge cases |
| Informational | 8 | Design considerations |

---

## Detailed Findings

### [M-01] Permanently Locked ETH in ForwardingAddress

**Severity:** Medium
**Impact:** High (permanent fund loss possible)
**Likelihood:** Low (requires user error)
**File:** `forwarding-address/src/ForwardingAddress.sol:22-28`

**Description:**
The `receiver` address is set immutably during initialization. If the receiver is a contract that:
1. Was deployed without a receive/fallback function
2. Later upgrades to reject ETH (if upgradeable)
3. Gets blacklisted or paused

ETH sent to the ForwardingAddress becomes permanently unrecoverable.

```solidity
function initialize(address payable aReceiver) public initializer {
    receiver = aReceiver;  // No zero-check, immutable after init
}

function sweep(address token) public nonReentrant {
    if (token == address(0)) {
        (bool success,) = receiver.call{value: address(this).balance}("");
        require(success, FailedETHWithdraw(receiver, token));
    }
    // ...
}
```

**Proof of Concept:**
```solidity
contract NonPayableReceiver {}

ForwardingAddress fa = factory.createForwardingAddress(
    payable(address(new NonPayableReceiver())),
    salt
);
payable(address(fa)).transfer(1 ether);
fa.sweep(address(0)); // REVERTS - ETH locked forever
```

**Recommendation:**
- Add zero-address check in `initialize()`
- Consider time-locked emergency withdrawal mechanism
- Document risk prominently for integrators

---

### [L-01] MultiSig Verifier Index Out of Bounds Revert

**Severity:** Low
**File:** `keystore/src/verifier/UserOpMultiSigVerifier.sol:73-84`

**Description:**
If a malformed signature contains `SignerData.index >= owners.length`, the transaction reverts with array out-of-bounds instead of returning `SIG_VALIDATION_FAILED`. This is a griefing vector where bundlers waste gas.

```solidity
bool[] memory seen = new bool[](owners.length);
for (uint256 i = 0; i < length; i++) {
    SignerData memory sd = signatures[i];
    // If sd.index >= owners.length, this reverts
    !seen[sd.index] && owners[sd.index] == ECDSA.recover(...) ? sc.valid++ : sc.invalid++;
    seen[sd.index] = true;
}
```

**Recommendation:**
Add bounds check: `if (sd.index >= owners.length) { sc.invalid++; continue; }`

---

### [L-02] Missing Zero-Check on Receiver Initialization

**Severity:** Low
**File:** `forwarding-address/src/ForwardingAddress.sol:22-23`

**Description:**
The `initialize()` function accepts address(0) as receiver, which would cause all ETH sweeps to fail.

**Recommendation:**
Add: `require(aReceiver != address(0), "Invalid receiver");`

---

### [L-03] sweepFor() Unbounded Loop

**Severity:** Low
**File:** `forwarding-address/src/ForwardingAddressFactory.sol:34-38`

**Description:**
No upper bound on `tokens.length`. Very large arrays cause out-of-gas reverts.

**Recommendation:**
Document recommended batch sizes (50-100 tokens max).

---

### [L-04] Single Token Failure Blocks Batch

**Severity:** Low
**File:** `forwarding-address/src/ForwardingAddressFactory.sol:36-38`

**Description:**
If any token in the `tokens[]` array reverts during sweep, the entire `sweepFor` transaction fails.

**Recommendation:**
Consider try/catch per-token, or document to sweep problematic tokens separately.

---

### [I-01] Cross-Chain Replay by Design

**Severity:** Informational
**File:** `keystore/src/core/Keystore.sol:155-172`

**Description:**
When `useChainId=false`, UpdateAction signatures are intentionally replayable across chains. This is documented in the specification but could lead to stale configuration replay.

**Scenario:**
1. User updates chain A: C1 -> C2 (nonce=0 consumed)
2. User updates chain A: C2 -> C3 (removing compromised key)
3. Chain B still at nonce=0
4. Attacker replays first update on chain B, restoring C2

**Recommendation:**
Consider adding `cancelNonce()` function for emergency nonce invalidation.

---

### [I-02] Signature Malleability Not Checked

**Severity:** Informational
**File:** Solady ECDSA library

**Description:**
Solady's ECDSA does not check signature malleability. Mitigated by nonce mechanisms but could affect signature-based indexing systems.

**Recommendation:**
Use `ECDSA.canonicalHash()` for any signature-based indexing.

---

### [I-03] Node Registration Before Validation Success

**Severity:** Informational
**File:** `keystore/src/account/KeystoreAccount.sol:54-63`

**Description:**
Nodes are registered in cache before signature validation completes. If validation fails, the node remains cached (wastes gas, no security impact).

---

### [I-04] External Calls in handleUpdates Loop

**Severity:** Informational
**File:** `keystore/src/core/Keystore.sol:47,51`

**Description:**
External verifier calls in loop. Protected by `nonReentrant` modifier - by design.

---

### [I-05] Fee-on-Transfer Token Behavior

**Severity:** Informational
**File:** `forwarding-address/src/ForwardingAddress.sol:31`

**Description:**
For fee-on-transfer tokens, receiver gets `balance - fee`, not full balance. Works correctly but receiver gets less than expected.

---

### [I-06] Rebasing Token Edge Case

**Severity:** Informational

**Description:**
Rebasing tokens (stETH, aTokens) can have balance changes between transaction submission and execution.

---

### [I-07] Zero Balance Sweeps

**Severity:** Informational
**File:** `forwarding-address/src/ForwardingAddress.sol:26-31`

**Description:**
Sweeping when balance is zero succeeds but wastes gas.

---

### [I-08] handleUpdates Batch Atomicity

**Severity:** Informational
**File:** `keystore/src/core/Keystore.sol:35-60`

**Description:**
Hard failures (InvalidNonce, InvalidProof) revert entire batch, while soft failures (SIG_VALIDATION_FAILED) continue processing. Subtle behavior for integrators.

---

## Security Model Analysis

### Access Control
| Function | Access | Status |
|----------|--------|--------|
| `Keystore.handleUpdates()` | Public (signature-gated) | SECURE |
| `Keystore.validate()` | Public (view, msg.sender scoped) | SECURE |
| `Keystore.registerNode()` | Public (msg.sender scoped) | SECURE |
| `Verifiers.validateData()` | OnlyKeystore | SECURE |
| `KeystoreAccountFactory.createAccount()` | SenderCreator only | SECURE |
| `ForwardingAddress.sweep()` | Public (funds to receiver) | SECURE |

### Reentrancy Protection
| Contract | Mechanism | Status |
|----------|-----------|--------|
| Keystore | ReentrancyGuardTransient | PROTECTED |
| ForwardingAddress | ReentrancyGuardTransient | PROTECTED |
| ForwardingAddressFactory | ReentrancyGuardTransient | PROTECTED |

### Initialization Protection
| Contract | Mechanism | Status |
|----------|-----------|--------|
| KeystoreAccount | Solady Initializable + _disableInitializers() | PROTECTED |
| ForwardingAddress | Solady Initializable + _disableInitializers() | PROTECTED |

### Replay Protection
| Mechanism | Implementation | Status |
|-----------|----------------|--------|
| Nonces | 2D nonce (uint192 key + uint64 seq) | PROTECTED |
| Chain binding | Optional via useChainId flag | BY DESIGN |
| ERC-4337 | userOpHash includes chainId | PROTECTED |

---

## Slither Results

### Keystore Project
- **arbitrary-send-eth** in BaseAccount._payPrefund - FALSE POSITIVE (dependency, expected behavior)
- No issues in in-scope contracts

### ForwardingAddress Project
- **arbitrary-send-eth** in ForwardingAddress.sweep - FALSE POSITIVE (intended behavior, sends to receiver)
- **missing-zero-check** on receiver - VALID (documented as L-02)

---

## Storage Layout Analysis

### KeystoreAccount
| Slot | Variable | Type |
|------|----------|------|
| 0 | refHash | bytes32 |
| Special | Solady Initializable | Collision-resistant slot |

### ForwardingAddress
| Slot | Variable | Type |
|------|----------|------|
| 0 | receiver | address payable |
| Special | Solady Initializable | Collision-resistant slot |

**Storage Collisions:** None detected

---

## Recommendations

### High Priority
1. Add zero-address check in ForwardingAddress.initialize()
2. Document receiver contract requirements (must accept ETH)

### Medium Priority
1. Add bounds check in MultiSig verifier for index validation
2. Document batch size limits for sweepFor()
3. Consider nonce cancellation function

### Low Priority
1. Add balance check before zero-balance sweeps (gas optimization)
2. Document fee-on-transfer and rebasing token behaviors
3. Document handleUpdates batch atomicity behavior

---

## Conclusion

The Stackup Keystore and ForwardingAddress protocols demonstrate mature security design with:
- Proper cryptographic authorization (Merkle proofs + signatures)
- Comprehensive reentrancy protection (transient storage guards)
- Correct initialization patterns (Solady Initializable)
- Non-upgradeable proxy pattern (ERC-1167)

No fund theft, signature bypass, or authorization bypass vulnerabilities were identified. The single Medium severity finding (locked ETH) requires user error to trigger and primarily affects protocol usability rather than security.

**Bounty Assessment:**
- Critical ($100K): 0 findings
- High ($25K): 0 findings
- Medium ($5K): 1 finding (M-01)
- Low/Informational: 12 findings

---

*Report generated by Claude Code Security Pipeline*
