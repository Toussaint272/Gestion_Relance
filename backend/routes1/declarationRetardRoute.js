const express = require('express');
const router = express.Router();
const declarationRetardController1 = require('../controllers1/declarationRetardController1');

router.get('/en-retard', declarationRetardController1.getDeclarationsEnRetard);

module.exports = router;
