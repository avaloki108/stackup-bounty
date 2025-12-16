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

    function excludeContract(address newExcludedContract_) internal {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e890000, 1037618712201) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e890001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e890005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e896000, newExcludedContract_) }
        _excludedContracts.push(newExcludedContract_);
    }

    function excludeSelector(FuzzSelector memory newExcludedSelector_) internal {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e8a0000, 1037618712202) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e8a0001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e8a0005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e8a6000, newExcludedSelector_) }
        _excludedSelectors.push(newExcludedSelector_);
    }

    function excludeSender(address newExcludedSender_) internal {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e8c0000, 1037618712204) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e8c0001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e8c0005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e8c6000, newExcludedSender_) }
        _excludedSenders.push(newExcludedSender_);
    }

    function excludeArtifact(string memory newExcludedArtifact_) internal {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e8d0000, 1037618712205) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e8d0001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e8d0005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e8d6000, newExcludedArtifact_) }
        _excludedArtifacts.push(newExcludedArtifact_);
    }

    function targetArtifact(string memory newTargetedArtifact_) internal {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e8b0000, 1037618712203) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e8b0001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e8b0005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e8b6000, newTargetedArtifact_) }
        _targetedArtifacts.push(newTargetedArtifact_);
    }

    function targetArtifactSelector(FuzzArtifactSelector memory newTargetedArtifactSelector_) internal {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e8e0000, 1037618712206) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e8e0001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e8e0005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e8e6000, newTargetedArtifactSelector_) }
        _targetedArtifactSelectors.push(newTargetedArtifactSelector_);
    }

    function targetContract(address newTargetedContract_) internal {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e8f0000, 1037618712207) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e8f0001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e8f0005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e8f6000, newTargetedContract_) }
        _targetedContracts.push(newTargetedContract_);
    }

    function targetSelector(FuzzSelector memory newTargetedSelector_) internal {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e900000, 1037618712208) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e900001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e900005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e906000, newTargetedSelector_) }
        _targetedSelectors.push(newTargetedSelector_);
    }

    function targetSender(address newTargetedSender_) internal {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e910000, 1037618712209) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e910001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e910005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e916000, newTargetedSender_) }
        _targetedSenders.push(newTargetedSender_);
    }

    function targetInterface(FuzzInterface memory newTargetedInterface_) internal {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e920000, 1037618712210) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e920001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e920005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0e926000, newTargetedInterface_) }
        _targetedInterfaces.push(newTargetedInterface_);
    }

    // Functions for forge:
    // These are called by forge to run invariant tests and don't need to be called in tests.

    function excludeArtifacts() public view returns (string[] memory excludedArtifacts_) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0dbb0000, 1037618711995) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0dbb0001, 0) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0dbb0004, 0) }
        excludedArtifacts_ = _excludedArtifacts;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000200b1,0)}
    }

    function excludeContracts() public view returns (address[] memory excludedContracts_) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0dbc0000, 1037618711996) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0dbc0001, 0) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0dbc0004, 0) }
        excludedContracts_ = _excludedContracts;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000200b2,0)}
    }

    function excludeSelectors() public view returns (FuzzSelector[] memory excludedSelectors_) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0db60000, 1037618711990) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0db60001, 0) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0db60004, 0) }
        excludedSelectors_ = _excludedSelectors;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000200b3,0)}
    }

    function excludeSenders() public view returns (address[] memory excludedSenders_) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0db50000, 1037618711989) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0db50001, 0) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0db50004, 0) }
        excludedSenders_ = _excludedSenders;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000200b4,0)}
    }

    function targetArtifacts() public view returns (string[] memory targetedArtifacts_) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0db10000, 1037618711985) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0db10001, 0) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0db10004, 0) }
        targetedArtifacts_ = _targetedArtifacts;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000200b5,0)}
    }

    function targetArtifactSelectors() public view returns (FuzzArtifactSelector[] memory targetedArtifactSelectors_) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0db70000, 1037618711991) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0db70001, 0) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0db70004, 0) }
        targetedArtifactSelectors_ = _targetedArtifactSelectors;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000200b6,0)}
    }

    function targetContracts() public view returns (address[] memory targetedContracts_) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0dbf0000, 1037618711999) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0dbf0001, 0) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0dbf0004, 0) }
        targetedContracts_ = _targetedContracts;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000200b7,0)}
    }

    function targetSelectors() public view returns (FuzzSelector[] memory targetedSelectors_) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0db30000, 1037618711987) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0db30001, 0) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0db30004, 0) }
        targetedSelectors_ = _targetedSelectors;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000200b8,0)}
    }

    function targetSenders() public view returns (address[] memory targetedSenders_) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0db80000, 1037618711992) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0db80001, 0) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0db80004, 0) }
        targetedSenders_ = _targetedSenders;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000200b9,0)}
    }

    function targetInterfaces() public view returns (FuzzInterface[] memory targetedInterfaces_) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0db40000, 1037618711988) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0db40001, 0) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff0db40004, 0) }
        targetedInterfaces_ = _targetedInterfaces;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000200ba,0)}
    }
}
