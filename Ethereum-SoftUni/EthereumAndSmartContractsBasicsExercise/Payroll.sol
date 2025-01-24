// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

contract Payroll {
    function calculateCompoundInterest(uint256 salary, uint256 rating)
        public
        pure
        returns (uint256)
    {
        uint256 paycheck = 0;
        if (rating > 8 && rating <= 10) {
            paycheck = salary + (salary / 10);
        } else if (rating > 10) {
            revert("Rating should be between 0-10");
        }

        return paycheck;
    }
}
