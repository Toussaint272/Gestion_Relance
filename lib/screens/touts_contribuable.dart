import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:my_app/screens/fichetotal_contribuable.dart';
import 'fiche_contribuable.dart';
import '../config/api_endpoints.dart';

// 🔹 Modèle Contribuable (Tsy niova)
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

  final String baseUrl = ApiEndpoints.contribuableBase;

  @override
  void initState() {
    super.initState();
    fetchContribuables();
  }

  // --- Logic Tsy niova ---
  Future<void> fetchContribuables() async {
    try {
      final res = await http.get(Uri.parse(baseUrl));
      if (res.statusCode == 200) {
        final List data = jsonDecode(res.body);
        if (!mounted) return;
        setState(() {
          contribuables = data.map((e) => Contribuable1.fromJson(e)).toList();
          isLoading = false;
        });
      } else {
        throw Exception('Erreur serveur ${res.statusCode}');
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => isLoading = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Erreur: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    // Logic filtrage tsy niova
    List<Contribuable1> filtered = contribuables.where((c) {
      final query = searchNif.toUpperCase();
      return c.nif.toUpperCase().contains(query) ||
          c.taxPayerNo.toUpperCase().contains(query);
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF4F7F9),
      appBar: AppBar(
        title: const Text(
          'Liste des Contribuables',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF4C6C89),
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: Column(
        children: [
          // 🔎 Barre de recherche (Hatsarana ny Ergonomie)
          _buildSearchBar(),

          // 🧾 Liste des contribuables
          Expanded(
            child: isLoading
                ? const Center(
                    child: CircularProgressIndicator(color: Color(0xFF4C6C89)),
                  )
                : _buildList(filtered),
          ),
        ],
      ),
    );
  }

  // --- UI COMPONENTS ---

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      color: const Color(0xFF4C6C89),
      child: TextField(
        onChanged: (value) => setState(() => searchNif = value),
        style: const TextStyle(color: Colors.black87),
        decoration: InputDecoration(
          hintText: 'Rechercher par NIF ou Nom...',
          hintStyle: TextStyle(color: Colors.grey.shade600),
          filled: true,
          fillColor: Colors.white,
          prefixIcon: const Icon(Icons.search, color: Color(0xFF4C6C89)),
          contentPadding: const EdgeInsets.symmetric(vertical: 0),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget _buildList(List<Contribuable1> list) {
    if (list.isEmpty) {
      return const Center(child: Text("Aucun contribuable trouvé"));
    }
    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: list.length,
      itemBuilder: (context, index) {
        final c = list[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: InkWell(
            // Fampitomboana ny zone de clic ho an'ny ergonomie
            borderRadius: BorderRadius.circular(16),
            onTap: () => _navigateToDetails(c),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          c.rs.toUpperCase(),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Color(0xFF2C3E50),
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      _buildStatusBadge(c.actif),
                    ],
                  ),
                  const Divider(height: 20),
                  _buildIconInfo(Icons.fingerprint, "NIF: ${c.taxPayerNo}"),
                  _buildIconInfo(Icons.business, "Centre: ${c.centre}"),
                  _buildIconInfo(
                    Icons.location_on_outlined,
                    "Adresse: ${c.adresse}",
                  ),
                  _buildIconInfo(Icons.work_outline, "Activité: ${c.activite}"),
                  const SizedBox(height: 10),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton.icon(
                      onPressed: () => _navigateToDetails(c),
                      icon: const Icon(Icons.arrow_forward_ios, size: 14),
                      label: const Text("Détails"),
                      style: TextButton.styleFrom(
                        foregroundColor: const Color(0xFF4C6C89),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildIconInfo(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.grey.shade600),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(color: Colors.grey.shade800, fontSize: 13),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(bool isActive) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: isActive
            ? Colors.green.withOpacity(0.1)
            : Colors.red.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isActive ? Colors.green : Colors.red,
          width: 0.5,
        ),
      ),
      child: Text(
        isActive ? "ACTIF" : "INACTIF",
        style: TextStyle(
          color: isActive ? Colors.green.shade700 : Colors.red.shade700,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  void _navigateToDetails(Contribuable1 c) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => FicheContribuableScreen1(taxPayerNo: c.nif),
      ),
    );
  }
}
