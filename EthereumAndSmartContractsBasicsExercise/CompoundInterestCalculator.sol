// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

contract CompoundInterestCalculator {
    function calculateTotalPayable(
        uint256 principal,
        uint256 interestRate,
        uint256 loanPeriodInYears
    ) public pure returns (uint256) {
        require(principal > 0, "Initial sum should be bigger than 0");
        require(interestRate > 0, "Rate shouldn't be negative");
        require(loanPeriodInYears > 0, "Years should be bigger than 0");
        uint256 amount = principal;

        for (uint256 i = 0; i < loanPeriodInYears; i++) {
            amount += (amount * interestRate) / 100;
        }

        return amount;
    }
}
