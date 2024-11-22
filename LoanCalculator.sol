// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

contract LoanCalculator {
    error InvalidInterestRate(string message);
    error InvalidLoanPeriod(string message);
    uint256 total;

    function calculateTotalPayable(
        uint256 principal,
        uint256 InterestRate,
        uint256 loanPeriodInYears
    ) public returns (uint256) {
        if (InterestRate < 0 || InterestRate > 100) {
            revert InvalidInterestRate(
                "Interest rate should be between 0 and 100"
            );
        }

        if (loanPeriodInYears < 1) {
            revert InvalidLoanPeriod("Loan period should be one year minimum");
        }

        total =
            principal +
            (principal * InterestRate * loanPeriodInYears) /
            100;
        return total;
    }
}
