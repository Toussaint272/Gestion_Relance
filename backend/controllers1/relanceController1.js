/*const nodemailer = require('nodemailer');
const Relance1 = require('../models1/Relance1');
const Contribuable1 = require('../models1/Contribuable1');

// ✅ ENVOYER RELANCE
exports.sendRelance = async (req, res) => {
  try {
    const { tax_payer_no, N_decl, message } = req.body;

    // 🔍 Trouver le contribuable correspondant
    const contribuable = await Contribuable1.findOne({ where: { tax_payer_no } });
    if (!contribuable) {
      return res.status(404).json({ message: 'Contribuable introuvable' });
    }

    // ✉️ Configurer transport Nodemailer
    const transporter = nodemailer.createTransport({
      service: 'gmail',
      auth: {
        user: process.env.EMAIL_USER,
        pass: process.env.EMAIL_PASS,
      },
    });

    // 📨 Préparer contenu email
    const mailOptions = {
      from: 'DGI Madagascar <votre.email@gmail.com>',
      to: contribuable.email,
      subject: `Relance pour votre déclaration n°${N_decl}`,
      text:
        message ||
        `Bonjour ${contribuable.rs},\n\nNous vous rappelons que votre paiement pour la déclaration n°${N_decl} reste en attente. Merci de régulariser votre situation dans les plus brefs délais.\n\nCordialement,\nDirection Générale des Impôts.`,
    };

    // 🚀 Envoi email
    await transporter.sendMail(mailOptions);

    // 🧾 Sauvegarde dans la table Relance
    const relance = await Relance1.create({
      tax_payer_no,
      N_decl,
      mode: 'email',
      message: mailOptions.text,
      status: 'Envoyé',
    });

    res.status(201).json({ message: 'Relance envoyée avec succès', relance });
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: 'Erreur lors de l’envoi de la relance', error });
  }
};*/
const nodemailer = require('nodemailer');
const Relance1 = require('../models1/Relance1');
const Contribuable1 = require('../models1/Contribuable1');
const dayjs = require('dayjs');
const utc = require('dayjs/plugin/utc');
const timezone = require('dayjs/plugin/timezone');
const { Op } = require('sequelize'); // <<< **IMPORT ILAY Op**

dayjs.extend(utc);
dayjs.extend(timezone);

// ✅ ENVOYER RELANCE
exports.sendRelance = async (req, res) => {
  try {
    const { tax_payer_no, N_decl, message,matricule } = req.body;

    // Vérif paramètres
    if (!tax_payer_no) {
      return res.status(400).json({ message: "Le champ tax_payer_no est requis." });
    }

    // 🔍 Trouver le contribuable correspondant
    const contribuable = await Contribuable1.findOne({ where: { tax_payer_no } });
    if (!contribuable) {
      return res.status(404).json({ message: 'Contribuable introuvable' });
    }

    // ✉️ Configurer transport Nodemailer
    const transporter = nodemailer.createTransport({
      service: 'gmail',
      auth: {
        user: process.env.EMAIL_USER,
        pass: process.env.EMAIL_PASS,
      },
    });

    // 📨 Préparer contenu email
    const emailMessage =
  message ||
  `Bonjour ${contribuable.rs || 'Cher contribuable'},\n
Nous espérons que vous allez bien.\n
Nous vous informons que le paiement relatif à votre déclaration n°${N_decl} n’a pas encore été reçu à ce jour.\n
Nous vous prions de bien vouloir régulariser votre situation dans les plus brefs délais afin d’éviter toute pénalité.\n\n
Nous vous remercions pour votre attention et restons à votre disposition pour toute information complémentaire.\n\n
Cordialement,\n
Direction Générale des Impôts\n
DGI Madagascar`;


    const mailOptions = {
      from: `DGI Madagascar <${process.env.EMAIL_USER}>`,
      to: contribuable.email,
      subject: `Relance pour votre déclaration n°${N_decl}`,
      text: emailMessage,
    };

    // 🚀 Envoi email
    await transporter.sendMail(mailOptions);

    // 🧾 Sauvegarde dans la table Relance
    const relance = await Relance1.create({
      tax_payer_no, // ✅ Correct
      N_decl,
      matricule,
      mode: 'email',
      message: emailMessage,
      status: 'Envoyé',
      date_envoi: dayjs().utcOffset(3).format('YYYY-MM-DD HH:mm:ss'), // GMT+3 Madagascar
    });

    res.status(201).json({
      message: '✅ Relance envoyée avec succès',
      relance,
    });
  } catch (error) {
    console.error('Erreur relance:', error);
    res.status(500).json({
      message: '❌ Erreur lors de l’envoi de la relance',
      error: error.message,
    });
  }
};

// ✅ Récupérer toutes les relances (table complète)
exports.getAllRelances = async (req, res) => {
  try {
    const relances = await Relance1.findAll({
      order: [['createdAt', 'DESC']], // les plus récentes d'abord
    });

    if (!relances || relances.length === 0) {
      return res.status(200).json({ message: 'Aucune relance trouvée.' });
    }

    res.status(200).json(relances);
  } catch (error) {
    console.error('Erreur lors de la récupération des relances :', error);
    res.status(500).json({ error: 'Erreur serveur', details: error.message });
  }
};
// Filtrer les relances par centre fiscal (query param: ?centre=...)

/*Relance1.belongsTo(Contribuable1, {
  foreignKey: "tax_payer_no",
  targetKey: "tax_payer_no",
});*/

exports.getByCentreFiscal = async (req, res) => {
  try {
    const { centre } = req.query;

    const results = await Relance1.findAll({
      include: [
        {
          model: Contribuable1,
          required: true, // important: join INNER
          where: {
            centre: {
              [Op.like]: `%${centre}%`,
            },
          },
        },
      ],
      order: [["date_envoi", "DESC"]],
    });

    res.json(results);
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: "Erreur serveur" });
  }
};