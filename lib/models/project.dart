import 'package:scrumflow/utils/utils.dart';

class Project {
  final int? id;
  final String? name;
  final String? description;
  final DateTime? startDate;
  final DateTime? endDate;
  final bool? active;

  Project({
    this.id,
    this.name,
    this.description,
    this.startDate,
    this.endDate,
    this.active = true,
  });

  factory Project.fromJson(Map<String, dynamic> json) {
    return Project(
      id: Helper.keyExists<int>(json, 'id'),
      name: Helper.keyExists<String>(json, 'name'),
      description: Helper.keyExists<String>(json, 'description'),
      startDate: Helper.toDateTime(Helper.keyExists(json, 'startDate')),
      endDate: Helper.toDateTime(Helper.keyExists(json, 'endDate')),
      active: Helper.toBool(Helper.keyExists(json, 'active')),
    );
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
      active: active ?? this.active,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'startDate': Helper.schemaDate(startDate),
      'endDate': Helper.schemaDate(endDate),
      'active': active,
    };
  }

  @override
  String toString() {
    return name ?? '';
  }
}
/*
Para criar um project:
{
    "name": "ProjetoTeste01",
    "description": "Este projeto é um teste",
    "startDate": "2024-10-10",
    "endDate": "2024-11-10",
    "active": true
    + Usuarios (a fazer)
}

Recebe da api:
{
  "id": 1,
  "name": "ProjetoTeste01",
  "description": "Este projeto é um teste",
  "startDate": "2024-10-10",
  "endDate": "2024-11-10",
  "active": true
}
 */
