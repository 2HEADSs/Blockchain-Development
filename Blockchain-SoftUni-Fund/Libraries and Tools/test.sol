// SPDX-License-Identifier: MIT
pragma solidity 0.8.29;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";

contract Test is ERC20, AccessControl {
    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");

    constructor(address minter) ERC20("MyToken", "TKN") {
        _grantRole(MINTER_ROLE, minter);
    }

    function mint(address to, uint256 amount) public {
        require(hasRole(MINTER_ROLE, msg.sender), "Caller is not a minter");
        _mint(to, amount);
    }
}
