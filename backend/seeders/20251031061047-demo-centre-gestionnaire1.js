'use strict';

module.exports = {
  async up(queryInterface, Sequelize) {
    await queryInterface.bulkInsert('centre_gestionnaire1', [
      {
        CG_designation: 'Centre Fiscal Antananarivo I',
        mail: 'cf1tana@gmail.com',
        lieu_bureau: 'Antananarivo',
        tel: '034 12 345 67',
        adresse: 'Analakely pres Firaisana I',
        code_bureau: '21-1-702',
        CG_ABBREV: 'CF TANA I',
        createdAt: new Date(),
        updatedAt: new Date()
      },
      {
        CG_designation: 'Centre Fiscal Toliary A',
        mail: 'cftoliara@gmail.com',
        lieu_bureau: 'Toliary',
        tel: '034 41 953 91',
        adresse: 'Route de Belemboka Betania',
        code_bureau: '21-6-724',
        CG_ABBREV: 'CF TOLIARY A',
        createdAt: new Date(),
        updatedAt: new Date()
      },
      {
        CG_designation: 'Centre Fiscal Brieville',
        mail: 'cfbrieville@gmail.com',
        lieu_bureau: 'Brieville',
        tel: '034 31 346 22',
        adresse: '',
        code_bureau: '21-6-768',
        CG_ABBREV: 'CF BRIEVILLE',
        createdAt: new Date(),
        updatedAt: new Date()
      },
      {
        CG_designation: 'Centre Fiscal Betafo',
        mail: 'cfbetafo@gmail.com',
        lieu_bureau: 'Betafo',
        tel: '034 35 789 96',
        adresse: 'Route de I hopital Betioky ville',
        code_bureau: '21-6-767',
        CG_ABBREV: 'CF BETAFO',
        createdAt: new Date(),
        updatedAt: new Date()
      },
      {
        CG_designation: 'Centre Fiscal Ambanja',
        mail: 'cfambanja@gmail.com',
        lieu_bureau: 'Ambanja',
        tel: '034 12 345 67',
        adresse: 'Pres Hotel de Ville ',
        code_bureau: '21-7-203',
        CG_ABBREV: 'CF AMBANJA',
        createdAt: new Date(),
        updatedAt: new Date()
      }
    ]);
  },

  async down(queryInterface, Sequelize) {
    await queryInterface.bulkDelete('centre_gestionnaire1', null);
  }
};
