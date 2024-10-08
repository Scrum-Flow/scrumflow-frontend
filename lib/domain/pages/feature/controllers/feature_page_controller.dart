import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scrumflow/domain/pages/feature/services/services.dart';
import 'package:scrumflow/domain/pages/feature/views/views.dart';
import 'package:scrumflow/models/feature.dart';
import 'package:scrumflow/utils/utils.dart';
import 'package:scrumflow/widgets/widgets.dart';

class FeaturePageController extends GetxController {
  FeaturePageController({required this.projectId});

  List<Feature>? _features;
  int projectId;

  List<Feature> values = [];
  Rx<PageState> featureListState = PageState.none().obs;
  Rx<PageState> featureDeleteState = PageState.none().obs;
  Rx<PageState> featureState = PageState.none().obs;
  RxString filterValue = ''.obs;

  @override
  onInit() {
    fetchFeatures();

    featureDeleteState.listen(Prompts.showSnackBar);
    featureState.listen((state) async {
      Prompts.showSnackBar(state);

      if (state.status == PageStatus.success) {
        await Get.to(FeatureFormPage(
          feature: state.data,
          projectId: state.data.projectId,
        ));
      }
    });

    super.onInit();
  }

  FutureOr<void> fetchFeatures() async {
    featureListState.value = PageState.loading();

    try {
      List<Feature> features = await FeatureService.fetchFeatures(projectId);

      for (Feature feature in features) {
        feature.projectId = projectId;
      }

      values = _features = features;
    } on DioException catch (e) {
      debugPrint(e.toString());
      featureListState.value = PageState.error();
    } catch (e) {
      debugPrint(e.toString());
      featureListState.value = PageState.error();
    }

    featureListState.value = PageState.none();
  }

  FutureOr<void> deleteFeature(Feature feature) async {
    featureDeleteState.value = PageState.loading('Deletando Funcionalidade!');

    try {
      await FeatureService.deleteFeature(feature.id);

      await fetchFeatures();

      featureDeleteState.value =
          PageState.success(info: 'Funcionalidade foi excluída!!');
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

  FutureOr<void> fetchFeatureData(Feature feature) async {
    featureState.value = PageState.loading('Carregando projeto!');

    try {
      //Não rpeciso fazer o fetch. Já é passado o featre
      // Feature featureData = await FeatureService.fetchFeature(feature.id);

      featureState.value = PageState.success(data: feature);
    } on DioException catch (e) {
      debugPrint(e.toString());
      featureState.value = PageState.error('Erro ao carregar projeto!');
    } catch (e) {
      debugPrint(e.toString());
      featureState.value = PageState.error('Erro ao carregar projeto!');
    }
  }

  void filterFeatures() {
    featureListState.value = PageState.loading();

    values = (_features ?? [])
        .where((element) => (element.name?.camelCase ?? '')
            .isCaseInsensitiveContains(filterValue.value.camelCase ?? ''))
        .toList();

    featureListState.value = PageState.none();
  }

  void filterSubmitted(String filter) {
    filterValue.value = filter;
    filterFeatures();
  }
}
