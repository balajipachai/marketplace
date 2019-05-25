const express = require('express');
const router = express.Router();
const LoginController = require('../../controller/Login/user')

/* GET home page. */
router.post('/login', LoginController.login );

/* GET home page. */
router.post('/register', LoginController.register);


module.exports = router;
