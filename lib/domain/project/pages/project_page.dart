import 'package:flutter/material.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:scrumflow/controllers/project_form_controller.dart';
import 'package:scrumflow/utils/utils.dart';
import 'package:scrumflow/widgets/base_button.dart';
import 'package:scrumflow/widgets/base_date_picker.dart';
import 'package:scrumflow/widgets/base_label.dart';
import 'package:scrumflow/widgets/base_text_field.dart';
import 'package:scrumflow/widgets/page_builder.dart';

class ProjectPage extends StatelessWidget {
  const ProjectPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const BaseLabel(
            text: 'Projetos', fontSize: fsVeryBig, fontWeight: fwMedium),
      ),
      body: BaseButton(
          title: 'Criar novo projeto',
          onPressed: () => Routes.goTo(context, CreateProjectPage())),
    );
  }
}

class CreateProjectPage extends StatelessWidget {
  const CreateProjectPage({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put<CreateProjectController>(CreateProjectController());

    return Scaffold(
        appBar: AppBar(
          title: const Text("Cadastro de novo Projeto"),
        ),
        body: PageBuilder(
            minimumInsets: EdgeInsets.zero,
            webPage: _WebPage(),
            mobilePage: _MobilePage()));
  }

  Widget _WebPage() {
    return ProjectFormView();
  }

  Widget _MobilePage() {
    return ProjectFormView();
  }
}

class CreateProjectController extends GetxController {
  final PageController _pageController = PageController();

  void changePage(int index) {
    _pageController.jumpToPage(index);
  }
}

class ProjectFormView extends StatelessWidget {
  const ProjectFormView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put<ProjectFormViewController>(ProjectFormViewController());

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [_ProjectForm()],
    );
  }
}

class _ProjectForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ProjectFormViewController projectFormViewController =
        Get.find<ProjectFormViewController>();

    return SizedBox(
      width: ScreenHelper.screenWidth(),
      height: ScreenHelper.screenHeight(),
      child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
          child: Form(
            key: projectFormViewController.projectFormKey,
            autovalidateMode: AutovalidateMode.disabled,
            child: ListView(
              children: [
                BaseTextField(
                  hint: "Nome do projeto",
                  validator: FormBuilderValidators.required(
                      errorText: 'Campo obrigatório'),
                  onChanged: projectFormViewController.onProjectNameChanged,
                ),
                BaseTextField(
                  hint: "Descrição do projeto",
                  validator: FormBuilderValidators.required(
                      errorText: 'Campo obrigatório'),
                  onChanged:
                      projectFormViewController.onProjectDescriptionChanged,
                ),
                BaseDatePicker(
                  hint: 'Data de início do projeto',
                  initialValue: projectFormViewController.startDate.value,
                  validator: FormBuilderValidators.required(
                      errorText: 'Campo obrigatório'),
                  onChanged: (value) => projectFormViewController
                      .onProjectStartDateChanged(value),
                ),
                BaseDatePicker(
                  hint: 'Data de fim do projeto',
                  initialValue: projectFormViewController.endDate.value,
                  validator: FormBuilderValidators.required(
                      errorText: 'Campo obrigatório'),
                  onChanged: (value) =>
                      projectFormViewController.onProjectEndDateChanged(value),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    BaseButton(
                      title: 'Cancelar',
                      isLoading:
                          projectFormViewController.pageState.value.status ==
                              PageStatus.loading,
                      onPressed: () async =>
                          await projectFormViewController.cancel(),
                    ),
                    25.toSizedBoxW(),
                    BaseButton(
                      title: 'Salvar',
                      isLoading:
                          projectFormViewController.pageState.value.status ==
                              PageStatus.loading,
                      onPressed: () async =>
                          await projectFormViewController.newProject(),
                    ),
                  ],
                )
              ],
            ),
          )),
    );
  }
}
