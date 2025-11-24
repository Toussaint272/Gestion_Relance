// controllers/statsController1.js
const { Op, fn, col, literal, Sequelize } = require('sequelize');
const Declaration1 = require('../models1/Declaration1');
const Paiement1 = require('../models1/Paiement1');
const Contribuable1 = require('../models1/Contribuable1');
//const Relance1 = require('../models1/Relance1');
//const User1 = require('../models1/User1');
const { Relance1, User1 } = require('../models1/associations');

exports.overview = async (req, res) => {
  try {
    const totalDeclarations = await Declaration1.count();
    const totalContribuables = await Contribuable1.count();
    const enRetard = await Declaration1.count({ where: { statut: 'En retard' } });
    const nonRecues = await Declaration1.count({ where: { received_date: null } });
    const totalRelances = await Relance1.count();
    const agentsActifs = await User1.count({ where: { role: 'agent' } });
    const totalPaiements = await Paiement1.count();

    // 🧮 Calcul des contribuables défaillants
    const defaillantsDeclaration = await Declaration1.findAll({
      where: {
        statut: { [Op.in]: ['Non reçu'] }
      },
      attributes: ['tax_payer_no'],
      raw: true,
    });

    const defaillantsPaiement = await Paiement1.findAll({
      where: { valider: false },
      attributes: ['tax_payer_no'],
      raw: true,
    });

    const contribuablesSansDeclaration = await Contribuable1.findAll({
  attributes: ['tax_payer_no'],
  where: {
    tax_payer_no: {
      [Op.notIn]: Sequelize.literal('(SELECT DISTINCT tax_payer_no FROM Declaration1)')
    }
  },
  raw: true
});

    const allDefaillants = new Set([
      ...defaillantsDeclaration.map(d => d.tax_payer_no),
      ...defaillantsPaiement.map(p => p.tax_payer_no),
      ...contribuablesSansDeclaration.map(c => c.tax_payer_no),   // ← 🔥 KEY FIX
    ]);

    const totalDefaillants = allDefaillants.size;

    res.json({
      totalDeclarations,
      totalContribuables,
      enRetard,
      nonRecues,
      totalRelances,
      agentsActifs,
      totalPaiements,
      totalDefaillants, // ✅ champ ajouté ici
    });
  } catch (err) {
    console.error('stats.overview', err);
    res.status(500).json({ message: 'Erreur serveur', error: err.message });
  }
};

// Monthly relances: return [{ month: '2025-11', count: 12 }, ...]
exports.monthlyRelances = async (req, res) => {
  try {
    // MySQL: use DATE_FORMAT on date_envoi or createdAt
    const rows = await Relance1.findAll({
      attributes: [
        [fn('DATE_FORMAT', col('date_envoi'), '%Y-%m'), 'month'],
        [fn('COUNT', col('*')), 'count'],
      ],
      where: {
        date_envoi: { [Op.ne]: null },
      },
      group: [literal("DATE_FORMAT(date_envoi,'%Y-%m')")],
      order: [[literal("DATE_FORMAT(date_envoi,'%Y-%m')"), 'ASC']],
      raw: true,
    });

    res.json(rows);
  } catch (err) {
    console.error('stats.monthlyRelances', err);
    res.status(500).json({ message: 'Erreur serveur', error: err.message });
  }
};

// Distribution of declarations by statut (Valide / En retard / Non reçu)
exports.declarationDistribution = async (req, res) => {
  try {
    const rows = await Declaration1.findAll({
      attributes: ['statut', [fn('COUNT', col('*')), 'count']],
      group: ['statut'],
      raw: true,
    });
    // Normalize to object { Valide: n, 'En retard': m, 'Non reçue': x }
    const result = {};
    rows.forEach(r => { result[r.statut || 'Unknown'] = Number(r.count); });
    res.json(result);
  } catch (err) {
    console.error('stats.declarationDistribution', err);
    res.status(500).json({ message: 'Erreur serveur', error: err.message });
  }
};

