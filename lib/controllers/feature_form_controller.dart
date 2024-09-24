import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scrumflow/models/feature.dart';
import 'package:scrumflow/services/feature_service.dart';
import 'package:scrumflow/utils/enums/enum_view_mode.dart';
import 'package:scrumflow/utils/utils.dart';
import 'package:scrumflow/widgets/dialog_confirm_exit.dart';
import 'package:scrumflow/widgets/prompts.dart';

class FeatureFormViewController extends GetxController {
  final GlobalKey<FormState> featureFormKey = GlobalKey<FormState>();

  final Rx<PageState> pageState = PageState.none().obs;
  final RxString name = ''.obs;
  final RxString description = ''.obs;
  final RxInt projectId = 0.obs;

  late ViewMode viewMode = ViewMode.create;
  late int? id;

  FeatureFormViewController(ViewMode? viewMode, Feature? feature) {
    this.viewMode = viewMode ?? ViewMode.create;
    if (feature != null) {
      id = feature.id;
      name.value = feature.name!;
      description.value = feature.description!;
      projectId.value = feature.projectId!;
    }
  }

  void onFeatureNameChanged(String value) {
    name.value = value;
  }

  void onFeatureDescriptionChanged(String value) {
    description.value = value;
  }

  void onFeatureProjectSelected(int value) {
    projectId.value = value;
  }

  FutureOr<void> saveFeature() async {
    if (featureFormKey.currentState!.validate()) {
      pageState.value = PageState.loading();

      try {
        if (viewMode == ViewMode.create) {
          Feature? feature = await FeatureService.newFeature(Feature(
              name: name.value,
              description: description.value,
              projectId: projectId.value));

          Get.back(result: feature);

          Prompts.successSnackBar(
              'Sucesso', 'Funcionalidade criada com sucesso!');
        }
        if (viewMode == ViewMode.edit) {
          Feature? feature = await FeatureService.updateFeature(Feature(
              id: id,
              name: name.value,
              description: description.value,
              projectId: projectId.value));

          Get.back(result: feature);

          Prompts.successSnackBar(
              'Sucesso', 'Funcionalidade editada com sucesso!');
        }
      } on DioException catch (e) {
        Prompts.errorSnackBar('Erro', e.message);
        pageState.value = PageState.error(e.message);

        debugPrint(e.toString());
      }
    }
  }

  void confirmExit(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return DialogConfirmExit(onConfirm: exit);
        });
  }

  void exit() {
    Get.delete<FeatureFormViewController>();
    Get.back();
  }
}
