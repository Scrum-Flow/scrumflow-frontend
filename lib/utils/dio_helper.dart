import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:scrumflow/domain/login/pages/login_page.dart';
import 'package:scrumflow/utils/utils.dart';

class DioHelper {
  static FutureOr<Map<String, dynamic>> get authHeader async => {
        HttpHeaders.authorizationHeader: 'Bearer ${await userToken}',
      };

  static FutureOr<Map<String, dynamic>> get jsonHeaders async => {
        HttpHeaders.contentTypeHeader: 'application/json',
        ...await authHeader,
      };

  static String get baseURL => EnvHelper.getKey(Keys.SCRUMFLOW_API_URL);

  static FutureOr<String?> get userToken async =>
      await Prefs.getString(PrefsKeys.userToken);

  static FutureOr<void> setToken(String token) async =>
      await Prefs.setString(PrefsKeys.userToken, token);

  static FutureOr<Dio> jsonDio() async {
    return await defaultDio(
        {HttpHeaders.contentTypeHeader: 'application/json'});
  }

  static FutureOr<Dio> defaultDio([Map<String, dynamic>? headers]) async {
    Dio dio = Dio();

    dio.options
      ..receiveTimeout = const Duration(minutes: 1)
      ..connectTimeout = const Duration(minutes: 1)
      ..headers = headers ?? await jsonHeaders
      ..baseUrl = baseURL;

    dio.interceptors
      ..add(LogInterceptor())
      ..add(AppInterceptor());

    return dio;
  }
}

class AppInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    var statusCode = err.response?.statusCode;

    switch (statusCode) {
      case HttpStatus.unauthorized:
        Get.to(const LoginPage());
        break;
    }

    super.onError(err, handler);
  }
}
