// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

contract SavingAccounts {
    struct SavingAccount {
        uint256 balance;
        address owner;
        uint256 creationTime;
        uint256 lockPeriod;
    }

    mapping(address => SavingAccount[]) savings;

    modifier validIndex(uint256 index) {
        require(
            index >= 0 && index < savings[msg.sender].length,
            "Invalid Index"
        );
        _;
    }

    function seeAccounts() public view returns (uint256 length) {
        return savings[msg.sender].length;
    }

    function createSavingPlan(uint256 periodLimit) public payable {
        require(
            msg.value > 0,
            "Must send some Ether to create a saving account"
        );

        savings[msg.sender].push(
            SavingAccount({
                balance: msg.value,
                owner: msg.sender,
                creationTime: block.timestamp,
                lockPeriod: periodLimit
            })
        );
    }

    function viewSavingsPlan(uint256 index)
        public
        view
        validIndex(index)
        returns (uint256 balance)
    {
        return (savings[msg.sender][index].balance);
    }

    function withdrawFunds(uint256 index) public validIndex(index) {
        SavingAccount storage saving = savings[msg.sender][index];
        uint256 timeForLockong = saving.creationTime + saving.lockPeriod;

        require(timeForLockong < block.timestamp, "Saving is stil locked");

        uint256 amount = saving.balance;
        saving.balance = 0;
        payable(msg.sender).transfer(amount);
    }
}
