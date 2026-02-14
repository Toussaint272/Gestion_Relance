require('dotenv').config();
const express = require('express');
const app = express();
const cors = require('cors');
const { sequelize } = require('./models1/User1'); // ilaina raha sync / test connexion
const userRoute = require('./routes1/userRoute');
const paiementRoute = require('./routes1/paiementRoute');
const statsRoute = require('./routes1/statsRoute');
// Routes centres
const centreRoutes = require('./routes1/centreRoute');
const contribuableRoute = require('./routes1/contribuableRoute');
const assujettissementRoute = require('./routes1/assujettissementRoute');
const declarationRoute = require('./routes1/declarationRoute');
const relanceRoute = require('./routes1/relanceRoute');
const relance_declarationRoute = require('./routes1/relance_declarationRoute');
//teste
const filtreContribuableRoute = require('./routes1/filtreContribuableRoute');
const declarationFiltreRoute = require('./routes1/declarationFiltreRoute');
const defaillantRoute = require('./routes1/defaillantRoute');
const centreRouteContribuable = require('./routes1/centreRouteContribuable');
const declarationRetardRoute = require('./routes1/declarationRetardRoute');
const totalDefaillantRoute = require('./routes1/totalDefaillantRoute');
const contribuableCentreRoute = require('./routes1/contribuableCentreRoute');
app.use('/api/stats', statsRoute);
app.use(cors());
app.use(express.json());

// Routes
app.use('/api/users', userRoute);
app.use('/api/centres', centreRoutes);
app.use('/api/contribuableRoute', contribuableRoute);
app.use('/api/assujettissementRoute', assujettissementRoute);
app.use('/api/declarationRoute', declarationRoute);
app.use('/api/paiementRoute', paiementRoute);
app.use('/api/relanceRoute', relanceRoute);
app.use('/api/relance_declarationRoute', relance_declarationRoute);
app.use('/api/totalDefaillantRoute', totalDefaillantRoute);
require('./models1/associations');
require('./models1/index2');
//test
app.use('/api/filtreContribuableRoute', filtreContribuableRoute);
app.use('/api/declarationFiltreRoute', declarationFiltreRoute);
app.use('/api/defaillantRoute', defaillantRoute);
app.use('/api/centreRouteContribuable', centreRouteContribuable);
app.use('/api/declarationRetardRoute', declarationRetardRoute);
app.use('/api/contribuableCentreRoute', contribuableCentreRoute);
// Test connexion DB
sequelize.authenticate()
  .then(() => console.log('Connexion DB réussie'))
  .catch(err => console.error('Erreur connexion DB :', err));

// Lancer serveur
const PORT = process.env.PORT || 5000;
app.listen(PORT, '0.0.0.0', () => console.log(`Serveur lancé sur port ${PORT}`));
/*require('dotenv').config();
const express = require('express');
const app = express();
const cors = require('cors');
const helmet = require('helmet');
const rateLimit = require('express-rate-limit');

// DB
const { sequelize } = require('./models1/User1');

// ROUTES
const userRoute = require('./routes1/userRoute');
const paiementRoute = require('./routes1/paiementRoute');
const statsRoute = require('./routes1/statsRoute');
const centreRoutes = require('./routes1/centreRoute');
const contribuableRoute = require('./routes1/contribuableRoute');
const assujettissementRoute = require('./routes1/assujettissementRoute');
const declarationRoute = require('./routes1/declarationRoute');
const relanceRoute = require('./routes1/relanceRoute');
const relance_declarationRoute = require('./routes1/relance_declarationRoute');

// TEST
const filtreContribuableRoute = require('./routes1/filtreContribuableRoute');
const declarationFiltreRoute = require('./routes1/declarationFiltreRoute');
const defaillantRoute = require('./routes1/defaillantRoute');
const centreRouteContribuable = require('./routes1/centreRouteContribuable');
const declarationRetardRoute = require('./routes1/declarationRetardRoute');
const totalDefaillantRoute = require('./routes1/totalDefaillantRoute');
const contribuableCentreRoute = require('./routes1/contribuableCentreRoute');

// 🔒 SECURITY MIDDLEWARES
app.use(helmet());
app.use(cors());
app.use(express.json());

// 🔒 Rate limiter login
const loginLimiter = rateLimit({
  windowMs: 15 * 60 * 1000,
  max: 10,
  message: "Trop de tentatives de connexion. Réessayez plus tard."
});
app.use("/api/users/login", loginLimiter);

// ROUTES
app.use('/api/stats', statsRoute);
app.use('/api/users', userRoute);
app.use('/api/centres', centreRoutes);
app.use('/api/contribuableRoute', contribuableRoute);
app.use('/api/assujettissementRoute', assujettissementRoute);
app.use('/api/declarationRoute', declarationRoute);
app.use('/api/paiementRoute', paiementRoute);
app.use('/api/relanceRoute', relanceRoute);
app.use('/api/relance_declarationRoute', relance_declarationRoute);
app.use('/api/filtreContribuableRoute', filtreContribuableRoute);
app.use('/api/declarationFiltreRoute', declarationFiltreRoute);
app.use('/api/defaillantRoute', defaillantRoute);
app.use('/api/centreRouteContribuable', centreRouteContribuable);
app.use('/api/declarationRetardRoute', declarationRetardRoute);
app.use('/api/totalDefaillantRoute', totalDefaillantRoute);
app.use('/api/contribuableCentreRoute', contribuableCentreRoute);

// DB TEST
sequelize.authenticate()
  .then(() => console.log('Connexion DB réussie'))
  .catch(err => console.error('Erreur connexion DB :', err));

// SERVER
const PORT = process.env.PORT || 5000;
app.listen(PORT, () => console.log(`Serveur lancé sur port ${PORT}`));*/

