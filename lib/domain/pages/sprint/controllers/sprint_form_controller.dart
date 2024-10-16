import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scrumflow/models/models.dart';
import 'package:scrumflow/utils/utils.dart';
import 'package:scrumflow/widgets/widgets.dart';

class SprintFormController extends GetxController {
  SprintFormController({this.sprint, required this.projectId});

  final Sprint? sprint;
  final int projectId;

  final GlobalKey<FormState> sprintFormKey = GlobalKey<FormState>();

  final Rx<PageState> pageState = PageState.none().obs;
  final Rx<PageState> initialState = PageState.none().obs;

  late final int? id;
  final RxString name = ''.obs;
  final RxString description = ''.obs;
  final Rx<DateTime?> startDate = Rx<DateTime?>(null);
  final Rx<DateTime?> endDate = Rx<DateTime?>(null);

  void updateName(String value) => name.value = value;

  void updateDescription(String value) => description.value = value;

  void updateStartDate(DateTime? value) => startDate.value = value;

  void updateEndDate(DateTime? value) => endDate.value = value;

  @override
  void onInit() {
    super.onInit();

    if (sprint != null) {
      id = sprint?.id;
      name.value = sprint?.name ?? '';
      description.value = sprint?.description ?? '';
      startDate.value = sprint?.startDate;
      endDate.value = sprint?.endDate;
    }

    pageState.listen((value) {
      Prompts.showSnackBar(value);

      if (value.status == PageStatus.success) Get.back();
    });
  }

  FutureOr<void> save() async {
    if (sprintFormKey.currentState!.validate()) {
      if (validateDates()) {
        pageState.value = PageState.loading();

        try {
          if (sprint != null) {
            Sprint updatedSprint = await SprintService.updateSprint(
              Sprint(
                id: id,
                name: name.value,
                description: description.value,
                startDate: startDate.value,
                endDate: endDate.value,
              ),
            );

            pageState.value = PageState.success(
                info: 'Sprint atualizada!!', data: updatedSprint);
          } else {
            Sprint newSprint = await SprintService.newSprint(
              Sprint(
                name: name.value,
                description: description.value,
                startDate: startDate.value,
                endDate: endDate.value,
                projectId: projectId,
              ),
            );

            pageState.value =
                PageState.success(info: 'Sprint criada!!', data: newSprint);
          }
        } on DioException catch (e) {
          pageState.value = PageState.error(e.message);

          debugPrint(e.toString());
        }
      }
    }
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

class SprintService {
  static newSprint(Sprint sprint) {}

  static updateSprint(Sprint sprint) {}
}
