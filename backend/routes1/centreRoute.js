const express = require('express');
const router = express.Router();
const centreController = require('../controllers1/centreController1');

// Liste centres
router.get('/', centreController.getAllCentres);

module.exports = router;
