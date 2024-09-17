import 'package:scrumflow/utils/helper.dart';
import 'package:scrumflow/utils/utils.dart';

class Project {
  final int? id;
  final String? name;
  final String? description;
  final DateTime? startDate;
  final DateTime? endDate;

  Project({
    this.id,
    this.name,
    this.description,
    this.startDate,
    this.endDate,
  });

  factory Project.fromJson(Map<String, dynamic> json) {
    return Project(
      id: JsonHelper.keyExists<int>(json, 'id'),
      name: JsonHelper.keyExists<String>(json, 'name'),
      description: JsonHelper.keyExists<String>(json, 'description'),
      startDate: JsonHelper.toDateTime(JsonHelper.keyExists(json, 'startDate')),
      endDate: JsonHelper.toDateTime(JsonHelper.keyExists(json, 'endDate')),
    );
  }

  Project copyWith({
    int? id,
    String? name,
    String? description,
    DateTime? startDate,
    DateTime? endDate,
  }) {
    return Project(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'startDate': Helper.schemaDate(startDate),
      'endDate': Helper.schemaDate(endDate),
    };
  }
}
