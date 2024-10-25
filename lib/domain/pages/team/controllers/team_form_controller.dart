import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:scrumflow/domain/pages/project/services/services.dart';
import 'package:scrumflow/domain/pages/team/services/services.dart';
import 'package:scrumflow/domain/pages/user/services/services.dart';
import 'package:scrumflow/models/models.dart';
import 'package:scrumflow/utils/utils.dart';

class TeamFormController extends GetxController {
  TeamFormController(this.team);

  final Team? team;

  List<Project> selectorProjects = [];
  List<User> selectorUsers = [];

  RxString teamName = ''.obs;
  RxList<User> users = RxList();
  Rx<Project?> project = Rxn();

  Rx<PageState> pageState = PageState.none().obs;
  Rx<PageState> formState = PageState.none().obs;

  final GlobalKey<FormState> teamFormKey = GlobalKey();

  @override
  void onInit() async {
    pageState.value = PageState.loading();

    if (team != null) {
      teamName.value = team?.name ?? '';
      users.value = team?.users ?? [];
      project.value = team?.project;
    }

    selectorUsers = await UserService.getUsers();
    selectorProjects = await ProjectService.fetchProjects();

    selectorProjects.removeWhere((element) => element.active == false);

    pageState.value = PageState.none();

    formState.listen((value) {
      if (value.status == PageStatus.success) Get.back(result: value.data);
    });

    super.onInit();
  }

  void updateName(String name) => teamName.value = name;

  void updateProject(Project? value) => project.value = value;

  void updateUsers(List<User> values) => users.value = values;

  FutureOr<void> save() async {
    if (teamFormKey.currentState!.validate()) {
      formState.value = PageState.loading();

      try {
        if (team != null) {
          Team updatedTeam = await TeamService.update(team!.copyWith(
            project: project.value,
            users: users,
            name: teamName.value,
          ));

          formState.value = PageState.success(info: 'Time atualizado!!', data: updatedTeam);
        } else {
          Team addTeam = await TeamService.add(Team(
            name: teamName.value,
            users: users,
            project: project.value,
          ));

          formState.value = PageState.success(info: 'Time criado!!', data: addTeam);
        }
      } on DioException catch (e) {
        formState.value = PageState.error(e.message);

        debugPrint(e.toString());
      }
    }
  }
}
