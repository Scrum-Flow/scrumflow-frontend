import 'package:flutter/material.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:scrumflow/controllers/feature_form_controller.dart';
import 'package:scrumflow/utils/extensions/extensions.dart';
import 'package:scrumflow/utils/page_state.dart';
import 'package:scrumflow/utils/routes.dart';
import 'package:scrumflow/utils/screen_helper.dart';
import 'package:scrumflow/widgets/base_button.dart';
import 'package:scrumflow/widgets/base_label.dart';
import 'package:scrumflow/widgets/base_text_field.dart';
import 'package:scrumflow/widgets/page_builder.dart';

class FeaturePage extends StatelessWidget {
  const FeaturePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const BaseLabel(
              text: 'Funcionalidades',
              fontSize: fsVeryBig,
              fontWeight: fwMedium),
        ),
        body: Column(
          children: [
            BaseButton(
                title: 'Criar nova funcionalidade',
                onPressed: () => Routes.goTo(context, CreateFeaturePage())),
          ],
        ));
  }
}

class CreateFeaturePage extends StatelessWidget {
  const CreateFeaturePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Cadastro de nova Funcionalidade"),
        ),
        body: PageBuilder(
            minimumInsets: EdgeInsets.zero,
            webPage: _WebPage(),
            mobilePage: _MobilePage()));
  }

  Widget _WebPage() {
    return const FeatureFormView();
  }

  Widget _MobilePage() {
    return const FeatureFormView();
  }
}

class FeatureFormView extends StatelessWidget {
  const FeatureFormView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put<FeatureFormViewController>(FeatureFormViewController());

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [_FeatureForm()],
    );
  }
}

class _FeatureForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    FeatureFormViewController featureFormViewController =
        Get.find<FeatureFormViewController>();

    return SizedBox(
      width: ScreenHelper.screenWidth(),
      height: ScreenHelper.screenHeight(),
      child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
          child: Form(
            key: featureFormViewController.featureFormKey,
            autovalidateMode: AutovalidateMode.disabled,
            child: ListView(
              children: [
                BaseTextField(
                  hint: "Nome do projeto",
                  validator: FormBuilderValidators.required(
                      errorText: 'Campo obrigatório'),
                  onChanged: featureFormViewController.onFeatureNameChanged,
                ),
                BaseTextField(
                  hint: "Descrição do projeto",
                  validator: FormBuilderValidators.required(
                      errorText: 'Campo obrigatório'),
                  onChanged:
                      featureFormViewController.onFeatureDescriptionChanged,
                ),
                DropdownButtonFormField<int>(
                  items: const [
                    //Setado com valores estáticos por enquanto
                    DropdownMenuItem(value: 1, child: Text('Nome Projeto 1')),
                    DropdownMenuItem(value: 2, child: Text('Nome Projeto 2')),
                  ],
                  onChanged: (value) =>
                      featureFormViewController.onFeatureProjectSelected,
                  decoration: InputDecoration(labelText: 'Projeto'),
                  isExpanded: true,
                  validator: FormBuilderValidators.required(
                      errorText: 'É necessário selecionar um projeto'),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    BaseButton(
                      title: 'Cancelar',
                      isLoading:
                          featureFormViewController.pageState.value.status ==
                              PageStatus.loading,
                      onPressed: () async =>
                          await featureFormViewController.cancel(),
                    ),
                    25.toSizedBoxW(),
                    BaseButton(
                      title: 'Salvar',
                      isLoading:
                          featureFormViewController.pageState.value.status ==
                              PageStatus.loading,
                      onPressed: () async =>
                          await featureFormViewController.newFeature(),
                    ),
                  ],
                )
              ],
            ),
          )),
    );
  }
}
