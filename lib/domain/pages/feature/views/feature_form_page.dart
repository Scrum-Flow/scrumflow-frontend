import 'package:flutter/material.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:scrumflow/domain/basics/basics.dart';
import 'package:scrumflow/domain/pages/feature/controllers/controllers.dart';
import 'package:scrumflow/models/models.dart';
import 'package:scrumflow/utils/utils.dart';
import 'package:scrumflow/widgets/widgets.dart';

class FeatureFormPage extends StatelessWidget {
  const FeatureFormPage({this.feature, required this.projectId, super.key});

  final int projectId;
  final Feature? feature;

  @override
  Widget build(BuildContext context) {
    Get.put<FeatureFormController>(
        FeatureFormController(feature, projectId: projectId));

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
                25.toSizedBoxH(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: BaseButton(
                        title: 'Cancelar',
                        isLoading:
                            featureFormViewController.pageState.value.status ==
                                PageStatus.loading,
                        onPressed: () => Get.back(),
                      ),
                    ),
                    25.toSizedBoxW(),
                    Expanded(
                      child: BaseButton(
                        title: 'Salvar',
                        isLoading:
                            featureFormViewController.pageState.value.status ==
                                PageStatus.loading,
                        onPressed: () async =>
                            await featureFormViewController.save(),
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
