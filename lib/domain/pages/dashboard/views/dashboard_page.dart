import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scrumflow/domain/basics/basics.dart';
import 'package:scrumflow/domain/pages/dashboard/views/dashboard_page_mobile.dart';
import 'package:scrumflow/domain/pages/dashboard/views/dashboard_page_web.dart';
import 'package:scrumflow/domain/pages/pages.dart';
import 'package:scrumflow/models/project.dart';
import 'package:scrumflow/utils/routes.dart';
import 'package:scrumflow/widgets/widgets.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthController authController = Get.find<AuthController>();

    return Scaffold(
      appBar: AppBar(
        title: const BaseLabel(
            text: 'Dashboards', fontSize: fsVeryBig, fontWeight: fwMedium),
      ),
      body: ProjectPage(
        user: authController.user.value,
        tag: Routes.dashboardPage,
        onSelectProject: (project) => Get.to(DashTabPage(project)),
      ),
    );
  }
}

class DashTabPage extends StatelessWidget {
  const DashTabPage(this.project, {super.key});

  final Project project;
  @override
  Widget build(BuildContext context) {
    Get.put<Project>(project);

    return PageBuilder(
      minimumInsets: EdgeInsets.zero,
      webPage: DashboardPageWeb(project),
      mobilePage: DashboardPageMobile(project),
    );
  }
}
