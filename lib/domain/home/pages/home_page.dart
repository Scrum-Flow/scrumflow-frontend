import 'package:easy_sidemenu/easy_sidemenu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:scrumflow/controllers/auth_controller.dart';
import 'package:scrumflow/domain/dashboard/dashboard_page.dart';
import 'package:scrumflow/domain/home/controllers/home_page_controller.dart';
import 'package:scrumflow/domain/project/pages/project_page.dart';
import 'package:scrumflow/domain/tasks/pages/task_page.dart';
import 'package:scrumflow/domain/team/pages/team_page.dart';
import 'package:scrumflow/domain/users/pages/users_page.dart';
import 'package:scrumflow/widgets/base_label.dart';
import 'package:scrumflow/widgets/page_builder.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put<HomePageController>(HomePageController());

    return PageBuilder(
      minimumInsets: EdgeInsets.zero,
      webPage: WebPage(),
      mobilePage: MobilePage(),
    );
  }
}

class WebPage extends StatelessWidget {
  const WebPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: _Body());
  }
}

class MobilePage extends StatelessWidget {
  const MobilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: _Body(isMobile: true));
  }
}

class _Body extends StatelessWidget {
  const _Body({this.isMobile = false});

  final bool isMobile;

  @override
  Widget build(BuildContext context) {
    HomePageController homeController = Get.find<HomePageController>();
    AuthController authController = Get.find<AuthController>();

    return SafeArea(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SideMenu(
            controller: homeController.sideMenu,
            alwaysShowFooter: true,
            style: SideMenuStyle(
              displayMode: SideMenuDisplayMode.compact,
              openSideMenuWidth: 150,
            ),
            title: Column(
              children: [
                Image.asset('assets/images/logo.png', width: 80),
                const Divider(
                  indent: 8.0,
                  endIndent: 8.0,
                ),
              ],
            ),
            items: Pages.values
                .map(
                  (page) => SideMenuItem(
                    builder: (context, displayMode) => Container(
                      width: double.infinity,
                      height: 50,
                      color: homeController.sideMenu.currentPage == page.index
                          ? const Color(0xff020819)
                          : Colors.transparent,
                      child: InkWell(
                        onTap: () => homeController.changePage(page.index),
                        child: Center(
                          child: SvgPicture.asset(
                            page.icon,
                            width: 25,
                            colorFilter: ColorFilter.mode(
                              homeController.sideMenu.currentPage == page.index
                                  ? Colors.white
                                  : Colors.black,
                              BlendMode.srcIn,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                )
                .toList(),
            footer: Container(
              margin: EdgeInsets.only(bottom: 12),
              child: IconButton(
                onPressed: () => showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title:
                        BaseLabel(text: 'Realmente deseja sair da aplicação ?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: BaseLabel(text: 'Cancelar'),
                      ),
                      TextButton(
                        onPressed: () => authController.logout(),
                        child: BaseLabel(text: 'Confirmar'),
                      )
                    ],
                  ),
                ),
                icon: Icon(Icons.login_outlined),
              ),
            ),
          ),
          const VerticalDivider(width: 0),
          Expanded(
            child: PageView(
              controller: homeController.pageController,
              children: [
                DashboardPage(),
                ProjectPage(),
                TeamPage(),
                UsersPage(),
                TaskPage(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
