import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scrumflow/models/user.dart';
import 'package:scrumflow/utils/utils.dart';

enum AuthControllerIds { authState }

enum AuthState { none, loading, authorized, unauthorized }

class AuthController extends GetxController {
  final Rx<User> user = User().obs;
  final Rx<AuthState> authState = AuthState.none.obs;

  @override
  void onInit() {
    super.onInit();

    initialVerification();

    authState.listen((state) {
      if (state == AuthState.unauthorized) {
        Get.offNamed(Routes.loginPage);
      } else if (state == AuthState.authorized) {
        Get.offNamed(Routes.homePage);
      } else if (state == AuthState.loading) {
        Get.offNamed(Routes.loadingPage);
      }
    });
  }

  void updateUser(User newUser) {
    user.value = newUser;
  }

  void authenticated() {
    authState.value = AuthState.authorized;
  }

  FutureOr<void> initialVerification() async {
    authState.value = AuthState.loading;

    try {
      await Future.delayed(Duration(seconds: 2));

      String? token = await Preferences.getString(PreferencesKeys.userToken);

      if (token != null) {
        user.value = User.fromJson(json.decode(token.toString()));

        authState.value = AuthState.authorized;
      } else {
        authState.value = AuthState.unauthorized;
      }
    } catch (e) {
      debugPrint(e.toString());
      authState.value = AuthState.unauthorized;
    }
  }

  FutureOr<void> logout() async {
    await Preferences.clear();

    authState.value = AuthState.unauthorized;
  }
}
