
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scrumflow/domain/pages/home/controllers/auth_controller.dart';
import 'package:scrumflow/models/user.dart';
import 'package:scrumflow/domain/pages/login/services/authentication_service.dart';
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

        User user = await authService.authenticate(email.value, password.value);

        var authController = Get.find<AuthController>();

        authController.updateUser(user);
        authController.authenticated();

        Prompts.successSnackBar('Sucesso', 'Login realizado com sucesso!');
      } on DioException catch (e) {
        Prompts.errorSnackBar('Erro', e.message);
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
