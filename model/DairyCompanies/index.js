const db = require('../../helper/mysql');
const dairySql = require('../../database/migrations/query/dairy');

/**
 * Function to add dairy company details into the database
 * @param {Object} req
 * @param {string} id
 */
const addDairyCompany = (req, id) => {
    return new Promise((resolve, reject) => {
        let data = {
            userId: id,
            org_name: req.body.org_name,
            first_name: req.body.first_name,
            last_name: req.body.last_name,
            address_line: req.body.address_line,
            state: req.body.state,
            district: req.body.district
        };

        db.mysqlConnection().then(connection => {
            connection.query(dairySql.add, data, function (error, results) {
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

module.exports = {
    addDairyCompany
};
