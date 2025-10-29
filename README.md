

Welcome to **ChainGuess**, a simple and beginner-friendly **Solidity smart contract** game built on the **Celo Sepolia Testnet**.  
Players can guess a random number, test their luck, and win double their bet if they guess correctly.  

> ⚠️ *Note: This version uses pseudo-randomness (not fully secure). A Chainlink VRF version can be added later for true provable fairness.*

---
<img width="1358" height="608" alt="Screenshot 2025-10-29 140754" src="https://github.com/user-attachments/assets/5ad6ea6d-22c3-4255-a375-bcac27ecdb41" />


## 🧠 Project Description

**ChainGuess** is a decentralized number guessing game designed to help beginners learn how to:
- Build smart contracts using **Solidity**.
- Deploy on the **Celo blockchain**.
- Interact with on-chain events and ETH-based rewards.
  
The goal is to create a fun, transparent, and educational blockchain mini-game that showcases basic **Solidity concepts** like state variables, events, and randomness.

---

## 💡 What It Does

1. Players send a small amount of **ETH (or CELO)** along with their guess (between 1 and 10).  
2. The contract generates a **random winning number** using on-chain data.  
3. If the player guesses correctly, they **win double** their bet!  
4. Game results are recorded as **events** on-chain for transparency.  

---

## ✨ Features

- 🎲 **Number Guessing Game:** Guess a number between 1 and 10.  
- 💰 **Double Reward:** Win 2x your bet if you guess correctly.  
- 📜 **Transparent Results:** Every game emits an event with results.  
- 🔐 **Owner Controls:** The contract owner can fund and withdraw balance.  
- 🧱 **Celo Sepolia Deployment:** Fully deployed and testable on the Celo network.

---

## 🌐 Deployed Smart Contract

**Network:** Celo Sepolia Testnet  
**Contract Address:** [`0x5a3657366213Bfc4cC80969E0efd31DdD2CE9E66`](https://celo-sepolia.blockscout.com/address/0x5a3657366213Bfc4cC80969E0efd31DdD2CE9E66)

View on [Celo Blockscout Explorer](https://celo-sepolia.blockscout.com/address/0x5a3657366213Bfc4cC80969E0efd31DdD2CE9E66).

---

## ⚙️ Smart Contract Code

```solidity
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
