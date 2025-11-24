'use strict';

module.exports = {
  async up(queryInterface, Sequelize) {
    await queryInterface.createTable('centre_gestionnaire1', {
      id_centre_gest: {
        allowNull: false,
        autoIncrement: true,
        primaryKey: true,
        type: Sequelize.INTEGER
      },
      CG_designation: {
        type: Sequelize.STRING(100),
        allowNull: false
      },
      lieu_bureau: {
        type: Sequelize.STRING(100),
        allowNull: true
      },
      mail: {
        type: Sequelize.STRING(100),
        allowNull: true
      },
      tel: {
        type: Sequelize.STRING(50),
        allowNull: true
      },
      adresse: {
        type: Sequelize.STRING(255),
        allowNull: true
      },
      code_bureau: {
        type: Sequelize.STRING(20),
        allowNull: true
      },
      CG_ABBREV: {
        type: Sequelize.STRING(20),
        allowNull: true
      },
      // ✅ timestamps
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
    await queryInterface.dropTable('centre_gestionnaire1');
  }
};
