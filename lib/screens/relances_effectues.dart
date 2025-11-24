import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

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
        Uri.parse('http://10.0.2.2:5000/api/relanceRoute/effectuees'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data is List) {
          setState(() {
            relances = data;
            isLoading = false;
          });
        } else {
          setState(() {
            errorMessage = 'Aucune relance trouvée.';
            isLoading = false;
          });
        }
      } else {
        setState(() {
          errorMessage =
              'Erreur serveur (${response.statusCode}): ${response.reasonPhrase}';
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
                    ? Colors.green
                    : Colors.redAccent,
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
          'Relances effectuées',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF395067),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage.isNotEmpty
          ? Center(
              child: Text(
                errorMessage,
                style: const TextStyle(color: Colors.red),
                textAlign: TextAlign.center,
              ),
            )
          : relances.isEmpty
          ? const Center(child: Text('Aucune relance effectuée.'))
          : RefreshIndicator(
              onRefresh: fetchRelances,
              child: ListView.builder(
                itemCount: relances.length,
                itemBuilder: (context, index) {
                  final relance = relances[index];
                  return buildRelanceCard(relance);
                },
              ),
            ),
    );
  }
}
