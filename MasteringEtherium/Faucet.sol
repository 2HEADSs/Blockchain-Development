// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

contract Faucet {
    receive() external payable {}

    function withdraw(uint256 withdraw_amount) public {
        require(withdraw_amount <= 100000000000000000);
    }
}
