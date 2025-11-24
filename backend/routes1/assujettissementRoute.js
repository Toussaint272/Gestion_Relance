const express = require('express');
const router = express.Router();
const Assujettissement1 = require('../models1/Assujettissement1');


// 🟢 GET /api/assujettissement → maka ny données rehetra
router.get('/', async (req, res) => {
  try {
    const assujettissement1 = await Assujettissement1.findAll();
    res.json(assujettissement1);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// 🟢 GET /api/assujettissement/:fiscal_no → maka ny données par NIF
router.get('/:fiscal_no', async (req, res) => {
  try {
    const { fiscal_no } = req.params;

    const assujettissement1 = await Assujettissement1.findAll({
      where: { fiscal_no },
    });

    // Raha tsy misy données → mamerina liste vide fa tsy erreur
    if (!assujettissement1.length) {
      return res.status(200).json([]);
    }

    res.json(assujettissement1);
  } catch (err) {
    res.status(500).json({ message: 'Erreur serveur', error: err.message });
  }
});

module.exports = router;
