import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../model1/agent.dart';
import '../model1/centre.dart';
import '../config/api_endpoints.dart';

class ListeAgents1 extends StatefulWidget {
  final bool readOnly;
  const ListeAgents1({super.key, this.readOnly = true}); // Natao true default

  @override
  State<ListeAgents1> createState() => _ListeAgentsState();
}

class _ListeAgentsState extends State<ListeAgents1> {
  final String baseUrl = ApiEndpoints.users;
  final String centresUrl = ApiEndpoints.centres;

  List<Agent> agents = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchAgents();
  }

  Future<void> fetchAgents() async {
    try {
      final res = await http.get(Uri.parse(baseUrl));
      if (res.statusCode == 200) {
        final List data = jsonDecode(res.body);
        final List agentData = data.where((u) => u['role'] == 'agent').toList();
        if (mounted) {
          setState(() {
            agents = agentData.map((e) => Agent.fromJson(e)).toList();
            isLoading = false;
          });
        }
      }
    } catch (e) {
      if (mounted) setState(() => isLoading = false);
      debugPrint('Erreur: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7F9),
      appBar: AppBar(
        // ✅ Titre mampiseho ny fitambaran'ny agent
        title: Text(
          isLoading ? 'Chargement...' : 'Total Agents : ${agents.length}',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF4C6C89),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : agents.isEmpty
          ? _buildEmptyState()
          : ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              itemCount: agents.length,
              itemBuilder: (context, i) => _buildAgentCard(agents[i]),
            ),
    );
  }

  Widget _buildAgentCard(Agent agent) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            // Avatar boribory miaraka amin'ny initiale
            CircleAvatar(
              radius: 26,
              backgroundColor: const Color(0xFF4C6C89).withOpacity(0.1),
              child: Text(
                agent.nom.isNotEmpty ? agent.nom[0].toUpperCase() : '?',
                style: const TextStyle(
                  color: Color(0xFF4C6C89),
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
            const SizedBox(width: 16),
            // ✅ Nampiana Flexible eto mba tsy hisy overflow intsony
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '${agent.nom} ${agent.prenom}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Color(0xFF2C3E50),
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  const SizedBox(height: 4),
                  _buildIconInfo(Icons.email_outlined, agent.email),
                  _buildIconInfo(
                    Icons.badge_outlined,
                    'Matricule: ${agent.matricule ?? "-"}',
                  ),
                  _buildIconInfo(
                    Icons.location_on_outlined,
                    agent.centreDesignation ?? "DGI",
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget kely ho an'ny andalana tsirairay ao anaty Card
  Widget _buildIconInfo(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 2),
      child: Row(
        children: [
          Icon(icon, size: 14, color: Colors.blueGrey[400]),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(fontSize: 13, color: Colors.blueGrey[700]),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.people_outline, size: 70, color: Colors.grey[300]),
          const SizedBox(height: 10),
          const Text(
            "Aucun agent actif pour le moment",
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
