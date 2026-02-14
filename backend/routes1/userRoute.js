const express = require('express');
const router = express.Router();
const userController = require('../controllers1/userController1');

// Login
router.post('/login', userController.login);

// Liste utilisateurs
/*router.get('/', userController.getAllUsers);*/


// CRUD utilisateurs
router.post("/register-admin", userController.registerAdmin);
router.get('/', userController.getAllUsers);
router.post('/', userController.createUser);
router.put('/:id', userController.updateUser);
router.delete('/:id', userController.deleteUser);

module.exports = router;
