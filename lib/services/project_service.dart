import 'dart:async';
import 'dart:convert';

import 'package:scrumflow/models/project.dart';
import 'package:scrumflow/utils/dio_helper.dart';

class ProjetcService {
  static FutureOr<Project> newProject(Project project) async {
    var dio = await DioHelper.defaultDio(await DioHelper.jsonHeaders);

    var response =
        await dio.post('/project', data: json.encode(project.toJson()));

    return Project.fromJsonObject(response.data);
  }

  static FutureOr<void> deleteProject(int id) async {
    var dio = await DioHelper.jsonDio();

    var response = await dio.delete('/project/$id');

    ///TODO Ajustar isso. :> Não sei o que retorna
  }

  static FutureOr<void> updateProject(int id) async {
    var dio = await DioHelper.jsonDio();

    var response = await dio.put('/project/$id');

    ///TODO Ajustar isso. :> Não sei o que retorna
  }

  static FutureOr<Project> getProject(int id) async {
    var dio = await DioHelper.jsonDio();

    var response = await dio.get('/project/$id');

    return Project.fromJsonObject(response.data);
  }

  static FutureOr<List<Project>> getAllProject() async {
    var dio = await DioHelper.jsonDio();

    var response = await dio.get('/project');

    return Project.fromJson(response.data);
  }
}
