// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import "hardhat/console.sol";

contract WavePortal {
	uint256 totalWaves;
	uint256 private seed;
	mapping(address => uint256) public lastWavedAt;
	// mapping(address => uint) public waves;
	// mapping(address => uint) public messageIndex;
	// mapping(address => mapping(uint => string)) public messages;

	event NewWave(address indexed from, uint256 timestamp, string message);
    struct Wave {
        address waver;
        string message;
        uint256 timestamp;
    }
    Wave[] waves;

    constructor() payable {
        console.log("Hello world!");
		seed = (block.timestamp + block.difficulty) % 100;
    }

	function wave(string memory _message) public {
		require(lastWavedAt[msg.sender] + 1 minutes < block.timestamp, "Please wait a minute between two messages.");

		lastWavedAt[msg.sender] = block.timestamp;
        totalWaves += 1;
		waves.push(Wave(msg.sender, _message, block.timestamp));
        console.log("%s has sent: %s!", msg.sender, _message);

        seed = (block.difficulty + block.timestamp + seed) % 100;
        
        console.log("Random # generated: %d", seed);

        // Give a 50% chance that the user wins the prize.
        if (seed <= 50) {
            console.log("%s won!", msg.sender);

            uint256 prizeAmount = 0.0001 ether;
            require(
                prizeAmount <= address(this).balance,
                "Trying to withdraw more money than the contract has."
            );
            (bool success, ) = (msg.sender).call{value: prizeAmount}("");
            require(success, "Failed to withdraw money from contract.");
        }

		emit NewWave(msg.sender, block.timestamp, _message);
    }

	function getAllWaves() public view returns (Wave[] memory) {
        return waves;
    }

    function getTotalWaves() public view returns (uint256) {
        console.log("We have %d total waves!", totalWaves);
        return totalWaves;
    }

// 	function sendMessage(string memory message) public {
// 		messages[msg.sender][messageIndex[msg.sender]] = message;
// 		messageIndex[msg.sender] += 1;
//         console.log("New message (total: %d) from %s: %s", messageIndex[msg.sender], msg.sender, message);
// 	}

// 	function getUserMessage(address sender, uint256 index) public view returns (string memory) {
//         console.log("Message number %d from %s: %s", index, sender, messages[sender][index]);
// 		return messages[sender][index];
// 	}
}
