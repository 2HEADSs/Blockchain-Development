// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;
import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";

contract FundMe {
    uint256 public minimumUsd = 5;

    function fund() public payable {
        require(
            getConversionRate(msg.value) >= minimumUsd,
            "didn't send enough ETH"
        );
    }

    // function withdraw() public {}

    function getPrice() public view returns (uint256) {
        // 0x694AA1769357215DE4FAC081bf1f309aDC325306
        AggregatorV3Interface priceFeed = AggregatorV3Interface(
            0x1b44F3514812d835EB1BDB0acB33d3fA3351Ee43
        );
        (, int256 price, , , ) = priceFeed.latestRoundData();
        //Price of ETH in terms of USD

        return uint256(price * 1e10);
    }

    function getConversionRate(uint256 ethAmount)
        public
        view
        returns (uint256)
    {
        uint256 ethPrice = getPrice();
        uint256 ethAmountInUsd = (ethPrice * ethAmount) / 1e18;
        return ethAmountInUsd;
    }

    function getVersion() public view returns (uint256) {
        return
            AggregatorV3Interface(0x1b44F3514812d835EB1BDB0acB33d3fA3351Ee43)
                .version();
    }
}
