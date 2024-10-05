import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:scrumflow/models/models.dart';
import 'package:scrumflow/utils/utils.dart';
import 'package:scrumflow/widgets/widgets.dart';

import '../controllers/controllers.dart';

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
      width: ScreenHelper.screenWidth(),
      height: ScreenHelper.screenHeight(),
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
                        decoratorProps: DropDownDecoratorProps(
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
                            decoration:
                                BoxDecoration(color: AppTheme.ligthBlueScrum),
                            alignment: Alignment.center,
                            padding: EdgeInsets.symmetric(vertical: 16),
                            child: Text(
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
                              borderSide: BorderSide(width: 0),
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
                            suffixProps: DropdownSuffixProps(
                              dropdownButtonProps: DropdownButtonProps(
                                iconClosed: Icon(Icons.keyboard_arrow_down),
                                iconOpened: Icon(Icons.keyboard_arrow_up),
                              ),
                            ),
                            decoratorProps: const DropDownDecoratorProps(
                              decoration: InputDecoration(
                                labelText:
                                    'Selecione o responsável pela tarefa',
                              ),
                            ),
                            items: (name, props) => taskFormViewController.users
                                .map((user) => user.name.toString())
                                .toList(),
                            popupProps: PopupProps.menu(
                              disableFilter:
                                  true, //data will be filtered by the backend
                              showSearchBox: true,
                              showSelectedItems: true,
                            ),
                            /*icon: Icon(Icons.person),
                      onConfirm: (p0) {},
                      searchable: true,
                      searchIcon: Icon(Icons.search_outlined),
                      listType: MultiSelectListType.CHIP,
                      title: const Text('Selecione os membros do projeto'),
                      searchHint: 'Nome do usuário',
                      barrierColor: Colors.transparent,
                      items: taskFormViewController.users
                          .map((user) => MultiSelectItem(user, user.name ?? ''))
                          .toList(),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.black12,
                      ),*/
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                /*BaseTextField(
                  hint: "Pontos estimados",
                  initialValue: taskFormViewController.task?.description,
                  validator: FormBuilderValidators.required(
                      errorText: 'Campo obrigatório'),
                  onChanged: taskFormViewController.updateDescription,
                ),*/
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
