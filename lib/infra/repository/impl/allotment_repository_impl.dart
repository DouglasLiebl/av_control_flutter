import 'dart:convert';

import 'package:demo_project/domain/entity/allotment.dart';
import 'package:demo_project/domain/entity/weight.dart';
import 'package:demo_project/domain/entity/weight_box.dart';
import 'package:demo_project/domain/exception/handler.dart';
import 'package:demo_project/infra/constants/api_endpoints.dart';
import 'package:demo_project/infra/dto/feed_dto.dart';
import 'package:demo_project/infra/dto/mortality_dto.dart';
import 'package:demo_project/infra/dto/water_dto.dart';
import 'package:demo_project/infra/repository/allotment_repository.dart';
import 'package:dio/dio.dart';

class AllotmentRepositoryImpl implements AllotmentRepository {
  final Dio apiPrivate;

  AllotmentRepositoryImpl({required this.apiPrivate});

  @override
  Future<Allotment> getAllotmentDetails(String allotmentId) async {
    try {
      final response = await apiPrivate.get(
        "${ApiEndpoints.allotmentBaseUrl}/$allotmentId"
      );

      Handler.apiResponse(response);
      return Allotment.fromJson(response.data);
    } catch (e, stackTrace) {
      Handler.apiException(e, stackTrace);
      rethrow;
    }
  }

  @override
  Future<FeedDto> registerFeed(String allotmentId, String accessKey, String nfeNumber, String emittedAt, double weight, String type) async {
    try {
      final response = await apiPrivate.post(
        ApiEndpoints.registerFeed,
        data: jsonEncode({
          "allotmentId": allotmentId,
          "accessKey": accessKey,
          "nfeNumber": nfeNumber,
          "emittedAt": emittedAt,
          "weight": weight,
          "type": type.replaceAll(" ", "_")
        })
      );

      Handler.apiResponse(response);
      return FeedDto.fromJson(response.data);
    } catch (e, stackTrace) {
      Handler.apiException(e, stackTrace);
      rethrow;
    }
  }

  @override
  Future<MortalityDto> registerMortality(String allotmentId, int deaths, int eliminations) async {
    try {
      final response = await apiPrivate.post(
        ApiEndpoints.registerMortality,
        data: jsonEncode({
          "allotmentId": allotmentId,
          "deaths": deaths,
          "eliminations": eliminations
        })
      );

      Handler.apiResponse(response);
      return MortalityDto.fromJson(response.data);
    } catch (e, stackTrace) {
      Handler.apiException(e, stackTrace);
      rethrow;
    }
  }

  @override
  Future<WaterDto> registerWaterConsume(String allotmentId, int multiplier, int currentMeasure) async {
    try {
      final response = await apiPrivate.post(
        ApiEndpoints.registerWaterConsume,
        data: jsonEncode({
          "allotmentId": allotmentId,
          "currentMeasure": currentMeasure,
          "multiplier": multiplier
        })
      );

      Handler.apiResponse(response);  
      return WaterDto.fromJson(response.data);
    } catch (e, stackTrace) {
      Handler.apiException(e, stackTrace);
      rethrow;
    }
  }

  @override
  Future<Weight> registerWeight(String allotmentId, int totalUnits, double tare, List<WeightBox> weights) async {
    try {
      final response = await apiPrivate.post(
        ApiEndpoints.registerWeight,
        data: jsonEncode({
          "allotmentId": allotmentId,
          "totalUnits": totalUnits,
          "tare": tare,
          "weights": weights.map((wb) => WeightBox.toJson(wb)).toList()
        })
      );

      Handler.apiResponse(response);
      return Weight.fromJson(response.data);
    } catch (e, stackTrace) {
      Handler.apiException(e, stackTrace);
      rethrow;
    }
  }

  @override
  Future<Allotment> startAllotment(String aviaryId, int totalAmount) async {
    try {
      final response = await apiPrivate.post(
        ApiEndpoints.allotmentBaseUrl,
        data: jsonEncode({
          "aviaryId": aviaryId,
          "totalAmount": totalAmount
        })
      );

      Handler.apiResponse(response);
      return Allotment.fromJson(response.data);
    } catch (e, stackTrace) {
      Handler.apiException(e, stackTrace);
      rethrow;
    }
  }
}