const express = require('express');
const router = express.Router();
const tfaController = require("../controllers/tfasControllers");

router.post('/1', tfaController.twoFactAuthVerificationUser);
router.post('/2', tfaController.twoFactAuthVerificationAdmin);
router.post('/newCode/1', tfaController.getNewCodeUser);
router.post('/newCode/2', tfaController.getNewCodeAdmin);



module.exports = router;
