// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;
import "hardhat/console.sol";

contract WavePortal {
	uint256 totalWaves;
	uint256 private seed;
	mapping(address => uint256) public lastWavedAt;
	event NewWave(address indexed from, uint256 timestamp, string message);
    struct Wave {
        address waver;
        string message;
        uint256 timestamp;
    }
    Wave[] waves;

    constructor() {
		seed = (block.timestamp + block.difficulty) % 100;
    }

	// Used to fill contract with Ether
	function fillContract() external payable {
	}

	// Send a wave
	function wave(string memory _message) public payable {
		require(lastWavedAt[msg.sender] + 1 minutes < block.timestamp, "Please wait a minute between two messages.");
		bytes memory _messageBytes = bytes(_message);
		require(_messageBytes.length == 0);

		lastWavedAt[msg.sender] = block.timestamp;
        totalWaves += 1;
		waves.push(Wave(msg.sender, _message, block.timestamp));

        // Give a 50% chance that the user wins the prize.
        seed = (block.difficulty + block.timestamp + seed) % 100;
        if (seed < 50) {
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

	// Returns all waves
	function getAllWaves() public view returns (Wave[] memory) {
        return waves;
    }

	// Returns waves count
    function getTotalWaves() public view returns (uint256) {
        return totalWaves;
    }
}
