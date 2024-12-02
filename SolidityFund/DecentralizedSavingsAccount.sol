// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

contract SavingAccounts{
    struct SavingAccount {
        uint256 balance;
        address owner;
        uint256 creationTime;
        uint256 lockPeriod;
    }

    mapping(address => SavingAccount[]) savings;

    function createSavingsPlan(uint256 periodLimit) public payable {
        require(msg.value >0, "Must send some Ether to create a saving account");
        savings[msg.sender].push(
            SavingAccount({
                balance: msg.value,
                owner: msg.sender,
                creationTime: block.timestamp,
                lockPeriod: periodLimit
            })
        );
    }
}
