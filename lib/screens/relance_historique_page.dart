import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RelanceHistoriquePage extends StatefulWidget {
  const RelanceHistoriquePage({Key? key}) : super(key: key);

  @override
  State<RelanceHistoriquePage> createState() => _RelanceHistoriquePageState();
}

class _RelanceHistoriquePageState extends State<RelanceHistoriquePage> {
  List<dynamic> relances = [];
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    fetchRelances();
  }

  // 🔹 Récupérer le matricule de l’agent connecté
  Future<String> _getAgentMatricule() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('agentMatricule') ?? '';
  }

  Future<void> fetchRelances() async {
    try {
      final matricule = await _getAgentMatricule();

      if (matricule.isEmpty) {
        setState(() {
          errorMessage = "Erreur : Agent non connecté.";
          isLoading = false;
        });
        return;
      }

      // 🔹 Endpoint backend avec query param matricule
      final response = await http.get(
        Uri.parse(
          'http://10.0.2.2:5000/api/relance_declarationRoute/historique?matricule=$matricule',
        ),
      );

      if (response.statusCode == 200) {
        setState(() {
          relances = json.decode(response.body);
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = 'Erreur serveur : ${response.statusCode}';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Erreur de connexion : $e';
        isLoading = false;
      });
    }
  }

  @override
  /*Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Relances effectuées',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF1565C0),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage.isNotEmpty
          ? Center(child: Text(errorMessage))
          : relances.isEmpty
          ? const Center(child: Text('Aucune relance effectuée 📭'))
          : ListView.builder(
              itemCount: relances.length,
              itemBuilder: (context, index) {
                final relance = relances[index];
                final dateFormat = DateFormat('dd/MM/yyyy HH:mm');

                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  child: ListTile(
                    leading: const Icon(
                      Icons.email_outlined,
                      color: Colors.blue,
                    ),
                    title: Text(
                      'Déclaration N° ${relance['N_decl'] ?? '-'}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Contribuable: ${relance['tax_payer_no'] ?? '-'}'),
                        Text('IM_Agent: ${relance['matricule'] ?? '-'}'),
                        Text('Mode: ${relance['mode'] ?? '-'}'),
                        Text('Statut: ${relance['status'] ?? '-'}'),
                        Text(
                          'Envoyée le: ${relance['date_envoi'] != null ? dateFormat.format(DateTime.parse(relance['date_envoi']).toLocal()) : '-'}',
                        ),

                        Text('Message: ${relance['message'] ?? '-'}'),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }*/
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, true);
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Relances effectuées',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: const Color(0xFF4C6C89),
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : errorMessage.isNotEmpty
            ? Center(child: Text(errorMessage))
            : relances.isEmpty
            ? const Center(child: Text('Aucune relance effectuée 📭'))
            : ListView.builder(
                itemCount: relances.length,
                itemBuilder: (context, index) {
                  final relance = relances[index];
                  final dateFormat = DateFormat('dd/MM/yyyy HH:mm');

                  return Card(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    child: ListTile(
                      leading: const Icon(
                        Icons.email_outlined,
                        color: Colors.blue,
                      ),
                      title: Text(
                        'Déclaration N° ${relance['N_decl'] ?? '-'}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Contribuable: ${relance['tax_payer_no'] ?? '-'}',
                          ),
                          Text('IM_Agent: ${relance['matricule'] ?? '-'}'),
                          Text('Mode: ${relance['mode'] ?? '-'}'),
                          Text('Statut: ${relance['status'] ?? '-'}'),
                          Text(
                            'Envoyée le: ${relance['date_envoi'] != null ? dateFormat.format(DateTime.parse(relance['date_envoi']).toLocal()) : '-'}',
                          ),
                          Text('Message: ${relance['message'] ?? '-'}'),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
