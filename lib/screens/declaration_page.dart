/*import 'package:flutter/material.dart';
import '../services/declaration_service.dart';

class VoirDeclarationPage extends StatefulWidget {
  final String taxPayerNo;
  final String agentMatricule; // 👈 agent connecté
  const VoirDeclarationPage({
    Key? key,
    required this.taxPayerNo,
    required this.agentMatricule,
  }) : super(key: key);

  @override
  State<VoirDeclarationPage> createState() => _VoirDeclarationPageState();
}

class _VoirDeclarationPageState extends State<VoirDeclarationPage> {
  final DeclarationService _service = DeclarationService();
  List<dynamic> declarations = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadDeclarations();
  }

  Future<void> _loadDeclarations() async {
    try {
      final data = await _service.getDeclarations(widget.taxPayerNo);
      setState(() {
        declarations = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Erreur: $e')));
    }
  }

  Future<void> _sendRelance() async {
    try {
      await _service.sendAutoRelance(
        widget.taxPayerNo,
        widget.agentMatricule, // ✅ ajout ici
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('✅ Relance envoyée avec succès 📧')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur lors de l’envoi de la relance: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Déclarations"),
        backgroundColor: const Color(0xFF4C6C89),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: declarations.length,
              itemBuilder: (context, index) {
                final decl = declarations[index];
                final statut = decl['statut'] ?? '';
                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  child: ListTile(
                    title: Text(
                      "Déclaration N°${decl['N_decl']}",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      "Type: ${decl['tax_type_no']} \nStatut: $statut",
                    ),
                    trailing: statut == "Non reçu"
                        ? ElevatedButton.icon(
                            onPressed: _sendRelance,
                            icon: const Icon(Icons.email_outlined, size: 18),
                            label: const Text("Relancer"),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.redAccent,
                            ),
                          )
                        : const Icon(
                            Icons.check_circle,
                            color: Color(0xFF5C8D89),
                          ),
                  ),
                );
              },
            ),
    );
  }
}*/
/*import 'dart:async'; // 👈 Ilaina amin'ny Timer
import 'package:flutter/material.dart';
import '../services/declaration_service.dart';

class VoirDeclarationPage extends StatefulWidget {
  final String taxPayerNo;
  final String agentMatricule;
  const VoirDeclarationPage({
    Key? key,
    required this.taxPayerNo,
    required this.agentMatricule,
  }) : super(key: key);

  @override
  State<VoirDeclarationPage> createState() => _VoirDeclarationPageState();
}

class _VoirDeclarationPageState extends State<VoirDeclarationPage> {
  final DeclarationService _service = DeclarationService();
  List<dynamic> declarations = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadDeclarations();
  }

  Future<void> _loadDeclarations() async {
    try {
      final data = await _service.getDeclarations(widget.taxPayerNo);
      setState(() {
        declarations = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Erreur: $e')));
    }
  }

  // ✅ 1. FONCTION CONFIRMATION (Pop-up 5 seconds)
  void _showAutoDismissDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext builderContext) {
        Timer(const Duration(seconds: 5), () {
          if (Navigator.of(builderContext).canPop()) {
            Navigator.of(builderContext).pop();
          }
        });

        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Icon(Icons.check_circle, color: Color(0xFF5C8D89), size: 50),
              SizedBox(height: 15),
              Text(
                "Relance envoyée",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              SizedBox(height: 10),
              Text(
                "La relance de déclaration a été transmise avec succès.",
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 15),
              LinearProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF5C8D89)),
                backgroundColor: Color(0xFFEEEEEE),
              ),
            ],
          ),
        );
      },
    );
  }

  // ✅ 2. MODIFICATION _sendRelance
  Future<void> _sendRelance() async {
    try {
      await _service.sendAutoRelance(widget.taxPayerNo, widget.agentMatricule);

      // Asehoy ilay Pop-up vaovao fa tsy SnackBar intsony
      if (!mounted) return;
      _showAutoDismissDialog(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur lors de l’envoi de la relance: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Déclarations"),
        backgroundColor: const Color(0xFF4C6C89),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: declarations.length,
              itemBuilder: (context, index) {
                final decl = declarations[index];
                final statut = decl['statut'] ?? '';
                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  child: ListTile(
                    title: Text(
                      "Déclaration N°${decl['N_decl']}",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      "Type: ${decl['tax_type_no']} \nStatut: $statut",
                    ),
                    trailing: statut == "Non reçu"
                        ? ElevatedButton.icon(
                            onPressed:
                                _sendRelance, // Miantso ny fonction namboarina
                            icon: const Icon(
                              Icons.email_outlined,
                              size: 18,
                              color: Colors.white,
                            ),
                            label: const Text(
                              "Relancer",
                              style: TextStyle(color: Colors.white),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.redAccent,
                            ),
                          )
                        : const Icon(
                            Icons.check_circle,
                            color: Color(0xFF5C8D89),
                          ),
                  ),
                );
              },
            ),
    );
  }
}*/
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/declaration_service.dart';

