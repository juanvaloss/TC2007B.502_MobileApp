const express = require('express');
const router = express.Router();
const requestController = require('../controllers/requestsControllers');

router.post('/getReqInfo', requestController.getRequestInfo);
router.post('/create', requestController.createRequest);
router.post('/delete', requestController.deleteRequest);

module.exports = router;
