import 'package:demo_project/data/database_helper.dart';
import 'package:demo_project/data/server_service.dart';
import 'package:demo_project/models/allotment.dart';
import 'package:demo_project/models/auth.dart';
import 'package:flutter/material.dart';

class AllotmentProvider with ChangeNotifier {
  final DatabaseHelper dbHelper = DatabaseHelper();
  final ServerService _serverService = ServerService();

  Allotment _allotment = Allotment(
    id: '', 
    aviaryId: '', 
    isActive: false, 
    number: 0, 
    totalAmount: 0, 
    currentAge: 0, 
    startedAt: '', 
    endedAt: '', 
    currentDeathPercentage: 0, 
    currentWeight: 0, 
    currentTotalWaterConsume: 0, 
    waterHistory: [], 
    mortalityHistory: [], 
    weightHistory: []
  );

  AllotmentProvider();

  Allotment get getAllotment => _allotment;

  Future<void> loadContext(String allotmentId) async {
    final allotmentData = await dbHelper.getAllotmentContext(allotmentId);
    _allotment = allotmentData; 
    notifyListeners();
  }

  Future<void> registerAllotment(Auth auth, aviaryId, int totalAmount) async {
    try {
      Allotment response = await _serverService.startAllotment(auth, totalAmount, aviaryId);
      await dbHelper.registerNewAllotment(response);
      _allotment = response;
      notifyListeners();
    } catch (e) {
      throw Exception("Failed to register a new allotment $e");
    }
  }

  Future<void> cleanContext() async {
    _allotment = Allotment(
      id: '', 
      aviaryId: '', 
      isActive: false, 
      number: 0, 
      totalAmount: 0, 
      currentAge: 0, 
      startedAt: '', 
      endedAt: '', 
      currentDeathPercentage: 0, 
      currentWeight: 0, 
      currentTotalWaterConsume: 0, 
      waterHistory: [], 
      mortalityHistory: [], 
      weightHistory: []
    );

    notifyListeners();
  }
}