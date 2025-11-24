const express = require('express');
const router = express.Router();
const totalDefaillantController1 = require('../controllers1/totalDefaillantController1');

// 🟧 Récupération globale de tous les défaillants
router.get('/all', totalDefaillantController1.getAllDefaillants);

module.exports = router;
