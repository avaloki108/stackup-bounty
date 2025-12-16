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

    function excludeContract(address newExcludedContract_) internal {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08780000, 1037618710648) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08780001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08780005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08786000, newExcludedContract_) }
        _excludedContracts.push(newExcludedContract_);
    }

    function excludeSelector(FuzzSelector memory newExcludedSelector_) internal {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08790000, 1037618710649) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08790001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08790005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08796000, newExcludedSelector_) }
        _excludedSelectors.push(newExcludedSelector_);
    }

    function excludeSender(address newExcludedSender_) internal {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff087b0000, 1037618710651) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff087b0001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff087b0005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff087b6000, newExcludedSender_) }
        _excludedSenders.push(newExcludedSender_);
    }

    function excludeArtifact(string memory newExcludedArtifact_) internal {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff087c0000, 1037618710652) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff087c0001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff087c0005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff087c6000, newExcludedArtifact_) }
        _excludedArtifacts.push(newExcludedArtifact_);
    }

    function targetArtifact(string memory newTargetedArtifact_) internal {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff087a0000, 1037618710650) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff087a0001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff087a0005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff087a6000, newTargetedArtifact_) }
        _targetedArtifacts.push(newTargetedArtifact_);
    }

    function targetArtifactSelector(FuzzArtifactSelector memory newTargetedArtifactSelector_) internal {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff087d0000, 1037618710653) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff087d0001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff087d0005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff087d6000, newTargetedArtifactSelector_) }
        _targetedArtifactSelectors.push(newTargetedArtifactSelector_);
    }

    function targetContract(address newTargetedContract_) internal {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff087e0000, 1037618710654) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff087e0001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff087e0005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff087e6000, newTargetedContract_) }
        _targetedContracts.push(newTargetedContract_);
    }

    function targetSelector(FuzzSelector memory newTargetedSelector_) internal {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff087f0000, 1037618710655) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff087f0001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff087f0005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff087f6000, newTargetedSelector_) }
        _targetedSelectors.push(newTargetedSelector_);
    }

    function targetSender(address newTargetedSender_) internal {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08800000, 1037618710656) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08800001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08800005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08806000, newTargetedSender_) }
        _targetedSenders.push(newTargetedSender_);
    }

    function targetInterface(FuzzInterface memory newTargetedInterface_) internal {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08810000, 1037618710657) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08810001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08810005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff08816000, newTargetedInterface_) }
        _targetedInterfaces.push(newTargetedInterface_);
    }

    // Functions for forge:
    // These are called by forge to run invariant tests and don't need to be called in tests.

    function excludeArtifacts() public view returns (string[] memory excludedArtifacts_) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07aa0000, 1037618710442) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07aa0001, 0) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07aa0004, 0) }
        excludedArtifacts_ = _excludedArtifacts;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000200b3,0)}
    }

    function excludeContracts() public view returns (address[] memory excludedContracts_) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07ad0000, 1037618710445) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07ad0001, 0) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07ad0004, 0) }
        excludedContracts_ = _excludedContracts;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000200b4,0)}
    }

    function excludeSelectors() public view returns (FuzzSelector[] memory excludedSelectors_) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07a40000, 1037618710436) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07a40001, 0) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07a40004, 0) }
        excludedSelectors_ = _excludedSelectors;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000200b5,0)}
    }

    function excludeSenders() public view returns (address[] memory excludedSenders_) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07a30000, 1037618710435) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07a30001, 0) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07a30004, 0) }
        excludedSenders_ = _excludedSenders;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000200b6,0)}
    }

    function targetArtifacts() public view returns (string[] memory targetedArtifacts_) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07ab0000, 1037618710443) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07ab0001, 0) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07ab0004, 0) }
        targetedArtifacts_ = _targetedArtifacts;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000200b7,0)}
    }

    function targetArtifactSelectors() public view returns (FuzzArtifactSelector[] memory targetedArtifactSelectors_) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07a60000, 1037618710438) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07a60001, 0) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07a60004, 0) }
        targetedArtifactSelectors_ = _targetedArtifactSelectors;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000200b8,0)}
    }

    function targetContracts() public view returns (address[] memory targetedContracts_) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07ae0000, 1037618710446) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07ae0001, 0) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07ae0004, 0) }
        targetedContracts_ = _targetedContracts;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000200b9,0)}
    }

    function targetSelectors() public view returns (FuzzSelector[] memory targetedSelectors_) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff079f0000, 1037618710431) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff079f0001, 0) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff079f0004, 0) }
        targetedSelectors_ = _targetedSelectors;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000200ba,0)}
    }

    function targetSenders() public view returns (address[] memory targetedSenders_) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07a70000, 1037618710439) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07a70001, 0) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07a70004, 0) }
        targetedSenders_ = _targetedSenders;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000200bb,0)}
    }

    function targetInterfaces() public view returns (FuzzInterface[] memory targetedInterfaces_) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07a00000, 1037618710432) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07a00001, 0) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07a00004, 0) }
        targetedInterfaces_ = _targetedInterfaces;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000200bc,0)}
    }
}
