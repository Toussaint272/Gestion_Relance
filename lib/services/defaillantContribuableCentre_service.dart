import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'http://10.0.2.2:5000/api';

  static Future<Map<String, dynamic>> getDefaillantsByMatricule(
    String matricule,
  ) async {
    final response = await http.get(
      Uri.parse(
        '$baseUrl/contribuableCentreRoute/by-Centre?matricule=$matricule',
      ),
    );
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception(
        'Erreur lors du chargement des contribuables défaillants',
      );
    }
  }
}
