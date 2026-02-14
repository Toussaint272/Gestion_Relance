import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/paiement.dart';
import '../services/paiement_service1.dart';

class PaiementsPage1 extends StatefulWidget {
  final String taxPayerNo;
  final String contribuableName;
  final String agentMatricule;

  const PaiementsPage1({
    Key? key,
    required this.taxPayerNo,
    required this.contribuableName,
    required this.agentMatricule,
  }) : super(key: key);

  @override
  State<PaiementsPage1> createState() => _PaiementsPageState();
}

class _PaiementsPageState extends State<PaiementsPage1> {
  late Future<List<Paiement1>> paiements;

  @override
  void initState() {
    super.initState();
    // Fakana ny liste ny paiements amin'ny alalan'ny NIF
    paiements = PaiementService.fetchPaiementsByContribuable(widget.taxPayerNo);
  }

  // Fonctions fampisehoana daty sy vola mba hadio ny code ao ambany
  String formatCurrency(dynamic amount) {
    double value = double.tryParse(amount.toString()) ?? 0;
    return NumberFormat('#,##0', 'fr_FR').format(value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Paiements - ${widget.contribuableName}"),
        backgroundColor: const Color(0xFF4C6C89),
        elevation: 0,
      ),
      body: FutureBuilder<List<Paiement1>>(
        future: paiements,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Erreur : ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("Aucun paiement trouvé."));
          }

          final data = snapshot.data!;

          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            itemCount: data.length,
            itemBuilder: (context, index) {
              final p = data[index];
              final dateStr = DateFormat(
                'yyyy-MM-dd',
              ).format(p.datePaiement.toLocal());

              return Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                elevation: 2,
                margin: const EdgeInsets.only(bottom: 12),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Boribory kely misy laharana déclaration
                      CircleAvatar(
                        backgroundColor: const Color(0xFF4C6C89),
                        child: Text(
                          p.nDecl.toString(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      const SizedBox(width: 15),
                      // Ny pitsopitsony rehetra
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "NIF : ${p.taxPayerNo}",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const Divider(height: 15),
                            _buildInfoRow(
                              Icons.account_balance_wallet,
                              "Montant payé",
                              "${formatCurrency(p.montantPayer)} Ar",
                            ),
                            _buildInfoRow(
                              Icons.money_off,
                              "Reste à recouvrer",
                              "${formatCurrency(p.resteARecouvrer)} Ar",
                              textColor: p.resteARecouvrer == 0
                                  ? const Color(0xFF5C8D89)
                                  : const Color(0xFFD9534F),
                            ),
                            _buildInfoRow(
                              Icons.payment,
                              "Mode",
                              p.modePaiement,
                            ),
                            _buildInfoRow(
                              Icons.calendar_today,
                              "Date",
                              dateStr,
                            ),
                            const SizedBox(height: 8),
                            // Statut fotsiny sisa no tavela eto fa nesorina ny bouton
                            Row(
                              children: [
                                Icon(
                                  p.valider ? Icons.check_circle : Icons.cancel,
                                  size: 16,
                                  color: p.valider ? Colors.green : Colors.red,
                                ),
                                const SizedBox(width: 5),
                                Text(
                                  p.valider ? 'Validé' : 'Non validé',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: p.valider
                                        ? Colors.green
                                        : Colors.red,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
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

  // Widget kely hanamorana ny fanoratana ny andalana tsirairay
  Widget _buildInfoRow(
    IconData icon,
    String label,
    String value, {
    Color? textColor,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Icon(icon, size: 14, color: Colors.grey[600]),
          const SizedBox(width: 8),
          Text(
            "$label : ",
            style: TextStyle(color: Colors.grey[700], fontSize: 13),
          ),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 13,
              color: textColor ?? Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
