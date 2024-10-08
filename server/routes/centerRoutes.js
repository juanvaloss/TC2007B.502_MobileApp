const express = require('express');
const router = express.Router();
const centerController = require('../controllers/centerControllers');

router.post('/create', centerController.createCenter);
router.get('/coordinates', centerController.getAllCoordinates);

module.exports = router;
