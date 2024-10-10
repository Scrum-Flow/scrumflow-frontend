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
}
