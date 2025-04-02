import 'dart:convert';
import 'dart:io';
import 'package:demo_project/dto/feed_dto.dart';
import 'package:demo_project/dto/mortality_dto.dart';
import 'package:demo_project/dto/water_dto.dart';
import 'package:demo_project/models/account.dart';
import 'package:demo_project/models/allotment.dart';
import 'package:demo_project/models/auth.dart';
import 'package:demo_project/models/aviary.dart';
import 'package:demo_project/models/weight.dart';
import 'package:demo_project/models/weight_box.dart';
import 'package:http/http.dart' as http;

class ServerService {
  final String baseUrl = Platform.isAndroid 
    ? 'http://44.201.40.23:8080'
    : 'http://44.201.40.23:8080';

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
      Uri.parse('$baseUrl/aviary/'),
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
      Uri.parse('$baseUrl/allotment/'),
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

  Future<MortalityDto> registerMortality(Auth auth, String allotmentId, int deaths, int eliminations) async {
    final response = await http.post(
      Uri.parse('$baseUrl/allotment/deaths'),
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
      return MortalityDto.fromJson(jsonResponse);
    } else {
      throw Exception("Failed to register a new mortality");
    }
  }

  Future<Allotment> getAllotmentDetails(Auth auth, String allotmentId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/allotment/$allotmentId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': '${auth.tokenType} ${auth.accessToken}'
      }
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = await jsonDecode(response.body);
      print(jsonResponse);
      return Allotment.fromJson(jsonResponse);
    } else {
      throw Exception("Failed to fetch allotment details");
    }
  }

  Future<WaterDto> registerWaterHistory(Auth auth, int? multiplier, String allotmentId, int measure) async {
    final response = await http.post(
      Uri.parse('$baseUrl/allotment/water'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': '${auth.tokenType} ${auth.accessToken}'
      },
      body: jsonEncode({
        'multiplier': multiplier,
        'allotmentId': allotmentId,
        'currentMeasure': measure
      })
    );

    if (response.statusCode == 201) {
      Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      return WaterDto.fromJson(jsonResponse);
    } else {
      throw Exception("Failed to register water History");
    }
  }

  Future<Weight> registerWeight(
    Auth auth, 
    String allotmentId,
    int totalUnits,
    double tare,
    List<WeightBox> weights
  ) async {
    final response = await http.post(
      Uri.parse("$baseUrl/allotment/weight"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "${auth.tokenType} ${auth.accessToken}"
      },
      body: jsonEncode({
        "allotmentId": allotmentId,
        "totalUnits": totalUnits,
        "tare": tare,
        "weights": weights.map((w) => WeightBox.toJson(w)).toList()
      })
    );

    if (response.statusCode == 201) {
      Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      return Weight.fromJson(jsonResponse);
    } else {
      throw Exception("Failed to register Weight");
    }
  }

  Future<FeedDto> registerFeed(
    Auth auth, 
    String allotmentId,
    String accessKey,
    String nfeNumber,
    String emittedAt,
    double weight,
    String type
  ) async {
    print("RECEIVED ID $allotmentId");
    final response = await http.post(
      Uri.parse("$baseUrl/allotment/feed"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "${auth.tokenType} ${auth.accessToken}"
      },
      body: jsonEncode({
        "allotmentId": allotmentId,
        "accessKey": accessKey,
        "nfeNumber": nfeNumber,
        "emittedAt": emittedAt,
        "weight": weight,
        "type": type.replaceAll(" ", "_")
      })
    );

    
    if (response.statusCode == 201) {
      Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      return FeedDto.fromJson(jsonResponse);
    } else {
      throw Exception("Failed to register new Feed");
    }
  
  }
}