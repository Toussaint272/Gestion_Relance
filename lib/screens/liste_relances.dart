import 'package:flutter/material.dart';
import 'relance_data.dart';

class RelancesEffectuees extends StatelessWidget {
  const RelancesEffectuees({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Relances effectuées')),
      body: ListView.builder(
        itemCount: relancesEffectuees.length,
        itemBuilder: (context, index) {
          final relance = relancesEffectuees[index];
          return ListTile(
            leading: const Icon(Icons.notifications_active),
            title: Text(relance.contribuable),
            subtitle: Text('Mode : ${relance.mode}'),
            trailing: Text(
              '${relance.date.day}/${relance.date.month}/${relance.date.year}',
              style: const TextStyle(color: Colors.grey),
            ),
          );
        },
      ),
    );
  }
}
