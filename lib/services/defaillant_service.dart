/*import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'http://10.0.2.2:5000/api/defaillantRoute';
  // ⚠️ 10.0.2.2 pour Android Emulator / sinon localhost:5000 pour web

  static Future<Map<String, dynamic>> getDefaillants(String centreName) async {
    final response = await http.get(Uri.parse('$baseUrl/$centreName'));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception(
        'Erreur lors du chargement des contribuables défaillants',
      );
    }
  }
}*/
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_endpoints.dart';

class ApiService {
  /*static const String baseUrl = 'http://10.155.28.240:5000/api';*/
  static const String baseUrl = ApiEndpoints.baseApi;

  // 🔹 Récupérer les contribuables défaillants par centre
  static Future<Map<String, dynamic>> getDefaillants(String centreName) async {
    final response = await http.get(
      Uri.parse('$baseUrl/defaillantRoute/$centreName'),
    );
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception(
        'Erreur lors du chargement des contribuables défaillants',
      );
    }
  }

  // 🔹 Récupérer automatiquement la liste des centres
  static Future<List<String>> getCentres() async {
    final response = await http.get(
      Uri.parse('$baseUrl/centreRouteContribuable'),
    );
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.cast<String>();
    } else {
      throw Exception('Erreur lors du chargement des centres fiscaux');
    }
  }
}
