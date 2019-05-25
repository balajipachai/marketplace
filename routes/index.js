const express = require('express');
const router = express.Router();

/* GET home page. */
router.get('/', function(req, res, next) {
  res.render('login/login', { title: 'Express' });
});

/* GET home page. */
router.get('/register', function(req, res, next) {
  res.render('login/register', { title: 'Express' });
});

module.exports = router;
