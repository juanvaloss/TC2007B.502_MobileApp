const express = require('express');
const router = express.Router();
const centerController = require('../controllers/centerControllers');

router.post('/create', centerController.createCenter);
router.post('/centerInfo', centerController.getCenterInfo);
router.get('/coordinates', centerController.getAllCoordinates);
router.post('/centerCoordinates', centerController.getCoordinatesById   )

module.exports = router;
