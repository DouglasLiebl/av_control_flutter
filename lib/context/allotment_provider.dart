import 'dart:convert';
import 'dart:math';

import 'package:demo_project/data/database_helper.dart';
import 'package:demo_project/data/server_service.dart';
import 'package:demo_project/dto/feed_dto.dart';
import 'package:demo_project/dto/mortality_dto.dart';
import 'package:demo_project/dto/water_dto.dart';
import 'package:demo_project/models/allotment.dart';
import 'package:demo_project/models/auth.dart';
import 'package:demo_project/models/feed.dart';
import 'package:demo_project/models/mortality.dart';
import 'package:demo_project/models/water.dart';
import 'package:demo_project/models/weight.dart';
import 'package:demo_project/models/weight_box.dart';
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
    currentTotalFeedReceived: 0,
    waterHistory: [], 
    mortalityHistory: [], 
    weightHistory: [],
    feedHistory: []
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

  Future<void> updateMortality(Auth auth, int deaths, int eliminations) async {
    bool status = await InternetConnection().hasInternetAccess;

    if (status) {
      MortalityDto response = await _serverService
        .registerMortality(auth, _allotment.id, deaths, eliminations);

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

      await dbHelper.registerOfflineOperation(jsonEncode({
        data
      }), "MORTALITY");

      _allotment.mortalityHistory.add(data);

      int totalDeaths = _allotment.mortalityHistory
        .fold(0, (sum, mortality) => sum + mortality.deaths);


      int totalEliminations = _allotment.mortalityHistory
        .fold(0, (sum, mortality) => sum + mortality.eliminations);

      double newDeathPercentage = ((totalDeaths + totalEliminations) * 100.0) / _allotment.totalAmount;
      _allotment.currentDeathPercentage = newDeathPercentage;
    }
 
    
    notifyListeners();
  }

  Future<void> updateWaterHistory(Auth auth, String aviaryId, int multiplier, int measure) async {
    bool status = await InternetConnection().hasInternetAccess;

    if (status) {
      WaterDto response = await _serverService
        .registerWaterHistory(auth, multiplier, _allotment.id, measure);

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

      await dbHelper.registerOfflineOperation(jsonEncode({
        data
      }), "WATER");

      _allotment.waterHistory.add(data);
      _allotment.currentTotalWaterConsume = _allotment.currentTotalWaterConsume + consumedLiters;
    }

    notifyListeners(); 
  }

  Future<void> updateWeight(Auth auth, int totalUnits, double tare, List<WeightBox> weights) async {
    bool status = await InternetConnection().hasInternetAccess;

    if (status) {
      Weight response = await _serverService
      .registerWeight(auth, _allotment.id, totalUnits, tare, weights);

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

      await dbHelper.registerOfflineOperation(jsonEncode({
        data
      }), "WEIGHT");

      _allotment.weightHistory.add(data);
      _allotment.currentWeight = data.weight;
    }

    notifyListeners();
  }

  Future<void> updateFeed(
    Auth auth, 
    String allotmentId,
    String accessKey,
    String nfeNumber,
    String emmitedAt,
    double weight, 
    String type
  ) async {
    FeedDto response = await _serverService
      .registerFeed(auth, allotmentId, accessKey, nfeNumber, emmitedAt, weight, type);

    Feed data = Feed.fromDTO(response);

    await dbHelper.registerFeed(response);
    _allotment.feedHistory.add(data);
    _allotment.currentTotalFeedReceived = response.currentTotalFeedReceived;

    notifyListeners();
  }
}