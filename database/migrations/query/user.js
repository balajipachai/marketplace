'use strict';
var loginSql = {
    getUserPassword: 'SELECT password FROM  user WHERE email = ?',
    getUserData: 'SELECT * from user WHERE email= ?',
    insertIntoUser: 'INSERT INTO user SET ?',
    getUserCount: 'SELECT count(*) as usercount from user where email = ?',
    delete: 'DELETE from user, farmers, government, dairy_company, veterinarians WHERE user.id = farmers.userId OR user.id = veterinarians.userId OR user.id <> dairy_company.userId AND user.id <> government.userId AND user.id = ? '
};

module.exports = loginSql;
