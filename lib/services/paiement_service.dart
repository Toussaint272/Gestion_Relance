import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/paiement.dart';
import '../config/api_endpoints.dart';

class PaiementService {
  /*static const String baseUrl = 'http://10.155.28.240:5000/api/paiementRoute';*/
  static const String baseUrl = ApiEndpoints.paiementBase;

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
