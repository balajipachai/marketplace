'use strict'
var loginSql = {
    getUserPassword: 'SELECT password FROM  user WHERE email = ?',
    getUserData: 'SELECT * from user WHERE email= ?',
    insertIntoUser: 'INSERT INTO user SET ?',
    getUserCount: 'SELECT count(*) as usercount from user where email = ?'
}

module.exports = loginSql;