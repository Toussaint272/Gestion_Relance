const express = require("express");
const router = express.Router();
const { registerAdmin } = require("../controllers/user.controller");

router.post("/register-admin", registerAdmin);

module.exports = router;
