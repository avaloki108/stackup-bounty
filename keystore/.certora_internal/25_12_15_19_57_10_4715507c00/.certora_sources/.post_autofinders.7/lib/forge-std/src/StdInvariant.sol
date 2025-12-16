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

    function excludeContract(address newExcludedContract_) internal {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0cd70000, 1037618711767) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0cd70001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0cd70005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0cd76000, newExcludedContract_) }
        _excludedContracts.push(newExcludedContract_);
    }

    function excludeSelector(FuzzSelector memory newExcludedSelector_) internal {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0cd80000, 1037618711768) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0cd80001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0cd80005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0cd86000, newExcludedSelector_) }
        _excludedSelectors.push(newExcludedSelector_);
    }

    function excludeSender(address newExcludedSender_) internal {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0cda0000, 1037618711770) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0cda0001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0cda0005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0cda6000, newExcludedSender_) }
        _excludedSenders.push(newExcludedSender_);
    }

    function excludeArtifact(string memory newExcludedArtifact_) internal {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0cdb0000, 1037618711771) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0cdb0001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0cdb0005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0cdb6000, newExcludedArtifact_) }
        _excludedArtifacts.push(newExcludedArtifact_);
    }

    function targetArtifact(string memory newTargetedArtifact_) internal {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0cd90000, 1037618711769) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0cd90001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0cd90005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0cd96000, newTargetedArtifact_) }
        _targetedArtifacts.push(newTargetedArtifact_);
    }

    function targetArtifactSelector(FuzzArtifactSelector memory newTargetedArtifactSelector_) internal {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0cdc0000, 1037618711772) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0cdc0001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0cdc0005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0cdc6000, newTargetedArtifactSelector_) }
        _targetedArtifactSelectors.push(newTargetedArtifactSelector_);
    }

    function targetContract(address newTargetedContract_) internal {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0cdd0000, 1037618711773) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0cdd0001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0cdd0005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0cdd6000, newTargetedContract_) }
        _targetedContracts.push(newTargetedContract_);
    }

    function targetSelector(FuzzSelector memory newTargetedSelector_) internal {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0cde0000, 1037618711774) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0cde0001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0cde0005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0cde6000, newTargetedSelector_) }
        _targetedSelectors.push(newTargetedSelector_);
    }

    function targetSender(address newTargetedSender_) internal {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0cdf0000, 1037618711775) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0cdf0001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0cdf0005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0cdf6000, newTargetedSender_) }
        _targetedSenders.push(newTargetedSender_);
    }

    function targetInterface(FuzzInterface memory newTargetedInterface_) internal {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ce00000, 1037618711776) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ce00001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ce00005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0ce06000, newTargetedInterface_) }
        _targetedInterfaces.push(newTargetedInterface_);
    }

    // Functions for forge:
    // These are called by forge to run invariant tests and don't need to be called in tests.

    function excludeArtifacts() public view returns (string[] memory excludedArtifacts_) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c080000, 1037618711560) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c080001, 0) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c080004, 0) }
        excludedArtifacts_ = _excludedArtifacts;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000200c3,0)}
    }

    function excludeContracts() public view returns (address[] memory excludedContracts_) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c0b0000, 1037618711563) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c0b0001, 0) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c0b0004, 0) }
        excludedContracts_ = _excludedContracts;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000200c4,0)}
    }

    function excludeSelectors() public view returns (FuzzSelector[] memory excludedSelectors_) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c030000, 1037618711555) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c030001, 0) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c030004, 0) }
        excludedSelectors_ = _excludedSelectors;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000200c5,0)}
    }

    function excludeSenders() public view returns (address[] memory excludedSenders_) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c020000, 1037618711554) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c020001, 0) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c020004, 0) }
        excludedSenders_ = _excludedSenders;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000200c6,0)}
    }

    function targetArtifacts() public view returns (string[] memory targetedArtifacts_) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0bfe0000, 1037618711550) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0bfe0001, 0) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0bfe0004, 0) }
        targetedArtifacts_ = _targetedArtifacts;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000200c7,0)}
    }

    function targetArtifactSelectors() public view returns (FuzzArtifactSelector[] memory targetedArtifactSelectors_) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c040000, 1037618711556) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c040001, 0) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c040004, 0) }
        targetedArtifactSelectors_ = _targetedArtifactSelectors;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000200c8,0)}
    }

    function targetContracts() public view returns (address[] memory targetedContracts_) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c0d0000, 1037618711565) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c0d0001, 0) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c0d0004, 0) }
        targetedContracts_ = _targetedContracts;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000200c9,0)}
    }

    function targetSelectors() public view returns (FuzzSelector[] memory targetedSelectors_) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c000000, 1037618711552) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c000001, 0) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c000004, 0) }
        targetedSelectors_ = _targetedSelectors;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000200ca,0)}
    }

    function targetSenders() public view returns (address[] memory targetedSenders_) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c050000, 1037618711557) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c050001, 0) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c050004, 0) }
        targetedSenders_ = _targetedSenders;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000200cb,0)}
    }

    function targetInterfaces() public view returns (FuzzInterface[] memory targetedInterfaces_) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c010000, 1037618711553) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c010001, 0) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0c010004, 0) }
        targetedInterfaces_ = _targetedInterfaces;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000200cc,0)}
    }
}
