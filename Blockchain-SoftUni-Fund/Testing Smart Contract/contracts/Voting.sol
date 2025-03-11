// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @title VotingSystem
 * @notice A voting system where the owner can create proposals and users can vote on them.
 * @dev Implements basic voting functionality with time-based restrictions and execution controls.
 */
contract VotingSystem {
    /**
     * @notice Structure representing a voting proposal
     * @param description Brief description of what is being voted on
     * @param voteCount Number of votes cast for this proposal
     * @param endTime Unix timestamp when voting period ends
     * @param executed Whether the proposal has been executed
     */
    struct Proposal {
        string description;
        uint256 voteCount;
        uint256 endTime;
        bool executed;
    }

    mapping(uint256 => Proposal) public proposals;
    mapping(address => mapping(uint256 => bool)) public hasVoted;

    uint256 public proposalCount;
    address public owner;

    event ProposalCreated(
        uint256 indexed proposalId,
        string description,
        uint256 endTime
    );
    event VoteCast(uint256 indexed proposalId, address indexed voter);
    event ProposalExecuted(uint256 indexed proposalId, uint256 finalVoteCount);

    error NotOwner();
    error InvalidVotingPeriod();
    error InvalidProposal();
    error AlreadyVoted();
    error VotingEnded();
    error ProposalAlreadyExecuted();
    error VotingNotEnded();

    modifier onlyOwner() {
        if (msg.sender != owner) revert NotOwner();
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    /**
     * @notice Creates a new proposal for voting
     * @param _description Description of the proposal
     * @param _votingPeriod Duration of the voting period in seconds
     * @dev Only the contract owner can create proposals
     */
    function createProposal(
        string memory _description,
        uint256 _votingPeriod
    ) external onlyOwner {
        if (_votingPeriod == 0) revert InvalidVotingPeriod();

        uint256 proposalId = proposalCount++;
        proposals[proposalId] = Proposal({
            description: _description,
            voteCount: 0,
            endTime: block.timestamp + _votingPeriod,
            executed: false
        });
        emit ProposalCreated(
            proposalId,
            _description,
            block.timestamp + _votingPeriod
        );
    }

    /**
     * @notice Allows an address to cast a vote on a specific proposal
     * @param _proposalId The ID of the proposal to vote on
     * @dev Each address can only vote once per proposal
     */
    function vote(uint256 _proposalId) external {
        if (_proposalId >= proposalCount) revert InvalidProposal();
        if (hasVoted[msg.sender][_proposalId]) revert AlreadyVoted();
        if (block.timestamp >= proposals[_proposalId].endTime)
            revert VotingEnded();
        if (proposals[_proposalId].executed) revert ProposalAlreadyExecuted();

        proposals[_proposalId].voteCount++;
        hasVoted[msg.sender][_proposalId] = true;
        emit VoteCast(_proposalId, msg.sender);
    }

    /**
     * @notice Executes a proposal after its voting period has ended
     * @param _proposalId The ID of the proposal to execute
     * @dev Only the owner can execute proposals and only after voting period ends
     */
    function executeProposal(uint256 _proposalId) external onlyOwner {
        if (_proposalId >= proposalCount) revert InvalidProposal();
        if (block.timestamp < proposals[_proposalId].endTime)
            revert VotingNotEnded();
        if (proposals[_proposalId].executed) revert ProposalAlreadyExecuted();

        proposals[_proposalId].executed = true;
        emit ProposalExecuted(_proposalId, proposals[_proposalId].voteCount);
    }
}
