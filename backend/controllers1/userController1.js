const { User1, CentreGestionnaire1 } = require('../models1/index1'); // models/index.js
const bcrypt = require('bcrypt');
const jwt = require('jsonwebtoken');

// Login
exports.login = async (req, res) => {
  try {
    const { email, password } = req.body;

    const user = await User1.findOne({ where: { email } });
    if (!user) return res.status(404).json({ message: 'Utilisateur non trouvé' });

    const valid = await bcrypt.compare(password, user.password);
    if (!valid) return res.status(401).json({ message: 'Mot de passe incorrect' });

    const token = jwt.sign(
      { id: user.id, role: user.role, id_centre_gest: user.id_centre_gest },
      process.env.JWT_SECRET || 'secret123',
      { expiresIn: '1h' }
    );

    res.json({
      message: 'Connexion réussie',
      token,
      user: {
        id: user.id,
        nom: user.nom,
        prenom: user.prenom,
        email: user.email,
        role: user.role,
        matricule: user.matricule,
        id_centre_gest: user.id_centre_gest
      }
    });
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: 'Erreur serveur' });
  }
};

// GET all users avec info centre
exports.getAllUsers = async (req, res) => {
  try {
    const users = await User1.findAll({
      include: [
        { model: CentreGestionnaire1, as: 'centre', attributes: ['CG_designation', 'code_bureau'] }
      ]
    });
    res.json(users);
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: 'Erreur serveur' });
  }
};



// Ajouter utilisateur
exports.createUser = async (req, res) => {
  try {
    const { nom, prenom, email, password, role, id_centre_gest } = req.body;
    const user = await User1.create({ nom, prenom, email, password, role, id_centre_gest });
    res.status(201).json(user);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

// Modifier utilisateur
exports.updateUser = async (req, res) => {
  try {
    const { id } = req.params;
    const { nom, prenom, email, role, id_centre_gest } = req.body;
    const user = await User1.findByPk(id);
    if (!user) return res.status(404).json({ message: 'Utilisateur non trouvé' });

    await user.update({ nom, prenom, email, role, id_centre_gest });
    res.json(user);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

// Supprimer utilisateur
exports.deleteUser = async (req, res) => {
  try {
    const { id } = req.params;
    const user = await User1.findByPk(id);
    if (!user) return res.status(404).json({ message: 'Utilisateur non trouvé' });

    await user.destroy();
    res.json({ message: 'Utilisateur supprimé' });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};