import 'package:demo_project/utils/logger.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiPublic {
  final Dio dio;

  ApiPublic({required this.dio});

  Dio getInstance() {
    dio.interceptors.clear();
    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        options.baseUrl = dotenv.env["BASE_URL"] ?? "";
        options.headers["Content-Type"] = "application/json";
        return handler.next(options);
      },
      onError: (DioException e, handler) async {
        Logger.log('-------------------------');
        Logger.log(e.error);
        Logger.log(e.message);
        Logger.log(e.response);
        Logger.log(e.response?.statusCode.toString() ?? '');
        Logger.log(e.response?.data.toString() ?? '');
        Logger.log('-------------------------');

        return handler.next(e);
      }, 
      onResponse: (response, handler) async {
        Logger.log(response.data);
        Logger.log(response.statusMessage);
        Logger.log(response.statusCode);

        return handler.next(response);
      }
    ));

    return dio;
  }
}