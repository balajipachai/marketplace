const {
	expectRevert,
	expectEvent
} = require('openzeppelin-test-helpers');

const Farmer = artifacts.require('Farmer');
const Cattle = artifacts.require('Cattle');
const Auction = artifacts.require('Auction');
const Gov = artifacts.require('Government');
const Milk = artifacts.require('Milk');
const MarketPlaceToken = artifacts.require('MarketPlaceToken');
const ZERO_ADDRESS = '0x000000000000000000000000000000000000000';

let farmerInstance;
let cattleInstance;
let auctionInstance;
let govInstance;
let milkInstance;
let marketPlaceInstance;

contract('Farmer Registration', async (accounts) => {

	let cattleName = "CATTLE";
	let cattleSymbol = "CAT";
	let milkName = "MILK";
	let milkSymbol = "MLK";
	let tokenName = "MarketPlace";
	let tokenSymbol = "MKP";
	let decimals = 18;
	let totalSupply = 10000;

	before(async () => {
		cattleInstance = Cattle.new(cattleName, cattleSymbol);
		milkInstance = Milk.new(milkName, milkSymbol);
		govInstance = Gov.new();
		marketPlaceInstance = MarketPlaceToken.new(tokenName, tokenSymbol, decimals, accounts[0], totalSupply)
		auctionInstance = Auction.new(cattleInstance.address, marketPlaceInstance.address, milkInstance.address);
		farmerInstance = Farmer.new(cattleInstance.address, auctionInstance.address, govInstance.address, milkInstance.address);

	})

	describe('Test Farmer Registration', () => {
		describe('Test Constructor', () => {

			describe('when the cattle contract address is ZERO address', () => {


				it('reverts', async () => {
				console.log('Cattle : ', cattleInstance.address);
				console.log('Milk : ', milkInstance.address);
				console.log('Gov : ', govInstance.address);
				console.log('MarketPlace  : ', marketPlaceInstance.address);
				console.log('Auction : ', auctionInstance.address);
				console.log('Farmer : ', farmerInstance.address);

				// await expectRevert(Farmer.new(ZERO_ADDRESS, auctionInstance.address, govInstance.address, milkInstance.address), 'Cattle Contract address is ZERO_ADDRESS');

				});

			})

		})

	});

});