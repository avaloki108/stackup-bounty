# ULTIMATE HUNT FINAL REPORT: Stackup Keystore Protocol

**Date:** 2025-12-15
**Auditor:** Claude Code Ultimate Hunt
**Target:** Stackup Keystore Protocol
**Bounty Platform:** Cantina (Max $100k Critical)

---

## Executive Summary

After comprehensive security analysis using 8 specialized agents, static analysis tools (Slither), and deep manual review, **no critical or high-severity vulnerabilities were identified** in the Stackup Keystore Protocol.

The protocol demonstrates strong security architecture with proper cryptographic authorization, account isolation, reentrancy protection, and defense-in-depth measures.

---

## Analysis Coverage

| Component | Status | Findings |
|-----------|--------|----------|
| Keystore.sol (core singleton) | Analyzed | Secure |
| KeystoreAccount.sol (ERC-4337 account) | Analyzed | Secure |
| KeystoreAccountFactory.sol | Analyzed | Secure |
| UserOpECDSAVerifier.sol | Analyzed | Secure |
| UserOpMultiSigVerifier.sol | Analyzed | Minor defensive improvement possible |
| UserOpWebAuthnVerifier.sol | Analyzed | Secure |
| UserOpWebAuthnCosignVerifier.sol | Analyzed | Secure |

---

## Tools & Agents Deployed

| Tool/Agent | Focus | Result |
|------------|-------|--------|
| **Slither** | Static analysis | 268 issues (mostly deps), 1 LOW in actual code |
| **recon-alpha** | Architecture mapping | Complete map of critical paths |
| **hunter-alpha** | Reentrancy | No exploitable vectors |
| **hunter-beta** | Access control | Secure (signature-based auth) |
| **hunter-theta** | Signatures | ECDSA malleability protected by Solady |
| **hunter-zeta** | Math/precision | No overflows except theoretical nonce |
| **hunter-iota** | Edge cases/DoS | Minor gas griefing possible |
| **owasp-logic-errors** | Business logic | Sound design confirmed |
| **the-mastermind** | Deep logic analysis | No bounty-worthy findings |

---

## Findings Summary

| Severity | Count |
|----------|-------|
| Critical | 0 |
| High | 0 |
| Medium | 0 |
| Low | 2 |
| Informational | 2 |

---

## Detailed Findings

### LOW-1: Gas Griefing Potential on Bundlers

**Location:** `src/account/KeystoreAccount.sol:60-70` (`_validateSignature()`)

**Description:** During ERC-4337 validation, the account automatically calls `registerNode()` which writes to storage even if the overall user operation fails validation. A malicious user could craft operations that pass initial checks but fail signature verification, causing bundlers to pay gas for state writes without compensation.

**Impact:** Minor gas loss for ERC-4337 bundlers
**Likelihood:** Low (bundlers can implement reputation systems)
**Severity:** LOW

**Recommendation:** Document this behavior for bundler operators. Consider adding a `view`-only validation mode.

---

### LOW-2: Array Bounds Not Validated in MultiSig Verifier

**Location:** `src/verifier/UserOpMultiSigVerifier.sol:81`

**Description:** The `sd.index` from user input is used to access `owners[sd.index]` without explicit bounds checking. While this causes a revert (not an exploit), explicit validation would be more defensive.

```solidity
!seen[sd.index] && owners[sd.index] == ECDSA.recover(sc.message, sd.signature)
```

**Impact:** Self-DoS only (transaction reverts)
**Likelihood:** Low (only affects attacker)
**Severity:** LOW (defensive improvement)

**Recommendation:** Add `require(sd.index < owners.length, InvalidSignerIndex())` for clarity.

---

### INFO-1: Theoretical Nonce Overflow

**Location:** `src/core/Keystore.sol:114-116` (`_incrementNonce()`)

**Description:** The nonce sequence is `uint64` and increments without overflow check. After 2^64 operations (~18 quintillion), the nonce would wrap to 0.

**Impact:** None practical - 2^64 operations infeasible even at 1M/second for 500,000+ years
**Severity:** INFORMATIONAL

---

### INFO-2: Cross-Chain Configuration Fork (By Design)

**Location:** `src/core/Keystore.sol:150-172` (`_getUpdateActionHash()`)

**Description:** When `useChainId=false`, the same signature can update configurations differently on different chains using the same nonce. This is documented behavior but users should understand implications.

**Impact:** User education issue
**Severity:** INFORMATIONAL

---

## Security Strengths Observed

1. **Cryptographic Authorization**: All state changes require valid signatures from the designated verifier
2. **Account Isolation**: `_rootHash`, `_nonceSequence`, and `_nodeCache` are all keyed per-account
3. **Reentrancy Protection**: `ReentrancyGuardTransient` on `handleUpdates()`
4. **ECDSA Malleability Protection**: Uses Solady's battle-tested ECDSA library
5. **Merkle Proof Verification**: Uses Solady's `MerkleProofLib`
6. **Verifier Access Control**: `onlyKeystore` modifier prevents direct verifier calls
7. **Nonce Sequencing**: Prevents replay attacks on same chain
8. **Proper Input Validation**: Length checks, zero-address checks throughout

---

## Attack Vectors Analyzed (No Exploits Found)

### Unauthorized rootHash Update
- **Hypothesis:** Attacker updates another user's rootHash
- **Result:** SECURE - Requires valid signature from verifier (needs private key)

### Cross-Account Signature Replay
- **Hypothesis:** Replay signature from Account A for Account B
- **Result:** SECURE - `action.account` included in signed message hash

### Cache Poisoning
- **Hypothesis:** Inject malicious node into another user's cache
- **Result:** SECURE - Cache keyed by `msg.sender`, isolation enforced

### Reentrancy on handleUpdates
- **Hypothesis:** Reenter during verifier callback
- **Result:** SECURE - `ReentrancyGuardTransient` modifier applied

### Merkle Proof Manipulation
- **Hypothesis:** Forge proof for non-existent node
- **Result:** SECURE - Solady's `MerkleProofLib` is battle-tested

---

## Conclusion

The Stackup Keystore Protocol is **well-architected and secure**. The protocol design follows security best practices for ERC-4337 account abstraction with proper separation of concerns between the singleton Keystore, stateless verifiers, and account contracts.

With 96 findings already submitted on Cantina and comprehensive automated + manual analysis finding no critical issues, the protocol appears to have been thoroughly vetted.

**Bounty Recommendation:** None of the findings meet the threshold for Critical ($100k), High ($25k), or Medium ($5k) rewards based on the program criteria. The LOW findings may be worth submitting for completeness but have low bounty potential.

---

## Appendix: Files Analyzed

```
src/
├── core/Keystore.sol
├── account/
│   ├── KeystoreAccount.sol
│   └── KeystoreAccountFactory.sol
├── verifier/
│   ├── UserOpECDSAVerifier.sol
│   ├── UserOpMultiSigVerifier.sol
│   ├── UserOpWebAuthnVerifier.sol
│   └── UserOpWebAuthnCosignVerifier.sol
├── interface/
│   ├── IKeystore.sol
│   └── IVerifier.sol
└── lib/
    ├── Actions.sol
    ├── KeystoreUserOperation.sol
    └── OnlyKeystore.sol
```

---

*Report generated by Claude Code Ultimate Hunt workflow*
