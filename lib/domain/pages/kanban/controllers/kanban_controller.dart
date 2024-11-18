import 'dart:async';

import 'package:appflowy_board/appflowy_board.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:scrumflow/domain/pages/kanban/kanban.dart';
import 'package:scrumflow/domain/pages/kanban/services/services.dart';
import 'package:scrumflow/domain/pages/pages.dart';
import 'package:scrumflow/models/models.dart';
import 'package:scrumflow/utils/utils.dart';
import 'package:scrumflow/widgets/widgets.dart';

enum KanbanBoards {
  todo('Pendente'),
  doing('Em Andamento'),
  done('Concluído');

  final String name;

  const KanbanBoards(this.name);

  @override
  String toString() => name;
}

class KanbanController extends GetNotifier<Map<SprintDetails, List<Task>>> {
  KanbanController(this.project) : super({});

  final Project project;

  Map<SprintDetails, List<Task>> get sprintTasks => _sprintTasks ?? {};

  Map<SprintDetails, List<Task>>? _sprintTasks;
  Rx<SprintDetails?> selectedSprint = Rxn();
  Rx<PageState> pageState = PageState.none().obs;

  AppFlowyBoardController kanbanController = AppFlowyBoardController(
    onMoveGroup: _onMoveGroup,
    onMoveGroupItem: _onMoveGroupItem,
    onMoveGroupItemToGroup: _onMoveGroupItemToGroup,
  );

  final AppFlowyBoardScrollController boardScrollController = AppFlowyBoardScrollController();

  @override
  void onInit() async {
    pageState.listen((value) => Prompts.showSnackBar(value));

    await fetchTasks();

    resetGroups();

    super.onInit();
  }

  void onChangeSprintSelected(SprintDetails? selected) {
    selectedSprint.value = selected;

    updateKanbanTasks();
  }

  void resetGroups([List<Task>? tasks]) {
    List<AppFlowyGroupItem> todoTasks = (tasks ?? []).map((task) => RichTextItem(title: task.name ?? '', subtitle: Helper.formatDate(task.createdAt) ?? '')).toList();

    kanbanController.removeGroup(KanbanBoards.todo.name, notify: false);
    kanbanController.removeGroup(KanbanBoards.doing.name, notify: false);
    kanbanController.removeGroup(KanbanBoards.done.name, notify: false);

    kanbanController.addGroup(AppFlowyGroupData(id: KanbanBoards.todo.name, name: KanbanBoards.todo.toString(), items: todoTasks)..draggable = false, notify: false);
    kanbanController.addGroup(AppFlowyGroupData(id: KanbanBoards.doing.name, name: KanbanBoards.doing.toString())..draggable = false, notify: false);
    kanbanController.addGroup(AppFlowyGroupData(id: KanbanBoards.done.name, name: KanbanBoards.done.toString())..draggable = false, notify: false);
  }

  FutureOr<void> fetchTasks() async {
    change(null, status: RxStatus.loading());

    try {
      Map<SprintDetails, List<Task>> sprintDetailsTasks = {};

      ProjectDetails details = await KanbanService.projectDetails(project.id ?? 0);

      for (SprintDetails sprint in details.sprints ?? []) {
        List<Task> sprintTasks = [];

        for (FeatureDetails featureDetails in sprint.features ?? []) {
          sprintTasks.addAll(featureDetails.tasks ?? []);
        }

        sprintDetailsTasks.update(
          sprint,
          (value) => [...value, ...sprintTasks],
          ifAbsent: () => sprintTasks,
        );
      }

      _sprintTasks = sprintDetailsTasks;
    } on DioException catch (e) {
      change(null, status: RxStatus.error(e.toString()));
    } catch (e) {
      change(null, status: RxStatus.error(e.toString()));
    }

    change(sprintTasks, status: RxStatus.success());
  }

  void updateKanbanTasks() {
    change(null, status: RxStatus.loading());

    resetGroups(sprintTasks[selectedSprint.value]);

    change(sprintTasks, status: RxStatus.success());
  }

  static void _onMoveGroup(String fromGroupId, int fromIndex, String toGroupId, int toIndex) {
    debugPrint('onMoveGroup: fromGroupId: $fromGroupId, fromIndex: $fromIndex, toGroupId: $toGroupId, toIndex: $toIndex');
  }

  static void _onMoveGroupItem(String groupId, int fromIndex, int toIndex) {
    debugPrint('onMoveGroupItem: groupId: $groupId, fromIndex: $fromIndex, toIndex: $toIndex');
  }

  static void _onMoveGroupItemToGroup(String fromGroupId, int fromIndex, String toGroupId, int toIndex) {}
}
