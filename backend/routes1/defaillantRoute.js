const express = require('express');
const router = express.Router();
const defaillantController1 = require('../controllers1/defaillantController1');

// 🟢 Filtrer les contribuables défaillants par centre fiscal
router.get('/:centreName', defaillantController1.getDefaillantsParCentre);

module.exports = router;
