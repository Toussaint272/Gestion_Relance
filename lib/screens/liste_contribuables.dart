import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:my_app/screens/listeContribuableCentreDefaillant.dart';
import 'package:shared_preferences/shared_preferences.dart';
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

class ListeContribuables extends StatefulWidget {
  final String? agentMatricule;

  const ListeContribuables({Key? key, this.agentMatricule}) : super(key: key);

  @override
  State<ListeContribuables> createState() => _ListeContribuablesState();
}

class _ListeContribuablesState extends State<ListeContribuables> {
  List<Contribuable1> contribuables = [];
  bool isLoading = true;
  String searchNif = '';

  final String baseUrl = ApiEndpoints.filtreContribuableByAgent;

  @override
  void initState() {
    super.initState();
    fetchContribuables();
  }

  // --- Logic Tsy niova ---
  Future<void> fetchContribuables() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final matricule =
          widget.agentMatricule ?? prefs.getString('agentMatricule') ?? '';

      if (matricule.isEmpty) {
        if (!mounted) return;
        setState(() => isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('⚠️ Aucun matricule agent trouvé')),
        );
        return;
      }

      final res = await http.get(Uri.parse('$baseUrl?matricule=$matricule'));

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        final List contribList = data['contribuables'] ?? [];

        if (!mounted) return;
        setState(() {
          contribuables = contribList
              .map((e) => Contribuable1.fromJson(e))
              .toList();
          isLoading = false;
        });
      } else {
        if (!mounted) return;
        setState(() => isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur serveur (${res.statusCode})')),
        );
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
      backgroundColor: const Color(
        0xFFF8FAFB,
      ), // Loko maivana ho an'ny background
      appBar: AppBar(
        title: const Text(
          'Mes Contribuables',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        backgroundColor: const Color(0xFF4C6C89),
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.warning_amber_rounded,
              color: Color(0xFFFFD1D1),
            ),
            tooltip: "Défaillants",
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => DefaillantsPageDefaillant()),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // 🔎 Search Bar (Ergonomie)
          _buildTopSearchSection(),

          // 🧾 Liste
          Expanded(
            child: isLoading
                ? const Center(
                    child: CircularProgressIndicator(color: Color(0xFF4C6C89)),
                  )
                : filtered.isEmpty
                ? _buildEmptyState()
                : _buildContribuableList(filtered),
          ),
        ],
      ),
    );
  }

  // --- UI COMPONENTS ---

  Widget _buildTopSearchSection() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 20),
      decoration: const BoxDecoration(
        color: Color(0xFF4C6C89),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(25),
          bottomRight: Radius.circular(25),
        ),
      ),
      child: TextField(
        onChanged: (value) => setState(() => searchNif = value),
        style: const TextStyle(color: Colors.black87),
        decoration: InputDecoration(
          hintText: 'Rechercher par NIF ou Nom...',
          hintStyle: TextStyle(color: Colors.grey.shade500),
          prefixIcon: const Icon(Icons.search, color: Color(0xFF4C6C89)),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(vertical: 12),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget _buildContribuableList(List<Contribuable1> list) {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
      itemCount: list.length,
      itemBuilder: (context, index) {
        final c = list[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 14),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(color: Colors.grey.shade200),
          ),
          child: InkWell(
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
                            fontSize: 15,
                            color: Color(0xFF2C3E50),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      _buildStatusBadge(c.actif),
                    ],
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Divider(height: 1, thickness: 0.5),
                  ),
                  _buildIconInfo(
                    Icons.fingerprint_rounded,
                    "NIF",
                    c.taxPayerNo,
                  ),
                  _buildIconInfo(Icons.business_rounded, "Centre", c.centre),
                  _buildIconInfo(
                    Icons.location_on_outlined,
                    "Adresse",
                    c.adresse,
                  ),
                  _buildIconInfo(
                    Icons.phone_android_rounded,
                    "Contact",
                    c.phone,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        "Voir détails",
                        style: TextStyle(
                          color: Color(0xFF4C6C89),
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 12,
                        color: Color(0xFF4C6C89),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildIconInfo(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 16, color: Colors.blueGrey.shade300),
          const SizedBox(width: 10),
          Text(
            "$label: ",
            style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: Color(0xFF34495E),
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
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
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFFE8F5E9) : const Color(0xFFFFEBEE),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        isActive ? "ACTIF" : "INACTIF",
        style: TextStyle(
          color: isActive ? const Color(0xFF2E7D32) : const Color(0xFFC62828),
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
          Icon(Icons.search_off_rounded, size: 60, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          Text(
            "Aucun contribuable trouvé",
            style: TextStyle(color: Colors.grey.shade500),
          ),
        ],
      ),
    );
  }

  void _navigateToDetails(Contribuable1 c) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => FicheContribuableScreen(taxPayerNo: c.nif),
      ),
    );
  }
}
