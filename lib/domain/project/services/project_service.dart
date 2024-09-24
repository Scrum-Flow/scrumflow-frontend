import 'dart:async';

import 'package:dio/dio.dart';
import 'package:scrumflow/models/project.dart';
import 'package:scrumflow/utils/utils.dart';

class ProjectService {
  static String get path => '/project';

  static FutureOr<List<Project>> fetchProjects() async {
    Dio dio = await DioHelper.defaultDio();

    Response response = await dio.get(path);

    return response.data.map<Project>((map) => Project.fromJson(map)).toList();
  }

  static FutureOr<void> deleteProject(int? id) async {
    Dio dio = await DioHelper.defaultDio();

    await dio.delete('$path/$id');
  }
}
