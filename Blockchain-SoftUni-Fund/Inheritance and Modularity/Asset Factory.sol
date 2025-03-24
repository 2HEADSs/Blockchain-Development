// SPDX-License-Identifier: MIT
pragma solidity 0.8.29;

contract Asset {
    constructor(
        string memory symbol,
        string memory name,
        uint256 initialSupply,
        address owner
    ) {
        symbol = symbol;
        name = name;
        initialSupply = initialSupply;
        owner = owner;
        balances[owner] = initialSupply;
    }

    mapping(address => uint256) public balances;
    event Transfer(address indexed from, address indexed to, uint256 value);

    function transfer(address to, uint256 amount)
        external
        sufficientBalance(amount)
        nonZeroAmount(amount)
        returns (bool)
    {
        balances[msg.sender] -= amount;
        balances[to] += amount;
        return true;
    }

    modifier sufficientBalance(uint256 _amount) {
        require(balances[msg.sender] >= _amount, "Insufficient Balance");
        _;
    }
    modifier nonZeroAmount(uint256 _amount) {
        require(_amount != 0, "Zero amount");
        _;
    }
}

contract AssetFactory {

}