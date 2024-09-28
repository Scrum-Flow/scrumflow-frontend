import 'package:get/get.dart';

enum PathIcons {
  chat,
  dashboard,
  home,
  projects,
  tasks,
  team,
  users;

  static PathIcons? getByName(String name) {
    return PathIcons.values.firstWhereOrNull((e) => e.name == name);
  }

  String getIcon() {
    return 'assets/icons/$name.svg';
  }
}
