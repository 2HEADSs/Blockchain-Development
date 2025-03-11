// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {ICustomToken} from "./ICustomToken.sol";

contract CrowdSale is Ownable {
    uint256 public constant MIN_SALE_PERIOD = 1 weeks;

    address public token;
    uint256 public price;
    uint256 public startTime;
    uint256 public endTime;
    address public feeReceiver;
    uint256 tokensForSale;
    uint256 tokenSold;
    bool public isFinished;

    error InvalidStartTime(string message);
    error InvalidEndTime(string message);
    error InvalidFeeReceiver();
    error OutOfSalePeriod();
    error SaleIsStillActive();
    error UnsuccessfulWithdraw();
    error SaleAlreadyFinished();

    constructor(address owner) Ownable(owner) {}

    /**
     * Set initial CrowdSale parameters
     * @param _startTime start the sale
     * @param _endTime end of the sale
     * @param _rateETH how much tokens are sold for 1 ETH
     */

    function initialize(
        uint256 _startTime,
        uint256 _endTime,
        uint256 _rateETH,
        address _feeReceiver,
        address _token,
        uint256 _tokensForSale
    ) external onlyOwner {
        if (_startTime < block.timestamp) {
            revert InvalidStartTime("Start time must be in the future");
        }

        if (_startTime > block.timestamp + 10 days) {
            revert InvalidStartTime("Start time must be within 10 days");
        }

        if (_endTime < _startTime + MIN_SALE_PERIOD) {
            revert InvalidEndTime(
                "End time must be at least MIN_SALE_PERIOD after start time"
            );
        }
        if (_feeReceiver == address(0)) {
            revert InvalidFeeReceiver();
        }

        price = _rateETH;
        startTime = _startTime;
        endTime = _endTime;
        feeReceiver = _feeReceiver;
        token = _token;
        tokensForSale = _tokensForSale;

        ICustomToken(token).transferFrom(
            msg.sender,
            address(this),
            tokensForSale
        );
    }

    function buyShares(address receiver) external payable {
        if (
            block.timestamp < startTime ||
            block.timestamp > endTime ||
            isFinished
        ) {
            revert OutOfSalePeriod();
        }
        uint256 tokenToReceive = (msg.value *
            price *
            (10 ** ICustomToken(token).decimals())) / 1 ether;

        ICustomToken(token).transfer(receiver, tokenToReceive);
    }

    function finalizeSale() external onlyOwner {
        if (isFinished) {
            revert SaleAlreadyFinished();
        }
        if (tokenSold < tokensForSale || block.timestamp <= endTime) {
            revert SaleIsStillActive();
        }

        isFinished = true;
        (bool success, ) = feeReceiver.call{value: address(this).balance}("");
        if (!success) {
            revert UnsuccessfulWithdraw();
        }

        ICustomToken(token).transfer(owner(), ICustomToken(token).balanceOf(address(this)));
    }
}
