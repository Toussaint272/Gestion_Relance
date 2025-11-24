import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:my_app/screens/listeContribuableCentreDefaillant.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'fiche_contribuable.dart';

// 🔹 Modèle Contribuable
class Contribuable1 {
  final int id;
  final String taxPayerNo;
  final String nif;
  final String rs;
  final String centre;
  final String adresse;
  final String phone;
  final String email;
  final int dernAnnee;
  final bool actif;
  final String activite;

  Contribuable1({
    required this.id,
    required this.taxPayerNo,
    required this.nif,
    required this.rs,
    required this.centre,
    required this.adresse,
    required this.phone,
    required this.email,
    required this.dernAnnee,
    required this.actif,
    required this.activite,
  });

  factory Contribuable1.fromJson(Map<String, dynamic> json) {
    return Contribuable1(
      id: json['id'],
      taxPayerNo: json['tax_payer_no'] ?? '',
      nif: json['nif'] ?? '',
      rs: json['rs'] ?? '',
      centre: json['centre'] ?? '',
      adresse: json['adresse'] ?? '',
      phone: json['phone'] ?? '',
      email: json['email'] ?? '',
      dernAnnee: json['dern_annee'] ?? 0,
      actif: json['actif'] ?? true,
      activite: json['activite'] ?? '',
    );
  }
}

class ListeContribuables extends StatefulWidget {
  final String? agentMatricule; // ✅ facultatif pour gestion automatique

  const ListeContribuables({Key? key, this.agentMatricule}) : super(key: key);

  @override
  State<ListeContribuables> createState() => _ListeContribuablesState();
}

class _ListeContribuablesState extends State<ListeContribuables> {
  List<Contribuable1> contribuables = [];
  bool isLoading = true;
  String searchNif = '';

  final String baseUrl =
      'http://10.0.2.2:5000/api/filtreContribuableRoute/by-agent';

  @override
  void initState() {
    super.initState();
    fetchContribuables();
  }

  Future<void> fetchContribuables() async {
    try {
      // ✅ Raha tsy misy paramètre dia alaina ao amin'ny SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final matricule =
          widget.agentMatricule ?? prefs.getString('agentMatricule') ?? '';

      if (matricule.isEmpty) {
        setState(() => isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('⚠️ Aucun matricule agent trouvé')),
        );
        return;
      }

      print("📡 Envoi matricule vers backend: $matricule");

      final res = await http.get(Uri.parse('$baseUrl?matricule=$matricule'));

      print("📩 Réponse brute backend: ${res.body}");

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        final List contribList = data['contribuables'] ?? [];

        setState(() {
          contribuables = contribList
              .map((e) => Contribuable1.fromJson(e))
              .toList();
          isLoading = false;
        });
      } else {
        setState(() => isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur serveur (${res.statusCode})')),
        );
      }
    } catch (e) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Erreur: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Contribuable1> filtered = contribuables.where((c) {
      final query = searchNif.toUpperCase();
      return c.nif.toUpperCase().contains(query) ||
          c.taxPayerNo.toUpperCase().contains(query);
    }).toList();

    return Scaffold(
      /*appBar: AppBar(
        title: const Text('Liste des Contribuables'),
        backgroundColor: const Color(0xFF1565C0),
      ),*/
      appBar: AppBar(
        title: const Text('Liste des Contribuables'),
        backgroundColor: Colors.blueAccent,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.warning_amber_rounded,
              color: Color.fromARGB(255, 255, 68, 68),
            ),
            tooltip: "Voir les contribuables défaillants",
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => DefaillantsPageDefaillant()),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: 'Rechercher par NIF',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                prefixIcon: const Icon(Icons.search),
              ),
              onChanged: (value) => setState(() => searchNif = value),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : filtered.isEmpty
                  ? const Center(child: Text('Aucun contribuable trouvé'))
                  : ListView.builder(
                      itemCount: filtered.length,
                      itemBuilder: (context, index) {
                        final c = filtered[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 3,
                          child: ListTile(
                            title: Text(
                              c.rs,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('NIF: ${c.taxPayerNo}'),
                                Text('Centre: ${c.centre}'),
                                Text('Adresse: ${c.adresse}'),
                                Text('Activité: ${c.activite}'),
                                Text('Téléphone: ${c.phone}'),
                                Text(
                                  'Statut: ${c.actif ? "Actif" : "Inactif"}',
                                  style: TextStyle(
                                    color: c.actif ? Colors.green : Colors.red,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            trailing: IconButton(
                              icon: const Icon(
                                Icons.info_outline,
                                color: Colors.blueAccent,
                              ),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => FicheContribuableScreen(
                                      taxPayerNo: c.nif,
                                    ),
                                  ),
                                );
                              },
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
