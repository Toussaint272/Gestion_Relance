/*const { DataTypes } = require('sequelize');
const sequelize = require('../config/db');

// Importation des autres modèles pour les relations
const Paiement1 = require('./Paiement1');
const Declaration1 = require('./Declaration1');
const User1 = require('./User1');

const Relance1 = sequelize.define('Relance1', {
  id: {
    type: DataTypes.INTEGER,
    autoIncrement: true,
    primaryKey: true
  },

  // 🔹 Identifiant contribuable (pour référence directe)
  taxPayerNo: {
    type: DataTypes.STRING,
    allowNull: false,
  },

  // 🔹 Date d’envoi de la relance
  date_envoi: {
    type: DataTypes.DATE,
    defaultValue: DataTypes.NOW,
  },

  // 🔹 Mode d’envoi : email ou SMS
  mode: {
    type: DataTypes.ENUM('email', 'sms'),
    allowNull: false,
  },

  // 🔹 Statut de la relance
  status: {
    type: DataTypes.ENUM('Envoyé', 'Échoué', 'En attente'),
    defaultValue: 'Envoyé',
  },

  // 🔹 Message envoyé (facultatif, utile pour logs)
  message: {
    type: DataTypes.TEXT,
    allowNull: true,
  }
}, {
  tableName: 'relances',
  timestamps: true,
});

// =====================
// 🔗 Associations
// =====================

// Un relance appartient à un paiement spécifique
Relance1.belongsTo(Paiement1, {
  foreignKey: 'id_paiement',
  as: 'paiement',
});

// Un relance correspond à une déclaration
Relance1.belongsTo(Declaration1, {
  foreignKey: 'N_decl',
  as: 'declaration',
});

// Un relance est envoyé par un agent
Relance1.belongsTo(User1, {
  foreignKey: 'id',
  as: 'agent',
});

module.exports = Relance1;*/
const { DataTypes } = require('sequelize');
const sequelize = require('../config/db');

//const Paiement1 = require('./Paiement1');
const Declaration1 = require('./Declaration1');
const User1 = require('./User1');
const Contribuable1 = require('./Contribuable1');
const Relance1 = sequelize.define('Relance1', {
  id: {
    type: DataTypes.INTEGER,
    autoIncrement: true,
    primaryKey: true,
  },

  tax_payer_no: {
    type: DataTypes.STRING,
    allowNull: false,
  },

  N_decl: {
    type: DataTypes.INTEGER,
    allowNull: true,
  },

  /*id_agent: {
    type: DataTypes.INTEGER,
    allowNull: true,
  },*/
  matricule: {
    type: DataTypes.STRING,
    allowNull: true, // ho agent connecte
  },

  date_envoi: {
    type: DataTypes.DATE,
    defaultValue: DataTypes.NOW,
  },

  mode: {
    type: DataTypes.ENUM('email', 'sms'),
    allowNull: false,
  },

  status: {
    type: DataTypes.ENUM('Envoyé', 'Échoué', 'En attente'),
    defaultValue: 'Envoyé',
  },

  message: {
    type: DataTypes.TEXT,
    allowNull: true,
  },
}, {
  tableName: 'relances1',
  timestamps: true,
});

// Associations

/*Relance1.belongsTo(Paiement1, {
  foreignKey: 'id_paiement',
  as: 'paiement',
});*/

Relance1.belongsTo(Declaration1, {
  foreignKey: 'N_decl',
  as: 'declaration',
});

/*Relance1.belongsTo(User1, {
  foreignKey: 'id_agent',
  as: 'agent',
});*/
Relance1.belongsTo(Contribuable1, {
  foreignKey: 'tax_payer_no',
  targetKey: 'tax_payer_no'
});



module.exports = Relance1;

