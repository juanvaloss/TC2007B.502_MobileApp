const express = require('express');
const router = express.Router();
const loginController = require('../controllers/loginControllers');

router.post('/global', loginController.globalLogin);

module.exports = router;