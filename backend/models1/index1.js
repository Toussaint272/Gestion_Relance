const User1 = require('./User1');
const CentreGestionnaire1 = require('./CentreGestionnaire1');

// Définir relations eto fa tsy ao amin'ny model tsirairay
CentreGestionnaire1.hasMany(User1, { foreignKey: 'id_centre_gest', as: 'users' });
User1.belongsTo(CentreGestionnaire1, { foreignKey: 'id_centre_gest', as: 'centre' });

module.exports = {
  User1,
  CentreGestionnaire1
};
