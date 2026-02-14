/*import 'package:flutter/material.dart';
import 'package:my_app/screens/defaillant_page.dart';
import 'package:my_app/screens/liste_agents.dart';
import 'package:my_app/screens/liste_assujettissement.dart';
import 'package:my_app/screens/liste_contribuables.dart';
import 'package:my_app/screens/liste_declarations.dart';
import 'package:my_app/screens/liste_paiement.dart';
import 'package:my_app/screens/relanceFiltreCentre_page.dart';
import 'package:my_app/screens/relance_historique_page.dart';
import 'package:my_app/screens/stats_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login_screen.dart'; // ho an'ny déconnexion

class Dashboard extends StatelessWidget {
  final String role;
  final String agentMatricule;

  const Dashboard({Key? key, required this.role, required this.agentMatricule})
    : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        elevation: 4,
        title: const Text(
          'Tableau de bord - DGI',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            tooltip: 'Se déconnecter',
            onPressed: () async {
              // 🔹 Popup confirmation avant déconnexion
              final confirm = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Confirmer la déconnexion'),
                  content: const Text(
                    'Voulez-vous vraiment vous déconnecter ?',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text('Annuler'),
                    ),
                    ElevatedButton(
                      onPressed: () => Navigator.pop(context, true),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                      child: const Text('Déconnecter'),
                    ),
                  ],
                ),
              );

              if (confirm == true) {
                // 🔹 Déconnexion propre: esorina ny stack rehetra
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                  (route) => false,
                );
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: role.trim().toLowerCase() == 'admin'
            ? const AdminDashboard()
            : const AgentDashboard(),
      ),
    );
  }
}

// ================= Agent Dashboard =================
class AgentDashboard extends StatelessWidget {
  const AgentDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // 🔹 Logo DGI
          Image.asset('assets/logodgi.png', width: 80),
          const SizedBox(height: 10),
          const Text(
            '👋 Bienvenue, Agent DGI',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.blueAccent,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Voici vos fonctionnalités principales :',
            style: TextStyle(color: Colors.black54),
          ),

          //test
          const SizedBox(height: 20),
          GridView.count(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              DashboardCard(
                icon: Icons.people,
                title: 'Liste Contribuables',
                color: Colors.blueAccent,
                onTap: () async {
                  final prefs = await SharedPreferences.getInstance();
                  final agentMatricule =
                      prefs.getString('agentMatricule') ?? '';

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          ListeContribuables(agentMatricule: agentMatricule),
                    ),
                  );
                },
              ),
              //Assujettissement
              DashboardCard(
                icon: Icons.assignment,
                title: 'Liste Assujettissement',
                color: Colors.blueAccent,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const ListeAssujettissement(),
                    ),
                  );
                },
              ),
              // Declaration
              DashboardCard(
                icon: Icons.description,
                title: 'Liste Declaration',
                color: Colors.blueAccent,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const ListeDeclaration()),
                  );
                },
              ),

              //Liste Paiement
              DashboardCard(
                icon: Icons.receipt_long,
                title: 'Liste Paiement',
                color: Colors.blueAccent,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const ListePaiementPage(),
                    ),
                  );
                },
              ),
              DashboardCard(
                icon: Icons.notifications_active,
                title: 'Relances effectuées',
                color: Colors.blueAccent,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const RelanceHistoriquePage(),
                    ),
                  );
                },
              ),

              /*ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const RelanceHistoriquePage(),
                    ),
                  );
                },
                icon: const Icon(Icons.history, size: 18),
                label: const Text("Relances effectuées"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                ),
              ),*/
              DashboardCard(
                icon: Icons.info_outline,
                title: 'Statut des contribuables',
                color: Colors.green,
                onTap: () {},
              ),
              DashboardCard(
                icon: Icons.settings,
                title: 'Paramètres',
                color: Colors.purple,
                onTap: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ================= Admin Dashboard =================
class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // 🔹 Logo DGI
          Image.asset('assets/logodgi.png', width: 80),
          const SizedBox(height: 10),
          const Text(
            '👑 Bienvenue, Administrateur DGI',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.blueAccent,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Gérez les agents et consultez les statistiques :',
            style: TextStyle(color: Colors.black54),
          ),
          const SizedBox(height: 20),
          GridView.count(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              DashboardCard(
                icon: Icons.manage_accounts,
                title: 'Gérer les comptes agents',
                //subtitle: 'Gérer les comptes agents',
                color: Colors.blueAccent,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const ListeAgents()),
                  );
                },
              ),
              DashboardCard(
                icon: Icons.bar_chart,
                title: 'Statistiques générales',
                color: Colors.blueAccent,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const StatsDashboardPage(),
                    ),
                  );
                },
              ),
              DashboardCard(
                icon: Icons.notifications_active,
                title: 'Relances effectuées',
                color: Colors.blueAccent,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const RelancesEffectueesCentres(),
                    ),
                  );
                },
              ),

              /*DashboardCard(
                icon: Icons.people_alt,
                title: 'Contribuables générales',
                color: Colors.blueAccent,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const ListeContribuables1(),
                    ),
                  );
                },
              ),*/
              /*DashboardCard(
                icon: Icons.people_alt,
                title: 'Types declaration',
                color: Colors.blueAccent,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const AdminDeclarationsPage(),
                    ),
                  );
                },
              ),*/
              DashboardCard(
                icon: Icons.people_alt,
                title: 'Contribuable defaillant',
                color: const Color.fromARGB(255, 255, 68, 68),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const DefaillantsPage()),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ================= Modern Card Widget =================
class DashboardCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final Color color;
  final VoidCallback onTap;

  const DashboardCard({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
              offset: Offset(2, 3),
            ),
          ],
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              backgroundColor: color.withOpacity(0.15),
              radius: 30,
              child: Icon(icon, color: color, size: 30),
            ),
            const SizedBox(height: 15),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: Colors.black87,
              ),
            ),
            if (subtitle != null) ...[
              const SizedBox(height: 5),
              Text(
                subtitle!,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 12, color: Colors.black54),
              ),
            ],
          ],
        ),
      ),
    );
  }
}*/
/*import 'package:flutter/material.dart';
import 'package:my_app/screens/relanceFiltreCentre_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Tes imports :
import 'package:my_app/screens/liste_contribuables.dart';
import 'package:my_app/screens/liste_assujettissement.dart';
import 'package:my_app/screens/liste_declarations.dart';
import 'package:my_app/screens/liste_paiement.dart';
import 'package:my_app/screens/relance_historique_page.dart';
import 'package:my_app/screens/relances_effectues.dart';
import 'package:my_app/screens/liste_agents.dart';
import 'package:my_app/screens/stats_page.dart';
import 'package:my_app/screens/defaillant_page.dart';
import 'login_screen.dart';

class Dashboard extends StatefulWidget {
  final String role;
  final String agentMatricule;

  const Dashboard({
    super.key,
    required this.role,
    required this.agentMatricule,
  });

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int currentIndex = 0;

  List<Widget> getPages() {
    return [
      widget.role.toLowerCase().trim() == "admin"
          ? const AdminDashboard()
          : const AgentDashboard(),

      // 🔥 PAGE RELANCE miankina amin'ny ROLE
      widget.role.toLowerCase().trim() == "admin"
          ? const RelancesEffectuees1() // Page Admin
          : const RelanceHistoriquePage(), // Page Agent

      const Center(
        child: Text(
          "Paramètres",
          style: TextStyle(fontSize: 24, color: Colors.white),
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF4C6C89),

      appBar: AppBar(
        backgroundColor: const Color(0xFF4C6C89),
        elevation: 3,
        title: Row(
          children: [
            Image.asset('assets/logodgi.png', width: 50),
            const SizedBox(width: 10),
            const Text(
              "Relances des défaillants",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () async {
              final confirm = await showDialog<bool>(
                context: context,
                builder: (_) => AlertDialog(
                  title: const Text("Déconnexion"),
                  content: const Text(
                    "Voulez-vous vraiment vous déconnecter ?",
                  ),
                  actions: [
                    TextButton(
                      child: const Text("Annuler"),
                      onPressed: () => Navigator.pop(context, false),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                      onPressed: () => Navigator.pop(context, true),
                      child: const Text("Déconnecter"),
                    ),
                  ],
                ),
              );

              if (confirm == true) {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                  (route) => false,
                );
              }
            },
          ),
        ],
      ),

      body: getPages()[currentIndex],

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white70,
        backgroundColor: const Color(0xFF395067),
        onTap: (index) => setState(() => currentIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Accueil"),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications_active),
            label: "Relances",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: "Paramètres",
          ),
        ],
      ),
    );
  }
}

// =====================================================
//                     AGENT DASHBOARD
// =====================================================

class AgentDashboard extends StatelessWidget {
  const AgentDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ---- Bannière ----
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.asset(
              'assets/logo3.png',
              width: double.infinity,
              height: 160,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 20),

          const Text(
            'Bienvenue, Agent DGI',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Accédez rapidement à vos fonctionnalités :',
            style: TextStyle(color: Colors.white70),
          ),
          const SizedBox(height: 26),

          // ---- Grid des fonctionnalités ----
          GridView.count(
            crossAxisCount: 2,
            childAspectRatio: 0.83,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),

            children: [
              AppCard(
                icon: Icons.people,
                title: "Liste Contribuables",
                color: Colors.blueAccent,
                onTap: () async {
                  final prefs = await SharedPreferences.getInstance();
                  String matricule = prefs.getString("agentMatricule") ?? "";
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          ListeContribuables(agentMatricule: matricule),
                    ),
                  );
                },
              ),

              AppCard(
                icon: Icons.assignment,
                title: "Assujettissement",
                color: Colors.blueAccent,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const ListeAssujettissement(),
                    ),
                  );
                },
              ),

              AppCard(
                icon: Icons.description,
                title: "Déclarations",
                color: Colors.blueAccent,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const ListeDeclaration()),
                  );
                },
              ),

              AppCard(
                icon: Icons.receipt_long,
                title: "Paiements",
                color: Colors.blueAccent,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const ListePaiementPage(),
                    ),
                  );
                },
              ),

              /*AppCard(
                icon: Icons.notifications_active,
                title: "Relances effectuées",
                color: Colors.orangeAccent,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const RelanceHistoriquePage(),
                    ),
                  );
                },
              ),*/
            ],
          ),
        ],
      ),
    );
  }
}

