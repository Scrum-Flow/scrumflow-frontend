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
  features;

  String get icon => switch (this) {
        Pages.dashboard => PathIcons.dashboard.getIcon(),
        Pages.projects => PathIcons.projects.getIcon(),
        Pages.team => PathIcons.team.getIcon(),
        Pages.users => PathIcons.users.getIcon(),
        Pages.tasks => PathIcons.tasks.getIcon(),
        Pages.features => PathIcons.feature.getIcon(),
      };

  String get name => switch (this) {
        Pages.dashboard => 'Dashboard',
        Pages.projects => 'Projetos',
        Pages.team => 'Times',
        Pages.users => 'Usuários',
        Pages.tasks => 'Tarefas',
        Pages.features => 'Funcionalidades',
      };
}

class HomePageController extends GetxController {
  final PageController pageController = PageController();
  final SideMenuController sideMenu = SideMenuController();

  void changePage(int index) {
    sideMenu.changePage(index);

    pageController.jumpToPage(index);
  }
}
