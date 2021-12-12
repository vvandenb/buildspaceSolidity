const main = async () => {
	const [owner, randomPerson] = await hre.ethers.getSigners();
	const waveContractFactory = await hre.ethers.getContractFactory('WavePortal');
	const waveContract = await waveContractFactory.deploy();
	await waveContract.deployed();
	console.log('Contract address:', waveContract.address);
	await waveContract.fillContract({value: hre.ethers.utils.parseEther('0.1')});
	console.log('Contract balance:', hre.ethers.utils.formatEther(await hre.ethers.provider.getBalance(waveContract.address)));
	console.log('Wave count:', await waveContract.getTotalWaves());
	
	let waveTxn = await waveContract.wave("");
	waveTxn.wait();
	console.log('Contract balance:', hre.ethers.utils.formatEther(await hre.ethers.provider.getBalance(waveContract.address)));
	
	let allWaves = await waveContract.getAllWaves();
	console.log(allWaves);
};

const runMain = async () => {
try {
	await main();
	process.exit(0);
} catch (error) {
	console.log(error);
	process.exit(1);
}
};

runMain();
