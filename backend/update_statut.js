// update_statut.js
const Declaration1 = require('./models1/Declaration1'); // alefaso ilay model marina
const sequelize = require('./config/db'); // raha ilaina mba connect DB

async function updateStatutAll() {
  try {
    // Miantso ny toutes les déclarations
    const declarations = await Declaration1.findAll();

    for (const d of declarations) {
      if (!d.received_date) {
        d.statut = 'Non reçu';
      } else if (d.date_echeance && d.received_date > d.date_echeance) {
        d.statut = 'En retard';
      } else {
        d.statut = 'Valide';
      }

      await d.save(); // Mise à jour DB
    }

    console.log('✅ Tous les statuts ont été mis à jour');
    process.exit();
  } catch (err) {
    console.error('❌ Erreur:', err);
    process.exit(1);
  }
}

updateStatutAll();
