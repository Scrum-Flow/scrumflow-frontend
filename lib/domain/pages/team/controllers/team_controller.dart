import 'dart:async';

import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:scrumflow/domain/pages/team/services/services.dart';
import 'package:scrumflow/models/models.dart';
import 'package:scrumflow/utils/utils.dart';
import 'package:scrumflow/widgets/widgets.dart';

class TeamController extends GetxController {
  List<Team>? _teams;

  List<Team> values = [];
  RxString filterValue = ''.obs;

  Rx<PageState> teamListState = PageState.none().obs;
  Rx<PageState> teamState = PageState.none().obs;
  Rx<PageState> deleteState = PageState.none().obs;

  @override
  void onInit() async {
    await fetchTeams();

    teamState.listen((state) async {
      Prompts.showSnackBar(state);

      if (state.status == PageStatus.success) {
        var result =
            await Get.toNamed(Routes.teamFormPage, arguments: state.data);
        if (result != null) await fetchTeams();
      }
    });

    deleteState.listen((state) async {
      Prompts.showSnackBar(state);
    });

    super.onInit();
  }

  FutureOr<void> fetchTeams() async {
    teamListState.value = PageState.loading();

    _teams = await TeamService.getAll();

    values = _teams ?? [];

    teamListState.value = PageState.none();
  }

  void filterTeams() {
    teamListState.value = PageState.loading();

    values = (_teams ?? [])
        .where((element) => (element.name?.toLowerCase() ?? '')
            .isCaseInsensitiveContains(filterValue.value.toLowerCase()))
        .toList();

    teamListState.value = PageState.none();
  }

  void filterSubmitted(String filter) {
    filterValue.value = filter;
    filterTeams();
  }

  FutureOr<void> fetchTeamData(Team team) async {
    teamState.value = PageState.loading('Buscando dados do Time');

    try {
      Team fetchedTeam = await TeamService.get(team.id);

      teamState.value = PageState.success(data: fetchedTeam);
    } on DioException catch (e) {
      teamState.value = PageState.error('Erro ao buscar Time');
    }
  }

  FutureOr<void> deleteTeam(Team team) async {
    deleteState.value = PageState.loading('Deletando projeto');

    try {
      await TeamService.delete(team.id);

      await fetchTeams();

      deleteState.value = PageState.success(info: 'Time deletado com sucesso');
    } on DioException catch (e) {
      deleteState.value = PageState.error('Erro ao deletar o time');
    }
  }
}
