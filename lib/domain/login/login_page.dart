import 'package:flutter/material.dart';
import 'package:scrumflow/core/theme.dart';
import 'package:scrumflow/domain/login/login_controller.dart';
import 'package:scrumflow/domain/login/page_views/login_mobile_view.dart';
import 'package:scrumflow/domain/login/page_views/login_web_view.dart';
import 'package:scrumflow/infra/utils.dart';
import 'package:scrumflow/widgets/base_button.dart';
import 'package:scrumflow/widgets/base_text_field.dart';
import 'package:validadores/Validador.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  LoginState createState() => LoginState();
}

class LoginState extends State<LoginPage> {
  late LoginController controller;

  @override
  void initState() {
    controller = LoginController();
    // controller.inicializar();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (isMobile()) {
            return buildMobile();
          }
          return buildWeb();
        },
      ),
    );
  }

  Widget newAccount() {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Ainda não tem uma conta? ',
            style: TextStyle(color: Colors.white, fontSize: 14),
          ),
          InkWell(
            onTap: () =>
                {} /*Navigator.of(context).push(UserRegisterPage.route())*/,
            child: Text(
              'Crie agora',
              style: TextStyle(
                color: AppTheme.theme.colorScheme.onPrimary,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget forgotPassword() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        InkWell(
          mouseCursor: SystemMouseCursors.click,
          onTap: () {
            /*Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ForgotPasswordPage()),
            );*/
          },
          child: Text(
            'Esqueci minha senha',
            style: TextStyle(
              color: AppTheme.theme.colorScheme.onPrimary,
              decoration: TextDecoration.underline,
            ),
          ),
        ),
      ],
    );
  }

  Widget addBody() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(left: 25, right: 25, top: 8, bottom: 8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
                width: 150, height: 150, child: Image.asset('images/logo.png')),
            10.toSizedBoxH(),
            const Text(
              "ScrumFlow",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            100.toSizedBoxH(),
            Form(
              key: controller.formKey,
              autovalidateMode: AutovalidateMode.disabled,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Row(
                    children: [
                      Text(
                        "Bem vindo!",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  const Row(
                    children: [
                      Text(
                        "Entre na sua conta",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                  20.toSizedBoxH(),
                  BaseTextField(
                      hint: 'Email',
                      prefixIcon: const Icon(Icons.email_outlined),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) => Validador()
                          .add(Validar.OBRIGATORIO, msg: 'Campo obrigatório')
                          .add(Validar.EMAIL, msg: "Email inválido")
                          .validar(value),
                      onChanged: (value) => controller.email.value = value),
                  BaseTextField(
                    hint: 'Senha',
                    obscureText: true,
                    prefixIcon: const Icon(Icons.lock_outline_rounded),
                    keyboardType: TextInputType.visiblePassword,
                    autofillHints: const [AutofillHints.password],
                    onChanged: (value) => controller.password.value = value,
                  ),
                  forgotPassword(),
                  20.toSizedBoxH(),
                  BaseButton(
                    title: "Continuar",
                    onPressed: () => controller.login(),
                  ),
                  20.toSizedBoxH(),
                  newAccount(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
