// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;
struct Vote {
    address shareholder;
    uint256 shares;
    uint256 timestamp;
}

error InsuficientAmount();

contract CrowdFunding {
    mapping(address => uint256) public shares;
    Vote[] public votes;
    uint256 public sharePrice;
    uint256 public totalShare;

    constructor(uint256 _initialSharePrice) {
        sharePrice = _initialSharePrice;
    }

    function buyShares() external payable {
        if(msg.value < sharePrice){
            revert InsuficientAmount(); 
        }
        if(msg.value % sharePrice >0){
            revert InsuficientAmount();
        }
        uint256 sharesToReceive = msg.value / sharePrice;
        totalShare += sharesToReceive;
        shares[msg.sender] += sharesToReceive;
    }

    function vote(address holder) external {
        votes.push(
            Vote({
                shareholder: holder,
                shares: shares[holder],
                timestamp: block.timestamp
            })
        );
    }
}
