import 'dart:convert';

import 'package:demo_project/domain/exception/handler.dart';
import 'package:demo_project/infra/constants/api_endpoints.dart';
import 'package:demo_project/infra/dto/account_dto.dart';
import 'package:demo_project/infra/repository/auth_repository.dart';
import 'package:dio/dio.dart';

class AuthRepositoryImpl implements AuthRepository {
  final Dio apiPublic;

  AuthRepositoryImpl({required this.apiPublic});

  @override
  Future<AccountDto> login(String email, String password) async {
    try {
      final response = await apiPublic.post(
        ApiEndpoints.login,
        data: jsonEncode({
          "email": email,
          "password": password
        })
      );

      Handler.apiResponse(response);
      return AccountDto.fromJson(response.data);
    } catch (e, stackTrace) {
      Handler.apiException(e, stackTrace);
      rethrow;
    }
  }
}