import 'dart:convert';
import 'dart:io';

import 'package:demo_project/data/database_helper.dart';
import 'package:demo_project/infra/dto/mortality_dto.dart';
import 'package:demo_project/domain/entity/sync_data.dart';
import 'package:http/http.dart' as http;

class SyncService {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  final String baseUrl = Platform.isAndroid 
    ? 'http://10.0.2.2:8080'
    : 'http://localhost:8080';

  void syncrhronize() async {
    _syncPendingData();
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

      _dbHelper.cleanOfflineSync();
    }
  }

  Future<void> _syncMortality(SyncData data) async {


      final response = await http.post(
        Uri.parse('$baseUrl/allotment/deaths'),
        headers: {
          'Content-Type': 'application/json'
        },
        body: data.data
      );

      if (response.statusCode == 201) {
        Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        _dbHelper.registerMortality(MortalityDto.fromJson(jsonResponse));
      }
    }
}