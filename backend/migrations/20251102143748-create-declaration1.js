'use strict';

module.exports = {
  async up(queryInterface, Sequelize) {
    await queryInterface.createTable('declaration1', {
      N_decl: {
        type: Sequelize.INTEGER,
        primaryKey: true,
        autoIncrement: true
      },
      tax_payer_no: {
        type: Sequelize.STRING(50),
        allowNull: false
      },
      tax_type_no: {
        type: Sequelize.STRING(30),
        allowNull: true
      },
      tax_periode: {
        type: Sequelize.DATE,
        allowNull: true
      },
      save_date: {
        type: Sequelize.DATE,
        allowNull: true
      },
      received_date: {
        type: Sequelize.DATE,
        allowNull: true
      },
      date_echeance: {
        type: Sequelize.DATE,
        allowNull: true
      },
      motif: {
        type: Sequelize.TEXT,
        allowNull: true
      },
      montant_liquide: {        // 🔹 Champ ajouté
        type: Sequelize.DECIMAL(15, 2),
        allowNull: true,
        defaultValue: 0.00
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
    await queryInterface.dropTable('declaration1');
  }
};
