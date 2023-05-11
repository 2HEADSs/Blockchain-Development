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
        uint256 startingPrice;
        uint256 lastBid;
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

    event bidAuction(uint256 bid, uint256 auctionId);

    function createAuction(
        uint256 startTime,
        uint256 duration,
        string memory name,
        string memory description,
        uint256 startingPrice
    ) public {
        require(
            startTime > block.timestamp,
            "The time must be bigger than timestamp"
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
                0,
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

    function placeBid(uint256 auctionId, uint256 bid) public {
        Auction storage currentAuction = Auctions[auctionId];

        require(
            bid >= currentAuction.lastBid,
            "Bid must be higher!!!"
        );
        currentAuction.lastBid = bid;
        availableToWithdrawal[msg.sender] = bid;

        emit bidAuction(auctionId, bid);
    }

    function finalizeBid(uint256 auctionId) public payable {
        Auction storage currentAuction = Auctions[auctionId];

        // hardcore finished auction for test only
        // currentAuction.finishedAction = true;

        if(block.timestamp > currentAuction.startTime + currentAuction.duration){
            currentAuction.finishedAction = true;

        }
        require(
            currentAuction.finishedAction == true,
            "Auction should finished!!!"
        );
        require(currentAuction.lastBid > 0, "Bid must be positive!!!");
        currentAuction.creatorMoney =
            currentAuction.startingPrice +
            currentAuction.lastBid;

        emit finalizeBidEmit(currentAuction.finishedAction);
    }


}
