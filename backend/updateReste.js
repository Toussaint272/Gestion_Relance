// script/updateReste.js
const Paiement1 = require('./models1/Paiement1');
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
})();
