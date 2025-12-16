// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.28;

import "../interfaces/IStakeManager.sol";

/* solhint-disable avoid-low-level-calls */
/* solhint-disable not-rely-on-time */

/**
 * Manage deposits and stakes.
 * Deposit is just a balance used to pay for UserOperations (either by a paymaster or an account).
 * Stake is value locked for at least "unstakeDelay" by a paymaster.
 */
abstract contract StakeManager is IStakeManager {
    /// maps paymaster to their deposits and stakes
    mapping(address => DepositInfo) private deposits;

    /// @inheritdoc IStakeManager
    function getDepositInfo(
        address account
    ) external view returns (DepositInfo memory info) {
        return deposits[account];
    }

    /**
     * Internal method to return just the stake info.
     * @param addr - The account to query.
     */
    function _getStakeInfo(
        address addr
    ) internal view returns (StakeInfo memory info) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00580000, 1037618708568) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00580001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00580005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00586000, addr) }
        DepositInfo storage depositInfo = deposits[addr];assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00010082,0)}
        info.stake = depositInfo.stake;uint256 certora_local142 = info.stake;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0000008e,certora_local142)}
        info.unstakeDelaySec = depositInfo.unstakeDelaySec;uint256 certora_local143 = info.unstakeDelaySec;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0000008f,certora_local143)}
    }

    /// @inheritdoc IStakeManager
    function balanceOf(address account) public view returns (uint256) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00550000, 1037618708565) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00550001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00550005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00556000, account) }
        return deposits[account].deposit;
    }

    receive() external payable {
        depositTo(msg.sender);
    }


    /**
     * Increments an account's deposit.
     * @param account - The account to increment.
     * @param amount  - The amount to increment by.
     * @return the updated deposit of this account
     */
    function _incrementDeposit(address account, uint256 amount) internal returns (uint256) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00590000, 1037618708569) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00590001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00590005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00596001, amount) }
        unchecked {
            DepositInfo storage info = deposits[account];
            uint256 newAmount = info.deposit + amount;
            info.deposit = newAmount;
            return newAmount;
        }
    }

    /**
     * Try to decrement the account's deposit.
     * @param account - The account to decrement.
     * @param amount  - The amount to decrement by.
     * @return true if the decrement succeeded (that is, previous balance was at least that amount)
     */
    function _tryDecrementDeposit(address account, uint256 amount) internal returns(bool) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff005a0000, 1037618708570) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff005a0001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff005a0005, 9) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff005a6001, amount) }
        unchecked {
            DepositInfo storage info = deposits[account];
            uint256 currentDeposit = info.deposit;
            if (currentDeposit < amount) {
                return false;
            }
            info.deposit = currentDeposit - amount;
            return true;
        }
    }

    /// @inheritdoc IStakeManager
    function depositTo(address account) public virtual payable {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00560000, 1037618708566) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00560001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00560005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00566000, account) }
        uint256 newDeposit = _incrementDeposit(account, msg.value);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000083,newDeposit)}
        emit Deposited(account, newDeposit);
    }

    /// @inheritdoc IStakeManager
    function addStake(uint32 unstakeDelaySec) external payable {
        DepositInfo storage info = deposits[msg.sender];assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00010084,0)}
        require(unstakeDelaySec > 0, "must specify unstake delay");
        require(
            unstakeDelaySec >= info.unstakeDelaySec,
            "cannot decrease unstake time"
        );
        uint256 stake = info.stake + msg.value;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000085,stake)}
        require(stake > 0, "no stake specified");
        require(stake <= type(uint112).max, "stake overflow");
        deposits[msg.sender] = DepositInfo(
            info.deposit,
            true,
            uint112(stake),
            unstakeDelaySec,
            0
        );
        emit StakeLocked(msg.sender, stake, unstakeDelaySec);
    }

    /// @inheritdoc IStakeManager
    function unlockStake() external {
        DepositInfo storage info = deposits[msg.sender];assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00010086,0)}
        require(info.unstakeDelaySec != 0, "not staked");
        require(info.staked, "already unstaking");
        uint48 withdrawTime = uint48(block.timestamp) + info.unstakeDelaySec;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000087,withdrawTime)}
        info.withdrawTime = withdrawTime;uint48 certora_local144 = info.withdrawTime;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000090,certora_local144)}
        info.staked = false;bool certora_local145 = info.staked;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000091,certora_local145)}
        emit StakeUnlocked(msg.sender, withdrawTime);
    }

    /// @inheritdoc IStakeManager
    function withdrawStake(address payable withdrawAddress) external {
        DepositInfo storage info = deposits[msg.sender];assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00010088,0)}
        uint256 stake = info.stake;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000089,stake)}
        require(stake > 0, "No stake to withdraw");
        require(info.withdrawTime > 0, "must call unlockStake() first");
        require(
            info.withdrawTime <= block.timestamp,
            "Stake withdrawal is not due"
        );
        info.unstakeDelaySec = 0;uint32 certora_local146 = info.unstakeDelaySec;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000092,certora_local146)}
        info.withdrawTime = 0;uint48 certora_local147 = info.withdrawTime;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000093,certora_local147)}
        info.stake = 0;uint112 certora_local148 = info.stake;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000094,certora_local148)}
        emit StakeWithdrawn(msg.sender, withdrawAddress, stake);
        (bool success,) = withdrawAddress.call{value: stake}("");assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0001008a,0)}
        require(success, "failed to withdraw stake");
    }

    /// @inheritdoc IStakeManager
    function withdrawTo(
        address payable withdrawAddress,
        uint256 withdrawAmount
    ) external {
        DepositInfo storage info = deposits[msg.sender];assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0001008b,0)}
        uint256 currentDeposit = info.deposit;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0000008c,currentDeposit)}
        require(withdrawAmount <= currentDeposit, "Withdraw amount too large");
        info.deposit = currentDeposit - withdrawAmount;uint256 certora_local149 = info.deposit;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000095,certora_local149)}
        emit Withdrawn(msg.sender, withdrawAddress, withdrawAmount);
        (bool success,) = withdrawAddress.call{value: withdrawAmount}("");assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0001008d,0)}
        require(success, "failed to withdraw");
    }
}
