const express = require('express');
const router = express.Router();
const applicationController = require('../controllers/applicationsControllers');

router.post('/getReqInfo', applicationController.getApplicationInfo);
router.post('/create', applicationController.createApplication);
router.post('/delete', applicationController.deleteApplication);

module.exports = router;
