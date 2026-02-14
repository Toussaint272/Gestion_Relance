/*import 'package:flutter/material.dart';
import '../services/defaillant_service.dart';

class DefaillantsPage extends StatefulWidget {
  const DefaillantsPage({super.key});

  @override
  State<DefaillantsPage> createState() => _DefaillantsPageState();
}

class _DefaillantsPageState extends State<DefaillantsPage> {
  String? selectedCentre;
  bool isLoading = false;
  bool isLoadingCentres = false;
  List<String> centres = [];
  List defaillants = [];

  @override
  void initState() {
    super.initState();
    _loadCentres();
  }

  Future<void> _loadCentres() async {
    setState(() => isLoadingCentres = true);
    try {
      centres = await ApiService.getCentres();
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Erreur chargement centres : $e")));
    } finally {
      setState(() => isLoadingCentres = false);
    }
  }

  Future<void> fetchDefaillants() async {
    if (selectedCentre == null) return;

    setState(() => isLoading = true);
    try {
      final data = await ApiService.getDefaillants(selectedCentre!);
      setState(() {
        defaillants = data['defaillants'];
      });
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Erreur : $e")));
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Défaillants par centre fiscal',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF4C6C89),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Dropdown pour le centre fiscal
            isLoadingCentres
                ? const Center(child: CircularProgressIndicator())
                : DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      labelText: "Sélectionner un centre fiscal",
                      border: OutlineInputBorder(),
                    ),
                    value: selectedCentre,
                    items: centres.map((centre) {
                      return DropdownMenuItem(
                        value: centre,
                        child: Text(centre),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() => selectedCentre = value);
                      fetchDefaillants(); // automatique après sélection
                    },
                  ),

            const SizedBox(height: 12),

            // Bouton pour charger les défaillants
            /*ElevatedButton.icon(
              onPressed: fetchDefaillants,
              icon: const Icon(Icons.search),
              label: const Text("Afficher"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                foregroundColor: Colors.white,
              ),
            ),*/
            const SizedBox(height: 20),

            // Liste des défaillants
            Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : defaillants.isEmpty
                  ? const Center(child: Text("Aucun contribuable défaillant"))
                  : ListView.builder(
                      itemCount: defaillants.length,
                      itemBuilder: (context, index) {
                        final d = defaillants[index];
                        return Card(
                          elevation: 3,
                          margin: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: const [
                                    Icon(
                                      Icons.warning,
                                      color: Color(0xFFD9534F),
                                    ),
                                    SizedBox(width: 8),
                                    Text(
                                      "Contribuable Défaillant",
                                      /*style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),*/
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  "NIF : ${d['tax_payer_no']}",
                                  /*style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),*/
                                ),

                                const SizedBox(height: 8),
                                Text(
                                  "Contribuable : ${d['rs']}",
                                  /*style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),*/
                                ),
                                /*Text("Motif : ${d['motif'] ?? '-'}"),*/
                                Text(
                                  "Motif : ${d['motif'] ?? '-'}",
                                  style: const TextStyle(
                                    fontStyle: FontStyle.italic,
                                    color: Color(0xFFD9534F),
                                  ),
                                ),
                                Text("Centre : ${d['centre'] ?? '-'}"),
                                Text("Adresse : ${d['adresse'] ?? '-'}"),
                                Text("Activité : ${d['activite'] ?? '-'}"),
                                Text("Téléphone : ${d['phone'] ?? '-'}"),
                                Text(
                                  "Statut : ${d['actif'] == true ? "Actif" : "Inactif"}",
                                  style: TextStyle(
                                    color: d['actif'] == true
                                        ? Color(0xFF5C8D89)
                                        : Color(0xFFD9534F),
                                    fontWeight: FontWeight.bold,
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
      ),
    );
  }
}*/
import 'package:flutter/material.dart';
import '../services/defaillant_service.dart';

class DefaillantsPage extends StatefulWidget {
  const DefaillantsPage({super.key});

  @override
  State<DefaillantsPage> createState() => _DefaillantsPageState();
}

class _DefaillantsPageState extends State<DefaillantsPage> {
  String? selectedCentre;
  bool isLoading = false;
  bool isLoadingCentres = false;
  List<String> centres = [];
  List defaillants = [];

  @override
  void initState() {
    super.initState();
    _loadCentres();
  }

  Future<void> _loadCentres() async {
    setState(() => isLoadingCentres = true);
    try {
      centres = await ApiService.getCentres();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Erreur chargement centres : $e"),
          backgroundColor: Colors.redAccent,
        ),
      );
    } finally {
      setState(() => isLoadingCentres = false);
    }
  }

  Future<void> fetchDefaillants() async {
    if (selectedCentre == null) return;
    setState(() => isLoading = true);
    try {
      final data = await ApiService.getDefaillants(selectedCentre!);
      setState(() {
        defaillants = data['defaillants'];
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Erreur : $e"),
          backgroundColor: Colors.redAccent,
        ),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7F9),
      appBar: AppBar(
        title: const Text(
          'Défaillants par centre fiscal',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF4C6C89),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Header misy Dropdown
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 5)],
            ),
            child: isLoadingCentres
                ? const Center(child: CircularProgressIndicator())
                : DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: "Sélectionner un centre fiscal",
                      prefixIcon: const Icon(
                        Icons.location_city,
                        color: Color(0xFF4C6C89),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                      ),
                    ),
                    value: selectedCentre,
                    items: centres.map((centre) {
                      return DropdownMenuItem(
                        value: centre,
                        child: Text(centre),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() => selectedCentre = value);
                      fetchDefaillants();
                    },
                  ),
          ),

          const SizedBox(height: 10),

          // Lisitry ny défaillants (Responsive)
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : defaillants.isEmpty
                ? _buildEmptyState()
                : _buildResponsiveContent(),
          ),
        ],
      ),
    );
  }

  // Content Responsive: Grid raha malalaka ny ecran, List raha finday
  Widget _buildResponsiveContent() {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 700) {
          return GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              mainAxisExtent: 240,
            ),
            itemCount: defaillants.length,
            itemBuilder: (context, index) => _buildCard(defaillants[index]),
          );
        } else {
          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            itemCount: defaillants.length,
            itemBuilder: (context, index) => _buildCard(defaillants[index]),
          );
        }
      },
    );
  }

  Widget _buildCard(Map d) {
    bool isActive = d['actif'] == true;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    "${d['rs']}",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Color(0xFF2C3E50),
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                _buildStatusBadge(isActive),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              "NIF: ${d['tax_payer_no']}",
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.grey,
              ),
            ),
            const Divider(height: 20),
            _buildInfoRow(
              Icons.warning_amber_rounded,
              "Motif",
              d['motif'] ?? '-',
              isItalic: true,
              iconColor: Colors.redAccent,
            ),
            _buildInfoRow(Icons.place_outlined, "Adresse", d['adresse'] ?? '-'),
            _buildInfoRow(Icons.work_outline, "Activité", d['activite'] ?? '-'),
            _buildInfoRow(Icons.phone_android, "Téléphone", d['phone'] ?? '-'),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(
    IconData icon,
    String label,
    String value, {
    bool isItalic = false,
    Color iconColor = Colors.blueGrey,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 16, color: iconColor),
          const SizedBox(width: 8),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: const TextStyle(fontSize: 13, color: Colors.black87),
                children: [
                  TextSpan(
                    text: "$label: ",
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                  TextSpan(
                    text: value,
                    style: TextStyle(
                      fontStyle: isItalic ? FontStyle.italic : FontStyle.normal,
                      color: isItalic ? Colors.redAccent : Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(bool isActive) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: isActive
            ? Colors.green.withOpacity(0.1)
            : Colors.red.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: isActive ? Colors.green : Colors.red),
      ),
      child: Text(
        isActive ? "Actif" : "Inactif",
        style: TextStyle(
          color: isActive ? Colors.green : Colors.red,
          fontSize: 11,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.person_off_outlined, size: 60, color: Colors.grey[300]),
          const SizedBox(height: 10),
          const Text(
            "Aucun contribuable défaillant",
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
