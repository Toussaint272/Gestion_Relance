import 'package:flutter/material.dart';

class MenuDrawer extends StatelessWidget {
  const MenuDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          // ======== HEADER ========
          DrawerHeader(
            decoration: const BoxDecoration(color: Color(0xFF003366)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/logodgi.png', width: 80),
                const SizedBox(height: 10),
                const Text(
                  'DGI - Relance Défaillants',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          // ======== MENU ITEMS ========
          ListTile(
            leading: const Icon(Icons.dashboard, color: Colors.black87),
            title: const Text('Tableau de bord'),
            onTap: () {
              Navigator.pushNamed(context, '/');
            },
          ),
          const Divider(),

          ListTile(
            leading: const Icon(Icons.people, color: Colors.black87),
            title: const Text('Contribuables'),
            onTap: () {
              Navigator.pushNamed(context, '/contribuable');
            },
          ),

          ListTile(
            leading: const Icon(Icons.description, color: Colors.black87),
            title: const Text('Déclarations'),
            onTap: () {
              Navigator.pushNamed(context, '/declaration');
            },
          ),

          ListTile(
            leading: const Icon(
              Icons.notifications_active,
              color: Colors.black87,
            ),
            title: const Text('Relances & Défaillants'),
            onTap: () {
              Navigator.pushNamed(context, '/relance');
            },
          ),

          ListTile(
            leading: const Icon(Icons.payment, color: Colors.black87),
            title: const Text('Paiements'),
            onTap: () {
              Navigator.pushNamed(context, '/paiement');
            },
          ),

          ListTile(
            leading: const Icon(Icons.account_circle, color: Colors.black87),
            title: const Text('Utilisateurs (Agents)'),
            onTap: () {
              Navigator.pushNamed(context, '/utilisateur');
            },
          ),

          const Divider(),

          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text(
              'Déconnexion',
              style: TextStyle(color: Colors.red),
            ),
            onTap: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
