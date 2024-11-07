import 'dart:async';

import 'package:appflowy_board/appflowy_board.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
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

class KanbanController extends GetNotifier<Map<Feature, List<Task>>> {
  KanbanController(this.project) : super({});

  final Project project;

  Map<Feature, List<Task>> get features => _features ?? {};

  Map<Feature, List<Task>>? _features;
  Rx<PageState> pageState = PageState.none().obs;

  AppFlowyBoardController kanbanController = AppFlowyBoardController(
    onMoveGroup: _onMoveGroup,
    onMoveGroupItem: _onMoveGroupItem,
    onMoveGroupItemToGroup: _onMoveGroupItemToGroup,
  );

  final AppFlowyBoardScrollController boardScrollController = AppFlowyBoardScrollController();

  @override
  void onInit() async {
    pageState.listen((value) {
      Prompts.showSnackBar(value);
    });

    await fetchTasks();

    super.onInit();
  }

  FutureOr<void> fetchTasks() async {
    change(null, status: RxStatus.loading());

    try {
      Map<Feature, List<Task>> featuresMap = {};

      List<Feature> features = await FeatureService.fetchFeatures(project.id ?? 0);

      for (Feature feature in features) {
        List<Task> tasks = await TaskService.fetchTasks(feature.id);

        featuresMap.putIfAbsent(feature, () => tasks);
      }

      _features = featuresMap;
    } on DioException catch (e) {
      change(null, status: RxStatus.error(e.toString()));
    } catch (e) {
      change(null, status: RxStatus.error(e.toString()));
    }

    change(features, status: RxStatus.success());
  }

  static void _onMoveGroup(String fromGroupId, int fromIndex, String toGroupId, int toIndex) {
    debugPrint('onMoveGroup: fromGroupId: $fromGroupId, fromIndex: $fromIndex, toGroupId: $toGroupId, toIndex: $toIndex');
  }

  static void _onMoveGroupItem(String groupId, int fromIndex, int toIndex) {
    debugPrint('onMoveGroupItem: groupId: $groupId, fromIndex: $fromIndex, toIndex: $toIndex');
  }

  static void _onMoveGroupItemToGroup(String fromGroupId, int fromIndex, String toGroupId, int toIndex) {}
}
