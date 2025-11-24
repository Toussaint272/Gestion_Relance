/*const Declaration1 = require('../models1/Declaration1');
const Paiement1 = require('../models1/Paiement1');
const Contribuable1 = require('../models1/Contribuable1');

exports.getDefaillantsParCentre = async (req, res) => {
  try {
    const { centreName } = req.params;

    // 🔍 1. Récupérer les contribuables du centre donné
    const contribuables = await Contribuable1.findAll({
      where: { centre: centreName },
      attributes: ['tax_payer_no','rs', 'centre']
    });

    console.log(`🔍 ${contribuables.length} contribuables trouvés pour ${centreName}`);

    const defaillants = [];

    // 🔄 2. Boucler sur chaque contribuable
    for (const c of contribuables) {
      console.log(`📌 Vérification contribuable ${c.tax_payer_no}`);

      // Vérifier s'il a fait une déclaration
      const decl = await Declaration1.findOne({
        where: { tax_payer_no: c.tax_payer_no }
      });

      const decl_exist = !!decl;

      // Vérifier s'il a fait un paiement
      const pay = await Paiement1.findOne({
        where: { tax_payer_no: c.tax_payer_no }
      });

      // Calcul état paiement
      let pay_exist = false;
      let valider = false;
      let reste = 0;

      if (pay) {
        pay_exist = true;
        valider = pay.valider === true;
        reste = parseFloat(pay.reste_a_recouvrer || 0);
        console.log(`💰 Paiement ${c.tax_payer_no} → valider=${valider}, reste=${reste}`);
      }

      // ✅ 3. Logique de défaillance corrigée
      if (!decl_exist) {
        console.log(`❌ ${c.tax_payer_no} → Aucune déclaration → DÉFAILLANT`);
        defaillants.push({
          tax_payer_no: c.tax_payer_no,
          contribuable: c.rs,
          motif: "Aucune déclaration"
        });
      } else if (!pay_exist) {
        console.log(`❌ ${c.tax_payer_no} → Aucune paiement → DÉFAILLANT`);
        defaillants.push({
          tax_payer_no: c.tax_payer_no,
          contribuable: c.rs,
          motif: "Aucun paiement"
        });
      } else if (valider === false || reste > 0) {
        console.log(`❌ ${c.tax_payer_no} → Paiement non validé ou reste > 0 → DÉFAILLANT`);
        defaillants.push({
          tax_payer_no: c.tax_payer_no,
          contribuable: c.rs,
          motif: "Paiement incomplet ou non validé"
        });
      } else {
        console.log(`✅ ${c.tax_payer_no} → En règle`);
      }
    }

    return res.status(200).json({
      centre: centreName,
      total_defaillants: defaillants.length,
      defaillants
    });

  } catch (error) {
    console.error('Erreur lors de la récupération des défaillants :', error);
    res.status(500).json({ message: "Erreur interne du serveur" });
  }
};*/
const Declaration1 = require('../models1/Declaration1');
const Paiement1 = require('../models1/Paiement1');
const Contribuable1 = require('../models1/Contribuable1');

exports.getDefaillantsParCentre = async (req, res) => {
  try {
    const { centreName } = req.params;

    // 🔹 1. Récupérer les contribuables du centre donné
    const contribuables = await Contribuable1.findAll({
      where: { centre: centreName },
      attributes: [
        'tax_payer_no',
        'rs',
        'centre',
        'adresse',
        'activite',
        'phone',
        'actif'
      ]
    });

    console.log(`🔍 ${contribuables.length} contribuables trouvés pour ${centreName}`);

    const defaillants = [];

    // 🔄 2. Boucler sur chaque contribuable
    for (const c of contribuables) {
      console.log(`📌 Vérification contribuable ${c.tax_payer_no}`);

      // Vérifier s'il a fait une déclaration
      const decl = await Declaration1.findOne({
        where: { tax_payer_no: c.tax_payer_no }
      });

      const decl_exist = !!decl;

      // Vérifier s'il a fait un paiement
      const pay = await Paiement1.findOne({
        where: { tax_payer_no: c.tax_payer_no }
      });

      // Calcul état paiement
      let pay_exist = false;
      let valider = false;
      let reste = 0;

      if (pay) {
        pay_exist = true;
        valider = pay.valider === true;
        reste = parseFloat(pay.reste_a_recouvrer || 0);
        console.log(`💰 Paiement ${c.tax_payer_no} → valider=${valider}, reste=${reste}`);
      }

      // ✅ 3. Logique de défaillance finale corrigée
      if (!decl_exist) {
        console.log(`❌ ${c.tax_payer_no} → Aucune déclaration → DÉFAILLANT`);
        defaillants.push({
          tax_payer_no: c.tax_payer_no,
          rs: c.rs,
          motif: "Aucune déclaration",
          centre: c.centre,
          adresse: c.adresse,
          activite: c.activite,
          phone: c.phone,
          actif: c.actif
        });
      } else if (!pay_exist) {
        console.log(`❌ ${c.tax_payer_no} → Aucun paiement → DÉFAILLANT`);
        defaillants.push({
          tax_payer_no: c.tax_payer_no,
          rs: c.rs,
          motif: "Aucun paiement",
          centre: c.centre,
          adresse: c.adresse,
          activite: c.activite,
          phone: c.phone,
          actif: c.actif
        });
      } else if (valider === false || reste > 0) {
        console.log(`❌ ${c.tax_payer_no} → Paiement non validé ou reste > 0 → DÉFAILLANT`);
        defaillants.push({
          tax_payer_no: c.tax_payer_no,
          rs: c.rs,
          motif: "Paiement incomplet ou non validé",
          centre: c.centre,
          adresse: c.adresse,
          activite: c.activite,
          phone: c.phone,
          actif: c.actif
        });
      } else {
        console.log(`✅ ${c.tax_payer_no} → En règle`);
      }
    }

    // 🔹 4. Réponse JSON complète
    return res.status(200).json({
      centre: centreName,
      total_defaillants: defaillants.length,
      defaillants
    });

  } catch (error) {
    console.error('💥 Erreur lors de la récupération des défaillants :', error);
    res.status(500).json({ message: "Erreur interne du serveur", error: error.message });
  }
};

