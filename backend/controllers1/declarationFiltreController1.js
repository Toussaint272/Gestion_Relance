const { Op } = require('sequelize');
const Declaration1 = require('../models1/Declaration1');

exports.getDeclarationsFiltered = async (req, res) => {
  try {
    const { type, dateDebut, dateFin } = req.query;

    console.log('🔍 Filtres reçus :', { type, dateDebut, dateFin });

    const whereClause = {};

    // Filtrage type si tsy "Tous"
    if (type && type !== 'Tous') {
      whereClause.tax_type_no = type;
    }

    // Filtrage dateDebut / dateFin
    if (dateDebut || dateFin) {
      // Date début = min 00:00:00
      const start = dateDebut ? new Date(dateDebut + 'T00:00:00Z') : new Date('2000-01-01T00:00:00Z');
      // Date fin = max 23:59:59
      const end = dateFin ? new Date(dateFin + 'T23:59:59Z') : new Date();

      whereClause.tax_periode = {
        [Op.between]: [start, end]
      };
    }

    const declarations = await Declaration1.findAll({
      where: whereClause,
      order: [['tax_periode', 'DESC']]
    });

    res.status(200).json({
      total: declarations.length,
      declarations
    });

  } catch (error) {
    console.error("💥 Erreur lors du filtrage :", error);
    res.status(500).json({ message: "Erreur serveur", error: error.message });
  }
};

