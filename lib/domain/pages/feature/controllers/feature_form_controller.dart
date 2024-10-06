import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scrumflow/domain/pages/feature/services/services.dart';
import 'package:scrumflow/models/models.dart';
import 'package:scrumflow/utils/utils.dart';
import 'package:scrumflow/widgets/widgets.dart';

class FeatureFormController extends GetxController {
  FeatureFormController(this.feature, {this.projectId});

  final GlobalKey<FormState> featureFormKey = GlobalKey<FormState>();

  final Feature? feature;

  final Rx<PageState> pageState = PageState.none().obs;
  final Rx<PageState> initialState = PageState.none().obs;
  final RxString name = ''.obs;
  final RxString description = ''.obs;
  late final int? projectId;

  void updateName(String value) => name.value = value;

  void updateDescription(String value) => description.value = value;

  @override
  onInit() {
    super.onInit();

    if (feature != null) {
      name.value = feature?.name ?? '';
      description.value = feature?.description ?? '';
      projectId = feature?.projectId;
    }

    pageState.listen((value) {
      Prompts.showSnackBar(value);

      if (value.status == PageStatus.success) Get.back();
    });
  }

  FutureOr<void> save() async {
    if (featureFormKey.currentState!.validate()) {
      pageState.value = PageState.loading();

      try {
        if (feature != null) {
          Feature updatedFeature = await FeatureService.updateFeature(
            Feature(
                name: name.value,
                description: description.value,
                projectId: projectId),
          );

          pageState.value = PageState.success(
              info: 'Funcionalidade atualizada!!', data: updatedFeature);
        } else {
          Feature newFeature = await FeatureService.newFeature(
            Feature(
                name: name.value,
                description: description.value,
                projectId: projectId),
          );

          pageState.value = PageState.success(
              info: 'Funcionalidade criada!!', data: newFeature);
        }
      } on DioException catch (e) {
        pageState.value = PageState.error(e.message);

        debugPrint(e.toString());
      }
    }
  }
}
