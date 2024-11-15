const express = require('express');
const router = express.Router();
const userControllers = require('../controllers/userControllers');

router.post('/create', userControllers.createUser);
router.post('/userInfo', userControllers.getUserInfo);
router.post('/userCenters', userControllers.getUserCenters);
router.patch('/updateAdmin', userControllers.updateAdminValue);
router.post('/delete', userControllers.deleteUser);


module.exports = router;
