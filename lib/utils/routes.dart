import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scrumflow/domain/dashboard/dashboard_page.dart';
import 'package:scrumflow/domain/home/pages/home_page.dart';
import 'package:scrumflow/domain/login/pages/login_page.dart';
import 'package:scrumflow/domain/project/pages/project_page.dart';
import 'package:scrumflow/domain/tasks/pages/task_page.dart';
import 'package:scrumflow/domain/team/pages/team_page.dart';
import 'package:scrumflow/domain/users/pages/users_page.dart';

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
      GetPage(
        name: homePage,
        page: () => const HomePage(),
      ),
      GetPage(
        name: projectPage,
        page: () => const ProjectPage(),
      ),
      GetPage(
        name: teamPage,
        page: () => const TeamPage(),
      ),
      GetPage(
        name: usersPage,
        page: () => const UsersPage(),
      ),
      GetPage(
        name: taskPage,
        page: () => const TaskPage(),
      ),
      GetPage(
        name: dashboardPage,
        page: () => const DashboardPage(),
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

  static Future<T?> replaceTo<T extends Object>(
      BuildContext context, var page) async {
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
  static const homePage = '/home';
  static const projectPage = '/project';
  static const teamPage = '/team';
  static const usersPage = '/users';
  static const taskPage = '/task';
  static const dashboardPage = '/dashboard';
}
