import 'package:scrumflow/utils/json_helper.dart';

class Feature {
  final int? id;
  final String? name;
  final String? description;

  Feature({
    this.id,
    this.name,
    this.description,
  });

  factory Feature.fromJson(Map<String, dynamic> json) {
    return Feature(
      id: JsonHelper.keyExists<int>(json, 'id'),
      name: JsonHelper.keyExists<String>(json, 'name'),
      description: JsonHelper.keyExists<String>(json, 'description'),
    );
  }

  Feature copyWith({
    int? id,
    String? name,
    String? description,
  }) {
    return Feature(
        id: id ?? this.id,
        name: name ?? this.name,
        description: description ?? this.description);
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
      id: 0,
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
