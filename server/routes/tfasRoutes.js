const express = require('express');
const router = express.Router();
const tfaController = require("../controllers/tfasControllers");

router.post('/', tfaController.twoFactAuthVerification);

module.exports = router;
