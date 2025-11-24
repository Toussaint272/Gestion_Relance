const Paiement1 = require('../models1/Paiement1'); // tsy misy destructuring
const Contribuable1 = require('../models1/Contribuable1');
const Declaration1 = require('../models1/Declaration1');

exports.getAllPaiements = async (req, res) => {
  try {
    const paiements = await Paiement1.findAll({
      include: [
        { model: Contribuable1, attributes: ['id','tax_payer_no','rs'],
          as: 'contribuables1'  // ✅ mitovy amin'ny alias ao amin'ny model
         },
        { model: Declaration1, attributes: ['N_decl','tax_type_no','tax_periode','montant_liquide'] }
      ]
    });

    const paiementsAvecCalcul = paiements.map(p => {
      const montant_liquide = p.Declaration1 ? parseFloat(p.Declaration1.montant_liquide) : 0;
      const montant_payer = parseFloat(p.montant_payer || 0);
      return {
        id: p.id_paiement,
        tax_payer_no: p.tax_payer_no,
        contribuable: p.contribuables1 ? p.contribuables1.rs : null,
        N_decl: p.N_decl,
        montant_payer,
        date_payment: p.date_payment,
        mode_paiement: p.mode_paiement,
        valider: p.valider,
        montant_liquide,
        reste_a_recouvrer: montant_liquide - montant_payer
      };
    });

    res.json(paiementsAvecCalcul);
  } catch (error) {
    console.error('Erreur lors du chargement des paiements :', error);
    res.status(500).json({ message: 'Erreur lors de la récupération des paiements', error });
  }
};

exports.createPaiement = async (req, res) => {
  try {
    const newPaiement = await Paiement1.create(req.body);
    res.status(201).json(newPaiement);
  } catch (error) {
    console.error('Erreur lors de la création du paiement :', error);
    res.status(500).json({ message: 'Erreur serveur', error });
  }
};


// 🟢 Récupérer paiements d’un contribuable par tax_payer_no
exports.getPaiementsByContribuable = async (req, res) => {
  try {
    const { tax_payer_no } = req.params;
    const paiements = await Paiement1.findAll({
      where: { tax_payer_no },
    });

    if (paiements.length === 0) {
      return res.status(404).json({ message: 'Aucun paiement trouvé pour ce contribuable' });
    }

    res.json(paiements);
  } catch (error) {
    res.status(500).json({ message: 'Erreur serveur', error });
  }
};
