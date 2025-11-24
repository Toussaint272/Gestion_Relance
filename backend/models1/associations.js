/*const Relance1 = require('./Relance1');
const User1 = require('./User1');

// ✅ Définir ici les relations pour éviter circular import
Relance1.belongsTo(User1, { foreignKey: 'id_agent', as: 'agent' });
User1.hasMany(Relance1, { foreignKey: 'id_agent', as: 'relances' });

module.exports = { Relance1, User1 };*/
const Relance1 = require('./Relance1');
const User1 = require('./User1');

// Association par matricule (pas par id)
User1.hasMany(Relance1, {
  foreignKey: 'matricule',
  sourceKey: 'matricule',
  as: 'relances',
});

Relance1.belongsTo(User1, {
  foreignKey: 'matricule',
  targetKey: 'matricule',
  as: 'agent',
});

module.exports = { Relance1, User1 };
