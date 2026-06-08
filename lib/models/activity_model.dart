class ActivityModel {
  final String id;
  final String title;        // ✅ non-null, has default
  final String timestamp;    // ✅ non-null, has default
  final ActivityStatus status;
  final String initial;      // for avatar letter
  final TaskPriority priority;

  const ActivityModel({
    required this.id,
    required this.title,
    required this.timestamp,
    required this.status,
    required this.initial,
    this.priority = TaskPriority.medium,
  });

  // ✅ Safe factory
  factory ActivityModel.fromMap(Map<String, dynamic> map) {
    return ActivityModel(
      id: (map['id'] as String?) ?? 'act_${DateTime.now().millisecondsSinceEpoch}',
      title: (map['title'] as String?) ?? 'Activity',
      timestamp: (map['timestamp'] as String?) ?? 'Just now',
      status: ActivityStatus.values.firstWhere(
        (e) => e.name == (map['status'] as String?),
        orElse: () => ActivityStatus.pending,
      ),
      initial: (map['initial'] as String?) ?? 'A',
      priority: TaskPriority.values.firstWhere(
        (e) => e.name == (map['priority'] as String?),
        orElse: () => TaskPriority.medium,
      ),
    );
  }
}

enum ActivityStatus { done, pending, inProgress, failed }
enum TaskPriority { high, medium, low }
