// SPDX-License-Identifier: MIT
pragma solidity 0.8.29;

interface ILoyaltyPoints {
    function rewardPoints(
        address _user,
        uint256 _amount
    ) external returns (uint256);
    function redeemPoints(
        address _cofeeShop,
        uint256 _amount
    ) external returns (uint256);

    event Rewarded(address indexed to, uint256 amount);
    event Redeemed(address indexed from, uint256 amount);
}

abstract contract BaseLoyaltyProgram is ILoyaltyPoints, Ownable {
    mapping(address => bool) public partnerCaffes;

    modifier onlyPartners() {
        require(partnerCaffes[msg.sender], "Not an authorized partner");
        _;
    }
    function addPartnersCafe(address _cafe) external onlyOwner {
        partnerCaffes[_cafe] = true;
    }
    function removePartnersCafe(address _cafe) external onlyOwner {
        partnerCaffes[_cafe] = false;
    }

    function _authorizeReward(
        address _user,
        uint256 _amount
    ) internal view virtual {
        require(_user != address(0), "Invalid address");
        require(_amount > 0, "Invalid amount");
    }
}

contract BrewBeanPoints is ERC20, BaseLoyaltyProgram {
    constructor() ERC20("BrewBean", "BBP") {}

    function rewardPoints(address _user, uint256 _amount) external override {
        _authorizeReward(_user, _amount);
        _mint(_user, _amount);
        emit Rewarded(_user, _amount);
    }

    function redeemPoints(uint256 _amount) external override {
        require(balanceoF[msg.sender] >= _amount, "Insufficient balance");
        _burn(msg.sender, _amount);
        emit Redeemed(msg.sender, _amount);
    }
}
