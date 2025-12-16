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

    function excludeContract(address newExcludedContract_) internal {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff057a0000, 1037618709882) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff057a0001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff057a0005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff057a6000, newExcludedContract_) }
        _excludedContracts.push(newExcludedContract_);
    }

    function excludeSelector(FuzzSelector memory newExcludedSelector_) internal {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff057b0000, 1037618709883) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff057b0001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff057b0005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff057b6000, newExcludedSelector_) }
        _excludedSelectors.push(newExcludedSelector_);
    }

    function excludeSender(address newExcludedSender_) internal {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff057d0000, 1037618709885) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff057d0001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff057d0005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff057d6000, newExcludedSender_) }
        _excludedSenders.push(newExcludedSender_);
    }

    function excludeArtifact(string memory newExcludedArtifact_) internal {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff057e0000, 1037618709886) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff057e0001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff057e0005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff057e6000, newExcludedArtifact_) }
        _excludedArtifacts.push(newExcludedArtifact_);
    }

    function targetArtifact(string memory newTargetedArtifact_) internal {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff057c0000, 1037618709884) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff057c0001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff057c0005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff057c6000, newTargetedArtifact_) }
        _targetedArtifacts.push(newTargetedArtifact_);
    }

    function targetArtifactSelector(FuzzArtifactSelector memory newTargetedArtifactSelector_) internal {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff057f0000, 1037618709887) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff057f0001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff057f0005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff057f6000, newTargetedArtifactSelector_) }
        _targetedArtifactSelectors.push(newTargetedArtifactSelector_);
    }

    function targetContract(address newTargetedContract_) internal {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05800000, 1037618709888) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05800001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05800005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05806000, newTargetedContract_) }
        _targetedContracts.push(newTargetedContract_);
    }

    function targetSelector(FuzzSelector memory newTargetedSelector_) internal {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05810000, 1037618709889) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05810001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05810005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05816000, newTargetedSelector_) }
        _targetedSelectors.push(newTargetedSelector_);
    }

    function targetSender(address newTargetedSender_) internal {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05820000, 1037618709890) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05820001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05820005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05826000, newTargetedSender_) }
        _targetedSenders.push(newTargetedSender_);
    }

    function targetInterface(FuzzInterface memory newTargetedInterface_) internal {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05830000, 1037618709891) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05830001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05830005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff05836000, newTargetedInterface_) }
        _targetedInterfaces.push(newTargetedInterface_);
    }

    // Functions for forge:
    // These are called by forge to run invariant tests and don't need to be called in tests.

    function excludeArtifacts() public view returns (string[] memory excludedArtifacts_) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04950000, 1037618709653) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04950001, 0) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04950004, 0) }
        excludedArtifacts_ = _excludedArtifacts;
    }

    function excludeContracts() public view returns (address[] memory excludedContracts_) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04ab0000, 1037618709675) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04ab0001, 0) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04ab0004, 0) }
        excludedContracts_ = _excludedContracts;
    }

    function excludeSelectors() public view returns (FuzzSelector[] memory excludedSelectors_) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04a40000, 1037618709668) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04a40001, 0) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04a40004, 0) }
        excludedSelectors_ = _excludedSelectors;
    }

    function excludeSenders() public view returns (address[] memory excludedSenders_) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04910000, 1037618709649) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04910001, 0) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04910004, 0) }
        excludedSenders_ = _excludedSenders;
    }

    function targetArtifacts() public view returns (string[] memory targetedArtifacts_) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04a90000, 1037618709673) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04a90001, 0) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04a90004, 0) }
        targetedArtifacts_ = _targetedArtifacts;
    }

    function targetArtifactSelectors() public view returns (FuzzArtifactSelector[] memory targetedArtifactSelectors_) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04920000, 1037618709650) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04920001, 0) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04920004, 0) }
        targetedArtifactSelectors_ = _targetedArtifactSelectors;
    }

    function targetContracts() public view returns (address[] memory targetedContracts_) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04ad0000, 1037618709677) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04ad0001, 0) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04ad0004, 0) }
        targetedContracts_ = _targetedContracts;
    }

    function targetSelectors() public view returns (FuzzSelector[] memory targetedSelectors_) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff049d0000, 1037618709661) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff049d0001, 0) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff049d0004, 0) }
        targetedSelectors_ = _targetedSelectors;
    }

    function targetSenders() public view returns (address[] memory targetedSenders_) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04930000, 1037618709651) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04930001, 0) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff04930004, 0) }
        targetedSenders_ = _targetedSenders;
    }

    function targetInterfaces() public view returns (FuzzInterface[] memory targetedInterfaces_) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff049c0000, 1037618709660) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff049c0001, 0) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff049c0004, 0) }
        targetedInterfaces_ = _targetedInterfaces;
    }
}
