import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import '../config/api_endpoints.dart';

// Mampiasa format tsotra mba tsy hiteraka erreur locale
final DateFormat standardFormatter = DateFormat('yyyy-MM-dd');

class AdminDeclarationsPage extends StatefulWidget {
  const AdminDeclarationsPage({super.key});

  @override
  State<AdminDeclarationsPage> createState() => _AdminDeclarationsPageState();
}

class _AdminDeclarationsPageState extends State<AdminDeclarationsPage> {
  List declarations = [];
  bool isLoading = false;

  String selectedType = 'Tous';
  DateTime? dateDebut;
  DateTime? dateFin;

  final String baseUrl = ApiEndpoints.declarationFiltre;

  Future<void> fetchDeclarations() async {
    setState(() => isLoading = true);

    final queryParams = {
      'type': selectedType,
      if (dateDebut != null)
        'dateDebut': dateDebut!.toIso8601String().split('T')[0],
      if (dateFin != null) 'dateFin': dateFin!.toIso8601String().split('T')[0],
    };

    final uri = Uri.parse(baseUrl).replace(queryParameters: queryParams);

    try {
      final res = await http.get(uri);
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        setState(() {
          declarations = data['declarations'] ?? [];
          isLoading = false;
        });
      } else {
        throw Exception('Erreur serveur: ${res.statusCode}');
      }
    } catch (e) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erreur: $e'),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  Future<void> selectDate(bool isStart) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2030),
    );

    if (picked != null) {
      setState(() {
        if (isStart) {
          dateDebut = picked;
        } else {
          dateFin = picked;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7F9),
      appBar: AppBar(
        title: const Text(
          'Déclarations par type & période',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF4C6C89),
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(
        children: [
          // --- FILTRE SECTION (RESPONSIVE) ---
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: DropdownButtonFormField<String>(
                        value: selectedType,
                        items: ['Tous', 'TVA', 'IRSA', 'IS', 'IR']
                            .map(
                              (t) => DropdownMenuItem(value: t, child: Text(t)),
                            )
                            .toList(),
                        decoration: InputDecoration(
                          labelText: 'Type d\'impôt',
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 10,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onChanged: (v) => setState(() => selectedType = v!),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      flex: 1,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF4C6C89),
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: fetchDeclarations,
                        icon: const Icon(
                          Icons.search,
                          color: Colors.white,
                          size: 20,
                        ),
                        label: const Text(
                          'Filtrer',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => selectDate(true),
                        icon: const Icon(Icons.calendar_today, size: 16),
                        label: Text(
                          dateDebut == null
                              ? 'Début'
                              : standardFormatter.format(dateDebut!),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => selectDate(false),
                        icon: const Icon(Icons.calendar_today, size: 16),
                        label: Text(
                          dateFin == null
                              ? 'Fin'
                              : standardFormatter.format(dateFin!),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // --- LIST SECTION ---
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : declarations.isEmpty
                ? const Center(child: Text('Aucune déclaration trouvée'))
                : ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: declarations.length,
                    itemBuilder: (context, index) {
                      final d = declarations[index];
                      return _buildResponsiveCard(d);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildResponsiveCard(Map d) {
    final double montant =
        double.tryParse(d['montant_liquide'].toString()) ?? 0;
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(
                    "${d['tax_type_no']} - ${d['motif'] ?? 'Aucun motif'}",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Color(0xFF4C6C89),
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                _statusBadge(d['statut'] ?? '---'),
              ],
            ),
            const Divider(height: 20),
            Row(
              children: [
                const Icon(Icons.person_outline, size: 16, color: Colors.grey),
                const SizedBox(width: 8),
                Text(
                  "NIF: ${d['tax_payer_no'] ?? '---'}",
                  style: const TextStyle(fontSize: 14),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(
                  Icons.calendar_month_outlined,
                  size: 16,
                  color: Colors.grey,
                ),
                const SizedBox(width: 8),
                Text(
                  "Période: ${d['tax_periode']?.substring(0, 10) ?? '---'}",
                  style: const TextStyle(fontSize: 14),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
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

  Widget _statusBadge(String status) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFF4C6C89).withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        status,
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: Color(0xFF4C6C89),
        ),
      ),
    );
  }
}
