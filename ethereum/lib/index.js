const blockchainObject = require("../../helper/web3");
// const constants = require("../../constants.json");
const log4js = require("log4js");
const logger = log4js.getLogger("");

/**
 * Function will create a blockchain address fot the register user
 * @param {Object} data data.password require. Password should be in encrypted format
 */
const createAccount = (data) => {
    return new Promise((resolve, reject) => {
        blockchainObject.web3.personal.newAccount(data.password, function (err, account) {
            if (err) {
                reject(err);
            }
            else {
                resolve(account);
            }
        });
    });
};

/**
 * Function to unlock ethereum account
 * @param {address} account ethereum account address
 */
const unlockUserAccount = (data) => {
    return new Promise((resolve, reject) => {
        blockchainObject.web3.personal.unlockAccount(data.account, data.password, function (err, result) {
            if (err) {
                logger.error("Fail to unlock the account: ", data.account);
                reject(err);
            }
            else {
                logger.debug("Successfully unlock the account: ", data.account);
                resolve(result);
            }
        });
    });
};

/**
 * Function to transfer ERC20 tokens
 * Implementation of transferFrom
 * @param {object} req 
 */
const transferERC20Token = (req) => {
    return new Promise((resolve, reject) => {
        const gasEstimate = blockchainObject.erc20.transferFrom.estimateGas(req.body.to, req.body.value);
        blockchainObject.erc20.transferFrom(req.session.user.local_blockchain_address, req.body.to, req.body.value, { gas: gasEstimate, from: blockchainObject.web3.eth.accounts[0] }, function (error, result) {
            if (error) {
                reject(error);
            }
            else {
                resolve(result);
            }
        });
    });
};

/**
 * Function to get a Balance of the user(ERC20 account balance)
 * @param {Object} req 
 */
const getBalance = (req) => {
    return new Promise((resolve, reject) => {
        blockchainObject.erc20.balanceOf(req.session.user.local_blockchain_address, function (error, result) {
            if (error) {
                reject(error);
            }
            else {
                resolve(result);
            }
        });
    });
};

/**
 * Function to get encoded ABI 
 * @param {object} req 
 */
const encodedABIOfTransferFrom = (req, data) => {
    console.log(blockchainObject.erc20.transferFrom.getData(req.session.user.rophston_address, data.address, data.amount));
    return blockchainObject.erc20.transferFrom.getData(req.session.user.rophston_address, data.address, data.amount);
};

const simpleTransfer = (req) => {
    blockchainObject.web3.eth.sendTransaction({ to: req.body.address, from: blockchainObject.web3.eth.accounts[0], value: 11 }, { gas: 3000000, from: blockchainObject.web3.eth.accounts[0] }, function (err, result) {

    });
};
module.exports = {
    createAccount,
    unlockUserAccount,
    transferERC20Token,
    encodedABIOfTransferFrom,
    getBalance
};