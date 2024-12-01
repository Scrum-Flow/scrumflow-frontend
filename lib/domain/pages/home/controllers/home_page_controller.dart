import 'package:easy_sidemenu/easy_sidemenu.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scrumflow/utils/enums/enum_icons.dart';

enum Pages {
  dashboard,
  projects,
  team,
  users;

  String get icon => switch (this) {
        Pages.dashboard => PathIcons.dashboard.getIcon(),
        Pages.projects => PathIcons.projects.getIcon(),
        Pages.team => PathIcons.team.getIcon(),
        Pages.users => PathIcons.users.getIcon(),
      };

  String get name => switch (this) {
        Pages.dashboard => 'Dashboard',
        Pages.projects => 'Projetos',
        Pages.team => 'Times',
        Pages.users => 'Usuários',
      };
}

class HomePageController extends GetxController {
  late PageController pageController = PageController();
  final SideMenuController sideMenu = SideMenuController();

  var index = 0.obs;

  void changePage(int index) {
    this.index.value = index;

    sideMenu.changePage(index);

    pageController.jumpToPage(index);
  }
}
