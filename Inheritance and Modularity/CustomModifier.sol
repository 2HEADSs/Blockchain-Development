// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

contract Onwed {
    address payable owner;

    constructor() {
        owner = payable(msg.sender);
    }

    modifier onlyOwner() {
        //1
        require(msg.sender == owner, "Not the owner");
        _;
    }
    modifier valueBiggerThanOne(uint256 value) {
        //2
        _;
        //4
        require(msg.value >= 1, "Value should be bigger tnah 1");
    }

    function register() public payable onlyOwner valueBiggerThanOne(1 ether) {
        //3.
        //4. concrete logic
    }
}
