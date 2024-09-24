import 'dart:convert';

import 'package:scrumflow/utils/utils.dart';

class Sprint {
  final int? id;
  final String? name;
  final String? description;
  final DateTime? startDate;
  final DateTime? endDate;
  final int? projectId;

  Sprint(
      {this.id,
      this.name,
      this.description,
      this.startDate,
      this.endDate,
      this.projectId});

  factory Sprint.fromJsonObject(Map<String, dynamic> json) {
    return Sprint(
        id: JsonHelper.keyExists<int>(json, 'id'),
        name: JsonHelper.keyExists<String>(json, 'name'),
        description: JsonHelper.keyExists<String>(json, 'description'),
        startDate:
            JsonHelper.toDateTime(JsonHelper.keyExists(json, 'startDate')),
        endDate: JsonHelper.toDateTime(JsonHelper.keyExists(json, 'endDate')),
        projectId: JsonHelper.keyExists<int>(json, 'projectId'));
  }

  static List<Sprint> fromJson(String jsonBody) {
    List<Sprint> lista = [];

    var jsonPronto = jsonDecode(jsonBody);

    for (var item in jsonPronto) {
      lista.add(Sprint.fromJsonObject(item));
    }

    return lista;
  }

  Sprint copyWith(
      {int? id,
      String? name,
      String? description,
      DateTime? startDate,
      DateTime? endDate,
      int? projectId}) {
    return Sprint(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      projectId: projectId ?? projectId,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'startDate': startDate?.toYYYYMMDD ?? '',
      'endDate': endDate?.toYYYYMMDD ?? '',
      'projectId': projectId,
    };
  }

  Sprint.fake()
      : id = -1,
        name = "Sprint fake",
        description = "Essa Sprint é falsa",
        startDate = DateTime.now(),
        endDate = DateTime.now().copyWith(year: 2025),
        projectId = -1;
}
