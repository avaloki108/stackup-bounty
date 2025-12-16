// SPDX-License-Identifier: MIT
pragma solidity >=0.6.2 <0.9.0;

pragma experimental ABIEncoderV2;

abstract contract StdInvariant {
    struct FuzzSelector {
        address addr;
        bytes4[] selectors;
    }

    struct FuzzArtifactSelector {
        string artifact;
        bytes4[] selectors;
    }

    struct FuzzInterface {
        address addr;
        string[] artifacts;
    }

    address[] private _excludedContracts;
    address[] private _excludedSenders;
    address[] private _targetedContracts;
    address[] private _targetedSenders;

    string[] private _excludedArtifacts;
    string[] private _targetedArtifacts;

    FuzzArtifactSelector[] private _targetedArtifactSelectors;

    FuzzSelector[] private _excludedSelectors;
    FuzzSelector[] private _targetedSelectors;

    FuzzInterface[] private _targetedInterfaces;

    // Functions for users:
    // These are intended to be called in tests.

    function excludeContract(address newExcludedContract_) internal {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0b360000, 1037618711350) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0b360001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0b360005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0b366000, newExcludedContract_) }
        _excludedContracts.push(newExcludedContract_);
    }

    function excludeSelector(FuzzSelector memory newExcludedSelector_) internal {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0b370000, 1037618711351) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0b370001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0b370005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0b376000, newExcludedSelector_) }
        _excludedSelectors.push(newExcludedSelector_);
    }

    function excludeSender(address newExcludedSender_) internal {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0b390000, 1037618711353) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0b390001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0b390005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0b396000, newExcludedSender_) }
        _excludedSenders.push(newExcludedSender_);
    }

    function excludeArtifact(string memory newExcludedArtifact_) internal {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0b3a0000, 1037618711354) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0b3a0001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0b3a0005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0b3a6000, newExcludedArtifact_) }
        _excludedArtifacts.push(newExcludedArtifact_);
    }

    function targetArtifact(string memory newTargetedArtifact_) internal {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0b380000, 1037618711352) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0b380001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0b380005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0b386000, newTargetedArtifact_) }
        _targetedArtifacts.push(newTargetedArtifact_);
    }

    function targetArtifactSelector(FuzzArtifactSelector memory newTargetedArtifactSelector_) internal {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0b3b0000, 1037618711355) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0b3b0001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0b3b0005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0b3b6000, newTargetedArtifactSelector_) }
        _targetedArtifactSelectors.push(newTargetedArtifactSelector_);
    }

    function targetContract(address newTargetedContract_) internal {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0b3c0000, 1037618711356) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0b3c0001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0b3c0005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0b3c6000, newTargetedContract_) }
        _targetedContracts.push(newTargetedContract_);
    }

    function targetSelector(FuzzSelector memory newTargetedSelector_) internal {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0b3d0000, 1037618711357) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0b3d0001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0b3d0005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0b3d6000, newTargetedSelector_) }
        _targetedSelectors.push(newTargetedSelector_);
    }

    function targetSender(address newTargetedSender_) internal {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0b3e0000, 1037618711358) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0b3e0001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0b3e0005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0b3e6000, newTargetedSender_) }
        _targetedSenders.push(newTargetedSender_);
    }

    function targetInterface(FuzzInterface memory newTargetedInterface_) internal {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0b3f0000, 1037618711359) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0b3f0001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0b3f0005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0b3f6000, newTargetedInterface_) }
        _targetedInterfaces.push(newTargetedInterface_);
    }

    // Functions for forge:
    // These are called by forge to run invariant tests and don't need to be called in tests.

    function excludeArtifacts() public view returns (string[] memory excludedArtifacts_) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a600000, 1037618711136) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a600001, 0) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a600004, 0) }
        excludedArtifacts_ = _excludedArtifacts;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000200d5,0)}
    }

    function excludeContracts() public view returns (address[] memory excludedContracts_) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a6b0000, 1037618711147) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a6b0001, 0) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a6b0004, 0) }
        excludedContracts_ = _excludedContracts;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000200d6,0)}
    }

    function excludeSelectors() public view returns (FuzzSelector[] memory excludedSelectors_) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a670000, 1037618711143) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a670001, 0) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a670004, 0) }
        excludedSelectors_ = _excludedSelectors;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000200d7,0)}
    }

    function excludeSenders() public view returns (address[] memory excludedSenders_) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a590000, 1037618711129) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a590001, 0) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a590004, 0) }
        excludedSenders_ = _excludedSenders;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000200d8,0)}
    }

    function targetArtifacts() public view returns (string[] memory targetedArtifacts_) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a690000, 1037618711145) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a690001, 0) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a690004, 0) }
        targetedArtifacts_ = _targetedArtifacts;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000200d9,0)}
    }

    function targetArtifactSelectors() public view returns (FuzzArtifactSelector[] memory targetedArtifactSelectors_) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a5a0000, 1037618711130) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a5a0001, 0) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a5a0004, 0) }
        targetedArtifactSelectors_ = _targetedArtifactSelectors;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000200da,0)}
    }

    function targetContracts() public view returns (address[] memory targetedContracts_) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a6d0000, 1037618711149) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a6d0001, 0) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a6d0004, 0) }
        targetedContracts_ = _targetedContracts;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000200db,0)}
    }

    function targetSelectors() public view returns (FuzzSelector[] memory targetedSelectors_) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a650000, 1037618711141) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a650001, 0) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a650004, 0) }
        targetedSelectors_ = _targetedSelectors;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000200dc,0)}
    }

    function targetSenders() public view returns (address[] memory targetedSenders_) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a5c0000, 1037618711132) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a5c0001, 0) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a5c0004, 0) }
        targetedSenders_ = _targetedSenders;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000200dd,0)}
    }

    function targetInterfaces() public view returns (FuzzInterface[] memory targetedInterfaces_) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a640000, 1037618711140) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a640001, 0) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0a640004, 0) }
        targetedInterfaces_ = _targetedInterfaces;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000200de,0)}
    }
}
