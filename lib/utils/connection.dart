import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:scrumflow/domain/pages/login/login.dart';
import 'package:scrumflow/models/request_exception.dart';
import 'package:scrumflow/utils/utils.dart';
import 'package:scrumflow/widgets/prompts.dart';

class Connection {
  static FutureOr<Map<String, dynamic>> get authHeader async => {
        HttpHeaders.authorizationHeader: 'Bearer ${await userToken}',
      };

  static FutureOr<Map<String, dynamic>> get jsonHeaders async => {
        HttpHeaders.contentTypeHeader: 'application/json',
        ...await authHeader,
      };

  static String get baseURL => Variables.getKey(Keys.SCRUMFLOW_API_URL);

  static FutureOr<String?> get userToken async => json.decode((await Preferences.getString(PreferencesKeys.userToken)) ?? '')['token'];

  static FutureOr<void> setToken(String token) async => await Preferences.setString(PreferencesKeys.userToken, token);

  static FutureOr<Dio> jsonDio() async => await defaultDio({HttpHeaders.contentTypeHeader: 'application/json'});

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

    var type = err.type;

    RequestException? exception;

    err.response?.extra = {'exception': exception};

    if (err.response?.data != null) {
      exception = RequestException.fromJson(err.response!.data);
    }

    switch (type) {
      case DioExceptionType.sendTimeout:
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
        Prompts.errorSnackBar('Erro de conexão', 'Tempo de conexão excedido, verifique sua conexão e tente novamente');
        return;
      case DioExceptionType.badResponse:
        {
          if (exception != null) {
            switch (exception.statusCode) {
              case HttpStatus.forbidden:
                Prompts.errorSnackBar('Erro', exception.errors?.join(', ') ?? 'Requisição inválida, verifique os dados e tente novamente');
                break;
              case HttpStatus.unauthorized:
                Get.to(const LoginPage());
                break;
              case HttpStatus.requestTimeout:
                Prompts.errorSnackBar('Erro de conexão', 'Tempo de conexão excedido, verifique sua conexão e tente novamente');
                break;
              case HttpStatus.internalServerError:
                Prompts.errorSnackBar('Erro interno', 'Erro interno no servidor, tente novamente mais tarde');
                break;
              case HttpStatus.badRequest:
                Prompts.errorSnackBar('Erro', 'Requisição inválida, verifique os dados e tente novamente');
                break;
              case HttpStatus.notFound:
                Prompts.errorSnackBar('Erro', 'Recurso não encontrado');
                break;
            }
          }
        }
        break;

      case DioExceptionType.badCertificate:
      case DioExceptionType.cancel:
      case DioExceptionType.connectionError:
      case DioExceptionType.unknown:
        break;
    }

    super.onError(err, handler);
  }
}
