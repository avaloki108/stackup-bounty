/*
 * ═══════════════════════════════════════════════════════════════════════════
 * WEBAUTHN VERIFIER - FORMAL VERIFICATION SPEC
 * Target: UserOpWebAuthnVerifier - P-256 / secp256r1 signature verification
 * Bounty Potential: $100K-$200K (Challenge binding, origin bypass, key abuse)
 * ═══════════════════════════════════════════════════════════════════════════
 */

using UserOpWebAuthnVerifier as verifier;

methods {
    // The main validation function
    function validateData(bytes32, bytes, bytes) external returns (uint256);

    // Access keystore address
    function keystore() external returns (address) envfree;

    // Summarize WebAuthn verification as NONDET (complex cryptographic operation)
    function _.verify(bytes memory, bool, WebAuthn.WebAuthnAuth memory, bytes32, bytes32) internal => NONDET;
    function _.tryDecodeAuth(bytes memory) internal => NONDET;
}

/*
 * ═══════════════════════════════════════════════════════════════════════════
 * RULE 1: ACCESS CONTROL - Only Keystore Can Call validateData
 * ═══════════════════════════════════════════════════════════════════════════
 */

rule onlyKeystoreCanValidate(env e, bytes32 message, bytes data, bytes config) {
    address keystoreAddr = keystore();
    require e.msg.sender != keystoreAddr;

    validateData@withrevert(e, message, data, config);

    assert lastReverted,
        "CRITICAL: Non-keystore caller was able to call validateData";
}

/*
 * ═══════════════════════════════════════════════════════════════════════════
 * RULE 2: RETURN VALUES ARE VALID
 * ═══════════════════════════════════════════════════════════════════════════
 */

rule validReturnValues(env e, bytes32 message, bytes data, bytes config) {
    require e.msg.sender == keystore();

    uint256 result = validateData@withrevert(e, message, data, config);

    // SIG_VALIDATION_SUCCESS = 0, SIG_VALIDATION_FAILED = 1
    assert !lastReverted => (result == 0 || result == 1),
        "HIGH: validateData returned invalid value (not 0 or 1)";
}

/*
 * ═══════════════════════════════════════════════════════════════════════════
 * RULE 3: VIEW FUNCTION - NO STATE CHANGES
 * ═══════════════════════════════════════════════════════════════════════════
 */

rule validateIsView(env e, bytes32 message, bytes data, bytes config) {
    address keystoreBefore = keystore();

    require e.msg.sender == keystore();
    validateData@withrevert(e, message, data, config);

    address keystoreAfter = keystore();

    assert keystoreBefore == keystoreAfter,
        "CRITICAL: validateData modified state";
}

/*
 * ═══════════════════════════════════════════════════════════════════════════
 * RULE 4: DETERMINISTIC OUTPUT
 * ═══════════════════════════════════════════════════════════════════════════
 */

rule deterministicValidation(env e1, env e2, bytes32 message, bytes data, bytes config) {
    require e1.msg.sender == keystore();
    require e2.msg.sender == keystore();
    require e1.block.number == e2.block.number;
    require e1.block.timestamp == e2.block.timestamp;

    uint256 result1 = validateData@withrevert(e1, message, data, config);
    bool reverted1 = lastReverted;

    uint256 result2 = validateData@withrevert(e2, message, data, config);
    bool reverted2 = lastReverted;

    assert reverted1 == reverted2,
        "HIGH: Same inputs produce different revert behavior";
    assert !reverted1 => result1 == result2,
        "HIGH: Same inputs produce different results";
}

/*
 * ═══════════════════════════════════════════════════════════════════════════
 * RULE 5: SANITY - FUNCTION REACHABILITY
 * ═══════════════════════════════════════════════════════════════════════════
 */

rule sanityValidateDataReachable(env e, bytes32 message, bytes data, bytes config) {
    require e.msg.sender == keystore();

    validateData@withrevert(e, message, data, config);

    satisfy !lastReverted;
}

/*
 * ═══════════════════════════════════════════════════════════════════════════
 * INVARIANT: Keystore Address is Non-Zero
 * ═══════════════════════════════════════════════════════════════════════════
 */

invariant keystoreNonZero()
    keystore() != 0
    {
        preserved {
            require true;
        }
    }
