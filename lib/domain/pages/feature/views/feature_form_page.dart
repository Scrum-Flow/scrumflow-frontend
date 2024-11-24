import 'package:flutter/material.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:scrumflow/domain/basics/basics.dart';
import 'package:scrumflow/domain/pages/feature/controllers/controllers.dart';
import 'package:scrumflow/models/models.dart';
import 'package:scrumflow/utils/utils.dart';
import 'package:scrumflow/widgets/widgets.dart';

class FeatureFormPage extends StatelessWidget {
  const FeatureFormPage(
      {super.key, this.feature /*, this.sprint*/, required this.projectId});

  final int projectId;
  final Feature? feature;
  /*final Sprint? sprint;*/

  @override
  Widget build(BuildContext context) {
    Get.put<FeatureFormController>(FeatureFormController(feature,
        projectId: projectId /*, sprint: sprint*/));

    return Scaffold(
      appBar: AppBar(
        title: const Text("Cadastro de Funcionalidade"),
      ),
      body: const PageBuilder(
        minimumInsets: EdgeInsets.zero,
        webPage: FeatureFormView(),
        mobilePage: FeatureFormView(),
      ),
    );
  }
}

class FeatureFormView extends StatelessWidget {
  const FeatureFormView({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [_FeatureForm()],
    );
  }
}

class _FeatureForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    FeatureFormController featureFormViewController =
        Get.find<FeatureFormController>();

    return SizedBox(
      width: Helper.screenWidth(),
      height: Helper.screenHeight(),
      child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
          child: Form(
            key: featureFormViewController.featureFormKey,
            autovalidateMode: AutovalidateMode.disabled,
            child: ListView(
              children: [
                BaseTextField(
                  hint: "Nome da funcionalidade",
                  initialValue: featureFormViewController.feature?.name,
                  validator: FormBuilderValidators.required(
                      errorText: 'Campo obrigatório'),
                  onChanged: featureFormViewController.updateName,
                ),
                BaseTextField(
                  hint: "Descrição da funcionalidade",
                  initialValue: featureFormViewController.feature?.description,
                  validator: FormBuilderValidators.required(
                      errorText: 'Campo obrigatório'),
                  onChanged: featureFormViewController.updateDescription,
                ),
                Obx(() => LoadingWidget(
                      isLoading: featureFormViewController
                              .fetchProjectSprintsState.value.status ==
                          PageStatus.loading,
                      child: MultiSelectDialogField<Sprint>(
                        initialValue: featureFormViewController.projectSprints
                            .where((sprint) {
                          for (Sprint s
                              in featureFormViewController.oldFeatureSprints) {
                            if (sprint.id! == s.id) return true;
                          }
                          return false;
                        }).toList(),
                        buttonText: Text('Selecione as sprints'),
                        title: BaseLabel(text: 'Sprints'),
                        items: featureFormViewController.projectSprints
                            .map((e) => MultiSelectItem(e, e.name ?? ''))
                            .toList(),
                        onConfirm: (sprints) => featureFormViewController
                            .newFeatureSprints = sprints,
                        chipDisplay: MultiSelectChipDisplay(
                          scroll: true,
                          textStyle: TextStyle(fontSize: fsSmall),
                          scrollBar: HorizontalScrollBar(isAlwaysShown: true),
                        ),
                        listType: MultiSelectListType.CHIP,
                      ),
                    )),
                25.toSizedBoxH(),
                Obx(
                  () => Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: BaseButton(
                          title: 'Cancelar',
                          isLoading: featureFormViewController
                                  .pageState.value.status ==
                              PageStatus.loading,
                          onPressed: () => Get.back(result: false),
                        ),
                      ),
                      25.toSizedBoxW(),
                      Expanded(
                        child: BaseButton(
                          title: 'Salvar',
                          isLoading: featureFormViewController
                                  .pageState.value.status ==
                              PageStatus.loading,
                          onPressed: () async =>
                              await featureFormViewController.save(),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          )),
    );
  }
}
