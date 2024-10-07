const express = require('express');
const router = express.Router();
const userControllers = require('../controllers/userControllers');

router.post('/login', userControllers.loginUser);
router.post('/create', userControllers.createUser);

module.exports = router;
