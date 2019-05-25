const db = require('../../helper/mysql');
const VeterinarianSql = require('../../migrations/query/veterinarian');

/**
 * Function to add government details into the database
 * @param {Object} req 
 * @param {string} id 
 */
const addVeterinarian = (req, id) => {
    return new Promise((resolve, reject) => {
        var data = {
            userId: id,
            UID: req.body.UID,
            doctor_id: req.body.doctor_id,
            first_name: req.body.first_name,
            last_name: req.body.last_name,
            address_line: req.body.address_line,
            state: req.body.state,
            district: req.body.district,
            village: req.body.village,
            birth_date: req.body.birth_date,
            contact: req.body.contact
        };

        db.mysqlConnection().then(connection => {
            connection.query(VeterinarianSql.add, data, function (error, results) {
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
    addVeterinarian
}