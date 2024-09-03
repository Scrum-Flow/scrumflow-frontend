import 'package:flutter/material.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:scrumflow/utils/extensions/extensions.dart';
import 'package:scrumflow/utils/routes.dart';
import 'package:scrumflow/utils/theme.dart';
import 'package:scrumflow/domain/login/controllers/login_controller.dart';
import 'package:scrumflow/domain/user_register/pages/user_register_page.dart';
import 'package:scrumflow/parts/web_view.dart';
import 'package:scrumflow/widgets/base_button.dart';
import 'package:scrumflow/widgets/base_label.dart';
import 'package:scrumflow/widgets/base_password_field.dart';
import 'package:scrumflow/widgets/base_text_field.dart';
import 'package:scrumflow/widgets/page_builder.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  LoginState createState() => LoginState();
}

class LoginState extends State<LoginPage> {
  final controller = LoginController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageBuilder(
        mobilePage: addBody(),
        webPage: WebView(addBody()),
      ),
    );
  }

  Widget newAccount() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const BaseLabel(
          text: 'Ainda não tem uma conta? ',
          color: Colors.black,
          fontSize: 14,
        ),
        InkWell(
          onTap: () => Routes.goTo(context, const UserRegisterPage()),
          child: BaseLabel(
            text: 'Crie agora',
            color: AppTheme.theme.colorScheme.onPrimary,
            decoration: TextDecoration.underline,
          ),
        ),
      ],
    );
  }

  Widget addBody() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Flexible(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                SizedBox(
                    width: 150,
                    height: 150,
                    child: Image.asset('assets/images/logo.png')),
                10.toSizedBoxH(),
                const BaseLabel(
                  text: "ScrumFlow",
                  fontSize: fsVeryBig,
                  fontWeight: fwBold,
                ),
              ],
            ),
          ),
          Flexible(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const BaseLabel(
                  text: "Bem vindo!",
                  fontSize: fsVeryBig,
                  fontWeight: fwMedium,
                ),
                const BaseLabel(
                  text: "Entre na sua conta",
                  fontWeight: fwLight,
                ),
                20.toSizedBoxH(),
                Form(
                  key: controller.formKey,
                  autovalidateMode: AutovalidateMode.disabled,
                  child: Expanded(
                    child: ListView(
                      children: [
                        BaseTextField(
                            hint: 'Email',
                            prefixIcon: const Icon(Icons.email_outlined),
                            keyboardType: TextInputType.emailAddress,
                            validator: FormBuilderValidators.compose(
                              [
                                FormBuilderValidators.required(
                                    errorText: 'Campo obrigatório'),
                                FormBuilderValidators.email(
                                    errorText: 'Email inválido')
                              ],
                            ),
                            onChanged: (value) =>
                                controller.email.value = value),
                        BasePasswordField(
                          hint: 'Senha',
                          validator: FormBuilderValidators.required(
                              errorText: 'Campo obrigatório'),
                          onChanged: (value) =>
                              controller.password.value = value,
                        ),
                        BaseButton(
                          title: "Continuar",
                          onPressed: () => controller.login(),
                        ),
                        10.toSizedBoxH(),
                        newAccount(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
