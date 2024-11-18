import 'dart:async';

import 'package:dio/dio.dart';
import 'package:scrumflow/models/models.dart';
import 'package:scrumflow/utils/utils.dart';

class KanbanService {
  static String get path => '/project';

  static FutureOr<ProjectDetails> projectDetails(int projectId) async {
    Dio dio = await Connection.defaultDio();

    Response response = await dio.get('$path/$projectId/details');

    return ProjectDetails.fromJson(response.data);
  }
}
