import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Clipboard
import 'package:intl/intl.dart';

class HelpPage extends StatelessWidget {
  // Path local image (provided from your environment)
  // Developer note: this path was uploaded in the current session.
  final String headerImagePath =
      '/mnt/data/491f60e1-81a6-417d-85c5-408ad089a663.png';

  // Contact info — change to your real support details
  final String supportEmail = 'toussainttokyratolojanahary@gmail.com';
  final String supportPhone = '+261 34 41 953 91';

  HelpPage({super.key});

  Widget sectionTitle(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, top: 12.0),
      child: Text(
        text,
        style: const TextStyle(
          color: Color(0xFF0D47A1),
          fontSize: 18,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget sectionBody(String text) {
    return Text(
      text,
      style: const TextStyle(fontSize: 14, height: 1.5, color: Colors.black87),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Simple card style used repeatedly
    final cardDecoration = BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      boxShadow: const [
        BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(2, 3)),
      ],
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Aide', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF395067),
      ),
      backgroundColor: const Color(0xFFF4F6F8),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header card with image + short intro
              Container(
                decoration: cardDecoration,
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    // Image (try to load the local file; fallback to placeholder)
                    /*ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: _buildHeaderImage(),
                    ),*/
                    Image.asset('assets/logodgi.png', width: 100),
                    const SizedBox(width: 10),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'Aide & Support',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 6),
                          Text(
                            'Guide rapide pour utiliser l\'application mobile gestion des relances des contribuables defaillants : connexion, envoi de relance, suivi et contact support.',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Présentation
              Container(
                decoration: cardDecoration,
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    sectionTitle('1. Présentation'),
                    sectionBody(
                      'Cette application permet aux agents et aux administrateurs de la DGI de gérer les déclarations, d’envoyer des relances et de suivre les contribuables défaillants.',
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              // Connexion
              Container(
                decoration: cardDecoration,
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    sectionTitle('2. Connexion'),
                    sectionBody(
                      'Entrez votre Email et mot de passe fournis. Si vous ne pouvez pas vous connecter : vérifiez la connexion internet, vérifiez votre matricule ou contactez le support.',
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              // Envoi relance (expandable with steps)
              Container(
                decoration: cardDecoration,
                padding: const EdgeInsets.all(6),
                child: ExpansionTile(
                  tilePadding: const EdgeInsets.symmetric(horizontal: 12),
                  title: const Text(
                    '3. Envoyer une relance (guide pas-à-pas)',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                  children: [
                    ListTile(
                      dense: true,
                      title: const Text('Étape 1'),
                      subtitle: const Text(
                        'Pour aller à "Liste Contribuables", cliquez sur le bouton Détail. Vous serez redirigé vers la fiche du contribuable, où il y a deux boutons : "Voir les paiements" et "Voir les déclarations".',
                      ),
                    ),
                    ListTile(
                      dense: true,
                      title: const Text('Étape 2'),
                      subtitle: const Text(
                        'Cliquer sur "Envoyer relance" et confirmer.',
                      ),
                    ),
                    ListTile(
                      dense: true,
                      title: const Text('Étape 3'),
                      subtitle: const Text(
                        'Après envoi, la relance apparaît dans l\'historique et le compteur (badge) se met à jour.',
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              // FAQ - using ExpansionPanelList for multiple Q/A
              Container(
                decoration: cardDecoration,
                padding: const EdgeInsets.all(14),
                child: _buildFaqSection(),
              ),

              const SizedBox(height: 12),

              // Support contact card
              Container(
                decoration: cardDecoration,
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    sectionTitle('Support / Assistance'),
                    sectionBody(
                      'Pour toute question ou problème technique, contactez notre équipe support.',
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const Icon(Icons.email_outlined, size: 20),
                        const SizedBox(width: 8),
                        Expanded(child: Text(supportEmail)),
                        TextButton.icon(
                          onPressed: () {
                            Clipboard.setData(
                              ClipboardData(text: supportEmail),
                            );
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Email copié dans le presse-papiers',
                                ),
                              ),
                            );
                          },
                          icon: const Icon(Icons.copy, size: 16),
                          label: const Text('Copier'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.phone, size: 20),
                        const SizedBox(width: 8),
                        Text(supportPhone),
                        const SizedBox(width: 8),
                        TextButton.icon(
                          onPressed: () {
                            Clipboard.setData(
                              ClipboardData(text: supportPhone),
                            );
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Numéro copié dans le presse-papiers',
                                ),
                              ),
                            );
                          },
                          icon: const Icon(Icons.copy, size: 16),
                          label: const Text('Copier'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Horaires support : Lun-Ven 08:00 - 16:00',
                      style: const TextStyle(
                        fontSize: 13,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Footer small
              Center(
                child: Text(
                  'Version de l\'application • ${_appVersionString()}',
                  style: const TextStyle(color: Colors.black54, fontSize: 12),
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  // build header image with fallback
  Widget _buildHeaderImage() {
    try {
      final file = File(headerImagePath);
      if (file.existsSync()) {
        return Image.file(file, width: 90, height: 90, fit: BoxFit.cover);
      } else {
        return Container(
          width: 90,
          height: 90,
          color: Colors.grey.shade200,
          child: const Icon(
            Icons.help_outline,
            size: 36,
            color: Colors.black38,
          ),
        );
      }
    } catch (e) {
      return Container(
        width: 90,
        height: 90,
        color: Colors.grey.shade200,
        child: const Icon(Icons.help_outline, size: 36, color: Colors.black38),
      );
    }
  }

  // FAQ builder (simple)
  Widget _buildFaqSection() {
    final faq = <Map<String, String>>[
      {
        'q': 'Pourquoi je ne vois pas mes relances immédiatement ?',
        'a':
            'Assurez-vous d\'être connecté. Le compteur se met à jour quand vous ouvrez l\'onglet "Relances" ou après l\'envoi automatique (si vous restez sur la page, fermez et rouvrez l\'onglet pour forcer le rafraîchissement).',
      },
      {
        'q': 'Que signifie "Envoyé" ?',
        'a':
            'La relance a bien été transmise au contribuable par le mode choisi (email, SMS...).',
      },
      {
        'q': 'Comment réinitialiser mon mot de passe ?',
        'a':
            'Contactez l\'administrateur central via le support pour une réinitialisation.',
      },
      {
        'q': 'Que faire si une déclaration est erronée ?',
        'a':
            'Ne pas envoyer de relance. Contactez le service technique / vérifiez la déclaration dans le module "Déclarations".',
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'FAQ',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        ...faq.map((f) {
          return ExpansionTile(
            tilePadding: const EdgeInsets.symmetric(horizontal: 6),
            title: Text(f['q']!),
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12.0,
                  vertical: 8,
                ),
                child: Text(
                  f['a']!,
                  style: const TextStyle(color: Colors.black87),
                ),
              ),
            ],
          );
        }).toList(),
      ],
    );
  }

  String _appVersionString() {
    // Replace with real version logic if you have one
    final now = DateTime.now();
    return DateFormat('yyyy.MM.dd').format(now);
  }
}
