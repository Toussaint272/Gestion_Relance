/*import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dashboard.dart';
import '../widgets/custom_input.dart';
import '../widgets/custom_button.dart';
import '../config/api_endpoints.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool isLoading = false;

  bool _obscurePassword = true;

  Future<void> handleLogin() async {
    final email = emailController.text.trim();
    final password = passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez remplir tous les champs')),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      final response = await http.post(
        /*Uri.parse('http://10.155.28.240:5000/api/users/login'),*/ Uri.parse(
          ApiEndpoints.login,
        ),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 &&
          data['token'] != null &&
          data['user'] != null) {
        final user = data['user'];
        final role = (user['role'] as String).toLowerCase();

        // 🔹 Stockage token + user info
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('jwt_token', data['token']);
        await prefs.setString('user_json', jsonEncode(user));
        // ✅ Tehirizo amin’ny SharedPreferences
        await prefs.setString('agentMatricule', user['matricule'] ?? '');

        // 🔹 Navigation mankany amin'ny Dashboard (Admin / Agent)
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) =>
                Dashboard(role: role, agentMatricule: user['matricule'] ?? ''),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data['message'] ?? 'Erreur de connexion')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Erreur: $e')));
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF4C6C89),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 🔹 Logo DGI
              Image.asset('assets/logoVraie.jpg', width: 160),
              const SizedBox(height: 30),

              // 🔹 Form container
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    const Text(
                      'Connexion DGI',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF4C6C89),
                      ),
                    ),
                    const SizedBox(height: 20),
                    CustomInput(
                      controller: emailController,
                      hint: "Email ou identifiant DGI",
                      prefixIcon: Icons.person,
                    ),
                    const SizedBox(height: 16),
                    CustomInput(
                      controller: passwordController,
                      hint: "Mot de passe",
                      obscure: _obscurePassword,
                      prefixIcon: Icons.lock,
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: Colors.grey,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                    ),

                    const SizedBox(height: 24),
                    isLoading
                        ? const CircularProgressIndicator(
                            color: const Color(0xFF4C6C89),
                          )
                        : CustomButton(
                            text: "Se connecter",
                            onPressed: handleLogin,
                            backgroundColor: const Color(0xFF4C6C89),
                            textColor: Colors.white,
                          ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "© DGI Madagascar",
                style: TextStyle(color: Colors.white, fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }
}*/
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'dashboard.dart';
import 'registre_admin.dart';
import '../widgets/custom_input.dart';
import '../widgets/custom_button.dart';
import '../config/api_endpoints.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool isLoading = false;
  bool _obscurePassword = true;

  // 🔹 FONCTION MAMPISEHO NOTIFICATION EO AFOWOANY
  void _showCenteredNotification(String message, {required bool isError}) {
    showDialog(
      context: context,
      barrierDismissible:
          false, // Tsy afaka esorina raha tsy tapitra ny fotoana
      builder: (BuildContext context) {
        // Miandry 1.5 segondra dia manakatona ny dialog ho azy
        Future.delayed(const Duration(milliseconds: 1500), () {
          if (Navigator.canPop(context)) Navigator.pop(context);
        });

        return Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            decoration: BoxDecoration(
              color: isError ? Colors.red.shade800 : Colors.green.shade800,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  isError
                      ? Icons.error_outline_rounded
                      : Icons.check_circle_outline_rounded,
                  color: Colors.white,
                  size: 50,
                ),
                const SizedBox(height: 15),
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> handleLogin() async {
    final email = emailController.text.trim();
    final password = passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      _showCenteredNotification(
        'Veuillez remplir tous les champs',
        isError: true,
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      final response = await http.post(
        Uri.parse(ApiEndpoints.login),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 &&
          data['token'] != null &&
          data['user'] != null) {
        final user = data['user'];
        final role = (user['role'] as String).toLowerCase();

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('jwt_token', data['token']);
        await prefs.setString('user_json', jsonEncode(user));
        await prefs.setString('agentMatricule', user['matricule'] ?? '');

        if (!mounted) return;

        // ✅ Notification eo afovoany
        _showCenteredNotification(
          'Connexion réussie !\nBienvenue ${user['nom'] ?? ""}',
          isError: false,
        );

        // Miandry kely mba ho hitan'ny mpampiasa ilay hafatra vao miova pejy
        await Future.delayed(const Duration(milliseconds: 1600));

        if (!mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) =>
                Dashboard(role: role, agentMatricule: user['matricule'] ?? ''),
          ),
        );
      } else {
        _showCenteredNotification(
          data['message'] ?? 'Email ou mot de passe incorrect',
          isError: true,
        );
      }
    } catch (e) {
      _showCenteredNotification('Erreur réseau : $e', isError: true);
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF4C6C89), Color(0xFF2C3E50)],
            ),
          ),
          child: SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 20,
                ),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 450),
                  child: Column(
                    children: [
                      // LOGO
                      Hero(
                        tag: 'logo',
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 20,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(25),
                            child: Image.asset(
                              'assets/logoVraie.jpg',
                              width: 130,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 40),

                      // CARD FORMULAIRE
                      Container(
                        padding: const EdgeInsets.all(30),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(28),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 20,
                              offset: Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            const Text(
                              'Authentification',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF2C3E50),
                              ),
                            ),
                            const SizedBox(height: 35),

                            const Text(
                              'Veuillez vous connecter pour continuer',
                              /*style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF2C3E50),
                              ),*/
                            ),
                            const SizedBox(height: 20),

                            CustomInput(
                              controller: emailController,
                              hint: "Adresse Email",
                              prefixIcon: Icons.alternate_email_rounded,
                            ),
                            const SizedBox(height: 18),

                            CustomInput(
                              controller: passwordController,
                              hint: "Mot de passe",
                              obscure: _obscurePassword,
                              prefixIcon: Icons.lock_outline_rounded,
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscurePassword
                                      ? Icons.visibility_off_outlined
                                      : Icons.visibility_outlined,
                                  color: Colors.grey,
                                  size: 20,
                                ),
                                onPressed: () => setState(
                                  () => _obscurePassword = !_obscurePassword,
                                ),
                              ),
                            ),

                            const SizedBox(height: 35),

                            isLoading
                                ? const CircularProgressIndicator()
                                : CustomButton(
                                    text: "SE CONNECTER",
                                    onPressed: handleLogin,
                                    backgroundColor: const Color(0xFF4C6C89),
                                    textColor: Colors.white,
                                  ),

                            const SizedBox(height: 25),
                            const Divider(),

                            Wrap(
                              alignment: WrapAlignment.center,
                              crossAxisAlignment: WrapCrossAlignment.center,
                              children: [
                                const Text(
                                  "Nouveau administrateur ?",
                                  style: TextStyle(fontSize: 13),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) =>
                                            const RegisterAdminScreen(),
                                      ),
                                    );
                                  },
                                  child: const Text(
                                    "Créer un compte",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF4C6C89),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 40),
                      const Text(
                        "© 2025 DGI Madagascar",
                        style: TextStyle(color: Colors.white70, fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