// Top agents by number of relances (requires Relance1.id_agent existant)
exports.getTopAgents = async (req, res) => {
  try {
    const topAgents = await Relance1.findAll({
      attributes: [
        'matricule',
        [Sequelize.fn('COUNT', Sequelize.col('Relance1.id')), 'total_relances'],
      ],
      include: [
        {
          model: User1,
          as: 'agent',
          attributes: ['nom', 'prenom'],
        },
      ],
      group: ['Relance1.matricule', 'agent.matricule', 'agent.nom', 'agent.prenom'],
      order: [[Sequelize.literal('total_relances'), 'DESC']],
      raw: true,
    });

    res.json(topAgents);
  } catch (error) {
    console.error('stats.getTopAgents', error);
    res.status(500).json({
      message: 'Erreur lors du chargement des statistiques des agents',
      error: error.message,
    });
  }
};

// 5️⃣ Statistiques des paiements
// ------------------
exports.paiementStats = async (req, res) => {
  try {
    // Compter le nombre de paiements valides et non valides
    const valides = await Paiement1.count({ where: { valider: true } });
    const nonValides = await Paiement1.count({ where: { valider: false } });

    res.json({
      Valide: valides,
      'Non valide': nonValides,
    });

  } catch (err) {
    console.error('stats.paiementStats', err);
    res.status(500).json({ message: 'Erreur serveur', error: err.message });
  }
};

//totalContribuablesDefaillants
exports.totalContribuablesDefaillants = async (req, res) => {
  try {
    // 1️⃣ Contribuables avec déclaration en retard
    const declarRetard = await Declaration1.findAll({
      attributes: [[Sequelize.fn('DISTINCT', Sequelize.col('tax_payer_no')), 'tax_payer_no']],
      where: {
        statut: { [Op.in]: ['Non reçu'] }
      },
      raw: true,
    });

    // 2️⃣ Contribuables avec paiement non validé
    const paiementNonValide = await Paiement1.findAll({
      attributes: [[Sequelize.fn('DISTINCT', Sequelize.col('tax_payer_no')), 'tax_payer_no']],
      where: { valider: false },
      raw: true,
    });
//teste
    const contribuablesSansDeclaration = await Contribuable1.findAll({
  attributes: ['tax_payer_no'],
  where: {
    tax_payer_no: {
      [Op.notIn]: Sequelize.literal('(SELECT DISTINCT tax_payer_no FROM Declaration1)')
    }
  },
  raw: true
});

    // 3️⃣ Fusionner les tax_payer_no distincts
    const allDefaillants = new Set([
      ...declarRetard.map(d => d.tax_payer_no),
      ...paiementNonValide.map(p => p.tax_payer_no),
      ...contribuablesSansDeclaration.map(c => c.tax_payer_no),   // ← 🔥 KEY FIX
    ]);

    const totalDefaillants = allDefaillants.size;

    res.json({ totalDefaillants: allDefaillants.size });
  } catch (err) {
    console.error(err);
    res.status(500).json({ message: 'Erreur serveur', error: err.message });
  }
};

// 6️⃣ Statistiques par type de déclaration
exports.statsByDeclarationType = async (req, res) => {
  try {
    const rows = await Declaration1.findAll({
      attributes: [
        'tax_type_no',
        [Sequelize.fn('COUNT', Sequelize.col('*')), 'count']
      ],
      group: ['tax_type_no'],
      raw: true,
    });

    // Convertir en objet propre
    const result = {};
    rows.forEach(r => {
      result[r.tax_type_no] = Number(r.count);
    });

    res.json(result);
  } catch (err) {
    console.error('stats.statsByDeclarationType', err);
    res.status(500).json({ message: 'Erreur serveur', error: err.message });
  }
};

// 7️⃣ Statistiques des déclarations par période (par mois)
exports.statsDeclarationByPeriod = async (req, res) => {
  try {
    const rows = await Declaration1.findAll({
      attributes: [
        [Sequelize.fn('DATE_FORMAT', Sequelize.col('tax_periode'), '%Y-%m'), 'periode'],
        [Sequelize.fn('COUNT', Sequelize.col('*')), 'count'],
      ],
      group: [Sequelize.literal("DATE_FORMAT(tax_periode,'%Y-%m')")],
      order: [[Sequelize.literal("DATE_FORMAT(tax_periode,'%Y-%m')"), 'ASC']],
      raw: true,
    });

    res.json(rows);
  } catch (err) {
    console.error('stats.statsDeclarationByPeriod', err);
    res.status(500).json({ message: 'Erreur serveur', error: err.message });
  }
};
