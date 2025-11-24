import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/paiement.dart';

class PaiementService {
  static const String baseUrl = 'http://10.0.2.2:5000/api/paiementRoute';
  // Raha amin'ny téléphone tena izy: soloina amin'ny IP an'ny backend, ex: 'http://192.168.43.10:5000/api/paiement1'

  static Future<List<Paiement1>> fetchPaiements() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((p) => Paiement1.fromJson(p)).toList();
    } else {
      throw Exception('Erreur lors du chargement des paiements');
    }
  }
}
