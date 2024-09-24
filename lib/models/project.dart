import 'dart:convert';

import 'package:scrumflow/utils/utils.dart';

class Project {
  final int? id;
  final String? name;
  final String? description;
  final DateTime? startDate;
  final DateTime? endDate;
  final bool? active;

  Project(
      {this.id,
      this.name,
      this.description,
      this.startDate,
      this.endDate,
      this.active});

  factory Project.fromJsonObject(Map<String, dynamic> json) {
    return Project(
      id: JsonHelper.keyExists<int>(json, 'id'),
      name: JsonHelper.keyExists<String>(json, 'name'),
      description: JsonHelper.keyExists<String>(json, 'description'),
      startDate: JsonHelper.toDateTime(JsonHelper.keyExists(json, 'startDate')),
      endDate: JsonHelper.toDateTime(JsonHelper.keyExists(json, 'endDate')),
      active: JsonHelper.keyExists(json, 'active') ?? true,
    );
  }

  static List<Project> fromJson(String jsonBody) {
    List<Project> lista = [];

    var jsonPronto = jsonDecode(jsonBody);

    for (var item in jsonPronto) {
      lista.add(Project.fromJsonObject(item));
    }

    return lista;
  }

  Project copyWith({
    int? id,
    String? name,
    String? description,
    DateTime? startDate,
    DateTime? endDate,
    bool? active,
  }) {
    return Project(
        id: id ?? this.id,
        name: name ?? this.name,
        description: description ?? this.description,
        startDate: startDate ?? this.startDate,
        endDate: endDate ?? this.endDate,
        active: active ?? this.active);
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'startDate': startDate?.toYYYYMMDD ?? '',
      'endDate': endDate?.toYYYYMMDD ?? '',
      'active': active
    };
  }

  Project.fake()
      : id = -1,
        name = "Projeto fake",
        description = "Esse Projeto é falsa",
        startDate = DateTime.now(),
        endDate = DateTime.now().copyWith(year: 2025),
        active = true;
}
