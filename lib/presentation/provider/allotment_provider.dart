import 'dart:convert';
import 'dart:math';

import 'package:demo_project/data/database_helper.dart';
import 'package:demo_project/data/secure_storage_service.dart';
import 'package:demo_project/data/server_service.dart';
import 'package:demo_project/infra/dto/feed_dto.dart';
import 'package:demo_project/infra/dto/mortality_dto.dart';
import 'package:demo_project/infra/dto/water_dto.dart';
import 'package:demo_project/domain/entity/allotment.dart';
import 'package:demo_project/infra/dto/auth_dto.dart';
import 'package:demo_project/domain/entity/feed.dart';
import 'package:demo_project/domain/entity/mortality.dart';
import 'package:demo_project/domain/entity/water.dart';
import 'package:demo_project/domain/entity/weight.dart';
import 'package:demo_project/domain/entity/weight_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

class AllotmentProvider with ChangeNotifier {
  final DatabaseHelper dbHelper = DatabaseHelper();


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
    currentTotalFeedReceived: 0,
    waterHistory: [], 
    mortalityHistory: [], 
    weightHistory: [],
    feedHistory: []
  );

  AllotmentProvider();

  Allotment get getAllotment => _allotment;

  Future<void> loadContext(String allotmentId) async {
    bool status = await InternetConnection().hasInternetAccess;
    
    if (!status) {
      print("SERVER");
      final allotmentData = await _serverService.getAllotmentDetails(auth, allotmentId);
      _allotment = allotmentData;
      await dbHelper.updateAllotmentData(allotmentData);
    } else {
      if (await dbHelper.hasDataToSync()) {
        Allotment? localData = await _secureStorageService.getAllotment(allotmentId);
        
        print("LOCAL SECURE STORAGE");
        _allotment = localData;
            } else {
        print("LOCAL SQLITE");
        final allotmentData = await dbHelper.getAllotmentContext(allotmentId);
        _allotment = allotmentData;
        _secureStorageService.setItem(allotmentId, jsonEncode(Allotment.toJson(_allotment)));
      } 
    }

    notifyListeners();
  }

  Future<void> registerAllotment(aviaryId, int totalAmount) async {
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
      currentTotalFeedReceived: 0, 
      waterHistory: [], 
      mortalityHistory: [], 
      weightHistory: [],
      feedHistory: []
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

  List<Feed> getFeedHistory() {
    return _allotment.feedHistory;
  }

  Future<void> updateMortality(int deaths, int eliminations) async {
    bool status = await InternetConnection().hasInternetAccess;

    if (!status) {
      MortalityDto response = await _serverService
        .registerMortality(_allotment.id, deaths, eliminations);

      Mortality data = Mortality.fromDTO(response);

      await dbHelper.registerMortality(response);
      _allotment.mortalityHistory.add(data);
      _allotment.currentDeathPercentage = response.newDeathPercentage;
    } else {
      Mortality data = Mortality(
        id: Random().nextInt(100).toString(), 
        allotmentId: _allotment.id, 
        age: _allotment.currentAge, 
        deaths: deaths, 
        eliminations: eliminations, 
        createdAt: DateTime.now().toString());

      await dbHelper.registerOfflineOperation(
        jsonEncode({
          "allotmentId": _allotment.id,
          "deaths": deaths,
          "eliminations": eliminations
        }), "MORTALITY"
      );

      _allotment.mortalityHistory.add(data);

      int totalDeaths = _allotment.mortalityHistory
        .fold(0, (sum, mortality) => sum + mortality.deaths);


      int totalEliminations = _allotment.mortalityHistory
        .fold(0, (sum, mortality) => sum + mortality.eliminations);

      double newDeathPercentage = ((totalDeaths + totalEliminations) * 100.0) / _allotment.totalAmount;
      _allotment.currentDeathPercentage = newDeathPercentage;

      _secureStorageService.setMortality(data, newDeathPercentage);
    }
 
    notifyListeners();
  }

  Future<void> updateWaterHistory(String aviaryId, int multiplier, int measure) async {
    bool status = await InternetConnection().hasInternetAccess;

    if (status) {
      WaterDto response = await _serverService
        .registerWaterHistory(multiplier, _allotment.id, measure);

      Water data = Water.fromDTO(response);

      await dbHelper.registerWaterHistory(response, aviaryId);
      _allotment.waterHistory.add(data);
      _allotment.currentTotalWaterConsume = response.newTotalConsumed;
    } else {
      int consumedLiters = (measure - _allotment.waterHistory[-1].currentMeasure) * multiplier;

      Water data = Water(
        id: Random().nextInt(100).toString(),
        allotmentId: _allotment.id,
        currentMeasure: measure,
        previousMeasure: _allotment.waterHistory[-1].currentMeasure,
        age: _allotment.currentAge,
        createdAt: DateTime.now().toString(),
        consumedLiters: consumedLiters
      );

      await dbHelper.registerOfflineOperation(
        jsonEncode({
          "allotmentId": _allotment.id,
          "currentMeasure": measure,
          "multiplier": multiplier,
        }), "WATER"
      );

      _allotment.waterHistory.add(data);
      _allotment.currentTotalWaterConsume = _allotment.currentTotalWaterConsume + consumedLiters;
    }

    notifyListeners(); 
  }

  Future<void> updateWeight(int totalUnits, double tare, List<WeightBox> weights) async {
    bool status = await InternetConnection().hasInternetAccess;

    if (status) {
      Weight response = await _serverService
      .registerWeight(_allotment.id, totalUnits, tare, weights);

      await dbHelper.registerWeight(response);
      _allotment.weightHistory.add(response);
      _allotment.currentWeight = response.weight;
    } else {
      Weight data = Weight(
        id: Random().nextInt(100).toString(),
        allotmentId: _allotment.id,
        age: _allotment.currentAge,
        weight: 0.0,
        totalUnits: totalUnits,
        tare: tare,
        createdAt: DateTime.now().toString(),
        boxesWeights: []
      );

      List<WeightBox> boxWeights = weights.map((w) => WeightBox(
        id: Random().nextInt(100).toString(),
        weight: w.weight,
        weightId: data.id,
        number: w.number,
        units: w.units
      )).toList();

      double totalWeight = boxWeights.fold(0, (sum, weight) => sum + (weight.weight - tare));
      double averageWeight = totalWeight / totalUnits;

      data.weight = averageWeight;
      data.boxesWeights = boxWeights;

      await dbHelper.registerOfflineOperation(
        jsonEncode({
          "allotmentId": _allotment.id,
          "tare": tare,
          "totalUnits": totalUnits,
          "weights": weights.map((wb) => {
            "weight": wb.weight,
            "units": wb.units,
            "number": wb.number
          }).toList()
        }), "WEIGHT"
      );

      _allotment.weightHistory.add(data);
      _allotment.currentWeight = data.weight;
    }

    notifyListeners();
  }

  Future<void> updateFeed( 
    String allotmentId,
    String accessKey,
    String nfeNumber,
    String emmitedAt,
    double weight, 
    String type
  ) async {
    FeedDto response = await _serverService
      .registerFeed(allotmentId, accessKey, nfeNumber, emmitedAt, weight, type);

    Feed data = Feed.fromDTO(response);

    await dbHelper.registerFeed(response);
    _allotment.feedHistory.add(data);
    _allotment.currentTotalFeedReceived = response.currentTotalFeedReceived;

    notifyListeners();
  }
}