'use strict'
var governmentSql = {
    getById: 'SELECT * FROM  government WHERE userId = ?',
    get: 'SELECT * from government WHERE userId= ?',
    add: 'INSERT INTO government SET ?'
}

module.exports = governmentSql;