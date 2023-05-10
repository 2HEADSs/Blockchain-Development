// SPDX-License-Identifier: MIT

pragma solidity >=0.8.2 <0.9.0;

/**
 * @title Storage
 * @dev Store & retrieve value in a variable
 * @custom:dev-run-script ./scripts/deploy_with_ethers.ts
 */

contract DecentralizedAuctionPlatform {
    struct Auction {
        uint256 auctionId;
        string name;
        string description;
        uint256 startingPrice;
        uint256 startTime;
        uint256 duration;
        bool finishedAction;
    }
    Auction[] public Auctions;
    uint256 public auctionCount = 0;

    event createActionInfo(
        uint256 startTime,
        uint256 duration,
        string name,
        string description,
        uint256 startingPrice
    );

    function createAuction(
        uint256 startTime,
        uint256 duration,
        string memory name,
        string memory description,
        uint256 startingPrice
    ) public {
        require(
            startTime > block.timestamp,
            "The time must be bigger than timestam"
        );
        require(duration > 0, "Time must be pozitive");
        auctionCount++;

        Auctions.push(
            Auction(
                auctionCount,
                name,
                description,
                startingPrice,
                startTime,
                duration,
                false
            )
        );
        emit createActionInfo(
            startTime,
            duration,
            name,
            description,
            startingPrice
        );
    }


}