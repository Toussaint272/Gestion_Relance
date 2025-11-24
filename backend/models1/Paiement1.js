/*const { DataTypes } = require('sequelize');
const sequelize = require('../config/db');
const Contribuable1 = require('./Contribuable1'); // Model contribuable
const Declaration1 = require('./Declaration1');   // Model declaration

const Paiement1 = sequelize.define('Paiement1', {
  id_paiement: {
    type: DataTypes.INTEGER,
    primaryKey: true,
    autoIncrement: true
  },
  tax_payer_no: {
    type: DataTypes.STRING,
    allowNull: false,
    references: {
      model: 'contribuables1',
      key: 'tax_payer_no' // 🔹 référence correcte
    },
    onDelete: 'CASCADE'
  },
  N_decl: {
    type: DataTypes.INTEGER,
    allowNull: false,
    references: {
      model: Declaration1,
      key: 'N_decl'
    },
    onDelete: 'CASCADE'
  },
  montant_payer: {
    type: DataTypes.DECIMAL(15,2),
    allowNull: false
  },
  reste_a_recouvrer: {
    type: DataTypes.DECIMAL(15,2),
    allowNull: true,
    defaultValue: null
  },
  date_payment: {
    type: DataTypes.DATE,
    allowNull: false,
    defaultValue: DataTypes.NOW
  },
  valider: {
    type: DataTypes.BOOLEAN,
    allowNull: false,
    defaultValue: false
  },
  mode_paiement: {
    type: DataTypes.ENUM('espece','virement','cheque','autre'),
    allowNull: false,
    defaultValue: 'espece'
  }
}, {
  tableName: 'paiement1',
  timestamps: true
});

// Associations
Paiement1.belongsTo(Contribuable1, { foreignKey: 'tax_payer_no' });
Paiement1.belongsTo(Declaration1, { foreignKey: 'N_decl' });

// ⚙️ Hook automatique — calculer avant insertion
Paiement1.beforeCreate(async (paiement, options) => {
  const declaration = await Declaration1.findOne({ where: { N_decl: paiement.N_decl } });
  if (declaration) {
    paiement.reste_a_recouvrer = declaration.montant_liquide - paiement.montant_payer;
  } else {
    paiement.reste_a_recouvrer = null;
  }
});

// ⚙️ Facultatif : calcul automatique aussi lors d’une mise à jour
Paiement1.beforeUpdate(async (paiement, options) => {
  const declaration = await Declaration1.findOne({ where: { N_decl: paiement.N_decl } });
  if (declaration) {
    paiement.reste_a_recouvrer = declaration.montant_liquide - paiement.montant_payer;
  }
});*/

const { DataTypes } = require('sequelize');
const sequelize = require('../config/db');
const Contribuable1 = require('./Contribuable1');
const Declaration1 = require('./Declaration1');

const Paiement1 = sequelize.define('Paiement1', {
  id_paiement: { type: DataTypes.INTEGER, primaryKey: true, autoIncrement: true },
  tax_payer_no: { type: DataTypes.STRING, allowNull: false, references: { model: 'contribuables1', key: 'tax_payer_no' }, onDelete: 'CASCADE' },
  N_decl: { type: DataTypes.INTEGER, allowNull: false, references: { model: Declaration1, key: 'N_decl' }, onDelete: 'CASCADE' },
  montant_payer: { type: DataTypes.DECIMAL(15,2), allowNull: false },
  reste_a_recouvrer: { type: DataTypes.DECIMAL(15,2), allowNull: true, defaultValue: null },
  date_payment: { type: DataTypes.DATE, allowNull: false, defaultValue: DataTypes.NOW },
  valider: { type: DataTypes.BOOLEAN, allowNull: false, defaultValue: false },
  mode_paiement: { type: DataTypes.ENUM('espece','virement','cheque','autre'), allowNull: false, defaultValue: 'espece' }
}, {
  tableName: 'paiement1',
  timestamps: true
});

// Relations
Paiement1.belongsTo(Contribuable1, { foreignKey: 'tax_payer_no' });
Paiement1.belongsTo(Declaration1, { foreignKey: 'N_decl' });
// Paiement1.js
Paiement1.belongsTo(Contribuable1, { 
    foreignKey: 'tax_payer_no', 
    targetKey: 'tax_payer_no',  // 🔹 zava-dehibe: targetKey dia tax_payer_no
    as: 'contribuables1'          // optional, mba ho fantatra amin'ny alias
});


// Hook automatique avant insertion/mise à jour
Paiement1.beforeSave(async (paiement) => {
  const declaration = await Declaration1.findOne({ where: { N_decl: paiement.N_decl } });
  if (declaration) {
    paiement.reste_a_recouvrer = parseFloat(declaration.montant_liquide) - parseFloat(paiement.montant_payer);
  }
});

module.exports = Paiement1;



