import 'package:flutter/material.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:scrumflow/domain/basics/basics.dart';
import 'package:scrumflow/domain/pages/user/user.dart';
import 'package:scrumflow/widgets/web_view.dart';
import 'package:scrumflow/utils/utils.dart';
import 'package:scrumflow/widgets/page_builder.dart';

class UserRegisterPage extends StatelessWidget {
  const UserRegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put<UserRegisterController>(UserRegisterController());

    return Scaffold(
      body: PageBuilder(mobilePage: _Body(), webPage: WebView(_Body())),
    );
  }
}

class _Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      mainAxisSize: MainAxisSize.max,
      children: [
        Flexible(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              SizedBox(width: 150, height: 150, child: Image.asset('assets/images/logo.png')),
              10.toSizedBoxH(),
              const BaseLabel(
                text: "ScrumFlow",
                fontSize: fsVeryBig,
                fontWeight: fwBold,
              ),
            ],
          ),
        ),
        Flexible(child: _Form()),
      ],
    );
  }
}

class _Form extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    UserRegisterController userController = Get.find<UserRegisterController>();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Form(
        key: userController.formKey,
        autovalidateMode: AutovalidateMode.disabled,
        child: ListView(
          children: [
            BaseTextField(
              hint: 'Nome Completo',
              prefixIcon: const Icon(Icons.person_outline),
              validator: FormBuilderValidators.required(errorText: 'Campo obrigatório'),
              onChanged: userController.onNameChanged,
            ),
            BaseTextField(
              hint: 'E-mail',
              prefixIcon: const Icon(Icons.email_outlined),
              validator: FormBuilderValidators.compose([FormBuilderValidators.required(errorText: 'Campo obrigatório'), FormBuilderValidators.email(errorText: 'Email inválido')]),
              onChanged: userController.onEmailChanged,
            ),
            BasePasswordField(
              hint: 'Senha',
              validator: FormBuilderValidators.compose([
                FormBuilderValidators.required(errorText: 'Campo obrigatório'),
                FormBuilderValidators.minLength(8, errorText: 'A senha deve ter no mínimo 8 caracteres'),
                FormBuilderValidators.hasUppercaseChars(atLeast: 1, errorText: 'A senha deve ter ao menos uma letra maiúscula'),
                FormBuilderValidators.hasNumericChars(atLeast: 1, errorText: 'A senha deve ter ao menos um número'),
              ]),
              onChanged: userController.onPasswordChanged,
            ),
            GetBuilder<UserRegisterController>(
              id: UserRegisterControllersIds.password,
              builder: (controller) => BasePasswordField(
                hint: 'Repita a senha',
                validator: FormBuilderValidators.compose(
                    [FormBuilderValidators.required(errorText: 'Campo obrigatório'), FormBuilderValidators.equal(controller.password.value, errorText: 'As senhas não coincidem')]),
                onChanged: userController.onPasswordConfirmationChanged,
              ),
            ),
            GetBuilder<UserRegisterController>(
              id: UserRegisterControllersIds.pageState,
              builder: (controller) => Row(
                children: [
                  Expanded(
                    child: BaseButton(
                      title: 'Cancelar',
                      type: ButtonType.secondary,
                      isLoading: controller.pageState.value.status == PageStatus.loading,
                      onPressed: () => Routes.goBack(context),
                    ),
                  ),
                  12.toSizedBoxW(),
                  Expanded(
                    child: BaseButton(
                      title: 'Cadastrar',
                      isLoading: controller.pageState.value.status == PageStatus.loading,
                      onPressed: () async => await userController.register(),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
