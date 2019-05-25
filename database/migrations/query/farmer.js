'use strict';
var farmerSql = {
    getById: 'SELECT * FROM  farmers WHERE userId = ?',
    get: 'SELECT * from farmers WHERE userId= ?',
    add: 'INSERT INTO farmers SET ?'
};

module.exports = farmerSql;