class VoirDeclarationPage extends StatefulWidget {
  final String taxPayerNo;
  final String agentMatricule;

  const VoirDeclarationPage({
    Key? key,
    required this.taxPayerNo,
    required this.agentMatricule,
  }) : super(key: key);

  @override
  State<VoirDeclarationPage> createState() => _VoirDeclarationPageState();
}

class _VoirDeclarationPageState extends State<VoirDeclarationPage> {
  final DeclarationService _service = DeclarationService();
  List<dynamic> declarations = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadDeclarations();
  }

  Future<void> _loadDeclarations() async {
    try {
      final data = await _service.getDeclarations(widget.taxPayerNo);
      setState(() {
        declarations = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erreur: $e'),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  void _showAutoDismissDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext builderContext) {
        Timer(const Duration(seconds: 5), () {
          if (Navigator.of(builderContext).canPop()) {
            Navigator.of(builderContext).pop();
          }
        });
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Icon(Icons.check_circle, color: Color(0xFF5C8D89), size: 50),
              SizedBox(height: 15),
              Text(
                "Relance envoyée",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              SizedBox(height: 10),
              Text(
                "La relance a été transmise avec succès.",
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 15),
              LinearProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF5C8D89)),
                backgroundColor: Color(0xFFEEEEEE),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _sendRelance() async {
    try {
      await _service.sendAutoRelance(widget.taxPayerNo, widget.agentMatricule);
      if (!mounted) return;
      _showAutoDismissDialog(context);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Erreur: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7F9),
      appBar: AppBar(
        title: const Text(
          "Déclarations",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF4C6C89),
        elevation: 0,
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xFF4C6C89)),
            )
          : ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              itemCount: declarations.length,
              itemBuilder: (context, index) {
                final decl = declarations[index];
                final statut = decl['statut'] ?? '';
                final isNonRecu = statut == "Non reçu";
                final currencyFormat = NumberFormat('#,##0', 'fr_FR');

                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  elevation: 3,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // --- HEADER : N° ary Icon ---
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Déclaration N°${decl['N_decl'] ?? '-'}",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Color(0xFF4C6C89),
                              ),
                            ),
                            Icon(
                              isNonRecu
                                  ? Icons.pending_actions
                                  : Icons.check_circle,
                              color: isNonRecu
                                  ? Colors.orange
                                  : const Color(0xFF5C8D89),
                            ),
                          ],
                        ),
                        const Divider(height: 24),

                        // --- INFO DETAILS ---
                        _buildInfoRow(
                          Icons.label_important_outline,
                          "Type",
                          decl['tax_type_no'] ?? '-',
                        ),
                        _buildInfoRow(Icons.info_outline, "Statut", statut),

                        // Napetraka hifandimby (Wrap) fa tsy natao andalana iray mba tsy ho tapaka (No overflow)
                        _buildInfoRow(
                          Icons.calendar_today,
                          "Période",
                          decl['tax_periode'] != null
                              ? decl['tax_periode'].substring(0, 10)
                              : '-',
                        ),
                        _buildInfoRow(
                          Icons.event_busy,
                          "Échéance",
                          decl['date_echeance'] != null
                              ? DateTime.parse(
                                  decl['date_echeance'],
                                ).toLocal().toString().substring(0, 10)
                              : '-',
                        ),
                        _buildInfoRow(
                          Icons.event_available,
                          "Date reçue",
                          decl['received_date'] != null
                              ? DateTime.parse(
                                  decl['received_date'],
                                ).toLocal().toString().substring(0, 10)
                              : '-',
                        ),

                        // Motif : natao malalaka
                        _buildInfoRow(
                          Icons.chat_bubble_outline,
                          "Motif",
                          decl['motif'] ?? "-",
                          isLongText: true,
                        ),

                        const SizedBox(height: 16),

                        // --- FOOTER : Montant ary Bokotra ---
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade50,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Montant dû :",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  Text(
                                    '${currencyFormat.format(double.tryParse(decl['montant_liquide'].toString()) ?? 0)} Ar',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ],
                              ),
                              if (isNonRecu)
                                ElevatedButton.icon(
                                  onPressed: _sendRelance,
                                  icon: const Icon(
                                    Icons.send,
                                    size: 16,
                                    color: Colors.white,
                                  ),
                                  label: const Text(
                                    "Relancer",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.redAccent,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }

  // Widget hanatsarana ny fisehon'ny andalana tsirairay (tsy ho tapaka ny soratra)
  Widget _buildInfoRow(
    IconData icon,
    String label,
    String value, {
    bool isLongText = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: isLongText
            ? CrossAxisAlignment.start
            : CrossAxisAlignment.center,
        children: [
          Icon(icon, size: 18, color: Colors.blueGrey.shade300),
          const SizedBox(width: 10),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: const TextStyle(color: Colors.black87, fontSize: 14),
                children: [
                  TextSpan(
                    text: "$label: ",
                    style: const TextStyle(color: Colors.grey),
                  ),
                  TextSpan(
                    text: value,
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
