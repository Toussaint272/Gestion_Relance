import 'package:flutter/material.dart';
import '../models/declaration.dart';
import '../services/api_service.dart';
import 'package:intl/intl.dart';

class ListeDeclaration extends StatefulWidget {
  const ListeDeclaration({super.key});

  @override
  State<ListeDeclaration> createState() => _ListeDeclarationState();
}

class _ListeDeclarationState extends State<ListeDeclaration> {
  final ApiService apiService = ApiService();
  late Future<List<Declaration1>> futureDeclarations;

  @override
  void initState() {
    super.initState();
    futureDeclarations = apiService.fetchDeclarations();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Liste des Déclarations'),
        backgroundColor: Colors.blueAccent,
      ),
      body: FutureBuilder<List<Declaration1>>(
        future: futureDeclarations,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erreur : ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Aucune déclaration trouvée.'));
          } else {
            final declarations = snapshot.data!;
            return ListView.builder(
              itemCount: declarations.length,
              itemBuilder: (context, index) {
                final d = declarations[index];
                return Card(
                  margin: const EdgeInsets.all(8),
                  child: ListTile(
                    title: Text('Déclarant: ${d.taxPayerNo}'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Type: ${d.taxTypeNo ?? "-"}'),
                        Text(
                          'Période: ${d.taxPeriode?.substring(0, 10) ?? "-"}',
                        ),
                        Text(
                          'Date save: ${d.saveDate?.substring(0, 10) ?? "-"}',
                        ),
                        Text(
                          'Date reçue: ${d.receivedDate?.substring(0, 10) ?? "-"}',
                        ),
                        Text(
                          'Échéance: ${d.dateEcheance?.substring(0, 10) ?? "-"}',
                        ),
                        Text('Motif: ${d.motif ?? "-"}'),
                        Text(
                          'Montant du : ${NumberFormat('#,###').format(double.tryParse(d.montant_liquide.toString()) ?? 0)} Ar',
                        ),
                        // ✅ Affichage du statut
                        Text(
                          'Statut: ${d.statut ?? "-"}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.green, // safidio couleur mety
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
