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
/*import 'package:flutter/material.dart';
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
        backgroundColor: const Color(0xFF4C6C89),
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
              final dateFormat = DateFormat('yyyy-MM-dd');

              return Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 3,
                margin: const EdgeInsets.symmetric(vertical: 6),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: const Color(0xFF4C6C89),
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
                      /*Text("Montant payé : ${p.montantPayer} Ar"),*/
                      Text(
                        'Montant payé  : ${NumberFormat('#,##0', 'fr_FR').format(double.tryParse(p.montantPayer.toString()) ?? 0)} Ar',
                      ),
                      Text(
                        /*"Reste à recouvrer : ${p.resteARecouvrer} Ar",*/
                        'Reste à recouvrer: ${NumberFormat('#,##0', 'fr_FR').format(double.tryParse(p.resteARecouvrer.toString()) ?? 0)} Ar',
                        style: TextStyle(
                          color: p.resteARecouvrer == 0
                              ? Color(0xFF5C8D89)
                              : Color(0xFFD9534F),
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
                          icon: const Icon(Icons.email, color: Colors.white),
                          label: const Text(
                            "Envoyer Relance",
                            style: TextStyle(color: Colors.white),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF5C8D89),
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
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_app/services/paiement_relance.dart';
import '../models/paiement.dart';
import '../services/paiement_service1.dart';

class PaiementsPage extends StatefulWidget {
  final String taxPayerNo;
  final String contribuableName;
  final String agentMatricule;

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

  void _showConfirmationPop(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext builderContext) {
        Timer(const Duration(seconds: 4), () {
          if (Navigator.of(builderContext).canPop()) {
            Navigator.of(builderContext).pop();
          }
        });

        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.mark_email_read_rounded,
                color: Color(0xFF5C8D89),
                size: 60,
              ),
              const SizedBox(height: 15),
              const Text(
                "Relance envoyée",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Color(0xFF2C3E50),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "La notification a été transmise au contribuable.",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey, fontSize: 14),
              ),
              const SizedBox(height: 20),
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: const LinearProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF5C8D89)),
                  backgroundColor: Color(0xFFE0E0E0),
                  minHeight: 6,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFB),
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Historique des Paiements",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Text(
              widget.contribuableName,
              style: const TextStyle(fontSize: 12, color: Colors.white70),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF4C6C89),
        elevation: 0,
      ),
      body: FutureBuilder<List<Paiement1>>(
        future: paiements,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFF4C6C89)),
            );
          } else if (snapshot.hasError) {
            return _buildErrorState(snapshot.error.toString());
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return _buildEmptyState();
          }

          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final p = snapshot.data![index];
              return _buildPaiementCard(p);
            },
          );
        },
      ),
    );
  }

  Widget _buildPaiementCard(Paiement1 p) {
    final dateFormat = DateFormat('yyyy MMM dd', 'fr_FR');
    final currencyFormat = NumberFormat('#,##0', 'fr_FR');

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          // Header section: N° Déclaration & Statut
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Décl. N° ${p.nDecl}",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF4C6C89),
                  ),
                ),
                _buildStatusBadge(p.valider),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Financial Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildAmountColumn(
                      "Montant Payé",
                      "${currencyFormat.format(p.montantPayer)} Ar",
                      const Color(0xFF2C3E50),
                    ),
                    _buildAmountColumn(
                      "Reste à recouvrer",
                      "${currencyFormat.format(p.resteARecouvrer)} Ar",
                      p.resteARecouvrer == 0
                          ? const Color(0xFF5C8D89)
                          : const Color(0xFFD9534F),
                    ),
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: Divider(height: 1),
                ),
                // Details Row
                Row(
                  children: [
                    _buildIconDetail(
                      Icons.calendar_today_rounded,
                      dateFormat.format(p.datePaiement.toLocal()),
                    ),
                    const Spacer(),
                    _buildIconDetail(
                      Icons.account_balance_wallet_rounded,
                      p.modePaiement,
                    ),
                  ],
                ),

                // Relance Button (Responsive logic)
                if (!p.valider || p.resteARecouvrer > 0) ...[
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () => _handleRelance(p),
                      icon: const Icon(
                        Icons.send_rounded,
                        size: 18,
                        color: Colors.white,
                      ),
                      label: const Text(
                        "ENVOYER UNE RELANCE",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF5C8D89),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 0,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- Helper Widgets ho an'ny IHM ---

  Widget _buildStatusBadge(bool isValid) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: isValid ? const Color(0xFFE8F5E9) : const Color(0xFFFFEBEE),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Icon(
            isValid ? Icons.check_circle : Icons.cancel,
            size: 14,
            color: isValid ? Colors.green : Colors.red,
          ),
          const SizedBox(width: 4),
          Text(
            isValid ? "VALIDÉ" : "NON VALIDÉ",
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: isValid ? Colors.green : Colors.red,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAmountColumn(String label, String value, Color valueColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: valueColor,
          ),
        ),
      ],
    );
  }

  Widget _buildIconDetail(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.blueGrey.shade300),
        const SizedBox(width: 6),
        Text(
          text,
          style: const TextStyle(fontSize: 13, color: Color(0xFF546E7A)),
        ),
      ],
    );
  }

  // --- Actions ---

  Future<void> _handleRelance(Paiement1 p) async {
    if (widget.agentMatricule.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Erreur : Agent non connecté")),
      );
      return;
    }
    try {
      await PaiementService1.sendRelance(
        taxPayerNo: p.taxPayerNo,
        NDecl: p.nDecl,
        agentMatricule: widget.agentMatricule,
      );
      if (!mounted) return;
      _showConfirmationPop(context);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Erreur : $e")));
    }
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.receipt_long_rounded,
            size: 80,
            color: Colors.grey.shade200,
          ),
          const SizedBox(height: 16),
          const Text(
            "Aucun paiement trouvé.",
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(String error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Text(
          "Erreur : $error",
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.redAccent),
        ),
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
