/*import 'package:flutter/material.dart';
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
}*/
import 'package:flutter/material.dart';
import 'package:my_app/screens/liste_contribuables.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/defaillantContribuableCentre_service.dart';
import 'fiche_contribuable.dart';

// Modely nohavaozina
class Contribuable1 {
  final int id;
  final String nif;
  final String taxPayerNo;
  final String rs;
  final String centre;
  final String adresse;
  final String phone;
  final bool actif;
  final String activite;
  final String motif;

  Contribuable1({
    required this.id,
    required this.nif,
    required this.taxPayerNo,
    required this.rs,
    required this.centre,
    required this.adresse,
    required this.phone,
    required this.actif,
    required this.activite,
    required this.motif,
  });

  factory Contribuable1.fromJson(Map<String, dynamic> json) {
    return Contribuable1(
      id: json['id'] ?? 0,
      nif: json['nif'] ?? '',
      taxPayerNo: json['tax_payer_no'] ?? '',
      rs: json['rs'] ?? '-',
      centre: json['centre'] ?? '-',
      adresse: json['adresse'] ?? '-',
      phone: json['phone'] ?? '-',
      actif: json['actif'] ?? false,
      activite: json['activite'] ?? '-',
      motif: json['motif'] ?? '-',
    );
  }
}

class DefaillantsPageDefaillant extends StatefulWidget {
  final String? matricule;
  const DefaillantsPageDefaillant({Key? key, this.matricule}) : super(key: key);

  @override
  State<DefaillantsPageDefaillant> createState() =>
      _DefaillantsPageDefaillantState();
}

class _DefaillantsPageDefaillantState extends State<DefaillantsPageDefaillant> {
  List<Contribuable1> defaillants = [];
  bool isLoading = true;
  String searchNif = '';

  @override
  void initState() {
    super.initState();
    _loadDefaillants();
  }

  Future<void> _loadDefaillants() async {
    setState(() => isLoading = true);
    String? matricule = widget.matricule;

    if (matricule == null || matricule.isEmpty) {
      final prefs = await SharedPreferences.getInstance();
      matricule = prefs.getString('agentMatricule');
    }

    if (matricule == null || matricule.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('⚠️ Aucun agent connecté'),
          backgroundColor: Colors.orange,
        ),
      );
      setState(() => isLoading = false);
      return;
    }

    try {
      final data = await ApiService.getDefaillantsByMatricule(matricule);
      final List list = data['defaillants'] ?? [];
      setState(() {
        defaillants = list.map((e) => Contribuable1.fromJson(e)).toList();
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Erreur: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final filtered = defaillants.where((c) {
      final query = searchNif.toUpperCase();
      return c.nif.toUpperCase().contains(query) ||
          c.taxPayerNo.toUpperCase().contains(query);
    }).toList();

    return Scaffold(
      backgroundColor: const Color(
        0xFFF4F7F9,
      ), // Loko maivana ho an'ny background
      appBar: AppBar(
        title: const Text(
          'Défaillants affectés',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF4C6C89),
        elevation: 0,
      ),
      body: Column(
        children: [
          // Bar de recherche mihaingo
          Container(
            padding: const EdgeInsets.all(16),
            color: const Color(0xFF4C6C89),
            child: TextField(
              onChanged: (value) => setState(() => searchNif = value),
              decoration: InputDecoration(
                hintText: 'Rechercher par NIF...',
                prefixIcon: const Icon(Icons.search, color: Color(0xFF4C6C89)),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : filtered.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      final c = filtered[index];
                      return _buildContribuableCard(c);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildContribuableCard(Contribuable1 c) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 2,
      child: InkWell(
        borderRadius: BorderRadius.circular(15),
        onTap: () => _navigateToFiche(c),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Ligne 1: Anarana ary Statut
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      c.rs,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Color(0xFF2C3E50),
                      ),
                    ),
                  ),
                  _buildStatusBadge(c.actif),
                ],
              ),
              const SizedBox(height: 8),

              // Ligne 2: NIF
              Row(
                children: [
                  const Icon(Icons.fingerprint, size: 16, color: Colors.grey),
                  const SizedBox(width: 5),
                  Text(
                    "NIF: ${c.taxPayerNo}",
                    style: const TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              const Divider(height: 20),

              // Andalana mombamomba
              _buildInfoRow(Icons.business, "Centre", c.centre),
              _buildInfoRow(Icons.location_on, "Adresse", c.adresse),
              _buildInfoRow(Icons.phone, "Contact", c.phone),

              const SizedBox(height: 10),

              // Motif miloko
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFEBEE),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.warning_amber_rounded,
                      size: 18,
                      color: Color(0xFFD9534F),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        "Motif: ${c.motif}",
                        style: const TextStyle(
                          color: Color(0xFFD9534F),
                          fontStyle: FontStyle.italic,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Icon(icon, size: 14, color: const Color(0xFF4C6C89)),
          const SizedBox(width: 8),
          Text(
            "$label: ",
            style: const TextStyle(fontSize: 13, color: Colors.grey),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(bool actif) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: actif ? const Color(0xFFE8F5E9) : const Color(0xFFFFEBEE),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        actif ? "ACTIF" : "INACTIF",
        style: TextStyle(
          color: actif ? const Color(0xFF2E7D32) : const Color(0xFFC62828),
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off, size: 60, color: Colors.grey[300]),
          const SizedBox(height: 10),
          const Text(
            "Aucun contribuable trouvé",
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  void _navigateToFiche(Contribuable1 c) {
    final String targetNif = c.nif.isNotEmpty ? c.nif : c.taxPayerNo;

    if (targetNif.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('❌ NIF introuvable')));
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => ListeContribuables()),
    );
  }
}
