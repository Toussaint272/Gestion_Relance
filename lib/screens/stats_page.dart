/*import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fl_chart/fl_chart.dart';
import 'package:my_app/screens/declarationRetard_page.dart';
import 'package:my_app/screens/filtre_declaration.dart';
import 'package:my_app/screens/liste_agents1.dart';
import 'package:my_app/screens/relances_effectues.dart';
import 'package:my_app/screens/totalDefaillant_page.dart';
import 'package:my_app/screens/touts_contribuable.dart';

class StatsDashboardPage extends StatefulWidget {
  const StatsDashboardPage({super.key});

  @override
  State<StatsDashboardPage> createState() => _StatsDashboardPageState();
}

class _StatsDashboardPageState extends State<StatsDashboardPage> {
  Map<String, dynamic>? overviewData;
  Map<String, dynamic>? paiementData;
  List<dynamic> monthlyRelances = [];
  List<dynamic> topAgents = [];
  //teste
  Map<String, dynamic>? statsByType;
  List<dynamic> statsByPeriod = [];

  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    fetchAllStats();
  }

  Future<void> fetchAllStats() async {
    try {
      const baseUrl = 'http://10.0.2.2:5000/api/stats'; // ⬅️ adapte si besoin

      final overviewRes = await http.get(Uri.parse('$baseUrl/overview'));
      final paiementRes = await http.get(Uri.parse('$baseUrl/paiement-stats'));
      final monthlyRes = await http.get(Uri.parse('$baseUrl/monthly-relances'));
      final topAgentsRes = await http.get(Uri.parse('$baseUrl/top-agents'));
      //teste
      final typeRes = await http.get(Uri.parse('$baseUrl/type-declaration'));
      final periodRes = await http.get(
        Uri.parse('$baseUrl/declaration-periode'),
      );

      if (overviewRes.statusCode == 200 &&
          paiementRes.statusCode == 200 &&
          monthlyRes.statusCode == 200 &&
          topAgentsRes.statusCode == 200) {
        setState(() {
          overviewData = json.decode(overviewRes.body);
          paiementData = json.decode(paiementRes.body);
          monthlyRelances = json.decode(monthlyRes.body);
          topAgents = json.decode(topAgentsRes.body);
          isLoading = false;
          //teste
          statsByType = json.decode(typeRes.body);
          statsByPeriod = json.decode(periodRes.body);
        });
      } else {
        setState(() {
          errorMessage =
              'Erreur serveur (${overviewRes.statusCode}, ${paiementRes.statusCode}, ${monthlyRes.statusCode}, ${topAgentsRes.statusCode})';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Erreur de connexion : $e';
        isLoading = false;
      });
    }
  }

  // 🟦 Carte de résumé
  Widget buildOverviewCard(
    String title,
    int value,
    Color color, {
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Card(
        color: color,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
              const SizedBox(height: 8),
              Text(
                '$value',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 🟩 Graphique Paiement Valide / Non Valide (Pie Chart)
  // 🟩 Graphique Paiement Valide / Non Valide (Pie Chart)
  Widget buildPaiementChart() {
    if (paiementData == null) return const SizedBox.shrink();
    final valide = paiementData?['Valide'] ?? 0;
    final nonValide = paiementData?['Non valide'] ?? 0;
    final total = (valide + nonValide).toDouble();

    if (total == 0) {
      return const Center(child: Text("Aucune donnée de paiement."));
    }

    return Card(
      elevation: 3,
      margin: const EdgeInsets.all(12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              'Répartition des paiements',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: PieChart(
                PieChartData(
                  sections: [
                    PieChartSectionData(
                      value: valide.toDouble(),
                      color: Colors.green,
                      title:
                          'Valide\n${((valide / total) * 100).toStringAsFixed(1)}%',
                      radius: 70,
                      titleStyle: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    PieChartSectionData(
                      value: nonValide.toDouble(),
                      color: Colors.redAccent,
                      title:
                          'Non valide\n${((nonValide / total) * 100).toStringAsFixed(1)}%',
                      radius: 70,
                      titleStyle: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            // ✅ Nombre exact
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    Text(
                      'Valide',
                      style: TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text('$valide'),
                  ],
                ),
                Column(
                  children: [
                    Text(
                      'Non valide',
                      style: TextStyle(
                        color: Colors.redAccent,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text('$nonValide'),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildCombinedDeclarationCharts() {
    if (statsByType == null || statsByType!.isEmpty || statsByPeriod.isEmpty) {
      return const Center(child: Text("Aucune statistique disponible."));
    }

    // TOTAL type-declaration
    final total = statsByType!.values
        .map((e) => int.tryParse(e.toString()) ?? 0)
        .fold(0, (sum, v) => sum + v);

    // Bars period
    final bars = statsByPeriod.asMap().entries.map((e) {
      final count = double.tryParse(e.value['count'].toString()) ?? 0;

      return BarChartGroupData(
        x: e.key,
        barRods: [BarChartRodData(toY: count, width: 14, color: Colors.indigo)],
      );
    }).toList();

    return Card(
      margin: const EdgeInsets.all(12),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              "Statistiques des Déclarations",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 15),

            // ------------------ PIE CHART ------------------
            const Text(
              "Répartition par Type de Déclaration",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 220,
              child: PieChart(
                PieChartData(
                  sections: statsByType!.entries.map((e) {
                    final value = int.tryParse(e.value.toString()) ?? 0;
                    final percent = (value / total * 100).toStringAsFixed(1);

                    return PieChartSectionData(
                      value: value.toDouble(),
                      title: "${e.key}\n$percent%",
                      radius: 70,
                      titleStyle: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),

            const SizedBox(height: 25),

            // ------------------ BAR CHART ------------------
            const Text(
              "Déclarations par Période",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 260,
              child: BarChart(
                BarChartData(
                  barGroups: bars,
                  borderData: FlBorderData(show: false),
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          final index = value.toInt();
                          if (index < 0 || index >= statsByPeriod.length) {
                            return const Text('');
                          }

                          final monthLabel = statsByPeriod[index]['month'];
                          return Text(
                            monthLabel != null ? monthLabel.toString() : '',
                            style: const TextStyle(fontSize: 10),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 🟨 Graphique Relances mensuelles (Bar Chart)
  Widget buildMonthlyRelancesChart() {
    if (monthlyRelances.isEmpty) {
      return const Center(child: Text('Aucune relance mensuelle.'));
    }

    final bars = monthlyRelances
        .asMap()
        .entries
        .map(
          (e) => BarChartGroupData(
            x: e.key,
            barRods: [
              BarChartRodData(
                toY: double.parse(e.value['count'].toString()),
                width: 14,
                color: Colors.blueAccent,
              ),
            ],
          ),
        )
        .toList();

    return Card(
      elevation: 3,
      margin: const EdgeInsets.all(12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              'Relances mensuelles',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 250,
              child: BarChart(
                BarChartData(
                  gridData: FlGridData(show: false),
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (val, meta) {
                          final monthIndex = val.toInt();
                          if (monthIndex >= 0 &&
                              monthIndex < monthlyRelances.length) {
                            final month = monthlyRelances[monthIndex]['month'];
                            return Text(
                              month,
                              style: const TextStyle(fontSize: 10),
                            );
                          }
                          return const Text('');
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: true),
                    ),
                    topTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  barGroups: bars,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 🧑‍💼 Liste des top agents
  Widget buildTopAgentsList() {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      elevation: 2,
      child: ExpansionTile(
        leading: const Icon(Icons.people, color: Colors.blue),
        title: const Text(
          'Top Agents (par nombre de relances)',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        children: topAgents.isEmpty
            ? [
                const Padding(
                  padding: EdgeInsets.all(8),
                  child: Text('Aucun agent.'),
                ),
              ]
            : topAgents.map((a) {
                return ListTile(
                  leading: const Icon(Icons.person_outline, color: Colors.blue),
                  title: Text(
                    '${a['agent.nom'] ?? 'Inconnu'} ${a['agent.prenom'] ?? ''}',
                  ),
                  subtitle: Text('Matricule: ${a['matricule']}'),
                  trailing: Text(
                    '${a['total_relances']} relances',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                );
              }).toList(),
      ),
    );
  }

  // 🧱 Build principale
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Tableau de bord',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blueAccent,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage.isNotEmpty
          ? Center(child: Text(errorMessage))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // 🟦 Section Overview
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      buildOverviewCard(
                        'Total Déclarations',
                        overviewData?['totalDeclarations'] ?? 0,
                        Colors.blue,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const AdminDeclarationsPage(),
                            ),
                          );
                        },
                      ),
                      buildOverviewCard(
                        'En Retard',
                        overviewData?['enRetard'] ?? 0,
                        Colors.redAccent,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const DeclarationsRetardPage(),
                            ),
                          );
                        },
                      ),

                      buildOverviewCard(
                        'Non Reçues',
                        overviewData?['nonRecues'] ?? 0,
                        Colors.orange,
                      ),
                      buildOverviewCard(
                        'Relances',
                        overviewData?['totalRelances'] ?? 0,
                        Colors.green,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const RelancesEffectuees1(),
                            ),
                          );
                        },
                      ),
                      buildOverviewCard(
                        'Agents Actifs',
                        overviewData?['agentsActifs'] ?? 0,
                        Colors.purple,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const ListeAgents1(),
                            ),
                          );
                        },
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const DefaillantsPage2(),
                            ),
                          );
                        },
                        child: buildOverviewCard(
                          'Contribuables Défaillants',
                          overviewData?['totalDefaillants'] ?? 0,
                          Colors.deepOrange,
                        ),
                      ),
                      //teste
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const ListeContribuables1(),
                            ),
                          );
                        },
                        child: buildOverviewCard(
                          'Total Contribuables',
                          overviewData?['totalContribuables'] ?? 0,
                          Colors.deepOrange,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // 🟩 Graphique Paiements
                  buildPaiementChart(),

                  // 🟨 Graphique Relances Mensuelles
                  buildMonthlyRelancesChart(),

                  // 🧑‍💼 Top Agents
                  buildTopAgentsList(),

                  buildCombinedDeclarationCharts(),
                ],
              ),
            ),
    );
  }
}*/
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fl_chart/fl_chart.dart';
import 'package:my_app/screens/declarationRetard_page.dart';
import 'package:my_app/screens/filtre_declaration.dart';
import 'package:my_app/screens/liste_agents1.dart';
import 'package:my_app/screens/relances_effectues.dart';
import 'package:my_app/screens/totalDefaillant_page.dart';
import 'package:my_app/screens/touts_contribuable.dart';

