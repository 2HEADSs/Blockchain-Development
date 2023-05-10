// SPDX-License-Identifier: MIT

pragma solidity >=0.8.2 <0.9.0;

/**
 * @title Storage
 * @dev Store & retrieve value in a variable
 * @custom:dev-run-script ./scripts/deploy_with_ethers.ts
 */

contract DecentralizedAuctionPlatform {
    struct Auction {
        address creator;
        uint256 creatorMoney;
        uint256 auctionId;
        string name;
        string description;
        uint256 price;
        //price
        uint256 startTime;
        uint256 duration;
        bool finishedAction;
    }
    mapping(address => uint256) public availableToWithdrawal;
    Auction[] public Auctions;
    uint256 public auctionCount = 1;

    event createActionInfo(
        uint256 startTime,
        uint256 duration,
        string name,
        string description,
        uint256 startingPrice
    );

    event finalizeBidEmit(bool isFinihsed);

    event bidAuction(uint256 bidPrice, uint256 auctionId);

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
                msg.sender,
                0,
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

    function placeBid(uint256 auctionId, uint256 bidPrice) public {
        Auction storage currentAuction = Auctions[auctionId];

        require(bidPrice >= currentAuction.price, "Bid must be higher!!!");
        currentAuction.price = bidPrice;
        availableToWithdrawal[msg.sender] = currentAuction.price;

        emit bidAuction(auctionId, bidPrice);
    }

    function finalizeBid(uint256 auctionId) public payable {
        Auction storage currentAuction = Auctions[auctionId];

        // hardcore finished auction for test only
        currentAuction.finishedAction = true;

        require(
            currentAuction.finishedAction == true,
            "Auction should finished!!!"
        );
        require(currentAuction.price > 0, "Price must be positive!!!");
        currentAuction.creatorMoney = currentAuction.price;

        emit finalizeBidEmit(currentAuction.finishedAction);
    }
}
