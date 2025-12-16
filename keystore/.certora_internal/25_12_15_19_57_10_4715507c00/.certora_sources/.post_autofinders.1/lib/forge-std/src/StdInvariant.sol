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

    function excludeContract(address newExcludedContract_) internal {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03de0000, 1037618709470) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03de0001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03de0005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03de6000, newExcludedContract_) }
        _excludedContracts.push(newExcludedContract_);
    }

    function excludeSelector(FuzzSelector memory newExcludedSelector_) internal {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03df0000, 1037618709471) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03df0001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03df0005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03df6000, newExcludedSelector_) }
        _excludedSelectors.push(newExcludedSelector_);
    }

    function excludeSender(address newExcludedSender_) internal {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03e10000, 1037618709473) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03e10001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03e10005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03e16000, newExcludedSender_) }
        _excludedSenders.push(newExcludedSender_);
    }

    function excludeArtifact(string memory newExcludedArtifact_) internal {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03e20000, 1037618709474) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03e20001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03e20005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03e26000, newExcludedArtifact_) }
        _excludedArtifacts.push(newExcludedArtifact_);
    }

    function targetArtifact(string memory newTargetedArtifact_) internal {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03e00000, 1037618709472) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03e00001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03e00005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03e06000, newTargetedArtifact_) }
        _targetedArtifacts.push(newTargetedArtifact_);
    }

    function targetArtifactSelector(FuzzArtifactSelector memory newTargetedArtifactSelector_) internal {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03e30000, 1037618709475) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03e30001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03e30005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03e36000, newTargetedArtifactSelector_) }
        _targetedArtifactSelectors.push(newTargetedArtifactSelector_);
    }

    function targetContract(address newTargetedContract_) internal {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03e40000, 1037618709476) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03e40001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03e40005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03e46000, newTargetedContract_) }
        _targetedContracts.push(newTargetedContract_);
    }

    function targetSelector(FuzzSelector memory newTargetedSelector_) internal {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03e50000, 1037618709477) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03e50001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03e50005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03e56000, newTargetedSelector_) }
        _targetedSelectors.push(newTargetedSelector_);
    }

    function targetSender(address newTargetedSender_) internal {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03e60000, 1037618709478) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03e60001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03e60005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03e66000, newTargetedSender_) }
        _targetedSenders.push(newTargetedSender_);
    }

    function targetInterface(FuzzInterface memory newTargetedInterface_) internal {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03e70000, 1037618709479) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03e70001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03e70005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03e76000, newTargetedInterface_) }
        _targetedInterfaces.push(newTargetedInterface_);
    }

    // Functions for forge:
    // These are called by forge to run invariant tests and don't need to be called in tests.

    function excludeArtifacts() public view returns (string[] memory excludedArtifacts_) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff02f90000, 1037618709241) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff02f90001, 0) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff02f90004, 0) }
        excludedArtifacts_ = _excludedArtifacts;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00020108,0)}
    }

    function excludeContracts() public view returns (address[] memory excludedContracts_) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff030f0000, 1037618709263) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff030f0001, 0) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff030f0004, 0) }
        excludedContracts_ = _excludedContracts;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00020109,0)}
    }

    function excludeSelectors() public view returns (FuzzSelector[] memory excludedSelectors_) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03080000, 1037618709256) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03080001, 0) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03080004, 0) }
        excludedSelectors_ = _excludedSelectors;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0002010a,0)}
    }

    function excludeSenders() public view returns (address[] memory excludedSenders_) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff02f50000, 1037618709237) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff02f50001, 0) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff02f50004, 0) }
        excludedSenders_ = _excludedSenders;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0002010b,0)}
    }

    function targetArtifacts() public view returns (string[] memory targetedArtifacts_) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff030d0000, 1037618709261) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff030d0001, 0) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff030d0004, 0) }
        targetedArtifacts_ = _targetedArtifacts;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0002010c,0)}
    }

    function targetArtifactSelectors() public view returns (FuzzArtifactSelector[] memory targetedArtifactSelectors_) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff02f60000, 1037618709238) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff02f60001, 0) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff02f60004, 0) }
        targetedArtifactSelectors_ = _targetedArtifactSelectors;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0002010d,0)}
    }

    function targetContracts() public view returns (address[] memory targetedContracts_) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03110000, 1037618709265) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03110001, 0) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03110004, 0) }
        targetedContracts_ = _targetedContracts;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0002010e,0)}
    }

    function targetSelectors() public view returns (FuzzSelector[] memory targetedSelectors_) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03010000, 1037618709249) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03010001, 0) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03010004, 0) }
        targetedSelectors_ = _targetedSelectors;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0002010f,0)}
    }

    function targetSenders() public view returns (address[] memory targetedSenders_) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff02f70000, 1037618709239) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff02f70001, 0) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff02f70004, 0) }
        targetedSenders_ = _targetedSenders;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00020110,0)}
    }

    function targetInterfaces() public view returns (FuzzInterface[] memory targetedInterfaces_) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03000000, 1037618709248) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03000001, 0) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff03000004, 0) }
        targetedInterfaces_ = _targetedInterfaces;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00020111,0)}
    }
}
