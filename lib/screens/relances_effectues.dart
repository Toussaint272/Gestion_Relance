/*import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../config/api_endpoints.dart';

class RelancesEffectuees1 extends StatefulWidget {
  const RelancesEffectuees1({super.key});

  @override
  State<RelancesEffectuees1> createState() => _RelancesEffectueesState();
}

class _RelancesEffectueesState extends State<RelancesEffectuees1> {
  List<dynamic> relances = [];
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    fetchRelances();
  }

  Future<void> fetchRelances() async {
    try {
      final response = await http.get(
        /*Uri.parse('http://10.155.28.240:5000/api/relanceRoute/effectuees'),*/
        Uri.parse(ApiEndpoints.relanceEffectuees),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          relances = data is List ? data : [];
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = 'Erreur serveur (${response.statusCode})';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Erreur de connexion : $e';
        isLoading = false;
      });
    }
  }

  // 📧 CARD EMAIL STYLE
  Widget buildRelanceCard(dynamic relance) {
    final taxPayerNo = relance['tax_payer_no'] ?? 'Inconnu';
    final matricule = relance['matricule'] ?? 'N/A';
    final mode = relance['mode'] ?? 'Non spécifié';
    final status = relance['status'] ?? 'N/A';
    final message = relance['message'] ?? 'Aucun message';
    final dateRelance = relance['date_relance'] ?? relance['createdAt'];

    final dateFormatted = dateRelance != null
        ? DateTime.tryParse(dateRelance)?.toLocal().toString().split('.')[0] ??
              'Date inconnue'
        : 'Date inconnue';

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ExpansionTile(
        leading: const Icon(Icons.email_outlined, color: Color(0xFF4C6C89)),
        title: Text(
          'Contribuable: $taxPayerNo',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),

        subtitle: Text(dateFormatted, style: const TextStyle(fontSize: 12)),
        childrenPadding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
        children: [
          // 📩 MESSAGE COMPLET
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFF3F6F9),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(message, style: const TextStyle(fontSize: 14)),
          ),

          const SizedBox(height: 10),
          const Divider(),

          _detailRow('IM Agent', matricule),
          _detailRow('Mode', mode),
          _detailRow(
            'Statut',
            status,
            valueColor: status.toLowerCase() == 'effectuée'
                ? Colors.redAccent
                : Colors.green,
          ),
        ],
      ),
    );
  }

  // 🔹 LIGNE DETAIL
  Widget _detailRow(
    String label,
    String value, {
    Color valueColor = Colors.black87,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label : ',
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              color: Colors.grey,
            ),
          ),
          Expanded(
            child: Text(value, style: TextStyle(color: valueColor)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Total des relances',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF4C6C89),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage.isNotEmpty
          ? Center(
              child: Text(
                errorMessage,
                style: const TextStyle(color: Colors.red),
              ),
            )
          : relances.isEmpty
          ? const Center(child: Text('Aucune relance effectuée.'))
          : RefreshIndicator(
              onRefresh: fetchRelances,
              child: ListView.builder(
                itemCount: relances.length,
                itemBuilder: (context, index) {
                  return buildRelanceCard(relances[index]);
                },
              ),
            ),
    );
  }
}*/
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../config/api_endpoints.dart';

class RelancesEffectuees1 extends StatefulWidget {
  const RelancesEffectuees1({super.key});

  @override
  State<RelancesEffectuees1> createState() => _RelancesEffectueesState();
}

class _RelancesEffectueesState extends State<RelancesEffectuees1> {
  List<dynamic> relances = [];
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    fetchRelances();
  }

  Future<void> fetchRelances() async {
    try {
      final response = await http.get(
        Uri.parse(ApiEndpoints.relanceEffectuees),
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          relances = data is List ? data : [];
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = 'Erreur serveur (${response.statusCode})';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Erreur de connexion : $e';
        isLoading = false;
      });
    }
  }

  // 📧 CARD EMAIL STYLE (Mitazona ny formanao fa voadio)
  Widget buildRelanceCard(dynamic relance) {
    final taxPayerNo = relance['tax_payer_no'] ?? 'Inconnu';
    final matricule = relance['matricule'] ?? 'N/A';
    final mode = relance['mode'] ?? 'Non spécifié';
    final status = (relance['status'] ?? 'N/A').toString();
    final message = relance['message'] ?? 'Aucun message';
    final dateRelance = relance['date_relance'] ?? relance['createdAt'];

    final dateFormatted = dateRelance != null
        ? DateTime.tryParse(dateRelance)?.toLocal().toString().split('.')[0] ??
              'Date inconnue'
        : 'Date inconnue';

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      elevation: 2,
      shadowColor: Colors.black26,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Theme(
        // Manala ilay tsipika border par défaut an'ny ExpansionTile
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          leading: CircleAvatar(
            backgroundColor: const Color(0xFF4C6C89).withOpacity(0.1),
            child: const Icon(
              Icons.email_outlined,
              color: Color(0xFF4C6C89),
              size: 20,
            ),
          ),
          title: Text(
            'Contribuable: $taxPayerNo',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
              color: Color(0xFF2C3E50),
            ),
          ),
          subtitle: Text(
            '🕒 $dateFormatted',
            style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
          ),
          childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          children: [
            const Divider(height: 1, thickness: 0.5),
            const SizedBox(height: 12),

            // 📩 MESSAGE COMPLET
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFFF8F9FA),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Text(
                message,
                style: const TextStyle(
                  fontSize: 14,
                  height: 1.4,
                  color: Colors.black,
                ),
              ),
            ),

            const SizedBox(height: 12),

            // INFO ROWS
            _detailRow('IM Agent', matricule, Icons.badge_outlined),
            _detailRow('Mode', mode, Icons.send_outlined),
            _detailRow(
              'Statut',
              status,
              Icons.info_outline,
              valueColor: status.toLowerCase() == 'effectuée'
                  ? Colors.blueAccent
                  : Colors.green,
            ),
          ],
        ),
      ),
    );
  }

  // 🔹 LIGNE DETAIL (Nampiana Icon kely mba ho ergonomic)
  Widget _detailRow(
    String label,
    String value,
    IconData icon, {
    Color valueColor = Colors.black87,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Icon(icon, size: 14, color: Colors.grey),
          const SizedBox(width: 8),
          Text(
            '$label : ',
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              color: Colors.grey,
              fontSize: 13,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: valueColor,
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7F9),
      appBar: AppBar(
        title: const Text(
          'Total des relances',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF4C6C89),
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
        elevation: 0,
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xFF4C6C89)),
            )
          : errorMessage.isNotEmpty
          ? Center(
              child: Text(
                errorMessage,
                style: const TextStyle(color: Colors.red),
              ),
            )
          : relances.isEmpty
          ? const Center(child: Text('Aucune relance effectuée.'))
          : RefreshIndicator(
              onRefresh: fetchRelances,
              color: const Color(0xFF4C6C89),
              child: ListView.builder(
                padding: const EdgeInsets.only(top: 8),
                itemCount: relances.length,
                itemBuilder: (context, index) =>
                    buildRelanceCard(relances[index]),
              ),
            ),
    );
  }
}
