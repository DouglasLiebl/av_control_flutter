import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiEndpoints {
  static String baseUrl = dotenv.env["BASE_URL"] ?? "";

  static String get login => "$baseUrl/login";
  static String get refreshToken => "$baseUrl/refresh-token";

  static String get registerNewAviary => "$baseUrl/aviary/";

  static String get allotmentBaseUrl => "$baseUrl/allotment"; 
  static String get registerMortality => "$baseUrl/allotment/mortality";
  static String get registerWaterConsume => "$baseUrl/allotment/water-consume";
  static String get registerWeight => "$baseUrl/allotment/weight";
  static String get registerFeed => "$baseUrl/allotment/feed";


}