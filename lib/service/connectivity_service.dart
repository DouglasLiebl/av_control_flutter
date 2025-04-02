import 'dart:convert';
import 'dart:io';

import 'package:demo_project/data/database_helper.dart';
import 'package:demo_project/data/secure_storage_service.dart';
import 'package:demo_project/dto/mortality_dto.dart';
import 'package:demo_project/models/auth.dart';
import 'package:demo_project/models/sync_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:http/http.dart' as http;

class ConnectivityService extends ChangeNotifier {
  bool _hasInternetConnection = true;
  final DatabaseHelper _dbHelper = DatabaseHelper();
  final SecureStorageService _secureStorage = SecureStorageService(storage: FlutterSecureStorage());

  final String baseUrl = Platform.isAndroid 
    ? 'http://10.0.2.2:8080'
    : 'http://localhost:8080';

  bool get hasInternetConnection => _hasInternetConnection;

  Connectivityservice() {
    InternetConnection().onStatusChange.listen((status) async {
      _hasInternetConnection = status == InternetStatus.connected;

      if (_hasInternetConnection) {
        await _syncPendingData();
      }

      notifyListeners();
    });
  }

  Future<void> _syncPendingData() async {
    print("STARTED TO SYNC DATA");
    if (await _dbHelper.hasDataToSync()) {
      print("HAS DATA TO SYNC");
      final pendingOperations = await _dbHelper.getPendingOperations();

      for (SyncData operation in pendingOperations) {
        switch (operation.type) {
          case "MORTALITY":
            await _syncMortality(operation);
            break;
        }
      }
    }
  }

  Future<void> _syncMortality(SyncData data) async {
    Auth? auth = await _secureStorage.getAuth();

    if (auth != null) {
      final response = await http.post(
        Uri.parse('$baseUrl/allotment/deaths'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': '${auth.tokenType} ${auth.accessToken}'
        },
        body: jsonEncode(data.data)
      );

      if (response.statusCode == 201) {
        Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        _dbHelper.registerMortality(MortalityDto.fromJson(jsonResponse));
      }
    }
  }
}