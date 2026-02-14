'use strict';

module.exports = {
  up: async (queryInterface, Sequelize) => {
    await queryInterface.createTable('paiement1', {
      id_paiement: {
        type: Sequelize.INTEGER,
        primaryKey: true,
        autoIncrement: true
      },
      tax_payer_no: {
        type: Sequelize.STRING,
        allowNull: false,
        references: {
          model: 'contribuables1',
          key: 'tax_payer_no'
        },
        onDelete: 'CASCADE'
      },
      N_decl: {
        type: Sequelize.INTEGER,
        allowNull: false,
        references: { model: 'declaration1', key: 'N_decl' },
        onDelete: 'CASCADE'
      },
      montant_payer: {
        type: Sequelize.DECIMAL(15,2),
        allowNull: false
      },
      reste_a_recouvrer: {
        type: Sequelize.DECIMAL(15,2),
        allowNull: true,
        defaultValue: null
      },
      date_payment: {
        type: Sequelize.DATE,
        allowNull: false,
        defaultValue: Sequelize.NOW
      },
      valider: {
        type: Sequelize.BOOLEAN,
        allowNull: false,
        defaultValue: false
      },
      mode_paiement: {
        type: Sequelize.ENUM('espece','virement','cheque','autre'),
        allowNull: false,
        defaultValue: 'espece'
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

  down: async (queryInterface, Sequelize) => {
    await queryInterface.dropTable('paiement1');
  }
};
