const express = require('express');
const router = express.Router();
const Contribuable1 = require('../models1/Contribuable1');

// 🟢 Récupérer la liste unique des centres fiscaux
router.get('/', async (req, res) => {
  try {
    const centres = await Contribuable1.findAll({
      attributes: ['centre'],
      group: ['centre'], // 🔹 éviter les doublons
      order: [['centre', 'ASC']],
    });

    const liste = centres.map(c => c.centre);
    res.json(liste);
  } catch (error) {
    console.error('Erreur lors du chargement des centres :', error);
    res.status(500).json({ message: 'Erreur serveur' });
  }
});

module.exports = router;
