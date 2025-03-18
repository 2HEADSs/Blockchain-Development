// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

contract LoanCalculator {
    error InvalidInterestRate(string message);
    error InvalidLoanPeriod(string message);
    uint256 public total;

    function calculateTotalPayable(
        uint256 principal,
        uint256 interestRate,
        uint256 loanPeriodInYears
    ) public returns (uint256) {
        if (interestRate < 0 || interestRate > 100) {
            revert InvalidInterestRate(
                "Interest rate should be between 0 and 100"
            );
        }

        if (loanPeriodInYears < 1) {
            revert InvalidLoanPeriod("Loan period should be one year minimum");
        }

        total =
            principal +
            (principal * interestRate * loanPeriodInYears) /
            100;
        return total;
    }
}
