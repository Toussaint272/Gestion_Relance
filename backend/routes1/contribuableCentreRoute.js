const express = require("express");
const router = express.Router();
const contribuableCentreController1 = require("../controllers1/contribuableCentreController1");

// Route pour récupérer les défaillants selon agent connecté
router.get("/by-Centre", contribuableCentreController1.getContribuableCentre);

module.exports = router;
