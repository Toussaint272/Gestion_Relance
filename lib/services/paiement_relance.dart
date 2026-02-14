import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_endpoints.dart';

class PaiementService1 {
  static Future<void> sendRelance({
    required String taxPayerNo,
    required int NDecl,
    required agentMatricule,

    //required String message,
  }) async {
    /*final url = Uri.parse('http://10.155.28.240:5000/api/relanceRoute/send');*/
    final url = Uri.parse(ApiEndpoints.relanceSend);
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'tax_payer_no': taxPayerNo,
        'N_decl': NDecl,
        'matricule': agentMatricule, // ✅ mandeha tsara izao
        //'message': message,
      }),
    );

    if (response.statusCode != 201) {
      throw Exception('Erreur lors de l’envoi de la relance');
    }
  }
}
