import 'package:flutter/material.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:scrumflow/domain/basics/basics.dart';
import 'package:scrumflow/domain/pages/team/controllers/team_form_controller.dart';
import 'package:scrumflow/models/models.dart';
import 'package:scrumflow/utils/utils.dart';
import 'package:scrumflow/widgets/page_builder.dart';
import 'package:scrumflow/widgets/widgets.dart';

class TeamFormPage extends StatelessWidget {
  const TeamFormPage({this.team, super.key});

  final Team? team;

  @override
  Widget build(BuildContext context) {
    Get.put<TeamFormController>(TeamFormController(team));

    return Scaffold(
      appBar: AppBar(
        title: const Text("Cadastro de novo Time"),
      ),
      body: const PageBuilder(
        minimumInsets: EdgeInsets.zero,
        webPage: TeamFormView(),
        mobilePage: TeamFormView(),
      ),
    );
  }
}

class TeamFormView extends StatelessWidget {
  const TeamFormView({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [_TeamForm()],
    );
  }
}

class _TeamForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    TeamFormController teamFormController = Get.find<TeamFormController>();

    return SizedBox(
      width: Helper.screenWidth(),
      height: Helper.screenHeight(),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        child: Form(
          key: teamFormController.teamFormKey,
          autovalidateMode: AutovalidateMode.disabled,
          child: Obx(
            () => LoadingWidget(
              isLoading: teamFormController.pageState.value.status == PageStatus.loading,
              child: ListView(
                children: [
                  BaseTextField(
                    hint: "Nome do time",
                    initialValue: teamFormController.team?.name,
                    validator: FormBuilderValidators.required(errorText: 'Campo obrigatório'),
                    onChanged: teamFormController.updateName,
                  ),
                  DropdownButtonFormField<Project>(
                      value: teamFormController.team?.project,
                      hint: BaseLabel(text: 'Selecione Projeto'),
                      items: teamFormController.selectorProjects
                          .map((project) => DropdownMenuItem(
                                child: BaseLabel(text: project.toString()),
                                value: project,
                              ))
                          .toList(),
                      onChanged: (project) => teamFormController.updateProject(project)),
                  12.toSizedBoxH(),
                  MultiSelectDialogField<User>(
                    initialValue: teamFormController.team?.users ?? [],
                    buttonText: Text('Selecione os usuários'),
                    title: BaseLabel(text: 'Usuários'),
                    items: teamFormController.selectorUsers.map((e) => MultiSelectItem(e, e.name ?? '')).toList(),
                    onConfirm: (users) => teamFormController.updateUsers(users),
                    chipDisplay: MultiSelectChipDisplay(
                      scroll: true,
                      textStyle: TextStyle(fontSize: fsSmall),
                      scrollBar: HorizontalScrollBar(isAlwaysShown: true),
                    ),
                    listType: MultiSelectListType.CHIP,
                  ),
                  25.toSizedBoxH(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: BaseButton(
                          title: 'Cancelar',
                          isLoading: teamFormController.formState.value.status == PageStatus.loading,
                          onPressed: () => Get.back(),
                        ),
                      ),
                      25.toSizedBoxW(),
                      Expanded(
                        child: BaseButton(
                          title: 'Salvar',
                          isLoading: teamFormController.formState.value.status == PageStatus.loading,
                          onPressed: () async => await teamFormController.save(),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
