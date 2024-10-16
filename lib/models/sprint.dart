import 'package:scrumflow/utils/utils.dart';

class Sprint {
  final int? id;
  final String? name;
  final String? description;
  final String? status;
  final DateTime? startDate;
  final DateTime? endDate;
  final int? projectId;

  Sprint({
    this.id,
    this.name,
    this.description,
    this.status,
    this.startDate,
    this.endDate,
    this.projectId,
  });

  factory Sprint.fromJson(Map<String, dynamic> json) {
    return Sprint(
      id: Helper.keyExists<int>(json, 'id'),
      name: Helper.keyExists<String>(json, 'name'),
      description: Helper.keyExists<String>(json, 'description'),
      status: Helper.keyExists<String>(json, 'status'),
      startDate: Helper.toDateTime(Helper.keyExists(json, 'startDate')),
      endDate: Helper.toDateTime(Helper.keyExists(json, 'endDate')),
      projectId: Helper.keyExists<int>(json, 'projectId'),
    );
  }

  Sprint copyWith({
    int? id,
    String? name,
    String? description,
    String? status,
    DateTime? startDate,
    DateTime? endDate,
    int? projectId,
  }) {
    return Sprint(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      status: status ?? this.status,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      projectId: id ?? this.projectId,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'status': status,
      'startDate': Helper.schemaDate(startDate),
      'endDate': Helper.schemaDate(endDate),
      'projectId': projectId,
    };
  }

  @override
  String toString() {
    return name ?? '';
  }
}
