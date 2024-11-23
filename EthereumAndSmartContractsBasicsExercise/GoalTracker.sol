// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

contract goalTracker {
    uint256 public goalAmount;
    uint256 public baseReward;
    uint256 public spendingTotal;
    bool public rewardClaimed;

    error RewardAlreadyClaimed(string message);
    error GoalNotMet(string message);

    function setGoalAndReward(uint256 inputGoalAmount, uint256 inputBaseReward)
        private
    {
        goalAmount = inputGoalAmount;
        baseReward = inputBaseReward;
    }

    function addSpending(uint256 input) private {
        spendingTotal += input;
    }

    function rewardClaim() private returns (uint256) {
        if (rewardClaimed) {
            revert RewardAlreadyClaimed("Reward has already been claimed");
        }
        if (spendingTotal < goalAmount) {
            revert GoalNotMet("Goal has not been met yet");
        }

        uint256 totalReward = 0;

        for (uint256 i = 0; i < 5; i++) {
            totalReward += baseReward;
        }

        rewardClaimed = true;

        return totalReward;
    }
}
