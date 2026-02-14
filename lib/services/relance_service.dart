/*import 'dart:convert';
import 'package:http/http.dart' as http;

class RelanceService {
  static const String baseUrl = "http://10.0.2.2:5000/api"; // ovay IP raha ilaina

  /// Filtrer relance par centre fiscal
  static Future<List<dynamic>> getRelanceByCentre(String centre) async {
    final url = Uri.parse("$baseUrl/filtre-centre?centre=$centre");

    final response = await http.get(url);

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception("Erreur serveur: ${response.statusCode}");
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
}*/
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_endpoints.dart';

class RelanceService {
  /*static const String baseUrl = "http://10.155.28.240:5000/api";*/
  static const String baseUrl = ApiEndpoints.baseApi;

  /// Filtrer relance par centre fiscal
  static Future<List<dynamic>> getRelanceByCentre(String centre) async {
    final url = Uri.parse("$baseUrl/relanceRoute/filtre-centre?centre=$centre");

    final response = await http.get(url);

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception("Erreur serveur: ${response.statusCode}");
    }
  }

  /// Récupérer liste des centres fiscaux
  static Future<List<String>> getCentres() async {
    final response = await http.get(
      Uri.parse('$baseUrl/centreRouteContribuable'),
    );

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((e) => e.toString()).toList();
    } else {
      throw Exception('Erreur lors du chargement des centres fiscaux');
    }
  }
}
