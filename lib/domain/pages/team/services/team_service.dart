import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:scrumflow/models/models.dart';
import 'package:scrumflow/utils/utils.dart';

class TeamService {
  static String get path => "/teams";

  static FutureOr<Team> add(Team team) async {
    Dio dio = await Connection.defaultDio();

    Map<String, dynamic> data = {
      'name': team.name,
      'projectId': team.project?.id,
      'teamMembers': team.users?.map((user) => user.id).toList(),
    };

    Response response = await dio.post(path, data: json.encode(data));

    return Team.fromJson(response.data);
  }

  static FutureOr<Team> update(Team team) async {
    Dio dio = await Connection.defaultDio();

    Map<String, dynamic> data = {
      'name': team.name,
      'projectId': team.project?.id,
      'teamMembers': team.users?.map((user) => user.id).toList(),
    };

    Response response = await dio.put('$path/${team.id}', data: json.encode(data));

    return Team.fromJson(response.data);
  }

  static FutureOr<List<Team>> getAll() async {
    Dio dio = await Connection.defaultDio();

    Response response = await dio.get(path);

    return response.data.map<Team>((json) => Team.fromJson(json)).toList();
  }

  static FutureOr<Team> get(int? id) async {
    Dio dio = await Connection.defaultDio();

    Response response = await dio.get('$path/$id');

    return Team.fromJson(response.data);
  }

  static FutureOr<void> delete(int? id) async {
    Dio dio = await Connection.defaultDio();

    await dio.delete('$path/$id');
  }
}
