import 'package:flutter/material.dart';
import 'package:scrumflow/domain/pages/backlog/backlog.dart';
import 'package:scrumflow/domain/pages/feature/views/feature_page.dart';
import 'package:scrumflow/domain/pages/kanban/kanban.dart';
import 'package:scrumflow/domain/pages/report/views/report_page.dart';
import 'package:scrumflow/domain/pages/sprint/views/sprint_form_page.dart';
import 'package:scrumflow/domain/pages/task/views/task_page.dart';
import 'package:scrumflow/models/project.dart';

class DashboardPageWeb extends StatelessWidget {
  const DashboardPageWeb(this.project, {super.key});

  final Project project;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 6,
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
              tabHeader('Relatório')
            ],
          ),
        ),
        body: TabBarView(
          children: [
            TaskPage(projectId: project.id!),
            FeaturePage(projectId: project.id!),
            SprintFormPage(projectId: project.id!),
            BacklogPage(projectId: project.id!),
            KanbanPage(project: project),
            ReportPage(projectId: project.id!)
          ],
        ),
      ),
    );
  }

  Widget tabHeader(String title) {
    return Tab(
      height: 30,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Text(title),
      ),
    );
  }
}
