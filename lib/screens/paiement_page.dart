/*import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/paiement.dart';
import '../services/paiement_service1.dart';
import '../services/paiement_relance.dart';

class PaiementsPage extends StatefulWidget {
  final String taxPayerNo;
  final String contribuableName;
   final String agentMatricule; // 👈 agent connecté

  const PaiementsPage({
    Key? key,
    required this.taxPayerNo,
    required this.contribuableName,
    required this.agentMatricule,
  }) : super(key: key);

  @override
  State<PaiementsPage> createState() => _PaiementsPageState();
}

class _PaiementsPageState extends State<PaiementsPage> {
  late Future<List<Paiement1>> paiements;

  @override
  void initState() {
    super.initState();
    paiements = PaiementService.fetchPaiementsByContribuable(widget.taxPayerNo);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Paiements - ${widget.contribuableName}"),
        backgroundColor: Colors.blueAccent,
      ),
      body: FutureBuilder<List<Paiement1>>(
        future: paiements,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Erreur : ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("Aucun paiement trouvé."));
          }

          final data = snapshot.data!;

          return ListView.builder(
            padding: const EdgeInsets.all(10),
            itemCount: data.length,
            itemBuilder: (context, index) {
              final p = data[index];
              final dateFormat = DateFormat('dd/MM/yyyy');

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
                      p.nDecl.toString(),
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  title: Text(
                    "Déclaration : ${p.taxPayerNo}",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Montant payé : ${p.montantPayer} Ar"),
                      Text(
                        "Reste à recouvrer : ${p.resteARecouvrer} Ar",
                        style: TextStyle(
                          color: p.resteARecouvrer == 0
                              ? Colors.green
                              : Colors.red,
                        ),
                      ),
                      Text("Mode : ${p.modePaiement}"),
                      Text(
                        "Date : ${dateFormat.format(p.datePaiement.toLocal())}",
                      ),
                      Text("Statut : ${p.valider ? 'Validé ✅' : 'Aucun ❌'}"),
                      const SizedBox(height: 5),
                      // ✅ Bouton envoyer relance
                      if (!p.valider || p.resteARecouvrer > 0)
                        ElevatedButton.icon(
                          onPressed: () async {
                            try {
                              final response = await PaiementService1.sendRelance(
                                taxPayerNo: p.taxPayerNo,
                                NDecl: p.nDecl,
                                agentMatricule:  // ✅ ajout ici
                                //message:
                                //"Votre paiement est en retard, merci de régulariser.",
                              );
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    "Relance envoyée avec succès !",
                                  ),
                                ),
                              );
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    "Erreur en envoyant la relance : $e",
                                  ),
                                ),
                              );
                            }
                          },
                          icon: const Icon(Icons.email),
                          label: const Text("Envoyer Relance"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                          ),
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
}*/
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/paiement.dart';
import '../services/paiement_service1.dart';
import '../services/paiement_relance.dart';

class PaiementsPage extends StatefulWidget {
  final String taxPayerNo;
  final String contribuableName;
  final String agentMatricule; // 👈 voatery ampidirina

  const PaiementsPage({
    Key? key,
    required this.taxPayerNo,
    required this.contribuableName,
    required this.agentMatricule,
  }) : super(key: key);

  @override
  State<PaiementsPage> createState() => _PaiementsPageState();
}

class _PaiementsPageState extends State<PaiementsPage> {
  late Future<List<Paiement1>> paiements;

