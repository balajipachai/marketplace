const db = require('../../helper/mysql');
const farmerSql = require('../../database/migrations/query/farmer');

/**
 * Function to add farmer details into the database
 * @param {Object} req
 * @param {string} id
 */
const addFarmer = (req, id) => {
    return new Promise((resolve, reject) => {
        let data = {
            userId: id,
            UID: req.body.UID,
            first_name: req.body.first_name,
            last_name: req.body.last_name,
            address_line: req.body.address_line,
            state: req.body.state,
            district: req.body.district,
            village: req.body.village,
            birth_date: req.body.birth_date
        };

        db.mysqlConnection().then(connection => {
            connection.query(farmerSql.add, data, function (error, results) {
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
    addFarmer
};
