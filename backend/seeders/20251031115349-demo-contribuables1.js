'use strict';

module.exports = {
  async up (queryInterface, Sequelize) {
    await queryInterface.bulkInsert('contribuables1', [
      {
        tax_payer_no: '900924',
        nif: '1234567892',
        rs: 'Entreprise Andry SARL',
        centre: 'Centre Fiscal Antananarivo I',
        adresse: 'Analakely pres Firaisana I',
        phone: '0341234567',
        email: 'andry@example.com',
        dern_annee: 2024,
        actif: true,
        activite: 'Commerce général',
        createdAt: new Date(),
        updatedAt: new Date()
      },
      {
        tax_payer_no: '900925',
        nif: '9876543213',
        rs: 'Rabe Import Export',
        centre: 'Centre Fiscal Toliary A',
        adresse: 'Route de Belemboka Betania',
        phone: '0336547890',
        email: 'tokyratolojanahary719@gmail.com',
        dern_annee: 2024,
        actif: true,
        activite: 'Import-export',
        createdAt: new Date(),
        updatedAt: new Date()
      },
      {
        tax_payer_no: '900926',
        nif: '9876543214',
        rs: 'Rasoa Export',
        centre: 'Centre Fiscal Toliary A',
        adresse: 'Route de Belemboka Betania',
        phone: '0346547896',
        email: 'degratolojanahary@gmail.com',
        dern_annee: 2024,
        actif: true,
        activite: 'export',
        createdAt: new Date(),
        updatedAt: new Date()
      },
      {
        tax_payer_no: '900927',
        nif: '9876543215',
        rs: 'Rakoto transport',
        centre: 'Centre Fiscal Toliary A',
        adresse: 'Route de Belemboka Betania',
        phone: '0338147822',
        email: 'rakoto@gmail.com',
        dern_annee: 2023,
        actif: true,
        activite: 'transport',
        createdAt: new Date(),
        updatedAt: new Date()
      },
      {
        tax_payer_no: '900928',
        nif: '9876543216',
        rs: 'Ravao Import',
        centre: 'Centre Fiscal Toliary A',
        adresse: 'Route de Belemboka Betania',
        phone: '0346547867',
        email: 'ravao@gmail.com',
        dern_annee: 2023,
        actif: true,
        activite: 'Import',
        createdAt: new Date(),
        updatedAt: new Date()
      },
      {
        tax_payer_no: '900929',
        nif: '9876543217',
        rs: 'Michel transport',
        centre: 'Centre Fiscal Toliary A',
        adresse: 'Route de Belemboka Betania',
        phone: '0333175692',
        email: 'michel@gmail.com',
        dern_annee: 2023,
        actif: true,
        activite: 'transport',
        createdAt: new Date(),
        updatedAt: new Date()
      },
      {
        tax_payer_no: '900930',
        nif: '2001456781',
        rs: 'Toky Textile',
        centre: 'Centre Fiscal Brieville',
        adresse: 'Brieville',
        phone: '0344195391',
        email: 'toussainttokyratolojanahary@gmail.com',
        dern_annee: 2022,
        actif: true,
        activite: 'Fabrication textile',
        createdAt: new Date(),
        updatedAt: new Date()
      },
      {
        tax_payer_no: '900931',
        nif: '2002456788',
        rs: 'Rasoa Export ',
        centre: 'Centre Fiscal Betafo',
        adresse: 'Route de I hopital Betioky ville',
        phone: '0343356091',
        email: 'rasoa@gmail.com',
        dern_annee: 2023,
        actif: true,
        activite: 'Exportation café',
        createdAt: new Date(),
        updatedAt: new Date()
      },
      {
        tax_payer_no: '900932',
        nif: '2003456767',
        rs: 'Charle ETS',
        centre: 'Centre Fiscal Ambanja',
        adresse: 'Ambanja',
        phone: '0343963251',
        email: 'charle@gmail.com',
        dern_annee: 2023,
        actif: true,
        activite: 'Transport',
        createdAt: new Date(),
        updatedAt: new Date()
      }
    ]);
  },

  async down (queryInterface, Sequelize) {
    await queryInterface.bulkDelete('contribuables1', null, {});
  }
};
