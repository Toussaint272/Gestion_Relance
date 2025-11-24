const { User1, Contribuable1, CentreGestionnaire1 } = require('../models1/index2');
const { Op } = require('sequelize');

// 🔹 Obtenir les contribuables d’un agent via son matricule
exports.getContribuablesByAgent = async (req, res) => {
  try {
    const { matricule } = req.query;

    console.log("🟡 Requête reçue pour matricule :", matricule);

    if (!matricule) {
      console.log("⛔ Paramètre 'matricule' manquant");
      return res.status(400).json({ message: "Paramètre 'matricule' manquant" });
    }

    // 1️⃣ Trouver l’agent et son centre
    const agent = await User1.findOne({
      where: { matricule },
      include: [
        {
          model: CentreGestionnaire1,
          as: 'centre',
          attributes: ['CG_designation', 'code_bureau']
        }
      ]
    });

    console.log("🟢 Agent trouvé :", agent ? agent.toJSON() : "❌ Aucun agent trouvé");

    if (!agent) {
      console.log("❌ Aucun agent trouvé avec ce matricule");
      return res.status(404).json({ message: "Agent non trouvé" });
    }

    const centreName = agent.centre?.CG_designation;
    console.log("🏢 Centre de l’agent :", centreName);

    if (!centreName) {
      console.log("❌ Centre introuvable pour cet agent");
      return res.status(404).json({ message: "Centre de l’agent introuvable" });
    }

    // 2️⃣ Chercher les contribuables correspondant à ce centre
    console.log("🔍 Recherche des contribuables du centre :", centreName);

    const contribuables = await Contribuable1.findAll({
      where: {
        centre: {
          [Op.like]: `%${centreName}%`
        }
      }
    });

    console.log(`🧾 ${contribuables.length} contribuable(s) trouvé(s) pour ce centre.`);

    if (contribuables.length === 0) {
      console.log("❌ Aucun contribuable trouvé pour ce centre :", centreName);
      return res.status(404).json({ message: "Aucun contribuable trouvé pour ce centre" });
    }

    res.status(200).json({
      centre: centreName,
      total: contribuables.length,
      contribuables
    });

  } catch (error) {
    console.error("💥 Erreur serveur :", error);
    res.status(500).json({ message: "Erreur serveur", error: error.message });
  }
};
