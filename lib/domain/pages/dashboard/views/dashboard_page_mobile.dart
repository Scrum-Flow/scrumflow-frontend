import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scrumflow/domain/pages/backlog/backlog.dart';
import 'package:scrumflow/domain/pages/feature/views/feature_page.dart';
import 'package:scrumflow/domain/pages/kanban/kanban.dart';
import 'package:scrumflow/domain/pages/sprint/views/sprint_form_page.dart';
import 'package:scrumflow/domain/pages/task/views/task_page.dart';
import 'package:scrumflow/models/project.dart';

class DashboardPageMobile extends StatefulWidget {
  const DashboardPageMobile(this.project, {super.key});

  final Project project;

  @override
  _DashboardPageMobileState createState() => _DashboardPageMobileState();
}

class _DashboardPageMobileState extends State<DashboardPageMobile> {
  late Widget _currentPage;
  int _selectedIndex = 0;

  final List<Widget> _pages = [];

  @override
  void initState() {
    super.initState();
    _pages.add(TaskPage(projectId: widget.project.id!));
    _pages.add(FeaturePage(projectId: widget.project.id!));
    _pages.add(SprintFormPage(projectId: widget.project.id!));
    _pages.add(BacklogPage(projectId: widget.project.id!));
    _pages.add(KanbanPage(project: widget.project));
    _currentPage = _pages[_selectedIndex];
  }

  void _selectPage(int index) {
    setState(() {
      _selectedIndex = index;
      _currentPage = _pages[_selectedIndex];
    });
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Itens do Projeto"),
        actions: [
          IconButton(
              padding: const EdgeInsets.only(right: 20),
              onPressed: () => Get.back(),
              icon: const Icon(Icons.arrow_back_ios_rounded))
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Colors.blue,
              ),
              child: Center(
                child: Text(
                  widget.project.name ?? "Projeto",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            _buildDrawerItem(
              icon: Icons.task,
              title: "Tarefas",
              index: 0,
            ),
            _buildDrawerItem(
              icon: Icons.featured_play_list,
              title: "Funcionalidades",
              index: 1,
            ),
            _buildDrawerItem(
              icon: Icons.add_to_photos,
              title: "Cadastro Sprint",
              index: 2,
            ),
            _buildDrawerItem(
              icon: Icons.list,
              title: "Backlog",
              index: 3,
            ),
            _buildDrawerItem(
              icon: Icons.view_kanban,
              title: "Kanban",
              index: 4,
            ),
          ],
        ),
      ),
      body: _currentPage,
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    required int index,
  }) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      selected: _selectedIndex == index,
      selectedTileColor: Colors.blue.shade100,
      onTap: () => _selectPage(index),
    );
  }
}