// =====================================================
//                     ADMIN DASHBOARD
// =====================================================

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.asset(
              'assets/logo3.png',
              width: double.infinity,
              height: 160,
              fit: BoxFit.cover,
            ),
          ),

          const SizedBox(height: 20),
          const Text(
            'Bienvenue, Administrateur',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Gérez les agents et les statistiques globales :',
            style: TextStyle(color: Colors.white70),
          ),
          const SizedBox(height: 26),

          GridView.count(
            crossAxisCount: 2,
            childAspectRatio: 0.83,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),

            children: [
              AppCard(
                icon: Icons.manage_accounts,
                title: "Gérer les agents",
                color: Colors.blueAccent,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const ListeAgents()),
                  );
                },
              ),

              AppCard(
                icon: Icons.bar_chart,
                title: "Statistiques générales",
                color: Colors.green,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const StatsDashboardPage(),
                    ),
                  );
                },
              ),

              AppCard(
                icon: Icons.notifications_active,
                title: "Relances effectuées",
                color: Colors.orangeAccent,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const RelancesEffectueesCentres(),
                    ),
                  );
                },
              ),

              AppCard(
                icon: Icons.people_alt,
                title: "Défaillants",
                color: Colors.redAccent,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const DefaillantsPage()),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// =====================================================
//                     CARD WIDGET MODERNE
// =====================================================

class AppCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color color;
  final VoidCallback onTap;

  const AppCard({
    super.key,
    required this.icon,
    required this.title,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: const [
            BoxShadow(
              blurRadius: 8,
              offset: Offset(2, 2),
              color: Colors.black12,
            ),
          ],
        ),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 32,
              backgroundColor: color.withOpacity(0.18),
              child: Icon(icon, color: color, size: 32),
            ),
            const SizedBox(height: 14),

            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}*/
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:my_app/screens/help_page.dart';
import 'package:my_app/screens/login_screen.dart';
import '../config/api_endpoints.dart';

// --- Imports screens ---
import 'package:my_app/screens/liste_contribuables.dart';
import 'package:my_app/screens/liste_assujettissement.dart';
import 'package:my_app/screens/liste_declarations.dart';
import 'package:my_app/screens/liste_paiement.dart';
import 'package:my_app/screens/relance_historique_page.dart';
import 'package:my_app/screens/relances_effectues.dart';
import 'package:my_app/screens/liste_agents.dart';
import 'package:my_app/screens/stats_page.dart';
import 'package:my_app/screens/defaillant_page.dart';
import 'package:my_app/screens/relanceFiltreCentre_page.dart';

class Dashboard extends StatefulWidget {
  final String role;
  final String agentMatricule;

  const Dashboard({
    super.key,
    required this.role,
    required this.agentMatricule,
  });

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int currentIndex = 0;
  int relanceCount = 0;

  @override
  void initState() {
    super.initState();
    loadCount();
  }

