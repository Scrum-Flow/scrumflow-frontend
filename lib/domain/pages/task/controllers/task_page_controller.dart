import 'package:get/get.dart';
import 'package:scrumflow/models/models.dart';

class TaskPageController extends GetxController {
  List<Task>? _tasks;
  List<Feature>? _features;
}

/// Tenho que ter uma lista das features -->
/// Para cada feature, fazer uma request das tasks dessa feature
