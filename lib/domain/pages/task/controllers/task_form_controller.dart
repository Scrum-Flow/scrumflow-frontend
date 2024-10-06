import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scrumflow/domain/pages/user/services/services.dart';
import 'package:scrumflow/models/models.dart';
import 'package:scrumflow/utils/utils.dart';

class TaskFormController extends GetxController {
  TaskFormController(this.task, {required this.feature});

  final Task? task;
  final Feature feature;

  final GlobalKey<FormState> taskFormKey = GlobalKey<FormState>();

  final Rx<PageState> pageState = PageState.none().obs;
  final Rx<PageState> initialState = PageState.none().obs;

  final RxString name = ''.obs;
  final RxString description = ''.obs;
  final RxInt estimatePoints = 0.obs;
  //Trato como User ou como int para organizar o id?
  final RxInt responsibleUser = 0.obs;

  final RxList<User> users = <User>[].obs;

  void updateName(String value) => name.value = value;

  void updateDescription(String value) => description.value = value;

  void updateEstimatePoints(int value) => estimatePoints.value = value;

  void updateResponsibleUser(int value) => responsibleUser.value = value;

  FutureOr<void> initialEvent() async {
    initialState.value = PageState.loading();
    try {
      //TODO : filtrar o user com base no projectId
      users.value = await UserService.getUsers();

      initialState.value = PageState.none();
    } on DioException catch (e) {
      initialState.value = PageState.error(e.message);
    } catch (e) {
      initialState.value = PageState.error(e.toString());
    }
  }

  FutureOr<void> newTask() async {
    if (taskFormKey.currentState!.validate()) {
      pageState.value = PageState.loading();
      try {
        //TODO : nessa task vou precisar do ProjectId e do FeatureId
        Task task = await await TaskService.newTask(Task(
          name: name.value,
          description: description.value,
          assignedUser: responsibleUser.value,
          assignedFeature: feature.id,
          estimatePoints: estimatePoints.value,
        ));
        pageState.value =
            PageState.success(info: 'Tarefa criada!!', data: task);

        Get.back();
      } on DioException catch (e) {
        pageState.value = PageState.error(e.message);

        debugPrint(e.toString());
      } catch (e) {
        pageState.value = PageState.error(e.toString());

        debugPrint(e.toString());
      }
    }
  }
}

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
}
