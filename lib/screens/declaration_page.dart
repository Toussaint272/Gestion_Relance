import 'package:flutter/material.dart';
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
        backgroundColor: Colors.blueAccent,
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
                        : const Icon(Icons.check_circle, color: Colors.green),
                  ),
                );
              },
            ),
    );
  }
}
