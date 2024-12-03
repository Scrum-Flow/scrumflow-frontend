import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scrumflow/domain/pages/kanban/services/services.dart';
import 'package:scrumflow/models/models.dart';
import 'package:scrumflow/utils/enums/enum_status.dart';
import 'package:scrumflow/utils/utils.dart';
import 'package:scrumflow/widgets/widgets.dart';

class KanbanController extends GetxController {
  KanbanController(this.project);

  final Project project;

  Map<SprintDetails, List<Task>> get sprintTasks => _sprintTasks ?? {};
  late ProjectDetails projectDetails;
  RxMap<ObjectStatus, List<Task>> statusTaskMap = <ObjectStatus, List<Task>>{}.obs;

  Map<SprintDetails, List<Task>>? _sprintTasks;
  Rx<SprintDetails?> selectedSprint = Rxn();
  Rx<PageState> pageState = PageState.none().obs;
  Rx<PageState> projectDetailsState = PageState.none().obs;

  @override
  Future<void> onInit() async {
    pageState.value = PageState.loading();
    pageState.listen((value) => Prompts.showSnackBar(value));

    await fetchProjectDetails();

    distributeTasksOnLists();

    super.onInit();
    pageState.value = PageState.none();
  }

  FutureOr<void> fetchProjectDetails() async {
    projectDetailsState.value = PageState.loading();

    try {
      projectDetails = await KanbanService.projectDetails(project.id ?? 0);

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

  Future<void> onChangeSprintSelected(SprintDetails? selected) async {
    selectedSprint.value = selected;

    if (selected == null) {
      await onInit();
    } else {
      _sprintTasks?.clear();

      buildMapSprintTask(projectDetails.sprints!);

      distributeTasksOnLists();
    }
  }

  void buildMapSprintTask(List<SprintDetails> sprints) {
    final Map<SprintDetails, List<Task>> sprintTaskMap = {};

    for (var sprint in sprints) {
      if (selectedSprint.value == null) {
        final tasks = sprint.features!.expand((feature) => feature.tasks!).toList();

        sprintTaskMap[sprint] = tasks;
      } else {
        if (sprint.id == selectedSprint.value!.id) {
          final tasks = sprint.features!.expand((feature) => feature.tasks!).toList();

          sprintTaskMap[sprint] = tasks;
        }
      }
    }
    _sprintTasks = sprintTaskMap;
  }

  void distributeTasksOnLists() {
    for (var status in ObjectStatus.values) {
      statusTaskMap[status] = [];
    }

    _sprintTasks!.values.forEach((tasks) {
      for (var task in tasks) {
        final status = ObjectStatus.values.firstWhere((sts) => sts.name == task.status);
        statusTaskMap[status]!.add(task);
      }
    });
  }

  Future<void> updateTaskStatus({
    required ObjectStatus oStatus,
    required int oIndex,
    required ObjectStatus nStatus,
    required int nIndex,
  }) async {
    final movedTask = statusTaskMap[oStatus]!.removeAt(oIndex);

    statusTaskMap[nStatus]!.insert(nIndex, movedTask);

    KanbanService.updateTaskStatus(movedTask.copyWith(status: ObjectStatus.getStringToJson(nStatus.getDescription())));

    statusTaskMap.refresh();
  }

  String getSprintName(int? taskId) {
    for (var sprint in projectDetails.sprints ?? []) {
      for (var feature in sprint.features ?? []) {
        for (var task in feature.tasks ?? []) {
          if (task.id == taskId) {
            return sprint.name;
          }
        }
      }
    }
    return "Sem Sprint";
  }

  String getFeatureName(int? taskId) {
    for (var sprint in projectDetails.sprints ?? []) {
      for (var feature in sprint.features ?? []) {
        for (var task in feature.tasks ?? []) {
          if (task.id == taskId) {
            return feature.name;
          }
        }
      }
    }
    return "Sem Funcionalidade";
  }

/*Future<void> updateTask(Task task, ObjectStatus status) async {
    try {
      await TaskService.updateTask(Task(
        id: task.id,
        name: task.name,
        status: status.name,
        description: task.description,
        assignedToUserId: task.assignedUser.,
        assignedFeature: chosenFeature.value!.id,
        estimatePoints: estimatePoints.value,
      ));
    } catch (e) {
      debugPrint(e.toString());
    }
  }*/
}
