import 'package:scrumflow/utils/utils.dart';

class TaskHistory {
  final int? id;
  final int? taskId;
  final String? userName;
  final String? fromStatus;
  final String? toStatus;
  final DateTime? movedAt;

  TaskHistory({
    this.id,
    this.taskId,
    this.userName,
    this.fromStatus,
    this.toStatus,
    this.movedAt,
  });

  factory TaskHistory.fromJson(Map<String, dynamic> json) {
    return TaskHistory(
      id: Helper.keyExists<int>(json, 'id'),
      taskId: Helper.keyExists<int>(json, 'taskId'),
      userName: Helper.keyExists<String>(json, 'userName'),
      fromStatus: Helper.keyExists<String>(json, 'fromStatus'),
      toStatus: Helper.keyExists<String>(json, 'toStatus'),
      movedAt: Helper.toDateTime(Helper.keyExists(json, 'movedAt')),
    );
  }
}
