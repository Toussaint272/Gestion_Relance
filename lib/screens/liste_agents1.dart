import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../model1/agent.dart';
import '../model1/centre.dart';

class ListeAgents1 extends StatefulWidget {
  final bool readOnly; // ✅ Ajout d’un paramètre
  const ListeAgents1({super.key, this.readOnly = false});

  @override
  State<ListeAgents1> createState() => _ListeAgentsState();
}

class _ListeAgentsState extends State<ListeAgents1> {
  final String baseUrl = 'http://10.0.2.2:5000/api/users';
  final String centresUrl = 'http://10.0.2.2:5000/api/centres';
  List<Agent> agents = [];
  List<Centre> centres = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchCentres();
    fetchAgents();
  }

  Future<void> fetchCentres() async {
    try {
      final res = await http.get(Uri.parse(centresUrl));
      if (res.statusCode == 200) {
        final List data = jsonDecode(res.body);
        setState(() {
          centres = data.map((e) => Centre.fromJson(e)).toList();
        });
      }
    } catch (e) {
      debugPrint('Erreur fetch centres: $e');
    }
  }

  Future<void> fetchAgents() async {
    try {
      final res = await http.get(Uri.parse(baseUrl));
      if (res.statusCode == 200) {
        final List data = jsonDecode(res.body);
        final List agentData = data.where((u) => u['role'] == 'agent').toList();
        setState(() {
          agents = agentData.map((e) => Agent.fromJson(e)).toList();
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Erreur : $e')));
    }
  }

  // ✅ Build principale
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Liste des agents actifs',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF4C6C89),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: agents.length,
              itemBuilder: (context, i) {
                final a = agents[i];
                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 4,
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    leading: CircleAvatar(
                      backgroundColor: Colors.blueAccent,
                      child: Text(
                        a.nom.isNotEmpty ? a.nom[0] : '',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                    title: Text(
                      '${a.nom} ${a.prenom}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        Text('Email: ${a.email}'),
                        Text('Matricule: ${a.matricule}'),
                        Text(
                          'Centre: ${a.centreDesignation ?? "Inconnu"} (${a.codeBureau ?? "-"})',
                        ),
                      ],
                    ),
                    // ✅ Si readOnly = false => bouton modif/suppr visible
                  ),
                );
              },
            ),

      // ✅ Esorina le bouton ajout raha readOnly
    );
  }
}
