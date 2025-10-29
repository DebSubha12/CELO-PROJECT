// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title ChainGuess - A simple number guessing game
/// @author 
/// @notice This is a beginner-friendly Solidity example, not for production use

contract ChainGuess {
    address public owner;
    uint256 public minBet = 0.01 ether; // minimum bet to play
    uint256 public maxNumber = 10;      // players guess between 1 and 10

    event GamePlayed(address indexed player, uint256 guess, uint256 winningNumber, bool won, uint256 reward);

    constructor() {
        owner = msg.sender;
    }

    /// @notice Play the guessing game by sending ETH and a number between 1 and 10
    function play(uint256 _guess) public payable {
        require(msg.value >= minBet, "Bet too low");
        require(_guess >= 1 && _guess <= maxNumber, "Guess out of range");

        // ⚠️ Simple pseudo-random number (not secure)
        uint256 winningNumber = (uint256(
            keccak256(abi.encodePacked(block.timestamp, msg.sender, block.prevrandao))
        ) % maxNumber) + 1;

        bool won = false;
        uint256 reward = 0;

        if (_guess == winningNumber) {
            won = true;
            reward = msg.value * 2; // double your bet if you win
            require(address(this).balance >= reward, "Not enough funds in contract");
            payable(msg.sender).transfer(reward);
        }

        emit GamePlayed(msg.sender, _guess, winningNumber, won, reward);
    }

    /// @notice Fund the contract (e.g. by owner)
    function fundContract() public payable {}

    /// @notice Withdraw funds (only owner)
    function withdraw(uint256 _amount) public {
        require(msg.sender == owner, "Only owner");
        payable(owner).transfer(_amount);
    }

    /// @notice Get the contract balance
    function getBalance() public view returns (uint256) {
        return address(this).balance;
    }
}
