import 'package:scrumflow/utils/utils.dart';

class Feature {
  final int? id;
  final String? name;
  final String? description;
  final int? projectId;

  Feature({this.id, this.name, this.description, this.projectId});

  factory Feature.fromJson(Map<String, dynamic> json) {
    return Feature(
        id: Helper.keyExists<int>(json, 'id'),
        name: Helper.keyExists<String>(json, 'name'),
        description: Helper.keyExists<String>(json, 'description'),
        projectId: Helper.keyExists<int>(json, 'projectId'));
  }

  Feature copyWith({
    int? id,
    String? name,
    String? description,
    int? projectId,
  }) {
    return Feature(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      projectId: projectId ?? projectId,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
    };
  }

  factory Feature.fake() {
    return Feature(
      id: 1,
      name: "Feature FAKE",
      description: "Feature false",
    );
  }
}
/*
Para criar a feature:
{
    "name": "Feature 03",
    "description": "Essa feature é foda",
    "projectId": 1
}
Recebe da api:
{
    "id": 1,
    "name": "Feature 01",
    "description": "Essa feature 01 é foda"
  }
*/
