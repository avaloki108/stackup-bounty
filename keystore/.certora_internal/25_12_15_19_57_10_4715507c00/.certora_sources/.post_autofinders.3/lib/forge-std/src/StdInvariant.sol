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

    function excludeContract(address newExcludedContract_) internal {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06fb0000, 1037618710267) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06fb0001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06fb0005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06fb6000, newExcludedContract_) }
        _excludedContracts.push(newExcludedContract_);
    }

    function excludeSelector(FuzzSelector memory newExcludedSelector_) internal {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06fc0000, 1037618710268) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06fc0001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06fc0005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06fc6000, newExcludedSelector_) }
        _excludedSelectors.push(newExcludedSelector_);
    }

    function excludeSender(address newExcludedSender_) internal {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06fe0000, 1037618710270) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06fe0001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06fe0005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06fe6000, newExcludedSender_) }
        _excludedSenders.push(newExcludedSender_);
    }

    function excludeArtifact(string memory newExcludedArtifact_) internal {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06ff0000, 1037618710271) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06ff0001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06ff0005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06ff6000, newExcludedArtifact_) }
        _excludedArtifacts.push(newExcludedArtifact_);
    }

    function targetArtifact(string memory newTargetedArtifact_) internal {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06fd0000, 1037618710269) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06fd0001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06fd0005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06fd6000, newTargetedArtifact_) }
        _targetedArtifacts.push(newTargetedArtifact_);
    }

    function targetArtifactSelector(FuzzArtifactSelector memory newTargetedArtifactSelector_) internal {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07000000, 1037618710272) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07000001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07000005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07006000, newTargetedArtifactSelector_) }
        _targetedArtifactSelectors.push(newTargetedArtifactSelector_);
    }

    function targetContract(address newTargetedContract_) internal {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07010000, 1037618710273) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07010001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07010005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07016000, newTargetedContract_) }
        _targetedContracts.push(newTargetedContract_);
    }

    function targetSelector(FuzzSelector memory newTargetedSelector_) internal {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07020000, 1037618710274) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07020001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07020005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07026000, newTargetedSelector_) }
        _targetedSelectors.push(newTargetedSelector_);
    }

    function targetSender(address newTargetedSender_) internal {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07030000, 1037618710275) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07030001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07030005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07036000, newTargetedSender_) }
        _targetedSenders.push(newTargetedSender_);
    }

    function targetInterface(FuzzInterface memory newTargetedInterface_) internal {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07040000, 1037618710276) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07040001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07040005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff07046000, newTargetedInterface_) }
        _targetedInterfaces.push(newTargetedInterface_);
    }

    // Functions for forge:
    // These are called by forge to run invariant tests and don't need to be called in tests.

    function excludeArtifacts() public view returns (string[] memory excludedArtifacts_) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06270000, 1037618710055) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06270001, 0) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06270004, 0) }
        excludedArtifacts_ = _excludedArtifacts;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000200b4,0)}
    }

    function excludeContracts() public view returns (address[] memory excludedContracts_) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06280000, 1037618710056) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06280001, 0) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06280004, 0) }
        excludedContracts_ = _excludedContracts;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000200b5,0)}
    }

    function excludeSelectors() public view returns (FuzzSelector[] memory excludedSelectors_) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06230000, 1037618710051) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06230001, 0) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06230004, 0) }
        excludedSelectors_ = _excludedSelectors;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000200b6,0)}
    }

    function excludeSenders() public view returns (address[] memory excludedSenders_) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06220000, 1037618710050) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06220001, 0) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06220004, 0) }
        excludedSenders_ = _excludedSenders;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000200b7,0)}
    }

    function targetArtifacts() public view returns (string[] memory targetedArtifacts_) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff061f0000, 1037618710047) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff061f0001, 0) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff061f0004, 0) }
        targetedArtifacts_ = _targetedArtifacts;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000200b8,0)}
    }

    function targetArtifactSelectors() public view returns (FuzzArtifactSelector[] memory targetedArtifactSelectors_) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06240000, 1037618710052) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06240001, 0) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06240004, 0) }
        targetedArtifactSelectors_ = _targetedArtifactSelectors;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000200b9,0)}
    }

    function targetContracts() public view returns (address[] memory targetedContracts_) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06290000, 1037618710057) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06290001, 0) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06290004, 0) }
        targetedContracts_ = _targetedContracts;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000200ba,0)}
    }

    function targetSelectors() public view returns (FuzzSelector[] memory targetedSelectors_) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06210000, 1037618710049) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06210001, 0) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06210004, 0) }
        targetedSelectors_ = _targetedSelectors;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000200bb,0)}
    }

    function targetSenders() public view returns (address[] memory targetedSenders_) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06250000, 1037618710053) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06250001, 0) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06250004, 0) }
        targetedSenders_ = _targetedSenders;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000200bc,0)}
    }

    function targetInterfaces() public view returns (FuzzInterface[] memory targetedInterfaces_) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06200000, 1037618710048) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06200001, 0) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff06200004, 0) }
        targetedInterfaces_ = _targetedInterfaces;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff000200bd,0)}
    }
}
