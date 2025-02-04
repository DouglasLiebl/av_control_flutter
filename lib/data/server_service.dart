import 'dart:convert';
import 'dart:io';
import 'package:demo_project/models/account.dart';
import 'package:demo_project/models/auth.dart';
import 'package:demo_project/models/aviary.dart';
import 'package:http/http.dart' as http;

class ServerService {
  final String baseUrl = Platform.isAndroid 
    ? 'http://10.0.2.2:8080'
    : 'http://localhost:8080';

  Future<Account> login(String email, String password) async {
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
  }

  Future<Aviary> registerAviary(Auth auth, String name, String alias) async {
    final response = await http.post(
      Uri.parse('$baseUrl/account/aviary'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': '${auth.tokenType} ${auth.accessToken}'
      },
      body: jsonEncode({
        'name': name,
        'alias': alias,
        'accountId': auth.accountId
      })
    );

    if (response.statusCode == 201) {
      final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      return Aviary.fromJson(jsonResponse);
    } else {
      throw Exception("Failed to register Aviary: ${response.body}");
    }
  }
}