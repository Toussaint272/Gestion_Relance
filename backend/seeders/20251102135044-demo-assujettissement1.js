'use strict';

module.exports = {
  async up(queryInterface, Sequelize) {
    await queryInterface.bulkInsert('Assujettissement1', [
      {
        fiscal_no: '900924',
        annee: 2024,
        periodicite: 'Mensuelle',
        debut: new Date('2024-01-01'),
        fin: new Date('2024-12-31'),
        actif: 1,
        etat: 'En cours',
        createdAt: new Date(),
        updatedAt: new Date(),
      },
      {
        fiscal_no: '900925',
        annee: 2024,
        periodicite: 'Trimestrielle',
        debut: new Date('2024-01-01'),
        fin: new Date('2024-12-31'),
        actif: 1,
        etat: 'En cours',
        createdAt: new Date(),
        updatedAt: new Date(),
      },
      {
        fiscal_no: '900926',
        annee: 2024,
        periodicite: 'Annuelle',
        debut: new Date('2024-01-01'),
        fin: new Date('2024-12-31'),
        actif: 1,
        etat: 'En cours',
        createdAt: new Date(),
        updatedAt: new Date(),
      },
      {
        fiscal_no: '900927',
        annee: 2023,
        periodicite: 'Mensuelle',
        debut: new Date('2023-01-01'),
        fin: new Date('2023-12-31'),
        actif: 0,
        etat: 'Radié',
        createdAt: new Date(),
        updatedAt: new Date(),
      },
      {
        fiscal_no: '900928',
        annee: 2022,
        periodicite: 'Mensuelle',
        debut: new Date('2022-01-01'),
        fin: new Date('2022-12-31'),
        actif: 0,
        etat: 'Radié',
        createdAt: new Date(),
        updatedAt: new Date(),
      },
    ]);
  },

  async down(queryInterface, Sequelize) {
    await queryInterface.bulkDelete('Assujettissement1', null, {});
  }
};
