require('@nomicfoundation/hardhat-toolbox');

require('dotenv').config({ path: __dirname + '/.env.local' });

const GOERLI_URL = process.env.ALCHEMY_API_KEY;
const MY_PK = process.env.DEV_PK;
const GOERLI_API = process.env.GOERLI_API_KEY;

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
	solidity: '0.8.17',
	networks: {
		goerli: {
			url: GOERLI_URL,
			accounts: [MY_PK],
		},
	},
	etherscan: {
		apiKey: GOERLI_API,
	},
};
