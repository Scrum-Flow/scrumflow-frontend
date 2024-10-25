import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:scrumflow/models/models.dart';
import 'package:scrumflow/models/user_role.dart';
import 'package:scrumflow/utils/utils.dart';

class UserService {
  static String get path => '/user';

  static FutureOr<List<User>> getUsers() async {
    Dio dio = await Connection.defaultDio();

    var response = await dio.get(path);

    return response.data?.map<User>((json) => User.fromJson(json)).toList() ?? [];
  }

  static FutureOr<User> updateUserRoles(User user) async {
    Dio dio = await Connection.defaultDio();

    Response response = await dio.put('$path/${user.id}', data: json.encode(user.roles?.map((role) => role.id).toList()));

    return User.fromJson(response.data);
  }
  
  static FutureOr<List<UserRole>> userRoles() async {
    Dio dio = await Connection.defaultDio();
    
    Response response = await dio.get('$path/roles');

    return response.data.map<UserRole>((json) => UserRole.fromJson(json)).toList();
  }
}
