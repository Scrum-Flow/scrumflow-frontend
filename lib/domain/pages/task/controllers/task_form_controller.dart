import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scrumflow/domain/pages/user/services/services.dart';
import 'package:scrumflow/models/models.dart';
import 'package:scrumflow/utils/utils.dart';
import 'package:scrumflow/widgets/widgets.dart';

class TaskFormController extends GetxController {
  TaskFormController(this.task, {this.feature});

  final Task? task;
  final Feature? feature;

  final GlobalKey<FormState> taskFormKey = GlobalKey<FormState>();

  final Rx<PageState> pageState = PageState.none().obs;
  final Rx<PageState> initialState = PageState.none().obs;

  final Rx<Feature?> chosenFeature = Rx<Feature?>(null);
  final RxString name = ''.obs;
  final RxString description = ''.obs;
  final RxInt estimatePoints = 0.obs;
  final RxInt responsibleUser = 0.obs;

  final RxList<User> users = <User>[].obs;

  void updateName(String value) => name.value = value;

  void updateDescription(String value) => description.value = value;

  void updateEstimatePoints(int value) => estimatePoints.value = value;

  void updateResponsibleUser(int value) => responsibleUser.value = value;

  void updateTaskFeature(Feature value) => chosenFeature.value = value;

  @override
  onInit() {
    super.onInit();

    if (task != null) {
      name.value = task?.name ?? '';
      description.value = task?.description ?? '';
      estimatePoints.value = task?.estimatePoints ?? 0;
    }

    pageState.listen((value) {
      Prompts.showSnackBar(value);

      if (value.status == PageStatus.success) Get.back();
    });

    initialEvent();
  }

  FutureOr<void> initialEvent() async {
    initialState.value = PageState.loading();
    try {
      users.value = await UserService.getUsers();

      initialState.value = PageState.none();
    } on DioException catch (e) {
      initialState.value = PageState.error(e.message);
    } catch (e) {
      initialState.value = PageState.error(e.toString());
    }
  }

  FutureOr<void> save() async {
    if (taskFormKey.currentState!.validate()) {
      pageState.value = PageState.loading();
      try {
        Task _task;
        if (task != null) {
          _task = Task(
            id: task!.id,
            name: name.value,
            description: description.value,
            assignedUser: responsibleUser.value,
            assignedFeature: chosenFeature.value!.id,
            estimatePoints: estimatePoints.value,
          );

          await TaskService.updateTask(_task);

          pageState.value =
              PageState.success(info: 'Tarefa atualizada!!', data: _task);
        } else {
          Task newTask = await TaskService.newTask(Task(
            name: name.value,
            description: description.value,
            assignedUser: responsibleUser.value,
            assignedFeature: chosenFeature.value!.id,
            estimatePoints: estimatePoints.value,
          ));
          pageState.value =
              PageState.success(info: 'Tarefa criada!!', data: newTask);
        }
      } on DioException catch (e) {
        pageState.value = PageState.error(e.message);

        debugPrint(e.toString());
      } catch (e) {
        pageState.value = PageState.error(e.toString());

        debugPrint(e.toString());
      }
    }
  }

  String? getSelectedUserItem() {
    ///Contorno cotoco para o selectedItem no userResponsible
    int idUser =
        users.firstWhereOrNull((user) => user.name == task?.assignedUser)?.id ??
            0;

    updateResponsibleUser(idUser);

    return users
        .firstWhereOrNull((user) => user.name == task?.assignedUser)
        ?.name;
  }

  String? getSelectedFeatureItem() {
    if (feature != null) {
      updateTaskFeature(feature!);
    }
    return feature?.name;
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

  static FutureOr<void> updateTask(Task task) async {
    var dio = await Connection.defaultDio();

    await dio.put('$path/${task.id}', data: json.encode(task.toJson()));
  }
}
