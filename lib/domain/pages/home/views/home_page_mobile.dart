import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:scrumflow/domain/basics/basics.dart';
import 'package:scrumflow/domain/pages/dashboard/views/dashboard_page.dart';
import 'package:scrumflow/domain/pages/home/controllers/auth_controller.dart';
import 'package:scrumflow/domain/pages/home/controllers/home_page_controller.dart';
import 'package:scrumflow/domain/pages/project/views/project_page.dart';
import 'package:scrumflow/domain/pages/team/views/team_page.dart';
import 'package:scrumflow/domain/pages/user/views/users_page.dart';

class BodyMobile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    HomePageController homeController = Get.find<HomePageController>();

    return SafeArea(
        child: Column(
      children: [
        Expanded(
          child: PageView(
            controller: homeController.pageController,
            pageSnapping: false,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              DashboardPage(),
              ProjectPage(),
              TeamPage(),
              UsersPage(),
            ],
          ),
        ),
        _BottomNavigationBar(), // Novo widget para mobile
      ],
    ));
  }
}

class _BottomNavigationBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    HomePageController homeController = Get.find<HomePageController>();
    AuthController authController = Get.find<AuthController>();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/logo.png',
            width: 45,
            height: 45,
          ),
          const VerticalDivider(
            width: 1.0,
          ),
          Obx(() {
            return Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ...Pages.values.map((page) {
                    return InkWell(
                      onTap: () => homeController.changePage(page.index),
                      child: Container(
                        height: 50,
                        color: homeController.index.value == page.index
                            ? const Color(0xff6d98ee)
                            : Colors.transparent,
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            SvgPicture.asset(
                              page.icon,
                              width: 45,
                              height: 45,
                              colorFilter: ColorFilter.mode(
                                homeController.index.value == page.index
                                    ? Colors.white
                                    : Colors.black,
                                BlendMode.srcIn,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ],
              ),
            );
          }),
          IconButton(
            onPressed: () => showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: BaseLabel(text: 'Realmente deseja sair da aplicação ?'),
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
        ],
      ),
    );
  }
}
