// routes/statsRoutes1.js
const express = require('express');
const router = express.Router();
const stats = require('../controllers1/statsController1');

router.get('/overview', stats.overview);
router.get('/monthly-relances', stats.monthlyRelances);
router.get('/declaration-distribution', stats.declarationDistribution);
router.get('/top-agents', stats.getTopAgents);
router.get('/paiement-stats', stats.paiementStats); // ✅ vaovao
router.get('/defaillants', stats.totalContribuablesDefaillants);
//teste
router.get('/type-declaration', stats.statsByDeclarationType);
router.get('/declaration-periode', stats.statsDeclarationByPeriod);


module.exports = router;
