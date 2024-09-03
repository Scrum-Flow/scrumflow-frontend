import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scrumflow/domain/login/login_page.dart';

class Routes {
  static String first() {
    return loginPage;
  }

  static List<GetPage> getPages() {
    return [
      GetPage(
        name: loginPage,
        page: () => const LoginPage(),
      ),
    ];
  }

  static Future goTo(BuildContext context, var page) async {
    return await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => page,
      ),
    );
  }

  static Future<T?> replaceTo<T extends Object>(BuildContext context, var page) async {
    return await Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => page,
      ),
    );
  }

  static goBack(BuildContext context, {dynamic result}) {
    Navigator.of(context).pop(result);
  }

  static const loginPage = '/login';
}
