'use strict'
var dairyCompanySql = {
    getById: 'SELECT * FROM  dairy_company WHERE userId = ?',
    get: 'SELECT * from dairy_company WHERE userId= ?',
    add: 'INSERT INTO dairy_company SET ?'
}

module.exports = dairyCompanySql;