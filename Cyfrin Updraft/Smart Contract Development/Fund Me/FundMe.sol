// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;
// import {AggregatorV3Interface} from "contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";
import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";

contract FundMe {
    uint256 public minimumUsd = 5;

    function fund() public payable {
        require(msg.value > minimumUsd, "didn't send enough ETH");
    }

    // function withdraw() public {}

    function getPrice() public {
        // 0x694AA1769357215DE4FAC081bf1f309aDC325306
    }

    function getConversionRate() public {}

    function getVersion() public view returns (uint256) {
        return
            AggregatorV3Interface(0x1b44F3514812d835EB1BDB0acB33d3fA3351Ee43)
                .version();
    }
}
