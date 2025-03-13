// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

import {IERC721} from "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

struct Auction {
    uint256 tokenId;
    address nftAddress;
    uint256 minPrice;
    uint256 startTime;
    uint256 endTime;
    uint256 minBidIncr;
    uint256 timeExtensionWindow;
    uint256 timeExtensionIncr;
    address seller;
    bool nftClaimed;
    bool rewardClaimed;
}

error CannotBeZero();
error InvalidStartTime();
error InvalidEndTime(string argument);
error InsufficientBid();
error NotBidPeriod();
error NotValidAuction();
error AuctionUnfinished();
error NotClaimer();
error AlreadyClaimed();
error HighestBidder();
error NotWinner();
error NotSeller();

contract AuctionHouse is Ownable {
    uint256 MIN_AUCTION_DURATION = 1 days;
    uint256 MAX_AUCTION_DURATION = 60 days;
    uint256 private _nextAuctionId;

    mapping(uint256 => Auction) public auctions;
    mapping(uint256 auctionId => mapping(address bidder => uint256 bid))
        public bids;
    mapping(uint256 auctionId => address highestBidder) public highestBidders;

    event AuctionCreated(uint256 indexed auctionId);
    event NewBid(
        uint256 indexed auctionId,
        address indexed bidder,
        uint256 bid
    );

    event NftClaimed(uint256 indexed auctionId);
    event BidClaimed(
        uint256 indexed auctionId,
        address indexed bidder,
        uint256 bid
    );
    event RewardClaimed(uint256 indexed auctionId, uint256 reward, uint256 fee);

    constructor() Ownable(msg.sender) {}

    function createAuction(
        uint256 tokenId,
        address tokenAddres,
        uint256 minPrice,
        uint256 startTime,
        uint256 endTime,
        uint256 minBidIncr,
        uint256 timeExtensionWindow,
        uint256 timeExtensionIncr
    ) external {
        if (minPrice == 0) {
            revert CannotBeZero();
        }

        if (startTime < block.timestamp) {
            revert InvalidStartTime();
        }

        if (endTime < startTime + MIN_AUCTION_DURATION) {
            revert InvalidEndTime("TOO_LOW");
        }

        if (endTime > startTime + MAX_AUCTION_DURATION) {
            revert InvalidEndTime("TOO HIGH");
        }

        uint256 auctionId = _nextAuctionId++;
        auctions[auctionId] = Auction({
            tokenId: tokenId,
            nftAddress: tokenAddres,
            minPrice: minPrice,
            startTime: startTime,
            endTime: endTime,
            minBidIncr: minBidIncr,
            timeExtensionWindow: timeExtensionWindow,
            timeExtensionIncr: timeExtensionIncr,
            seller: msg.sender,
            nftClaimed: false,
            rewardClaimed: false
        });
        // @note The NFT needs allowance
        IERC721(tokenAddres).transferFrom(msg.sender, address(this), tokenId);

        emit AuctionCreated(auctionId);
    }

    function bid(uint256 auctionId) external payable {
        Auction storage auction = auctions[auctionId];

        if (auction.nftAddress == address(0)) {
            revert NotValidAuction();
        }

        if (
            block.timestamp < auction.startTime ||
            block.timestamp > auction.endTime
        ) {
            revert NotBidPeriod();
        }

        uint256 newBid = bids[auctionId][msg.sender] + msg.value;

        if (
            msg.value < auction.minPrice ||
            (highestBidders[auctionId] != address(0) &&
                newBid <
                bids[auctionId][highestBidders[auctionId]] + auction.minBidIncr)
        ) {
            revert InsufficientBid();
        }

        if (auction.endTime > auction.endTime - auction.timeExtensionWindow) {
            auction.endTime += auction.timeExtensionIncr;
        }

        bids[auctionId][msg.sender] = newBid;
        highestBidders[auctionId] = msg.sender;

        emit NewBid(auctionId, msg.sender, newBid);
    }

    function claimNFT(uint256 auctionId) external auctionFinished(auctionId) {
        Auction storage auction = auctions[auctionId];

        if (auction.nftClaimed) {
            revert AlreadyClaimed();
        }

        address highestBidder = highestBidders[auctionId];
        if (
            msg.sender != highestBidder &&
            highestBidder != address(0) &&
            msg.sender != auction.seller
        ) {
            revert NotClaimer();
        }

        auction.nftClaimed = true;

        address receiver = msg.sender == highestBidder
            ? highestBidder
            : auction.seller;
        IERC721(auction.nftAddress).safeTransferFrom(
            address(this),
            receiver,
            auction.tokenId
        );

        emit NftClaimed(auctionId);
    }

    function claimBid(uint256 auctionId) external {
        uint256 userBid = bids[auctionId][msg.sender];

        if (highestBidders[auctionId] == msg.sender) {
            revert HighestBidder();
        }

        if (bids[auctionId][msg.sender] != 0) {
            bids[auctionId][msg.sender] = 0;
            _transferETH(payable(msg.sender), userBid);
        }
    }

    function claimReward(
        uint256 auctionId
    ) external auctionFinished(auctionId) {
        uint256 reward = bids[auctionId][highestBidders[auctionId]];
        if (reward == 0) {
            revert NotWinner();
        }
        Auction storage auction = auctions[auctionId];

        if (auction.rewardClaimed) {
            revert AlreadyClaimed();
        }

        if (msg.sender != auction.seller) {
            revert NotSeller();
        }
        auction.rewardClaimed = true;

        uint256 fee = (reward / 100);
        if (fee > 0) {
            _transferETH(payable(owner()), fee);
        }
        _transferETH(payable(msg.sender), reward);

        emit RewardClaimed(auctionId, reward, fee);
    }

    function _transferETH(address payable to, uint256 amount) private {
        (bool sent, ) = to.call{value: amount}("");
        require(sent, "Failed to send Ether");
    }

    modifier auctionFinished(uint256 auctionId) {
        if (block.timestamp <= auctions[auctionId].endTime) {
            revert AuctionUnfinished();
        }
        _;
    }
}
