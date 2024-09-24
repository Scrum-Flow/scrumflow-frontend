/*
import 'package:flutter/material.dart';
import 'package:scrumflow/models/sprint.dart';
import 'package:scrumflow/utils/enums/enum_view_mode.dart';
import 'package:scrumflow/utils/utils.dart';
import 'package:scrumflow/widgets/base_button.dart';
import 'package:scrumflow/widgets/base_label.dart';

class SprintPage extends StatelessWidget {
  const SprintPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const BaseLabel(
              text: 'Sprint', fontSize: fsVeryBig, fontWeight: fwMedium),
        ),
        body: Column(
          children: [
            BaseButton(
                title: 'Criar nova sprint',
                onPressed: () => Routes.goTo(context, CreateSprintPage())),
            20.toSizedBoxH(),
            BaseButton(
                title: 'Editar sprint',
                onPressed: () => Routes.goTo(
                    context,
                    CreateSprintPage(
                        sprint: Sprint.fake(), viewMode: ViewMode.edit))),
            20.toSizedBoxH(),
            BaseButton(
                title: 'Visualizar sprint',
                onPressed: () => Routes.goTo(
                    context,
                    CreateSprintPage(
                        sprint: Sprint.fake(), viewMode: ViewMode.view))),
          ],
        ));
  }
}

class CreateSprintPage extends StatelessWidget {}
*/
