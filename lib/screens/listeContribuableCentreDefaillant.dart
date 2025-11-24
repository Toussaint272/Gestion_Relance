import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/defaillantContribuableCentre_service.dart';

class DefaillantsPageDefaillant extends StatefulWidget {
  final String? matricule; // 🔹 Passer le matricule de l'agent si misy

  const DefaillantsPageDefaillant({super.key, this.matricule});

  @override
  State<DefaillantsPageDefaillant> createState() => _DefaillantsPageState();
}

class _DefaillantsPageState extends State<DefaillantsPageDefaillant> {
  bool isLoading = false;
  List defaillants = [];

  @override
  void initState() {
    super.initState();
    _loadDefaillants(); // 🔹 Charger automatiquement à l'ouverture
  }

  Future<void> _loadDefaillants() async {
    String? matricule = widget.matricule;

    // 🔹 Si le constructeur ne fournit pas le matricule, on prend depuis SharedPreferences
    if (matricule == null || matricule.isEmpty) {
      final prefs = await SharedPreferences.getInstance();
      matricule = prefs.getString('agentMatricule');
    }

    if (matricule != null && matricule.isNotEmpty) {
      fetchDefaillants(matricule);
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("⚠️ Aucun agent connecté")));
      setState(() => defaillants = []);
    }
  }

  Future<void> fetchDefaillants(String matricule) async {
    setState(() => isLoading = true);
    try {
      final data = await ApiService.getDefaillantsByMatricule(matricule);
      setState(() {
        defaillants = data['defaillants'];
      });
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Erreur : $e")));
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contribuables Défaillants'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : defaillants.isEmpty
            ? const Center(child: Text("Aucun contribuable défaillant"))
            : ListView.builder(
                itemCount: defaillants.length,
                itemBuilder: (context, index) {
                  final d = defaillants[index];
                  return Card(
                    elevation: 3,
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: const [
                              Icon(Icons.warning, color: Colors.redAccent),
                              SizedBox(width: 8),
                              Text(
                                "Contribuable Défaillant",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "NIF : ${d['tax_payer_no']}",
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "Contribuable : ${d['rs']}",
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text("Motif : ${d['motif'] ?? '-'}"),
                          Text("Centre : ${d['centre'] ?? '-'}"),
                          Text("Adresse : ${d['adresse'] ?? '-'}"),
                          Text("Activité : ${d['activite'] ?? '-'}"),
                          Text("Téléphone : ${d['phone'] ?? '-'}"),
                          Text(
                            "Statut : ${d['actif'] == true ? "Actif" : "Inactif"}",
                            style: TextStyle(
                              color: d['actif'] == true
                                  ? Colors.green
                                  : Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
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
