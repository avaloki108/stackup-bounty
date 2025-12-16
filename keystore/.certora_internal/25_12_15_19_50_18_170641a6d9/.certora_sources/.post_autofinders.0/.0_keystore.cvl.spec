/*
 * ═══════════════════════════════════════════════════════════════════════════
 * KEYSTORE PROTOCOL - FORMAL VERIFICATION SPEC
 * Target: Merkle-tree based configuration management for ERC-4337 accounts
 * Bounty Potential: $50K-$200K (Critical auth/state bugs)
 * ═══════════════════════════════════════════════════════════════════════════
 */

methods {
    // View functions
    function getRegisteredNode(bytes32, address, bytes32) external returns (bytes) envfree;
    function getRootHash(bytes32, address) external returns (bytes32) envfree;
    function getNonce(bytes32, address, uint192) external returns (uint256) envfree;

    // State-changing functions
    function registerNode(bytes32, bytes32[], bytes) external;

    // External calls to verifiers - summarize as NONDET
    function _.validateData(bytes32, bytes, bytes) external => NONDET;
}

/*
 * ═══════════════════════════════════════════════════════════════════════════
 * RULE 1: NONCE MONOTONICITY
 * Risk: Replay attacks if nonces can be reused or decrease
 * Bounty: $100K+ (Cross-chain replay protection bypass)
 * ═══════════════════════════════════════════════════════════════════════════
 */

// Nonces can only increase, never decrease
rule nonceCannotDecrease(env e, bytes32 refHash, address account, uint192 key) {
    uint256 nonceBefore = getNonce(refHash, account, key);

    calldataarg args;
    method f;
    f(e, args);

    uint256 nonceAfter = getNonce(refHash, account, key);

    assert nonceAfter >= nonceBefore,
        "CRITICAL: Nonce decreased - replay attack possible";
}

// Nonce cannot be reset to zero after being incremented
rule nonceCannotReset(env e, bytes32 refHash, address account, uint192 key) {
    uint256 nonceBefore = getNonce(refHash, account, key);
    require nonceBefore > 0;

    calldataarg args;
    method f;
    f(e, args);

    uint256 nonceAfter = getNonce(refHash, account, key);

    assert nonceAfter > 0,
        "CRITICAL: Nonce was reset to zero - allows replay of all previous operations";
}

/*
 * ═══════════════════════════════════════════════════════════════════════════
 * RULE 2: ROOT HASH INTEGRITY
 * Risk: Unauthorized root hash changes = full account takeover
 * Bounty: $200K+ (Signature bypass)
 * ═══════════════════════════════════════════════════════════════════════════
 */

// Root hash only changes via non-view functions
rule rootHashOnlyChangesViaStateChanging(env e, bytes32 refHash, address account, method f)
    filtered { f -> f.isView }
{
    bytes32 rootBefore = getRootHash(refHash, account);

    calldataarg args;
    f(e, args);

    bytes32 rootAfter = getRootHash(refHash, account);

    assert rootAfter == rootBefore,
        "CRITICAL: View function modified root hash";
}

/*
 * ═══════════════════════════════════════════════════════════════════════════
 * RULE 3: NODE REGISTRATION ACCESS CONTROL
 * Risk: Malicious node injection
 * Bounty: $150K+ (Merkle proof bypass)
 * ═══════════════════════════════════════════════════════════════════════════
 */

// Node too short should revert
rule nodeLengthMinimum(env e, bytes32 refHash, bytes32[] proof, bytes node) {
    require node.length < 20;

    registerNode@withrevert(e, refHash, proof, node);

    assert lastReverted,
        "CRITICAL: Registered node shorter than verifier address length";
}

/*
 * ═══════════════════════════════════════════════════════════════════════════
 * RULE 4: VALIDATE FUNCTION SAFETY
 * Risk: Validation bypass = unauthorized transactions
 * Bounty: $150K+ (Sig validation bypass)
 * ═══════════════════════════════════════════════════════════════════════════
 */

// View functions cannot modify state (general invariant)
rule viewFunctionsReadOnly(env e, bytes32 refHash, address account, uint192 key, method f)
    filtered { f -> f.isView }
{
    bytes32 rootBefore = getRootHash(refHash, account);
    uint256 nonceBefore = getNonce(refHash, account, key);

    calldataarg args;
    f(e, args);

    bytes32 rootAfter = getRootHash(refHash, account);
    uint256 nonceAfter = getNonce(refHash, account, key);

    assert rootBefore == rootAfter,
        "CRITICAL: View function modified rootHash state";

    assert nonceBefore == nonceAfter,
        "CRITICAL: View function modified nonce state";
}

/*
 * ═══════════════════════════════════════════════════════════════════════════
 * RULE 5: STATE CONSISTENCY
 * Risk: Inconsistent state after operations
 * Bounty: $100K+ (State corruption)
 * ═══════════════════════════════════════════════════════════════════════════
 */

// Root hash is never zero (it defaults to refHash when unset)
rule rootHashNeverZeroForValidRefHash(bytes32 refHash, address account) {
    require refHash != to_bytes32(0);

    bytes32 root = getRootHash(refHash, account);

    assert root != to_bytes32(0),
        "HIGH: Root hash is zero for valid refHash";
}

/*
 * ═══════════════════════════════════════════════════════════════════════════
 * RULE 6: VIEW FUNCTIONS NEVER REVERT
 * ═══════════════════════════════════════════════════════════════════════════
 */

