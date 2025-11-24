import 'package:flutter/material.dart';
import '../services/totaldefaillant_service.dart';

class DefaillantsPage2 extends StatefulWidget {
  const DefaillantsPage2({super.key});

  @override
  State<DefaillantsPage2> createState() => _DefaillantsPageState();
}

class _DefaillantsPageState extends State<DefaillantsPage2> {
  final DefaillantService service = DefaillantService();

  bool isLoading = true;
  int total = 0;
  List<dynamic> defaillants = [];

  @override
  void initState() {
    super.initState();
    fetchDefaillants();
  }

  Future<void> fetchDefaillants() async {
    try {
      final data = await service.getDefaillants();
      setState(() {
        total = data['totalDefaillants'];
        defaillants = data['defaillants'];
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Erreur: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Contribuables Défaillants",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF4C6C89),
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
      ),

      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // ──────────────────────────────
                // CARD TOTAL
                // ──────────────────────────────
                Container(
                  margin: const EdgeInsets.all(12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF4C6C89),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Total Défaillants",
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        total.toString(),
                        style: const TextStyle(
                          fontSize: 22,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),

                // ──────────────────────────────
                // LISTE DÉFAILLANTS
                // ──────────────────────────────
                Expanded(
                  child: ListView.builder(
                    itemCount: defaillants.length,
                    itemBuilder: (context, index) {
                      final d = defaillants[index];
                      return Card(
                        elevation: 3,
                        margin: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          /*leading: CircleAvatar(
                            backgroundColor: Colors.deepOrange,
                            child: Text(
                              d['tax_payer_no'][0],
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),*/
                          title: Text(
                            "NIF : ${d['tax_payer_no']}",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Contribuable : ${d['contribuable'] ?? '-'}",
                              ),
                              Text("Centre : ${d['centre'] ?? '-'}"),
                              Text(
                                "Motif : ${d['motif']}",
                                style: const TextStyle(
                                  fontStyle: FontStyle.italic,
                                  color: Colors.red,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
