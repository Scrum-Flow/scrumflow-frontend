import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scrumflow/models/models.dart';
import 'package:scrumflow/models/project.dart';
import 'package:scrumflow/services/services.dart';
import 'package:scrumflow/utils/utils.dart';
import 'package:scrumflow/widgets/prompts.dart';

class ProjectFormController extends GetxController {
  ProjectFormController(this.project);

  final Project? project;

  final GlobalKey<FormState> projectFormKey = GlobalKey<FormState>();

  final Rx<PageState> pageState = PageState.none().obs;
  final Rx<PageState> initialState = PageState.none().obs;
  final RxString name = ''.obs;
  final RxString description = ''.obs;
  final Rx<DateTime?> startDate = Rx<DateTime?>(null);
  final Rx<DateTime?> endDate = Rx<DateTime?>(null);

  final RxList<User> users = <User>[].obs;

  final PageController _pageController = PageController();

  void changePage(int index) {
    _pageController.jumpToPage(index);
  }

  void updateName(String value) => name.value = value;

  void updateDescription(String value) => description.value = value;

  void updateStartDate(DateTime? value) => startDate.value = value;

  void updateEndDate(DateTime? value) => endDate.value = value;

  FutureOr<void> initialEvent() async {
    initialState.value = PageState.loading();
    try {
      await Future.delayed(Duration(seconds: 5));

      users.value = await UserService.getUsers();
    } on DioException catch (e) {
      initialState.value = PageState.error(e.message);
    } catch (e) {
      initialState.value = PageState.error(e.toString());
    }
  }

  FutureOr<void> newProject() async {
    if (projectFormKey.currentState!.validate()) {
      if (validateDates()) {
        pageState.value = PageState.loading();

        try {
          Project project = await ProjectService.newProject(
            Project(
              name: name.value,
              description: description.value,
              startDate: startDate.value,
              endDate: endDate.value,
            ),
          );

          pageState.value = PageState.success(info: 'Projeto criado!!', data: project);
        } on DioException catch (e) {
          pageState.value = PageState.error(e.message);

          debugPrint(e.toString());
        }
      }
    }
  }

  Future<void> cancel() async {
    ;
  }

  bool validateDates() {
    if (startDate.value == null || endDate.value == null) {
      Prompts.errorSnackBar('Erro', "Data inicial e/ou final estão vazias");
      return false;
    }

    if (startDate.value!.isAfter(endDate.value!)) {
      Prompts.errorSnackBar('Erro', "Data inicial deve ser anterior à data final");
      return false;
    }

    return true;
  }
}
