const Declaration1 = require('../models1/Declaration1');
const Paiement1 = require('../models1/Paiement1');
const Contribuable1 = require('../models1/Contribuable1');
const { User1, CentreGestionnaire1 } = require('../models1/index1');

exports.getContribuableCentre = async (req, res) => {
  try {
    const { matricule } = req.query;
    if (!matricule) return res.status(400).json({ message: "Matricule requis !" });

    // 🔹 Récupérer agent avec centre
    const agent = await User1.findOne({
      where: { matricule },
      include: { model: CentreGestionnaire1, as: 'centre' }
    });

    if (!agent) return res.status(404).json({ message: "Agent introuvable !" });

    const centreName = agent.centre?.CG_designation;
    if (!centreName) return res.status(400).json({ message: "Centre fiscal introuvable pour cet agent !" });

    // 🔹 Récupérer les contribuables
    const contribuables = await Contribuable1.findAll({
      where: { centre: centreName },
      attributes: ['tax_payer_no','rs','centre','adresse','activite','phone','actif']
    });

    let defaillants = [];

    for (const c of contribuables) {
      const decl = await Declaration1.findOne({ where: { tax_payer_no: c.tax_payer_no } });
      const pay = await Paiement1.findOne({ where: { tax_payer_no: c.tax_payer_no } });

      let valider = pay?.valider === true;
      let reste = parseFloat(pay?.reste_a_recouvrer || 0);
      let pay_exist = !!pay;

      if (!decl) defaillants.push({ ...c.dataValues, motif: "Aucune déclaration" });
      else if (!pay_exist) defaillants.push({ ...c.dataValues, motif: "Aucun paiement" });
      else if (!valider || reste > 0) defaillants.push({ ...c.dataValues, motif: "Paiement incomplet ou non validé" });
    }

    return res.status(200).json({
      agent: matricule,
      centre: centreName,
      total_defaillants: defaillants.length,
      defaillants
    });

  } catch (error) {
    console.error("💥 ERREUR SERVEUR :", error);
    res.status(500).json({ message: "Erreur interne serveur", error: error.message });
  }
};
