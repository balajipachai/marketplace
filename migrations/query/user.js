'use strict'
var loginSql = {
    getUserPassword: 'SELECT password FROM  user WHERE username = ?',
    getUserData: 'SELECT * from user WHERE username= ?',
    insertIntoUser: 'INSERT INTO user SET ?',
    getUserCount: 'SELECT count(*) as usercount from user where username = ?'
}

module.exports = loginSql;