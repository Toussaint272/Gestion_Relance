// lib/data/relance_data.dart
class Relance {
  final String contribuable;
  final String mode;
  final DateTime date;

  Relance({
    required this.contribuable,
    required this.mode,
    required this.date,
    required String message,
  });
}

// Mock global list
List<Relance> relancesEffectuees = [];
