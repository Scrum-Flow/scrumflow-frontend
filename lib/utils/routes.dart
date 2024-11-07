import 'package:get/get.dart';
import 'package:scrumflow/domain/pages/backlog/views/backlog_page.dart';
import 'package:scrumflow/domain/pages/kanban/views/kanban_page.dart';
import 'package:scrumflow/domain/pages/pages.dart';
import 'package:scrumflow/domain/pages/sprint/views/sprint_form_page.dart';
import 'package:scrumflow/domain/pages/team/views/team_form_page.dart';
import 'package:scrumflow/domain/pages/user/views/user_register_page.dart';
import 'package:scrumflow/domain/pages/user/views/users_page.dart';
import 'package:scrumflow/models/models.dart';

class Routes {
  static String first() {
    return loadingPage;
  }

  static List<GetPage> getPages() {
    return [
      GetPage(
        name: loginPage,
        page: () => const LoginPage(),
      ),
      GetPage(
        name: registerPage,
        page: () => const UserRegisterPage(),
      ),
      GetPage(
        name: homePage,
        page: () => const HomePage(),
      ),
      GetPage(
        name: kanbanPage,
        page: () {
          Project project = Get.arguments;

          return KanbanPage(project: project);
        },
      ),
      GetPage(
        name: loadingPage,
        page: () => const SplashPage(),
      ),
      GetPage(
        name: projectPage,
        page: () => const ProjectPage(),
      ),
      GetPage(
        name: projectFormPage,
        page: () {
          Project? project = Get.arguments;

          return ProjectFormPage(project: project);
        },
      ),
      GetPage(
        name: teamPage,
        page: () => const TeamPage(),
      ),
      GetPage(
        name: teamFormPage,
        page: () {
          Team? team = Get.arguments;

          return TeamFormPage(team: team);
        },
      ),
      GetPage(
        name: usersPage,
        page: () => const UsersPage(),
      ),
      GetPage(
        name: dashboardPage,
        page: () => const DashboardPage(),
      ),
      GetPage(
        name: taskPage,
        page: () {
          return TaskPage(projectId: Get.find<Project>().id!);
        },
      ),
      GetPage(
        name: taskFormPage,
        page: () => const TaskFormPage(),
      ),
      GetPage(
        name: featurePage,
        page: () {
          return FeaturePage(projectId: Get.find<Project>().id!);
        },
      ),
      GetPage(
        name: featureFormPage,
        page: () => FeatureFormPage(
          projectId: Get.find<Project>().id!,
        ),
      ),
      GetPage(
        name: backlog,
        page: () => BacklogPage(projectId: Get.find<Project>().id!),
      ),
      GetPage(
          name: sprintFormPage,
          page: () => SprintFormPage(projectId: Get.find<Project>().id!))
    ];
  }

  static const loginPage = '/login';
  static const registerPage = '/register';
  static const homePage = '/home';
  static const loadingPage = '/loading';
  static const projectPage = '/project';
  static const projectFormPage = '$projectPage/projectForm';
  static const teamPage = '/team';
  static const teamFormPage = '$teamPage/teamFormPage';
  static const usersPage = '/users';
  static const dashboardPage = '/dashboard';
  static const taskPage = '/task';
  static const taskFormPage = '$taskPage/taskForm';
  static const featurePage = '/feature';
  static const featureFormPage = '/featureForm';
  static const sprintFormPage = '$backlog/sprintFormPage';
  static const backlog = '/backlog';
  static const kanbanPage = '/kanban';
}
