const express = require('express');
const router = express.Router();
const userControllers = require('../controllers/userControllers');

router.post('/create', userControllers.createUser);
router.post('/userInfo', userControllers.getUserInfo);
router.post('/userCenter', userControllers.getUserCenters);
router.post('/userApplication', userControllers.getUserApplication);
router.patch('/updateAdmin', userControllers.updateAdminValue);
router.post('/delete', userControllers.deleteUser);


module.exports = router;
