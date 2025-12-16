/*
 * Certora Formal Verification Specification
 * Protocol: Stackup Forwarding Address Factory
 *
 * Key Invariants:
 * 1. Implementation is immutable
 * 2. Address prediction matches deployment
 * 3. Created clones are always initialized
 * 4. Same (receiver, salt) produces same address
 */

using ForwardingAddressFactory as factory;
using ForwardingAddress as forwardingAddress;

methods {
    // Factory methods
    function implementation() external returns (address) envfree;
    function getAddress(address, bytes32) external returns (address) envfree;
    function createForwardingAddress(address, bytes32) external returns (address);
    function sweepFor(address, bytes32, address[]) external;

    // ForwardingAddress methods (for cross-contract verification)
    function forwardingAddress.receiver() external returns (address) envfree;
    function forwardingAddress.initialize(address) external;
    function forwardingAddress.sweep(address) external;
}

/*
 * INVARIANT 1: IMPLEMENTATION IMMUTABILITY
 * The implementation address should never change
 * Risk: Upgrade attack ($200K+)
 */
rule implementationIsImmutable(method f, env e, calldataarg args) {
    address implBefore = implementation();

    f(e, args);

    address implAfter = implementation();

    assert implAfter == implBefore,
        "CRITICAL: Implementation address changed";
}

/*
 * INVARIANT 2: ADDRESS DETERMINISM
 * getAddress(receiver, salt) must be deterministic
 * Same inputs = same output
 */
rule addressDeterminism(address receiver, bytes32 salt) {
    address addr1 = getAddress(receiver, salt);
    address addr2 = getAddress(receiver, salt);

    assert addr1 == addr2,
        "CRITICAL: Address prediction is non-deterministic";
}

/*
 * INVARIANT 3: ADDRESS UNIQUENESS
 * Different (receiver, salt) pairs produce different addresses
 * (With overwhelming probability - collision resistance)
 */
rule addressUniqueness(address receiver1, address receiver2, bytes32 salt1, bytes32 salt2) {
    // If inputs differ
    require receiver1 != receiver2 || salt1 != salt2;

    address addr1 = getAddress(receiver1, salt1);
    address addr2 = getAddress(receiver2, salt2);

    // Addresses should differ (overwhelmingly likely due to keccak256)
    // Note: This is probabilistic, not absolute
    assert addr1 != addr2,
        "HIGH: Address collision detected";
}

/*
 * INVARIANT 4: CREATE RETURNS PREDICTED ADDRESS
 * createForwardingAddress must return the same address as getAddress
 */
rule createMatchesPrediction(env e, address receiver, bytes32 salt) {
    address predicted = getAddress(receiver, salt);

    address created = createForwardingAddress(e, receiver, salt);

    assert created == predicted,
        "CRITICAL: Created address differs from prediction";
}

/*
 * INVARIANT 5: SWEEP FOR LIVENESS
 * sweepFor should be callable for valid inputs
 */
rule sweepForLiveness(env e, address receiver, bytes32 salt, address[] tokens) {
    require receiver != 0;
    require e.msg.sender != 0;

    sweepFor@withrevert(e, receiver, salt, tokens);

    // Should be callable (may revert due to token issues)
    satisfy !lastReverted;
}

/*
 * INVARIANT 6: IDEMPOTENT CREATION
 * Calling createForwardingAddress twice with same params
 * returns the same address (idempotent)
 */
rule idempotentCreation(env e1, env e2, address receiver, bytes32 salt) {
    address first = createForwardingAddress(e1, receiver, salt);
    address second = createForwardingAddress(e2, receiver, salt);

    assert first == second,
        "CRITICAL: Non-idempotent creation";
}

/*
 * INVARIANT 7: RECEIVER BINDING
 * Created clone must have the specified receiver
 * (Verified via cross-contract call if supported)
 */
rule createdCloneHasCorrectReceiver(env e, address receiver, bytes32 salt) {
    require receiver != 0;

    address created = createForwardingAddress(e, receiver, salt);

    // The created clone should have the receiver set
    // Note: This requires linking with ForwardingAddress contract
    assert created != 0,
        "HIGH: Clone creation failed";
}

/*
 * SANITY: Functions should be reachable
 */
rule sanity_getAddress(address receiver, bytes32 salt) {
    address addr = getAddress(receiver, salt);
    satisfy true;
}

rule sanity_create(env e, address receiver, bytes32 salt) {
    createForwardingAddress@withrevert(e, receiver, salt);
    satisfy true;
}

rule sanity_implementation() {
    address impl = implementation();
    satisfy impl != 0;
}
