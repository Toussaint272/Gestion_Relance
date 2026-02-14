/*import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:my_app/screens/declaration_page.dart';
import 'package:my_app/screens/paiement_page.dart';
import '../models/fiche_contrib.dart';
import 'package:intl/intl.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../config/api_endpoints.dart';
// ✅ ajout obligatoire

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
      /*final url = 'http://10.155.28.240:5000/api/contribuableRoute/nif/$nif';*/
      final url = ApiEndpoints.contribuableByNif(nif);

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
      /*final url =
          'http://10.155.28.240:5000/api/assujettissementRoute/$fiscalNo';*/
      final url = ApiEndpoints.assujettissementByFiscalNo(fiscalNo);

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
      /*final url = 'http://10.155.28.240:5000/api/declarationRoute/$fiscalNo';*/
      final url = ApiEndpoints.declarationByFiscalNo(fiscalNo);

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
        backgroundColor: const Color(0xFF4C6C89),
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
                                  'Montant dû : ${NumberFormat('#,##0', 'fr_FR').format(double.tryParse(d.montant_liquide.toString()) ?? 0)} Ar',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF5C8D89),
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
                                        // 1. Afficher un indicateur de chargement pendant l'appel API
                                        showDialog(
                                          context: context,
                                          barrierDismissible: false,
                                          builder: (context) => const Center(
                                            child: CircularProgressIndicator(
                                              color: Color(0xFF5C8D89),
                                            ),
                                          ),
                                        );

                                        try {
                                          final response = await http.get(
                                            Uri.parse(
                                              ApiEndpoints.paiementByContribuable(
                                                contribuable.taxPayerNo,
                                              ),
                                            ),
                                          );

                                          // Fermer l'indicateur de chargement
                                          Navigator.pop(context);

                                          bool estRegle = false;

                                          if (response.statusCode == 200) {
                                            final List paiements = json.decode(
                                              response.body,
                                            );
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
                                            estRegle = false;
                                          } else {
                                            throw Exception(
                                              'Erreur serveur: ${response.statusCode}',
                                            );
                                          }

                                          // 2. Afficher le Pop-up de confirmation au centre
                                          await showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                ),
                                                title: Icon(
                                                  estRegle
                                                      ? Icons.check_circle
                                                      : Icons.error_outline,
                                                  size: 60,
                                                  color: estRegle
                                                      ? const Color(0xFF4C6C89)
                                                      : const Color(0xFFD9534F),
                                                ),
                                                content: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    Text(
                                                      estRegle
                                                          ? 'Paiement en règle'
                                                          : 'Paiement non valide',
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: const TextStyle(
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    const SizedBox(height: 10),
                                                    Text(
                                                      estRegle
                                                          ? 'Le statut de ce contribuable est à jour.'
                                                          : 'Le paiement n\'est pas encore validé ou est incomplet.',
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                  ],
                                                ),
                                                actions: [
                                                  Center(
                                                    child: TextButton(
                                                      onPressed: () =>
                                                          Navigator.pop(
                                                            context,
                                                          ),
                                                      child: const Text(
                                                        "OK",
                                                        style: TextStyle(
                                                          color: Color(
                                                            0xFF5C8D89,
                                                          ),
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              );
                                            },
                                          );

                                          // 3. Récupération des préférences et Navigation
                                          final prefs =
                                              await SharedPreferences.getInstance();
                                          final agentMatricule =
                                              prefs.getString(
                                                'agentMatricule',
                                              ) ??
                                              '';

                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  PaiementsPage(
                                                    taxPayerNo:
                                                        contribuable.taxPayerNo,
                                                    contribuableName:
                                                        contribuable.rs,
                                                    agentMatricule:
                                                        agentMatricule,
                                                  ),
                                            ),
                                          );
                                        } catch (e) {
                                          Navigator.pop(
                                            context,
                                          ); // Fermer le chargement en cas d'erreur
                                          debugPrint('Erreur: $e');

                                          // Pop-up d'erreur réseau
                                          showDialog(
                                            context: context,
                                            builder: (context) => AlertDialog(
                                              title: const Text("Erreur"),
                                              content: const Text(
                                                "Impossible de vérifier le statut. Veuillez vérifier votre connexion.",
                                              ),
                                              actions: [
                                                TextButton(
                                                  onPressed: () =>
                                                      Navigator.pop(context),
                                                  child: const Text("OK"),
                                                ),
                                              ],
                                            ),
                                          );
                                        }
                                      },
                                      icon: const Icon(
                                        Icons.receipt_long,
                                        color: Colors.white,
                                        size: 18,
                                      ),
                                      label: const Text(
                                        "Voir Paiement",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color(
                                          0xFF5C8D89,
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 8,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
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
                                        color: Colors.white,
                                        size: 18,
                                      ),
                                      label: const Text(
                                        "Voir Déclaration",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Color(0xFF5C8D89),
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
}*/
//TESTE1
/*import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:my_app/screens/declaration_page.dart';
import 'package:my_app/screens/paiement_page.dart';
import '../models/fiche_contrib.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../config/api_endpoints.dart';

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

  // -------------------------------------------------------------------------
  // 🔹 FETCH FUNCTIONS (API CALLS)
  // -------------------------------------------------------------------------

  Future<Contribuable1?> fetchContribuable(String nif) async {
    try {
      final url = ApiEndpoints.contribuableByNif(nif);
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200 && response.body != 'null') {
        return Contribuable1.fromJson(jsonDecode(response.body));
      }
      return null;
    } catch (e) {
      debugPrint('Erreur fetchContribuable: $e');
      return null;
    }
  }

  Future<List<Assujettissement1>> fetchAssujettissements(
    String fiscalNo,
  ) async {
    try {
      final url = ApiEndpoints.assujettissementByFiscalNo(fiscalNo);
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final List data = jsonDecode(response.body);
        return data.map((e) => Assujettissement1.fromJson(e)).toList();
      }
    } catch (e) {
      debugPrint('Erreur Assuj: $e');
    }
    return [];
  }

  Future<List<Declaration1>> fetchDeclarations(String fiscalNo) async {
    try {
      final url = ApiEndpoints.declarationByFiscalNo(fiscalNo);
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final List data = jsonDecode(response.body);
        return data.map((e) => Declaration1.fromJson(e)).toList();
      }
    } catch (e) {
      debugPrint('Erreur Decl: $e');
    }
    return [];
  }

  // -------------------------------------------------------------------------
  // ✅ FONCTION DE CONFIRMATION & NAVIGATION
  // -------------------------------------------------------------------------

  Future<void> _verifierEtNaviguer({
    required BuildContext context,
    required String type, // 'paiement' na 'declaration'
    required String taxPayerNo,
    required String rs,
  }) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(color: Color(0xFF5C8D89)),
      ),
    );

    try {
      String url = (type == 'paiement')
          ? ApiEndpoints.paiementByContribuable(taxPayerNo)
          : ApiEndpoints.declarationByFiscalNo(taxPayerNo);

      final response = await http.get(Uri.parse(url));
      if (!mounted) return;
      Navigator.pop(context); // Akatona ny loading

      bool estValide = false;
      if (response.statusCode == 200) {
        final List data = json.decode(response.body);
        if (data.isNotEmpty) {
          if (type == 'paiement') {
            estValide = data.any(
              (p) => (p['valider'] == true) || (p['reste_a_recouvrer'] == 0),
            );
          } else {
            estValide = true;
          }
        }
      }

      // Pop-up Confirmation
      await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: Icon(
            estValide ? Icons.check_circle : Icons.info_outline,
            size: 60,
            color: estValide
                ? const Color(0xFF4C6C89)
                : const Color(0xFFD9534F),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                type == 'paiement'
                    ? (estValide ? 'Paiement en règle' : 'Paiement non valide')
                    : (estValide
                          ? 'Déclaration trouvée'
                          : 'Aucune déclaration'),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Text(
                estValide
                    ? 'Efa ao amin\'ny systeme ny antontan-taratasy.'
                    : 'Tsy mbola misy fampahalalana feno ao amin\'ny systeme.',
                textAlign: TextAlign.center,
              ),
            ],
          ),
          actions: [
            Center(
              child: TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  "OK",
                  style: TextStyle(
                    color: Color(0xFF5C8D89),
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      );

      final prefs = await SharedPreferences.getInstance();
      final agentMatricule = prefs.getString('agentMatricule') ?? '';

      if (!mounted) return;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => type == 'paiement'
              ? PaiementsPage(
                  taxPayerNo: taxPayerNo,
                  contribuableName: rs,
                  agentMatricule: agentMatricule,
                )
              : VoirDeclarationPage(
                  taxPayerNo: taxPayerNo,
                  agentMatricule: agentMatricule,
                ),
        ),
      );
    } catch (e) {
      if (mounted) Navigator.pop(context);
      debugPrint("Erreur Navigation: $e");
    }
  }

  // -------------------------------------------------------------------------
  // 🔹 UI BUILDER
  // -------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Fiche Contribuable"),
        backgroundColor: const Color(0xFF4C6C89),
      ),
      body: FutureBuilder<Contribuable1?>(
        future: contribuableFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final contribuable = snapshot.data;
          if (contribuable == null) {
            return const Center(child: Text('Contribuable non trouvé'));
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 🟦 INFOS PRINCIPALES (COMPLET)
                Text(
                  contribuable.rs,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                _buildInfoRow(
                  Icons.fingerprint,
                  "NIF",
                  contribuable.taxPayerNo,
                ),
                _buildInfoRow(Icons.business, "Centre", contribuable.centre),
                _buildInfoRow(
                  Icons.location_on,
                  "Adresse",
                  contribuable.adresse,
                ),
                _buildInfoRow(Icons.email, "Email", contribuable.email),
                _buildInfoRow(Icons.phone, "Téléphone", contribuable.phone),
                _buildInfoRow(Icons.work, "Activité", contribuable.activite),

                const Divider(height: 40, thickness: 1.5),

                // 🟩 SECTION ASSUJETTISSEMENTS
                const Text(
                  'Assujettissements',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                FutureBuilder<List<Assujettissement1>>(
                  future: fetchAssujettissements(contribuable.taxPayerNo),
                  builder: (context, snap) {
                    final list = snap.data ?? [];
                    if (list.isEmpty)
                      return const Text("Aucun assujettissement.");
                    return Column(
                      children: list
                          .map(
                            (a) => Card(
                              margin: const EdgeInsets.only(bottom: 8),
                              child: ListTile(
                                title: Text("${a.annee} - ${a.periodicite}"),
                                subtitle: Text("État: ${a.etat ?? 'N/A'}"),
                              ),
                            ),
                          )
                          .toList(),
                    );
                  },
                ),

                const Divider(height: 40, thickness: 1.5),

                // 🟨 SECTION DÉCLARATIONS (MIARAKA AMINY BOUTONS)
                const Text(
                  'Déclarations & Actions',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                FutureBuilder<List<Declaration1>>(
                  future: fetchDeclarations(contribuable.taxPayerNo),
                  builder: (context, snap) {
                    final list = snap.data ?? [];
                    if (list.isEmpty)
                      return const Text("Aucune déclaration trouvée.");
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: list.length,
                      itemBuilder: (context, index) {
                        final d = list[index];
                        return Card(
                          elevation: 3,
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Type: ${d.taxTypeNo}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  'Période: ${d.taxPeriode != null ? d.taxPeriode!.toLocal().toIso8601String().split("T")[0] : "-"}',
                                ),
                                Text(
                                  'Montant dû: ${NumberFormat('#,##0', 'fr_FR').format(double.tryParse(d.montant_liquide.toString()) ?? 0)} Ar',
                                  style: const TextStyle(
                                    color: Color(0xFF5C8D89),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 15),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    _buildActionButton(
                                      label: "Voir Paiement",
                                      icon: Icons.receipt_long,
                                      color: const Color(0xFF5C8D89),
                                      onTap: () => _verifierEtNaviguer(
                                        context: context,
                                        type: 'paiement',
                                        taxPayerNo: contribuable.taxPayerNo,
                                        rs: contribuable.rs,
                                      ),
                                    ),
                                    _buildActionButton(
                                      label: "Voir Déclaration",
                                      icon: Icons.list_alt,
                                      color: const Color(0xFF4C6C89),
                                      onTap: () => _verifierEtNaviguer(
                                        context: context,
                                        type: 'declaration',
                                        taxPayerNo: contribuable.taxPayerNo,
                                        rs: contribuable.rs,
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
            ),
          );
        },
      ),
    );
  }

  // Widget ho an'ny fampisehoana tsara ny informatio (Adresse, phone, etc.)
  Widget _buildInfoRow(IconData icon, String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.grey[600]),
          const SizedBox(width: 10),
          Text(
            "$label : ",
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Expanded(child: Text(value ?? "-", overflow: TextOverflow.ellipsis)),
        ],
      ),
    );
  }

  // Widget ho an'ny style an'ny boutons
  Widget _buildActionButton({
    required String label,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return ElevatedButton.icon(
      onPressed: onTap,
      icon: Icon(icon, color: Colors.white, size: 16),
      label: Text(
        label,
        style: const TextStyle(color: Colors.white, fontSize: 12),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }
}*/
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:my_app/screens/declaration_page.dart';
import 'package:my_app/screens/paiement_page.dart';
import '../models/fiche_contrib.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../config/api_endpoints.dart';

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

  // --- API CALLS (Logic tsy niova) ---
  Future<Contribuable1?> fetchContribuable(String nif) async {
    try {
      final url = ApiEndpoints.contribuableByNif(nif);
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200 && response.body != 'null') {
        return Contribuable1.fromJson(jsonDecode(response.body));
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<List<Assujettissement1>> fetchAssujettissements(
    String fiscalNo,
  ) async {
    try {
      final url = ApiEndpoints.assujettissementByFiscalNo(fiscalNo);
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final List data = jsonDecode(response.body);
        return data.map((e) => Assujettissement1.fromJson(e)).toList();
      }
    } catch (e) {
      debugPrint('Erreur: $e');
    }
    return [];
  }

  Future<List<Declaration1>> fetchDeclarations(String fiscalNo) async {
    try {
      final url = ApiEndpoints.declarationByFiscalNo(fiscalNo);
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final List data = jsonDecode(response.body);
        return data.map((e) => Declaration1.fromJson(e)).toList();
      }
    } catch (e) {
      debugPrint('Erreur: $e');
    }
    return [];
  }

  // ✅ NAVIGATION LOGIC (Tsy niova fa nampiana Loading IHM)
  Future<void> _verifierEtNaviguer({
    required BuildContext context,
    required String type,
    required String taxPayerNo,
    required String rs,
  }) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(color: Color(0xFF5C8D89)),
      ),
    );

    try {
      String url = (type == 'paiement')
          ? ApiEndpoints.paiementByContribuable(taxPayerNo)
          : ApiEndpoints.declarationByFiscalNo(taxPayerNo);

      final response = await http.get(Uri.parse(url));
      if (!mounted) return;
      Navigator.pop(context);

      bool estValide = false;
      if (response.statusCode == 200) {
        final List data = json.decode(response.body);
        if (data.isNotEmpty) {
          estValide = (type == 'paiement')
              ? data.any(
                  (p) =>
                      (p['valider'] == true) || (p['reste_a_recouvrer'] == 0),
                )
              : true;
        }
      }

      _showResultDialog(context, type, estValide, taxPayerNo, rs);
    } catch (e) {
      if (mounted) Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7F9),
      appBar: AppBar(
        title: const Text(
          "Détails Contribuable",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF4C6C89),
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: FutureBuilder<Contribuable1?>(
        future: contribuableFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final c = snapshot.data;
          if (c == null)
            return const Center(child: Text('Contribuable non trouvé'));

          return SingleChildScrollView(
            child: Column(
              children: [
                _buildHeaderProfile(c),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildInfoSection(c),
                      const SizedBox(height: 20),
                      _buildActionSection(c),
                      const SizedBox(height: 20),
                      _buildAssujettissementSection(c.taxPayerNo),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // --- UI COMPONENTS ---

  Widget _buildHeaderProfile(Contribuable1 c) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      decoration: const BoxDecoration(
        color: Color(0xFF4C6C89),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 35,
            backgroundColor: Colors.white.withOpacity(0.2),
            child: const Icon(
              Icons.business_center,
              color: Colors.white,
              size: 40,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            c.rs.toUpperCase(),
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            "NIF: ${c.taxPayerNo}",
            style: const TextStyle(color: Colors.white70, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoSection(Contribuable1 c) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildInfoRow(Icons.location_on_outlined, "Adresse", c.adresse),
            _buildInfoRow(Icons.apartment, "Centre", c.centre),
            _buildInfoRow(Icons.work_outline, "Activité", c.activite),
            _buildInfoRow(Icons.email_outlined, "Email", c.email),
            _buildInfoRow(Icons.phone_outlined, "Contact", c.phone),
          ],
        ),
      ),
    );
  }

  Widget _buildActionSection(Contribuable1 c) {
    return Row(
      children: [
        Expanded(
          child: _buildMainButton(
            label: "Paiements",
            icon: Icons.payments,
            color: const Color(0xFF5C8D89),
            onTap: () => _verifierEtNaviguer(
              context: context,
              type: 'paiement',
              taxPayerNo: c.taxPayerNo,
              rs: c.rs,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildMainButton(
            label: "Déclarations",
            icon: Icons.description,
            color: const Color(0xFF4C6C89),
            onTap: () => _verifierEtNaviguer(
              context: context,
              type: 'declaration',
              taxPayerNo: c.taxPayerNo,
              rs: c.rs,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAssujettissementSection(String nif) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Assujettissements",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2C3E50),
          ),
        ),
        const SizedBox(height: 10),
        FutureBuilder<List<Assujettissement1>>(
          future: fetchAssujettissements(nif),
          builder: (context, snap) {
            final list = snap.data ?? [];
            if (snap.connectionState == ConnectionState.waiting)
              return const LinearProgressIndicator();
            if (list.isEmpty)
              return const Center(
                child: Text("Aucun assujettissement trouvé."),
              );

            return ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: list.length,
              itemBuilder: (context, index) {
                final a = list[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    leading: const Icon(
                      Icons.check_circle_outline,
                      color: Colors.green,
                    ),
                    title: Text(
                      "${a.annee} - ${a.periodicite}",
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    subtitle: Text(
                      "État: ${a.etat ?? 'N/A'}",
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ],
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 20, color: const Color(0xFF4C6C89)),
          const SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
              ),
              Text(
                value ?? "-",
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMainButton({
    required String label,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(icon, color: Colors.white, size: 28),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- Helpers for Dialogs (logic tsy niova) ---
  void _showResultDialog(
    BuildContext context,
    String type,
    bool estValide,
    String taxPayerNo,
    String rs,
  ) {
    // ... (Ity dia ilay logic-nao tany aloha fa nalahatra fotsiny ny sary)
    String title = type == 'paiement'
        ? (estValide ? "Paiement en règle" : "Paiement non valide")
        : (estValide ? "Déclaration trouvée" : "Déclaration absente");
    IconData icon = estValide
        ? Icons.check_circle
        : Icons.warning_amber_rounded;
    Color color = estValide ? const Color(0xFF5C8D89) : Colors.orange;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Column(
          children: [
            Icon(icon, size: 50, color: color),
            const SizedBox(height: 10),
            Text(title, textAlign: TextAlign.center),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              final prefs = await SharedPreferences.getInstance();
              final agentMatricule = prefs.getString('agentMatricule') ?? '';
              if (!mounted) return;
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => type == 'paiement'
                      ? PaiementsPage(
                          taxPayerNo: taxPayerNo,
                          contribuableName: rs,
                          agentMatricule: agentMatricule,
                        )
                      : VoirDeclarationPage(
                          taxPayerNo: taxPayerNo,
                          agentMatricule: agentMatricule,
                        ),
                ),
              );
            },
            child: const Text("CONTINUER"),
          ),
        ],
      ),
    );
  }
}
