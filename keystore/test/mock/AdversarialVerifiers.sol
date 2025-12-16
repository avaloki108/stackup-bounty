// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import {IVerifier} from "../../src/interface/IVerifier.sol";
import {SIG_VALIDATION_FAILED, SIG_VALIDATION_SUCCESS} from "account-abstraction/core/Helpers.sol";

/**
 * @title AdversarialVerifiers
 * @notice Hostile verifier implementations for security testing
 * @dev Tests that Keystore handles malicious/buggy verifiers correctly
 */

/// @notice Returns SUCCESS for ANY input - signature bypass attempt
contract AlwaysSuccessVerifier is IVerifier {
    function validateData(bytes32, bytes calldata, bytes calldata) external pure returns (uint256) {
        return SIG_VALIDATION_SUCCESS;
    }
}

/// @notice Returns FAILED for ANY input
contract AlwaysFailVerifier is IVerifier {
    function validateData(bytes32, bytes calldata, bytes calldata) external pure returns (uint256) {
        return SIG_VALIDATION_FAILED;
    }
}

/// @notice Returns different values based on calldata length - inconsistent behavior
contract CalldataLengthVerifier is IVerifier {
    function validateData(bytes32, bytes calldata data, bytes calldata config) external pure returns (uint256) {
        // Inconsistent: depends on data length
        if (data.length % 2 == 0) {
            return SIG_VALIDATION_SUCCESS;
        }
        if (config.length > 20) {
            return SIG_VALIDATION_SUCCESS;
        }
        return SIG_VALIDATION_FAILED;
    }
}

/// @notice Reverts on certain inputs - DoS surface testing
contract RevertingVerifier is IVerifier {
    error IntentionalRevert();
    error OutOfGas();

    function validateData(bytes32 message, bytes calldata data, bytes calldata) external pure returns (uint256) {
        // Revert if message starts with 0xdead
        if (bytes4(message) == 0xdeadbeef) {
            revert IntentionalRevert();
        }
        // Revert on empty data
        if (data.length == 0) {
            revert IntentionalRevert();
        }
        return SIG_VALIDATION_SUCCESS;
    }
}

/// @notice Consumes huge gas - griefing attack (view-compatible)
contract GasGriefingVerifier is IVerifier {
    function validateData(bytes32 message, bytes calldata, bytes calldata) external view returns (uint256) {
        // Waste gas with expensive computation (view-safe)
        uint256 result = 0;
        uint256 iterations = uint256(message) % 1000;
        for (uint256 i = 0; i < iterations; i++) {
            result = uint256(keccak256(abi.encode(result, i)));
        }
        return result % 2 == 0 ? SIG_VALIDATION_SUCCESS : SIG_VALIDATION_SUCCESS;
    }
}

/// @notice Attempts reentrancy during validation (view version - staticcall only)
/// @dev In practice, reentrancy from view functions is limited to staticcall
contract ReentrantVerifier is IVerifier {
    address public target;
    bytes public payload;

    function setReentrancyTarget(address _target, bytes calldata _payload) external {
        target = _target;
        payload = _payload;
    }

    function validateData(bytes32, bytes calldata, bytes calldata) external view returns (uint256) {
        // View functions can only do staticcall, which can't modify state
        // But we test that Keystore handles external calls during validation
        if (target != address(0)) {
            (bool success,) = target.staticcall(payload);
            success; // Suppress warning
        }
        return SIG_VALIDATION_SUCCESS;
    }
}

/// @notice Returns invalid validation data (not 0 or 1)
contract InvalidReturnVerifier is IVerifier {
    uint256 public returnValue;

    constructor(uint256 _returnValue) {
        returnValue = _returnValue;
    }

    function validateData(bytes32, bytes calldata, bytes calldata) external view returns (uint256) {
        return returnValue;
    }
}

/// @notice Self-destructs during validation (deprecated but worth testing)
/// @dev NOTE: IVerifier requires view, so this is a view-compatible version
contract SelfDestructVerifier is IVerifier {
    function validateData(bytes32, bytes calldata, bytes calldata) external view returns (uint256) {
        // In reality, a view function can't selfdestruct
        // but we keep this for interface compliance
        return SIG_VALIDATION_SUCCESS;
    }
}

/// @notice State-dependent: returns different values on repeated calls
/// @dev NOTE: Made view-compatible by using storage read only
contract StatefulVerifier is IVerifier {
    uint256 public callCount;

    function validateData(bytes32, bytes calldata, bytes calldata) external view returns (uint256) {
        // View function can only read state, not modify
        // First call (callCount==0) succeeds, subsequent calls fail
        if (callCount == 0) {
            return SIG_VALIDATION_SUCCESS;
        }
        return SIG_VALIDATION_FAILED;
    }

    function incrementCount() external {
        callCount++;
    }

    function reset() external {
        callCount = 0;
    }
}

/// @notice Returns SUCCESS but with time-bound data (ERC-4337 validUntil/validAfter)
contract TimeBoundVerifier is IVerifier {
    function validateData(bytes32, bytes calldata, bytes calldata) external view returns (uint256) {
        // Pack validAfter=0, validUntil=block.timestamp+100, sig=0 (success)
        // This tests if Keystore properly handles time-bounded validation
        uint48 validUntil = uint48(block.timestamp + 100);
        uint48 validAfter = 0;
        return uint256(validUntil) << 160 | uint256(validAfter) << 208;
    }
}

