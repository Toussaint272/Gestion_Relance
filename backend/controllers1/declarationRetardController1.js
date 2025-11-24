const { Op, Sequelize } = require('sequelize');
const Declaration1 = require('../models1/Declaration1');

// 🟠 GET - Liste des déclarations en retard
exports.getDeclarationsEnRetard = async (req, res) => {
  try {
    const declarations = await Declaration1.findAll({
      where: {
        received_date: {
          [Op.gt]: Sequelize.col('date_echeance') // reçu après la date d'échéance
        }
      },
      order: [['date_echeance', 'DESC']]
    });

    if (!declarations || declarations.length === 0) {
      return res.status(200).json([]); // pas d'erreur, juste liste vide
    }

    res.status(200).json(declarations);

  } catch (error) {
    console.error("❌ Erreur lors de la récupération des déclarations en retard :", error);
    res.status(500).json({ message: "Erreur interne du serveur" });
  }
};
