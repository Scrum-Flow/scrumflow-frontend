import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:scrumflow/models/user.dart';
import 'package:scrumflow/utils/dio_helper.dart';

class AuthService {
  Future<void> authenticate(String email, String password) async {
    Dio dio = await DioHelper.jsonDio();

    try {
      final response = await dio.post('/auth/login', data: {
        'email': email,
        'password': password,
      });

      User authenticatedUser =
          User.fromJson(response.data).copyWith(email: email);

      await DioHelper.setToken(json.encode(authenticatedUser.toJson()));
    } catch (e) {
      throw Exception('Falha ao autenticar com o servidor');
    }
  }

  static FutureOr<User> register(User user) async {
    var dio = await DioHelper.jsonDio();

    var response =
        await dio.post('/auth/register', data: json.encode(user.toJson()));

    return User.fromJson(response.data);
  }
}
