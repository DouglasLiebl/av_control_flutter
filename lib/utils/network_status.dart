import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

class NetworkStatus {
  static final NetworkStatus _instance = NetworkStatus._internal();
  
  NetworkStatus._internal();
  
  static NetworkStatus get instance => _instance;

  Future<bool> get hasConnection async {
    return await InternetConnection().hasInternetAccess;
  }
}