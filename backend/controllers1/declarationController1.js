const { Declaration1 } = require('../models1');
const { Op } = require('sequelize');

exports.getAllDeclarations = async (req, res) => {
  try {
    const declaration1 = await Declaration1.findAll();

    const data = declaration1.map((d) => {
  const received = new Date(d.received_date);
  const echeance = new Date(d.date_echeance);

  let statut = '';
  if (received <= echeance) {
    statut = 'Déclaré à temps';
  } else {
    statut = 'En retard';
  }

  return {
    ...d.toJSON(),
    statut,
  };
});

    res.json(data);
  } catch (error) {
    console.error('Erreur:', error);
    res.status(500).json({ message: 'Erreur serveur' });
  }
};
