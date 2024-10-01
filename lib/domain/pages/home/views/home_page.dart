import 'package:easy_sidemenu/easy_sidemenu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:scrumflow/domain/basics/basics.dart';
import 'package:scrumflow/domain/pages/pages.dart';
import 'package:scrumflow/utils/utils.dart';
import 'package:scrumflow/widgets/page_builder.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put<HomePageController>(HomePageController());

    return Scaffold(
      body: PageBuilder(
        minimumInsets: EdgeInsets.zero,
        webPage: _Body(),
        mobilePage: _Body(),
      ),
    );
  }
}

class _Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    HomePageController homeController = Get.find<HomePageController>();

    return SafeArea(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          _SideMenu(),
          const VerticalDivider(width: 0),
          Expanded(
            child: PageView(
              controller: homeController.pageController,
              pageSnapping: false,
              physics: NeverScrollableScrollPhysics(),
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

class _SideMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    HomePageController homeController = Get.find<HomePageController>();
    AuthController authController = Get.find<AuthController>();

    return SideMenu(
      controller: homeController.sideMenu,
      alwaysShowFooter: true,
      style: SideMenuStyle(
        displayMode: Helper.isMobile() ? SideMenuDisplayMode.compact : SideMenuDisplayMode.auto,
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
              builder: (context, displayMode) {
                Widget picture = SvgPicture.asset(
                  page.icon,
                  width: 25,
                  colorFilter: ColorFilter.mode(
                    homeController.sideMenu.currentPage == page.index ? Colors.white : Colors.black,
                    BlendMode.srcIn,
                  ),
                );

                return Container(
                  width: double.infinity,
                  height: 50,
                  color: homeController.sideMenu.currentPage == page.index ? const Color(0xff020819) : Colors.transparent,
                  child: InkWell(
                    onTap: () => homeController.changePage(page.index),
                    child: Helper.isMobile()
                        ? Center(child: picture)
                        : ListTile(
                            leading: picture,
                            title: BaseLabel(
                              text: page.name,
                              color: homeController.sideMenu.currentPage == page.index ? Colors.white : Colors.black,
                            ),
                          ),
                  ),
                );
              },
            ),
          )
          .toList(),
      footer: Container(
        margin: EdgeInsets.only(bottom: 12),
        child: IconButton(
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
      ),
    );
  }
}
