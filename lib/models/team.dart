import 'package:scrumflow/models/models.dart';
import 'package:scrumflow/utils/utils.dart';

class Team {
  const Team({
    this.id,
    this.name,
    this.createdAt,
    this.updatedAt,
    this.project,
    this.users,
  });

  final int? id;
  final String? name;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final Project? project;
  final List<User>? users;

  factory Team.fromJson(Map<String, dynamic> json) {
    return Team(
      id: Helper.keyExists(json, 'id'),
      name: Helper.keyExists(json, 'name'),
      createdAt: Helper.toDateTime(Helper.keyExists(json, 'createdAt')),
      updatedAt: Helper.toDateTime(Helper.keyExists(json, 'updatedAt')),
      project: json.containsKey('project') ? Project.fromJson(Helper.keyExists(json, 'project')) : null,
      users: json.containsKey('users') ? (Helper.keyExists(json, 'users') as List).map<User>((map) => User.fromJson(map)).toList() : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'projectId': project?.id ?? 0,
      'users': users?.map((user) => user.id).toList(),
    };
  }
}
