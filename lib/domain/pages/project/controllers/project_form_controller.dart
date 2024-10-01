import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scrumflow/domain/pages/project/services/services.dart';
import 'package:scrumflow/domain/pages/user/services/services.dart';
import 'package:scrumflow/models/models.dart';
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

  final RxString teamName = ''.obs;
  final RxList<User> users = <User>[].obs;
  final RxList<User> selectedUsers = <User>[].obs;

  final PageController _pageController = PageController();

  void changePage(int index) {
    _pageController.jumpToPage(index);
  }

  void updateName(String value) => name.value = value;

  void updateDescription(String value) => description.value = value;

  void updateStartDate(DateTime? value) => startDate.value = value;

  void updateEndDate(DateTime? value) => endDate.value = value;

  void updateSelectedUsers(List<User> value) => selectedUsers.value = value;

  @override
  onInit() {
    super.onInit();

    if (project != null) {
      name.value = project?.name ?? '';
      description.value = project?.description ?? '';
      startDate.value = project?.startDate;
      endDate.value = project?.endDate;
    }

    pageState.listen((value) {
      Prompts.showSnackBar(value);

      if (value.status == PageStatus.success) Get.back();
    });

    initialEvent();
  }

  FutureOr<void> initialEvent() async {
    initialState.value = PageState.loading();
    try {
      users.value = await UserService.getUsers();

      initialState.value = PageState.none();
    } on DioException catch (e) {
      initialState.value = PageState.error(e.message);
    } catch (e) {
      initialState.value = PageState.error(e.toString());
    }
  }

  FutureOr<void> save() async {
    if (projectFormKey.currentState!.validate()) {
      if (validateDates()) {
        pageState.value = PageState.loading();

        try {
          if (project != null) {
            Project updatedProject = await ProjectService.updateProject(
              Project(
                name: name.value,
                description: description.value,
                startDate: startDate.value,
                endDate: endDate.value,
              ),
            );

            pageState.value = PageState.success(info: 'Projeto atualizado!!', data: updatedProject);
          } else {
            Project newProject = await ProjectService.newProject(
              Project(
                name: name.value,
                description: description.value,
                startDate: startDate.value,
                endDate: endDate.value,
              ),
            );

            pageState.value = PageState.success(info: 'Projeto criado!!', data: newProject);
          }
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
