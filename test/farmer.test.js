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
		cattleInstance = await Cattle.new(cattleName, cattleSymbol);
		milkInstance = await Milk.new(milkName, milkSymbol);
		govInstance = await Gov.new();
		marketPlaceInstance = await MarketPlaceToken.new(tokenName, tokenSymbol, decimals, accounts[0], totalSupply)
		auctionInstance = await Auction.new(cattleInstance.address, marketPlaceInstance.address, milkInstance.address);
		farmerInstance = await Farmer.new(cattleInstance.address, auctionInstance.address, govInstance.address, milkInstance.address);

		console.log('Cattle : ', cattleInstance.address);
		console.log('Milk : ', milkInstance.address);
		console.log('Gov : ', govInstance.address);
		console.log('MarketPlace  : ', marketPlaceInstance.address);
		console.log('Auction : ', auctionInstance.address);
		console.log('Farmer : ', farmerInstance.address);

	})

	describe('Test Farmer Registration', () => {
		describe('Test Constructor', () => {

			/**
			 * Positive scenario test cases
			 */
			describe('Cattle Contract Address should not be ZERO', () => {

				it('should not revert ', async () => {
					await expect(Farmer.new(cattleInstance.address, auctionInstance.address, govInstance.address, milkInstance.address), 'Cattle Contract address is not ZERO_ADDRESS');

				});

			})

			describe('Cattle Should be the Contract Address', () => {

				it('should not revert ', async () => {
					await expect(Farmer.new(accounts[0], auctionInstance.address, govInstance.address, milkInstance.address), 'Cattle Contract address should be contract address');

				});

			})

			describe('Auction Contract Address should not be ZERO', () => {

				it('should not revert ', async () => {
					await expect(Farmer.new(cattleInstance.address, auctionInstance.address, govInstance.address, milkInstance.address), 'Auction Contract address is not ZERO_ADDRESS');

				});
			})

			describe('Auction Should be the Contract Address', () => {

				it('should not revert ', async () => {
					await expect(Farmer.new(cattleInstance.address, accounts[0], govInstance.address, milkInstance.address), 'Auction Contract address should be contract address');

				});
			})


			describe('Government Contract Address should not be ZERO', () => {

				it('should not revert ', async () => {
					await expect(Farmer.new(cattleInstance.address, auctionInstance.address, govInstance.address, milkInstance.address), 'Government Contract address is not ZERO_ADDRESS');

				});
			})

			describe('Government Should be the Contract Address', () => {

				it('should not revert ', async () => {
					await expect(Farmer.new(cattleInstance.address, auctionInstance.address, accounts[0], milkInstance.address), 'Government Contract address should be contract address');

				});
			})

			describe('Milk Contract Address should not be ZERO', () => {

				it('should not revert ', async () => {
					await expect(Farmer.new(cattleInstance.address, auctionInstance.address, govInstance.address, milkInstance.address), 'Milk Contract address is not ZERO_ADDRESS');

				});
			})

			describe('Milk Should be the Contract Address', () => {

				it('should not revert ', async () => {
					await expect(Farmer.new(cattleInstance.address, auctionInstance.address, govInstance.address, accounts[0]), 'Milk Contract address should be contract address');

				});
			})

		})

	});

});