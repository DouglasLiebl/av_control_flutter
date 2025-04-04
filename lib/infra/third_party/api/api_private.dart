import 'dart:convert';

import 'package:demo_project/infra/dto/auth_dto.dart';
import 'package:demo_project/infra/third_party/local_storage/secure_storage.dart';
import 'package:demo_project/main.dart';
import 'package:demo_project/utils/logger.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiPrivate {
  final Dio dio;

  ApiPrivate({required this.dio});

  Dio getInstance() {
    dio.interceptors.clear();
    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        AuthDto? authData;

        authData = await getIt<SecureStorage>().getAuth();

         options.baseUrl = dotenv.env["BASE_URL"] ?? "";
        options.headers["Authorization"] = "${authData?.tokenType} ${authData?.accessToken}";

        Logger.log('-------------------------');
        Logger.log(options.method);
        Logger.log(options.data);
        Logger.log(options.queryParameters);
        Logger.log('-------------------------');

        return handler.next(options);
      },
      onError: (DioException exception, handler) async {
        Logger.log('-------------------------');
        Logger.log(exception.error);
        Logger.log(exception.message);
        Logger.log(exception.response);
        Logger.log(exception.response?.statusCode ?? '');
        Logger.log(exception.response?.data);
        Logger.log('-------------------------');

        
        return handler.next(exception);
      },
      onResponse: (response, handler) async {
        Logger.log(response.data);
        Logger.log(response.statusMessage);
        Logger.log(response.statusCode);
        Logger.log(jsonEncode(response.data));
        
        return handler.next(response);
      },
    ));

    return dio;
  }
}