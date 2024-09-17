import 'dart:async';
import 'dart:convert';

import 'package:scrumflow/models/project.dart';
import 'package:scrumflow/utils/dio_helper.dart';

class ProjetcService {
  static FutureOr<Project> newProject(Project project) async {
    var dio = await DioHelper.defaultDio();

    var response = await dio.post('/project', data: json.encode(project.toJson()));

    return Project.fromJson(response.data);
  }

  static FutureOr<void> deleteProject(int? id) async {
    var dio = await DioHelper.jsonDio();
  }

  static FutureOr<void> updateProject(Project project) async {
    var dio = await DioHelper.jsonDio();
  }
}
