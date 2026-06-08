import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../models/activity_model.dart';

final taskListProvider = StateNotifierProvider<TaskNotifier, List<ActivityModel>>((ref) {
  return TaskNotifier();
});

class TaskNotifier extends StateNotifier<List<ActivityModel>> {
  TaskNotifier() : super(_defaultTasks);

  static final _defaultTasks = [
    const ActivityModel(id: 'a1', title: 'Data sync complete',
      timestamp: 'Jun 02, 11:40 PM', status: ActivityStatus.done, initial: 'D', priority: TaskPriority.low),
    const ActivityModel(id: 'a2', title: 'System check',
      timestamp: 'Jun 02, 10:45 PM', status: ActivityStatus.pending, initial: 'S', priority: TaskPriority.high),
    const ActivityModel(id: 'a3', title: 'User upload complete',
      timestamp: 'Jun 02, 09:45 PM', status: ActivityStatus.done, initial: 'U', priority: TaskPriority.medium),
    const ActivityModel(id: 'a4', title: 'Weekly report generated',
      timestamp: 'Jun 01, 11:45 PM', status: ActivityStatus.done, initial: 'W'),
    const ActivityModel(id: 'a5', title: 'Performance review submitted',
      timestamp: 'Jun 01, 08:20 PM', status: ActivityStatus.done, initial: 'P'),
    const ActivityModel(id: 'a6', title: 'Team sync meeting',
      timestamp: 'May 31, 03:00 PM', status: ActivityStatus.inProgress, initial: 'T'),
  ];

  // ✅ Add new task
  void addTask(String title, [DateTime? date]) {
    final now = date ?? DateTime.now();
    final formatted = DateFormat('MMM dd, hh:mm a').format(now);
    state = [
      ActivityModel(
        id: 'a_${now.millisecondsSinceEpoch}',
        title: title, timestamp: formatted,
        status: ActivityStatus.pending,
        initial: title.isNotEmpty ? title[0].toUpperCase() : 'T',
      ),
      ...state,
    ];
  }

  // ✅ Toggle task done/pending
  void toggleStatus(String id) {
    state = state.map((task) {
      if (task.id != id) return task;
      final next = task.status == ActivityStatus.done
          ? ActivityStatus.pending : ActivityStatus.done;
      return ActivityModel(
        id: task.id, title: task.title,
        timestamp: task.timestamp, status: next,
        initial: task.initial,
        priority: task.priority,
      );
    }).toList();
  }

  // ✅ Delete task
  void deleteTask(String id) {
    state = state.where((t) => t.id != id).toList();
  }

  // ✅ Reorder tasks
  void reorderTasks(int oldIndex, int newIndex) {
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    final items = List<ActivityModel>.from(state);
    final item = items.removeAt(oldIndex);
    items.insert(newIndex, item);
    state = items;
  }

  // ✅ Edit task
  void editTask(String id, String newTitle, TaskPriority newPriority) {
    state = state.map((task) {
      if (task.id == id) {
        return ActivityModel(
          id: task.id, title: newTitle, timestamp: task.timestamp,
          status: task.status, initial: newTitle.isNotEmpty ? newTitle[0].toUpperCase() : 'T',
          priority: newPriority,
        );
      }
      return task;
    }).toList();
  }
}

// Completion percent derived (0.0 to 1.0)
final completionProvider = Provider<double>((ref) {
  final tasks = ref.watch(taskListProvider);
  if (tasks.isEmpty) return 0.0;
  final done = tasks.where((t) => t.status == ActivityStatus.done).length;
  return done / tasks.length;
});
