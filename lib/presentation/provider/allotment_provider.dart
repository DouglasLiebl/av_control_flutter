import 'package:demo_project/domain/service/allotment_service.dart';
import 'package:demo_project/infra/dto/feed_dto.dart';
import 'package:demo_project/infra/dto/mortality_dto.dart';
import 'package:demo_project/infra/dto/water_dto.dart';
import 'package:demo_project/domain/entity/allotment.dart';
import 'package:demo_project/domain/entity/feed.dart';
import 'package:demo_project/domain/entity/mortality.dart';
import 'package:demo_project/domain/entity/water.dart';
import 'package:demo_project/domain/entity/weight.dart';
import 'package:demo_project/domain/entity/weight_box.dart';
import 'package:demo_project/presentation/provider/base_provider.dart';

class AllotmentProvider extends BaseProvider {
  final AllotmentService allotmentService;

  AllotmentProvider({required this.allotmentService});

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

  Allotment get getAllotment => _allotment;

  Future<void> loadContext(String allotmentId) async {
    try {
      Allotment response = await allotmentService.getAllotmentData(allotmentId);
      _allotment = response;
    } catch (e, stackTrace) {
      handleError(e, stackTrace);
    }

    notifyListeners();
  }

  Future<void> registerAllotment(aviaryId, int totalAmount) async {
    try {
      Allotment response = await allotmentService.registerNewAllotment(aviaryId, totalAmount);
      _allotment = response;
    } catch (e, stackTrace) {
      handleError(e, stackTrace);
    }

    notifyListeners();
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
    try {
      MortalityDto response = await allotmentService.registerMortality(_allotment.id, deaths, eliminations);

      Mortality data = Mortality.fromDTO(response);

      _allotment.mortalityHistory.add(data);
      _allotment.currentDeathPercentage = response.newDeathPercentage;
    } catch (e, stackTrace) {
      await handleError(e, stackTrace);
    }
 
    notifyListeners();
  }

  Future<void> updateWaterHistory(String aviaryId, int multiplier, int currentMeasure) async {
    try {
      WaterDto response = await allotmentService.registerWaterConsume(aviaryId, _allotment.id, multiplier, currentMeasure);

      Water data = Water.fromDTO(response);

      _allotment.waterHistory.add(data);
      _allotment.currentTotalWaterConsume = response.newTotalConsumed;
    } catch (e, stackTrace) {
      await handleError(e, stackTrace);
    }

    notifyListeners(); 
  }

  Future<void> updateWeight(int totalUnits, double tare, List<WeightBox> weights) async {
    try {
      Weight response = await allotmentService.registerWeight(_allotment.id, totalUnits, tare, weights);

      _allotment.weightHistory.add(response);
      _allotment.currentWeight = response.weight;
    } catch (e, stackTrace) {
      handleError(e, stackTrace);
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
    try {
      FeedDto response = await allotmentService
        .registerFeed(allotmentId, accessKey, nfeNumber, emmitedAt, weight, type);

      Feed data = Feed.fromDTO(response);
      
      _allotment.feedHistory.add(data);
      _allotment.currentTotalFeedReceived = response.currentTotalFeedReceived;
    } catch (e, stackTrace) {
      handleError(e, stackTrace);
    }

    notifyListeners();
  }
}