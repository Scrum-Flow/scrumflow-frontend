import 'package:easy_sidemenu/easy_sidemenu.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scrumflow/utils/enums/enum_icons.dart';

enum Pages {
  dashboard,
  projects,
  team,
  users,
  tasks;

  String get icon => switch (this) {
        Pages.dashboard => PathIcons.dashboard.getIcon(),
        Pages.projects => PathIcons.projects.getIcon(),
        Pages.team => PathIcons.team.getIcon(),
        Pages.users => PathIcons.users.getIcon(),
        Pages.tasks => PathIcons.tasks.getIcon(),
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
