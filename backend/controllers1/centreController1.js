const { CentreGestionnaire1 } = require('../models1/index1'); // avy amin'ny models/index.js

// GET all centres
exports.getAllCentres = async (req, res) => {
  try {
    const centres = await CentreGestionnaire1.findAll({
      attributes: ['id_centre_gest', 'CG_designation', 'code_bureau'] // ataovy izay ilain'ny frontend
    });
    res.json(centres);
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: "Erreur serveur" });
  }
};
