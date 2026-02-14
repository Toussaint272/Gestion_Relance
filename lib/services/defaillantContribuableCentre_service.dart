import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_endpoints.dart';

class ApiService {
  /*static const String baseUrl = 'http://10.155.28.240:5000/api';*/
  static const String baseUrl = ApiEndpoints.baseApi;

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
