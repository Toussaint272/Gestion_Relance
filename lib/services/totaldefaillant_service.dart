import 'dart:convert';
import 'package:http/http.dart' as http;

class DefaillantService {
  final String baseUrl = "http://10.0.2.2:5000/api/totalDefaillantRoute/all";

  Future<Map<String, dynamic>> getDefaillants() async {
    final res = await http.get(Uri.parse(baseUrl));

    if (res.statusCode == 200) {
      return jsonDecode(res.body);
    } else {
      throw Exception("Erreur serveur (${res.statusCode})");
    }
  }
}
