// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

error InsufficientBalance();
error InsufficientApproval();

contract ERC20 {
    string public name;
    string public symbol;
    uint8 public decimals = 3; // 1000 => 1 token; 10**decimels
    uint256 public totalSupply;
    mapping(address => uint256) public balanceoF;

    mapping(address => mapping(address => uint256)) public allowance;

    constructor(string memory newName, string memory newSymbol) {
        name = newName;
        symbol = newSymbol;

        uint256 supply = 1000 * 10**decimals;
        balanceoF[msg.sender] = supply;
        totalSupply = supply;
    }

    event Transfer();

    function transfer(address _to, uint256 _value)
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

    function transferFrom(
        address _from,
        address _to,
        uint256 _value
    ) public returns (bool success) {
        if (allowance[_from][msg.sender] < _value) {
            revert InsufficientApproval();
        }

        allowance[_from][msg.sender] -= _value;

        if (balanceoF[_from] < _value) {
            revert InsufficientBalance();
        }  

        balanceoF[_from] -= _value;
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
