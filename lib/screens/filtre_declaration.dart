import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AdminDeclarationsPage extends StatefulWidget {
  const AdminDeclarationsPage({super.key});

  @override
  State<AdminDeclarationsPage> createState() => _AdminDeclarationsPageState();
}

class _AdminDeclarationsPageState extends State<AdminDeclarationsPage> {
  List declarations = [];
  bool isLoading = false;

  String selectedType = 'Tous';
  DateTime? dateDebut;
  DateTime? dateFin;

  final String baseUrl =
      'http://10.0.2.2:5000/api/declarationFiltreRoute/filtre';

  Future<void> fetchDeclarations() async {
    setState(() => isLoading = true);

    // 🔹 Préparer query params
    final queryParams = {
      'type': selectedType,
      if (dateDebut != null)
        'dateDebut': dateDebut!.toIso8601String().split('T')[0],
      if (dateFin != null) 'dateFin': dateFin!.toIso8601String().split('T')[0],
    };

    final uri = Uri.parse(baseUrl).replace(queryParameters: queryParams);

    try {
      final res = await http.get(uri);
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);

        setState(() {
          // ✅ Prendre la liste dans le champ "declarations"
          declarations = data['declarations'] ?? [];
          isLoading = false;
        });
      } else {
        throw Exception('Erreur serveur: ${res.statusCode}');
      }
    } catch (e) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Erreur: $e')));
    }
  }

  Future<void> selectDate(bool isStart) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2030),
    );

    if (picked != null) {
      setState(() {
        if (isStart) {
          dateDebut = picked;
        } else {
          dateFin = picked;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          ' Déclarations par type & période',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF4C6C89),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: selectedType,
                    items: ['Tous', 'TVA', 'IRSA', 'IS', 'IR']
                        .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                        .toList(),
                    decoration: const InputDecoration(
                      labelText: 'Type d\'impôt',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (v) => setState(() => selectedType = v!),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton.icon(
                  onPressed: fetchDeclarations,
                  icon: const Icon(Icons.search),
                  label: const Text('Filtrer'),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () => selectDate(true),
                  child: Text(
                    dateDebut == null
                        ? 'Date début'
                        : 'Début: ${dateDebut!.toLocal().toString().split(' ')[0]}',
                  ),
                ),
                ElevatedButton(
                  onPressed: () => selectDate(false),
                  child: Text(
                    dateFin == null
                        ? 'Date fin'
                        : 'Fin: ${dateFin!.toLocal().toString().split(' ')[0]}',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : declarations.isEmpty
                  ? const Center(child: Text('Aucune déclaration trouvée'))
                  : ListView.builder(
                      itemCount: declarations.length,
                      itemBuilder: (context, index) {
                        final d = declarations[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          child: ListTile(
                            title: Text(
                              "${d['tax_type_no']} - ${d['motif'] ?? 'Aucun motif'}",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text(
                              "NIF: ${d['tax_payer_no'] ?? '---'}\n"
                              "Période: ${d['tax_periode']?.substring(0, 10) ?? '---'}\n"
                              "Montant: ${d['montant_liquide'] ?? 0} Ar\n"
                              "Statut: ${d['statut'] ?? '---'}",
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
