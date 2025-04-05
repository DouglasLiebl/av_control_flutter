import 'package:demo_project/domain/entity/allotment.dart';
import 'package:demo_project/domain/entity/weight.dart';
import 'package:demo_project/domain/entity/weight_box.dart';
import 'package:demo_project/infra/dto/feed_dto.dart';
import 'package:demo_project/infra/dto/mortality_dto.dart';
import 'package:demo_project/infra/dto/water_dto.dart';

abstract class AllotmentRepository {

  Future<Allotment> startAllotment(String aviaryId, int totalAmount);

  Future<Allotment> getAllotmentDetails(String allotmentId); 

  Future<MortalityDto> registerMortality(String allotmentId, int deaths, int eliminations);

  Future<MortalityDto> syncMortality(String data);

  Future<WaterDto> registerWaterConsume(String allotmentId, int multiplier, int currentMeasure);

  Future<WaterDto> syncWaterConsume(String data);

  Future<Weight> registerWeight(String allotmentId, int totalUnits, double tare, List<WeightBox> weights);

  Future<Weight> syncWeight(String data);

  Future<FeedDto> registerFeed(String allotmentId, String accessKey, String nfeNumber, String emittedAt, double weight, String type);

}