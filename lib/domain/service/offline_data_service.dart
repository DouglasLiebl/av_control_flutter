import 'dart:convert';
import 'dart:math';

import 'package:demo_project/domain/entity/allotment.dart';
import 'package:demo_project/domain/entity/feed.dart';
import 'package:demo_project/domain/entity/mortality.dart';
import 'package:demo_project/domain/entity/sync_data.dart';
import 'package:demo_project/domain/entity/water.dart';
import 'package:demo_project/domain/entity/weight.dart';
import 'package:demo_project/domain/entity/weight_box.dart';
import 'package:demo_project/infra/dto/mortality_dto.dart';
import 'package:demo_project/infra/dto/water_dto.dart';
import 'package:demo_project/infra/third_party/local_storage/secure_storage.dart';
import 'package:demo_project/infra/third_party/local_storage/sqlite_storage.dart';
import 'package:sqflite/sqflite.dart';

class OfflineDataService {
  final SecureStorage secureStorage;
  final SqliteStorage _sqliteStorage = SqliteStorage.instance;

  OfflineDataService({required this.secureStorage});

  Future<Allotment> loadLocalData(String allotmentId) async {
    final db = await _sqliteStorage.database;

    final List<Map<String, dynamic>> results = await db.rawQuery(
      '''
      SELECT * FROM tb_allotments 
      WHERE id = ?
      ''', 
      [allotmentId]
    );

    if (results.isEmpty) {
      throw Exception("No allotment found");
    }

    final allotmentData = results.first;

    final List<Map<String, dynamic>> mortalityHistory = await db.rawQuery(
      '''
      SELECT * FROM tb_mortality_history
      WHERE allotmentId = ?
      ''',
      [allotmentData['id']]
    );

    final List<Map<String, dynamic>> waterHistory = await db.rawQuery(
      '''
      SELECT * FROM tb_water_history
      WHERE allotmentId = ?
      ''',
      [allotmentData['id']]
    );
    
    final List<Map<String, dynamic>> weights = await db.rawQuery(
      '''
      SELECT * FROM tb_weight_history
      WHERE allotmentId = ?
      ''',
      [allotmentData['id']]
    );

    List<Weight> weightHistory = await Future.wait(weights.map((weight) async {
      List<Map<String, dynamic>> boxes = await db.rawQuery(
        '''
        SELECT * FROM tb_box_weight_history
        WHERE weightId = ?
        ''',
        [weight['id']]
      );

      Weight response = Weight.fromSQLite(weight);
      response.boxesWeights = boxes.map((weighBox) => WeightBox.fromJson(weighBox)).toList();
      
      return response;
    }).toList());

    final List<Map<String, dynamic>> feedHistory = await db.rawQuery(
      '''
      SELECT * FROM tb_feed_history
      WHERE allotmentId = ?
      ''',
      [allotmentData['id']]
    );

    final allotment = Allotment.fromSQLite(allotmentData);
    allotment.mortalityHistory = mortalityHistory.map((m) => Mortality.fromJson(m)).toList();
    allotment.waterHistory = waterHistory.map((w) => Water.fromJson(w)).toList();
    allotment.weightHistory = weightHistory;
    allotment.feedHistory = feedHistory.map((f) => Feed.fromJson(f)).toList();

    await secureStorage.setItem(allotment.id, jsonEncode(Allotment.toJson(allotment)));

    return allotment;
  }

