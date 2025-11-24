import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'fiche_contribuable.dart'; // ✅ import de la fiche

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

class ListeContribuables1 extends StatefulWidget {
  const ListeContribuables1({super.key});

  @override
  State<ListeContribuables1> createState() => _ListeContribuablesState();
}

class _ListeContribuablesState extends State<ListeContribuables1> {
  List<Contribuable1> contribuables = [];
  bool isLoading = true;
  String searchNif = '';

  final String baseUrl = 'http://10.0.2.2:5000/api/contribuableRoute';

  @override
  void initState() {
    super.initState();
    fetchContribuables();
  }

  Future<void> fetchContribuables() async {
    try {
      final res = await http.get(Uri.parse(baseUrl));
      if (res.statusCode == 200) {
        final List data = jsonDecode(res.body);
        setState(() {
          contribuables = data.map((e) => Contribuable1.fromJson(e)).toList();
          isLoading = false;
        });
      } else {
        throw Exception('Erreur serveur ${res.statusCode}');
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
    // 🔍 Filtrer selon NIF
    List<Contribuable1> filtered = contribuables.where((c) {
      final query = searchNif.toUpperCase();
      return c.nif.toUpperCase().contains(query) ||
          c.taxPayerNo.toUpperCase().contains(query);
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Liste des Contribuables',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF4C6C89),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // 🔎 Barre de recherche
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

            // 🧾 Liste des contribuables
            Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
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
                                Text('Telephone: ${c.phone}'),
                                Text(
                                  'Statut: ${c.actif ? "Actif" : "Inactif"}',
                                  style: TextStyle(
                                    color: c.actif ? Colors.green : Colors.red,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            /*trailing: IconButton(
                              icon: const Icon(
                                Icons.info_outline,
                                color: Colors.blueAccent,
                              ),
                              tooltip: 'Détails',
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => FicheContribuableScreen(
                                      taxPayerNo: c
                                          .nif, // ⚠️ ataovy mifanaraka amin'ny backend
                                    ),
                                  ),
                                );
                              },
                            ),*/
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
