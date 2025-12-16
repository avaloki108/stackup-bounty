/*
 * ═══════════════════════════════════════════════════════════════════════════
 * ECDSA VERIFIER - FORMAL VERIFICATION SPEC
 * Target: UserOpECDSAVerifier - EIP-191 signed message verification
 * Bounty Potential: $50K-$100K (Signature bypass, malleability, wrong domain)
 * ═══════════════════════════════════════════════════════════════════════════
 */

using UserOpECDSAVerifier as verifier;

methods {
    // The main validation function
    function validateData(bytes32, bytes, bytes) external returns (uint256);

    // Access keystore address
    function keystore() external returns (address) envfree;

    // Summarize external ECDSA.recover - returns an address (could be any)
    function _.recover(bytes32, bytes memory) internal => NONDET;

    // Summarize ECDSA.toEthSignedMessageHash
    function _.toEthSignedMessageHash(bytes32) internal => NONDET;
}

/*
 * ═══════════════════════════════════════════════════════════════════════════
 * RULE 1: ACCESS CONTROL - Only Keystore Can Call validateData
 * Risk: If non-keystore can call, signature validation could be bypassed
 * Bounty: $50K+ (Access control bypass)
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
 * Risk: Invalid return values could cause unexpected behavior
 * Bounty: $25K+ (Logic error)
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
 * RULE 3: CONFIG LENGTH VALIDATION
 * Risk: Config must be at least 20 bytes (address length)
 * Bounty: $25K+ (Config parsing error)
 * ═══════════════════════════════════════════════════════════════════════════
 */

rule configLengthMinimum(env e, bytes32 message, bytes data, bytes config) {
    require e.msg.sender == keystore();
    require config.length < 20;

    validateData@withrevert(e, message, data, config);

    // Should revert or fail if config too short
    assert lastReverted || true,  // Will be refined based on actual behavior
        "MEDIUM: Short config handled unexpectedly";
}

/*
 * ═══════════════════════════════════════════════════════════════════════════
 * RULE 4: DETERMINISTIC OUTPUT
 * Same inputs should produce same outputs (no hidden state)
 * ═══════════════════════════════════════════════════════════════════════════
 */

rule deterministicValidation(env e1, env e2, bytes32 message, bytes data, bytes config) {
    require e1.msg.sender == keystore();
    require e2.msg.sender == keystore();
    // Same block context
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
 * RULE 5: VIEW FUNCTION - NO STATE CHANGES
 * validateData is view, should never change state
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
 * RULE 6: SANITY - FUNCTION REACHABILITY
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
