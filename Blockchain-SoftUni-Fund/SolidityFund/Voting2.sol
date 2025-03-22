// SPDX-License-Identifier: MIT
pragma solidity 0.8.29;

struct Voter {
    uint256 choice;
    bool hasVoted;
}

error InvalidCandidateID();
error VoterHasAlreadyVoted();

contract Voting2 {
    uint256 candidateOneID = 1;
    uint256 candidateTwoID = 2;
    uint256 candidateThreeID = 3;

    mapping(address => Voter) public votes;

    function registerVote(uint256 id) public {
        if(votes[msg.sender].hasVoted){
            revert VoterHasAlreadyVoted();
        }
        if(id != candidateOneID && id != candidateTwoID && id != candidateThreeID){
            revert InvalidCandidateID();
        }

        votes[msg.sender] = Voter({hasVoted: true, choice: id});
    }

    function getVoterStatus(address voter)
        public
        view
        returns (bool hasVoted, uint256 choice)
    {
        return (votes[voter].hasVoted, votes[voter].choice);
    }
}
