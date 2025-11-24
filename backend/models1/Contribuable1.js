const { DataTypes } = require('sequelize');
const sequelize = require('../config/db');

const Contribuable1 = sequelize.define('Contribuable1', {
  id: { type: DataTypes.INTEGER, primaryKey: true, autoIncrement: true },
  tax_payer_no: { type: DataTypes.STRING(50), unique: true },
  nif: { type: DataTypes.STRING(50), unique: true },
  rs: { type: DataTypes.STRING(255) },
  centre: { type: DataTypes.STRING(100) },
  adresse: { type: DataTypes.STRING(255) },
  phone: { type: DataTypes.STRING(50) },
  email: { type: DataTypes.STRING(100) },
  dern_annee: { type: DataTypes.INTEGER },
  actif: { type: DataTypes.BOOLEAN, defaultValue: true },
  activite: { type: DataTypes.STRING(255) } // 🔹 nouveau champ
}, {
  tableName: 'contribuables1',
  timestamps: true,
});

module.exports = Contribuable1;
