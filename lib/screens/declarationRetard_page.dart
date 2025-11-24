import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class DeclarationsRetardPage extends StatefulWidget {
  const DeclarationsRetardPage({super.key});

  @override
  State<DeclarationsRetardPage> createState() => _DeclarationsRetardPageState();
}

class _DeclarationsRetardPageState extends State<DeclarationsRetardPage> {
  final String apiUrl =
      "http://10.0.2.2:5000/api/declarationRetardRoute/en-retard"; // Changez selon votre backend
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
        setState(() => errorMessage = "Erreur: ${res.statusCode}");
      }
    } catch (e) {
      setState(() => errorMessage = "Erreur: $e");
    } finally {
      setState(() => isLoading = false);
    }
  }

  Widget buildDeclarationCard(Map d) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
      elevation: 3,
      child: ListTile(
        title: Text("Contribuable: ${d['tax_payer_no']}"),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Déclaration N°${d['N_decl']}"),
            Text("Motif: ${d['motif']}"),
            Text(
              "Période: ${d['tax_periode'] != null ? d['tax_periode'].substring(0, 10) : '-'}",
            ),
            Text(
              "Date échéance: ${d['date_echeance'] != null ? DateTime.parse(d['date_echeance']).toLocal().toString().substring(0, 10) : '-'}",
            ),

            Text(
              "Date reçue: ${d['received_date'] != null ? DateTime.parse(d['received_date']).toLocal().toString().substring(0, 10) : '-'}",
            ),

            Text(
              'Montant du : ${NumberFormat('#,###').format(double.tryParse(d['montant_liquide'].toString()) ?? 0)} Ar',
            ),
            Text(
              'Statut: ${d['statut'] ?? "-"}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.green, // safidio couleur mety
              ),
            ),
          ],
        ),
        isThreeLine: true,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Déclarations En Retard",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF4C6C89),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage.isNotEmpty
          ? Center(child: Text(errorMessage))
          : declarations.isEmpty
          ? const Center(child: Text("Aucune déclaration en retard"))
          : RefreshIndicator(
              onRefresh: fetchDeclarations,
              child: ListView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: declarations.length,
                itemBuilder: (context, index) {
                  return buildDeclarationCard(declarations[index]);
                },
              ),
            ),
    );
  }
}
