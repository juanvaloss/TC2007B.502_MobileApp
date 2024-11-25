const express = require('express');
const router = express.Router();
const applicationController = require('../controllers/applicationsControllers');

router.post('/getApplicationInfo', applicationController.getApplicationInfo);
router.post('/create', applicationController.createApplication);
router.post('/deleteAll', applicationController.deleteAllAplicationsFromUser);
router.post('/delete', applicationController.deleteApplication);
router.get('/getAll', applicationController.getAllApplications);

module.exports = router;
