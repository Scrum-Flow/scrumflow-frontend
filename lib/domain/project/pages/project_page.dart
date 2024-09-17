import 'dart:math';

import 'package:flutter/material.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:scrumflow/controllers/project_form_controller.dart';
import 'package:scrumflow/domain/project/controllers/project_page_controller.dart';
import 'package:scrumflow/utils/utils.dart';
import 'package:scrumflow/widgets/base_button.dart';
import 'package:scrumflow/widgets/base_date_picker.dart';
import 'package:scrumflow/widgets/base_label.dart';
import 'package:scrumflow/widgets/base_text_field.dart';
import 'package:scrumflow/widgets/page_builder.dart';
import 'package:scrumflow/widgets/search_field.dart';

class ProjectPage extends StatelessWidget {
  const ProjectPage({super.key});

  @override
  Widget build(BuildContext context) {
    ProjectPageController controller =
        Get.put<ProjectPageController>(ProjectPageController());

    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        child: Column(
          children: [
            Expanded(
              flex: 1,
              child: Row(
                children: [
                  Expanded(
                    flex: 4,
                    child: SearchField(
                      onFieldSubmitted: controller.filterProjects,
                      onClear: controller.filterProjects,
                    ),
                  ),
                  Expanded(flex: 6, child: Container()),
                ],
              ),
            ),
            Expanded(
              flex: 9,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.white,
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 12),
                      child: Row(
                        children: [
                          const Expanded(
                            flex: 8,
                            child: BaseLabel(
                              text: 'Projetos',
                              fontSize: fsVeryBig,
                              fontWeight: fwMedium,
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: BaseButton(
                              title: 'Criar Projeto',
                              onPressed: () => Routes.goTo(
                                  context, const CreateProjectPage()),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: GetBuilder<ProjectPageController>(
                        id: 'projects',
                        builder: (controller) => GridView.builder(
                          shrinkWrap: true,
                          padding: const EdgeInsets.symmetric(horizontal: 24)
                              .add(const EdgeInsets.only(bottom: 12)),
                          itemCount: controller.values?.length ?? 0,
                          gridDelegate:
                              const SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: 350,
                            childAspectRatio: 1.5,
                            crossAxisSpacing: 24,
                            mainAxisSpacing: 24,
                          ),
                          itemBuilder: (context, index) => Card(
                            shadowColor: Colors.black45,
                            elevation: 2,
                            color: Colors.grey[250],
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 8),
                              alignment: Alignment.center,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                        color: Color((Random().nextDouble() *
                                                    0xFFFFFF)
                                                .toInt())
                                            .withOpacity(0.2),
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 8),
                                    child: BaseLabel(
                                      text: controller.values?[index] ?? '',
                                      color: Colors.black,
                                      fontWeight: fwBold,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  BaseLabel(
                                    text:
                                        'Descrição do projeto $index Descrição do projeto $index projeto Descrição do projeto $index projeto Descrição do projeto $index projeto Descrição do projeto $index projeto',
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    color: Colors.black,
                                  ),
                                  const SizedBox(height: 8),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      const BaseLabel(text: '50%'),
                                      const SizedBox(height: 4),
                                      LinearProgressIndicator(
                                        borderRadius: BorderRadius.circular(4),
                                        minHeight: 8,
                                        value: 0.5,
                                        color: Colors.blue[300],
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      IconButton(
                                        icon: const Icon(
                                          Icons.mode_edit_rounded,
                                        ),
                                        onPressed: () {},
                                      ),
                                      const SizedBox(width: 4),
                                      IconButton(
                                        icon: const Icon(
                                          Icons.delete_outline_rounded,
                                        ),
                                        onPressed: () {},
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
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

class CreateProjectPage extends StatelessWidget {
  const CreateProjectPage({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put<CreateProjectController>(CreateProjectController());

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
                  onChanged: projectFormViewController.onProjectNameChanged,
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