  Future<int> countRelances() async {
    String url = widget.role.toLowerCase() == "admin"
        ? ApiEndpoints.statsOverview
        : ApiEndpoints.relanceHistorique(widget.agentMatricule);

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (widget.role.toLowerCase() == "admin")
          return data["totalRelances"] ?? 0;
        if (data is List) return data.length;
      }
    } catch (e) {
      debugPrint("Error counting relances: $e");
    }
    return 0;
  }

  Future<void> loadCount() async {
    int res = await countRelances();
    if (mounted) setState(() => relanceCount = res);
  }

  List<Widget> getPages() {
    bool isAdmin = widget.role.toLowerCase().trim() == "admin";
    return [
      isAdmin ? const AdminDashboard() : const AgentDashboard(),
      isAdmin ? const RelancesEffectuees1() : const RelanceHistoriquePage(),
      HelpPage(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Background gradient ho an'ny app manontolo
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF4C6C89), Color(0xFF2C3E50)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildCustomAppBar(),
              Expanded(child: getPages()[currentIndex]),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildCustomAppBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Image.asset('assets/logoVraie.jpg', width: 45),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "DGI Relances",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                Text(
                  "Gestion des défaillants",
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.power_settings_new, color: Colors.white),
            onPressed: _showLogoutDialog,
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: const Text("Déconnexion"),
        content: const Text("Voulez-vous vraiment quitter l'application ?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Annuler"),
          ),
          TextButton(
            /*style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),*/
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              "Oui, Déconnecter",
              style: TextStyle(color: Colors.green),
            ),
          ),
        ],
      ),
    );

    if (confirm == true) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
        (route) => false,
      );
    }
  }

  Widget _buildBottomNav() {
    return Container(
      decoration: const BoxDecoration(
        boxShadow: [
          BoxShadow(color: Colors.black26, blurRadius: 10, spreadRadius: 0),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) {
          setState(() => currentIndex = index);
          if (index == 1) loadCount();
        },
        backgroundColor: const Color(0xFF1A2A3A),
        selectedItemColor: Colors.amberAccent,
        unselectedItemColor: Colors.white54,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_rounded),
            label: "Accueil",
          ),
          BottomNavigationBarItem(
            icon: Badge(
              label: Text('$relanceCount'),
              isLabelVisible: relanceCount > 0,
              child: const Icon(Icons.history_rounded),
            ),
            label: "Historique",
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.help_center_rounded),
            label: "Aide",
          ),
        ],
      ),
    );
  }
}

// =====================================================
//           DASHBOARD CONTENT (SHARED STYLE)
// =====================================================

class AgentDashboard extends StatelessWidget {
  const AgentDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return _DashboardBase(
      welcomeText: "Bienvenue, Agent DGI",
      subText: "Gestionnaire de portefeuille",
      cards: [
        _MenuData(Icons.people_alt_rounded, "Contribuables", Colors.blue, (
          context,
        ) async {
          final prefs = await SharedPreferences.getInstance();
          String mat = prefs.getString("agentMatricule") ?? "";
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ListeContribuables(agentMatricule: mat),
            ),
          );
        }),
        _MenuData(
          Icons.assignment_turned_in_rounded,
          "Assujetissement",
          Colors.indigo,
          (context) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ListeAssujettissement()),
            );
          },
        ),
        _MenuData(Icons.description_rounded, "Déclarations", Colors.teal, (
          context,
        ) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const ListeDeclaration()),
          );
        }),
        _MenuData(Icons.payments_rounded, "Paiements", Colors.orange, (
          context,
        ) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const ListePaiementPage()),
          );
        }),
      ],
    );
  }
}

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return _DashboardBase(
      welcomeText: "Espace Administrateur",
      subText: "Supervision et contrôle global",
      cards: [
        _MenuData(Icons.admin_panel_settings, "Agents", Colors.blue, (context) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const ListeAgents()),
          );
        }),
        _MenuData(Icons.analytics_rounded, "Stats", Colors.green, (context) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const StatsDashboardPage()),
          );
        }),
        _MenuData(Icons.send_and_archive_rounded, "Relances", Colors.orange, (
          context,
        ) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const RelancesEffectueesCentres(),
            ),
          );
        }),
        _MenuData(
          Icons.report_problem_rounded,
          "Défaillants",
          Colors.redAccent,
          (context) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const DefaillantsPage()),
            );
          },
        ),
      ],
    );
  }
}

class _DashboardBase extends StatelessWidget {
  final String welcomeText;
  final String subText;
  final List<_MenuData> cards;

  const _DashboardBase({
    required this.welcomeText,
    required this.subText,
    required this.cards,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Banner Image mihaingo
          Container(
            height: 140,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              image: const DecorationImage(
                image: AssetImage('assets/logo3.png'),
                fit: BoxFit.cover,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
          ),
          const SizedBox(height: 25),
          Text(
            welcomeText,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          Text(
            subText,
            style: const TextStyle(color: Colors.white70, fontSize: 14),
          ),
          const SizedBox(height: 25),

          // Grid responsive
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: cards.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 15,
              mainAxisSpacing: 15,
              childAspectRatio: 1.1,
            ),
            itemBuilder: (context, index) {
              final item = cards[index];
              return AppCard(
                icon: item.icon,
                title: item.title,
                color: item.color,
                onTap: () => item.onTap(context),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _MenuData {
  final IconData icon;
  final String title;
  final Color color;
  final Function(BuildContext) onTap;
  _MenuData(this.icon, this.title, this.color, this.onTap);
}

class AppCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color color;
  final VoidCallback onTap;

  const AppCard({
    super.key,
    required this.icon,
    required this.title,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      elevation: 4,
      shadowColor: Colors.black26,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.all(15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 30),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2C3E50),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
