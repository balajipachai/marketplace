const db = require('../../helper/mysql');
const userSql = require('../../database/migrations/query/user');
const uuidv4 = require('uuid/v4');
const async = require('async');
const bcrypt = require('bcrypt');
const constants = require('../../constants.json').bcrypt;
const farmerSql = require('../../database/migrations/query/farmer');
const governmentSql = require('../../database/migrations/query/government');
const diaryOrganisationSql = require('../../database/migrations/query/dairy');
const veterinarianSql = require('../../database/migrations/query/veterinarian');


/**
 * Function will return password of user if email exists in database
 * @param {object} req
 * @param {function} cb
 */
const getUserPassword = (req) => {
    return new Promise((resolve, reject) => {
        db.mysqlConnection().then((connection) => {
            connection.query(userSql.getUserPassword, [req.body.email], function (error, results, fields) {
                if (!error && results.length) {
                    resolve(results[0].password);
                }
                else {
                    reject("Invalid Email");
                }
            });
            connection.release();
        })
    }).catch((error) => {
        reject(error);
    });
};

/**
 * Validate user password
 * @param {string} password
 * @param {string} dbpassword
 */
const validatePassword = (password, dbpassword) => {
    return bcrypt.compareSync(password, dbpassword);
};

/**
 * Store user details in database when user register for the application
 * @param {object} req
 * @param {function} cb
 */
const storeUserDetails = (req, account) => {
    return new Promise((resolve, reject) => {
        db.mysqlConnection().then(connection => {
            var data = {
                id: uuidv4(),
                password: getEncryptedHash(req.body.password),
                email: req.body.email,
                userType: req.body.userTypeId,
                ethereum_account: account
            };
            connection.query(userSql.insertIntoUser, data, function (error, results, fields) {
                if (!error) {
                    resolve(data.id);
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
};

/**
 * Function to check whether email already used or not
 * @param {string} email
 */
const isDuplicateEmail = (email) => {
    return new Promise((resolve, reject) => {
        db.mysqlConnection().then(connection => {
            connection.query(userSql.getUserCount, [email], function (error, results, fields) {
                if (!error) {
                    if (results[0].usercount) {
                        reject("Email Already use");
                    } else {
                        resolve(true);
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
};

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
            connection.query(userSql.getUserData, [req.body.email], function (error, results) {
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
};



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
    isDuplicateEmail,
    getUserDetails
};
