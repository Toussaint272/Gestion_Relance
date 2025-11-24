const { DataTypes } = require('sequelize');
const sequelize = require('../config/db'); // na instance avy amin'ny config.js/.env
const bcrypt = require('bcrypt');

const User1 = sequelize.define('User1', {
  id: { type: DataTypes.INTEGER, primaryKey: true, autoIncrement: true },
  nom: { type: DataTypes.STRING, allowNull: false },
  prenom: { type: DataTypes.STRING, allowNull: false },
  email: { type: DataTypes.STRING, allowNull: false, unique: true },
  password: { type: DataTypes.STRING, allowNull: false },
  role: { type: DataTypes.ENUM('admin','agent'), defaultValue: 'agent' },
  matricule: { type: DataTypes.STRING, allowNull: true, unique: true },
  id_centre_gest: { type: DataTypes.INTEGER, allowNull: true }
}, {
  tableName: 'users1',
  timestamps: true
});

// Hash password + generate matricule
User1.beforeCreate(async (user) => {
  user.password = await bcrypt.hash(user.password, 10);
  const random = Math.floor(1000 + Math.random() * 9000);
  user.matricule = `M-${random}`;
});


module.exports = User1;
