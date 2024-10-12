const express = require('express');
const router = express.Router();
const donationController = require('../controllers/donationsControllers');

router.post('/register', donationController.registerDonation);

module.exports = router;
