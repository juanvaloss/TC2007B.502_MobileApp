const express = require('express');
const router = express.Router();
const requestController = require('../controllers/requestsControllers');

router.post('/create', requestController.createRequest);

module.exports = router;
