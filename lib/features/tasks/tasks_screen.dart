import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_typography.dart';
import '../../core/providers/task_provider.dart';
import '../../core/providers/theme_provider.dart';
import '../../models/activity_model.dart';
import '../../core/providers/nav_state_provider.dart';
import '../../shared/widgets/lottie_hamburger.dart';

class TasksScreen extends ConsumerStatefulWidget {
  const TasksScreen({super.key});

  @override
  ConsumerState<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends ConsumerState<TasksScreen> {
  void _showTaskSheet({ActivityModel? existingTask}) {
    ref.read(navVisibleProvider.notifier).state = false;
    
    final titleCtrl = TextEditingController(text: existingTask?.title ?? '');
    TaskPriority selectedPriority = existingTask?.priority ?? TaskPriority.medium;
    final isDark = ref.read(themeProvider) == ThemeMode.dark;

    showModalBottomSheet(
      context: context,
      useRootNavigator: true,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setSheetState) {
            return Padding(
              padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
              child: Container(
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
                ),
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 40, height: 4,
                      decoration: BoxDecoration(
                        color: isDark ? Colors.white24 : Colors.black12,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(existingTask == null ? 'New Task' : 'Edit Task', 
                      style: AppTypography.h2(Theme.of(context).colorScheme.onSurface)),
                    const SizedBox(height: 16),
                    TextField(
                      controller: titleCtrl,
                      autofocus: true,
                      decoration: InputDecoration(
                        hintText: 'Task name...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: const BorderSide(color: AppColors.neonCyan),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Priority selector
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: TaskPriority.values.map((p) {
                        final isSelected = selectedPriority == p;
                        Color pColor;
                        if (p == TaskPriority.high) {
                          pColor = AppColors.neonCoral;
                        } else if (p == TaskPriority.medium) { pColor = AppColors.neonAmber; }
                        else { pColor = AppColors.neonGreen; }

                        return Expanded(
                          child: GestureDetector(
                            onTap: () => setSheetState(() => selectedPriority = p),
                            child: Container(
                              margin: const EdgeInsets.symmetric(horizontal: 4),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(
                                color: isSelected ? pColor.withValues(alpha: 0.2) : Colors.transparent,
                                border: Border.all(color: isSelected ? pColor : Colors.grey.withValues(alpha: 0.3)),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Center(
                                child: Text(
                                  p.name.toUpperCase(),
                                  style: AppTypography.label(Theme.of(context).colorScheme.onSurface).copyWith(
                                    color: isSelected ? pColor : Theme.of(context).colorScheme.onSurface,
                                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.all(16),
                          backgroundColor: AppColors.neonCyan,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        ),
                        onPressed: () {
                          if (titleCtrl.text.trim().isNotEmpty) {
                            if (existingTask == null) {
                              // We need to pass priority to addTask if we modify provider, but for now we can just use edit
                              ref.read(taskListProvider.notifier).addTask(titleCtrl.text.trim());
                              // hack: update the priority of the newest task
                              final tasks = ref.read(taskListProvider);
                              if (tasks.isNotEmpty) {
                                ref.read(taskListProvider.notifier).editTask(tasks.first.id, titleCtrl.text.trim(), selectedPriority);
                              }
                            } else {
                              ref.read(taskListProvider.notifier).editTask(existingTask.id, titleCtrl.text.trim(), selectedPriority);
                            }
                            Navigator.pop(ctx);
                            HapticFeedback.mediumImpact();
                          }
                        },
                        child: Text(existingTask == null ? 'Add Task' : 'Save Changes',
                          style: AppTypography.h3(Theme.of(context).colorScheme.onSurface).copyWith(color: Colors.black)),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
        );
      },
    ).then((_) {
      if (mounted) {
        ref.read(navVisibleProvider.notifier).state = true;
      }
    });
  }

  Color _getPriorityColor(TaskPriority p) {
    if (p == TaskPriority.high) return AppColors.neonCoral;
    if (p == TaskPriority.medium) return AppColors.neonAmber;
    return AppColors.neonGreen;
  }

  @override
  Widget build(BuildContext context) {
    final tasks = ref.watch(taskListProvider);
    final isDark = ref.watch(themeProvider) == ThemeMode.dark;

    return Scaffold(
      appBar: AppBar(
        leading: const LottieHamburger(),
        title: const Text('My Tasks'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_task_rounded, color: AppColors.neonCyan),
            onPressed: () => _showTaskSheet(),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: tasks.isEmpty
        ? Center(
            child: Text('No tasks found.', style: AppTypography.body(Theme.of(context).colorScheme.onSurface)),
          )
        : ReorderableListView.builder(
            padding: EdgeInsets.only(bottom: 100 + MediaQuery.of(context).padding.bottom, top: 16),
            itemCount: tasks.length,
            // ignore: deprecated_member_use
            onReorder: (oldIndex, newIndex) {
              ref.read(taskListProvider.notifier).reorderTasks(oldIndex, newIndex);
              HapticFeedback.lightImpact();
            },
            itemBuilder: (context, index) {
              final task = tasks[index];
              final pColor = _getPriorityColor(task.priority);

              return Dismissible(
                key: Key(task.id),
                direction: DismissDirection.endToStart,
                background: Container(
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 24),
                  color: AppColors.neonCoral.withValues(alpha: 0.2),
                  child: const Icon(Icons.delete_rounded, color: AppColors.neonCoral),
                ),
                onDismissed: (_) {
                  ref.read(taskListProvider.notifier).deleteTask(task.id);
                  HapticFeedback.mediumImpact();
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.darkCard : AppColors.lightCard,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: pColor.withValues(alpha: 0.3)),
                    boxShadow: [
                      BoxShadow(
                        color: pColor.withValues(alpha: 0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      )
                    ],
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    leading: GestureDetector(
                      onTap: () {
                        ref.read(taskListProvider.notifier).toggleStatus(task.id);
                        HapticFeedback.lightImpact();
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        width: 24, height: 24,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: task.status == ActivityStatus.done ? pColor : Colors.transparent,
                          border: Border.all(color: pColor, width: 2),
                        ),
                        child: task.status == ActivityStatus.done
                            ? const Icon(Icons.check, size: 16, color: Colors.white)
                            : null,
                      ),
                    ),
                    title: Text(
                      task.title,
                      style: AppTypography.h3(Theme.of(context).colorScheme.onSurface).copyWith(
                        decoration: task.status == ActivityStatus.done ? TextDecoration.lineThrough : null,
                        color: task.status == ActivityStatus.done ? Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5) : Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: Row(
                        children: [
                          const Icon(Icons.schedule, size: 12, color: AppColors.lightSubtext),
                          const SizedBox(width: 4),
                          Text(task.timestamp, style: AppTypography.bodySmall(Theme.of(context).colorScheme.onSurface)),
                          const SizedBox(width: 12),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: pColor.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(task.priority.name.toUpperCase(), 
                              style: TextStyle(fontSize: 10, color: pColor, fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit_outlined, size: 20),
                          color: AppColors.lightSubtext,
                          onPressed: () => _showTaskSheet(existingTask: task),
                        ),
                        const Icon(Icons.drag_indicator, color: AppColors.lightSubtext),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
    );
  }
}
