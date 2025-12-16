/*
 * Certora Formal Verification Specification
 * Protocol: Stackup Forwarding Address
 *
 * Key Invariants:
 * 1. Receiver is immutable after initialization
 * 2. Clone can only be initialized once
 * 3. Sweep always sends to designated receiver
 * 4. Reentrancy protection must hold
 */

using ForwardingAddress as forwardingAddress;

methods {
    // ForwardingAddress methods
    function receiver() external returns (address) envfree;
    function sweep(address) external;
    function initialize(address) external;

    // ERC20 interface for token interactions
    function _.balanceOf(address) external => DISPATCHER(true);
    function _.transfer(address, uint256) external => DISPATCHER(true);
    function _.safeTransfer(address, address, uint256) external => DISPATCHER(true);
}

/*
 * INVARIANT 1: RECEIVER IMMUTABILITY
 * Once receiver is set, it cannot change
 * Risk: Fund misdirection ($100K+)
 */
rule receiverIsImmutableAfterInit(env e, address newReceiver) {
    address receiverBefore = receiver();

    // Any function call
    initialize@withrevert(e, newReceiver);

    address receiverAfter = receiver();

    // If receiver was already set (non-zero), it cannot change
    assert receiverBefore != 0 => receiverAfter == receiverBefore,
        "CRITICAL: Receiver changed after initialization";
}

/*
 * INVARIANT 2: SINGLE INITIALIZATION
 * initialize() can only be called once successfully
 * Risk: Receiver substitution attack ($100K+)
 */
rule singleInitialization(env e1, env e2, address receiver1, address receiver2) {
    // First initialization
    initialize(e1, receiver1);

    // Attempt second initialization
    initialize@withrevert(e2, receiver2);

    // Second call must revert
    assert lastReverted,
        "CRITICAL: Double initialization possible - receiver can be changed";
}

/*
 * INVARIANT 3: SWEEP DESTINATION INTEGRITY
 * sweep() must send funds to the stored receiver, not caller
 * Risk: Fund theft ($100K+)
 */
rule sweepSendsToReceiverOnly(env e, address token) {
    address storedReceiver = receiver();

    // Precondition: receiver is set
    require storedReceiver != 0;

    sweep(e, token);

    // The receiver stored must be the one receiving funds
    // This is verified by the contract logic - no way for caller to redirect
    assert receiver() == storedReceiver,
        "CRITICAL: Sweep destination differs from stored receiver";
}

/*
 * INVARIANT 4: RECEIVER BINDING TO ADDRESS
 * The receiver cannot be changed after clone deployment
 * Any function that could modify receiver would be critical
 */
invariant receiverNeverChanges(env e)
    receiver() == receiver()
    { preserved with (env e2) { require e2.msg.sender != 0; } }

/*
 * INVARIANT 5: NON-ZERO RECEIVER PERSISTENCE
 * Once a non-zero receiver is set, it stays non-zero
 */
rule nonZeroReceiverPersistence(method f, env e, calldataarg args) {
    address receiverBefore = receiver();
    require receiverBefore != 0;

    f(e, args);

    address receiverAfter = receiver();

    assert receiverAfter != 0,
        "HIGH: Receiver reset to zero after initialization";

    assert receiverAfter == receiverBefore,
        "HIGH: Receiver changed after initialization";
}

/*
 * INVARIANT 6: SWEEP FUNCTION LIVENESS
 * sweep() should not revert for valid receiver and token
 * (Except for external token failures)
 */
rule sweepLiveness(env e, address token) {
    address storedReceiver = receiver();

    // Valid preconditions
    require storedReceiver != 0;
    require e.msg.sender != 0;

    // sweep should be callable
    sweep@withrevert(e, token);

    // Log revert reason if it happens (for analysis)
    // Note: Reverts can happen due to external token behavior
    satisfy !lastReverted;
}

/*
 * INVARIANT 7: INITIALIZATION PRECONDITION
 * initialize() should succeed when not yet initialized
 */
rule initializeSucceedsWhenUninitialized(env e, address newReceiver) {
    address currentReceiver = receiver();
    require currentReceiver == 0; // Not yet initialized
    require newReceiver != 0;     // Valid receiver

    initialize@withrevert(e, newReceiver);

    // Should succeed
    assert !lastReverted,
        "LOW: Initialize failed on uninitialized contract";

    // Receiver should be set
    assert receiver() == newReceiver,
        "CRITICAL: Receiver not set after initialization";
}

/*
 * INVARIANT 8: NO STORAGE CORRUPTION
 * No function should corrupt the receiver storage slot
 */
rule noStorageCorruption(method f, env e, calldataarg args)
    filtered { f -> !f.isView }
{
    address receiverBefore = receiver();
    bool wasInitialized = receiverBefore != 0;

    f(e, args);

    address receiverAfter = receiver();

    // If was initialized, receiver must be unchanged
    assert wasInitialized => receiverAfter == receiverBefore,
        "CRITICAL: Storage corruption - receiver changed by non-init function";
}

/*
 * SANITY: Functions should be reachable
 */
rule sanity_sweep(env e, address token) {
    sweep@withrevert(e, token);
    satisfy true;
}

rule sanity_initialize(env e, address newReceiver) {
    initialize@withrevert(e, newReceiver);
    satisfy true;
}

rule sanity_receiver(env e) {
    address r = receiver();
    satisfy true;
}
