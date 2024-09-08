import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scrumflow/controllers/user_controller.dart';
import 'package:scrumflow/domain/dashboard/dashboard_page.dart';
import 'package:scrumflow/domain/project/pages/project_page.dart';
import 'package:scrumflow/domain/tasks/pages/task_page.dart';
import 'package:scrumflow/domain/team/pages/team_page.dart';
import 'package:scrumflow/domain/users/pages/users_page.dart';
import 'package:scrumflow/utils/enums/enum_icons.dart';
import 'package:scrumflow/utils/routes.dart';
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
          getNavigationButtons(context, userController),
        ]),
      ),
    );
  }

  ListView getNavigationButtons(
      BuildContext context, AuthController userController) {
    late List<Widget> btns;

    btns = [];

    if (userController.user.value.userCategory!.index != 2) {
      btns.add(
        NavigationButton(
          iconPath: PathIcons.projects.getIcon(),
          title: "Projetos",
          onPressed: () => Routes.goTo(context, const ProjectPage()),
        ),
      );
      btns.add(
        NavigationButton(
          iconPath: PathIcons.team.getIcon(),
          title: "Times",
          onPressed: () => Routes.goTo(context, const TeamPage()),
        ),
      );
      btns.add(
        NavigationButton(
            iconPath: PathIcons.users.getIcon(),
            title: "Usuários",
            onPressed: () => Routes.goTo(context, const UsersPage())),
      );
    }

    btns.add(
      NavigationButton(
        iconPath: PathIcons.tasks.getIcon(),
        title: "Tarefas",
        onPressed: () => Routes.goTo(context, const TaskPage()),
      ),
    );

    btns.add(
      NavigationButton(
        iconPath: PathIcons.dashboard.getIcon(),
        title: "Dashboard",
        onPressed: () => Routes.goTo(context, const DashboardPage()),
      ),
    );

    return ListView(
      shrinkWrap: true,
      children: btns,
    );
  }
}
