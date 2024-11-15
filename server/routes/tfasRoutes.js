const express = require('express');
const router = express.Router();
const tfaController = require("../controllers/tfasControllers");

router.post('/1', tfaController.twoFactAuthVerificationUser);
router.post('/2', tfaController.twoFactAuthVerificationAdmin);
router.post('/newCode', tfaController.getNewCode);


module.exports = router;
