import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:scrumflow/domain/basics/basics.dart';
import 'package:scrumflow/domain/pages/task/controllers/controllers.dart';
import 'package:scrumflow/models/models.dart';
import 'package:scrumflow/utils/utils.dart';
import 'package:scrumflow/widgets/widgets.dart';

class TaskFormPage extends StatelessWidget {
  const TaskFormPage({required this.feature, this.task, super.key});

  final Task? task;
  final Feature feature;

  @override
  Widget build(BuildContext context) {
    Get.put<TaskFormController>(
        TaskFormController(task, feature: feature)..initialEvent());

    return Scaffold(
      appBar: AppBar(
        title: const Text("Cadastro de nova Tarefa"),
      ),
      body: const PageBuilder(
        minimumInsets: EdgeInsets.zero,
        webPage: TaskFormView(),
        mobilePage: TaskFormView(),
      ),
    );
  }
}

class TaskFormView extends StatelessWidget {
  const TaskFormView({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [_TaskForm()],
    );
  }
}

class _TaskForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    TaskFormController taskFormViewController = Get.find<TaskFormController>();

    taskFormViewController.pageState.listen((value) {
      Prompts.showSnackBar(value);

      if (value.status == PageStatus.success) Get.back();
    });

    return SizedBox(
      width: Helper.screenWidth(),
      height: Helper.screenHeight(),
      child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
          child: Form(
            key: taskFormViewController.taskFormKey,
            autovalidateMode: AutovalidateMode.disabled,
            child: ListView(
              children: [
                BaseTextField(
                  hint: "Nome da tarefa",
                  initialValue: taskFormViewController.task?.name,
                  validator: FormBuilderValidators.required(
                      errorText: 'Campo obrigatório'),
                  onChanged: taskFormViewController.updateName,
                ),
                BaseTextField(
                  hint: "Descrição da tarefa",
                  initialValue: taskFormViewController.task?.description,
                  validator: FormBuilderValidators.required(
                      errorText: 'Campo obrigatório'),
                  onChanged: taskFormViewController.updateDescription,
                ),
                Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: DropdownSearch<int>(
                        items: (f, cs) => List.generate(15, (i) => i + 1),
                        decoratorProps: const DropDownDecoratorProps(
                          decoration: InputDecoration(
                              labelText: "Pontos estimados",
                              hintText: "Selecione um número"),
                        ),
                        selectedItem:
                            taskFormViewController.estimatePoints.value,
                        /*validator: FormBuilderValidators.required(
                            errorText: 'Campo obrigatório'),*/
                        onChanged: (value) => taskFormViewController
                            .updateEstimatePoints(value ?? 0),
                        popupProps: PopupProps.dialog(
                          title: Container(
                            decoration: const BoxDecoration(
                                color: AppTheme.ligthBlueScrum),
                            alignment: Alignment.center,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            child: const Text(
                              'Pontos estimados',
                              style: TextStyle(
                                  fontSize: 21,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white70),
                            ),
                          ),
                          dialogProps: DialogProps(
                            clipBehavior: Clip.antiAlias,
                            shape: OutlineInputBorder(
                              borderSide: const BorderSide(width: 1),
                              borderRadius: BorderRadius.circular(25),
                            ),
                          ),
                        ),
                      ),
                    ),
                    20.toSizedBoxW(),
                    Expanded(
                      flex: 7,
                      child: Obx(
                        () => LoadingWidget(
                          isLoading: taskFormViewController
                                  .initialState.value.status ==
                              PageStatus.loading,
                          child: DropdownSearch<String>(
                            suffixProps: const DropdownSuffixProps(
                              clearButtonProps:
                                  ClearButtonProps(isVisible: true),
                              dropdownButtonProps: DropdownButtonProps(
                                iconClosed: Icon(Icons.keyboard_arrow_down),
                                iconOpened: Icon(Icons.keyboard_arrow_up),
                              ),
                            ),
                            items: (filter, props) => taskFormViewController
                                .users
                                .map((user) => user.name ?? '')
                                .where((e) => e
                                    .toLowerCase()
                                    .contains(filter.toLowerCase()))
                                .toList(),
                            onChanged: (selectedUserName) {
                              var selectedUser =
                                  taskFormViewController.users.firstWhere(
                                (user) => user.name == selectedUserName,
                              );
                              taskFormViewController
                                  .updateResponsibleUser(selectedUser.id!);
                            },
                            /*selectedItem: taskFormViewController.users
                                    .firstWhere((user) =>
                                        user.id ==
                                        taskFormViewController
                                            .responsibleUser.value)
                                    .name,*/
                            decoratorProps: DropDownDecoratorProps(
                              decoration: InputDecoration(
                                labelText: "Selecione o responsável",
                                hintText: "Escolha um usuário",
                                border: OutlineInputBorder(),
                              ),
                            ),
                            popupProps: PopupProps.menu(
                              showSearchBox: true,
                              itemBuilder:
                                  (context, item, isDisabled, isSelected) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 12.0),
                                  child: Text(
                                    item,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18),
                                    textAlign: TextAlign.center,
                                  ),
                                );
                              },
                              fit: FlexFit.loose,
                              constraints: BoxConstraints(maxHeight: 400),
                            ),
                          ),
                        ),
                      ),
                    )
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
                            taskFormViewController.pageState.value.status ==
                                PageStatus.loading,
                        onPressed: () => Get.back(),
                      ),
                    ),
                    25.toSizedBoxW(),
                    Expanded(
                      child: BaseButton(
                        title: 'Salvar',
                        isLoading:
                            taskFormViewController.pageState.value.status ==
                                PageStatus.loading,
                        onPressed: () async =>
                            await taskFormViewController.newTask(),
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
