/*const express = require('express');
const router = express.Router();
const Declaration1 = require('../models1/Declaration1');

// 🔹 GET toutes les déclarations
router.get('/', async (req, res) => {
  try {
    const data = await Declaration1.findAll({
      order: [['N_decl', 'DESC']]
    });
    res.json(data);
  } catch (err) {
    console.error('Erreur:', err.message);
    res.status(500).json({ error: err.message });
  }
});
// GET declarations par tax_payer_no
router.get('/:tax_payer_no', async (req, res) => {
  try {
    const tax_payer_no = req.params.tax_payer_no;
    const data = await Declaration1.findAll({ where: { tax_payer_no } });
    res.json(data); // miverina lisitra foana, na banga aza
  } catch (err) {
    res.status(500).json({ message: 'Erreur serveur' });
  }

});


module.exports = router;*/


const express = require('express');
const router = express.Router();
const Declaration1 = require('../models1/Declaration1');

// 🔹 GET toutes les déclarations
router.get('/', async (req, res) => {
  try {
    const data = await Declaration1.findAll({ order: [['N_decl', 'DESC']] });

    // Calcul automatique du statut
    const result = data.map(d => {
      const echeance = d.date_echeance ? new Date(d.date_echeance) : null;
      const received = d.received_date ? new Date(d.received_date) : null;
      let statut;

      if (!received) statut = 'Non reçu';
      else if (echeance && received > echeance) statut = 'En retard';
      else statut = 'Valide';

      return { ...d.toJSON(), statut };
    });

    res.json(result);
  } catch (err) {
    console.error('Erreur serveur:', err.message);
    res.status(500).json({ message: 'Erreur serveur', error: err.message });
  }
});

// 🔹 GET declarations par tax_payer_no
router.get('/:tax_payer_no', async (req, res) => {
  try {
    const tax_payer_no = req.params.tax_payer_no;
    const data = await Declaration1.findAll({ where: { tax_payer_no } });

    const result = data.map(d => {
      const echeance = d.date_echeance ? new Date(d.date_echeance) : null;
      const received = d.received_date ? new Date(d.received_date) : null;
      let statut;

      if (!received) statut = 'Non reçu';
      else if (echeance && received > echeance) statut = 'En retard';
      else statut = 'Valide';

      return { ...d.toJSON(), statut };
    });

    res.json(result);
  } catch (err) {
    console.error('Erreur serveur:', err.message);
    res.status(500).json({ message: 'Erreur serveur', error: err.message });
  }
});

module.exports = router;
