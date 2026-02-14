import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/declaration.dart';
import '../config/api_endpoints.dart';

class ApiService {
  /*static const String baseUrl = "http://10.155.28.240:5000/api";*/
  static const String baseUrl = ApiEndpoints.baseApi;

  Future<List<Declaration1>> fetchDeclarations() async {
    final response = await http.get(Uri.parse('$baseUrl/declarationRoute'));
    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      return data.map((e) => Declaration1.fromJson(e)).toList();
    } else {
      throw Exception('Erreur de chargement des déclarations');
    }
  }
}
