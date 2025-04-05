import 'dart:convert';
import 'dart:math';

import 'package:demo_project/domain/entity/allotment.dart';
import 'package:demo_project/domain/entity/mortality.dart';
import 'package:demo_project/domain/entity/water.dart';
import 'package:demo_project/domain/entity/weight.dart';
import 'package:demo_project/domain/entity/weight_box.dart';
import 'package:demo_project/infra/dto/mortality_dto.dart';
import 'package:demo_project/infra/dto/water_dto.dart';
import 'package:demo_project/infra/repository/allotment_repository.dart';
import 'package:demo_project/infra/third_party/local_storage/secure_storage.dart';
import 'package:demo_project/infra/third_party/local_storage/sqlite_storage.dart';
import 'package:sqflite/sqflite.dart';

class OfflineDataService {
  final AllotmentRepository allotmentRepository;
  final SecureStorage secureStorage;
  final SqliteStorage _sqliteStorage = SqliteStorage.instance;

  OfflineDataService({required this.allotmentRepository, required this.secureStorage});

  Future<MortalityDto> offMortalityRegister(String allotmentId, int deaths, int eliminations) async {
    final db = await _sqliteStorage.database;

    Allotment allotment = await allotmentRepository.getAllotmentDetails(allotmentId);

    int totalDeaths = allotment.mortalityHistory
      .fold(0, (sum, mortality) => sum + mortality.deaths);


    int totalEliminations = allotment.mortalityHistory
      .fold(0, (sum, mortality) => sum + mortality.eliminations);

    double newDeathPercentage = ((totalDeaths + totalEliminations) * 100.0) / allotment.totalAmount;

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

    Allotment allotment = await allotmentRepository.getAllotmentDetails(allotmentId);

    int consumedLiters = (currentMeasure - allotment.waterHistory[-1].currentMeasure) * multiplier;
    int newTotalConsume = allotment.currentTotalWaterConsume + consumedLiters;

    WaterDto data = WaterDto(
      id: Random().nextInt(100).toString(),
      allotmentId: allotment.id,
      currentMeasure: currentMeasure,
      previousMeasure: allotment.waterHistory[-1].currentMeasure,
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

    Allotment allotment = await allotmentRepository.getAllotmentDetails(allotmentId);
    
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
}