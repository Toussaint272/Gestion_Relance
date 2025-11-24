import 'package:flutter/material.dart';
import '../services/defaillant_service.dart';

class DefaillantsPage extends StatefulWidget {
  const DefaillantsPage({super.key});

  @override
  State<DefaillantsPage> createState() => _DefaillantsPageState();
}

class _DefaillantsPageState extends State<DefaillantsPage> {
  String? selectedCentre;
  bool isLoading = false;
  bool isLoadingCentres = false;
  List<String> centres = [];
  List defaillants = [];

  @override
  void initState() {
    super.initState();
    _loadCentres();
  }

  Future<void> _loadCentres() async {
    setState(() => isLoadingCentres = true);
    try {
      centres = await ApiService.getCentres();
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Erreur chargement centres : $e")));
    } finally {
      setState(() => isLoadingCentres = false);
    }
  }

  Future<void> fetchDefaillants() async {
    if (selectedCentre == null) return;

    setState(() => isLoading = true);
    try {
      final data = await ApiService.getDefaillants(selectedCentre!);
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
        title: const Text(
          'Défaillants par centre fiscal',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF4C6C89),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Dropdown pour le centre fiscal
            isLoadingCentres
                ? const Center(child: CircularProgressIndicator())
                : DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      labelText: "Sélectionner un centre fiscal",
                      border: OutlineInputBorder(),
                    ),
                    value: selectedCentre,
                    items: centres.map((centre) {
                      return DropdownMenuItem(
                        value: centre,
                        child: Text(centre),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() => selectedCentre = value);
                      fetchDefaillants(); // automatique après sélection
                    },
                  ),

            const SizedBox(height: 12),

            // Bouton pour charger les défaillants
            /*ElevatedButton.icon(
              onPressed: fetchDefaillants,
              icon: const Icon(Icons.search),
              label: const Text("Afficher"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                foregroundColor: Colors.white,
              ),
            ),*/
            const SizedBox(height: 20),

            // Liste des défaillants
            Expanded(
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
                                    Icon(
                                      Icons.warning,
                                      color: Colors.redAccent,
                                    ),
                                    SizedBox(width: 8),
                                    Text(
                                      "Contribuable Défaillant",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
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
          ],
        ),
      ),
    );
  }
}
