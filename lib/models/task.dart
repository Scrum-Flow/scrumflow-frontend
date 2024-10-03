import 'package:scrumflow/utils/utils.dart';

class Task {
  final int? id;
  final String? name;
  final String? description;
  final int? estimatePoints;
  final String? status;

  var assignedUser;
  var assignedFeature;

  Task({
    this.id,
    this.name,
    this.description,
    this.estimatePoints,
    this.assignedUser,
    this.assignedFeature,
    this.status,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
        id: JsonHelper.keyExists<int>(json, 'id'),
        name: JsonHelper.keyExists<String>(json, 'name'),
        description: JsonHelper.keyExists<String>(json, 'description'),
        estimatePoints: JsonHelper.keyExists<int>(json, 'estimatePoints'),
        assignedUser: JsonHelper.keyExists<String>(json, 'assignedToUserName'),
        assignedFeature: JsonHelper.keyExists<String>(json, 'featureName'),
        status: 'STATUS');
  }

  Task copyWith({
    int? id,
    String? name,
    String? description,
    int? estimatePoints,
    String? status,
    var assignedUser,
    var assignedFeature,
  }) {
    return Task(
        id: id ?? this.id,
        name: name ?? this.name,
        description: description ?? this.description,
        estimatePoints: estimatePoints ?? this.estimatePoints,
        assignedUser: assignedUser ?? this.assignedUser,
        assignedFeature: assignedFeature ?? this.assignedFeature,
        status: status ?? 'STATUS');
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'estimatePoints': estimatePoints,
      'assignedToUserId': assignedUser,
      'featureId': assignedFeature,
    };
  }
}
/*
Para criar a task tem que ser:
{
    "name":"Tarefa 2",
    "description": "Essa é a tarefa 2",
    "estimatePoints": 2,
    "featureId": 1,
    "assignedToUserId": 1
}
O que recebe da api:
{
    "id": 2,
    "name": "Tarefa 2",
    "description": "Essa é a tarefa 2",
    "estimatePoints": 2,
    "featureName": "Feature 01",
    "assignedToUserName": "Gabriel",
    "createdAt": null,
    "updatedAt": null
}
 */
