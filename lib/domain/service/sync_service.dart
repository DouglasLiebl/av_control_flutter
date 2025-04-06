import 'package:demo_project/domain/entity/sync_data.dart';
import 'package:demo_project/domain/entity/weight.dart';
import 'package:demo_project/domain/service/allotment_service.dart';
import 'package:demo_project/domain/service/offline_data_service.dart';
import 'package:demo_project/infra/dto/mortality_dto.dart';
import 'package:demo_project/infra/dto/water_dto.dart';
import 'package:demo_project/infra/repository/allotment_repository.dart';
import 'package:demo_project/infra/third_party/local_storage/secure_storage.dart';
import 'package:demo_project/utils/network_status.dart';

class SyncService {
  AllotmentService allotmentService;
  AllotmentRepository allotmentRepository;
  OfflineDataService offlineDataService;
  SecureStorage secureStorage;
  final NetworkStatus _networkStatus = NetworkStatus.instance;

  SyncService({
    required this.allotmentService, 
    required this.allotmentRepository, 
    required this.offlineDataService,
    required this.secureStorage
  });

  Future<void> synchronize() async {
    if (!(await _networkStatus.hasConnection)) {
      return;
    }

    List<SyncData> dataToSync = await offlineDataService.getDataToSync();

    for (SyncData data in dataToSync) {
      switch (data.type) {
        case "MORTALITY":
          await _syncMortality(data);
          print("SYNC MORTALITY");
        case "WATER_CONSUME":
          await _syncWaterConsume(data);
          print("SYNC WATER");
        case "WEIGHT":
          await _syncWeight(data);
          print("SYNC WEIGHT");
      }
    }

    offlineDataService.cleanDataToSync();
    secureStorage.cleanStorage();
  }

  Future<void> _syncMortality(SyncData syncData) async {
    MortalityDto response = await allotmentRepository.syncMortality(syncData.data);

    await allotmentService.registerMortalityLocally(response);
  }

  Future<void> _syncWaterConsume(SyncData syncData) async {
    WaterDto response = await allotmentRepository.syncWaterConsume(syncData.data);

    await allotmentService.registerWaterConsumeLocally(response);
  }

  Future<void> _syncWeight(SyncData syncData) async {
    Weight response = await allotmentRepository.syncWeight(syncData.data);

    await allotmentService.registerWeightLocally(response);
  }


}