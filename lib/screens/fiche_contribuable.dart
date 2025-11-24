import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:my_app/screens/declaration_page.dart';
import 'package:my_app/screens/paiement_page.dart';
import '../models/fiche_contrib.dart';
import 'package:intl/intl.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:shared_preferences/shared_preferences.dart'; // ✅ ajout obligatoire

class FicheContribuableScreen extends StatefulWidget {
  final String taxPayerNo;

  const FicheContribuableScreen({super.key, required this.taxPayerNo});

  @override
  State<FicheContribuableScreen> createState() =>
      _FicheContribuableScreenState();
}

class _FicheContribuableScreenState extends State<FicheContribuableScreen> {
  late Future<Contribuable1?> contribuableFuture;

  @override
  void initState() {
    super.initState();
    contribuableFuture = fetchContribuable(widget.taxPayerNo);
  }

  // 🔹 Fetch Contribuable selon tax_payer_no
  Future<Contribuable1?> fetchContribuable(String nif) async {
    try {
      final url = 'http://10.0.2.2:5000/api/contribuableRoute/nif/$nif';
      print('🔍 URL Contribuable: $url');

      final response = await http.get(Uri.parse(url));
      print('🔍 Code: ${response.statusCode}');
      print('🔍 Body: ${response.body}');

      if (response.statusCode == 200 && response.body != 'null') {
        return Contribuable1.fromJson(jsonDecode(response.body));
      } else {
        print('❌ Aucun contribuable trouvé pour $nif');
        return null;
      }
    } catch (e) {
      print('Erreur fetchContribuable: $e');
      return null;
    }
  }

  // 🔹 Fetch Assujettissements
  Future<List<Assujettissement1>> fetchAssujettissements(
    String fiscalNo,
  ) async {
    try {
      final url = 'http://10.0.2.2:5000/api/assujettissementRoute/$fiscalNo';
      print('🔍 URL Assujettissement: $url');

      final response = await http.get(Uri.parse(url));
      print('🔍 Code: ${response.statusCode}');
      print('🔍 Body: ${response.body}');

      if (response.statusCode == 200 && response.body.isNotEmpty) {
        final data = jsonDecode(response.body);
        if (data is List) {
          return data.map((e) => Assujettissement1.fromJson(e)).toList();
        }
      }
    } catch (e) {
      print('❌ Erreur fetchAssujettissements: $e');
    }
    return [];
  }

