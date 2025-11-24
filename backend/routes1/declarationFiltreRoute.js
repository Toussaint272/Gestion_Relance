const express = require('express');
const router = express.Router();
const declarationFiltreController1 = require('../controllers1/declarationFiltreController1');

// ✅ GET /api/declarations/filter?type=TVA&start=2024-01-01&end=2024-12-31
router.get('/filtre', declarationFiltreController1.getDeclarationsFiltered);

module.exports = router;
