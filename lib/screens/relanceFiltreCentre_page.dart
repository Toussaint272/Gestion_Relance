import 'dart:convert';
import 'package:flutter/material.dart';
import '../services/relance_service.dart';

class RelancesEffectueesCentres extends StatefulWidget {
  const RelancesEffectueesCentres({super.key});

  @override
  State<RelancesEffectueesCentres> createState() => _RelancesEffectuees1State();
}

class _RelancesEffectuees1State extends State<RelancesEffectueesCentres> {
  List<dynamic> relances = [];
  List<String> centres = [];
  bool isLoading = true;
  String errorMessage = '';
  String selectedCentre = ""; // centre voafidy

  @override
  void initState() {
    super.initState();
    loadCentres();
  }

  Future<void> loadCentres() async {
    try {
      final data = await RelanceService.getCentres();

      setState(() {
        centres = data;
        if (centres.isNotEmpty) {
          selectedCentre = centres[0]; // misafidy centre par défaut
          fetchRelances(selectedCentre);
        }
      });
    } catch (e) {
      setState(() {
        errorMessage = "Impossible de charger les centres fiscaux: $e";
        isLoading = false;
      });
    }
  }

  Future<void> fetchRelances(String centre) async {
    setState(() {
      isLoading = true;
      errorMessage = "";
    });

    try {
      final data = await RelanceService.getRelanceByCentre(centre);

      setState(() {
        relances = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = "Erreur lors du chargement: $e";
        isLoading = false;
      });
    }
  }

  Widget buildRelanceCard(dynamic relance) {
    final taxPayerNo = relance['tax_payer_no'] ?? 'Inconnu';
    final matricule = relance['matricule'] ?? 'N/A';
    final mode = relance['mode'] ?? 'Non spécifié';
    final status = relance['status'] ?? 'N/A';
    final message = relance['message'] ?? 'Aucun message';
    final dateRelance = relance['date_relance'] ?? relance['createdAt'];
    final dateFormatted = dateRelance != null
        ? DateTime.tryParse(dateRelance)?.toLocal().toString().split('.')[0]
        : 'Date inconnue';

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.notifications_active,
                  color: Colors.blueAccent,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    message,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
            const Divider(),
            Text(
              '🧾 Contribuable : $taxPayerNo',
              style: const TextStyle(fontSize: 14),
            ),
            Text(
              '👤 IM_Agent : $matricule',
              style: const TextStyle(fontSize: 14),
            ),
            Text('💳 Mode : $mode', style: const TextStyle(fontSize: 14)),
            Text(
              '📌 Statut : $status',
              style: TextStyle(
                fontSize: 14,
                color: status.toLowerCase() == 'effectuée'
                    ? Colors.green
                    : Colors.blueAccent,
              ),
            ),
            const SizedBox(height: 6),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                '🕒 Envoyée le : $dateFormatted',
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                  fontStyle: FontStyle.italic,
                ),
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
      appBar: AppBar(
        title: const Text(
          'Relances par centre fiscal',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF4C6C89),
        iconTheme: const IconThemeData(color: Colors.white),
      ),

      body: Column(
        children: [
          // 🔵 Dropdown Centre Fiscal
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: "Choisissez un centre fiscal",
                border: OutlineInputBorder(),
              ),
              value: selectedCentre.isNotEmpty ? selectedCentre : null,
              items: centres.map((centre) {
                return DropdownMenuItem(value: centre, child: Text(centre));
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  selectedCentre = value;
                  fetchRelances(value);
                }
              },
            ),
          ),

          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : errorMessage.isNotEmpty
                ? Center(
                    child: Text(
                      errorMessage,
                      style: const TextStyle(color: Colors.red),
                    ),
                  )
                : relances.isEmpty
                ? const Center(child: Text("Aucune relance trouvée."))
                : RefreshIndicator(
                    onRefresh: () => fetchRelances(selectedCentre),
                    child: ListView.builder(
                      itemCount: relances.length,
                      itemBuilder: (context, index) {
                        return buildRelanceCard(relances[index]);
                      },
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
