// script/updateReste.js
/*const Paiement1 = require('./models1/Paiement1');
const Declaration1 = require('./models1/Declaration1');

(async () => {
  const paiements = await Paiement1.findAll();
  for (const p of paiements) {
    const decl = await Declaration1.findOne({ where: { N_decl: p.N_decl } });
    if (decl) {
      p.reste_a_recouvrer = decl.montant_liquide - p.montant_payer;
      await p.save();
    }
  }
  console.log('✅ Mise à jour réussie des reste_a_recouvrer');
})();*/
// scripts/updateReste.js
const Paiement1 = require('./models1/Paiement1');
const Declaration1 = require('./models1/Declaration1');

(async () => {
  try {
    console.log("⏳ Mise à jour automatique des paiements...");

    // Maka paiements rehetra
    const paiements = await Paiement1.findAll();

    for (const p of paiements) {

      const decl = await Declaration1.findOne({
        where: { N_decl: p.N_decl }
      });

      if (!decl) {
        console.log(`⚠️ Declaration ${p.N_decl} introuvable pour paiement ${p.id_paiement}`);
        continue;
      }

      const montantLiquide = parseFloat(decl.montant_liquide);
      const montantPaye = parseFloat(p.montant_payer);

      // Calcul automatique reste
      p.reste_a_recouvrer = montantLiquide - montantPaye;

      // Validation automatique
      p.valider = p.reste_a_recouvrer <= 0;

      await p.save();
      console.log(`✔ Paiement ${p.id_paiement} mis à jour`);
    }

    console.log("✅ Tous les paiements ont été mis à jour avec succès !");
    process.exit();

  } catch (error) {
    console.error("❌ Erreur :", error);
    process.exit(1);
  }
})();

