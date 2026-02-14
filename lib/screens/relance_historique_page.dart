import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../config/api_endpoints.dart';

class RelanceHistoriquePage extends StatefulWidget {
  const RelanceHistoriquePage({Key? key}) : super(key: key);

  @override
  State<RelanceHistoriquePage> createState() => _RelanceHistoriquePageState();
}

class _RelanceHistoriquePageState extends State<RelanceHistoriquePage> {
  List<dynamic> relances = [];
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    fetchRelances();
  }

  Future<String> _getAgentMatricule() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('agentMatricule') ?? '';
  }

  Future<void> fetchRelances() async {
    setState(() => isLoading = true);
    try {
      final matricule = await _getAgentMatricule();
      if (matricule.isEmpty) {
        setState(() {
          errorMessage = "Erreur : Agent non connecté.";
          isLoading = false;
        });
        return;
      }

      final response = await http.get(
        Uri.parse(ApiEndpoints.relanceHistorique(matricule)),
      );

      if (response.statusCode == 200) {
        setState(() {
          relances = json.decode(response.body);
          isLoading = false;
          errorMessage = '';
        });
      } else {
        setState(() {
          errorMessage = 'Erreur serveur : ${response.statusCode}';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Erreur de connexion au serveur';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F7F9),
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Historique des Relances',
          style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1),
        ),
        backgroundColor: const Color(0xFF4C6C89),
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: fetchRelances),
        ],
      ),
      body: Column(
        children: [
          _buildHeaderSummary(),
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : errorMessage.isNotEmpty
                ? _buildErrorWidget()
                : relances.isEmpty
                ? _buildEmptyWidget()
                : RefreshIndicator(
                    onRefresh: fetchRelances,
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      itemCount: relances.length,
                      itemBuilder: (context, index) {
                        // Mba ho responsive amin'ny ecran lehibe
                        return Center(
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 600),
                            child: _buildRelanceCard(relances[index]),
                          ),
                        );
                      },
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  // 🔹 FAMINTINANA EO AMBONY (Dashboard style)
  Widget _buildHeaderSummary() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Color(0xFF4C6C89),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: Column(
        children: [
          const Icon(Icons.history_toggle_off, color: Colors.white70, size: 40),
          const SizedBox(height: 10),
          Text(
            '${relances.length} relances enregistrées',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRelanceCard(dynamic relance) {
    final taxPayerNo = relance['tax_payer_no'] ?? 'Inconnu';
    final matricule = relance['matricule'] ?? 'N/A';
    final mode = relance['mode'] ?? 'SMS/Email';
    final status = relance['status'] ?? 'Envoyé';
    final message = relance['message'] ?? 'Aucun message';
    final dateRelance = relance['date_envoi'] ?? relance['createdAt'];

    final parsedDate = DateTime.tryParse(dateRelance ?? '');
    final dateFormatted = parsedDate != null
        ? DateFormat(
            'yyyy MMM dd à HH:mm:ss',
          ).format(parsedDate.add(const Duration(hours: 1)))
        : 'Date inconnue';

    bool isDone = status.toString().toLowerCase() == 'effectuée';

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 3,
      shadowColor: Colors.black12,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: ExpansionTile(
          backgroundColor: Colors.white,
          collapsedBackgroundColor: Colors.white,
          leading: CircleAvatar(
            backgroundColor: isDone
                ? const Color(0xFFE8F5E9)
                : const Color(0xFFFFF3E0),
            child: Icon(
              mode.toString().toLowerCase().contains('email')
                  ? Icons.alternate_email
                  : Icons.textsms_outlined,
              color: isDone ? Colors.green : Colors.orange,
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
            dateFormatted,
            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
          ),
          childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          children: [
            const Divider(),
            const SizedBox(height: 8),
            _buildInfoRow(Icons.person_outline, 'Agent (IM)', matricule),
            _buildInfoRow(Icons.send_outlined, 'Mode d\'envoi', mode),
            _buildInfoRow(
              Icons.check_circle_outline,
              'Statut',
              status.toUpperCase(),
              color: isDone ? Colors.green : Colors.orange,
            ),
            const SizedBox(height: 12),
            const Text(
              "Message envoyé :",
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 6),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFF8F9FA),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.black12),
              ),
              child: Text(
                message,
                style: const TextStyle(
                  fontSize: 13,
                  height: 1.4,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(
    IconData icon,
    String label,
    String value, {
    Color? color,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.grey[600]),
          const SizedBox(width: 8),
          Text(
            '$label : ',
            style: const TextStyle(color: Colors.grey, fontSize: 13),
          ),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 13,
              color: color ?? const Color(0xFF2C3E50),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, color: Colors.redAccent, size: 60),
          const SizedBox(height: 16),
          Text(
            errorMessage,
            style: const TextStyle(
              color: Colors.redAccent,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: fetchRelances,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4C6C89),
            ),
            child: const Text("Réessayer"),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.inbox_outlined, color: Colors.grey[300], size: 80),
          const SizedBox(height: 16),
          const Text(
            'Aucune relance effectuée',
            style: TextStyle(color: Colors.grey, fontSize: 16),
          ),
        ],
      ),
    );
  }
}
