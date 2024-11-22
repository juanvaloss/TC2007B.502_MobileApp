const express = require('express');
const router = express.Router();
const adminControllers = require('../controllers/adminsControllers');

router.post('/create', adminControllers.createAdmin);
router.post('/adminCenters', adminControllers.getAdminApprovedCenters);
router.post('/adminInfo', adminControllers.getAdminInfo);

module.exports = router;
