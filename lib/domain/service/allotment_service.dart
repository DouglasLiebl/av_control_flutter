import 'dart:convert';

import 'package:demo_project/domain/entity/allotment.dart';
import 'package:demo_project/domain/entity/feed.dart';
import 'package:demo_project/domain/entity/mortality.dart';
import 'package:demo_project/domain/entity/water.dart';
import 'package:demo_project/domain/entity/weight.dart';
import 'package:demo_project/domain/entity/weight_box.dart';
import 'package:demo_project/domain/service/offline_data_service.dart';
import 'package:demo_project/infra/dto/feed_dto.dart';
import 'package:demo_project/infra/dto/mortality_dto.dart';
import 'package:demo_project/infra/dto/water_dto.dart';
import 'package:demo_project/infra/repository/allotment_repository.dart';
import 'package:demo_project/infra/third_party/local_storage/secure_storage.dart';
import 'package:demo_project/infra/third_party/local_storage/sqlite_storage.dart';
import 'package:demo_project/utils/network_status.dart';
import 'package:sqflite/sqflite.dart';

class AllotmentService {
  final AllotmentRepository allotmentRepository;
  final OfflineDataService offlineDataService;
  final SecureStorage secureStorage;
  final SqliteStorage _sqliteStorage = SqliteStorage.instance;
  final NetworkStatus _networkStatus = NetworkStatus.instance;
  

  AllotmentService({required this.allotmentRepository, required this.offlineDataService, required this.secureStorage});

  Future<Allotment> getAllotmentData(String allotmentId) async {
    if (await _networkStatus.hasConnection) {
      Allotment response = await allotmentRepository.getAllotmentDetails(allotmentId);

      await _updateAllotmentLocally(response);
      return response;
    }

    if (await offlineDataService.hasDataToSync()) {
      Allotment? response = await secureStorage.getAllotment(allotmentId);
      if (response != null) return response;
    }

    return await _loadLocalData(allotmentId);
  }

  Future<Allotment> registerNewAllotment(String aviaryId, int totalAmount) async {
    if (await _networkStatus.hasConnection) {
      Allotment response = await allotmentRepository.startAllotment(aviaryId, totalAmount);

      await _registerNewAllotmentLocally(response);
      return response;
    }

    throw Exception("");
  }

  Future<MortalityDto> registerMortality(String allotmentId, int deaths, int eliminations) async {
    if (await _networkStatus.hasConnection) {
      MortalityDto response = await allotmentRepository.registerMortality(allotmentId, deaths, eliminations);

      await _registerMortalityLocally(response);
      return response;  
    }

    return await offlineDataService.offMortalityRegister(allotmentId, deaths, eliminations);
  }

  Future<WaterDto> registerWaterConsume(String aviaryId, String allotmentId, int multiplier, int currentMeasure) async {
    if (await _networkStatus.hasConnection) {
      WaterDto response = await allotmentRepository.registerWaterConsume(allotmentId, multiplier, currentMeasure);

      await _registerWaterConsumeLocally(response, aviaryId);
      return response;
    }

    return await offlineDataService.offWaterConsumeRegister(allotmentId, multiplier, currentMeasure);
  }

  Future<Weight> registerWeight(String allotmentId, int totalUnits, double tare, List<WeightBox> weights) async {
    if (await _networkStatus.hasConnection) {
      Weight response = await allotmentRepository.registerWeight(allotmentId, totalUnits, tare, weights);

      await _registerWeightLocally(response);
      return response;
    } 

    return await offlineDataService.offWeightRegister(allotmentId, totalUnits, tare, weights);
  }

  Future<FeedDto> registerFeed(String allotmentId, String accessKey, String nfeNumber, String emittedAt, double weight, String type) async {
    if (await _networkStatus.hasConnection) {
      FeedDto response = await allotmentRepository.registerFeed(allotmentId, accessKey, nfeNumber, emittedAt, weight, type);

      await _registerFeedLocally(response);
      return response;
    }

    throw Exception("");
  }

  Future<void> _registerNewAllotmentLocally(Allotment source) async {
    final db = await _sqliteStorage.database
    ;
    await db.transaction((tx) async {
      await tx.insert(
        "tb_allotments", 
        {
          'id': source.id,
          'aviaryId': source.aviaryId,
          'isActive': source.isActive ? 1 : 0,
          'number': source.number,
          'totalAmount': source.totalAmount,
          'currentAge': source.currentAge,
          'startedAt': source.startedAt,
          'endedAt': source.endedAt,
          'currentDeathPercentage': source.currentDeathPercentage,
          'currentWeight': source.currentWeight,
          'currentTotalWaterConsume': source.currentTotalWaterConsume,
          'currentTotalFeedReceived': source.currentTotalFeedReceived
        },
      );

      await tx.update(
        "tb_aviaries", 
        {
          'activeAllotmentId': source.id
        },
        where: 'id = ?',
        whereArgs: [source.aviaryId]
      );
    });
  }

