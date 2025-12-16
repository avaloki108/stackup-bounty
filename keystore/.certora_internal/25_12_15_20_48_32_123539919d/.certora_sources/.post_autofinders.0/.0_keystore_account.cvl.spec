/*
 * ═══════════════════════════════════════════════════════════════════════════
 * KEYSTORE ACCOUNT - FORMAL VERIFICATION SPEC
 * Target: KeystoreAccount - ERC-4337 account using Keystore for validation
 * Bounty Potential: $50K-$100K (Initialization bugs, access control bypass)
 * ═══════════════════════════════════════════════════════════════════════════
 */

using KeystoreAccount as account;

methods {
    // View functions
    function refHash() external returns (bytes32) envfree;
    function keystore() external returns (address) envfree;
    function entryPoint() external returns (address) envfree;
    function getDeposit() external returns (uint256);

    // State-modifying functions
    function initialize(bytes32) external;
    function addDeposit() external;
    function withdrawDepositTo(address, uint256) external;

    // Summarize external calls to avoid complexity
    function _.validate(ValidateAction memory) external => NONDET;
    function _.registerNode(bytes32, bytes32[], bytes) external => NONDET;
    function _.balanceOf(address) external => NONDET;
    function _.depositTo(address) external => NONDET;
    function _.withdrawTo(address, uint256) external => NONDET;
}

/*
 * ═══════════════════════════════════════════════════════════════════════════
 * RULE 1: IMMUTABLES DON'T CHANGE - Keystore address is constant
 * ═══════════════════════════════════════════════════════════════════════════
 */

rule keystoreImmutable(env e, method f)
    filtered { f -> !f.isView }
{
    address keystoreBefore = keystore();

    calldataarg args;
    f(e, args);

    address keystoreAfter = keystore();

    assert keystoreBefore == keystoreAfter,
        "CRITICAL: keystore address changed";
}

/*
 * ═══════════════════════════════════════════════════════════════════════════
 * RULE 2: IMMUTABLES DON'T CHANGE - EntryPoint address is constant
 * ═══════════════════════════════════════════════════════════════════════════
 */

rule entryPointImmutable(env e, method f)
    filtered { f -> !f.isView }
{
    address entryPointBefore = entryPoint();

    calldataarg args;
    f(e, args);

    address entryPointAfter = entryPoint();

    assert entryPointBefore == entryPointAfter,
        "CRITICAL: entryPoint address changed";
}

/*
 * ═══════════════════════════════════════════════════════════════════════════
 * RULE 3: REFHASH ONLY SET ONCE - Initialization safety
 * ═══════════════════════════════════════════════════════════════════════════
 */

rule refHashInitializationProtection(env e, bytes32 newRefHash) {
    bytes32 existingRefHash = refHash();

    // If already initialized (non-zero), should revert
    require existingRefHash != 0;

    initialize@withrevert(e, newRefHash);

    assert lastReverted,
        "CRITICAL: Re-initialization of refHash was allowed";
}

/*
 * ═══════════════════════════════════════════════════════════════════════════
 * RULE 4: REFHASH CANNOT CHANGE AFTER INITIALIZATION
 * ═══════════════════════════════════════════════════════════════════════════
 */

rule refHashPermanentAfterInit(env e, method f)
    filtered { f -> !f.isView && f.selector != sig:initialize(bytes32).selector }
{
    bytes32 refHashBefore = refHash();
    require refHashBefore != 0; // Already initialized

    calldataarg args;
    f(e, args);

    bytes32 refHashAfter = refHash();

    assert refHashBefore == refHashAfter,
        "CRITICAL: refHash changed after initialization";
}

/*
 * ═══════════════════════════════════════════════════════════════════════════
 * RULE 5: INITIALIZATION SETS REFHASH
 * ═══════════════════════════════════════════════════════════════════════════
 */

rule initializeSetsRefHash(env e, bytes32 newRefHash) {
    bytes32 refHashBefore = refHash();
    require refHashBefore == 0; // Not initialized
    require newRefHash != 0;    // Meaningful initialization

    initialize@withrevert(e, newRefHash);

    assert !lastReverted => refHash() == newRefHash,
        "HIGH: Initialize did not set refHash correctly";
}

/*
 * ═══════════════════════════════════════════════════════════════════════════
 * INVARIANT: Keystore is non-zero (set at construction)
 * ═══════════════════════════════════════════════════════════════════════════
 */

invariant keystoreNonZero()
    keystore() != 0
    {
        preserved {
            require true;
        }
    }

/*
 * ═══════════════════════════════════════════════════════════════════════════
 * INVARIANT: EntryPoint is non-zero (set at construction)
 * ═══════════════════════════════════════════════════════════════════════════
 */

invariant entryPointNonZero()
    entryPoint() != 0
    {
        preserved {
            require true;
        }
    }

/*
 * ═══════════════════════════════════════════════════════════════════════════
 * RULE 6: SANITY - Functions are reachable
 * ═══════════════════════════════════════════════════════════════════════════
 */

rule sanityInitializeReachable(env e, bytes32 newRefHash) {
    bytes32 refHashBefore = refHash();
    require refHashBefore == 0;

    initialize@withrevert(e, newRefHash);

    satisfy !lastReverted;
}

rule sanityAddDepositReachable(env e) {
    addDeposit@withrevert(e);

    satisfy !lastReverted;
}
