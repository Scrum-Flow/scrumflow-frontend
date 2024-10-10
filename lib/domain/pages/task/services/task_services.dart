import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:scrumflow/models/models.dart';
import 'package:scrumflow/utils/utils.dart';

class TaskService {
  static String get path => '/task';

  static FutureOr<Task> fetchTask(int? id) async {
    Dio dio = await Connection.defaultDio();

    var response = await dio.get('$path/$id');

    return Task.fromJson(response.data);
  }

  static FutureOr<List<Task>> fetchTasks(int? featureId) async {
    Dio dio = await Connection.defaultDio();

    var response;
    if (featureId == null) {
      response = await dio.get(path);
    } else {
      response = await dio.get('$path/feature/$featureId');
    }

    return response.data.map<Task>((map) => Task.fromJson(map)).toList();
  }

  static FutureOr<Task> newTask(Task task) async {
    var dio = await Connection.defaultDio();

    var response = await dio.post(path, data: json.encode(task.toJson()));

    return Task.fromJson(response.data);
  }

  static FutureOr<void> deleteTask(int? id) async {
    Dio dio = await Connection.defaultDio();

    await dio.delete('$path/$id');
  }

  static FutureOr<void> updateTask(Task task) async {
    var dio = await Connection.defaultDio();

    await dio.put('$path/${task.id}', data: json.encode(task.toJson()));
  }
}
