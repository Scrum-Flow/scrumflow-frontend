import 'dart:async';

import 'package:dio/dio.dart';
import 'package:scrumflow/models/models.dart';
import 'package:scrumflow/utils/utils.dart';

class UserService {
  static String get path => '/user';

  static FutureOr<List<User>> getUsers() async {
    Dio dio = await Connection.defaultDio();

    Response response = await dio.get(path);

    return response.data?.map<User>((json) => User.fromJson(json)).toList() ?? [];
  }
}
