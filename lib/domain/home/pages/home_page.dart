import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scrumflow/controllers/user_controller.dart';
import 'package:scrumflow/utils/enums/enum_icons.dart';
import 'package:scrumflow/widgets/base_label.dart';
import 'package:scrumflow/widgets/navegation_button.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    AuthController userController = Get.find<AuthController>();

    return Scaffold(
      appBar: AppBar(
          title: const BaseLabel(
              text: 'Home', fontSize: fsVeryBig, fontWeight: fwMedium),
          actions: [
            IconButton(
              onPressed: () => showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: BaseLabel(
                      text: 'Realmente deseja deslogar da aplicação ?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: BaseLabel(text: 'Cancelar'),
                    ),
                    TextButton(
                      onPressed: () => userController.logout(),
                      child: BaseLabel(text: 'Confirmar'),
                    )
                  ],
                ),
              ),
              icon: Icon(Icons.login_outlined),
            )
          ]),
      drawer: Drawer(
        child: Column(children: [
          UserAccountsDrawerHeader(
            accountName:
                BaseLabel(text: userController.user.value.name ?? 'Test'),
            accountEmail: BaseLabel(
              text: userController.user.value.email ?? 'Test',
            ),
          ),
          addNavigationButtons(),
        ]),
      ),
    );
  }

  Widget addNavigationButtons() {
    return ListView(shrinkWrap: true, children: [
      NavigationButton(
          iconPath: PathIcons.home.getIcon(),
          title: "Home",
          onPressed: () => {}),
      NavigationButton(
          iconPath: PathIcons.projects.getIcon(),
          title: "Projetos",
          onPressed: () => {}),
      NavigationButton(
          iconPath: PathIcons.team.getIcon(),
          title: "Times",
          onPressed: () => {}),
      NavigationButton(
          iconPath: PathIcons.users.getIcon(),
          title: "Usuários",
          onPressed: () => {}),
      NavigationButton(
          iconPath: PathIcons.tasks.getIcon(),
          title: "Tarefas",
          onPressed: () => {}),
      NavigationButton(
          iconPath: PathIcons.chat.getIcon(),
          title: "Chat",
          onPressed: () => {}),
      NavigationButton(
          iconPath: PathIcons.dashboard.getIcon(),
          title: "Dashboard",
          onPressed: () => {}),
    ]);
  }
}
