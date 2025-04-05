import 'dart:convert';
import 'dart:math';

import 'package:demo_project/domain/entity/allotment.dart';
import 'package:demo_project/domain/entity/mortality.dart';
import 'package:demo_project/infra/dto/mortality_dto.dart';
import 'package:demo_project/infra/repository/allotment_repository.dart';
import 'package:demo_project/infra/third_party/local_storage/secure_storage.dart';
import 'package:demo_project/infra/third_party/local_storage/sqlite_storage.dart';

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

}