const { DataTypes } = require('sequelize');
const sequelize = require('../config/db');

const Assujettissement1 = sequelize.define('Assujettissement1', {
  id_assuj: {
    type: DataTypes.INTEGER,
    primaryKey: true,
    autoIncrement: true,
  },
  fiscal_no: {
    type: DataTypes.STRING,
    allowNull: false,
  },
  annee: {
    type: DataTypes.INTEGER,
    allowNull: false,
  },
  periodicite: {
    type: DataTypes.STRING,
  },
  debut: {
    type: DataTypes.DATE,
  },
  fin: {
    type: DataTypes.DATE,
  },
  actif: {
    type: DataTypes.BOOLEAN,
    defaultValue: true,
  },
  etat: {
    type: DataTypes.STRING,
  },
}, {
  tableName: 'assujettissement1',
  timestamps: true,
});

module.exports = Assujettissement1;
