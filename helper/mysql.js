const mysql = require('mysql');
const db = require('../database/database').development;
const pool = mysql.createPool(db);

/**
 * Create a connection pool and return one connection to the user
 * @param {*} cb
 */
const mysqlConnection = () => {
    return new Promise((resolve, reject)=> {
        pool.getConnection(function (err, connection) {
            if (err) {
                reject(err);
            } else {
                resolve(connection);
            }
        });
    })

};

module.exports = {
    mysqlConnection
};

//use this
/*
        connection.query('SELECT something FROM sometable', function (error, results, fields) {
          // When done with the connection, release it.
          connection.release();

          // Handle error after the release.
          if (error) throw error;

          // Don't use the connection here, it has been returned to the pool.
        });
*/
