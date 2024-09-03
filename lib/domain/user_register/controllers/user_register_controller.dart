import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:scrumflow/models/user.dart';
import 'package:scrumflow/services/authentication_service.dart';
import 'package:scrumflow/utils/utils.dart';

enum UserRegisterControllersIds {
  pageState,
  password,
}

class UserRegisterController extends GetxController {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final Rx<PageState> pageState = PageState.none().obs;
  final RxString name = ''.obs;
  final RxString email = ''.obs;
  final RxString password = ''.obs;
  final RxString passwordConfirmation = ''.obs;

  void onNameChanged(String value) {
    name.value = value;
  }

  void onEmailChanged(String value) {
    email.value = value;
  }

  void onPasswordChanged(String value) {
    password.value = value;
    update([UserRegisterControllersIds.password]);
  }

  void onPasswordConfirmationChanged(String value) {
    passwordConfirmation.value = value;
  }

  FutureOr<void> register() async {
    if (formKey.currentState!.validate()) {
      pageState.value = PageState.loading();
      update([UserRegisterControllersIds.pageState]);

      try {
        User? user = await AuthService.register(User(
          name: name.value,
          email: email.value,
          password: password.value,
        ));

        Get.back(result: user);
      } on DioException catch (e) {
        pageState.value = PageState.error(e.message);
        update([UserRegisterControllersIds.pageState]);
        debugPrint(e.toString());
      } catch (e) {
        pageState.value = PageState.error(e.toString());
        update([UserRegisterControllersIds.pageState]);
        debugPrint(e.toString());
      }

      pageState.value = PageState.none();
      update([UserRegisterControllersIds.pageState]);
    }

    return null;
  }
}
