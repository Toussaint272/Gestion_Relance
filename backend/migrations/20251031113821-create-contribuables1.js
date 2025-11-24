'use strict';

module.exports = {
  async up(queryInterface, Sequelize) {
    await queryInterface.createTable('contribuables1', {
      id: {
        type: Sequelize.INTEGER,
        primaryKey: true,
        autoIncrement: true
      },
      tax_payer_no: {
        type: Sequelize.STRING(50),
        unique: true
      },
      nif: {
        type: Sequelize.STRING(50),
        unique: true
      },
      rs: {
        type: Sequelize.STRING(255)
      },
      centre: {
        type: Sequelize.STRING(100)
      },
      adresse: {
        type: Sequelize.STRING(255)
      },
      phone: {
        type: Sequelize.STRING(50)
      },
      email: {
        type: Sequelize.STRING(100)
      },
      dern_annee: {
        type: Sequelize.INTEGER
      },
      actif: {
        type: Sequelize.BOOLEAN,
        defaultValue: true
      },
      activite: {
        type: Sequelize.STRING(255)
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
    await queryInterface.dropTable('contribuables1');
  }
};
