// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

contract PaymentProcessorBase {
    mapping(address => uint256) public balances;

    function receivePayment() public payable {
        require(msg.value > 0, "Payment must be greater than zero");
        balances[msg.sender] += msg.value;
    }

    function balanceCheck(address _addr)
        public
        view
        returns (uint256 addressBalance)
    {
        require(balances[_addr] > 0, "Address not found or balance is zero");
        return balances[_addr];
    }

    function transferToRecipient(address recipient, uint256 amount)
        public
        payable
    {
        require(balances[recipient] >= amount, "Balance not high enough");
        balances[msg.sender] -= amount;
        balances[recipient] += amount;
        (bool success, ) = recipient.call{value: amount}("");
        require(success, "Refund transfer failed");
    }
}
