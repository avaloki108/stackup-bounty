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

    function excludeContract(address newExcludedContract_) internal {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09e60000, 1037618711014) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09e60001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09e60005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09e66000, newExcludedContract_) }
        _excludedContracts.push(newExcludedContract_);
    }

    function excludeSelector(FuzzSelector memory newExcludedSelector_) internal {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09e70000, 1037618711015) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09e70001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09e70005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09e76000, newExcludedSelector_) }
        _excludedSelectors.push(newExcludedSelector_);
    }

    function excludeSender(address newExcludedSender_) internal {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09e90000, 1037618711017) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09e90001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09e90005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09e96000, newExcludedSender_) }
        _excludedSenders.push(newExcludedSender_);
    }

    function excludeArtifact(string memory newExcludedArtifact_) internal {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09ea0000, 1037618711018) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09ea0001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09ea0005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09ea6000, newExcludedArtifact_) }
        _excludedArtifacts.push(newExcludedArtifact_);
    }

    function targetArtifact(string memory newTargetedArtifact_) internal {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09e80000, 1037618711016) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09e80001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09e80005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09e86000, newTargetedArtifact_) }
        _targetedArtifacts.push(newTargetedArtifact_);
    }

    function targetArtifactSelector(FuzzArtifactSelector memory newTargetedArtifactSelector_) internal {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09eb0000, 1037618711019) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09eb0001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09eb0005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09eb6000, newTargetedArtifactSelector_) }
        _targetedArtifactSelectors.push(newTargetedArtifactSelector_);
    }

    function targetContract(address newTargetedContract_) internal {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09ec0000, 1037618711020) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09ec0001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09ec0005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09ec6000, newTargetedContract_) }
        _targetedContracts.push(newTargetedContract_);
    }

    function targetSelector(FuzzSelector memory newTargetedSelector_) internal {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09ed0000, 1037618711021) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09ed0001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09ed0005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09ed6000, newTargetedSelector_) }
        _targetedSelectors.push(newTargetedSelector_);
    }

    function targetSender(address newTargetedSender_) internal {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09ee0000, 1037618711022) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09ee0001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09ee0005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09ee6000, newTargetedSender_) }
        _targetedSenders.push(newTargetedSender_);
    }

    function targetInterface(FuzzInterface memory newTargetedInterface_) internal {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09ef0000, 1037618711023) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09ef0001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09ef0005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09ef6000, newTargetedInterface_) }
        _targetedInterfaces.push(newTargetedInterface_);
    }

    // Functions for forge:
    // These are called by forge to run invariant tests and don't need to be called in tests.

    function excludeArtifacts() public view returns (string[] memory excludedArtifacts_) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09190000, 1037618710809) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09190001, 0) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09190004, 0) }
        excludedArtifacts_ = _excludedArtifacts;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00020089,0)}
    }

    function excludeContracts() public view returns (address[] memory excludedContracts_) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff091a0000, 1037618710810) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff091a0001, 0) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff091a0004, 0) }
        excludedContracts_ = _excludedContracts;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0002008a,0)}
    }

    function excludeSelectors() public view returns (FuzzSelector[] memory excludedSelectors_) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09140000, 1037618710804) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09140001, 0) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09140004, 0) }
        excludedSelectors_ = _excludedSelectors;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0002008b,0)}
    }

    function excludeSenders() public view returns (address[] memory excludedSenders_) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09130000, 1037618710803) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09130001, 0) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09130004, 0) }
        excludedSenders_ = _excludedSenders;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0002008c,0)}
    }

    function targetArtifacts() public view returns (string[] memory targetedArtifacts_) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff090e0000, 1037618710798) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff090e0001, 0) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff090e0004, 0) }
        targetedArtifacts_ = _targetedArtifacts;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0002008d,0)}
    }

    function targetArtifactSelectors() public view returns (FuzzArtifactSelector[] memory targetedArtifactSelectors_) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09150000, 1037618710805) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09150001, 0) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09150004, 0) }
        targetedArtifactSelectors_ = _targetedArtifactSelectors;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0002008e,0)}
    }

    function targetContracts() public view returns (address[] memory targetedContracts_) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff091c0000, 1037618710812) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff091c0001, 0) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff091c0004, 0) }
        targetedContracts_ = _targetedContracts;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0002008f,0)}
    }

    function targetSelectors() public view returns (FuzzSelector[] memory targetedSelectors_) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09110000, 1037618710801) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09110001, 0) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09110004, 0) }
        targetedSelectors_ = _targetedSelectors;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00020090,0)}
    }

    function targetSenders() public view returns (address[] memory targetedSenders_) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09160000, 1037618710806) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09160001, 0) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff09160004, 0) }
        targetedSenders_ = _targetedSenders;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00020091,0)}
    }

    function targetInterfaces() public view returns (FuzzInterface[] memory targetedInterfaces_) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff090f0000, 1037618710799) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff090f0001, 0) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff090f0004, 0) }
        targetedInterfaces_ = _targetedInterfaces;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00020092,0)}
    }
}
