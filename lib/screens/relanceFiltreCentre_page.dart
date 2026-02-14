/*import 'dart:convert';
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
                  color: Colors.orangeAccent,
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
                    ? Colors.blueAccent
                    : Colors.green,
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
}*/
import 'dart:convert';
import 'package:flutter/material.dart';
import '../services/relance_service.dart';

class RelancesEffectueesCentres extends StatefulWidget {
  const RelancesEffectueesCentres({super.key});

  @override
  State<RelancesEffectueesCentres> createState() => _RelancesEffectuees1State();
}

class _RelancesEffectuees1State extends State<RelancesEffectueesCentres> {
  // --- Tsy novana mihitsy ireto ---
  List<dynamic> relances = [];
  List<String> centres = [];
  bool isLoading = true;
  String errorMessage = '';
  String selectedCentre = "";

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
          selectedCentre = centres[0];
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

  // --- Fanatsarana ny interface (Card) ---
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
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2, // Nahena kely ny aloka ho an'ny IHM moderna
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.notifications_active,
                  color: Colors.orangeAccent,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    message,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Color(0xFF2C3E50),
                    ),
                  ),
                ),
              ],
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Divider(height: 1),
            ),
            // Fandaharana responsive
            _buildDetailRow(
              Icons.business_center_outlined,
              'Contribuable',
              taxPayerNo,
            ),
            _buildDetailRow(Icons.badge_outlined, 'IM_Agent', matricule),
            _buildDetailRow(Icons.send_outlined, 'Mode', mode),

            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildStatusChip(status),
                Text(
                  '🕒 $dateFormatted',
                  style: const TextStyle(
                    fontSize: 11,
                    color: Colors.grey,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // --- Widget fanampiny ho an'ny sary madio ---
  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.blueGrey),
          const SizedBox(width: 8),
          Text(
            "$label : ",
            style: const TextStyle(fontSize: 13, color: Colors.black54),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    bool isEffectuee = status.toLowerCase() == 'effectuée';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: isEffectuee
            ? Colors.blue.withOpacity(0.1)
            : Colors.green.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isEffectuee ? Colors.blue : Colors.green,
          width: 0.5,
        ),
      ),
      child: Text(
        status,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: isEffectuee ? Colors.blueAccent : Colors.green,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7F9), // Loko fond maivana kokoa
      appBar: AppBar(
        title: const Text(
          'Relances par centre fiscal',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF4C6C89),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Filter Section
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: "Choisissez un centre fiscal",
                prefixIcon: const Icon(
                  Icons.location_on,
                  color: Color(0xFF4C6C89),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12),
              ),
              value: selectedCentre.isNotEmpty ? selectedCentre : null,
              items: centres
                  .map(
                    (centre) =>
                        DropdownMenuItem(value: centre, child: Text(centre)),
                  )
                  .toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() => selectedCentre = value);
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
                      padding: const EdgeInsets.only(top: 8, bottom: 20),
                      itemCount: relances.length,
                      itemBuilder: (context, index) =>
                          buildRelanceCard(relances[index]),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
