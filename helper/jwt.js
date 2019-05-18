const jwt = require("jsonwebtoken");
const fs = require("fs");
const config = require("../config.json").jwt;
const path = require("path");

/**
 * Create a json web token of the login user
 * @param {object} data 
 * @return Promise
 */
const createToken = (data) => {
	return new Promise((resolve, reject) => {
		var privateKey = fs.readFileSync(path.join(__dirname+"/key"+"/private.key"));
		var payload = { exp: (Math.floor(Date.now() / 1000) + config.expiry), data: data };
		jwt.sign(payload, privateKey, {algorithm:config.algorithm}, function(err,token){
			if(err){
				reject(err);
			}
			else {
				resolve(token);

			}
		});
		

	});
};

/**
 * Verify the JWT token
 * @param {string} data 
 * @return Promise
 */
const verifyToken = (token) => {
	return new Promise((resolve, reject) => {
		var publicKey = fs.readFileSync(path.join(__dirname+"/key"+"/private.key.pub"));
		jwt.verify(token, publicKey, function(err, decoded){
			if(!err){
				resolve(decoded);
			}
			else {
				reject(err.message);
			}
		});
	});
};

module.exports = {
	createToken,
	verifyToken
};