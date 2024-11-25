const express = require('express');
const router = express.Router();
const collectionController = require('../controllers/collectionsControllers');

router.get('/getAll', collectionController.getAllCollections);
router.post('/register', collectionController.registerCollection);

module.exports = router;