import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:my_app/screens/declaration_page.dart';
import 'package:my_app/screens/paiementpageSansRelance.dart';
import '../models/fiche_contrib.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../config/api_endpoints.dart';

class FicheContribuableScreen1 extends StatefulWidget {
  final String taxPayerNo;

  const FicheContribuableScreen1({super.key, required this.taxPayerNo});

  @override
  State<FicheContribuableScreen1> createState() =>
      _FicheContribuableScreenState();
}

class _FicheContribuableScreenState extends State<FicheContribuableScreen1> {
  late Future<Contribuable1?> contribuableFuture;

  @override
  void initState() {
    super.initState();
    contribuableFuture = fetchContribuable(widget.taxPayerNo);
  }

  // --- API CALLS (TSY NIOVA) ---
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

  // --- FONCTION LOGIC (TSY NIOVA) ---
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

      String titleDialog = "";
      String messageDialog = "";
      IconData iconDialog;
      Color colorDialog;

      if (type == 'paiement') {
        titleDialog = estValide ? "Paiement en règle" : "Paiement non valide";
        messageDialog = estValide
            ? "Le paiement de ce contribuable a été vérifié et est à jour."
            : "Attention, aucun paiement valide n'a été trouvé.";
        iconDialog = estValide ? Icons.check_circle : Icons.error_outline;
        colorDialog = estValide ? const Color(0xFF5C8D89) : Colors.redAccent;
      } else {
        titleDialog = estValide ? "Déclaration trouvée" : "Déclaration absente";
        messageDialog = estValide
            ? "La déclaration correspondante a été identifiée."
            : "Aucune déclaration n'a été enregistrée.";
        iconDialog = estValide
            ? Icons.description
            : Icons.warning_amber_rounded;
        colorDialog = const Color(0xFF4C6C89);
      }

      await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: Column(
            children: [
              Icon(iconDialog, size: 60, color: colorDialog),
              const SizedBox(height: 10),
              Text(
                titleDialog,
                style: TextStyle(
                  color: colorDialog,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          content: Text(messageDialog, textAlign: TextAlign.center),
          actions: [
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: colorDialog),
                onPressed: () async {
                  Navigator.pop(context);
                  final prefs = await SharedPreferences.getInstance();
                  final agentMatricule =
                      prefs.getString('agentMatricule') ?? '';
                  if (!mounted) return;
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => type == 'paiement'
                          ? PaiementsPage1(
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
                child: const Text(
                  "CONTINUER",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      );
    } catch (e) {
      if (mounted) Navigator.pop(context);
    }
  }

  // --- INTERFACE (HATSARAINA NY ERGONOMIE) ---
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7F9),
      appBar: AppBar(
        title: const Text("Fiche Contribuable"),
        backgroundColor: const Color(0xFF4C6C89),
        elevation: 0,
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
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 🟦 INFOS PRINCIPALES (Styling fotsiny)
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        c.rs,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF4C6C89),
                        ),
                      ),
                      const Divider(height: 25),
                      _buildInfoRow(Icons.fingerprint, "NIF", c.taxPayerNo),
                      _buildInfoRow(Icons.business, "Centre", c.centre),
                      _buildInfoRow(Icons.location_on, "Adresse", c.adresse),
                      _buildInfoRow(Icons.email, "Email", c.email),
                      _buildInfoRow(Icons.phone, "Téléphone", c.phone),
                      _buildInfoRow(Icons.work, "Activité", c.activite),
                    ],
                  ),
                ),

                const SizedBox(height: 25),

                // 🟩 SECTION ASSUJETTISSEMENTS
                const Text(
                  'Assujettissements',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                FutureBuilder<List<Assujettissement1>>(
                  future: fetchAssujettissements(c.taxPayerNo),
                  builder: (context, snap) {
                    final list = snap.data ?? [];
                    if (list.isEmpty)
                      return const Text("Aucun assujettissement.");
                    return Column(
                      children: list
                          .map(
                            (a) => Card(
                              margin: const EdgeInsets.only(bottom: 8),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: ListTile(
                                leading: const Icon(
                                  Icons.calendar_month,
                                  color: Color(0xFF4C6C89),
                                ),
                                title: Text(
                                  "${a.annee} - ${a.periodicite}",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                subtitle: Text("État: ${a.etat ?? 'N/A'}"),
                              ),
                            ),
                          )
                          .toList(),
                    );
                  },
                ),

                const SizedBox(height: 25),

                // 🟨 SECTION DÉCLARATIONS (Logic nitovy hatrany)
                FutureBuilder<List<Declaration1>>(
                  future: fetchDeclarations(c.taxPayerNo),
                  builder: (context, snap) {
                    final list = snap.data ?? [];
                    if (list.isEmpty)
                      return const Center(
                        child: Text("Aucune déclaration trouvée."),
                      );

                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: list.length,
                      itemBuilder: (context, index) {
                        return Card(
                          elevation: 2,
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              children: [
                                const Text(
                                  "Actions disponibles pour ce dossier",
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 13,
                                  ),
                                ),
                                const SizedBox(height: 15),
                                Row(
                                  children: [
                                    Expanded(
                                      child: _buildActionButton(
                                        label: "Paiement",
                                        icon: Icons.payments_outlined,
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
                                      child: _buildActionButton(
                                        label: "Declaration",
                                        icon: Icons.list_alt,
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

  Widget _buildInfoRow(IconData icon, String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: const Color(0xFF4C6C89)),
          const SizedBox(width: 12),
          Text(
            "$label : ",
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: Text(
              value ?? "-",
              style: const TextStyle(color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required String label,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return ElevatedButton.icon(
      onPressed: onTap,
      icon: Icon(icon, color: Colors.white, size: 18),
      label: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 13,
          fontWeight: FontWeight.bold,
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: const EdgeInsets.symmetric(vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}
