const db = require('../../helper/mysql');
const userSql = require('../../migrations/query/user');
const uuidv4 = require('uuid/v4');
const async = require('async');
const bcrypt = require('bcrypt');
const constants = require('../../constants.json').bcrypt;

/**
 * Function will return password of user if username exists in database
 * @param {object} req 
 * @param {function} cb 
 */
const getUserPassword = (req) => {
    return new Promise((resolve, reject) => {
        db.mysqlConnection().then((connection) => {
            connection.query(userSql.getUserPassword, [req.body.username], function (error, results, fields) {
                if (!error && results.length) {
                    resolve(results[0].password);
                }
                else {
                    reject("Invalid Username");
                }
            });
            connection.release();
        })
    }).catch((error) => {
        reject(error);
    });
}

/**
 * Validate user password
 * @param {string} password 
 * @param {string} dbpassword 
 */
const validatePassword = (password, dbpassword) => {
    return bcrypt.compareSync(password, dbpassword);
}

/**
 * Store user details in database when user register for the application
 * @param {object} req 
 * @param {function} cb 
 */
const storeUserDetails = (req, account) => {
    return new Promise((resolve, reject) => {
        db.mysqlConnection().then(connection => {
            var data = {
                first_name: req.body.first_name,
                last_name: req.body.last_name,
                id: uuidv4(),
                username: req.body.username,
                password: getEncryptedHash(req.body.password),
                email: req.body.email,
                gender: req.body.gender,
                mobile_number: req.body.mobile_number,
                type: req.body.userTypeId,
                ethereum_account: account,
                uat: new Date(),
                cat: new Date()
            }
            connection.query(userSql.insertIntoUser, data, function (error, results, fields) {
                if (!error) {
                    resolve(results);
                }
                else {
                    reject("Error in data insertion" + error);
                }
            });
            connection.release();
        }).catch((error) => {
            reject(error);
        });
    });
}

/**
 * Function to check whether username already used or not
 * @param {string} username 
 */
const isDuplicateUsername = (username) => {
    return new Promise((resolve, reject) => {
        db.mysqlConnection().then(connection => {
            connection.query(userSql.getUserCount, [username], function (error, results, fields) {
                if (!error) {
                    if (results[0].usercount) {
                        resolve(true);
                    } else {
                        reject(false);
                    }
                }
                else {
                    reject("Database connection error" + error);
                }
            });
            connection.release();
        }).catch((error) => {
            reject(error);
        });
    })
}

/**
 * Returns encrypted password
 * @param {string} password 
 */
const getEncryptedHash = (password) => {
    return bcrypt.hashSync(password, constants.saltRounds);
};

const getUserDetails = (req) => {
    return new Promise((resolve, reject) => {
        db.mysqlConnection().then(connection => {
            connection.query(userSql.getUserData, [req.body.username], function (error, results) {
                if (!error) {
                    resolve(results);
                }
                else {
                    reject(error);
                }
            });
            connection.release();
        }).catch((error) => {
            reject(error);
        });
    })
}


//TODO
//forgot password
//change password
//login with gmail
//login with facebook
//login with twitter

module.exports = {
    validatePassword,
    getUserPassword,
    storeUserDetails,
    isDuplicateUsername,
    getUserDetails
}