// lib/models/task/task_type.dart

class TaskType {
  final String id;
  final String companyId;
  final String taskName;
  final String taskDescription;
  final DateTime createdAt;
  final DateTime updatedAt;

  TaskType({
    required this.id,
    required this.companyId,
    required this.taskName,
    required this.taskDescription,
    required this.createdAt,
    required this.updatedAt,
  });

  factory TaskType.fromJson(Map<String, dynamic> json) {
    return TaskType(
      id: json['id'] ?? '',
      companyId: json['company_id'] ?? '',
      taskName: json['task_name'] ?? '',
      taskDescription: json['task_description'] ?? '',
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updated_at'] ?? '') ?? DateTime.now(),
    );
  }
}
