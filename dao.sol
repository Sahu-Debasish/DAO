// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// Import necessary libraries
import "@openzeppelin/contracts/access/Ownable.sol";

// Create the DAO contract
contract DAO is Ownable {
    string public name;
    uint256 public totalShares;
    mapping(address => uint256) public shares;
    uint256 public proposalCount;
    
    // Struct to represent a proposal
    struct Proposal {
        uint256 id;
        string description;
        uint256 votesYes;
        uint256 votesNo;
        bool executed;
    }
    
    // Array of proposals
    Proposal[] public proposals;
    
    // Mapping of member addresses to their voting power
    mapping(address => uint256) public votingPower;
    
    // Modifier to check if a member has voting power
    modifier hasVotingPower() {
        require(votingPower[msg.sender] > 0, "You do not have voting power.");
        _;
    }

    // Constructor to initialize the DAO
    constructor(string memory _name) {
        name = _name;
        totalShares = 0;
        proposalCount = 0;
    }
    
    // Function to add a member to the DAO
    function addMember(address member, uint256 _shares) public onlyOwner {
        shares[member] = _shares;
        totalShares += _shares;
        votingPower[member] = _shares;
    }
    
    // Function to create a new proposal
    function createProposal(string memory description) public hasVotingPower {
        proposalCount++;
        Proposal memory newProposal = Proposal({
            id: proposalCount,
            description: description,
            votesYes: 0,
            votesNo: 0,
            executed: false
        });
        proposals.push(newProposal);
    }
    
    // Function to vote on a proposal
    function vote(uint256 proposalId, bool approve) public hasVotingPower {
        require(proposalId <= proposalCount && proposalId > 0, "Invalid proposal ID.");
        require(!proposals[proposalId - 1].executed, "Proposal already executed.");
        
        if (approve) {
            proposals[proposalId - 1].votesYes += votingPower[msg.sender];
        } else {
            proposals[proposalId - 1].votesNo += votingPower[msg.sender];
        }
    }
    
    // Function to execute a proposal
    function executeProposal(uint256 proposalId) public onlyOwner {
        require(proposalId <= proposalCount && proposalId > 0, "Invalid proposal ID.");
        require(!proposals[proposalId - 1].executed, "Proposal already executed.");
        
        Proposal storage proposal = proposals[proposalId - 1];
        if (proposal.votesYes > proposal.votesNo) {
            // Execute the proposal
            proposal.executed = true;
            // Implement the proposal logic here
        }
    }
}
