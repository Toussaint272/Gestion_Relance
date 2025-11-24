'use strict';

module.exports = {
  async up(queryInterface, Sequelize) {
    await queryInterface.createTable('assujettissement1', {
      id_assuj: {
        type: Sequelize.INTEGER,
        primaryKey: true,
        autoIncrement: true,
        allowNull: false
      },
      fiscal_no: {
        type: Sequelize.STRING(50),
        allowNull: false
      },
      annee: {
        type: Sequelize.INTEGER,
        allowNull: false
      },
      periodicite: {
        type: Sequelize.STRING(30),
        allowNull: true
      },
      debut: {
        type: Sequelize.DATE,
        allowNull: true
      },
      fin: {
        type: Sequelize.DATE,
        allowNull: true
      },
      actif: {
        type: Sequelize.BOOLEAN,
        allowNull: false,
        defaultValue: true
      },
      etat: {
        type: Sequelize.STRING(50),
        allowNull: true
      },
      createdAt: {
        allowNull: false,
        type: Sequelize.DATE,
        defaultValue: Sequelize.literal('CURRENT_TIMESTAMP')
      },
      
      updatedAt: {
        allowNull: false,
        type: Sequelize.DATE,
        defaultValue: Sequelize.literal('CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP')
      }
      
    });
  },

  async down(queryInterface, Sequelize) {
    await queryInterface.dropTable('assujettissement1');
  }
};
