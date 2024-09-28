import 'package:scrumflow/utils/helper.dart';
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
      id: JsonHelper.keyExists<int>(json, 'id'),
      name: JsonHelper.keyExists<String>(json, 'name'),
      description: JsonHelper.keyExists<String>(json, 'description'),
      startDate: JsonHelper.toDateTime(JsonHelper.keyExists(json, 'startDate')),
      endDate: JsonHelper.toDateTime(JsonHelper.keyExists(json, 'endDate')),
      active: JsonHelper.toBool(JsonHelper.keyExists(json, 'active')),
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
