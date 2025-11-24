'use strict';

module.exports = {
  async up (queryInterface, Sequelize) {
    await queryInterface.bulkInsert('Paiement1', [
      {
        tax_payer_no: '900924',
        N_decl: 1, // id avy amin’ny table Declaration
        montant_payer: 1500000,
        date_payment: new Date(),
        valider: true,
        mode_paiement: 'Espèce',
        createdAt: new Date(),
        updatedAt: new Date(),
      },
      {
        tax_payer_no: '900925',
        N_decl: 2,
        montant_payer: 1700000,
        date_payment: new Date(),
        valider: false,
        mode_paiement: 'Virement',
        createdAt: new Date(),
        updatedAt: new Date(),
      },
      {
        tax_payer_no: '900926',
        N_decl: 3,
        montant_payer: 2500000,
        date_payment: new Date(),
        valider: false,
        mode_paiement: 'Virement',
        createdAt: new Date(),
        updatedAt: new Date(),
      },
      {
        tax_payer_no: '900927',
        N_decl: 4,
        montant_payer: 3700000,
        date_payment: new Date(),
        valider: false,
        mode_paiement: 'Virement',
        createdAt: new Date(),
        updatedAt: new Date(),
      }
    ], {});
  },

  async down (queryInterface, Sequelize) {
    await queryInterface.bulkDelete('Paiement1', null, {});
  }
};
