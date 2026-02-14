import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../widgets/custom_input.dart';
import '../widgets/custom_button.dart';
import '../config/api_endpoints.dart';

class RegisterAdminScreen extends StatefulWidget {
  const RegisterAdminScreen({super.key});

  @override
  State<RegisterAdminScreen> createState() => _RegisterAdminScreenState();
}

class _RegisterAdminScreenState extends State<RegisterAdminScreen> {
  // Controller ho an'ny fampidirana soratra
  final nomCtrl = TextEditingController();
  final prenomCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();
  final confirmCtrl = TextEditingController();

  bool isLoading = false;
  bool obscurePass = true;
  bool obscureConfirm = true;

  // Fonction hikarakarana ny fisoratana anarana
  Future<void> handleRegister() async {
    // Fanamarinana raha feno ny saha rehetra
    if (nomCtrl.text.trim().isEmpty ||
        prenomCtrl.text.trim().isEmpty ||
        emailCtrl.text.trim().isEmpty ||
        passwordCtrl.text.isEmpty ||
        confirmCtrl.text.isEmpty) {
      _showSnackBar("Tous les champs sont obligatoires", isError: true);
      return;
    }

    // Fanamarinana ny halavan'ny teny miafina
    if (passwordCtrl.text.length < 6) {
      _showSnackBar("Mot de passe : 6 caractères minimum", isError: true);
      return;
    }

    // Fanamarinana raha mitovy ny teny miafina roa
    if (passwordCtrl.text != confirmCtrl.text) {
      _showSnackBar("Les mots de passe ne correspondent pas", isError: true);
      return;
    }

    setState(() => isLoading = true);

    try {
      final response = await http.post(
        Uri.parse(ApiEndpoints.registerAdmin),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "nom": nomCtrl.text.trim(),
          "prenom": prenomCtrl.text.trim(),
          "email": emailCtrl.text.trim(),
          "password": passwordCtrl.text,
          "role": "admin",
        }),
      );

      if (response.statusCode == 201) {
        if (!mounted) return;
        _showSuccessDialog(); // Mampiseho ilay hafatra eo afovoany
      } else {
        final data = jsonDecode(response.body);
        _showSnackBar(data['message'] ?? "Erreur d'inscription", isError: true);
      }
    } catch (e) {
      _showSnackBar("Erreur réseau : $e", isError: true);
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  // Fonction mampiseho ilay Dialog fahombiazana eo afovoany
  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.check_circle_rounded,
                  color: Colors.green,
                  size: 80,
                ),
                const SizedBox(height: 20),
                const Text(
                  "Inscription Réussie !",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2C3E50),
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  "Le compte administrateur a été créé avec succès. Vous faîtes maintenant partie de l'équipe DGI.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 14,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4C6C89),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    onPressed: () {
                      Navigator.pop(context); // Akatona ny Dialog
                      Navigator.pop(context); // Miverina any amin'ny Login
                    },
                    child: const Text(
                      "CONTINUER VERS CONNEXION",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Fonction mampiseho SnackBar ho an'ny fahadisoana
  void _showSnackBar(String msg, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        behavior: SnackBarBehavior.floating,
        backgroundColor: isError ? Colors.red.shade700 : Colors.green.shade700,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  @override
  void dispose() {
    nomCtrl.dispose();
    prenomCtrl.dispose();
    emailCtrl.dispose();
    passwordCtrl.dispose();
    confirmCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(
        context,
      ).unfocus(), // Manala klavier rehefa mikitika any ivelany
      child: Scaffold(
        backgroundColor: const Color(0xFFF4F7F9),
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          title: const Text(
            "Créer un compte Admin",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
          backgroundColor: const Color(0xFF4C6C89),
        ),
        body: Stack(
          children: [
            // Haingo manga kely eo ambony
            Container(height: 120, color: const Color(0xFF4C6C89)),

            Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 20,
                ),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 500),
                  child: Column(
                    children: [
                      const Icon(
                        Icons.admin_panel_settings,
                        size: 70,
                        color: Colors.white,
                      ),
                      const SizedBox(height: 25),

                      // Ny Card misy ny Formulaire
                      Container(
                        padding: const EdgeInsets.all(28),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.08),
                              blurRadius: 25,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            const Text(
                              "Inscription",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF2C3E50),
                              ),
                            ),
                            const SizedBox(height: 25),

                            CustomInput(
                              controller: nomCtrl,
                              hint: "Nom",
                              prefixIcon: Icons.badge_outlined,
                            ),
                            const SizedBox(height: 16),

                            CustomInput(
                              controller: prenomCtrl,
                              hint: "Prénom",
                              prefixIcon: Icons.person_outline,
                            ),
                            const SizedBox(height: 16),

                            CustomInput(
                              controller: emailCtrl,
                              hint: "Adresse Email",
                              prefixIcon: Icons.email_outlined,
                            ),
                            const SizedBox(height: 16),

                            CustomInput(
                              controller: passwordCtrl,
                              hint: "Mot de passe",
                              obscure: obscurePass,
                              prefixIcon: Icons.lock_outline,
                              suffixIcon: IconButton(
                                icon: Icon(
                                  obscurePass
                                      ? Icons.visibility_off_outlined
                                      : Icons.visibility_outlined,
                                  size: 20,
                                ),
                                onPressed: () =>
                                    setState(() => obscurePass = !obscurePass),
                              ),
                            ),
                            const SizedBox(height: 16),

                            CustomInput(
                              controller: confirmCtrl,
                              hint: "Confirmer mot de passe",
                              obscure: obscureConfirm,
                              prefixIcon: Icons.lock_reset_rounded,
                              suffixIcon: IconButton(
                                icon: Icon(
                                  obscureConfirm
                                      ? Icons.visibility_off_outlined
                                      : Icons.visibility_outlined,
                                  size: 20,
                                ),
                                onPressed: () => setState(
                                  () => obscureConfirm = !obscureConfirm,
                                ),
                              ),
                            ),

                            const SizedBox(height: 32),

                            isLoading
                                ? const CircularProgressIndicator()
                                : CustomButton(
                                    text: "S'INSCRIRE MAINTENANT",
                                    onPressed: handleRegister,
                                    backgroundColor: const Color(0xFF4C6C89),
                                    textColor: Colors.white,
                                  ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 30),
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text(
                          "Retour à la connexion",
                          style: TextStyle(
                            color: Color(0xFF4C6C89),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
