import 'package:demo_project/infra/dto/mortality_dto.dart';
import 'package:demo_project/infra/repository/allotment_repository.dart';
import 'package:demo_project/infra/third_party/local_storage/secure_storage.dart';
import 'package:demo_project/infra/third_party/local_storage/sqlite_storage.dart';
import 'package:demo_project/utils/network_status.dart';

class AllotmentService {
  final AllotmentRepository allotmentRepository;
  final SecureStorage secureStorage;
  final SqliteStorage _sqliteStorage = SqliteStorage.instance;
  final NetworkStatus _networkStatus = NetworkStatus.instance;
  

  AllotmentService({required this.allotmentRepository, required this.secureStorage});

  Future<MortalityDto> registerMortality(String allotmentId, int deaths, int eliminations) async {
    if (await _networkStatus.hasConnection) {
      MortalityDto response = await allotmentRepository.registerMortality(allotmentId, deaths, eliminations);

      await _registerMortalityLocally(response);
      return response;  
    }


    
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
}