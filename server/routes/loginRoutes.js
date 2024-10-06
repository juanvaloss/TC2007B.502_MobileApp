const express = require('express');
const router = express.Router();
const userControllers = require('../controllers/loginControllers');

router.post('/login', userControllers.loginUser);

module.exports = router;
