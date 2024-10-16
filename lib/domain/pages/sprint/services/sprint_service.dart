import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:scrumflow/models/sprint.dart';
import 'package:scrumflow/utils/utils.dart';

class SprintService {
  static String get path => '/sprints';

  static FutureOr<Sprint> fetchSprint(int? id) async {
    Dio dio = await Connection.defaultDio();

    Response response = await dio.get('$path/$id');

    return Sprint.fromJson(response.data);
  }

  static FutureOr<List<Sprint>> fetchSprints() async {
    Dio dio = await Connection.defaultDio();

    Response response = await dio.get(path);

    return response.data.map<Sprint>((map) => Sprint.fromJson(map)).toList();
  }

  static FutureOr<Sprint> newSprint(Sprint sprint) async {
    var dio = await Connection.defaultDio();

    var response = await dio.post(path, data: json.encode(sprint.toJson()));

    return Sprint.fromJson(response.data);
  }

  static FutureOr<Sprint> updateSprint(Sprint sprint) async {
    var dio = await Connection.defaultDio();

    var response = await dio.put('$path/${sprint.id}', data: json.encode(sprint.toJson()));

    return Sprint.fromJson(response.data);
  }

  static FutureOr<void> deleteSprint(int? id) async {
    Dio dio = await Connection.defaultDio();

    await dio.delete('$path/$id');
  }
}