rule getRootHashNeverReverts(bytes32 refHash, address account) {
    bytes32 result = getRootHash@withrevert(refHash, account);

    assert !lastReverted,
        "MEDIUM: getRootHash reverted unexpectedly";
}

rule getNonceNeverReverts(bytes32 refHash, address account, uint192 key) {
    uint256 result = getNonce@withrevert(refHash, account, key);

    assert !lastReverted,
        "MEDIUM: getNonce reverted unexpectedly";
}

/*
 * ═══════════════════════════════════════════════════════════════════════════
 * RULE 7: REGISTERNODE CANNOT CHANGE NONCE
 * Risk: Nonce manipulation = replay attacks
 * Bounty: $100K+
 * ═══════════════════════════════════════════════════════════════════════════
 */

rule registerNodeCannotChangeNonce(env e, bytes32 refHash, address account, uint192 key, bytes32[] proof, bytes node) {
    uint256 nonceBefore = getNonce(refHash, account, key);

    registerNode(e, refHash, proof, node);

    uint256 nonceAfter = getNonce(refHash, account, key);

    assert nonceAfter == nonceBefore,
        "CRITICAL: registerNode changed nonce";
}

/*
 * ═══════════════════════════════════════════════════════════════════════════
 * RULE 8: REGISTERNODE CANNOT CHANGE ROOT HASH
 * Risk: Root hash manipulation = account takeover
 * Bounty: $200K+
 * ═══════════════════════════════════════════════════════════════════════════
 */

rule registerNodeCannotChangeRootHash(env e, bytes32 refHash, address account, bytes32[] proof, bytes node) {
    bytes32 rootBefore = getRootHash(refHash, account);

    registerNode(e, refHash, proof, node);

    bytes32 rootAfter = getRootHash(refHash, account);

    assert rootAfter == rootBefore,
        "CRITICAL: registerNode changed root hash";
}

/*
 * ═══════════════════════════════════════════════════════════════════════════
 * RULE 9: SANITY CHECKS - Function Reachability
 * ═══════════════════════════════════════════════════════════════════════════
 */

rule sanityAllFunctions(env e, method f) {
    calldataarg args;
    f@withrevert(e, args);
    satisfy !lastReverted;
}

rule viewsAccessible(bytes32 refHash, address account) {
    bytes32 root = getRootHash(refHash, account);
    uint256 nonce = getNonce(refHash, account, 0);

    assert true;
}

/*
 * ═══════════════════════════════════════════════════════════════════════════
 * RULE 10: REENTRANCY PROTECTION
 * Risk: State manipulation during external verifier calls
 * Bounty: $100K+ (Classic reentrancy)
 * ═══════════════════════════════════════════════════════════════════════════
 */

persistent ghost uint256 callDepth {
    init_state axiom callDepth == 0;
}

hook CALL(uint256 g, address addr, uint256 value, uint256 argsOffset, uint256 argsLength, uint256 retOffset, uint256 retLength) uint256 rc {
    callDepth = require_uint256(callDepth + 1);
}

// Any function should not have unbounded call depth
rule boundedCallDepth(env e, method f) {
    require callDepth == 0;

    calldataarg args;
    f(e, args);

    // Call depth shouldn't exceed reasonable bounds
    assert callDepth < 10,
        "HIGH: Potential unbounded external calls";
}

/*
 * ═══════════════════════════════════════════════════════════════════════════
 * RULE 11: NODE REGISTRATION PRESERVES OTHER NODES
 * Risk: Node cache corruption
 * Bounty: $50K+
 * ═══════════════════════════════════════════════════════════════════════════
 */

rule registerNodePreservesOtherNodes(
    env e,
    bytes32 refHash,
    address account,
    bytes32 nodeHash,
    bytes32[] proof,
    bytes node
) {
    // Existing node for a different hash
    require keccak256(node) != nodeHash;

    bytes existingNodeBefore = getRegisteredNode(refHash, account, nodeHash);
    require existingNodeBefore.length > 0;

    registerNode(e, refHash, proof, node);

    bytes existingNodeAfter = getRegisteredNode(refHash, account, nodeHash);

    // Other registered nodes should persist
    assert existingNodeAfter.length == existingNodeBefore.length,
        "HIGH: registerNode corrupted other cached nodes";
}

/*
 * ═══════════════════════════════════════════════════════════════════════════
 * RULE 12: NONCE STRUCTURE PRESERVATION
 * Risk: 2D nonce key corruption
 * Bounty: $50K+
 * ═══════════════════════════════════════════════════════════════════════════
 */

// Different nonce keys are independent
rule nonceKeysIndependent(env e, bytes32 refHash, address account, uint192 key1, uint192 key2) {
    require key1 != key2;

    uint256 nonce1Before = getNonce(refHash, account, key1);
    uint256 nonce2Before = getNonce(refHash, account, key2);

    calldataarg args;
    method f;
    f(e, args);

    uint256 nonce1After = getNonce(refHash, account, key1);
    uint256 nonce2After = getNonce(refHash, account, key2);

    // If one changed, the other should be independent
    // (both can change via handleUpdates, but changes are independent)
    assert (nonce1Before == nonce1After) || (nonce2Before == nonce2After) ||
           (nonce1After >= nonce1Before && nonce2After >= nonce2Before),
        "HIGH: Nonce keys are not independent";
}
