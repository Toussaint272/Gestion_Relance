const nodemailer = require('nodemailer');
const Relance1 = require('../models1/Relance1');
const Declaration1 = require('../models1/Declaration1');
const Contribuable1 = require('../models1/Contribuable1');
const dayjs = require('dayjs');
const utc = require('dayjs/plugin/utc');
const timezone = require('dayjs/plugin/timezone');

dayjs.extend(utc);
dayjs.extend(timezone);


exports.autoRelanceDeclaration = async (req, res) => {
  try {
    const { tax_payer_no , matricule } = req.body;
    const contribuable = await Contribuable1.findOne({ where: { tax_payer_no } });
    if (!contribuable) return res.status(404).json({ message: 'Contribuable introuvable' });

    // 🔹 Vérification matricule
    if (!matricule || matricule.trim() === '') {
      return res.status(400).json({ message: "Matricule de l’agent requis" });
    }

    const declarationsRetard = await Declaration1.findAll({
      where: { tax_payer_no, statut: 'Non reçu' },
    });

    const transporter = nodemailer.createTransport({
      service: 'gmail',
      auth: { user: process.env.EMAIL_USER, pass: process.env.EMAIL_PASS },
    });

    for (const decl of declarationsRetard) {
      const message = `Bonjour ${contribuable.rs || 'Cher contribuable'}, votre déclaration n°${decl.N_decl} est en retard. Merci de régulariser.`;
      await transporter.sendMail({
        from: 'DGI Madagascar <${process.env.EMAIL_USER}>',
        to: contribuable.email,
        subject: `Relance déclaration n°${decl.N_decl}`,
        text: message,
      });

      await Relance1.create({
        tax_payer_no,
        N_decl: decl.N_decl,
        mode: 'email',
        message,
        status: 'Envoyé',
        date_envoi: dayjs().tz('Indian/Antananarivo').format('YYYY-MM-DD HH:mm:ss'),
        matricule, // 👈 agent connecte // ⏰ Date exacte Madagascar
      });
    }

    res.status(201).json({ message: 'Relance(s) envoyée(s)', count: declarationsRetard.length });
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: 'Erreur lors de l’envoi des relances', error: error.message });
  }
  
};
// 🔹 Récupération de l’historique des relances
/*exports.getAllRelances = async (req, res) => {
  try {
    const relances = await Relance1.findAll({
      order: [['createdAt', 'DESC']],
      attributes: ['tax_payer_no', 'N_decl', 'mode', 'message', 'status', 'date_envoi', 'matricule'],
    });
    res.json(relances);
  } catch (error) {
    res.status(500).json({
      message: 'Erreur lors du chargement des relances',
      error: error.message,
    });
  }
};*/
// 🔹 Récupération de l’historique des relances pour l'agent connecté
exports.getAllRelances = async (req, res) => {
  try {
    const { matricule } = req.query;

    if (!matricule || matricule.trim() === '') {
      return res.status(400).json({ message: "Matricule de l’agent requis" });
    }

    const relances = await Relance1.findAll({
      where: { matricule }, // 🔹 Filtre pour l'agent connecté
      order: [['createdAt', 'DESC']],
      attributes: ['tax_payer_no', 'N_decl', 'mode', 'message', 'status', 'date_envoi', 'matricule'],
    });

    res.json(relances);
  } catch (error) {
    res.status(500).json({
      message: 'Erreur lors du chargement des relances',
      error: error.message,
    });
  }
};



