'use strict';
var veterinariansSql = {
    getById: 'SELECT * FROM  veterinarians WHERE userId = ?',
    get: 'SELECT * from veterinarians WHERE userId= ?',
    add: 'INSERT INTO veterinarians SET ?'
};

module.exports = veterinariansSql;
