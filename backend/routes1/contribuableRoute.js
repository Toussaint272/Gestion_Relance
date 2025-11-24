const express = require('express');
const router = express.Router();
const Contribuable1 = require('../models1/Contribuable1');

// 🔹 GET all contribuables
router.get('/', async (req, res) => {
  try {
    const contribuables1 = await Contribuable1.findAll();
    res.json(contribuables1);
  } catch (err) {
    res.status(500).json({ message: 'Erreur serveur', error: err.message });
  }
});
// 🔹 Rechercher contribuable par tax_payer_no
router.get('/:taxPayerNo', async (req, res) => {
  try {
    const contribuables1 = await Contribuable1.findOne({
      where: { tax_payer_no: req.params.taxPayerNo }
    });

    if (!contribuables1) {
      return res.status(404).json({ message: 'Contribuable non trouvé' });
    }

    res.json(contribuables1);
  } catch (error) {
    console.error('Erreur serveur:', error);
    res.status(500).json({ message: 'Erreur serveur' });
  }
});

// 🔹 Rechercher contribuable par NIF
router.get('/nif/:nif', async (req, res) => {
  try {
    const contribuables1 = await Contribuable1.findOne({
      where: { nif: req.params.nif }
    });

    if (!contribuables1) {
      return res.status(404).json({ message: 'Contribuable non trouvé' });
    }

    res.json(contribuables1);
  } catch (error) {
    console.error('Erreur serveur:', error);
    res.status(500).json({ message: 'Erreur serveur' });
  }
});



module.exports = router;
