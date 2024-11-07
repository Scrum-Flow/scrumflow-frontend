import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:scrumflow/domain/pages/sprint/services/services.dart';
import 'package:scrumflow/models/models.dart';
import 'package:scrumflow/utils/page_state.dart';

import '../../feature/services/services.dart';

class BacklogPageController extends GetxController {
  final int projectId;

  BacklogPageController({required this.projectId});

  Rx<PageState> sprintsListState = PageState.none().obs;
  List<Sprint> sprintValues = [];

  Rx<PageState> featuresListState = PageState.none().obs;
  List<Feature> featureValues = [];

  Map<Sprint, List<Feature>> map = {};

  List<Feature> featuresWithoutSprint = [];
  Rx<PageState> featuresWithoutSprintState = PageState.none().obs;

  List<Feature> newFeaturesInSprint = [];
  List<Feature> oldFeaturesInSprint = [];

  Rx<PageState> featureDeleteState = PageState.none().obs;
  Rx<PageState> featureAssociateState = PageState.none().obs;
  Rx<PageState> sprintDeleteState = PageState.none().obs;

  @override
  Future<void> onInit() async {
    clearVariables();

    await fetchFeaturesWithoutSprint();

    await fetchSprints();

    if (sprintValues.isNotEmpty) {
      await fetchFeatures();
    }

    super.onInit();
  }

  Future<void> fetchSprints() async {
    sprintsListState.value = PageState.loading();

    try {
      List<Sprint> sprints = await SprintService.fetchSprints(projectId);

      sprintValues = sprints;

      sprintsListState.value = PageState.none();
    } on DioException catch (e) {
      debugPrint(e.toString());
      sprintsListState.value = PageState.error("Erro ao obter sprints (DIO)");
    } catch (e) {
      debugPrint(e.toString());
      sprintsListState.value = PageState.error("Erro ao obter sprints");
    }
  }

  Future<void> fetchFeatures() async {
    featuresListState.value = PageState.loading();

    try {
      for (Sprint sprint in sprintValues) {
        featureValues = [];

        featureValues = await FeatureService.fetchFeatures(projectId);

        map[sprint] = featureValues;
      }

      featuresListState.value = PageState.none();
    } on DioException catch (e) {
      debugPrint(e.toString());
      featuresListState.value =
          PageState.error("Erro ao obter funcionalidades das sprints (DIO)");
    } catch (e) {
      debugPrint(e.toString());
      featuresListState.value =
          PageState.error("Erro ao obter funcionalidades das sprints");
    }
  }

  Future<void> fetchFeaturesWithoutSprint() async {
    featuresWithoutSprintState.value = PageState.loading();

    try {
      List<Feature> features = await FeatureService.fetchFeatures(projectId);

      if (features.isNotEmpty) {
        for (Feature f in features) {
          if (f.sprintsId!.isEmpty) {
            featuresWithoutSprint.add(f);
          }
        }
      }

      featuresWithoutSprintState.value = PageState.none();
    } on DioException catch (e) {
      debugPrint(e.toString());
      featuresWithoutSprintState.value =
          PageState.error("Erro ao obter funcionalidades sem sprints (DIO)");
    } catch (e) {
      debugPrint(e.toString());
      featuresWithoutSprintState.value =
          PageState.error("Erro ao obter funcionalidades sem sprints");
    }
  }

  Future<void> deleteFeature(Feature feature) async {
    featureDeleteState.value = PageState.loading('Deletando Funcionalidade!');

    try {
      await FeatureService.deleteFeature(feature.id);

      featureDeleteState.value =
          PageState.success(info: 'Funcionalidade foi excluída!!');

      await refresh();
    } on DioException catch (e) {
      debugPrint(e.toString());
      featureDeleteState.value =
          PageState.error('Erro ao deletar Funcionalidade!');
    } catch (e) {
      debugPrint(e.toString());
      featureDeleteState.value =
          PageState.error('Erro ao deletar Funcionalidade!');
    }

    featureDeleteState.value = PageState.none();
  }

  Future<void> refresh() async {
    await onInit();
  }

  void clearVariables() {
    map.clear();
    sprintValues.clear();
    featuresWithoutSprint.clear();
  }

  Future<void> deleteSprint(Sprint sprint) async {
    sprintDeleteState.value =
        PageState.loading('Desassociando funcionalidades dessa sprint');

    try {
      ///Tenho que desassociar todas as features dessa sprint antes de excluí-la
      if (featureValues.isNotEmpty) {
        for (Feature feature in featureValues) {
          if (feature.sprintsId!.contains(sprint.id)) {
            await disassociateFeature(
                sprintId: sprint.id!, featureId: feature.id!);
          }
        }
      }

      sprintDeleteState.value = PageState.loading('Deletando sprint');

      await SprintService.deleteSprint(sprint.id);

      sprintDeleteState.value =
          PageState.success(info: 'Sprint foi excluída!!');

      await refresh();
    } on DioException catch (e) {
      debugPrint(e.toString());
      sprintDeleteState.value =
          PageState.error('Erro ao deletar sprintDeleteState!');
    } catch (e) {
      debugPrint(e.toString());
      sprintDeleteState.value =
          PageState.error('Erro ao deletar sprintDeleteState!');
    }

    sprintDeleteState.value = PageState.none();
  }

  Future<void> disassociateFeature(
      {required int sprintId, required int featureId}) async {
    featureDeleteState.value =
        PageState.loading('Desassociando funcionalidade!');

    try {
      await SprintService.disassociateFeatureWithSprint(sprintId, featureId);

      featureDeleteState.value = PageState.success(
          info: 'Funcionalidade foi desassociada da sprint!!');

      await refresh();
    } on DioException catch (e) {
      debugPrint(e.toString());
      featureDeleteState.value =
          PageState.error('Erro ao desassociar Funcionalidade!');
    } catch (e) {
      debugPrint(e.toString());
      featureDeleteState.value =
          PageState.error('Erro ao desassociar Funcionalidade!');
    }

    featureDeleteState.value = PageState.none();
  }

  Future<void> associateFeature(
      {required int sprintId, required List<Feature> features}) async {
    featureAssociateState.value =
        PageState.loading('Associando funcionalidade!');

    try {
      if (features.isNotEmpty) {
        List<Feature> addedFeatures = features
            .where((feature) => !feature.sprintsId!.contains(sprintId))
            .toList();

        List<Feature> removedFeatures = oldFeaturesInSprint
            .where((oldFeature) =>
                !features.any((newFeature) => newFeature.id! == oldFeature.id))
            .toList();

        if (removedFeatures.isNotEmpty) {
          for (Feature f in removedFeatures) {
            await SprintService.disassociateFeatureWithSprint(sprintId, f.id!);
          }
        }

        if (addedFeatures.isNotEmpty) {
          for (Feature f in addedFeatures) {
            await SprintService.associateFeatureWithSprint(sprintId, f.id!);
          }
        }

        featureAssociateState.value =
            PageState.success(info: 'Funcionalidade foi associada na sprint!!');

        await refresh();
      }
    } on DioException catch (e) {
      debugPrint(e.toString());
      featureAssociateState.value =
          PageState.error('Erro ao associar Funcionalidade!');
    } catch (e) {
      debugPrint(e.toString());
      featureAssociateState.value =
          PageState.error('Erro ao associar Funcionalidade!');
    }

    featureAssociateState.value = PageState.none();
  }

  List<Feature> initialFeaturesInSprint(int sprintId) {
    return oldFeaturesInSprint = featureValues
            .where((e) => e.sprintsId?.contains(sprintId) ?? false)
            .toList() ??
        [];
  }
}
