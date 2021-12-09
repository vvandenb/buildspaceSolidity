const main = async () => {
	const [owner, randomPerson] = await hre.ethers.getSigners();
	const waveContractFactory = await hre.ethers.getContractFactory('WavePortal');
	const waveContract = await waveContractFactory.deploy({
		value: hre.ethers.utils.parseEther('0.1'),
	  });
	await waveContract.deployed();

	console.log('Contract address:', waveContract.address);

	let waveCount;
	waveCount = await waveContract.getTotalWaves();
	console.log(waveCount.toNumber());

	let contractBalance = await hre.ethers.provider.getBalance(
		waveContract.address
	);
	console.log(
		'Contract balance:',
		hre.ethers.utils.formatEther(contractBalance)
	);
	
	let waveTxn = await waveContract.wave('This is wave #1');
	await waveTxn.wait();

	let waveTxn2 = await waveContract.wave('This is wave #2');
	await waveTxn2.wait();

	contractBalance = await hre.ethers.provider.getBalance(waveContract.address);
	console.log(
	'Contract balance:',
	hre.ethers.utils.formatEther(contractBalance)
	);
	
	  let allWaves = await waveContract.getAllWaves();
	  console.log(allWaves);

	//Waves tests
	// waveTxn = await waveContract.wave('A message!');
	// await waveTxn.wait(); // Wait for the transaction to be mined

	// waveTxn = await waveContract.connect(randomPerson).wave('Another message!');
	// await waveTxn.wait(); // Wait for the transaction to be mined

	// allWaves = await waveContract.getAllWaves();
	// console.log(allWaves);

	//Old waves tests
	// let waveCount;
	// waveCount = await waveContract.getTotalWaves();

	// let waveTxn = await waveContract.wave();
	// await waveTxn.wait();
	// waveCount = await waveContract.getTotalWaves();

	// waveTxn = await waveContract.connect(randomPerson).wave();
	// await waveTxn.wait();
	// waveCount = await waveContract.getTotalWaves();

	// waveTxn = await waveContract.connect(randomPerson).wave();
	// await waveTxn.wait();
	// await waveContract.connect(randomPerson).getUserWaves();
	// waveCount = await waveContract.getTotalWaves();

	//Own messages tests
	// console.log();
	// await waveContract.getUserMessage(randomPerson.address, 0);
	// waveTxn = await waveContract.connect(randomPerson).sendMessage("Hello world!");
	// await waveTxn.wait();
	// await waveContract.getUserMessage(randomPerson.address, 0);
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
