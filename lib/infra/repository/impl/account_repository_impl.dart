import 'dart:convert';

import 'package:demo_project/domain/exception/handler.dart';
import 'package:demo_project/infra/constants/api_endpoints.dart';
import 'package:demo_project/infra/dto/aviary_dto.dart';
import 'package:demo_project/infra/repository/account_repository.dart';
import 'package:dio/dio.dart';

class AccountRepositoryImpl implements AccountRepository {
  final Dio apiPrivate;

  AccountRepositoryImpl({required this.apiPrivate});

  @override
  Future<AviaryDto> registerNewAviary(String accountId, String name, String alias) async {
    try {
      final response = await apiPrivate.post(
        ApiEndpoints.registerNewAviary,
        data: jsonEncode({
          "accountId": accountId,
          "name": name,
          "alias": alias
        })
      );

      Handler.apiResponse(response);
      return AviaryDto.fromJson(response.data);
    } catch (e, stackTrace) {
      Handler.apiException(e, stackTrace);
      rethrow;
    }
  }
}