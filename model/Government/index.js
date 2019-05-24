const db = require('../../helper/mysql');
const governmentSql = require('../../migrations/query/government');

/**
 * Function to add government details into the database
 * @param {Object} req 
 * @param {string} id 
 */
const addGovernment = (req, id) => {
    return new Promise((resolve, reject) => {
        var data = {
            userId: id,
            first_name: req.body.first_name,
            last_name: req.body.last_name,
            gov_org_name: req.body.gov_org_name,
            contact: req.body.contact,
            address_line: req.body.address_line,
            state: req.body.state,
            district: req.body.district
        }

        db.mysqlConnection().then(connection => {
            connection.query(governmentSql.add, data, function (error, results) {
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

module.exports = {
    addGovernment
}