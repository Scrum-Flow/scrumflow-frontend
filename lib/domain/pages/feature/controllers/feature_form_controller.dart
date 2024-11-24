import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scrumflow/domain/pages/feature/services/services.dart';
import 'package:scrumflow/domain/pages/sprint/services/services.dart';
import 'package:scrumflow/models/models.dart';
import 'package:scrumflow/utils/utils.dart';

class FeatureFormController extends GetxController {
  FeatureFormController(this.feature, {this.projectId /*, this.sprint*/});

  final GlobalKey<FormState> featureFormKey = GlobalKey<FormState>();

  final Feature? feature;

  final Rx<PageState> pageState = PageState.none().obs;
  final Rx<PageState> fetchSprintState = PageState.none().obs;
  final Rx<PageState> fetchProjectSprintsState = PageState.none().obs;
  final Rx<PageState> initialState = PageState.none().obs;
  final RxString name = ''.obs;
  final RxString description = ''.obs;
  int? projectId;
  List<Sprint> newFeatureSprints = [];
  List<Sprint> oldFeatureSprints = [];
/*
  Sprint? sprint;
*/
  List<Sprint> projectSprints = [];

  void updateName(String value) => name.value = value;

  void updateDescription(String value) => description.value = value;

  @override
  onInit() async {
    if (feature != null) {
      name.value = feature!.name ?? '';
      description.value = feature!.description ?? '';
      projectId = projectId ?? feature!.projectId;
      await fetchSprints();
    }

    /*if (sprint != null) {
      oldFeatureSprints.add(sprint!);
    }*/

    await fetchProjectSprints();

    pageState.listen((value) {
      if (value.status == PageStatus.success) Get.back(result: true);
    });

    super.onInit();
  }

  FutureOr<void> save() async {
    if (featureFormKey.currentState!.validate()) {
      pageState.value = PageState.loading();

      try {
        Feature _feature;
        if (feature != null) {
          _feature = Feature(
              id: feature!.id,
              name: name.value,
              description: description.value,
              projectId: projectId);

          await FeatureService.updateFeature(_feature);

          //sprints removidas ?
          List<Sprint> removedSprints = oldFeatureSprints
              .where((sprint) => newFeatureSprints.contains(sprint))
              .toList();

          // sprints adicionadas ?
          List<Sprint> addedSprints = newFeatureSprints
              .where((sprint) => !oldFeatureSprints.contains(sprint))
              .toList();

          if (removedSprints.isNotEmpty) {
            for (Sprint s in removedSprints) {
              await SprintService.disassociateFeatureWithSprint(
                  s.id!, _feature.id!);
            }
          }

          if (addedSprints.isNotEmpty) {
            for (Sprint s in addedSprints) {
              await SprintService.associateFeatureWithSprint(
                  s.id!, _feature.id!);
            }
          }

          onInit();
          pageState.value = PageState.success(
              info: 'Funcionalidade atualizada!!', data: _feature);
        } else {
          Feature newFeature = await FeatureService.newFeature(
            Feature(
                name: name.value,
                description: description.value,
                projectId: projectId),
          );

          if (newFeatureSprints.isNotEmpty) {
            for (Sprint sprint in newFeatureSprints) {
              await SprintService.associateFeatureWithSprint(
                  sprint.id!, newFeature.id!);
            }
          }

          onInit();
          pageState.value = PageState.success(
              info: 'Funcionalidade criada!!', data: newFeature);
        }
      } on DioException catch (e) {
        pageState.value = PageState.error(e.message);

        debugPrint(e.toString());
      }
    }
  }

  Future<void> fetchSprints() async {
    fetchSprintState.value = PageState.loading("Buscando Sprints");

    try {
      for (int sprintId in feature!.sprintsId!) {
        oldFeatureSprints.add(await SprintService.fetchSprint(sprintId));
      }

      fetchSprintState.value = PageState.none();
    } on DioException catch (e) {
      pageState.value = PageState.error("Erro ao buscar sprints: ${e.message}");

      debugPrint(e.toString());
    }
  }

  Future<void> fetchProjectSprints() async {
    fetchProjectSprintsState.value = PageState.loading();

    try {
      projectSprints = await SprintService.fetchSprints(projectId!);

      fetchProjectSprintsState.value = PageState.none();
    } on DioException catch (e) {
      debugPrint(e.toString());
      fetchProjectSprintsState.value =
          PageState.error('Erro ao buscar sprints!');
    } catch (e) {
      debugPrint(e.toString());
      fetchProjectSprintsState.value =
          PageState.error('Erro ao buscar sprints!');
    }
  }
}
