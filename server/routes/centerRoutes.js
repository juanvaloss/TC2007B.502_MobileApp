const express = require('express');
const router = express.Router();
const centerController = require('../controllers/centerControllers');

router.post('/create', centerController.createCenter);
router.get('/coordinates', centerController.getAllCoordinates);

module.exports = router;

/*
{
    "adminId": 2,
    "centerName": "Catedral de GDL.",
    "centerAddress": "Av. Fray Antonio Alcalde 10, Zona Centro, 44100 Guadalajara, Jal.",
    "lat": "20.6772447924935",
    "lon": "-103.34691426256785"
}
     */