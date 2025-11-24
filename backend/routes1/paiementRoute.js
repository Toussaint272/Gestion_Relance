const express = require('express');
const router = express.Router();
const paiementController1 = require('../controllers1/paiementController1');

// Route affichage paiements
router.get('/', paiementController1.getAllPaiements);
//router.post('/', paiementController1.createPaiement);
// ✅ Route: récupérer les paiements d’un contribuable spécifique
router.get('/contribuable/:tax_payer_no', paiementController1.getPaiementsByContribuable);


module.exports = router;
