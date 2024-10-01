import 'package:flutter/material.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:scrumflow/domain/basics/basics.dart';
import 'package:scrumflow/domain/pages/project/projects.dart';
import 'package:scrumflow/models/project.dart';
import 'package:scrumflow/utils/utils.dart';
import 'package:scrumflow/widgets/widgets.dart';

class ProjectFormPage extends StatelessWidget {
  const ProjectFormPage({this.project, super.key});

  final Project? project;

  @override
  Widget build(BuildContext context) {
    Get.put<ProjectFormController>(ProjectFormController(project)..initialEvent());

    return Scaffold(
      appBar: AppBar(
        title: const Text("Cadastro de novo Projeto"),
      ),
      body: const PageBuilder(
        minimumInsets: EdgeInsets.zero,
        webPage: ProjectFormView(),
        mobilePage: ProjectFormView(),
      ),
    );
  }
}

class ProjectFormView extends StatelessWidget {
  const ProjectFormView({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [_ProjectForm()],
    );
  }
}

class _ProjectForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ProjectFormController projectFormViewController = Get.find<ProjectFormController>();

    return SizedBox(
      width: Helper.screenWidth(),
      height: Helper.screenHeight(),
      child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
          child: Form(
            key: projectFormViewController.projectFormKey,
            autovalidateMode: AutovalidateMode.disabled,
            child: ListView(
              children: [
                BaseTextField(
                  hint: "Nome do projeto",
                  initialValue: projectFormViewController.project?.name,
                  validator: FormBuilderValidators.required(errorText: 'Campo obrigatório'),
                  onChanged: projectFormViewController.updateName,
                ),
                BaseTextField(
                  hint: "Descrição do projeto",
                  initialValue: projectFormViewController.project?.description,
                  validator: FormBuilderValidators.required(errorText: 'Campo obrigatório'),
                  onChanged: projectFormViewController.updateDescription,
                ),
                BaseDatePicker(
                  hint: 'Data de início do projeto',
                  initialValue: projectFormViewController.project?.startDate,
                  validator: FormBuilderValidators.required(errorText: 'Campo obrigatório'),
                  onChanged: projectFormViewController.updateStartDate,
                ),
                BaseDatePicker(
                  hint: 'Data de fim do projeto',
                  initialValue: projectFormViewController.project?.endDate,
                  validator: FormBuilderValidators.required(errorText: 'Campo obrigatório'),
                  onChanged: projectFormViewController.updateEndDate,
                ),
                BaseTextField(
                  hint: "Nome do Time",
                  initialValue: projectFormViewController.project?.description,
                  validator: FormBuilderValidators.required(errorText: 'Campo obrigatório'),
                  onChanged: projectFormViewController.updateDescription,
                ),
                Obx(
                  () => LoadingWidget(
                    isLoading: projectFormViewController.initialState.value.status == PageStatus.loading,
                    child: MultiSelectDialogField(
                      onConfirm: projectFormViewController.updateSelectedUsers,
                      searchable: true,
                      searchIcon: Icon(Icons.search_outlined),
                      listType: MultiSelectListType.CHIP,
                      title: const Text('Selecione os membros do projeto'),
                      searchHint: 'Nome do usuário',
                      barrierColor: Colors.transparent,
                      items: projectFormViewController.users.map((user) => MultiSelectItem(user, user.name ?? '')).toList(),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.black12,
                      ),
                    ),
                  ),
                ),
                25.toSizedBoxH(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: BaseButton(
                        title: 'Cancelar',
                        isLoading: projectFormViewController.pageState.value.status == PageStatus.loading,
                        onPressed: () => Get.back(),
                      ),
                    ),
                    25.toSizedBoxW(),
                    Expanded(
                      child: BaseButton(
                        title: 'Salvar',
                        isLoading: projectFormViewController.pageState.value.status == PageStatus.loading,
                        onPressed: () async => await projectFormViewController.save(),
                      ),
                    ),
                  ],
                )
              ],
            ),
          )),
    );
  }
}
