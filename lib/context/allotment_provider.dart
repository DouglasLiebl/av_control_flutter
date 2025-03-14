import 'package:demo_project/data/database_helper.dart';
import 'package:demo_project/data/server_service.dart';
import 'package:demo_project/dto/mortality_dto.dart';
import 'package:demo_project/dto/water_dto.dart';
import 'package:demo_project/models/allotment.dart';
import 'package:demo_project/models/auth.dart';
import 'package:demo_project/models/mortality.dart';
import 'package:demo_project/models/water.dart';
import 'package:demo_project/models/weight.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

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

  Future<void> loadContext(Auth auth, String allotmentId) async {
    bool status = await InternetConnection().hasInternetAccess;
    
    if (status) {
      final allotmentData = await _serverService.getAllotmentDetails(auth, allotmentId);
      _allotment = allotmentData;
      await dbHelper.updateAllotmentData(allotmentData);
      notifyListeners();
    } else {
      final allotmentData = await dbHelper.getAllotmentContext(allotmentId);
      _allotment = allotmentData; 
      notifyListeners();
    }

   
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

  String getId() {
    return _allotment.id;
  }

  List<Mortality> getMortalityHistory() {
    return _allotment.mortalityHistory;
  }

  List<Water> getWaterHistory() {
    return _allotment.waterHistory;
  }

  List<Weight> getWeightHistory() {
    return _allotment.weightHistory;
  }

  Future<void> updateMortality(Auth auth, int deaths, int eliminations) async {
    MortalityDto response = await _serverService
      .registerMortality(auth, _allotment.id, deaths, eliminations);

    Mortality data = Mortality.fromDTO(response);

    await dbHelper.registerMortality(response);
    _allotment.mortalityHistory.add(data);
    _allotment.currentDeathPercentage = response.newDeathPercentage;
    notifyListeners();
  }

  Future<void> updateWaterHistory(Auth auth, String aviaryId, int multiplier, int measure) async {
    WaterDto response = await _serverService
      .registerWaterHistory(auth, multiplier, _allotment.id, measure);

    Water data = Water.fromDTO(response);

    await dbHelper.registerWaterHistory(response, aviaryId);
    _allotment.waterHistory.add(data);
    _allotment.currentTotalWaterConsume = response.newTotalConsumed;
    notifyListeners(); 
  }
}