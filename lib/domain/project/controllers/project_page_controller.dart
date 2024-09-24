import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:scrumflow/domain/project/services/project_service.dart';
import 'package:scrumflow/models/project.dart';
import 'package:scrumflow/utils/utils.dart';

class ProjectPageController extends GetxController {
  List<Project>? _projects;

  List<Project> values = [];
  Rx<PageState> projectListState = PageState.none().obs;
  Rx<PageState> projectState = PageState.none().obs;
  RxString filterValue = ''.obs;

  FutureOr<void> fetchProjects() async {
    projectListState.value = PageState.loading();

    try {
      List<Project> projects = await ProjectService.fetchProjects();

      values = _projects =
          projects.where((element) => element.active == true).toList();
    } on DioException catch (e) {
      debugPrint(e.toString());
      projectListState.value = PageState.error();
    } catch (e) {
      debugPrint(e.toString());
      projectListState.value = PageState.error();
    }

    projectListState.value = PageState.none();
  }

  FutureOr<void> deleteProject(Project project) async {
    projectState.value = PageState.loading('Deletando projeto!');

    try {
      await ProjectService.deleteProject(project.id);

      fetchProjects();

      projectState.value = PageState.success(info: 'Project foi excluído!!');
    } on DioException catch (e) {
      debugPrint(e.toString());
      projectState.value = PageState.error('Erro ao deletar projeto!');
    } catch (e) {
      debugPrint(e.toString());
      projectState.value = PageState.error('Erro ao deletar projeto!');
    }

    projectState.value = PageState.none();
  }

  void filterProjects() {
    projectListState.value = PageState.loading();

    values = (_projects ?? [])
        .where((element) => (element.name?.camelCase ?? '')
            .isCaseInsensitiveContains(filterValue.value.camelCase ?? ''))
        .toList();

    projectListState.value = PageState.none();
  }

  void filterSubmitted(String filter) {
    filterValue.value = filter;
    filterProjects();
  }
}
