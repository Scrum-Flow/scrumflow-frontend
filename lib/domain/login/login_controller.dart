import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginController {
  var email = ''.obs;
  var password = ''.obs;
  var isLoading = false.obs;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  void login() {
    if (formKey.currentState!.validate()) {
      isLoading.value = true;

      Future.delayed(Duration(seconds: 2), () {
        isLoading.value = false;
        Get.snackbar('Sucesso', 'Login realizado',
            snackPosition: SnackPosition.BOTTOM);
        Get.offNamed('/home'); // Redirecionar para a página inicial
      });
    }
  }
}