/// @notice Tests message commitment - accepts if message contains specific pattern
contract MessagePatternVerifier is IVerifier {
    bytes32 public acceptedPattern;

    constructor(bytes32 _pattern) {
        acceptedPattern = _pattern;
    }

    function validateData(bytes32 message, bytes calldata, bytes calldata) external view returns (uint256) {
        // Only accept if message matches pattern - tests domain separation
        if (message == acceptedPattern) {
            return SIG_VALIDATION_SUCCESS;
        }
        return SIG_VALIDATION_FAILED;
    }
}

/*//////////////////////////////////////////////////////////////
                    ERC-4337 VALIDATION DATA BYPASS VERIFIERS
//////////////////////////////////////////////////////////////*/

/**
 * @title ExpiredTimeBoundVerifier
 * @notice Returns ERC-4337 packed validationData with EXPIRED time bounds
 * @dev Exploits the bug where Keystore checks `== SIG_VALIDATION_FAILED` instead of
 *      `!= SIG_VALIDATION_SUCCESS`. This verifier returns a non-0, non-1 value that
 *      encodes an expired time window, but is accepted as "success" by Keystore.
 *
 * ERC-4337 validationData packing (256 bits):
 * - Bits 0-159: aggregator address (0 = success, 1 = failure, other = aggregator)
 * - Bits 160-207: validUntil (48 bits) - timestamp after which validation expires
 * - Bits 208-255: validAfter (48 bits) - timestamp before which validation is not valid
 *
 * VULNERABILITY: Keystore only checks if return == 1 (SIG_VALIDATION_FAILED)
 * Any other value, including packed time bounds, is treated as SUCCESS.
 */
contract ExpiredTimeBoundVerifier is IVerifier {
    function validateData(bytes32, bytes calldata, bytes calldata) external view returns (uint256) {
        // Return EXPIRED time bounds: validUntil = block.timestamp - 100 (past)
        // This SHOULD be rejected, but Keystore accepts it because return != 1
        uint48 validUntil = uint48(block.timestamp > 100 ? block.timestamp - 100 : 0); // Expired!
        uint48 validAfter = 0;
        address aggregator = address(0); // Success marker, not address(1) which is failure

        // Pack according to ERC-4337 spec:
        // aggregator in lower 160 bits, validUntil in next 48 bits, validAfter in upper 48 bits
        return uint256(uint160(aggregator)) | (uint256(validUntil) << 160) | (uint256(validAfter) << 208);
    }
}

/**
 * @title NotYetValidVerifier
 * @notice Returns ERC-4337 packed validationData with FUTURE validAfter
 * @dev Similar to ExpiredTimeBoundVerifier but with validAfter in the future.
 *      This represents a signature that isn't valid yet, but Keystore accepts it.
 */
contract NotYetValidVerifier is IVerifier {
    function validateData(bytes32, bytes calldata, bytes calldata) external view returns (uint256) {
        // Return FUTURE validAfter: validAfter = block.timestamp + 1 hour
        // This SHOULD be rejected, but Keystore accepts it because return != 1
        uint48 validUntil = type(uint48).max; // Never expires
        uint48 validAfter = uint48(block.timestamp + 3600); // Not valid for 1 hour!
        address aggregator = address(0);

        return uint256(uint160(aggregator)) | (uint256(validUntil) << 160) | (uint256(validAfter) << 208);
    }
}

/**
 * @title ArbitraryReturnVerifier
 * @notice Returns arbitrary non-0 non-1 values to test return value handling
 * @dev Demonstrates that ANY value except 1 is treated as success by Keystore.
 */
contract ArbitraryReturnVerifier is IVerifier {
    uint256 public immutable returnValue;

    constructor(uint256 _returnValue) {
        // Ensure we're testing non-standard values
        require(_returnValue != 0 && _returnValue != 1, "Use standard values for clarity");
        returnValue = _returnValue;
    }

    function validateData(bytes32, bytes calldata, bytes calldata) external view returns (uint256) {
        // Return arbitrary value - if != 1, Keystore treats as success
        return returnValue;
    }
}

/**
 * @title AggregatorAddressVerifier
 * @notice Returns a custom aggregator address (should require aggregator validation)
 * @dev In ERC-4337, a non-0 non-1 aggregator address means "use this aggregator to validate".
 *      Keystore doesn't handle this case, so it's accepted as success.
 */
contract AggregatorAddressVerifier is IVerifier {
    address public immutable fakeAggregator;

    constructor(address _fakeAggregator) {
        require(_fakeAggregator != address(0) && _fakeAggregator != address(1), "Invalid aggregator");
        fakeAggregator = _fakeAggregator;
    }

    function validateData(bytes32, bytes calldata, bytes calldata) external view returns (uint256) {
        // Return aggregator address - Keystore should defer to aggregator, but doesn't
        return uint256(uint160(fakeAggregator));
    }
}
