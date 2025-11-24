const express = require('express');
const router = express.Router();
const contribuablesController1 = require('../controllers1/contribuablesController1');

// Route GET pour filtrer par matricule
router.get('/by-agent', contribuablesController1.getContribuablesByAgent);

module.exports = router;
