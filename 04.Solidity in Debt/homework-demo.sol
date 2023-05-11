// SPDX-License-Identifier: MIT
 
pragma solidity >=0.8.2 <0.9.0;
 
contract AuctionPLatform {
    struct Auction{
         address creator;
        uint256 startTime;
        uint256 duration;
        string name;
        string description;
        uint256 startingPrice;
        address highestBidder;
        uint256 highestBid;
        bool isFinalized;
    }
 
   mapping(uint256 => Auction) public auctions;
    mapping(address => uint256) public availableToWithdrawal;
 
    uint256 public auctionCount = 0;
 
 modifier onlyActiveAuction(uint256 _auctionId) {
        require(!auctions[_auctionId].isFinalized, "Auction is finalized");
        require(
            auctions[_auctionId].startTime <= block.timestamp &&
                block.timestamp <= auctions[_auctionId].startTime + auctions[_auctionId].duration,
            "Auction is not active"
        );
        _;
    }
 
    event AuctionCreated(
    uint256 startTime,
    uint256 duration,
    string name,
    string description,
    uint256 startingPrice
    );
 
    event BidPlaced(uint256 auctionId,
    address bidder,
    uint256 amount);
 
     event FundsWithdrawn(
         address beneficiary, 
         uint256 amount);
 
    function createAuction(
         uint256 _startTime,
        uint256 _duration,
        string memory _name,
        string memory _description,
        uint256 _startingPrice
    ) public {
      require(_startTime > block.timestamp, "Incorrect time!");
      require(_duration <= block.timestamp, "Incorrect time!");
 
      auctionCount++;
 
      auctions[auctionCount] = Auction(
          msg.sender,
          _startTime,
          _duration,
          _name,
          _description,
          _startingPrice,
          address(0),
          0,
          false
      );
 
      emit AuctionCreated(
          _startTime,
          _duration,
          _name,
          _description,
          _startingPrice
      );
    }
 
     function placeBid(uint256 _auctionId) public payable onlyActiveAuction(_auctionId){
 
     Auction storage auction = auctions[_auctionId];
 
      require(msg.value > auctions[_auctionId].highestBid, "The bid amount must be higher!");
 
       require(msg.value > auction.highestBid);
 
 
         auction.highestBid = msg.value;
         auction.highestBidder = msg.sender;
 
         emit BidPlaced(
             _auctionId,
             msg.sender,
             msg.value
         );
 
     }
 
      function finalizeAuction(uint256 _auctionId) public{
          Auction storage auction = auctions[_auctionId];
 
          require(block.timestamp > auction.startTime + auction.duration, "The auction is not finihed yet!");
 
          require(!auction.isFinalized,"Auction finished!");
 
          auction.isFinalized = true;
 
          if(auction.highestBid > 0){
              availableToWithdrawal[auction.creator] += auction.highestBid;
          }
      }
 
 
 
 
}