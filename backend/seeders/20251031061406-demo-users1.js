'use strict';
const bcrypt = require('bcrypt');

module.exports = {
  async up(queryInterface, Sequelize) {
    await queryInterface.bulkInsert('users1', [
      {
        nom: 'RATOLOJANAHARY',
        prenom: 'Toky',
        email: 'admin@dgi.mg',
        password: await bcrypt.hash('admin123', 10), // hash password automatique
        role: 'admin',
        matricule: `M${new Date().getFullYear()}${new Date().getMonth()+1}${new Date().getDate()}01`,
        id_centre_gest: 1, // référence au centre_gestionnaire1
        createdAt: new Date(),
        updatedAt: new Date()
      }
    ], {});
  },

  async down(queryInterface, Sequelize) {
    await queryInterface.bulkDelete('users1', null, {});
  }
};
