import 'package:scrumflow/models/sprint_details.dart';
import 'package:scrumflow/utils/utils.dart';

class ProjectDetails {
  final int? id;
  final String? name;
  final String? description;
  final List<SprintDetails>? sprints;

  const ProjectDetails({
    this.id,
    this.name,
    this.description,
    this.sprints,
  });

  factory ProjectDetails.fromJson(Map<String, dynamic> json) => ProjectDetails(
        id: Helper.keyExists(json, 'id'),
        name: Helper.keyExists(json, 'name'),
        description: Helper.keyExists(json, 'description'),
        sprints: Helper.keyExists(json, 'sprints')?.map<SprintDetails>((map) => SprintDetails.fromJson(map)).toList() ?? [],
      );
}
