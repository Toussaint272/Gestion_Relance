import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/paiement.dart';

class PaiementService {
  static const String baseUrl = 'http://10.0.2.2:5000/api/paiementRoute';

  static Future<List<Paiement1>> fetchPaiementsByContribuable(
    String taxPayerNo,
  ) async {
    final response = await http.get(
      // ❌ Miala amin'ny "/contribuable/"
      Uri.parse('$baseUrl'),
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      // Raha tianao ny hisehoan’ny paiements an’ny contribuable iray ihany
      final filtered = jsonList
          .where((item) => item['tax_payer_no'] == taxPayerNo)
          .toList();
      return filtered.map((json) => Paiement1.fromJson(json)).toList();
    } else {
      print("Erreur ${response.statusCode} : ${response.body}");
      throw Exception('Erreur lors de la récupération des paiements');
    }
  }
}
