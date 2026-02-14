/*import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_endpoints.dart';

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
    /*const String apiUrl = 'http://10.155.28.240:5000/api/assujettissementRoute';*/
    const String apiUrl = ApiEndpoints.assujettissement;
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
        backgroundColor: const Color(0xFF4C6C89),
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
                                                ? Color(0xFF5C8D89)
                                                : Color(0xFFD9534F),
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
}*/
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_endpoints.dart';

// --- Model (Tsy miova) ---
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

  @override
  void initState() {
    super.initState();
    fetchAssujettissement();
  }

  Future<void> fetchAssujettissement() async {
    const String apiUrl = ApiEndpoints.assujettissement;
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
      }
    } catch (e) {
      setState(() => _loading = false);
    }
  }

  void _search(String query) {
    setState(() {
      _filtered = _assujettissements
          .where(
            (item) => item.fiscalNo.toLowerCase().contains(query.toLowerCase()),
          )
          .toList();
    });
  }

  // --- Fanamboarana ny Interface (IHM) ---
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7F9), // Loko fond maivana
      appBar: AppBar(
        title: const Text(
          'Assujettissements',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF4C6C89),
        elevation: 0,
      ),
      body: Column(
        children: [
          // Section fikarohana voadio
          Container(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 20),
            decoration: const BoxDecoration(
              color: Color(0xFF4C6C89),
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
            ),
            child: TextField(
              onChanged: _search,
              style: const TextStyle(color: Colors.black87),
              decoration: InputDecoration(
                hintText: 'Rechercher par numéro fiscal...',
                filled: true,
                fillColor: Colors.white,
                prefixIcon: const Icon(Icons.search, color: Color(0xFF4C6C89)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
              ),
            ),
          ),

          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : _filtered.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: _filtered.length,
                    itemBuilder: (context, index) =>
                        _buildAssujCard(_filtered[index]),
                  ),
          ),
        ],
      ),
    );
  }

  // Widget ho an'ny lisitra (Card)
  Widget _buildAssujCard(Assujettissement1 a) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.assignment_outlined,
                      color: Color(0xFF4C6C89),
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      "Fiscal n° ${a.fiscalNo}",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                _buildStatusBadge(a.actif),
              ],
            ),
            const Divider(height: 24),
            Row(
              children: [
                _infoColumn("Année", a.annee.toString(), Icons.calendar_today),
                _infoColumn(
                  "Périodicité",
                  a.periodicite ?? '-',
                  Icons.timer_outlined,
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                _infoColumn(
                  "Début",
                  a.debut?.substring(0, 10) ?? '-',
                  Icons.login,
                ),
                _infoColumn(
                  "Fin",
                  a.fin?.substring(0, 10) ?? '-',
                  Icons.logout,
                ),
              ],
            ),
            if (a.etat != null) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.info_outline,
                      size: 16,
                      color: Colors.blueGrey,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      "État : ${a.etat}",
                      style: const TextStyle(
                        fontSize: 13,
                        color: Colors.blueGrey,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  // Column kely ho an'ny fampahalalana ao anaty card
  Widget _infoColumn(String label, String value, IconData icon) {
    return Expanded(
      child: Row(
        children: [
          Icon(icon, size: 14, color: Colors.grey[600]),
          const SizedBox(width: 6),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(fontSize: 11, color: Colors.grey[600]),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Badge ho an'ny Actif/Inactif
  Widget _buildStatusBadge(bool isActive) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: isActive
            ? const Color(0xFF5C8D89).withOpacity(0.1)
            : const Color(0xFFD9534F).withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isActive ? const Color(0xFF5C8D89) : const Color(0xFFD9534F),
          width: 0.5,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isActive ? Icons.check_circle : Icons.cancel,
            size: 14,
            color: isActive ? const Color(0xFF5C8D89) : const Color(0xFFD9534F),
          ),
          const SizedBox(width: 4),
          Text(
            isActive ? "Actif" : "Inactif",
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: isActive
                  ? const Color(0xFF5C8D89)
                  : const Color(0xFFD9534F),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off, size: 64, color: Colors.grey[300]),
          const SizedBox(height: 16),
          const Text(
            'Aucun assujettissement trouvé',
            style: TextStyle(color: Colors.grey, fontSize: 16),
          ),
        ],
      ),
    );
  }
}
