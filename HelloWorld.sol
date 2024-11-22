// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;
enum VotingOptions {
    CandidateOne,
    CandidateTow
}

error InvalidCandidate();

contract SimpleVoting {
    bool public votedEnded = false;
    address public candidate1 = 0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2;
    address public candidate2 = 0x4B20993Bc481177ec7E8f571ceCaE8A9e22C02db;
    uint256 public votesCandidateOne;
    uint256 public votesCandidateTwo;
    address public winner;
    address public owner = 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4;

    function votes(address candidate) public {
        require(
            candidate == candidate1 || candidate == candidate2,
            "Invalid candidate addres"
        );

        require(!votedEnded, "Voting already ended");

        if (candidate == candidate1) {
            votesCandidateOne++;
        } else if (candidate == candidate2) {
            votesCandidateTwo++;
        } else {
            revert InvalidCandidate();
        }
    }

    function chooseWinner() external {
        require(msg.sender == owner, "Not owner");
        votedEnded = true;

        if (votesCandidateOne > votesCandidateTwo) {
            winner = candidate1;
        } else if (votesCandidateTwo > votesCandidateOne) {
            winner = candidate2;
        } else {
            revert("More voting needed");
        }
    }
}
