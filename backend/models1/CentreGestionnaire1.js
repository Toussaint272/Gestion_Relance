const { DataTypes } = require('sequelize');
const sequelize = require('../config/db'); // na instance avy amin'ny config.js/.env

const CentreGestionnaire1 = sequelize.define('CentreGestionnaire1', {
  id_centre_gest: { type: DataTypes.INTEGER, primaryKey: true, autoIncrement: true },
  CG_designation: { type: DataTypes.STRING(100), allowNull: false },
  lieu_bureau: { type: DataTypes.STRING(100), allowNull: true },
  mail: { type: DataTypes.STRING(100), allowNull: true },
  tel: { type: DataTypes.STRING(50), allowNull: true },
  adresse: { type: DataTypes.STRING(255), allowNull: true },
  code_bureau: { type: DataTypes.STRING(20), allowNull: true },
  CG_ABBREV: { type: DataTypes.STRING(20), allowNull: true }
}, {
  tableName: 'centre_gestionnaire1',
  timestamps: true
});

module.exports = CentreGestionnaire1;