  Future<void> _updateAllotmentLocally(Allotment source) async {
    final db = await _sqliteStorage.database;

    await db.transaction((tx) async {
      await tx.insert(
        "tb_allotments", 
        {
          'id': source.id,
          'aviaryId': source.aviaryId,
          'isActive': source.isActive ? 1 : 0,
          'number': source.number,
          'totalAmount': source.totalAmount,
          'currentAge': source.currentAge,
          'startedAt': source.startedAt,
          'endedAt': source.endedAt,
          'currentDeathPercentage': source.currentDeathPercentage,
          'currentWeight': source.currentWeight,
          'currentTotalWaterConsume': source.currentTotalWaterConsume,
          'currentTotalFeedReceived': source.currentTotalFeedReceived
        },
        conflictAlgorithm: ConflictAlgorithm.replace
      );

      for (Water h in source.waterHistory) {
        await tx.insert(
          "tb_water_history",
          {
            'id': h.id,
            'allotmentId': h.allotmentId,
            'age': h.age,
            'previousMeasure': h.previousMeasure,
            'currentMeasure': h.currentMeasure,
            'consumedLiters': h.consumedLiters,
            'createdAt': h.createdAt
          },
          conflictAlgorithm: ConflictAlgorithm.replace
        );
      }

      for (Mortality h in source.mortalityHistory) {
        await tx.insert(
          "tb_mortality_history",
          {
            'id': h.id,
            'allotmentId': h.allotmentId,
            'age': h.age,
            'deaths': h.deaths,
            'eliminations': h.eliminations,
            'createdAt': h.createdAt
          },
          conflictAlgorithm: ConflictAlgorithm.replace
        );
      }

      for (Weight h in source.weightHistory) {
        await tx.insert(
          "tb_weight_history",
          {
            'id': h.id,
            'allotmentId': h.allotmentId,
            'age': h.age,
            'weight': h.weight,
            'tare': h.tare,
            'totalUnits': h.totalUnits,
            'createdAt': h.createdAt
          },
          conflictAlgorithm: ConflictAlgorithm.replace
        );

        for (WeightBox hb in h.boxesWeights) {
          await tx.insert(
            "tb_box_weight_history",
            {
              'id': hb.id,
              'weightId': hb.weightId,
              'number': hb.number,
              'weight': hb.weight,
              'units': hb.units
            },
            conflictAlgorithm: ConflictAlgorithm.replace
          );
        }

      }

      for (Feed f in source.feedHistory) {
        await tx.insert(
          "tb_feed_history",
          {
            "id": f.id,
            "allotmentId": f.allotmentId,
            "accessKey": f.accessKey,
            "nfeNumber": f.nfeNumber,
            "emittedAt": f.emittedAt,
            "weight": f.weight,
            "type": f.type,
            "createdAt": f.createdAt
          },
          conflictAlgorithm: ConflictAlgorithm.replace
        );
      }
    });
  }

  Future<Allotment> _loadLocalData(String allotmentId) async {
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
        WHERE weight_id = ?
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

  Future<void> _registerMortalityLocally(MortalityDto source) async {
    final db = await _sqliteStorage.database;

    await db.transaction((tx) async {
      await tx.insert(
        "tb_mortality_history",
        {
          'id': source.id,
          'allotmentId': source.allotmentId,
          'age': source.age,
          'deaths': source.deaths,
          'eliminations': source.eliminations,
          'createdAt': source.createdAt
        }
      );

      await tx.update(
        "tb_allotments",
        {
          "currentDeathPercentage": source.newDeathPercentage
        },
        where: "id = ?",
        whereArgs: [source.allotmentId]
      );
    });
  }

  Future<void> _registerWaterConsumeLocally(WaterDto source, String aviaryId) async {
    final db = await _sqliteStorage.database;

    await db.transaction((tx) async {
      await tx.insert(
        "tb_water_history",
        {
          "id": source.id,
          "allotmentId": source.allotmentId,
          "age": source.age,
          "previousMeasure": source.previousMeasure,
          "currentMeasure": source.currentMeasure,
          "consumedLiters": source.consumedLiters,
          "createdAt": source.createdAt
        }
      );

      await tx.update(
        "tb_aviaries", 
        {
          "currentWaterMultiplier": source.multiplier
        },
        where: "id = ?",
        whereArgs: [aviaryId]
      );

      await tx.update(
        "tb_allotments",
        {
          "currentTotalWaterConsume": source.newTotalConsumed
        },
        where: "id = ?",
        whereArgs: [source.allotmentId]
      );

    });
  }

  Future<void> _registerWeightLocally(Weight source) async {
    final db = await _sqliteStorage.database;
    
    await db.transaction((tx) async {
      tx.insert(
        "tb_weight_history", 
        {
          "id": source.id,
          "allotmentId": source.allotmentId,
          "age": source.age,
          "weight": source.weight,
          "tare": source.tare,
          "totalUnits": source.totalUnits,
          "createdAt": source.createdAt
        }
      );

      for (WeightBox w in source.boxesWeights) {
        tx.insert(
          "tb_box_weight_history",
          {
            "id": w.id,
            "weightId": w.weightId,
            "number": w.number,
            "weight": w.weight,
            "units": w.units
          }
        );
      }

      await tx.update(
        "tb_allotments",
        {
          "currentWeight": source.weight
        },
        where: "id = ?",
        whereArgs: [source.allotmentId]
      );

    });
  }

  Future<void> _registerFeedLocally(FeedDto source) async {
    final db = await _sqliteStorage.database;

    await db.transaction((tx) async {
      tx.insert(
        "tb_feed_history", 
        {
          "id": source.id,
          "allotmentId": source.allotmentId,
          "accessKey": source.accessKey,
          "nfeNumber": source.nfeNumber,
          "emittedAt": source.emittedAt,
          "weight": source.weight,
          "type": source.type,
          "createdAt": source.createdAt
        }
      );

      tx.update(
        "tb_allotments", 
        {
          "currentTotalFeedReceived": source.currentTotalFeedReceived
        },
        where: "id = ?",
        whereArgs: [source.allotmentId]
      );
    });
  }
}