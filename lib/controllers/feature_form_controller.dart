import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scrumflow/models/feature.dart';
import 'package:scrumflow/services/feature_service.dart';
import 'package:scrumflow/utils/utils.dart';
import 'package:scrumflow/widgets/prompts.dart';

class FeatureFormViewController extends GetxController {
  final GlobalKey<FormState> featureFormKey = GlobalKey<FormState>();

  final Rx<PageState> pageState = PageState.none().obs;
  final RxString name = ''.obs;
  final RxString description = ''.obs;
  final RxInt projectId = 0.obs;

  void onFeatureNameChanged(String value) {
    name.value = value;
  }

  void onFeatureDescriptionChanged(String value) {
    description.value = value;
  }

  void onFeatureProjectSelected(int value) {
    projectId.value = value;
  }

  FutureOr<void> newFeature() async {
    if (featureFormKey.currentState!.validate()) {
      pageState.value = PageState.loading();

      try {
        Feature? feature = await FeatureService.newFeature(Feature(
            name: name.value,
            description: description.value,
            projectId: projectId.value));

        Get.back(result: feature);

        Prompts.successSnackBar(
            'Sucesso', 'Funcionalidade criada com sucesso!');
      } on DioException catch (e) {
        Prompts.errorSnackBar('Erro', e.message);
        pageState.value = PageState.error(e.message);

        debugPrint(e.toString());
      }
    }
  }

  Future<void> cancel() async {
    name.value = '';
    description.value = '';
    projectId.value = 0;
    Get.back();
  }
}
