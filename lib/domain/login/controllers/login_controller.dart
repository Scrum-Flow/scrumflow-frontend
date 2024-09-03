import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scrumflow/utils/dio_helper.dart';
import 'package:scrumflow/utils/theme.dart';
import 'package:scrumflow/services/authentication_service.dart';

class LoginController extends GetxController {
  var email = ''.obs;
  var password = ''.obs;
  var isLoading = false.obs;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  Future<void> login() async {
    if (formKey.currentState!.validate()) {
      try {
        final authService = AuthService();

        await authService.authenticate(email.value, password.value);

        if (await DioHelper.userToken != null) {
          showCustomSnackBar(
            'Sucesso',
            'Login realizado com sucesso!',
            true,
          );

          // Routes.goTo(pageHome)
        }
      } catch (e) {
        showCustomSnackBar(
          'Erro',
          'Falha ao realizar login: ${e.toString()}',
          false,
        );
      }
    } else {
      showCustomSnackBar(
        'Erro',
        "E-mail ou senha inválidos",
        false,
      );
    }
  }

  void showCustomSnackBar(String title, String message, bool isSuccess) {
    Get.snackbar(
      title,
      message,
      backgroundColor:
          isSuccess ? AppTheme.successColor : AppTheme.theme.colorScheme.error,
      colorText:
          isSuccess ? AppTheme.onSuccess : AppTheme.theme.colorScheme.onError,
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}