  @override
  void initState() {
    super.initState();
    paiements = PaiementService.fetchPaiementsByContribuable(widget.taxPayerNo);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Paiements - ${widget.contribuableName}"),
        backgroundColor: Colors.blueAccent,
      ),
      body: FutureBuilder<List<Paiement1>>(
        future: paiements,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Erreur : ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("Aucun paiement trouvé."));
          }

          final data = snapshot.data!;

          return ListView.builder(
            padding: const EdgeInsets.all(10),
            itemCount: data.length,
            itemBuilder: (context, index) {
              final p = data[index];
              final dateFormat = DateFormat('dd/MM/yyyy');

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
                      p.nDecl.toString(),
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  title: Text(
                    "NIF : ${p.taxPayerNo}",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Montant payé : ${p.montantPayer} Ar"),
                      Text(
                        "Reste à recouvrer : ${p.resteARecouvrer} Ar",
                        style: TextStyle(
                          color: p.resteARecouvrer == 0
                              ? Colors.green
                              : Colors.red,
                        ),
                      ),
                      Text("Mode : ${p.modePaiement}"),
                      Text(
                        "Date : ${dateFormat.format(p.datePaiement.toLocal())}",
                      ),
                      Text("Statut : ${p.valider ? 'Validé ✅' : 'Aucun ❌'}"),
                      const SizedBox(height: 5),

                      // 🔹 Bouton relance si nécessaire
                      if (!p.valider || p.resteARecouvrer > 0)
                        ElevatedButton.icon(
                          onPressed: () async {
                            try {
                              if (widget.agentMatricule.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      "Erreur : Agent non connecté",
                                    ),
                                  ),
                                );
                                return;
                              }

                              // 🔹 Envoi relance avec agentMatricule
                              await PaiementService1.sendRelance(
                                taxPayerNo: p.taxPayerNo,
                                NDecl: p.nDecl,
                                agentMatricule: widget.agentMatricule,
                              );

                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Relance envoyée ✅"),
                                ),
                              );
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    "Erreur en envoyant la relance : $e",
                                  ),
                                ),
                              );
                            }
                          },
                          icon: const Icon(Icons.email),
                          label: const Text("Envoyer Relance"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blueAccent,
                          ),
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

/*import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_app/services/paiement_relance.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/paiement.dart';
import '../services/paiement_service1.dart';
import '../services/auth_service.dart'; // ✅ Import AuthService

class PaiementsPage extends StatefulWidget {
  final String taxPayerNo;
  final String contribuableName;

  const PaiementsPage({
    Key? key,
    required this.taxPayerNo,
    required this.contribuableName,
  }) : super(key: key);

  @override
  State<PaiementsPage> createState() => _PaiementsPageState();
}

class _PaiementsPageState extends State<PaiementsPage> {
  late Future<List<Paiement1>> paiements;
  final AuthService authService = AuthService(); // ✅ Instance AuthService

  @override
  void initState() {
    super.initState();
    paiements = PaiementService.fetchPaiementsByContribuable(widget.taxPayerNo);
  }

  Future<int?> _getAgentId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('agentId');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Paiements - ${widget.contribuableName}"),
        backgroundColor: Colors.blueAccent,
      ),
      body: FutureBuilder<List<Paiement1>>(
        future: paiements,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Erreur : ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("Aucun paiement trouvé."));
          }

          final data = snapshot.data!;

          return ListView.builder(
            padding: const EdgeInsets.all(10),
            itemCount: data.length,
            itemBuilder: (context, index) {
              final p = data[index];
              final dateFormat = DateFormat('dd/MM/yyyy');

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
                      p.nDecl.toString(),
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  title: Text(
                    "Déclaration : ${p.taxPayerNo}",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Montant payé : ${p.montantPayer} Ar"),
                      Text(
                        "Reste à recouvrer : ${p.resteARecouvrer} Ar",
                        style: TextStyle(
                          color: p.resteARecouvrer == 0
                              ? Colors.green
                              : Colors.red,
                        ),
                      ),
                      Text("Mode : ${p.modePaiement}"),
                      Text(
                        "Date : ${dateFormat.format(p.datePaiement.toLocal())}",
                      ),
                      Text("Statut : ${p.valider ? 'Validé ✅' : 'Aucun ❌'}"),
                      const SizedBox(height: 5),

                      // ✅ Bouton envoyer relance
                      if (!p.valider || p.resteARecouvrer > 0)
                        ElevatedButton.icon(
                          onPressed: () async {
                            try {
                              final agentId = await _getAgentId();

                              if (agentId == null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      "Erreur : ID agent introuvable. Veuillez vous reconnecter.",
                                    ),
                                  ),
                                );
                                return;
                              }

                              // ✅ Envoi relance avec ID agent
                              final response =
                                  await PaiementService1.sendRelance(
                                    taxPayerNo: p.taxPayerNo,
                                    NDecl: p.nDecl,
                                    idAgent: agentId,
                                  );

                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    "Relance envoyée avec succès ✅",
                                  ),
                                ),
                              );
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    "Erreur en envoyant la relance : $e",
                                  ),
                                ),
                              );
                            }
                          },
                          icon: const Icon(Icons.email),
                          label: const Text("Envoyer Relance"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orangeAccent,
                          ),
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
}*/
