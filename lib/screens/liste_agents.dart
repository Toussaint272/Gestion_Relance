import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../model1/agent.dart';
import '../model1/centre.dart';

class ListeAgents extends StatefulWidget {
  const ListeAgents({super.key});

  @override
  State<ListeAgents> createState() => _ListeAgentsState();
}

class _ListeAgentsState extends State<ListeAgents> {
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

  Future<void> addAgent(Map<String, dynamic> data) async {
    try {
      final res = await http.post(
        Uri.parse(baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(data),
      );
      if (res.statusCode == 201) {
        final body = jsonDecode(res.body);
        setState(() => agents.add(Agent.fromJson(body)));
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Agent ajouté avec succès')),
        );
      } else {
        throw Exception('Erreur ajout (${res.statusCode})');
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Erreur : $e')));
    }
  }

  Future<void> updateAgent(int id, Map<String, dynamic> data) async {
    try {
      final res = await http.put(
        Uri.parse('$baseUrl/$id'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(data),
      );
      if (res.statusCode == 200) {
        final updated = Agent.fromJson(jsonDecode(res.body));
        setState(() {
          final index = agents.indexWhere((a) => a.id == id);
          if (index != -1) agents[index] = updated;
        });
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Agent modifié avec succès')),
        );
      } else {
        throw Exception('Erreur modification (${res.statusCode})');
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Erreur : $e')));
    }
  }

  Future<void> deleteAgent(int id) async {
    try {
      final res = await http.delete(Uri.parse('$baseUrl/$id'));
      if (res.statusCode == 200 || res.statusCode == 204) {
        setState(() => agents.removeWhere((a) => a.id == id));
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Agent supprimé avec succès')),
        );
      } else {
        throw Exception('Erreur suppression (${res.statusCode})');
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Erreur : $e')));
    }
  }

  void _showAgentDialog({Agent? agent}) {
    final isEdit = agent != null;
    final nomCtrl = TextEditingController(text: agent?.nom ?? '');
    final prenomCtrl = TextEditingController(text: agent?.prenom ?? '');
    final emailCtrl = TextEditingController(text: agent?.email ?? '');
    final matriculeCtrl = TextEditingController(text: agent?.matricule ?? '');
    final passCtrl = TextEditingController();
    int? selectedCentreId = agent?.idCentreGest;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(isEdit ? 'Modifier un agent' : 'Ajouter un agent'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nomCtrl,
                decoration: const InputDecoration(labelText: 'Nom'),
              ),
              TextField(
                controller: prenomCtrl,
                decoration: const InputDecoration(labelText: 'Prénom'),
              ),
              TextField(
                controller: emailCtrl,
                decoration: const InputDecoration(labelText: 'Email'),
              ),
              TextField(
                controller: matriculeCtrl,
                readOnly: true,
                decoration: const InputDecoration(
                  labelText: 'Matricule (généré automatiquement)',
                ),
              ),
              DropdownButtonFormField<int>(
                value: centres.any((c) => c.idCentreGest == selectedCentreId)
                    ? selectedCentreId
                    : null,
                decoration: const InputDecoration(
                  labelText: 'Centre de gestion et code_bureau',
                ),
                isExpanded: true, // ✅ atao true mba hitombo ny width
                items: centres.map((c) {
                  return DropdownMenuItem<int>(
                    value: c.idCentreGest,
                    child: Text('${c.codeBureau} - ${c.cgDesignation}'),
                  );
                }).toList(),
                onChanged: (val) {
                  setState(() {
                    selectedCentreId = val;
                  });
                },
              ),
              TextField(
                controller: passCtrl,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: isEdit
                      ? 'Nouveau mot de passe (laisser vide si inchangé)'
                      : 'Mot de passe',
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () {
              if (nomCtrl.text.isEmpty ||
                  prenomCtrl.text.isEmpty ||
                  emailCtrl.text.isEmpty ||
                  selectedCentreId == null ||
                  (!isEdit && passCtrl.text.isEmpty)) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Tous les champs sont obligatoires'),
                  ),
                );
                return;
              }

              final data = {
                "nom": nomCtrl.text,
                "prenom": prenomCtrl.text,
                "email": emailCtrl.text,
                "id_centre_gest": selectedCentreId,
              };
              if (passCtrl.text.isNotEmpty) data["password"] = passCtrl.text;

              if (isEdit) {
                updateAgent(agent!.id, data);
              } else {
                addAgent(data);
              }
            },
            child: Text(isEdit ? 'Modifier' : 'Enregistrer'),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(Agent agent) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmer la suppression'),
        content: Text(
          'Voulez-vous vraiment supprimer ${agent.nom} ${agent.prenom} ?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );
    if (confirm == true) deleteAgent(agent.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Liste des agents',
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
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(
                            Icons.edit,
                            color: Colors.blueAccent,
                          ),
                          tooltip: 'Modifier',
                          onPressed: () => _showAgentDialog(agent: a),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          tooltip: 'Supprimer',
                          onPressed: () => _confirmDelete(a),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Ajouter un agent',
        onPressed: () => _showAgentDialog(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
