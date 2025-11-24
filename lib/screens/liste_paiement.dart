import 'package:flutter/material.dart';
import '../models/paiement.dart';
import '../services/paiement_service.dart';

class ListePaiementPage extends StatefulWidget {
  const ListePaiementPage({Key? key}) : super(key: key);

  @override
  State<ListePaiementPage> createState() => _ListePaiementPageState();
}

class _ListePaiementPageState extends State<ListePaiementPage> {
  late Future<List<Paiement1>> paiements;

  @override
  void initState() {
    super.initState();
    paiements = PaiementService.fetchPaiements();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Liste des Paiements"),
        backgroundColor: Colors.blueAccent,
      ),
      body: FutureBuilder<List<Paiement1>>(
        future: paiements,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                "Erreur : ${snapshot.error}",
                style: const TextStyle(color: Colors.red),
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("Aucun paiement trouvé."));
          }

          final data = snapshot.data!;

          return ListView.builder(
            padding: const EdgeInsets.all(10),
            itemCount: data.length,
            itemBuilder: (context, index) {
              final p = data[index];
              return Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 3,
                margin: const EdgeInsets.symmetric(vertical: 6),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.blueAccent,
                    child: Text(
                      p.idPaiement.toString(),
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  title: Text(
                    p.contribuable,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Declaration : ${p.taxPayerNo}"),
                      //Text("N_Déclaration : ${p.nDecl}"),
                      Text("Montant payé : ${p.montantPayer} Ar"),
                      Text(
                        "Reste à recouvrer : ${p.resteARecouvrer} Ar",
                        style: TextStyle(
                          color: p.resteARecouvrer == 0
                              ? Colors.green
                              : Colors.red,
                        ),
                      ),
                      Text("Mode_paiement : ${p.modePaiement}"),
                      Text(
                        "Date_paiement : ${p.datePaiement.toLocal().toIso8601String().split('T').first}",
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
