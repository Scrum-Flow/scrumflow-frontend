import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scrumflow/models/project.dart';
import 'package:scrumflow/services/project_service.dart';
import 'package:scrumflow/utils/page_state.dart';
import 'package:scrumflow/widgets/prompts.dart';

class ProjectFormViewController extends GetxController {
  final GlobalKey<FormState> projectFormKey = GlobalKey<FormState>();

  final Rx<PageState> pageState = PageState.none().obs;
  final RxString name = ''.obs;
  final RxString description = ''.obs;
  final Rx<DateTime?> startDate = Rx<DateTime?>(null);
  final Rx<DateTime?> endDate = Rx<DateTime?>(null);

  void onProjectNameChanged(String value) {
    name.value = value;
  }

  void onProjectDescriptionChanged(String value) {
    description.value = value;
  }

  void onProjectStartDateChanged(DateTime? value) {
    if (value != null) {
      startDate.value = value;
    }
  }

  void onProjectEndDateChanged(DateTime? value) {
    if (value != null) {
      endDate.value = value;
    }
  }

  FutureOr<void> newProject() async {
    if (projectFormKey.currentState!.validate()) {
      if (validateDates()) {
        pageState.value = PageState.loading();

        try {
          Project? project = await ProjetcService.newProject(Project(
              name: name.value,
              description: description.value,
              startDate: startDate.value,
              endDate: endDate.value,
              active: true));

          Get.back(result: project);

          Prompts.successSnackBar('Sucesso', 'Projeto criado com sucesso!');
        } on DioException catch (e) {
          Prompts.errorSnackBar('Erro', e.message);
          pageState.value = PageState.error(e.message);

          debugPrint(e.toString());
        }
      }
    }
  }

  Future<void> cancel() async {
    Get.back();
  }

  bool validateDates() {
    if (startDate.value == null || endDate.value == null) {
      Prompts.errorSnackBar('Erro', "Data inicial e/ou final estão vazias");
      return false;
    }

    if (startDate.value!.isAfter(endDate.value!)) {
      Prompts.errorSnackBar(
          'Erro', "Data inicial deve ser anterior à data final");
      return false;
    }

    return true;
  }
}
