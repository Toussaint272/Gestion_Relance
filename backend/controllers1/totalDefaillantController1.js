const Declaration1 = require('../models1/Declaration1');
const Paiement1 = require('../models1/Paiement1');
const Contribuable1 = require('../models1/Contribuable1');

exports.getAllDefaillants = async (req, res) => {
  try {
    console.log("📌 Récupération des contribuables défaillants (global)");

    const contribuables = await Contribuable1.findAll({
      attributes: ['tax_payer_no', 'rs', 'centre']
    });

    const defaillants = [];

    for (const c of contribuables) {
      // 1️⃣ Vérifier déclaration
      const decl = await Declaration1.findOne({
        where: { tax_payer_no: c.tax_payer_no }
      });
      const decl_exist = !!decl;

      // 2️⃣ Vérifier paiement
      const pay = await Paiement1.findOne({
        where: { tax_payer_no: c.tax_payer_no }
      });

      let pay_exist = false;
      let valider = false;
      let reste = 0;

      if (pay) {
        pay_exist = true;
        valider = pay.valider === true;
        reste = parseFloat(pay.reste_a_recouvrer || 0);
      }

      // 🔍 LOGIQUE DÉFAILLANT
      if (!decl_exist) {
        defaillants.push({
          tax_payer_no: c.tax_payer_no,
          contribuable: c.rs,
          centre: c.centre,
          motif: "Aucune déclaration"
        });
      } else if (!pay_exist) {
        defaillants.push({
          tax_payer_no: c.tax_payer_no,
          contribuable: c.rs,
          centre: c.centre,
          motif: "Aucun paiement"
        });
      } else if (valider === false || reste > 0) {
        defaillants.push({
          tax_payer_no: c.tax_payer_no,
          contribuable: c.rs,
          centre: c.centre,
          motif: "Paiement incomplet ou non validé"
        });
      }
    }

    return res.status(200).json({
      totalDefaillants: defaillants.length,
      defaillants
    });

  } catch (error) {
    console.error("❌ Erreur récupération défaillants :", error);
    return res.status(500).json({
      message: "Erreur serveur"
    });
  }
};
