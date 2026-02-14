import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_endpoints.dart';

class DeclarationService {
  /*final String baseUrl = "http://10.155.28.240:5000/api";*/
  final String baseUrl = ApiEndpoints.baseApi;

  // 🔹 Récupérer les déclarations d’un contribuable
  Future<List<dynamic>> getDeclarations(String taxPayerNo) async {
    final url = Uri.parse('$baseUrl/declarationRoute/$taxPayerNo');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Erreur lors du chargement des déclarations');
    }
  }

  // 🔹 Envoyer relance automatique
  /*Future<void> sendAutoRelance(String taxPayerNo) async {
    final url = Uri.parse('$baseUrl/relance_declarationRoute/send');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'tax_payer_no': taxPayerNo,
        'matricule': agentMatricule, // 👈 agent connecte
        
        }),
    );

    if (response.statusCode != 201) {
      throw Exception('Échec lors de l’envoi de la relance');
    }
  }*/

  Future<void> sendAutoRelance(String taxPayerNo, String agentMatricule) async {
    final url = Uri.parse('$baseUrl/relance_declarationRoute/send');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'tax_payer_no': taxPayerNo,
        'matricule': agentMatricule, // ✅ mandeha tsara izao
      }),
    );

    if (response.statusCode != 201) {
      throw Exception('Échec lors de l’envoi de la relance');
    }
  }
}
