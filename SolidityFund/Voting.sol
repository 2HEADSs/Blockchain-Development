// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

contract Voting {
    struct Voter {
        bool hasVoted;
        uint256 choice;
    }

    mapping(address => Voter) public votes;

    function registerVote(uint256 id) public {
        require(!votes[msg.sender].hasVoted, "Voter has already voted!");

        votes[msg.sender] = Voter({hasVoted: true, choice: id});
    }

    // function registerVote(address voter, uint256 id) public {
    //     require(!votes[voter].hasVoted, "Voter has already voted!");

    //     votes[voter] = Voter({hasVoted: true, choice: id});
    // }

    function getVoterStatus(address voter)
        public
        view
        returns (bool hasVoted, uint256 choice)
    {
        return (votes[voter].hasVoted, votes[voter].choice);
    }
}
