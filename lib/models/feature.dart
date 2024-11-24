import 'package:scrumflow/utils/utils.dart';

class Feature {
  final int? id;
  final String? name;
  final String? description;
  int? projectId;
  final List<int>? sprintsId;

  Feature(
      {this.id, this.name, this.description, this.projectId, this.sprintsId});

  factory Feature.fromJson(Map<String, dynamic> json) {
    return Feature(
        id: Helper.keyExists<int>(json, 'id'),
        name: Helper.keyExists<String>(json, 'name'),
        description: Helper.keyExists<String>(json, 'description'),
        projectId: Helper.keyExists<int>(json, 'projectId'),
        sprintsId: Helper.keyExists<List<dynamic>>(json, 'sprintsId')
            ?.map((sprint) => sprint as int)
            .toList());
  }

  Feature copyWith({
    int? id,
    String? name,
    String? description,
    int? projectId,
    List<int>? sprintsId,
  }) {
    return Feature(
        id: id ?? this.id,
        name: name ?? this.name,
        description: description ?? this.description,
        projectId: projectId ?? this.projectId,
        sprintsId: sprintsId ?? this.sprintsId);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'projectId': projectId,
      'name': name,
      'description': description,
      'sprintsId': sprintsId,
    };
  }

  factory Feature.fake() {
    return Feature(
      id: 1,
      name: "Feature FAKE",
      description: "Feature false",
    );
  }

  @override
  String toString() {
    return name ?? "";
  }
}
