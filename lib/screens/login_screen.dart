import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dashboard.dart';
import '../widgets/custom_input.dart';
import '../widgets/custom_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool isLoading = false;

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
        Uri.parse('http://10.0.2.2:5000/api/users/login'),
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
              Image.asset('assets/logodgi.png', width: 120),
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
                      obscure: true,
                      prefixIcon: Icons.lock,
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
}
