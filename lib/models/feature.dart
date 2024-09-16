import 'dart:convert';

import 'package:scrumflow/utils/utils.dart';

class Feature {
  final int? id;
  final String? name;
  final String? description;
  final int? projectId;

  Feature({this.id, this.name, this.description, this.projectId});

  factory Feature.fromJsonObject(Map<String, dynamic> json) {
    return Feature(
        id: JsonHelper.keyExists<int>(json, 'id'),
        name: JsonHelper.keyExists<String>(json, 'name'),
        description: JsonHelper.keyExists<String>(json, 'description'),
        projectId: JsonHelper.keyExists<int>(json, 'projectId'));
  }

  static List<Feature> fromJson(String jsonBody) {
    List<Feature> lista = [];

    var jsonPronto = jsonDecode(jsonBody);

    for (var item in jsonPronto) {
      lista.add(Feature.fromJsonObject(item));
    }

    return lista;
  }

  Feature copyWith(
      {int? id, String? name, String? description, int? projectId}) {
    return Feature(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      projectId: projectId ?? projectId,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'projectId': projectId,
    };
  }
}
