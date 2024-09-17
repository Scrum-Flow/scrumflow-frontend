import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scrumflow/domain/home/pages/home_page.dart';
import 'package:scrumflow/domain/login/pages/login_page.dart';
import 'package:scrumflow/models/user.dart';
import 'package:scrumflow/utils/utils.dart';

enum AuthControllerIds { authState }

enum AuthState { none, loading, authorized, unauthorized }

class AuthController extends GetxController {
  final Rx<User> user = User().obs;
  final Rx<AuthState> authState = AuthState.none.obs;

  void updateUser(User newUser) {
    user.value = newUser;
  }

  void authenticated() {
    authState.value = AuthState.authorized;

    Get.key.currentState?.pushReplacement(
      MaterialPageRoute(builder: (context) => const HomePage()),
    );
  }

  FutureOr<void> initialVerification() async {
    authState.value = AuthState.loading;
    update([AuthControllerIds.authState]);

    try {
      await Future.delayed(Duration(seconds: 2));

      String? token = await Prefs.getString(PrefsKeys.userToken);

      if (token != null) {
        user.value = User.fromJson(json.decode(token.toString()));

        authState.value = AuthState.authorized;
        update([AuthControllerIds.authState]);
      } else {
        authState.value = AuthState.unauthorized;
        update([AuthControllerIds.authState]);
      }
    } catch (e) {
      debugPrint(e.toString());
      authState.value = AuthState.unauthorized;
      update([AuthControllerIds.authState]);
    }
  }

  FutureOr<void> logout() async {
    await Prefs.clear();

    authState.value = AuthState.unauthorized;

    Get.key.currentState?.pushReplacement(
        MaterialPageRoute(builder: (context) => const LoginPage()));
  }
}
