// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

contract VotingEligibilityChecker {
    function checkEligibility(uint256 age) public pure returns (bool) {
        if (age < 18) {
            revert("Too young to vote");
        } else {
            return true;
        }
    }
}
