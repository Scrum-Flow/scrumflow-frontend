import 'package:get/get.dart';
import 'package:scrumflow/domain/pages/backlog/views/backlog_page.dart';
import 'package:scrumflow/domain/pages/pages.dart';
import 'package:scrumflow/domain/pages/sprint/views/sprint_form_page.dart';
import 'package:scrumflow/models/models.dart';

class Routes {
  static String first() {
    return loginPage;
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
          Project? team = Get.arguments;

          return ProjectFormPage(project: team);
        },
      ),
      GetPage(
        name: teamPage,
        page: () => const TeamPage(),
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
          return const TaskPage(projectId: 1);
        },
      ),
      GetPage(
        name: taskFormPage,
        page: () => const TaskFormPage(),
      ),
      GetPage(
        name: featurePage,
        page: () {
          return const FeaturePage(projectId: 1);
        },
      ),
      GetPage(
        name: featureFormPage,
        page: () => const TaskFormPage(),
      ),
      GetPage(
        name: backlog,
        page: () => const BacklogPage(projectId: 1),
      ),
      GetPage(
          name: sprintFormPage, page: () => const SprintFormPage(projectId: 1))
    ];
  }

  static const loginPage = '/login';
  static const registerPage = '/register';
  static const homePage = '/home';
  static const loadingPage = '/loading';
  static const projectPage = '/project';
  static const projectFormPage = '$projectPage/projectForm';
  static const teamPage = '/team';
  static const usersPage = '/users';
  static const dashboardPage = '/dashboard';
  static const taskPage = '/task';
  static const taskFormPage = '$taskPage/taskForm';
  static const featurePage = '/feature';
  static const featureFormPage = '$featurePage/featureForm';
  static const sprintFormPage = '$backlog/sprintFormPage';
  static const backlog = '/backlog';
}
