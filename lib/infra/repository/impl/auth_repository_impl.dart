import 'dart:convert';

import 'package:demo_project/domain/exception/handler.dart';
import 'package:demo_project/infra/constants/api_endpoints.dart';
import 'package:demo_project/infra/dto/account_dto.dart';
import 'package:demo_project/infra/dto/login_dto.dart';
import 'package:demo_project/infra/repository/auth_repository.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class AuthRepositoryImpl implements AuthRepository {
  final Dio apiPublic;

  AuthRepositoryImpl({required this.apiPublic});

  @override
  Future<AccountDto> login(String email, String password) async {
    try {
      DeviceInfoPlugin device = DeviceInfoPlugin();

      AndroidDeviceInfo info = await device.androidInfo;
      debugPrint(info.toString());

      final response = await apiPublic.post(
        ApiEndpoints.login,
        options: Options(headers: {'Authorization': 'Basic ${LoginDto.encodeAuth(email, password)}'}),
        data: jsonEncode({
          "fingerPrint": info.fingerprint,
          "deviceId": info.id
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