import 'dart:convert';
import 'package:demo_project/models/account.dart';
import 'package:http/http.dart' as http;

class ServerService {
  final String baseUrl = 'http://10.0.2.2:8080';

  Future<Account> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        return Account.fromJson(jsonResponse);
      } else {
        throw Exception('Failed to login: ${response.body}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }
}