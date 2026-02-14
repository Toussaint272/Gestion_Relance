'use strict';

const sequelize = require("../config/db");

module.exports = {
  async up(queryInterface, Sequelize) {
    await queryInterface.createTable('relances1', {
      id: {
        type: Sequelize.INTEGER,
        autoIncrement: true,
        primaryKey: true,
      },
      N_decl: {
        type: Sequelize.INTEGER,
        allowNull: true,
      },
      tax_payer_no: {
        type: Sequelize.STRING,
        allowNull: false,
      },
      /*id_agent: {
          type: Sequelize.INTEGER,
          allowNull: true,
        },*/
      matricule: {
        type: Sequelize.STRING,
        allowNull: true, // ho agent connecte
      },
      
      date_envoi: {
        type: Sequelize.DATE,
        defaultValue: Sequelize.fn('NOW'),
      },
      mode: {
        type: Sequelize.ENUM('email', 'sms'),
        allowNull: false,
      },
      status: {
        type: Sequelize.ENUM('Envoyé', 'Échoué', 'En attente'),
        defaultValue: 'Envoyé',
      },
      message: {
        type: Sequelize.TEXT,
        allowNull: true,
      },
      createdAt: { type: Sequelize.DATE, allowNull: false },
      updatedAt: { type: Sequelize.DATE, allowNull: false },
    });
  },
  async down(queryInterface) {
    await queryInterface.dropTable('relances1');
  },
};
