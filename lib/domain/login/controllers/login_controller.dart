import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scrumflow/domain/home/pages/home_page.dart';
import 'package:scrumflow/services/authentication_service.dart';
import 'package:scrumflow/utils/utils.dart';
import 'package:scrumflow/widgets/prompts.dart';

class LoginController extends GetxController {
  var pageState = PageState.none().obs;
  var email = ''.obs;
  var password = ''.obs;
  var isLoading = false.obs;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  Future<void> login() async {
    if (formKey.currentState!.validate()) {
      pageState.value = PageState.loading();
      update();

      try {
        final authService = AuthService();

        await authService.authenticate(email.value, password.value);

        if (await DioHelper.userToken != null) {
          Prompts.successSnackBar('Sucesso', 'Login realizado com sucesso!');

          if (Get.context != null) {
            Routes.replaceTo(Get.context!, const HomePage());
          }
        }
      } catch (e) {
        Prompts.errorSnackBar(
            'Erro', 'Falha ao realizar login: ${e.toString()}');
      }
    } else {
      Prompts.errorSnackBar('Erro', "E-mail ou senha inválidos");
    }

    pageState.value = PageState.none();
    update();
  }
}
