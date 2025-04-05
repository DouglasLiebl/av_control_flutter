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
    
  }


}