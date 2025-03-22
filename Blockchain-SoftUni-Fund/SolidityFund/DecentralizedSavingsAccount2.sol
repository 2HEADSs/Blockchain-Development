// SPDX-License-Identifier: MIT
pragma solidity 0.8.29;

struct SavingsAccount {
    uint256 amount;
    address owner;
    uint256 creationTime;
    uint256 lockPeriod;
}

error NoEthersSend();
error YouDoNotHaveAnyPlan();
error NotCorrectIndexOfSavingPlans();
error LockPeriodIsNotOver();
error SavingPlanIsAlreadyWithdraw();

contract DecentralizedSavingsAccount2 {
    mapping(address => SavingsAccount[]) public savingsStorage;

    modifier hasPlans() {
        if (savingsStorage[msg.sender].length == 0) {
            revert YouDoNotHaveAnyPlan();
        }
        _;
    }

    modifier validIndex(uint256 _index) {
        if (_index >= savingsStorage[msg.sender].length) {
            revert NotCorrectIndexOfSavingPlans();
        }
        _;
    }

    function createSavingsPlan(uint256 _lockPeriod) external payable {
        if (msg.value <= 0) {
            revert NoEthersSend();
        }

        savingsStorage[msg.sender].push(
            SavingsAccount({
                amount: msg.value,
                owner: msg.sender,
                creationTime: block.timestamp,
                lockPeriod: block.timestamp + _lockPeriod
            })
        );
    }

    function viewSavingsPlan(
        uint256 _index
    )
        public
        view
        hasPlans
        validIndex(_index)
        returns (
            uint256 amount,
            address owner,
            uint256 creationTime,
            uint256 lockPeriod
        )
    {
        SavingsAccount memory saving = savingsStorage[msg.sender][_index];
        return (
            saving.amount,
            saving.owner,
            saving.creationTime,
            saving.lockPeriod
        );
    }

    function withdrawFunds(
        uint256 _index
    ) external hasPlans validIndex(_index) {
        SavingsAccount storage saving = savingsStorage[msg.sender][_index];

        if (saving.lockPeriod > block.timestamp) {
            revert LockPeriodIsNotOver();
        }

        uint256 amount = saving.amount;
        if (amount == 0) {
            revert SavingPlanIsAlreadyWithdraw();
        }
        saving.amount = 0;
        payable(msg.sender).transfer(amount);
    }
}
