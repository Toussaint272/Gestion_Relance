/*import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:my_app/screens/login_screen.dart';
import '../model1/agent.dart';
import '../model1/centre.dart';
import '../config/api_endpoints.dart';

class ListeAgents extends StatefulWidget {
  const ListeAgents({super.key});

  @override
  State<ListeAgents> createState() => _ListeAgentsState();
}

class _ListeAgentsState extends State<ListeAgents> {
  final String baseUrl = ApiEndpoints.users;
  final String centresUrl = ApiEndpoints.centres;

  List<Agent> agents = [];
  List<Centre> centres = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchCentres();
    fetchAgents();
  }

  // --- 1. LOGIQUE CONNECTION & CONFIRMATION ---
  Future<void> _confirmConnection(Agent agent) async {
    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Confirmation"),
        content: Text(
          "Voulez-vous vous connecter en tant que ${agent.nom} ${agent.prenom} ?",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text("Annuler"),
          ),
          TextButton(
            /*style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4C6C89),
            ),*/
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text(
              "Oui, continuer",
              style: TextStyle(color: Colors.green),
            ),
          ),
        ],
      ),
    );

    if (confirm == true) {
      if (Navigator.canPop(context))
        Navigator.pop(context); // Akatona ny BottomSheet
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
        (route) => false,
      );
    }
  }

  // --- 2. INTERFACE DETAIL (BOTTOM SHEET) ---
  void _showAgentDetails(Agent agent) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            const SizedBox(height: 20),
            CircleAvatar(
              radius: 40,
              backgroundColor: const Color(0xFF4C6C89).withOpacity(0.1),
              child: Text(
                agent.nom[0].toUpperCase(),
                style: const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF4C6C89),
                ),
              ),
            ),
            const SizedBox(height: 15),
            Text(
              '${agent.nom} ${agent.prenom}',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const Divider(height: 30),
            _buildDetailItem(
              Icons.badge_outlined,
              "Matricule",
              agent.matricule ?? '',
            ),
            _buildDetailItem(Icons.email_outlined, "Email", agent.email),
            _buildDetailItem(
              Icons.business_outlined,
              "Centre",
              agent.centreDesignation ?? "DGI",
            ),
            const SizedBox(height: 25),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.login_rounded, color: Colors.white),
                label: const Text(
                  "Se Connecter",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2E7D32),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                onPressed: () => _confirmConnection(agent),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  "Fermer",
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- 3. DIALOG AJOUT / MODIFICATION ---
  void _showAgentDialog({Agent? agent}) {
    final isEdit = agent != null;
    final nomCtrl = TextEditingController(text: agent?.nom ?? '');
    final prenomCtrl = TextEditingController(text: agent?.prenom ?? '');
    final emailCtrl = TextEditingController(text: agent?.email ?? '');
    final matriculeCtrl = TextEditingController(text: agent?.matricule ?? '');
    final passCtrl = TextEditingController();
    int? selectedCentreId = agent?.idCentreGest;
    bool obscurePassword = true;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(
            isEdit ? 'Modifier l\'Agent' : 'Nouvel Agent',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          content: SizedBox(
            width: double.maxFinite,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildInput(nomCtrl, 'Nom', Icons.person),
                  _buildInput(prenomCtrl, 'Prénom', Icons.person_outline),
                  _buildInput(
                    emailCtrl,
                    'Email',
                    Icons.email,
                    type: TextInputType.emailAddress,
                  ),
                  _buildInput(
                    matriculeCtrl,
                    'Matricule (Auto)',
                    Icons.badge,
                    readOnly: true,
                  ),
                  const SizedBox(height: 10),
                  DropdownButtonFormField<int>(
                    isExpanded: true,
                    value:
                        centres.any((c) => c.idCentreGest == selectedCentreId)
                        ? selectedCentreId
                        : null,
                    decoration: InputDecoration(
                      labelText: 'Centre de gestion',
                      prefixIcon: const Icon(Icons.location_city, size: 20),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    items: centres
                        .map(
                          (c) => DropdownMenuItem(
                            value: c.idCentreGest,
                            child: Text(
                              '${c.codeBureau} - ${c.cgDesignation}',
                              style: const TextStyle(fontSize: 11),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        )
                        .toList(),
                    onChanged: (val) => selectedCentreId = val,
                  ),
                  _buildInput(
                    passCtrl,
                    isEdit ? 'Nouveau mot de passe' : 'Mot de passe',
                    Icons.lock,
                    obscure: obscurePassword,
                    suffix: IconButton(
                      icon: Icon(
                        obscurePassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: Colors.grey,
                      ),
                      onPressed: () => setDialogState(
                        () => obscurePassword = !obscurePassword,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Annuler'),
            ),
            TextButton(
              /*style: TextButton.styleFrom(
                backgroundColor: const Color(0xFF4C6C89),
                shape: const StadiumBorder(),
              ),*/
              onPressed: () {
                if (nomCtrl.text.isEmpty ||
                    emailCtrl.text.isEmpty ||
                    selectedCentreId == null)
                  return;
                final data = {
                  "nom": nomCtrl.text,
                  "prenom": prenomCtrl.text,
                  "email": emailCtrl.text,
                  "id_centre_gest": selectedCentreId,
                  "role": "agent",
                };
                if (passCtrl.text.isNotEmpty) data["password"] = passCtrl.text;
                isEdit ? updateAgent(agent.id, data) : addAgent(data);
              },
              child: const Text(
                'Enregistrer',
                style: TextStyle(color: const Color(0xFF4C6C89)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- 4. WIDGETS REUSABLES ---
  Widget _buildInput(
    TextEditingController ctrl,
    String label,
    IconData icon, {
    bool readOnly = false,
    bool obscure = false,
    TextInputType type = TextInputType.text,
    Widget? suffix,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        controller: ctrl,
        readOnly: readOnly,
        obscureText: obscure,
        keyboardType: type,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, size: 20),
          suffixIcon: suffix,
          filled: readOnly,
          fillColor: readOnly ? Colors.grey.shade100 : null,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }

  Widget _buildDetailItem(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: const Color(0xFF4C6C89), size: 22),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(color: Colors.grey, fontSize: 11),
                ),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                  softWrap: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- 5. LOGIQUE API (CRUD) ---
  Future<void> fetchCentres() async {
    try {
      final res = await http.get(Uri.parse(centresUrl));
      if (res.statusCode == 200) {
        final List data = jsonDecode(res.body);
        setState(() => centres = data.map((e) => Centre.fromJson(e)).toList());
      }
    } catch (e) {
      debugPrint('Erreur centres: $e');
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
      _showSimpleError('Erreur chargement: $e');
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
        fetchAgents(); // Refresh liste
        Navigator.pop(context);
        _showCenteredSuccess('Agent ajouté');
      }
    } catch (e) {
      _showSimpleError('Erreur : $e');
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
        fetchAgents(); // Refresh liste
        Navigator.pop(context);
        _showCenteredSuccess('Mise à jour réussie');
      }
    } catch (e) {
      _showSimpleError('Erreur : $e');
    }
  }

  Future<void> deleteAgent(Agent agent) async {
    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Supprimer l'agent"),
        content: Text(
          "Voulez-vous vraiment supprimer ${agent.nom} ? Cette action est définitive.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text("Annuler"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text(
              "Supprimer",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        final res = await http.delete(Uri.parse('$baseUrl/${agent.id}'));
        if (res.statusCode == 200 || res.statusCode == 204) {
          setState(() => agents.removeWhere((a) => a.id == agent.id));
          _showCenteredSuccess('Agent supprimé');
        }
      } catch (e) {
        _showSimpleError('Erreur : $e');
      }
    }
  }

  void _showSimpleError(String m) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(m)));

  void _showCenteredSuccess(String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        Future.delayed(
          const Duration(milliseconds: 1500),
          () => Navigator.canPop(ctx) ? Navigator.pop(ctx) : null,
        );
        return Center(
          child: Material(
            color: Colors.transparent,
            child: Container(
              padding: const EdgeInsets.all(25),
              decoration: BoxDecoration(
                color: const Color(0xFF2C3E50).withOpacity(0.9),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.check_circle,
                    color: Colors.greenAccent,
                    size: 50,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    message,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text(
          'Gestion des Agents',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF4C6C89),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: agents.length,
              itemBuilder: (context, i) {
                final a = agents[i];
                return Card(
                  margin: const EdgeInsets.only(bottom: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: ListTile(
                    onTap: () => _showAgentDetails(a),
                    leading: CircleAvatar(
                      backgroundColor: const Color(0xFF4C6C89).withOpacity(0.1),
                      child: Text(a.nom[0]),
                    ),
                    title: Text(
                      '${a.nom} ${a.prenom}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: Text(a.email, overflow: TextOverflow.ellipsis),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(
                            Icons.edit,
                            color: Colors.blue,
                            size: 20,
                          ),
                          onPressed: () => _showAgentDialog(agent: a),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.delete,
                            color: Colors.red,
                            size: 20,
                          ),
                          onPressed: () => deleteAgent(a),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: const Color(0xFF4C6C89),
        onPressed: () => _showAgentDialog(),
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text(
          'Ajouter Agent',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}*/
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:my_app/screens/login_screen.dart';
import '../model1/agent.dart';
import '../model1/centre.dart';
import '../config/api_endpoints.dart';

class ListeAgents extends StatefulWidget {
  const ListeAgents({super.key});

  @override
  State<ListeAgents> createState() => _ListeAgentsState();
}

class _ListeAgentsState extends State<ListeAgents> {
  final String baseUrl = ApiEndpoints.users;
  final String centresUrl = ApiEndpoints.centres;

  List<Agent> agents = [];
  List<Centre> centres = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchCentres();
    fetchAgents();
  }

  // --- 1. LOGIQUE CONNECTION & CONFIRMATION ---
  Future<void> _confirmConnection(Agent agent) async {
    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Confirmation"),
        content: Text(
          "Voulez-vous vous connecter en tant que ${agent.nom} ${agent.prenom} ?",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text("Annuler"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text(
              "Oui, continuer",
              style: TextStyle(
                color: Colors.green,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );

    if (confirm == true) {
      if (Navigator.canPop(context)) Navigator.pop(context);
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
        (route) => false,
      );
    }
  }

  // --- 2. INTERFACE DETAIL (BOTTOM SHEET) ---
  void _showAgentDetails(Agent agent) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            const SizedBox(height: 20),
            // ✅ AVATAR VOAHITSY (DETAILS)
            CircleAvatar(
              radius: 40,
              backgroundColor: const Color(0xFF4C6C89).withOpacity(0.1),
              child: Text(
                agent.nom[0].toUpperCase(),
                style: const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF4C6C89), // Mitovy amin'ny loko FAB
                ),
              ),
            ),
            const SizedBox(height: 15),
            Text(
              '${agent.nom} ${agent.prenom}',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const Divider(height: 30),
            _buildDetailItem(
              Icons.badge_outlined,
              "Matricule",
              agent.matricule ?? '',
            ),
            _buildDetailItem(Icons.email_outlined, "Email", agent.email),
            _buildDetailItem(
              Icons.business_outlined,
              "Centre",
              agent.centreDesignation ?? "DGI",
            ),
            const SizedBox(height: 25),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.login_rounded, color: Colors.white),
                label: const Text(
                  "Se Connecter",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2E7D32),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                onPressed: () => _confirmConnection(agent),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  "Fermer",
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- 3. DIALOG AJOUT / MODIFICATION ---
  void _showAgentDialog({Agent? agent}) {
    final isEdit = agent != null;
    final nomCtrl = TextEditingController(text: agent?.nom ?? '');
    final prenomCtrl = TextEditingController(text: agent?.prenom ?? '');
    final emailCtrl = TextEditingController(text: agent?.email ?? '');
    final matriculeCtrl = TextEditingController(text: agent?.matricule ?? '');
    final passCtrl = TextEditingController();
    int? selectedCentreId = agent?.idCentreGest;
    bool obscurePassword = true;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(
            isEdit ? 'Modifier l\'Agent' : 'Nouvel Agent',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          content: SizedBox(
            width: double.maxFinite,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildInput(nomCtrl, 'Nom', Icons.person),
                  _buildInput(prenomCtrl, 'Prénom', Icons.person_outline),
                  _buildInput(
                    emailCtrl,
                    'Email',
                    Icons.email,
                    type: TextInputType.emailAddress,
                  ),
                  _buildInput(
                    matriculeCtrl,
                    'Matricule (Auto)',
                    Icons.badge,
                    readOnly: true,
                  ),
                  const SizedBox(height: 10),
                  DropdownButtonFormField<int>(
                    isExpanded: true,
                    value:
                        centres.any((c) => c.idCentreGest == selectedCentreId)
                        ? selectedCentreId
                        : null,
                    decoration: InputDecoration(
                      labelText: 'Centre de gestion',
                      prefixIcon: const Icon(Icons.location_city, size: 20),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    items: centres
                        .map(
                          (c) => DropdownMenuItem(
                            value: c.idCentreGest,
                            child: Text(
                              '${c.codeBureau} - ${c.cgDesignation}',
                              style: const TextStyle(fontSize: 11),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        )
                        .toList(),
                    onChanged: (val) => selectedCentreId = val,
                  ),
                  _buildInput(
                    passCtrl,
                    isEdit ? 'Nouveau mot de passe' : 'Mot de passe',
                    Icons.lock,
                    obscure: obscurePassword,
                    suffix: IconButton(
                      icon: Icon(
                        obscurePassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: Colors.grey,
                      ),
                      onPressed: () => setDialogState(
                        () => obscurePassword = !obscurePassword,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Annuler'),
            ),
            TextButton(
              onPressed: () {
                if (nomCtrl.text.isEmpty ||
                    emailCtrl.text.isEmpty ||
                    selectedCentreId == null)
                  return;
                final data = {
                  "nom": nomCtrl.text,
                  "prenom": prenomCtrl.text,
                  "email": emailCtrl.text,
                  "id_centre_gest": selectedCentreId,
                  "role": "agent",
                };
                if (passCtrl.text.isNotEmpty) data["password"] = passCtrl.text;
                isEdit ? updateAgent(agent.id, data) : addAgent(data);
              },
              child: const Text(
                'Enregistrer',
                style: TextStyle(
                  color: Color(0xFF4C6C89),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- 4. WIDGETS REUSABLES ---

  // ✅ _buildInput VOAHITSY (Column + CrossAxisAlignment)
  Widget _buildInput(
    TextEditingController ctrl,
    String label,
    IconData icon, {
    bool readOnly = false,
    bool obscure = false,
    TextInputType type = TextInputType.text,
    Widget? suffix,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: ctrl,
            readOnly: readOnly,
            obscureText: obscure,
            keyboardType: type,
            decoration: InputDecoration(
              labelText: label,
              prefixIcon: Icon(icon, size: 20, color: const Color(0xFF4C6C89)),
              suffixIcon: suffix,
              filled: readOnly,
              fillColor: readOnly ? Colors.grey.shade100 : Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: Color(0xFF4C6C89),
                  width: 1.5,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailItem(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: const Color(0xFF4C6C89), size: 22),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(color: Colors.grey, fontSize: 11),
                ),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                  softWrap: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- 5. LOGIQUE API (CRUD) ---
  Future<void> fetchCentres() async {
    try {
      final res = await http.get(Uri.parse(centresUrl));
      if (res.statusCode == 200) {
        final List data = jsonDecode(res.body);
        setState(() => centres = data.map((e) => Centre.fromJson(e)).toList());
      }
    } catch (e) {
      debugPrint('Erreur centres: $e');
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
      _showSimpleError('Erreur chargement: $e');
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
        fetchAgents();
        Navigator.pop(context);
        _showCenteredSuccess('Agent ajouté');
      }
    } catch (e) {
      _showSimpleError('Erreur : $e');
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
        fetchAgents();
        Navigator.pop(context);
        _showCenteredSuccess('Mise à jour réussie');
      }
    } catch (e) {
      _showSimpleError('Erreur : $e');
    }
  }

  Future<void> deleteAgent(Agent agent) async {
    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Supprimer l'agent"),
        content: Text(
          "Voulez-vous vraiment supprimer ${agent.nom} ? Cette action est définitive.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text("Annuler"),
          ),
          TextButton(
            /*style: ElevatedButton.styleFrom(backgroundColor: Colors.red),*/
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text("Supprimer", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        final res = await http.delete(Uri.parse('$baseUrl/${agent.id}'));
        if (res.statusCode == 200 || res.statusCode == 204) {
          setState(() => agents.removeWhere((a) => a.id == agent.id));
          _showCenteredSuccess('Agent supprimé');
        }
      } catch (e) {
        _showSimpleError('Erreur : $e');
      }
    }
  }

  void _showSimpleError(String m) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(m)));

  void _showCenteredSuccess(String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        Future.delayed(
          const Duration(milliseconds: 1500),
          () => Navigator.canPop(ctx) ? Navigator.pop(ctx) : null,
        );
        return Center(
          child: Material(
            color: Colors.transparent,
            child: Container(
              padding: const EdgeInsets.all(25),
              decoration: BoxDecoration(
                color: const Color(0xFF2C3E50).withOpacity(0.9),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.check_circle,
                    color: Colors.greenAccent,
                    size: 50,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    message,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text(
          'Gestion des Agents',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF4C6C89),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: agents.length,
              itemBuilder: (context, i) {
                final a = agents[i];
                return Card(
                  margin: const EdgeInsets.only(bottom: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: ListTile(
                    onTap: () => _showAgentDetails(a),
                    // ✅ AVATAR VOAHITSY (LISTE)
                    leading: CircleAvatar(
                      backgroundColor: const Color(0xFF4C6C89).withOpacity(0.1),
                      child: Text(
                        a.nom[0].toUpperCase(),
                        style: const TextStyle(
                          color: Color(0xFF4C6C89), // Loko manga
                          fontWeight: FontWeight.bold, // Gras
                          fontSize: 16,
                        ),
                      ),
                    ),
                    title: Text(
                      '${a.nom} ${a.prenom}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: Text(a.email, overflow: TextOverflow.ellipsis),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(
                            Icons.edit,
                            color: Colors.blue,
                            size: 20,
                          ),
                          onPressed: () => _showAgentDialog(agent: a),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.delete,
                            color: Colors.red,
                            size: 20,
                          ),
                          onPressed: () => deleteAgent(a),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: const Color(0xFF4C6C89),
        onPressed: () => _showAgentDialog(),
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text(
          'Ajouter Agent',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
