/*import 'package:flutter/material.dart';
import '../models/declaration.dart';
import '../services/api_service.dart';
import 'package:intl/intl.dart';

class ListeDeclaration extends StatefulWidget {
  const ListeDeclaration({super.key});

  @override
  State<ListeDeclaration> createState() => _ListeDeclarationState();
}

class _ListeDeclarationState extends State<ListeDeclaration> {
  final ApiService apiService = ApiService();
  late Future<List<Declaration1>> futureDeclarations;

  @override
  void initState() {
    super.initState();
    futureDeclarations = apiService.fetchDeclarations();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Liste des Déclarations'),
        backgroundColor: const Color(0xFF4C6C89),
      ),
      body: FutureBuilder<List<Declaration1>>(
        future: futureDeclarations,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erreur : ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Aucune déclaration trouvée.'));
          } else {
            final declarations = snapshot.data!;
            return ListView.builder(
              itemCount: declarations.length,
              itemBuilder: (context, index) {
                final d = declarations[index];
                return Card(
                  margin: const EdgeInsets.all(8),
                  child: ListTile(
                    title: Text('Déclarant: ${d.taxPayerNo}'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Type: ${d.taxTypeNo ?? "-"}'),
                        Text(
                          'Période: ${d.taxPeriode?.substring(0, 10) ?? "-"}',
                        ),
                        /*Text(
                          'Date save: ${d.saveDate?.substring(0, 10) ?? "-"}',
                        ),*/
                        Text(
                          'Date reçue: ${d.receivedDate?.substring(0, 10) ?? "-"}',
                        ),
                        Text(
                          'Échéance: ${d.dateEcheance?.substring(0, 10) ?? "-"}',
                        ),
                        Text('Motif: ${d.motif ?? "-"}'),
                        /*Text(
                          'Montant du : ${NumberFormat('#,###').format(double.tryParse(d.montant_liquide.toString()) ?? 0)} Ar',
                        ),*/
                        Text(
                          'Montant dû : ${NumberFormat('#,##0', 'fr_FR').format(double.tryParse(d.montant_liquide.toString()) ?? 0)} Ar',
                          /*style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.teal,
                          ),*/
                        ),
                        // ✅ Affichage du statut
                        Text(
                          'Statut: ${d.statut ?? "-"}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF5C8D89), // safidio couleur mety
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}*/
import 'package:flutter/material.dart';
import '../models/declaration.dart';
import '../services/api_service.dart';
import 'package:intl/intl.dart';

class ListeDeclaration extends StatefulWidget {
  const ListeDeclaration({super.key});

  @override
  State<ListeDeclaration> createState() => _ListeDeclarationState();
}

class _ListeDeclarationState extends State<ListeDeclaration> {
  final ApiService apiService = ApiService();

  List<Declaration1> allDeclarations = []; // Mitahiry ny rehetra
  List<Declaration1> filteredDeclarations = []; // Izay voadio ihany
  bool isLoading = true;
  String errorMessage = '';

  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final data = await apiService.fetchDeclarations();
      setState(() {
        allDeclarations = data;
        filteredDeclarations = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
    }
  }

  // Fampiharana ny fikarohana
  void _onSearchChanged(String query) {
    setState(() {
      filteredDeclarations = allDeclarations
          .where(
            (d) =>
                d.taxPayerNo.toLowerCase().contains(query.toLowerCase()) ||
                (d.taxTypeNo?.toLowerCase().contains(query.toLowerCase()) ??
                    false),
          )
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7F9),
      appBar: AppBar(
        title: const Text(
          'Déclarations',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        elevation: 0,
        centerTitle: true,
        backgroundColor: const Color(0xFF4C6C89),
      ),
      body: Column(
        children: [
          // 🔍 SEARCH BAR SECTION
          Container(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 20),
            decoration: const BoxDecoration(
              color: Color(0xFF4C6C89),
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
            ),
            child: TextField(
              controller: _searchController,
              onChanged: _onSearchChanged,
              decoration: InputDecoration(
                hintText: 'Rechercher par NIF na Type...',
                prefixIcon: const Icon(Icons.search, color: Color(0xFF4C6C89)),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          _onSearchChanged('');
                        },
                      )
                    : null,
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
              ),
            ),
          ),

          // LIST SECTION
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : errorMessage.isNotEmpty
                ? Center(child: Text('Erreur : $errorMessage'))
                : filteredDeclarations.isEmpty
                ? _buildEmptyState()
                : RefreshIndicator(
                    onRefresh: _loadData,
                    child: ListView.builder(
                      padding: const EdgeInsets.all(12),
                      itemCount: filteredDeclarations.length,
                      itemBuilder: (context, index) {
                        return _buildDeclarationCard(
                          filteredDeclarations[index],
                        );
                      },
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildDeclarationCard(Declaration1 d) {
    final montantFormatted = NumberFormat(
      '#,##0',
      'fr_FR',
    ).format(double.tryParse(d.montant_liquide.toString()) ?? 0);

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.only(bottom: 12),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(
          backgroundColor: const Color(0xFF4C6C89).withOpacity(0.1),
          child: const Icon(
            Icons.description_outlined,
            color: Color(0xFF4C6C89),
          ),
        ),
        title: Text(
          'NIF: ${d.taxPayerNo}',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
        ),
        subtitle: Text(
          'Type: ${d.taxTypeNo ?? "-"}',
          style: const TextStyle(fontSize: 13),
        ),
        trailing: _buildStatusBadge(d.statut),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Column(
              children: [
                const Divider(),
                _infoRow(
                  Icons.event,
                  "Période",
                  d.taxPeriode?.substring(0, 10),
                ),
                _infoRow(
                  Icons.history,
                  "Reçue le",
                  d.receivedDate?.substring(0, 10),
                ),
                _infoRow(
                  Icons.priority_high,
                  "Échéance",
                  d.dateEcheance?.substring(0, 10),
                ),
                _infoRow(Icons.notes, "Motif", d.motif),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF5C8D89).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Montant dû",
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                      Text(
                        "$montantFormatted Ar",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Color(0xFF5C8D89),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoRow(IconData icon, String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.blueGrey),
          const SizedBox(width: 8),
          Text(
            "$label: ",
            style: const TextStyle(color: Colors.grey, fontSize: 13),
          ),
          Expanded(
            child: Text(
              value ?? "-",
              style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(String? statut) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFF5C8D89).withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        statut ?? "N/A",
        style: const TextStyle(
          color: Color(0xFF5C8D89),
          fontWeight: FontWeight.bold,
          fontSize: 11,
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off, size: 60, color: Colors.grey.shade300),
          const SizedBox(height: 10),
          const Text(
            "Aucun résultat trouvé",
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
