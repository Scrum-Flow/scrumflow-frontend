import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scrumflow/domain/basics/basics.dart';
import 'package:scrumflow/domain/pages/team/controllers/controllers.dart';
import 'package:scrumflow/models/models.dart';
import 'package:scrumflow/utils/utils.dart';
import 'package:scrumflow/widgets/widgets.dart';

class TeamPage extends StatelessWidget {
  const TeamPage({super.key});

  @override
  Widget build(BuildContext context) {
    TeamController controller = Get.put(TeamController());

    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        child: Column(
          children: [
            SearchField(
              onFieldSubmitted: controller.filterSubmitted,
              onClear: controller.filterSubmitted,
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.white,
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      child: Row(
                        children: [
                          const Expanded(
                            child: BaseLabel(
                              text: 'Times',
                              fontSize: fsVeryBig,
                              fontWeight: fwMedium,
                            ),
                          ),
                          PageBuilder(
                            minimumInsets: EdgeInsets.zero,
                            webPage: SizedBox(
                              width: 200,
                              child: BaseButton(
                                title: 'Criar Time',
                                onPressed: () async {
                                  var result = await Get.toNamed(Routes.teamFormPage);

                                  if (result != null) {
                                    controller.fetchTeams();
                                  }
                                },
                              ),
                            ),
                            mobilePage: IconButton(
                              tooltip: 'Criar Time',
                              onPressed: () async {
                                var result = await Get.toNamed(Routes.teamFormPage);

                                if (result != null) {
                                  controller.fetchTeams();
                                }
                              },
                              icon: Icon(Icons.person_add_alt_1_sharp),
                            ),
                          ),
                        ],
                      ),
                    ),
                    _TeamList(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TeamList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    TeamController controller = Get.find<TeamController>();

    return Obx(
      () => Expanded(
        child: BaseGrid(
          maxCrossAxisExtent: 250,
          mainAxisExtent: 100,
          onRefresh: () => controller.fetchTeams(),
          shrinkWrap: true,
          padding: const EdgeInsets.symmetric(horizontal: 24).add(const EdgeInsets.only(bottom: 12)),
          pageState: controller.teamListState.value,
          items: controller.values,
          itemBuilder: (context, item) => UserCard(item),
        ),
      ),
    );
  }
}

class UserCard extends StatelessWidget {
  const UserCard(this.team, {super.key});

  final Team team;

  @override
  Widget build(BuildContext context) {
    TeamController controller = Get.find<TeamController>();

    return Card(
      shadowColor: Colors.black45,
      elevation: 2,
      color: Colors.grey[250],
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        alignment: Alignment.center,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(color: Color((Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(0.2), borderRadius: BorderRadius.circular(20)),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: BaseLabel(
                text: team.toString(),
                color: Colors.black,
                fontWeight: fwBold,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: const Icon(Icons.mode_edit_rounded),
                  tooltip: 'Editar',
                  onPressed: () => controller.fetchTeamData(team),
                ),
                const SizedBox(width: 4),
                IconButton(
                  icon: const Icon(
                    Icons.delete_outline_rounded,
                  ),
                  tooltip: 'Excluir',
                  onPressed: () => showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: BaseLabel(text: 'Realmente deseja excluir este time?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: BaseLabel(text: 'Cancelar'),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            controller.deleteTeam(team);
                          },
                          child: BaseLabel(text: 'Confirmar'),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