  Future<MortalityDto> offMortalityRegister(String allotmentId, int deaths, int eliminations) async {
    final db = await _sqliteStorage.database;

    Allotment allotment = await loadLocalData(allotmentId);

    int totalDeaths = allotment.mortalityHistory
      .fold(0, (sum, mortality) => sum + mortality.deaths);
    totalDeaths += deaths;

    int totalEliminations = allotment.mortalityHistory
      .fold(0, (sum, mortality) => sum + mortality.eliminations);
    totalEliminations += eliminations;

    double newDeathPercentage = ((totalDeaths + totalEliminations) * 100.0) / allotment.totalAmount;
    newDeathPercentage = double.parse(newDeathPercentage.toStringAsFixed(2));

    MortalityDto data = MortalityDto(
      id: Random().nextInt(100).toString(), 
      allotmentId: allotmentId, 
      age: allotment.currentAge, 
      deaths: deaths, 
      eliminations: eliminations, 
      createdAt: DateTime.now().toString(),
      newDeathPercentage: newDeathPercentage
    );


    secureStorage.setMortality(Mortality.fromDTO(data), newDeathPercentage);

    await db.transaction((tx) async {
      tx.insert(
        "tb_offline_sync", 
        {
          "id": Random().nextInt(100),
          "operationType": "MORTALITY",
          "data": jsonEncode({
            "allotmentId": allotmentId,
            "deaths": deaths,
            "eliminations": eliminations
          })
        }  
      );
    });

    return data;

  }

  Future<WaterDto> offWaterConsumeRegister(String allotmentId, int multiplier, int currentMeasure) async {
    final db = await _sqliteStorage.database;

    Allotment allotment = await loadLocalData(allotmentId);

    int consumedLiters = 0;
    int newTotalConsume = 0;
    int lastMeasure = 0;

    if (allotment.waterHistory.isNotEmpty) {
      consumedLiters = (currentMeasure - allotment.waterHistory.last.currentMeasure) * multiplier;
      newTotalConsume = allotment.currentTotalWaterConsume + consumedLiters;
      lastMeasure = allotment.waterHistory.last.currentMeasure;
    }

    WaterDto data = WaterDto(
      id: Random().nextInt(100).toString(),
      allotmentId: allotment.id,
      aviaryId: "",
      currentMeasure: currentMeasure,
      previousMeasure: lastMeasure,
      age: allotment.currentAge,
      createdAt: DateTime.now().toString(),
      consumedLiters: consumedLiters,
      newTotalConsumed: newTotalConsume,
      multiplier: multiplier
    );

    await secureStorage.setWater(Water.fromDTO(data), newTotalConsume);

    await db.transaction((tx) async {
      tx.insert(
        "tb_offline_sync", 
        {
          "id": Random().nextInt(100),
          "operationType": "WATER_CONSUME",
          "data": jsonEncode({
            "allotmentId": allotmentId,
            "multiplier": multiplier,
            "currentMeasure": currentMeasure
          })
        });
    });

    return data;
  }

  Future<Weight> offWeightRegister(String allotmentId, int totalUnits, double tare, List<WeightBox> weights) async {
    final db = await _sqliteStorage.database;

    Allotment allotment = await loadLocalData(allotmentId);
    
    Weight data = Weight(
      id: Random().nextInt(100).toString(),
      allotmentId: allotmentId,
      age: allotment.currentAge,
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

    averageWeight = double.parse(averageWeight.toStringAsFixed(3));

    data.weight = averageWeight;
    data.boxesWeights = boxWeights;

    await secureStorage.setWeight(data, data.weight);
    
    await db.transaction((tx) async {
      await tx.insert(
        "tb_offline_sync",
        {
          "id": Random().nextInt(100),
          "operationType": "WEIGHT",
          "data": jsonEncode({
            "allotmentId": allotmentId,
            "tare": tare,
            "totalUnits": totalUnits,
            "weights": weights.map((wb) => {
              "weight": wb.weight,
              "units": wb.units,
              "number": wb.number
            }).toList()
          })
        }
      );
    });

    return data;
  }

  Future<bool> hasDataToSync() async {
    final db = await _sqliteStorage.database;
    final count = Sqflite.firstIntValue(await db.rawQuery("SELECT COUNT(*) FROM tb_offline_sync"));
    return count != null && count > 0;
  }

  Future<List<SyncData>> getDataToSync() async {
    final db = await _sqliteStorage.database;

    List<Map<String, dynamic>> data = await db.rawQuery(
      '''
      SELECT * FROM tb_offline_sync
      '''
    );

    return data.map((d) => SyncData.fromJson(d)).toList();
  }

  Future<void> cleanDataToSync() async {
    final db = await _sqliteStorage.database;

    await db.transaction((tx) async {
      await tx.rawDelete("DELETE FROM tb_offline_sync");
    });
  }
}