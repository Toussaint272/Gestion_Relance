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
      if (mounted) {
        setState(() {
          total = data['totalDefaillants'];
          defaillants = data['defaillants'];
          isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Erreur: $e"),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7F9), // Loko ambadika malefaka
      appBar: AppBar(
        title: const Text(
          "Contribuables Défaillants",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF4C6C89),
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
        elevation: 0,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                _buildHeaderCard(),
                Expanded(child: _buildResponsiveList()),
              ],
            ),
    );
  }

  // --- 1. CARD TOTAL (ERIGONOMIC DESIGN) ---
  Widget _buildHeaderCard() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF4C6C89), Color(0xFF6A8CAF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF4C6C89).withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          const Icon(Icons.group_off, color: Colors.white, size: 40),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Total Défaillants",
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
                Text(
                  total.toString(),
                  style: const TextStyle(
                    fontSize: 28,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- 2. RESPONSIVE LIST/GRID ---
  Widget _buildResponsiveList() {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Raha lehibe noho ny 700px ny ecran (Tablette/Web), mizara 2
        if (constraints.maxWidth > 700) {
          return GridView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 2.8,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: defaillants.length,
            itemBuilder: (context, index) => _buildItemCard(defaillants[index]),
          );
        } else {
          // Finday (Mobile)
          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            itemCount: defaillants.length,
            itemBuilder: (context, index) => _buildItemCard(defaillants[index]),
          );
        }
      },
    );
  }

  // --- 3. ITEM CARD (IHM OPTIMIZED) ---
  Widget _buildItemCard(dynamic d) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Sary kely (Avatar) mampiseho ny NIF
            CircleAvatar(
              backgroundColor: const Color(0xFFFEECEB),
              child: Icon(Icons.business, color: Colors.red[400]),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "NIF: ${d['tax_payer_no']}",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  _buildIconText(
                    Icons.person_outline,
                    d['contribuable'] ?? '-',
                  ),
                  _buildIconText(
                    Icons.location_city_outlined,
                    d['centre'] ?? '-',
                  ),
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.red[50],
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      "Motif: ${d['motif']}",
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.red[700],
                        fontWeight: FontWeight.w500,
                        fontStyle: FontStyle.italic,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIconText(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 2),
      child: Row(
        children: [
          Icon(icon, size: 14, color: Colors.grey[600]),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              text,
              style: TextStyle(fontSize: 13, color: Colors.grey[800]),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
