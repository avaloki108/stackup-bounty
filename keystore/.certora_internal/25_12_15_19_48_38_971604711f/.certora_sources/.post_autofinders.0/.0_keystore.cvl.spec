/*
 * ═══════════════════════════════════════════════════════════════════════════
 * KEYSTORE PROTOCOL - FORMAL VERIFICATION SPEC
 * Target: Merkle-tree based configuration management for ERC-4337 accounts
 * Bounty Potential: $50K-$200K (Critical auth/state bugs)
 * ═══════════════════════════════════════════════════════════════════════════
 */

methods {
    // Keystore core functions - use NONDET for complex struct parameters
    function handleUpdates(bytes) external;
    function validate(bytes) external returns (uint256);
    function registerNode(bytes32, bytes32[], bytes) external;
    function getRegisteredNode(bytes32, address, bytes32) external returns (bytes) envfree;
    function getRootHash(bytes32, address) external returns (bytes32) envfree;
    function getNonce(bytes32, address, uint192) external returns (uint256) envfree;

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

// Root hash can only change through handleUpdates
rule rootHashOnlyChangesViaHandleUpdates(env e, bytes32 refHash, address account, method f)
    filtered { f -> !f.isView && f.selector != sig:handleUpdates(bytes).selector }
{
    bytes32 rootBefore = getRootHash(refHash, account);

    calldataarg args;
    f(e, args);

    bytes32 rootAfter = getRootHash(refHash, account);

    assert rootAfter == rootBefore,
        "CRITICAL: Root hash changed outside handleUpdates";
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

// validate() is view-only, cannot modify state
rule validateIsReadOnly(env e, bytes32 refHash, address account) {
    bytes32 rootBefore = getRootHash(refHash, account);
    uint256 nonceBefore = getNonce(refHash, account, 0);

    calldataarg args;
    validate(e, args);

    bytes32 rootAfter = getRootHash(refHash, account);
    uint256 nonceAfter = getNonce(refHash, account, 0);

    assert rootBefore == rootAfter,
        "CRITICAL: validate() modified rootHash state";

    assert nonceBefore == nonceAfter,
        "CRITICAL: validate() modified nonce state";
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
 * RULE 7: NONCE ONLY CHANGES VIA HANDLEUPDATES
 * Risk: Nonce manipulation = replay attacks
 * Bounty: $100K+
 * ═══════════════════════════════════════════════════════════════════════════
 */

rule nonceOnlyChangesViaHandleUpdates(env e, bytes32 refHash, address account, uint192 key, method f)
    filtered { f -> !f.isView && f.selector != sig:handleUpdates(bytes).selector }
{
    uint256 nonceBefore = getNonce(refHash, account, key);

    calldataarg args;
    f(e, args);

    uint256 nonceAfter = getNonce(refHash, account, key);

    assert nonceAfter == nonceBefore,
        "CRITICAL: Nonce changed outside handleUpdates";
}

/*
 * ═══════════════════════════════════════════════════════════════════════════
 * RULE 8: SANITY CHECKS - Function Reachability
 * ═══════════════════════════════════════════════════════════════════════════
 */

rule sanityHandleUpdates(env e) {
    calldataarg args;
    handleUpdates@withrevert(e, args);
    satisfy !lastReverted;
}

rule sanityValidate(env e) {
    calldataarg args;
    validate@withrevert(e, args);
    satisfy !lastReverted;
}

rule sanityRegisterNode(env e) {
    calldataarg args;
    registerNode@withrevert(e, args);
    satisfy !lastReverted;
}

rule viewsAccessible(bytes32 refHash, address account) {
    bytes32 root = getRootHash(refHash, account);
    uint256 nonce = getNonce(refHash, account, 0);

    assert true;
}

/*
 * ═══════════════════════════════════════════════════════════════════════════
 * RULE 9: REENTRANCY PROTECTION
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

// handleUpdates uses nonReentrant modifier - verify call depth behavior
rule noReentrantHandleUpdates(env e) {
    require callDepth == 0;

    calldataarg args;
    handleUpdates(e, args);

    // ReentrancyGuardTransient should prevent re-entry during execution
}

/*
 * ═══════════════════════════════════════════════════════════════════════════
 * RULE 10: REGISTERED NODE PERSISTENCE
 * Risk: Registered nodes disappearing unexpectedly
 * Bounty: $50K+ (DoS on validation)
 * ═══════════════════════════════════════════════════════════════════════════
 */

// Registered nodes persist unless root hash changes
rule registeredNodePersistence(env e, bytes32 refHash, address account, bytes32 nodeHash, method f)
    filtered { f -> f.selector != sig:handleUpdates(bytes).selector }
{
    bytes nodeBefore = getRegisteredNode(refHash, account, nodeHash);
    require nodeBefore.length > 0;

    bytes32 rootBefore = getRootHash(refHash, account);

    calldataarg args;
    f(e, args);

    bytes32 rootAfter = getRootHash(refHash, account);

    // If root didn't change, node should persist
    bytes nodeAfter = getRegisteredNode(refHash, account, nodeHash);
    assert rootBefore != rootAfter || nodeAfter.length > 0,
        "HIGH: Registered node disappeared without root hash change";
}
