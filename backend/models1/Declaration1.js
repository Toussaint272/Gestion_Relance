const { DataTypes } = require('sequelize');
const sequelize = require('../config/db');

const Declaration1 = sequelize.define('Declaration1', { 
  N_decl: {
    type: DataTypes.INTEGER,
    primaryKey: true,
    autoIncrement: true
  },
  tax_payer_no: {
    type: DataTypes.STRING(50),
    allowNull: false
  },
  tax_type_no: {
    type: DataTypes.STRING(30),
    allowNull: true
  },
  tax_periode: {
    type: DataTypes.DATE,
    allowNull: true
  },
  save_date: {
    type: DataTypes.DATE,
    allowNull: true
  },
  received_date: {
    type: DataTypes.DATE,
    allowNull: true
  },
  date_echeance: {
    type: DataTypes.DATE,
    allowNull: true
  },
  motif: {
    type: DataTypes.TEXT,
    allowNull: true
  },
  montant_liquide: {      
    type: DataTypes.DECIMAL(15, 2),
    allowNull: true,
    defaultValue: 0.00
  },
  statut: {   // 🟢 Champ automatique
    type: DataTypes.STRING(30),
    allowNull: true
  }
}, {
  tableName: 'declaration1',
  timestamps: true
});

// 🧠 Calcul automatique du statut avant sauvegarde
Declaration1.beforeSave((declaration1, options) => {
    if (!declaration1.received_date) {
      declaration1.statut = 'Non reçu';
    } else if (declaration1.date_echeance && declaration1.received_date > declaration1.date_echeance) {
      declaration1.statut = 'En retard';
    } else {
      declaration1.statut = 'Valide';
    }
  });

module.exports = Declaration1;
