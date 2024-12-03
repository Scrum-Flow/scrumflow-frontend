import 'dart:async';

import 'package:dio/dio.dart';
import 'package:scrumflow/domain/pages/pages.dart';
import 'package:scrumflow/models/models.dart';
import 'package:scrumflow/utils/utils.dart';

class KanbanService {
  static FutureOr<ProjectDetails> projectDetails(int projectId) async {
    Dio dio = await Connection.defaultDio();

    Response response = await dio.get('${ProjectService.path}/$projectId/details');

    return ProjectDetails.fromJson(response.data);
  }

  static FutureOr<void> updateTaskStatus(Task task) async {
    Dio dio = await Connection.defaultDio();

    await dio.post('${TaskService.path}/${task.id}/update', queryParameters: {'status': task.status});
  }
}
