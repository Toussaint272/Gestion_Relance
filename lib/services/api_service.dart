import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/declaration.dart';

class ApiService {
  static const String baseUrl = "http://10.0.2.2:5000/api";

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
