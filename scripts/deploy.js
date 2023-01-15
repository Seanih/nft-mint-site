const { ethers } = require('hardhat');

async function main() {
	const contract = await ethers.getContractFactory('RoboPunksNFT');
	const RoboPunksContract = await contract.deploy();
	await RoboPunksContract.deployed();

	console.log(`RoboPunksNFT deployed to: ${RoboPunksContract.address}`);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch(error => {
	console.error(error);
	process.exitCode = 1;
});
