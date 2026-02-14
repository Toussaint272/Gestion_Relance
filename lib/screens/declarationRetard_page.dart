import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import '../config/api_endpoints.dart';

class DeclarationsRetardPage extends StatefulWidget {
  const DeclarationsRetardPage({super.key});

  @override
  State<DeclarationsRetardPage> createState() => _DeclarationsRetardPageState();
}

class _DeclarationsRetardPageState extends State<DeclarationsRetardPage> {
  final String apiUrl = ApiEndpoints.declarationRetard;
  bool isLoading = true;
  String errorMessage = "";
  List declarations = [];

  @override
  void initState() {
    super.initState();
    fetchDeclarations();
  }

  Future<void> fetchDeclarations() async {
    setState(() {
      isLoading = true;
      errorMessage = "";
    });
    try {
      final res = await http.get(Uri.parse(apiUrl));
      if (res.statusCode == 200) {
        final List data = jsonDecode(res.body);
        setState(() => declarations = data);
      } else {
        setState(() => errorMessage = "Erreur de serveur: ${res.statusCode}");
      }
    } catch (e) {
      setState(() => errorMessage = "Erreur de connexion: $e");
    } finally {
      setState(() => isLoading = false);
    }
  }

  // Fampisehoana ny daty amin'ny fomba madio
  String formatDate(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return "-";
    try {
      final DateTime date = DateTime.parse(dateStr).toLocal();
      return DateFormat('yyyy-MM-dd').format(date);
    } catch (e) {
      return dateStr.substring(0, 10);
    }
  }

  Widget buildDeclarationCard(Map d) {
    final double montant =
        double.tryParse(d['montant_liquide'].toString()) ?? 0;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header: NIF sy Statut
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.business,
                      color: Color(0xFF4C6C89),
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      "NIF: ${d['tax_payer_no']}",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                _buildStatusBadge(d['statut'] ?? "Inconnu"),
              ],
            ),
            const Divider(height: 24),

            // Details
            _buildInfoRow(
              Icons.description_outlined,
              "N° Décl",
              d['N_decl'].toString(),
            ),
            _buildInfoRow(
              Icons.warning_amber_rounded,
              "Motif",
              d['motif'],
              iconColor: Colors.orange,
            ),
            _buildInfoRow(
              Icons.calendar_month_outlined,
              "Période",
              d['tax_periode']?.substring(0, 10) ?? '---',
            ),

            const SizedBox(height: 8),

            // Daty andalana roa
            Row(
              children: [
                Expanded(
                  child: _buildDateChip(
                    "Échéance",
                    formatDate(d['date_echeance']),
                    Colors.red.shade100,
                    Colors.red.shade900,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildDateChip(
                    "Reçue",
                    formatDate(d['received_date']),
                    Colors.blue.shade100,
                    Colors.blue.shade900,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Montant
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
              decoration: BoxDecoration(
                color: const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Montant dû:",
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  Text(
                    '${NumberFormat('#,##0', 'fr_FR').format(montant)} Ar',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                      color: Color(0xFF4C6C89),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text(
          "Déclarations En Retard",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF4C6C89),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage.isNotEmpty
          ? _buildErrorWidget()
          : declarations.isEmpty
          ? const Center(child: Text("Aucune déclaration en retard"))
          : RefreshIndicator(
              onRefresh: fetchDeclarations,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  // Responsive: 2 columns raha tablette, 1 column raha phone
                  if (constraints.maxWidth > 600) {
                    return GridView.builder(
                      padding: const EdgeInsets.all(12),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 12,
                            mainAxisExtent: 340, // Haavon'ny card
                          ),
                      itemCount: declarations.length,
                      itemBuilder: (context, index) =>
                          buildDeclarationCard(declarations[index]),
                    );
                  } else {
                    return ListView.builder(
                      padding: const EdgeInsets.all(12),
                      itemCount: declarations.length,
                      itemBuilder: (context, index) =>
                          buildDeclarationCard(declarations[index]),
                    );
                  }
                },
              ),
            ),
    );
  }

  // --- Widgets fanampiny ---

  Widget _buildInfoRow(
    IconData icon,
    String label,
    String value, {
    Color? iconColor,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          Icon(icon, size: 16, color: iconColor ?? Colors.grey[600]),
          const SizedBox(width: 8),
          Text(
            "$label: ",
            style: const TextStyle(color: Colors.grey, fontSize: 13),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateChip(
    String label,
    String date,
    Color bgColor,
    Color textColor,
  ) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              color: textColor.withOpacity(0.7),
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            date,
            style: TextStyle(
              fontSize: 12,
              color: textColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.green.shade200),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: Colors.green.shade800,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildErrorWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 60, color: Colors.red),
          const SizedBox(height: 16),
          Text(errorMessage),
          ElevatedButton(
            onPressed: fetchDeclarations,
            child: const Text("Réessayer"),
          ),
        ],
      ),
    );
  }
}
