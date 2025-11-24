import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Assujettissement1 {
  final int idAssuj;
  final String fiscalNo;
  final int annee;
  final String? periodicite;
  final String? debut;
  final String? fin;
  final bool actif;
  final String? etat;

  Assujettissement1({
    required this.idAssuj,
    required this.fiscalNo,
    required this.annee,
    this.periodicite,
    this.debut,
    this.fin,
    required this.actif,
    this.etat,
  });

  factory Assujettissement1.fromJson(Map<String, dynamic> json) {
    return Assujettissement1(
      idAssuj: json['id_assuj'],
      fiscalNo: json['fiscal_no'],
      annee: json['annee'],
      periodicite: json['periodicite'],
      debut: json['debut'],
      fin: json['fin'],
      actif: json['actif'] == 1 || json['actif'] == true,
      etat: json['etat'],
    );
  }
}

class ListeAssujettissement extends StatefulWidget {
  const ListeAssujettissement({super.key});

  @override
  State<ListeAssujettissement> createState() => _ListeAssujettissementState();
}

class _ListeAssujettissementState extends State<ListeAssujettissement> {
  List<Assujettissement1> _assujettissements = [];
  List<Assujettissement1> _filtered = [];
  bool _loading = true;
  String _searchFiscalNo = '';

  @override
  void initState() {
    super.initState();
    fetchAssujettissement();
  }

  Future<void> fetchAssujettissement() async {
    const String apiUrl = 'http://10.0.2.2:5000/api/assujettissementRoute';
    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = jsonDecode(response.body);
        setState(() {
          _assujettissements = jsonData
              .map((item) => Assujettissement1.fromJson(item))
              .toList();
          _filtered = _assujettissements;
          _loading = false;
        });
      } else {
        setState(() => _loading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Erreur de chargement des données")),
        );
      }
    } catch (e) {
      setState(() => _loading = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Erreur : $e")));
    }
  }

  void _search(String query) {
    setState(() {
      _searchFiscalNo = query;
      _filtered = _assujettissements
          .where(
            (item) => item.fiscalNo.toLowerCase().contains(query.toLowerCase()),
          )
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Liste des Assujettissements'),
        centerTitle: true,
        backgroundColor: const Color(0xFF1565C0),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  TextField(
                    onChanged: _search,
                    decoration: InputDecoration(
                      labelText: 'Rechercher par numéro fiscal',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      prefixIcon: const Icon(Icons.search),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: _filtered.isEmpty
                        ? const Center(
                            child: Text(
                              'Aucun assujettissement trouvé',
                              style: TextStyle(fontSize: 16),
                            ),
                          )
                        : ListView.builder(
                            itemCount: _filtered.length,
                            itemBuilder: (context, index) {
                              final a = _filtered[index];
                              return Card(
                                elevation: 3,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                margin: const EdgeInsets.symmetric(vertical: 8),
                                child: ListTile(
                                  contentPadding: const EdgeInsets.all(12),
                                  title: Text(
                                    "Fiscal n° ${a.fiscalNo}",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text("Année : ${a.annee}"),
                                      Text(
                                        "Périodicité : ${a.periodicite ?? '-'}",
                                      ),
                                      Text(
                                        "Début : ${a.debut?.substring(0, 10) ?? '-'}",
                                      ),
                                      Text(
                                        "Fin : ${a.fin?.substring(0, 10) ?? '-'}",
                                      ),
                                      Text("État : ${a.etat ?? '-'}"),
                                      const SizedBox(height: 5),
                                      Row(
                                        children: [
                                          const Text("Actif : "),
                                          Icon(
                                            a.actif
                                                ? Icons.check_circle
                                                : Icons.cancel,
                                            color: a.actif
                                                ? Colors.green
                                                : Colors.red,
                                          ),
                                        ],
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
