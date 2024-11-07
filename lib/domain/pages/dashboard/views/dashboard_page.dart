import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scrumflow/domain/basics/basics.dart';
import 'package:scrumflow/domain/pages/backlog/backlog.dart';
import 'package:scrumflow/domain/pages/kanban/views/kanban_page.dart';
import 'package:scrumflow/domain/pages/pages.dart';
import 'package:scrumflow/domain/pages/sprint/sprint.dart';
import 'package:scrumflow/models/project.dart';
import 'package:scrumflow/utils/routes.dart';

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

    return DefaultTabController(
      length: 5,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Itens do projeto'),
          bottom: TabBar(
            tabs: [
              tabHeader('Tarefas'),
              tabHeader('Funcionalidades'),
              tabHeader('Cadastro Sprint'),
              tabHeader('Backlog'),
              tabHeader('Kanban'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            TaskPage(projectId: project.id!),
            FeaturePage(projectId: project.id!),
            SprintFormPage(projectId: project.id!),
            BacklogPage(projectId: project.id!),
            KanbanPage(project: project)
          ],
        ),
      ),
    );
  }

  Widget tabHeader(String title) {
    return Tab(
      height: 30,
      child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20), child: Text(title)),
    );
  }
}
