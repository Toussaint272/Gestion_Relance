const express = require('express');
const router = express.Router();
const relanceController1 = require('../controllers1/relanceController1');

// POST /api/relances
router.post('/send', relanceController1.sendRelance);
// 🔹 Route : toutes les relances effectuées
router.get('/effectuees', relanceController1.getAllRelances);

// GET /api/relanceRoute/filtre-centre?centre=....
router.get('/filtre-centre', relanceController1.getByCentreFiscal);

module.exports = router;
