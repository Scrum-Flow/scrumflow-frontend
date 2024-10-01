import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:scrumflow/models/project.dart';
import 'package:scrumflow/utils/utils.dart';

class ProjectService {
  static String get path => '/project';

  static FutureOr<Project> fetchProject(int? id) async {
    Dio dio = await Connection.defaultDio();

    Response response = await dio.get('$path/$id');

    return Project.fromJson(response.data);
  }

  static FutureOr<List<Project>> fetchProjects() async {
    Dio dio = await Connection.defaultDio();

    Response response = await dio.get(path);

    return response.data.map<Project>((map) => Project.fromJson(map)).toList();
  }

  static FutureOr<Project> newProject(Project project) async {
    var dio = await Connection.defaultDio();

    var response = await dio.post('/project', data: json.encode(project.toJson()));

    return Project.fromJson(response.data);
  }

  static FutureOr<Project> updateProject(Project project) async {
    var dio = await Connection.defaultDio();

    var response = await dio.put('/project/${project.id}', data: json.encode(project.toJson()));

    return Project.fromJson(response.data);
  }

  static FutureOr<void> deleteProject(int? id) async {
    Dio dio = await Connection.defaultDio();

    await dio.delete('$path/$id');
  }
}
