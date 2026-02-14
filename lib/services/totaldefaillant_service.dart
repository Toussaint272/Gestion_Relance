import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_endpoints.dart';

class DefaillantService {
  /*final String baseUrl =
      "http://10.155.28.240:5000/api/totalDefaillantRoute/all";*/
  final String baseUrl = ApiEndpoints.totalDefaillant;

  Future<Map<String, dynamic>> getDefaillants() async {
    final res = await http.get(Uri.parse(baseUrl));

    if (res.statusCode == 200) {
      return jsonDecode(res.body);
    } else {
      throw Exception("Erreur serveur (${res.statusCode})");
    }
  }
}
