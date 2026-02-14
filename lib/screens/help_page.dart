import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class HelpPage extends StatelessWidget {
  final String supportEmail = 'toussainttokyratolojanahary@gmail.com';
  final String supportPhone = '+261 34 41 953 91';

  HelpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA), // Loko malefaka kokoa
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Centre d\'aide',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF395067),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: 600,
              ), // Ho an'ny responsiveness
              child: Column(
                children: [
                  _buildHeader(),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildInfoSection(
                          icon: Icons.info_outline,
                          title: '1. Présentation',
                          content:
                              'Cette application permet aux agents et aux administrateurs de la DGI de gérer les déclarations, d’envoyer des relances et de suivre les contribuables défaillants.',
                        ),
                        const SizedBox(height: 16),
                        _buildInfoSection(
                          icon: Icons.login_rounded,
                          title: '2. Connexion',
                          content:
                              'Utilisez vos identifiants DGI. En cas de problème, vérifiez votre connexion ou contactez l\'administrateur pour réinitialiser votre compte.',
                        ),
                        const SizedBox(height: 16),
                        _buildExpansionStep(),
                        const SizedBox(height: 16),
                        _buildFaqSection(),
                        const SizedBox(height: 16),
                        _buildContactCard(context),
                        const SizedBox(height: 30),
                        _buildFooter(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // 1. Header mihaingo kokoa
  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
      decoration: const BoxDecoration(
        color: Color(0xFF395067),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 40,
            backgroundColor: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset('assets/logodgi.png', fit: BoxFit.contain),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Comment pouvons-nous vous aider ?',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Guide complet et support technique DGI',
            style: TextStyle(color: Colors.white70, fontSize: 13),
          ),
        ],
      ),
    );
  }

  // 2. Section d'information classique
  Widget _buildInfoSection({
    required IconData icon,
    required String title,
    required String content,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: const Color(0xFF0D47A1), size: 22),
              const SizedBox(width: 10),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0D47A1),
                ),
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.only(top: 10, left: 32),
            child: Divider(height: 1),
          ),
          const SizedBox(height: 12),
          Text(
            content,
            style: const TextStyle(
              fontSize: 14,
              height: 1.5,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  // 3. Guide pas-à-pas (Expansion)
  Widget _buildExpansionStep() {
    return Container(
      decoration: _cardDecoration(),
      child: ExpansionTile(
        leading: const Icon(Icons.map_outlined, color: Color(0xFF0D47A1)),
        title: const Text(
          '3. Guide d\'envoi de relance',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF0D47A1),
          ),
        ),
        children: [
          _stepItem(
            '1',
            'Accédez à la liste des contribuables et cliquez sur "Détail".',
          ),
          _stepItem(
            '2',
            'Vérifiez les déclarations puis cliquez sur "Envoyer relance".',
          ),
          _stepItem('3', 'Suivez l\'état de l\'envoi dans votre Historique.'),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget _stepItem(String number, String text) {
    return ListTile(
      leading: CircleAvatar(
        radius: 12,
        backgroundColor: const Color(0xFF0D47A1),
        child: Text(
          number,
          style: const TextStyle(color: Colors.white, fontSize: 12),
        ),
      ),
      title: Text(text, style: const TextStyle(fontSize: 13)),
    );
  }

  // 4. FAQ
  Widget _buildFaqSection() {
    final faq = [
      {
        'q': 'Relances non visibles ?',
        'a': 'Vérifiez votre connexion et rafraîchissez l\'onglet Historique.',
      },
      {
        'q': 'Statut "Envoyé" ?',
        'a': 'Cela confirme que le SMS ou l\'Email a quitté nos serveurs.',
      },
      {
        'q': 'Mot de passe oublié ?',
        'a': 'Contactez le support technique via les boutons ci-dessous.',
      },
    ];

    return Container(
      decoration: _cardDecoration(),
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(12.0),
            child: Text(
              'Questions fréquentes (FAQ)',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0D47A1),
              ),
            ),
          ),
          ...faq
              .map(
                (item) => ExpansionTile(
                  title: Text(
                    item['q']!,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: Text(
                        item['a']!,
                        style: const TextStyle(color: Colors.black54),
                      ),
                    ),
                  ],
                ),
              )
              .toList(),
        ],
      ),
    );
  }

  // 5. Card Contact (Actionable)
  Widget _buildContactCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.blue.shade100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Besoin d\'une assistance directe ?',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          const SizedBox(height: 15),
          _contactTile(context, Icons.email, supportEmail, 'Copier l\'email'),
          const Divider(),
          _contactTile(context, Icons.phone, supportPhone, 'Copier le numéro'),
        ],
      ),
    );
  }

  Widget _contactTile(
    BuildContext context,
    IconData icon,
    String value,
    String tooltip,
  ) {
    return InkWell(
      onTap: () {
        Clipboard.setData(ClipboardData(text: value));
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('$value copié !')));
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Icon(icon, size: 20, color: Colors.blue.shade800),
            const SizedBox(width: 12),
            Expanded(child: Text(value, style: const TextStyle(fontSize: 14))),
            const Icon(Icons.copy_all, size: 18, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  Widget _buildFooter() {
    return Center(
      child: Column(
        children: [
          const Text(
            'Direction Générale des Impôts',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: Colors.black54,
            ),
          ),
          Text(
            'v${DateFormat('yyyy.MM.dd').format(DateTime.now())}',
            style: const TextStyle(fontSize: 12, color: Colors.black38),
          ),
        ],
      ),
    );
  }

  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(15),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }
}
