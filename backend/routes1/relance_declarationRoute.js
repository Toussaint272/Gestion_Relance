const express = require('express');
const router = express.Router();
const relance_declarationController1 = require('../controllers1/relance_declarationController1');

router.post('/send', relance_declarationController1.autoRelanceDeclaration);

// 🔹 Historique relances
router.get('/historique', relance_declarationController1.getAllRelances);

module.exports = router;
