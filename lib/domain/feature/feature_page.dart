import 'package:flutter/material.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:scrumflow/controllers/feature_form_controller.dart';
import 'package:scrumflow/models/feature.dart';
import 'package:scrumflow/utils/enums/enum_view_mode.dart';
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
            20.toSizedBoxH(),
            BaseButton(
                title: 'Editar funcionalidade',
                onPressed: () => Routes.goTo(
                    context,
                    CreateFeaturePage(
                        feature: Feature.fake(), viewMode: ViewMode.edit))),
            20.toSizedBoxH(),
            BaseButton(
                title: 'Visualizar funcionalidade',
                onPressed: () => Routes.goTo(
                    context,
                    CreateFeaturePage(
                        feature: Feature.fake(), viewMode: ViewMode.view))),
          ],
        ));
  }
}

class CreateFeaturePage extends StatelessWidget {
  const CreateFeaturePage(
      {super.key, this.feature, this.viewMode = ViewMode.create});

  final ViewMode? viewMode;
  final Feature? feature;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(viewMode == ViewMode.view
              ? "Visualização da Funcionalidade"
              : viewMode == ViewMode.edit
                  ? "Edição de Funcionalidade"
                  : "Cadastro de nova Funcionalidade"),
        ),
        body: PageBuilder(
            minimumInsets: EdgeInsets.zero,
            webPage: _WebPage(feature, viewMode),
            mobilePage: _MobilePage(feature, viewMode)));
  }

  Widget _WebPage(Feature? feature, ViewMode? viewMode) {
    return FeatureFormView(feature: feature, viewMode: viewMode);
  }

  Widget _MobilePage(Feature? feature, ViewMode? viewMode) {
    return FeatureFormView(feature: feature, viewMode: viewMode);
  }
}

class FeatureFormView extends StatelessWidget {
  const FeatureFormView(
      {super.key, this.feature, this.viewMode = ViewMode.create});

  final ViewMode? viewMode;
  final Feature? feature;

  @override
  Widget build(BuildContext context) {
    Get.put<FeatureFormViewController>(
        FeatureFormViewController(viewMode, feature));

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [_FeatureForm()],
    );
  }
}

class _FeatureForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final featureFormViewController = Get.find<FeatureFormViewController>();

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
                Obx(
                  () => BaseTextField(
                    initialValue: featureFormViewController.name.value,
                    hint: "Nome do projeto",
                    validator: FormBuilderValidators.required(
                        errorText: 'Campo obrigatório'),
                    onChanged: featureFormViewController.onFeatureNameChanged,
                    enabled:
                        featureFormViewController.viewMode != ViewMode.view,
                  ),
                ),
                Obx(
                  () => BaseTextField(
                    initialValue: featureFormViewController.description.value,
                    hint: "Descrição do projeto",
                    validator: FormBuilderValidators.required(
                        errorText: 'Campo obrigatório'),
                    onChanged:
                        featureFormViewController.onFeatureDescriptionChanged,
                    enabled:
                        featureFormViewController.viewMode != ViewMode.view,
                  ),
                ),
                DropdownButtonFormField<int>(
                  items: const [
                    //Setado com valores estáticos por enquanto
                    DropdownMenuItem(value: -1, child: Text('Projeto fake')),
                    DropdownMenuItem(value: 1, child: Text('Nome Projeto 1')),
                    DropdownMenuItem(value: 2, child: Text('Nome Projeto 2')),
                  ],
                  onChanged: featureFormViewController.viewMode != ViewMode.view
                      ? (value) =>
                          featureFormViewController.onFeatureProjectSelected
                      : null,
                  decoration: InputDecoration(labelText: 'Projeto'),
                  isExpanded: true,
                  validator: FormBuilderValidators.required(
                      errorText: 'É necessário selecionar um projeto'),
                  value: featureFormViewController.viewMode != ViewMode.create
                      ? featureFormViewController.projectId.value
                      : null,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Obx(
                      () => BaseButton(
                        title:
                            featureFormViewController.viewMode != ViewMode.view
                                ? 'Cancelar'
                                : 'Voltar',
                        isLoading:
                            featureFormViewController.pageState.value.status ==
                                PageStatus.loading,
                        onPressed: () =>
                            featureFormViewController.viewMode != ViewMode.view
                                ? featureFormViewController.confirmExit(context)
                                : featureFormViewController.exit(),
                      ),
                    ),
                    25.toSizedBoxW(),
                    featureFormViewController.viewMode != ViewMode.view
                        ? BaseButton(
                            title: 'Salvar',
                            isLoading: featureFormViewController
                                    .pageState.value.status ==
                                PageStatus.loading,
                            onPressed: () async =>
                                await featureFormViewController.saveFeature(),
                          )
                        : 0.toSizedBoxW(),
                  ],
                )
              ],
            ),
          )),
    );
  }
}
