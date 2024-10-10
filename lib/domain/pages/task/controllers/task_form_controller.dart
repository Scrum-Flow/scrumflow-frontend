import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scrumflow/domain/pages/task/services/services.dart';
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

          onInit();

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

          onInit();

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
    ///Contorno cotoco para o selectedItem no chosen featuer
    if (feature != null) {
      updateTaskFeature(feature!);
    }
    return feature?.name;
  }
}
