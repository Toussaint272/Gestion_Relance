'use strict';

module.exports = {
  async up(queryInterface, Sequelize) {
    await queryInterface.bulkInsert('declaration1', [
      {
        N_decl: 1,
        tax_payer_no: '900924',
        tax_type_no: 'IRSA',
        tax_periode: '2024-01-31',
        save_date: '2024-02-05',
        received_date: '2024-02-06',
        date_echeance: '2024-02-28',
        motif: 'Déclaration mensuelle IRSA janvier',
        montant_liquide: 1500000.00
      },
      {
        N_decl: 2,
        tax_payer_no: '900925',
        tax_type_no: 'TVA',
        tax_periode: '2024-03-31',
        save_date: '2024-04-05',
        received_date: '2024-05-01',
        date_echeance: '2024-04-30',
        motif: 'Déclaration trimestrielle TVA T1',
        montant_liquide: 3000000.00
      },
      {
        N_decl: 3,
        tax_payer_no: '900926',
        tax_type_no: 'IRSA',
        tax_periode: '2024-06-30',
        save_date: '2024-07-05',
        received_date: '2024-07-06',
        date_echeance: '2024-07-31',
        motif: 'Déclaration semestrielle bénéfices',
        montant_liquide: 4500000.00
      },
      {
        N_decl: 4,
        tax_payer_no: '900927',
        tax_type_no: 'IRSA',
        tax_periode: '2024-06-30',
        save_date: '2024-07-05',
        received_date: '2024-07-06',
        date_echeance: '2024-07-31',
        motif: 'Déclaration semestrielle bénéfices',
        montant_liquide: 4500000.00
      },
      {
        N_decl: 5,
        tax_payer_no: '900928',
        tax_type_no: 'IRSA',
        tax_periode: '2024-06-30',
        save_date: '2024-07-05',
        received_date: '2024-07-06',
        date_echeance: '2024-07-31',
        motif: 'Déclaration semestrielle bénéfices',
        montant_liquide: 4500000.00
      },
      {
        N_decl: 6,
        tax_payer_no: '900929',
        tax_type_no: 'TVA',
        tax_periode: '2024-03-31',
        save_date: '2024-04-05',
        received_date: '2024-05-01',
        date_echeance: '2024-04-30',
        motif: 'Déclaration trimestrielle TVA T1',
        montant_liquide: 3000000.00
      },
      {
        N_decl: 7,
        tax_payer_no: '900930',
        tax_type_no: 'IRSA',
        tax_periode: '2024-06-30',
        save_date: '2024-07-05',
        received_date: '2024-07-06',
        date_echeance: '2024-07-31',
        motif: 'Déclaration semestrielle bénéfices',
        montant_liquide: 4500000.00
      },
      {
        N_decl: 8,
        tax_payer_no: '900931',
        tax_type_no: 'IR',
        tax_periode: '2023-12-31',
        save_date: '2024-01-05',
        received_date: '2024-01-06',
        date_echeance: '2024-01-31',
        motif: 'Déclaration annuelle IR',
        montant_liquide: 5200000.00
      },
      {
        N_decl: 9,
        tax_payer_no: '900932',
        tax_type_no: 'IS',
        tax_periode: '2024-01-31',
        save_date: '2024-02-05',
        received_date: '2024-02-06',
        date_echeance: '2024-02-28',
        motif: 'Déclaration mensuelle IS janvier',
        montant_liquide: 1500000.00
      },
    ], {});
  },

  async down(queryInterface, Sequelize) {
    await queryInterface.bulkDelete('declaration1', null, {});
  }
};
