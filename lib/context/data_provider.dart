import 'package:demo_project/data/database_helper.dart';
import 'package:demo_project/data/server_service.dart';
import 'package:demo_project/models/account.dart';
import 'package:demo_project/models/auth.dart';
import 'package:demo_project/models/aviary.dart';
import 'package:flutter/material.dart';

class DataProvider with ChangeNotifier {
  final DatabaseHelper dbHelper = DatabaseHelper();
  final ServerService _serverService = ServerService();
  Account _account = Account(
    id: '',
    firstName: '',
    lastName: '',
    email: '',
    aviaries: [],
    authData: Auth(
      accountId: '',
      accessToken: '',
      tokenType: '',
      refreshToken: '',
      accessTokenExpiration: '',
    ),
  );
  
  DataProvider() {
    _loadContext();
  }

  Account get getAccount => _account;  

  Future<void> _loadContext() async {
    final accountData = await dbHelper.getContext();
    _account = accountData;
    notifyListeners();
  }

  Future<void> login(String email, String password) async {
    try {
      Account response = await _serverService.login(email, password);
      await dbHelper.registerAccountData(response);
      _account = response;
      notifyListeners();
    } catch (e) {
      throw Exception('Login failed: $e');
    }
    notifyListeners();
  }

  Future<void> logout() async {
    await dbHelper.cleanDatabase(_account.id);
    _account = Account(
      id: '',
      firstName: '',
      lastName: '',
      email: '',
      aviaries: [],
      authData: Auth(
        accountId: '',
        accessToken: '',
        tokenType: '',
        refreshToken: '',
        accessTokenExpiration: '',
      ),
    );
    notifyListeners();
  }

  Future<void> registerAviary(String name, String alias) async {
    Aviary r = await _serverService.registerAviary(_account.authData, name, alias);
    await dbHelper.registerAviaryData(r);
    _account.aviaries.add(r);
    notifyListeners();
  }

  Future<void> updateActiveAllotmentId(String aviaryId, String allotmentId) async {
    for (var a in _account.aviaries) {
      if (a.id == aviaryId) {
        a.activeAllotmentId = allotmentId;
      }
    }

    notifyListeners(); 
  }

  Auth getAuth() {
    return _account.authData;
  }

  Future<void> reloadContext() async {
    _loadContext();
  }
}