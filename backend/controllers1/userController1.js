const { User1, CentreGestionnaire1 } = require('../models1/index1'); // models/index.js
const bcrypt = require('bcrypt');
const jwt = require('jsonwebtoken');

// Login
exports.login = async (req, res) => {
  try {
    const { email, password } = req.body;

    const user = await User1.findOne({ where: { email } });
    if (!user) return res.status(404).json({ message: 'Utilisateur non trouvé' });
    // 🔍 DEBUG PASSWORD
    console.log("Password saisi :", password);
    console.log("Hash DB :", user.password);
    const valid = await bcrypt.compare(password, user.password);
    console.log("Compare result :", valid);

    /*const valid = await bcrypt.compare(password, user.password);*/
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

//teste
exports.registerAdmin = async (req, res) => {
  try {
    const { nom, prenom, email, password, id_centre_gest } = req.body;

    if (!nom || !prenom || !email || !password) {
      return res.status(400).json({ message: "Champs obligatoires manquants" });
    }

    // 🔒 Limitation à 3 admins
    const adminCount = await User1.count({ where: { role: "admin" } });
    if (adminCount >= 3) {
      return res.status(403).json({
        message: "Limite atteinte : 3 administrateurs maximum",
      });
    }

    const existing = await User1.findOne({ where: { email } });
    if (existing) {
      return res.status(409).json({ message: "Email déjà utilisé" });
    }

    /*const hashedPassword = await bcrypt.hash(password, 10);*/

    const admin = await User1.create({
      nom,
      prenom,
      email,
      password,
      role: "admin",
      id_centre_gest,
    });

    res.status(201).json({
      message: "Administrateur créé avec succès",
      admin: {
        id: admin.id,
        nom: admin.nom,
        prenom: admin.prenom,
        email: admin.email,
        role: admin.role,
      },
    });
  } catch (error) {
    console.error("registerAdmin:", error);
    res.status(500).json({ message: "Erreur serveur" });
  }
};

// Modifier utilisateur (avec changement mot de passe optionnel)
/*exports.updateUser = async (req, res) => {
  try {
    const { id } = req.params;
    const { nom, prenom, email, role, id_centre_gest, password } = req.body;

    const user = await User1.findByPk(id);
    if (!user) return res.status(404).json({ message: "Utilisateur non trouvé" });

    let updatedData = { nom, prenom, email, role, id_centre_gest };

    // 🔐 Hash password uniquement si l’utilisateur en fournit un
    if (password && password.trim() !== "") {
      const hashed = await bcrypt.hash(password, 10);
      updatedData.password = hashed;
    }

    await user.update(updatedData);
    res.json({ message: "Utilisateur mis à jour", user });

  } catch (error) {
    console.error("Erreur updateUser:", error);
    res.status(500).json({ message: error.message });
  }
};*/

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
/*const { User1, CentreGestionnaire1 } = require('../models1/index1');
const bcrypt = require('bcrypt');
const jwt = require('jsonwebtoken');

// LOGIN (sécurisé)
exports.login = async (req, res) => {
  try {
    const { email, password } = req.body;

    const user = await User1.findOne({ where: { email } });
    if (!user) return res.status(404).json({ message: 'Utilisateur non trouvé' });

    const valid = await bcrypt.compare(password, user.password);
    if (!valid) return res.status(401).json({ message: 'Mot de passe incorrect' });

    const token = jwt.sign(
      {
        id: user.id,
        role: user.role,
        id_centre_gest: user.id_centre_gest
      },
      process.env.JWT_SECRET,
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

// GET USERS (sécurisé)
exports.getAllUsers = async (req, res) => {
  try {
    const users = await User1.findAll({
      attributes: { exclude: ['password'] },
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

// CREATE USER (sécurisé)
exports.createUser = async (req, res) => {
  try {
    const { nom, prenom, email, password, role, id_centre_gest } = req.body;

    const hashedPassword = await bcrypt.hash(password, 10);

    const user = await User1.create({
      nom,
      prenom,
      email,
      password: hashedPassword,
      role,
      id_centre_gest
    });

    res.status(201).json({ message: "Utilisateur créé avec succès" });

  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

// UPDATE USER (sécurisé)
exports.updateUser = async (req, res) => {
  try {
    const { id } = req.params;
    const { nom, prenom, email, role, id_centre_gest } = req.body;

    const user = await User1.findByPk(id);
    if (!user) return res.status(404).json({ message: 'Utilisateur non trouvé' });

    await user.update({ nom, prenom, email, role, id_centre_gest });

    res.json({ message: "Utilisateur modifié" });

  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

// DELETE USER (sécurisé)
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
};*/
