// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

error InsufficientBalance();
error InsufficientApproval();

contract ERC20 {
    string public name;
    string public symbol;
    uint8 public decimals = 3; // 1000 => 1 token; 10***
    uint256 public totalSupply;
    mapping(address => uint256) balanceoF;

    mapping(address => mapping(address => uint256)) public allowance;

    constructor(string memory newName, string memory newSymbol) {
        name = newName;
        symbol = newSymbol;
    }

    event Transfer();

    function transferFrom(address _to, uint256 _value)
        public
        returns (bool success)
    {
        if (balanceoF[msg.sender] < _value) {
            revert InsufficientBalance();
        }
        balanceoF[msg.sender] -= _value;
        balanceoF[_to] += _value;

        emit Transfer();

        return true;
    }

    function approve(address _spender, uint256 _value)
        public
        returns (bool success)
    {
        allowance[msg.sender][_spender] = _value;
        return true;
    }
}
