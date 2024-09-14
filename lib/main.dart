import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:scrumflow/controllers/auth_controller.dart';
import 'package:scrumflow/domain/login/pages/login_page.dart';
import 'package:scrumflow/domain/splash_page.dart';

import 'domain/home/pages/home_page.dart';

void main() async {
  await dotenv.load();

  Get.put(AuthController());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    Get.find<AuthController>().initialVerification();

    return GetMaterialApp(
      title: 'ScrumFlow',
      navigatorKey: Get.key,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: GetBuilder<AuthController>(
        id: AuthControllerIds.authState,
        builder: (controller) {
          switch (controller.authState.value) {
            case AuthState.authorized:
              return const HomePage();
            case AuthState.unauthorized:
            case AuthState.none:
              return const LoginPage();
            case AuthState.loading:
            default:
              return const SplashPage();
          }
        },
      ),
    );
  }
}
