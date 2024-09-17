import 'dart:async';

import 'package:get/get.dart';

class ProjectPageController extends GetxController {
  List<String> items = List.generate(50, (index) => 'Nome do projeto $index');

  List<String>? values;

  ProjectPageController() {
    values = List.of(items);
  }

  FutureOr<void> filterProjects(String filter) async {
    values = List.of(items)
        .where((element) => (element.camelCase ?? '')
            .isCaseInsensitiveContains(filter.camelCase ?? ''))
        .toList();

    update(['projects']);
  }
}