class StatsDashboardPage extends StatefulWidget {
  const StatsDashboardPage({super.key});

  @override
  State<StatsDashboardPage> createState() => _StatsDashboardPageState();
}

class _StatsDashboardPageState extends State<StatsDashboardPage> {
  Map<String, dynamic>? overviewData;
  Map<String, dynamic>? paiementData;
  List<dynamic> monthlyRelances = [];
  List<dynamic> topAgents = [];
  Map<String, dynamic>? statsByType;
  List<dynamic> statsByPeriod = [];

  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    fetchAllStats();
  }

  Future<void> fetchAllStats() async {
    try {
      const baseUrl = 'http://10.0.2.2:5000/api/stats';

      final overviewRes = await http.get(Uri.parse('$baseUrl/overview'));
      final paiementRes = await http.get(Uri.parse('$baseUrl/paiement-stats'));
      final monthlyRes = await http.get(Uri.parse('$baseUrl/monthly-relances'));
      final topAgentsRes = await http.get(Uri.parse('$baseUrl/top-agents'));
      final typeRes = await http.get(Uri.parse('$baseUrl/type-declaration'));
      final periodRes = await http.get(
        Uri.parse('$baseUrl/declaration-periode'),
      );

      if (overviewRes.statusCode == 200 &&
          paiementRes.statusCode == 200 &&
          monthlyRes.statusCode == 200 &&
          topAgentsRes.statusCode == 200) {
        setState(() {
          overviewData = json.decode(overviewRes.body);
          paiementData = json.decode(paiementRes.body);
          monthlyRelances = json.decode(monthlyRes.body);
          topAgents = json.decode(topAgentsRes.body);
          statsByType = json.decode(typeRes.body);
          statsByPeriod = json.decode(periodRes.body);
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = 'Erreur serveur';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Erreur de connexion : $e';
        isLoading = false;
      });
    }
  }

  // 🟦 Carte Overview améliorée
  Widget buildOverviewCard(
    String title,
    int value,
    Color color, {
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        color: color,
        child: SizedBox(
          width: 160,
          height: 100,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                Text(
                  '$value',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // 🟩 Graphique Paiement amélioré
  Widget buildPaiementChart() {
    if (paiementData == null) return const SizedBox.shrink();
    final valide = paiementData?['Valide'] ?? 0;
    final nonValide = paiementData?['Non valide'] ?? 0;
    final total = (valide + nonValide).toDouble();

    if (total == 0)
      return const Center(child: Text("Aucune donnée de paiement."));

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 12),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              'Répartition des paiements',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: PieChart(
                PieChartData(
                  sections: [
                    PieChartSectionData(
                      value: valide.toDouble(),
                      color: Colors.green,
                      title:
                          'Valide\n${((valide / total) * 100).toStringAsFixed(1)}%',
                      radius: 70,
                      titleStyle: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    PieChartSectionData(
                      value: nonValide.toDouble(),
                      color: const Color.fromARGB(255, 255, 68, 68),
                      title:
                          'Non valide\n${((nonValide / total) * 100).toStringAsFixed(1)}%',
                      radius: 70,
                      titleStyle: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    Text(
                      'Valide',
                      style: TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text('$valide'),
                  ],
                ),
                Column(
                  children: [
                    Text(
                      'Non valide',
                      style: TextStyle(
                        color: const Color.fromARGB(255, 255, 68, 68),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text('$nonValide'),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // 🟨 Graphique Relances Mensuelles amélioré
  Widget buildMonthlyRelancesChart() {
    if (monthlyRelances.isEmpty) {
      return const Center(child: Text('Aucune relance mensuelle.'));
    }

    final bars = monthlyRelances
        .asMap()
        .entries
        .map(
          (e) => BarChartGroupData(
            x: e.key,
            barRods: [
              BarChartRodData(
                toY: double.parse(e.value['count'].toString()),
                width: 14,
                color: Colors.blueAccent,
              ),
            ],
          ),
        )
        .toList();

    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              'Relances mensuelles',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 250,
              child: BarChart(
                BarChartData(
                  gridData: FlGridData(show: false),
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (val, meta) {
                          final monthIndex = val.toInt();
                          if (monthIndex >= 0 &&
                              monthIndex < monthlyRelances.length) {
                            final month = monthlyRelances[monthIndex]['month'];
                            return Text(
                              month,
                              style: const TextStyle(fontSize: 10),
                            );
                          }
                          return const Text('');
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: true),
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  barGroups: bars,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 🧑‍💼 Liste Top Agents améliorée
  Widget buildTopAgentsList() {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ExpansionTile(
        leading: const Icon(Icons.people, color: Colors.blueAccent),
        title: const Text(
          'Top Agents (par nombre de relances)',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        children: topAgents.isEmpty
            ? [
                const Padding(
                  padding: EdgeInsets.all(8),
                  child: Text('Aucun agent'),
                ),
              ]
            : topAgents.map((a) {
                return Column(
                  children: [
                    ListTile(
                      leading: const Icon(
                        Icons.person_outline,
                        color: Colors.blue,
                      ),
                      title: Text(
                        '${a['agent.nom'] ?? 'Inconnu'} ${a['agent.prenom'] ?? ''}',
                      ),
                      subtitle: Text('Matricule: ${a['matricule']}'),
                      trailing: Text(
                        '${a['total_relances']} relances',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    const Divider(height: 1),
                  ],
                );
              }).toList(),
      ),
    );
  }

  // 🟪 Déclarations par Type et Période
  Widget buildCombinedDeclarationCharts() {
    if (statsByType == null || statsByType!.isEmpty || statsByPeriod.isEmpty) {
      return const Center(child: Text("Aucune statistique disponible."));
    }

    final total = statsByType!.values
        .map((e) => int.tryParse(e.toString()) ?? 0)
        .fold(0, (sum, v) => sum + v);

    final bars = statsByPeriod.asMap().entries.map((e) {
      final count = double.tryParse(e.value['count'].toString()) ?? 0;
      return BarChartGroupData(
        x: e.key,
        barRods: [
          BarChartRodData(toY: count, width: 14, color: Colors.blueAccent),
        ],
      );
    }).toList();

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 12),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              "Statistiques des Déclarations",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 15),

            const Text(
              "Répartition par Type de Déclaration",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 220,
              child: PieChart(
                PieChartData(
                  sections: statsByType!.entries.map((e) {
                    final value = int.tryParse(e.value.toString()) ?? 0;
                    final percent = (value / total * 100).toStringAsFixed(1);
                    return PieChartSectionData(
                      value: value.toDouble(),
                      title: "${e.key}\n$percent%",
                      radius: 70,
                      titleStyle: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
            const SizedBox(height: 25),
            const Text(
              "Déclarations par Période",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 260,
              child: BarChart(
                BarChartData(
                  barGroups: bars,
                  borderData: FlBorderData(show: false),
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          int index = value.toInt();
                          if (index < 0 || index >= statsByPeriod.length) {
                            return const Text("");
                          }

                          final periode = statsByPeriod[index]['periode'];

                          return Text(
                            periode != null ? periode.toString() : '',
                            style: const TextStyle(fontSize: 10),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Tableau de bord',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF4C6C89),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage.isNotEmpty
          ? Center(child: Text(errorMessage))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      buildOverviewCard(
                        'Total Déclarations',
                        overviewData?['totalDeclarations'] ?? 0,
                        Colors.blue,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const AdminDeclarationsPage(),
                            ),
                          );
                        },
                      ),
                      buildOverviewCard(
                        'En Retard',
                        overviewData?['enRetard'] ?? 0,
                        Colors.blue,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const DeclarationsRetardPage(),
                            ),
                          );
                        },
                      ),
                      buildOverviewCard(
                        'Non Reçues',
                        overviewData?['nonRecues'] ?? 0,
                        Colors.blue,
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const ListeContribuables1(),
                            ),
                          );
                        },
                        child: buildOverviewCard(
                          'Total Contribuables',
                          overviewData?['totalContribuables'] ?? 0,
                          Colors.blue,
                        ),
                      ),

                      /*buildOverviewCard(
                        'Relances',
                        overviewData?['totalRelances'] ?? 0,
                        Colors.green,
                      ),*/
                      buildOverviewCard(
                        'Total Relances',
                        overviewData?['totalRelances'] ?? 0,
                        Colors.green,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const RelancesEffectuees1(),
                            ),
                          );
                        },
                      ),
                      /*buildOverviewCard(
                        'Agents Actifs',
                        overviewData?['agentsActifs'] ?? 0,
                        Colors.purple,
                      ),*/
                      buildOverviewCard(
                        'Agents Actifs',
                        overviewData?['agentsActifs'] ?? 0,
                        Colors.green,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const ListeAgents1(),
                            ),
                          );
                        },
                      ),
                      /*buildOverviewCard(
                        'Défaillants',
                        overviewData?['totalDefaillants'] ?? 0,
                        Colors.deepOrange,
                      ),*/
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const DefaillantsPage2(),
                            ),
                          );
                        },
                        child: buildOverviewCard(
                          'Total Défaillants',
                          overviewData?['totalDefaillants'] ?? 0,
                          const Color.fromARGB(255, 255, 68, 68),
                        ),
                      ),
                    ],
                  ),
                  buildPaiementChart(),
                  buildMonthlyRelancesChart(),
                  buildTopAgentsList(),
                  buildCombinedDeclarationCharts(),
                ],
              ),
            ),
    );
  }
}
