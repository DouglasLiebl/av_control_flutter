import 'dart:convert';
import 'dart:io';
import 'package:demo_project/models/account.dart';
import 'package:demo_project/models/allotment.dart';
import 'package:demo_project/models/auth.dart';
import 'package:demo_project/models/aviary.dart';
import 'package:demo_project/models/mortality.dart';
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

  Future<Allotment> startAllotment(Auth auth, int totalAmount, String aviaryId) async {
    final response = await http.post(
      Uri.parse('$baseUrl/account/allotment'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': '${auth.tokenType} ${auth.accessToken}'
      },
      body: jsonEncode({
        'totalAmount': totalAmount,
        'aviaryId': aviaryId
      })
    );

    if (response.statusCode == 201) {
      final Map<String, dynamic> jsonReponse = jsonDecode(response.body);
      return Allotment.fromJson(jsonReponse);
    } else {
      throw Exception("Failed to register Allotment");
    }
  }

  Future<Mortality> registerMortality(Auth auth, String allotmentId, int deaths, int eliminations) async {
    final response = await http.post(
      Uri.parse('$baseUrl/account/allotment/deaths'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': '${auth.tokenType} ${auth.accessToken}'
      },
      body: jsonEncode({
        'allotmentId': allotmentId,
        'deaths': deaths,
        'eliminations': eliminations
      })
    );

    if (response.statusCode == 201) {
      final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      return Mortality.fromJson(jsonResponse);
    } else {
      throw Exception("Failed to register a new mortality");
    }
  }

  Future<Allotment> getAllotmentDetails(Auth auth, String allotmentId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/account/allotment/$allotmentId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': '${auth.tokenType} ${auth.accessToken}'
      }
    );

    print("REQUEST RECEIVED");
    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = await jsonDecode(response.body);
      return Allotment.fromJson(jsonResponse);
    } else {
      throw Exception("Failed to fetch allotment details");
    }
  }
}