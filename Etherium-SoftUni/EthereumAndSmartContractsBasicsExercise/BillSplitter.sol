// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

contract cillSplitter {
    error splitNotEven(string message);

    function splitExpense(uint256 totalAmount, uint256 numPeople)
        private
        pure
        returns (uint256)
    {
        if (totalAmount / numPeople != 0) {
            revert splitNotEven(
                "Total amount can't be evenly devide among people"
            );
        }
        uint256 personShare = totalAmount / numPeople;
        return personShare;
    }
}
