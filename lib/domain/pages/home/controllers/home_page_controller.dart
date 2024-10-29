import 'package:easy_sidemenu/easy_sidemenu.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scrumflow/utils/enums/enum_icons.dart';

enum Pages {
  dashboard,
  projects,
  team,
  users,
  tasks,
  features,
  sprints,
  backlog;

  String get icon => switch (this) {
        Pages.dashboard => PathIcons.dashboard.getIcon(),
        Pages.projects => PathIcons.projects.getIcon(),
        Pages.team => PathIcons.team.getIcon(),
        Pages.users => PathIcons.users.getIcon(),
        Pages.tasks => PathIcons.tasks.getIcon(),
        Pages.features => PathIcons.tasks.getIcon(),
        Pages.sprints => PathIcons.tasks.getIcon(),
        Pages.backlog => PathIcons.tasks.getIcon(),
      };

  String get name => switch (this) {
        Pages.dashboard => 'Dashboard',
        Pages.projects => 'Projetos',
        Pages.team => 'Times',
        Pages.users => 'Usuários',
        Pages.tasks => 'Tarefas',
        Pages.features => 'Funcionalidades',
        Pages.sprints => 'Sprints',
        Pages.backlog => 'Backlog',
      };
}

class HomePageController extends GetxController {
  late PageController pageController = PageController();
  final SideMenuController sideMenu = SideMenuController();

  int index = 0;

  void changePage(int index) {
    this.index = index;

    sideMenu.changePage(index);

    pageController.jumpToPage(index);
  }
}