  // 🔹 Fetch Déclarations
  Future<List<Declaration1>> fetchDeclarations(String fiscalNo) async {
    try {
      final url = 'http://10.0.2.2:5000/api/declarationRoute/$fiscalNo';
      print('🔍 URL Déclaration: $url');

      final response = await http.get(Uri.parse(url));
      print('🔍 Code: ${response.statusCode}');
      print('🔍 Body: ${response.body}');

      if (response.statusCode == 200 && response.body.isNotEmpty) {
        final data = jsonDecode(response.body);
        if (data is List) {
          return data.map((e) => Declaration1.fromJson(e)).toList();
        }
      }
    } catch (e) {
      print('Erreur fetchDeclarations: $e');
    }
    return [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Fiche Contribuable"),
        backgroundColor: Colors.blueAccent,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: FutureBuilder<Contribuable1?>(
          future: contribuableFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text('Erreur: ${snapshot.error}'));
            }

            final contribuable = snapshot.data;
            if (contribuable == null) {
              return const Center(child: Text('Contribuable non trouvé'));
            }

            final fiscalNo = contribuable.taxPayerNo;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 🟦 Infos principales
                Text(
                  contribuable.rs,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text('NIF : ${contribuable.taxPayerNo}'),
                Text('Centre : ${contribuable.centre}'),
                Text('Adresse : ${contribuable.adresse}'),
                Text('Email : ${contribuable.email}'),
                Text('Téléphone : ${contribuable.phone}'),
                Text('Activité : ${contribuable.activite}'),
                const Divider(height: 30),

                // 🟩 Section Assujettissements
                const Text(
                  'Assujettissements',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                FutureBuilder<List<Assujettissement1>>(
                  future: fetchAssujettissements(fiscalNo),
                  builder: (context, snap) {
                    if (snap.connectionState == ConnectionState.waiting) {
                      return const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: CircularProgressIndicator(),
                      );
                    }
                    if (snap.hasError) {
                      return Text('Erreur: ${snap.error}');
                    }
                    final list = snap.data ?? [];
                    if (list.isEmpty) {
                      return const Text('Aucun assujettissement trouvé');
                    }
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: list.length,
                      itemBuilder: (context, index) {
                        final a = list[index];
                        return Card(
                          child: ListTile(
                            title: Text('${a.annee} - ${a.periodicite}'),
                            subtitle: Text('État : ${a.etat ?? "Non défini"}'),
                          ),
                        );
                      },
                    );
                  },
                ),
                const Divider(height: 30),

                // 🟨 Section Déclarations
                const Text(
                  'Déclarations',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                FutureBuilder<List<Declaration1>>(
                  future: fetchDeclarations(fiscalNo),
                  builder: (context, snap) {
                    if (snap.connectionState == ConnectionState.waiting) {
                      return const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: CircularProgressIndicator(),
                      );
                    }
                    if (snap.hasError) {
                      return Text('Erreur: ${snap.error}');
                    }
                    final list = snap.data ?? [];
                    if (list.isEmpty) {
                      return const Text('Aucune déclaration trouvée');
                    }

                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: list.length,
                      itemBuilder: (context, index) {
                        final d = list[index];
                        return Card(
                          elevation: 3,
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Type: ${d.taxTypeNo}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Période: ${d.taxPeriode != null ? d.taxPeriode!.toLocal().toIso8601String().split("T")[0] : "-"}',
                                ),
                                Text(
                                  'Échéance: ${d.dateEcheance != null ? d.dateEcheance!.toLocal().toIso8601String().split("T")[0] : "-"}',
                                ),
                                Text('Motif: ${d.motif ?? "-"}'),
                                Text(
                                  'Montant dû : ${NumberFormat('#,###').format(double.tryParse(d.montant_liquide.toString()) ?? 0)} Ar',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.teal,
                                  ),
                                ),

                                // ✅ Affichage du statut
                                /*Text(
                                  'Statut: ${d.statut ?? "-"}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green, // safidio couleur mety
                                  ),
                                ),*/
                                const SizedBox(height: 10),

                                // 🟦 Boutons d’action
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    ElevatedButton.icon(
                                      onPressed: () async {
                                        try {
                                          // 🔄 Maka paiements rehetra an’ilay contribuable
                                          final response = await http.get(
                                            Uri.parse(
                                              'http://10.0.2.2:5000/api/paiementRoute/contribuable/${contribuable.taxPayerNo}',
                                            ),
                                          );

                                          bool estRegle = false;

                                          if (response.statusCode == 200) {
                                            final List paiements = json.decode(
                                              response.body,
                                            );

                                            // 🧠 Raha misy paiements du contribuable, dia jerena raha misy valider=true na reste=0
                                            if (paiements.isNotEmpty) {
                                              estRegle = paiements.any(
                                                (p) =>
                                                    (p['valider'] == true) ||
                                                    (p['reste_a_recouvrer'] !=
                                                            null &&
                                                        p['reste_a_recouvrer'] ==
                                                            0),
                                              );
                                            }
                                          } else if (response.statusCode ==
                                              404) {
                                            // Raha tsy misy paiement
                                            estRegle = false;
                                          } else {
                                            throw Exception(
                                              'Erreur serveur: ${response.statusCode}',
                                            );
                                          }

                                          // 🔔 Notification visuelle en haut
                                          showSimpleNotification(
                                            Row(
                                              children: [
                                                Icon(
                                                  estRegle
                                                      ? Icons.check_circle
                                                      : Icons.error_outline,
                                                  //color: Colors.white,
                                                ),
                                                const SizedBox(width: 10),
                                                Expanded(
                                                  child: Text(
                                                    estRegle
                                                        ? '✅ Paiement en règle'
                                                        : '❌ Contribuable défaillant',
                                                    /*style: const TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),*/
                                                  ),
                                                ),
                                              ],
                                            ),
                                            background: estRegle
                                                ? Colors.blue
                                                : Colors.red,
                                            position: NotificationPosition.top,
                                            autoDismiss: true,
                                            slideDismiss: true,
                                            duration: const Duration(
                                              seconds: 2,
                                            ),
                                          );

                                          // ⏳ Attendre un peu avant d’aller à la page Paiement
                                          await Future.delayed(
                                            const Duration(milliseconds: 700),
                                          );
                                          //test
                                          final prefs =
                                              await SharedPreferences.getInstance();
                                          final agentMatricule =
                                              prefs.getString(
                                                'agentMatricule',
                                              ) ??
                                              '';

                                          // 👉 Navigation
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => PaiementsPage(
                                                taxPayerNo:
                                                    contribuable.taxPayerNo,
                                                contribuableName:
                                                    contribuable.rs,
                                                agentMatricule:
                                                    agentMatricule, // ✅ agent connecté
                                              ),
                                            ),
                                          );
                                        } catch (e) {
                                          // ⚠️ Gestion d’erreur (backend non dispo, json invalide, etc.)
                                          debugPrint(
                                            'Erreur vérification statut: $e',
                                          );
                                          showSimpleNotification(
                                            const Text(
                                              'Erreur lors de la vérification du statut 😕',
                                              style: TextStyle(
                                                color: Colors.white,
                                              ),
                                            ),
                                            background: Colors.orange,
                                            position: NotificationPosition.top,
                                            duration: Duration(seconds: 2),
                                          );
                                        }
                                      },
                                      icon: const Icon(
                                        Icons.receipt_long,
                                        size: 18,
                                      ),
                                      label: const Text("Voir Paiements"),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.blue,
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 8,
                                        ),
                                      ),
                                    ),
                                    ElevatedButton.icon(
                                      onPressed: () async {
                                        final prefs =
                                            await SharedPreferences.getInstance();
                                        final agentMatricule =
                                            prefs.getString('agentMatricule') ??
                                            '';
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) => VoirDeclarationPage(
                                              taxPayerNo:
                                                  contribuable.taxPayerNo,
                                              agentMatricule: agentMatricule,
                                            ),
                                          ),
                                        );
                                      },
                                      icon: const Icon(
                                        Icons.list_alt,
                                        size: 18,
                                      ),
                                      label: const Text("Voir Déclaration"),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.blue,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
