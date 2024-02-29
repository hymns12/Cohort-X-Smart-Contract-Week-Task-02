// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "./ERC20Token.sol";
import "./IERC20Token.sol";

import "@chainlink/contracts/src/v0.8/VRFConsumerBase.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract RandomNumberG is VRFConsumerBase {
    bytes32 internal keyHash;
    uint256 internal fee;
    uint256 public randomResult;
    address public admin;
    address public tokenAddress;
    uint256 public totalParticipants;
    uint256 public totalPrize;
    mapping(uint256 => address) public participants;
    mapping(address => uint256) public participantIndex;
    bool public prizeDistributed;

    event PrizeDistributed(address winner, uint256 amount);

    modifier onlyAdmin() {
        require(msg.sender == admin, "Only admin can call this function");
        _;
    }

    constructor(
        address _vrfCoordinator,
        address _linkToken,
        bytes32 _keyHash,
        uint256 _fee,
        address _tokenAddress
    )
        VRFConsumerBase(_vrfCoordinator, _linkToken)
    {
        keyHash = _keyHash;
        fee = _fee;
        admin = msg.sender;
        tokenAddress = _tokenAddress;
    }

    function participate() external {
        require(!prizeDistributed, "Prize already distributed");
        require(participantIndex[msg.sender] == 0, "Already participated");
        
        totalParticipants++;
        participants[totalParticipants] = msg.sender;
        participantIndex[msg.sender] = totalParticipants;
    }

    function distributePrize() external onlyAdmin {
        require(totalParticipants > 0, "No participants");
        require(!prizeDistributed, "Prize already distributed");

        prizeDistributed = true;
        bytes32 requestId = requestRandomness(keyHash, fee);
        // You could store the requestId to verify the randomness later
    }

    function fulfillRandomness(bytes32 requestId, uint256 randomness) internal override {
        randomResult = randomness;
        uint256 winnerIndex = randomness % totalParticipants + 1;
        address winner = participants[winnerIndex];
        // Distribute prize to winner
        distributeTokens(winner);
        emit PrizeDistributed(winner, totalPrize);
    }

    function distributeTokens(address winner) internal {
        IERC20 token = IERC20(tokenAddress);
        uint256 balance = token.balanceOf(address(this));
        require(balance >= totalPrize, "Not enough tokens to distribute");

        token.transfer(winner, totalPrize);
    }

    function setTotalPrize(uint256 _totalPrize) external onlyAdmin {
        totalPrize = _totalPrize;
    }

    function withdrawLink(address _to, uint256 _amount) external onlyAdmin {
        IERC20 link = IERC20(address(chainlinkTokenAddress()));
        require(link.transfer(_to, _amount), "Unable to transfer");
    }
}

