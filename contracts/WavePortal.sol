// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Waves {
	uint256 private seed;
	mapping(address => uint256) public lastWavedAt;
	event NewWave(address indexed from, uint256 timestamp, string message);
    struct Wave {
        address waver;
        string message;
        uint256 timestamp;
    }
    Wave[] waves;

    constructor() payable {
		seed = (block.timestamp + block.difficulty) % 100;
    }

    receive() external payable {}

	// Send a wave
	function wave(string calldata _message) public payable {
		require(lastWavedAt[msg.sender] + 1 minutes < block.timestamp, "Please wait a minute between two messages.");
		bytes memory _messageBytes = bytes(_message);
		require(_messageBytes.length != 0, "Please send a message");

		lastWavedAt[msg.sender] = block.timestamp;
		waves.push(Wave(msg.sender, _message, block.timestamp));

        // Give a 50% chance that the user wins the prize.
        seed = (block.difficulty + block.timestamp + seed) % 100;
        if (seed < 50) {
            uint256 prizeAmount = 0.0001 ether;
            require(prizeAmount <= address(this).balance, "Trying to withdraw more money than the contract has.");
            (bool success, ) = (msg.sender).call{value: prizeAmount}("");
            require(success, "Failed to withdraw money from contract.");
        }

		emit NewWave(msg.sender, block.timestamp, _message);
    }

    //Getters
    function getWaves() view public returns(Wave[] memory)
    {
        return (waves);
    }

    function getWavesCount() view public returns(uint256)
    {
        return (waves.length);
    }
}
