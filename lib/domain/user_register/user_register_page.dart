import 'package:flutter/material.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:scrumflow/domain/user_register/controllers/user_register_controller.dart';
import 'package:scrumflow/models/user.dart';
import 'package:scrumflow/parts/web_view.dart';
import 'package:scrumflow/utils/utils.dart';
import 'package:scrumflow/widgets/base_button.dart';
import 'package:scrumflow/widgets/base_label.dart';
import 'package:scrumflow/widgets/base_password_field.dart';
import 'package:scrumflow/widgets/base_text_field.dart';
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
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
                width: 150, height: 150, child: Image.asset('images/logo.png')),
            10.toSizedBoxH(),
            const BaseLabel(
              text: "ScrumFlow",
              fontSize: fsVeryBig,
              fontWeight: fwBold,
            ),
          ],
        ),
        _Form(),
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
        child: Column(
          children: [
            BaseTextField(
              hint: 'Nome Completo',
              prefixIcon: const Icon(Icons.person_outline),
              validator: FormBuilderValidators.required(
                  errorText: 'Campo obrigatório'),
              onChanged: userController.onNameChanged,
            ),
            BaseTextField(
              hint: 'E-mail',
              prefixIcon: const Icon(Icons.email_outlined),
              validator: FormBuilderValidators.compose([
                FormBuilderValidators.required(errorText: 'Campo obrigatório'),
                FormBuilderValidators.email(errorText: 'Email inválido')
              ]),
              onChanged: userController.onEmailChanged,
            ),
            BasePasswordField(
              hint: 'Senha',
              validator: FormBuilderValidators.required(
                  errorText: 'Campo obrigatório'),
              onChanged: userController.onPasswordChanged,
            ),
            GetBuilder<UserRegisterController>(
              id: UserRegisterControllersIds.password,
              builder: (controller) => BasePasswordField(
                hint: 'Repita a senha',
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(
                      errorText: 'Campo obrigatório'),
                  FormBuilderValidators.equal(controller.password.value,
                      errorText: 'As senhas não coincidem')
                ]),
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
                      isLoading: controller.pageState.value.status ==
                          PageStatus.loading,
                      onPressed: () => Routes.goBack(context),
                    ),
                  ),
                  12.toSizedBoxW(),
                  Expanded(
                    child: BaseButton(
                      title: 'Cadastrar',
                      isLoading: controller.pageState.value.status ==
                          PageStatus.loading,
                      onPressed: () async {
                        User? user = await userController.register();

                        if (user != null) {
                          Navigator.of(context).pop();
                        }
                      },
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
