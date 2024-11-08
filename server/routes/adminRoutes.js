const express = require('express');
const router = express.Router();
const adminControllers = require('../controllers/adminsControllers');

router.post('/login', adminControllers.loginAdmin);
router.post('/create', adminControllers.createAdmin);
router.post('/adminInfo', adminControllers.getAdminInfo);


module.exports = router;