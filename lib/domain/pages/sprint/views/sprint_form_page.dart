import 'package:flutter/material.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:scrumflow/domain/basics/basics.dart';
import 'package:scrumflow/domain/pages/sprint/controllers/controllers.dart';
import 'package:scrumflow/models/models.dart';
import 'package:scrumflow/utils/utils.dart';
import 'package:scrumflow/widgets/widgets.dart';

class SprintFormPage extends StatelessWidget {
  const SprintFormPage({this.sprint, required this.projectId, super.key});

  final Sprint? sprint;
  final int projectId;

  @override
  Widget build(BuildContext context) {
    Get.put<SprintFormController>(
        SprintFormController(sprint: sprint, projectId: projectId));

    return Scaffold(
      appBar: AppBar(
        title: const Text("Cadastro de Sprint"),
      ),
      body: const PageBuilder(
        minimumInsets: EdgeInsets.zero,
        webPage: SprintFormView(),
        mobilePage: SprintFormView(),
      ),
    );
  }
}

class SprintFormView extends StatelessWidget {
  const SprintFormView({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: _SprintForm(),
    );
  }
}

class _SprintForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SprintFormController SprintFormViewController =
        Get.find<SprintFormController>();

    return SizedBox(
      width: Helper.screenWidth(),
      height: Helper.screenHeight(),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        child: Form(
          key: SprintFormViewController.sprintFormKey,
          autovalidateMode: AutovalidateMode.disabled,
          child: ListView(
            children: [
              BaseTextField(
                hint: "Nome da sprint",
                initialValue: SprintFormViewController.sprint?.name,
                validator: FormBuilderValidators.required(
                    errorText: 'Campo obrigatório'),
                onChanged: SprintFormViewController.updateName,
              ),
              BaseTextField(
                hint: "Descrição da sprint",
                initialValue: SprintFormViewController.sprint?.description,
                onChanged: SprintFormViewController.updateDescription,
              ),
              Row(
                children: [
                  Expanded(
                    child: BaseDatePicker(
                      hint: 'Data de início da sprint',
                      initialValue: SprintFormViewController.sprint?.startDate,
                      validator: FormBuilderValidators.required(
                          errorText: 'Campo obrigatório'),
                      onChanged: SprintFormViewController.updateStartDate,
                    ),
                  ),
                  20.toSizedBoxW(),
                  Expanded(
                    child: BaseDatePicker(
                      hint: 'Data de fim da sprint',
                      initialValue: SprintFormViewController.sprint?.endDate,
                      validator: FormBuilderValidators.required(
                          errorText: 'Campo obrigatório'),
                      onChanged: SprintFormViewController.updateEndDate,
                    ),
                  ),
                ],
              ),
              25.toSizedBoxH(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: BaseButton(
                      title: 'Cancelar',
                      isLoading:
                          SprintFormViewController.pageState.value.status ==
                              PageStatus.loading,
                      onPressed: () => Get.back(),
                    ),
                  ),
                  25.toSizedBoxW(),
                  Expanded(
                    child: BaseButton(
                      title: 'Salvar',
                      isLoading:
                          SprintFormViewController.pageState.value.status ==
                              PageStatus.loading,
                      onPressed: () async =>
                          await SprintFormViewController.save(),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
