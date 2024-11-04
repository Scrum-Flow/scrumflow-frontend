import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scrumflow/domain/basics/basics.dart';
import 'package:scrumflow/domain/pages/pages.dart';
import 'package:scrumflow/utils/routes.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthController authController = Get.find<AuthController>();

    return Scaffold(
      appBar: AppBar(
        title: const BaseLabel(text: 'Dashboards', fontSize: fsVeryBig, fontWeight: fwMedium),
      ),
      body: ProjectPage(
        user: authController.user.value,
        tag: Routes.dashboardPage,
        onSelectProject: (project) => Get.toNamed(Routes.kanbanPage, arguments: project),
      ),
    );
  }
}
