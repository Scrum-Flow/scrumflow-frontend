import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scrumflow/domain/pages/feature/feature.dart';
import 'package:scrumflow/domain/pages/pages.dart';
import 'package:scrumflow/models/models.dart';
import 'package:scrumflow/utils/utils.dart';
import 'package:scrumflow/widgets/widgets.dart';

class TaskPageController extends GetxController {
  int projectId;

  TaskPageController({required this.projectId});

  List<Task>? _tasks;
  List<Feature>? _features;

  List<Task> tasksValues = [];
  List<Feature> featureValues = [];
  Rx<PageState> featureListState = PageState.none().obs;
  Rx<PageState> taskListState = PageState.none().obs;
  Rx<PageState> pageState = PageState.none().obs;
  Rx<PageState> taskDeleteState = PageState.none().obs;

  @override
  void onInit() {
    pageState.value = PageState.loading();

    fetchFeatures();

    taskDeleteState.listen(Prompts.showSnackBar);

    super.onInit();
  }

  FutureOr<void> fetchFeatures() async {
    featureListState.value = PageState.loading();

    try {
      List<Feature> features = await FeatureService.fetchFeatures(projectId);

      featureValues = _features = features;

      featureListState.value = PageState.none();

      fetchTasks();
    } on DioException catch (e) {
      debugPrint(e.toString());
      featureListState.value = PageState.error();
    } catch (e) {
      debugPrint(e.toString());
      featureListState.value = PageState.error();
    }
  }

  FutureOr<void> fetchTasks() async {
    if (featureListState.value != PageState.none()) {
      taskListState.value = PageState.error(
          "Não foi possível obter as tarefas pois não foi possível obter as funcionalidades");
    }

    if (_features?.isEmpty ?? true) {
      taskListState.value = PageState.error("Funcionalidades nula ou vazia");
    }

    if (taskListState.value != PageState.error()) {
      taskListState.value = PageState.loading();

      try {
        _tasks = [];

        for (Feature feature in _features!) {
          _tasks!.addAll(await TaskService.fetchTasks(feature.id));
        }
        tasksValues = _tasks!;

        taskListState.value = PageState.none();
        pageState.value = PageState.none();
      } on DioException catch (e) {
        debugPrint(e.toString());
        taskListState.value = PageState.error();
      } catch (e) {
        debugPrint(e.toString());
        taskListState.value = PageState.error();
      }
    }
  }

  FutureOr<void> updateTask() async {}

  FutureOr<void> deleteTask(int taskId) async {
    taskDeleteState.value = PageState.loading('Deletando tarefa!');

    try {
      await TaskService.deleteTask(taskId);

      onInit();

      taskDeleteState.value = PageState.success(info: 'Tarefa foi excluída!!');
    } on DioException catch (e) {
      debugPrint(e.toString());
      taskDeleteState.value = PageState.error('Erro ao deletar tarefa!');
    } catch (e) {
      debugPrint(e.toString());
      taskDeleteState.value = PageState.error('Erro ao deletar tarefa!');
    }

    taskDeleteState.value = PageState.none();
  }
}

/// Tenho que ter uma lista das features -->
/// Para cada feature, fazer uma request das tasks dessa feature
