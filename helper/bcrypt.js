const bcrypt = require("bcrypt");
const config = require("../config.json").bcrypt;

/**
 * This function will return the encrypted hash
 * @param {string} password 
 * @return Promise
 */
const encryptPassword = (password) => {
	return new Promise((resolve, reject)=>{
		bcrypt.hash(password, config.saltRounds)
			.then((hash) => {
				resolve(hash);
			})
			.catch((error)=>{
				reject(error);
			});
	});
};

/**
 * This function will verify the password of the user
 * @param {string} password 
 * @param {string} dbpassword (Encrypted password)
 * @return Promise
 */
const verifyPassword = (password, dbpassword) => {
	return new Promise((resolve, reject)=>{
		bcrypt.compare(password, dbpassword)
			.then((res) => {
				resolve(res);
			}).catch((error) => {
				reject(error);
			});
	});
};

module.exports = {
	encryptPassword,
	verifyPassword
};