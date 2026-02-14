/*import 'package:flutter/material.dart';
import '../models/paiement.dart';
import '../services/paiement_service.dart';
import 'package:intl/intl.dart';

class ListePaiementPage extends StatefulWidget {
  const ListePaiementPage({Key? key}) : super(key: key);

  @override
  State<ListePaiementPage> createState() => _ListePaiementPageState();
}

class _ListePaiementPageState extends State<ListePaiementPage> {
  late Future<List<Paiement1>> paiements;

  @override
  void initState() {
    super.initState();
    paiements = PaiementService.fetchPaiements();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Liste des Paiements"),
        backgroundColor: const Color(0xFF4C6C89),
      ),
      body: FutureBuilder<List<Paiement1>>(
        future: paiements,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                "Erreur : ${snapshot.error}",
                style: const TextStyle(color: Colors.red),
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("Aucun paiement trouvé."));
          }

          final data = snapshot.data!;

          return ListView.builder(
            padding: const EdgeInsets.all(10),
            itemCount: data.length,
            itemBuilder: (context, index) {
              final p = data[index];
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
                      p.idPaiement.toString(),
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  title: Text(
                    p.contribuable,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Declaration : ${p.taxPayerNo}"),
                      //Text("N_Déclaration : ${p.nDecl}"),
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
                      Text("Mode_paiement : ${p.modePaiement}"),
                      Text(
                        "Date_paiement : ${p.datePaiement.toLocal().toIso8601String().split('T').first}",
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
import 'package:flutter/material.dart';
import '../models/paiement.dart';
import '../services/paiement_service.dart';
import 'package:intl/intl.dart';

class ListePaiementPage extends StatefulWidget {
  const ListePaiementPage({Key? key}) : super(key: key);

  @override
  State<ListePaiementPage> createState() => _ListePaiementPageState();
}

class _ListePaiementPageState extends State<ListePaiementPage> {
  List<Paiement1> allPaiements = [];
  List<Paiement1> filteredPaiements = [];
  bool isLoading = true;
  String errorMessage = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    try {
      final data = await PaiementService.fetchPaiements();
      setState(() {
        allPaiements = data;
        filteredPaiements = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
    }
  }

  void _onSearch(String query) {
    setState(() {
      filteredPaiements = allPaiements
          .where(
            (p) =>
                p.contribuable.toLowerCase().contains(query.toLowerCase()) ||
                p.taxPayerNo.toLowerCase().contains(query.toLowerCase()),
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
          "Liste des Paiements",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF4C6C89),
        elevation: 0,
      ),
      body: Column(
        children: [
          // --- BARRE DE RECHERCHE ---
          Container(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 20),
            decoration: const BoxDecoration(
              color: Color(0xFF4C6C89),
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
            ),
            child: TextField(
              controller: _searchController,
              onChanged: _onSearch,
              decoration: InputDecoration(
                hintText: 'Rechercher contribuable na NIF...',
                prefixIcon: const Icon(Icons.search, color: Color(0xFF4C6C89)),
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

          // --- LISTE ---
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : errorMessage.isNotEmpty
                ? Center(
                    child: Text(
                      "Erreur : $errorMessage",
                      style: const TextStyle(color: Colors.red),
                    ),
                  )
                : filteredPaiements.isEmpty
                ? const Center(child: Text("Aucun paiement trouvé."))
                : RefreshIndicator(
                    onRefresh: _fetchData,
                    child: ListView.builder(
                      padding: const EdgeInsets.all(12),
                      itemCount: filteredPaiements.length,
                      itemBuilder: (context, index) {
                        return _buildPaiementCard(filteredPaiements[index]);
                      },
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaiementCard(Paiement1 p) {
    final bool isSolde =
        (double.tryParse(p.resteARecouvrer.toString()) ?? 0) <= 0;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.only(bottom: 12),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(
          backgroundColor: const Color(0xFF4C6C89).withOpacity(0.1),
          child: const Icon(Icons.payments_outlined, color: Color(0xFF4C6C89)),
        ),
        title: Text(
          p.contribuable,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
        ),
        subtitle: Text(
          "NIF: ${p.taxPayerNo}",
          style: const TextStyle(fontSize: 13),
        ),
        trailing: Icon(
          isSolde ? Icons.check_circle : Icons.pending_actions,
          color: isSolde ? const Color(0xFF5C8D89) : const Color(0xFFD9534F),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Column(
              children: [
                const Divider(),
                _infoRow(
                  Icons.calendar_today,
                  "Date paiement",
                  p.datePaiement.toLocal().toString().split(' ')[0],
                ),
                _infoRow(
                  Icons.account_balance_wallet_outlined,
                  "Mode",
                  p.modePaiement,
                ),
                const SizedBox(height: 12),

                // --- SECTION MONTANTS ---
                Row(
                  children: [
                    _montantBox("Payé", p.montantPayer, Colors.blueGrey),
                    const SizedBox(width: 10),
                    _montantBox(
                      "Reste",
                      p.resteARecouvrer,
                      isSolde
                          ? const Color(0xFF5C8D89)
                          : const Color(0xFFD9534F),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 14, color: Colors.grey),
          const SizedBox(width: 8),
          Text(
            "$label: ",
            style: const TextStyle(color: Colors.grey, fontSize: 13),
          ),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13),
          ),
        ],
      ),
    );
  }

  Widget _montantBox(String label, dynamic montant, Color color) {
    final formatted = NumberFormat(
      '#,##0',
      'fr_FR',
    ).format(double.tryParse(montant.toString()) ?? 0);
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: color.withOpacity(0.05),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: color.withOpacity(0.2)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: TextStyle(fontSize: 11, color: color)),
            Text(
              "$formatted Ar",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13,
                color: color,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
