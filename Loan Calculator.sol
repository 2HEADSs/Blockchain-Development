// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

contract LoanCalculator {
    error interestRate(string);
    error loanPeriod(string);
    uint256 public total;

    function calculateTotalPayable(
        uint256 principal,
        uint256 InterestRate,
        uint256 loanPeriodInYears
    ) public returns (uint256) {
        if (InterestRate < 0 || InterestRate > 100) {
            revert interestRate("Interest rate should be between 0 and 100");
        }

        if (loanPeriodInYears < 1) {
            revert loanPeriod("Loan period should be one year minimum");
        }
        total =
            principal +
            (principal * InterestRate * (loanPeriodInYears / 100));
        return total;
    }
}
