import 'package:scrumflow/models/models.dart';
import 'package:scrumflow/utils/utils.dart';

class FeatureDetails {
  final int? id;
  final String? name;
  final String? description;
  final List<Task>? tasks;

  const FeatureDetails({
    this.id,
    this.name,
    this.description,
    this.tasks,
  });

  factory FeatureDetails.fromJson(Map<String, dynamic> json) => FeatureDetails(
        id: Helper.keyExists(json, 'id'),
        name: Helper.keyExists(json, 'name'),
        description: Helper.keyExists(json, 'description'),
        tasks: Helper.keyExists(json, 'tasks')?.map<Task>((map) => Task.fromJson(map)).toList() ?? [],
      );
}
