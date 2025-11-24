import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  String? token;
  String? role;
  Map<String, dynamic>? userInfo;

  // Fonction login
  Future<bool> login(String email, String password) async {
    final url = Uri.parse(
      'http://10.0.2.2:5000/api/auth/login',
    ); // localhost emulator
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      token = data['token'];
      role = data['user']['role'];
      userInfo = data['user'];
      return true;
    } else {
      return false;
    }
  }
}

/*import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  String? token;
  String? role;
  Map<String, dynamic>? userInfo;

  Future<bool> login(String email, String password) async {
    final url = Uri.parse('http://10.0.2.2:5000/api/auth/login');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      token = data['token'];
      role = data['user']['role'];
      userInfo = data['user'];

      final prefs = await SharedPreferences.getInstance();

      // ✅ Tahirizo tsara ny ID agent sy vaovao rehetra
      await prefs.setInt('agentId', data['user']['id']);
      await prefs.setString('userRole', data['user']['role']);
      await prefs.setString('userEmail', data['user']['email']);

      print('✅ Agent ID sauvegardé: ${data['user']['id']}'); // debug

      return true;
    } else {
      print('❌ Login échoué : ${response.body}');
      return false;
    }
  }
}*/
