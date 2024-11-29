import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scrumflow/domain/pages/kanban/services/services.dart';
import 'package:scrumflow/models/models.dart';
import 'package:scrumflow/utils/utils.dart';
import 'package:scrumflow/widgets/widgets.dart';

class KanbanController extends GetxController {
  KanbanController(this.project);

  final Project project;

  Map<SprintDetails, List<Task>> get sprintTasks => _sprintTasks ?? {};

  Map<SprintDetails, List<Task>>? _sprintTasks;
  Rx<SprintDetails?> selectedSprint = Rxn();
  Rx<PageState> pageState = PageState.none().obs;
  Rx<PageState> projectDetailsState = PageState.none().obs;

  @override
  void onInit() async {
    pageState.value = PageState.loading();
    pageState.listen((value) => Prompts.showSnackBar(value));

    await fetchProjectDetails();

    // resetGroups();

    super.onInit();
    pageState.value = PageState.none();
  }

  FutureOr<void> fetchProjectDetails() async {
    projectDetailsState.value = PageState.loading();

    try {
      ProjectDetails projectDetails =
          await KanbanService.projectDetails(project.id ?? 0);

      if (projectDetails.sprints != null) {
        buildMapSprintTask(projectDetails.sprints!);
      } else {
        throw Exception("O projeto não possui sprints");
      }
    } on DioException catch (e) {
      debugPrint(e.toString());
      projectDetailsState.value = PageState.error();
    } catch (e) {
      debugPrint(e.toString());
      projectDetailsState.value = PageState.error();
    }

    projectDetailsState.value = PageState.none();
  }

  void onChangeSprintSelected(SprintDetails? selected) {
    selectedSprint.value = selected;
  }

  // void resetGroups([List<Task>? tasks]) {
  //   List<AppFlowyGroupItem> todoTasks = (tasks ?? [])
  //       .map((task) => RichTextItem(
  //           title: task.name ?? '',
  //           subtitle: Helper.formatDate(task.createdAt) ?? ''))
  //       .toList();
  // }

  void updateKanbanBoard() {}

  void buildMapSprintTask(List<SprintDetails> sprints) {
    final Map<SprintDetails, List<Task>> sprintTaskMap = {};

    for (var sprint in sprints) {
      final tasks =
          sprint.features!.expand((feature) => feature.tasks!).toList();

      sprintTaskMap[sprint] = tasks;
    }
    _sprintTasks = sprintTaskMap;
  }
}
