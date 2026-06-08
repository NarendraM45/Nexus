import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lottie/lottie.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/providers/task_provider.dart';
import '../../../core/providers/nav_state_provider.dart';
import '../../../models/activity_model.dart';
import '../../shared/widgets/lottie_hamburger.dart';

class CalendarScreen extends ConsumerStatefulWidget {
  const CalendarScreen({super.key});

  @override
  ConsumerState<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends ConsumerState<CalendarScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  CalendarFormat _calFormat = CalendarFormat.month;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final allTasks = ref.watch(taskListProvider);
    final tasksByDate = _groupByDate(allTasks);
    final selectedTasks = _selectedDay != null
        ? (tasksByDate[_normalizeDate(_selectedDay!)] ?? [])
        : (tasksByDate[_normalizeDate(_focusedDay)] ?? []);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // AppBar with Lottie
            SliverAppBar(
              pinned: true,
              backgroundColor: Colors.transparent,
              leading: const LottieHamburger(),
              title: Row(children: [
                Text('Calendar',
                  style: Theme.of(context).textTheme.headlineLarge),
                const Spacer(),
                SizedBox(
                  width: 36, height: 36,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width: 36, height: 36,
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      Lottie.asset('assets/lottie/calendar_icon.json',
                        width: 36, height: 36,
                        repeat: true,
                        errorBuilder: (ctx, err, stack) => const Icon(Icons.calendar_today_rounded, color: AppColors.neonCyan),
                      ),
                    ],
                  ),
                ),
              ]),
            ),

            SliverToBoxAdapter(
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.darkCard : AppColors.lightCard,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
                    ),
                    child: TableCalendar<ActivityModel>(
                      firstDay: DateTime.utc(2024, 1, 1),
                      lastDay: DateTime.utc(2027, 12, 31),
                      focusedDay: _focusedDay,
                      selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                      calendarFormat: _calFormat,
                      onFormatChanged: (f) => setState(() => _calFormat = f),
                      onDaySelected: (sel, foc) {
                        setState(() {
                          _selectedDay = sel;
                          _focusedDay = foc;
                        });
                        HapticFeedback.selectionClick();
                      },
                      eventLoader: (day) =>
                        tasksByDate[_normalizeDate(day)] ?? [],

                      calendarStyle: CalendarStyle(
                        outsideDaysVisible: false,
                        todayDecoration: const BoxDecoration(
                          gradient: AppColors.primaryGrad,
                          shape: BoxShape.circle),
                        selectedDecoration: const BoxDecoration(
                          gradient: AppColors.warmGrad,
                          shape: BoxShape.circle),
                        markerDecoration: const BoxDecoration(
                          color: AppColors.neonAmber,
                          shape: BoxShape.circle),
                        defaultTextStyle: TextStyle(
                          color: Theme.of(context).colorScheme.onSurface),
                        weekendTextStyle: const TextStyle(
                          color: AppColors.neonCoral),
                        outsideTextStyle: TextStyle(
                          color: Theme.of(context).colorScheme.onSurface
                            .withValues(alpha: 0.3)),
                        todayTextStyle: const TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w700),
                        selectedTextStyle: const TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w700),
                      ),
                      headerStyle: HeaderStyle(
                        formatButtonVisible: true,
                        titleCentered: true,
                        titleTextStyle: GoogleFonts.sora(
                          color: Theme.of(context).colorScheme.onSurface,
                          fontWeight: FontWeight.w700, fontSize: 16),
                        leftChevronIcon: const Icon(Icons.chevron_left_rounded,
                          color: AppColors.neonCyan),
                        rightChevronIcon: const Icon(Icons.chevron_right_rounded,
                          color: AppColors.neonCyan),
                        formatButtonDecoration: BoxDecoration(
                          border: Border.all(color: AppColors.neonCyan),
                          borderRadius: BorderRadius.circular(12)),
                        formatButtonTextStyle: const TextStyle(
                          color: AppColors.neonCyan, fontSize: 12),
                      ),
                    ),
                  ),

                  // Tasks for selected day
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        Text(
                          _selectedDay != null
                            ? DateFormat('MMMM d').format(_selectedDay!)
                            : 'Today',
                          style: Theme.of(context).textTheme.headlineMedium),
                        const Spacer(),
                        Text('${selectedTasks.length} tasks',
                          style: const TextStyle(color: AppColors.neonCyan)),
                        const SizedBox(width: 8),
                        // Lottie add button
                        GestureDetector(
                          onTap: () => _showAddTaskForDate(
                            context, _selectedDay ?? _focusedDay),
                          child: Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.neonCyan.withValues(alpha: 0.12),
                              border: Border.all(
                                color: AppColors.neonCyan.withValues(alpha: 0.4),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.neonCyan.withValues(alpha: 0.2),
                                  blurRadius: 10,
                                  spreadRadius: 1,
                                ),
                              ],
                            ),
                            child: Lottie.asset(
                              'assets/lottie/add.json',
                              width: 24,
                              height: 24,
                              repeat: true,
                              animate: true,
                              errorBuilder: (ctx, err, stack) => const Icon(
                                Icons.add_rounded,
                                color: AppColors.neonCyan,
                                size: 20,
                              ),
                            ),
                          ),
                        )
                          .animate()
                          .fadeIn(duration: 400.ms)
                          .scale(
                            begin: const Offset(0.0, 0.0),
                            end: const Offset(1.0, 1.0),
                            duration: 500.ms,
                            curve: Curves.elasticOut,
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            ),

            // Task list for selected date
            selectedTasks.isEmpty
              ? SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 40),
                    child: Column(
                      children: [
                        // Glowing Lottie container
                        Container(
                          width: 180, height: 180,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.neonCyan.withValues(alpha: 0.15),
                                blurRadius: 40,
                                spreadRadius: 10,
                              ),
                            ],
                          ),
                          child: Lottie.asset(
                            'assets/lottie/empty_box.json',
                            width: 160,
                            height: 160,
                            repeat: true,
                            animate: true,
                            errorBuilder: (ctx, err, stack) => const Icon(
                              Icons.event_available_rounded,
                              size: 80,
                              color: AppColors.neonCyan,
                            ),
                          ),
                        )
                          .animate()
                          .fadeIn(duration: 600.ms, curve: Curves.easeOut)
                          .scale(
                            begin: const Offset(0.6, 0.6),
                            end: const Offset(1.0, 1.0),
                            duration: 700.ms,
                            curve: Curves.elasticOut,
                          )
                          .shimmer(
                            delay: 800.ms,
                            duration: 1800.ms,
                            color: AppColors.neonCyan.withValues(alpha: 0.15),
                          ),
                        const SizedBox(height: 24),
                        Text('No tasks on this day',
                          style: Theme.of(context).textTheme.headlineMedium)
                          .animate()
                          .fadeIn(delay: 300.ms, duration: 500.ms)
                          .slideY(begin: 0.3, end: 0),
                        const SizedBox(height: 8),
                        Text('Tap + to add one',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
                          ))
                          .animate()
                          .fadeIn(delay: 500.ms, duration: 500.ms)
                          .slideY(begin: 0.3, end: 0),
                      ],
                    ),
                  ),
                )
              : SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 120),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (ctx, i) => _CalendarTaskTile(
                        task: selectedTasks[i],
                        onToggle: () => ref
                          .read(taskListProvider.notifier)
                          .toggleStatus(selectedTasks[i].id),
                        onDelete: () => ref
                          .read(taskListProvider.notifier)
                          .deleteTask(selectedTasks[i].id),
                      ).animate(delay: (80 * i).ms).fadeIn().slideX(begin: 0.3),
                      childCount: selectedTasks.length,
                    ),
                  ),
                ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 80.0), // Lift it above nav menu
        child: Hero(
          tag: 'calendar_fab',
          child: FloatingActionButton.extended(
            onPressed: () => _showAddTaskForDate(
              context, _selectedDay ?? _focusedDay),
            icon: SizedBox(
              width: 24, height: 24,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(color: Colors.transparent, width: 24, height: 24),
                  Lottie.asset('assets/lottie/add.json',
                    width: 24, height: 24,
                    repeat: true,
                    errorBuilder: (ctx, err, stack) => const Icon(Icons.add_rounded),
                  ),
                ],
              ),
            ),
            label: const Text('Add Task'),
            backgroundColor: AppColors.neonCyan,
            foregroundColor: Colors.black,
          ),
        ),
      ),
    );
  }

  Map<DateTime, List<ActivityModel>> _groupByDate(List<ActivityModel> tasks) {
    final map = <DateTime, List<ActivityModel>>{};
    final now = DateTime.now();
    for (int i = 0; i < tasks.length; i++) {
      final date = _normalizeDate(now.subtract(Duration(days: i % 7)));
      map[date] = [...(map[date] ?? []), tasks[i]];
    }
    return map;
  }

  DateTime _normalizeDate(DateTime d) => DateTime(d.year, d.month, d.day);

  void _showAddTaskForDate(BuildContext ctx, DateTime initialDate) {
    ref.read(navVisibleProvider.notifier).state = false;
    
    final ctrl = TextEditingController();
    DateTime selectedDate = initialDate;
    
    showModalBottomSheet(
      context: ctx,
      useRootNavigator: true,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,

      builder: (_) => StatefulBuilder(
        builder: (context, setModalState) {
          return Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(ctx).viewInsets.bottom),
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(ctx).cardColor,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(28))),
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Add Task',
                      style: Theme.of(ctx).textTheme.headlineMedium),
                    TextButton.icon(
                      icon: const Icon(Icons.calendar_month_rounded, size: 18),
                      label: Text(DateFormat('MMM d').format(selectedDate)),
                      onPressed: () async {
                        final dt = await showDatePicker(
                          context: ctx,
                          initialDate: selectedDate,
                          firstDate: DateTime(2020),
                          lastDate: DateTime(2030),
                        );
                        if (dt != null) {
                          setModalState(() => selectedDate = dt);
                        }
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                TextField(controller: ctrl, autofocus: true,
                  decoration: InputDecoration(
                    hintText: 'What needs to be done?',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: const BorderSide(color: AppColors.neonCyan)))),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(16),
                      backgroundColor: AppColors.neonCyan,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16))),
                    onPressed: () {
                      if (ctrl.text.trim().isNotEmpty) {
                        ref.read(taskListProvider.notifier).addTask(ctrl.text.trim(), selectedDate);
                        Navigator.pop(ctx);
                      }
                    },
                    child: const Text('Add Task',
                      style: TextStyle(color: Colors.black, fontWeight: FontWeight.w700)),
                  ),
                ),
              ]),
            ),
          );
        }
      ),
    ).then((_) {
      if (mounted) {
        ref.read(navVisibleProvider.notifier).state = true;
      }
    });
  }
}

class _CalendarTaskTile extends StatelessWidget {
  final ActivityModel task;
  final VoidCallback onToggle;
  final VoidCallback onDelete;

  const _CalendarTaskTile({
    required this.task,
    required this.onToggle,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final isDone = task.status == ActivityStatus.done;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Dismissible(
      key: ValueKey(task.id),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => onDelete(),
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: AppColors.neonCoral.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Icon(Icons.delete_sweep_rounded, color: AppColors.neonCoral),
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkCard : AppColors.lightCard,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDone 
              ? AppColors.neonGreen.withValues(alpha: 0.3)
              : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
          ),
        ),
        child: ListTile(
          onTap: onToggle,
          leading: Container(
            width: 40, height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isDone ? AppColors.neonGreen.withValues(alpha: 0.2) : AppColors.neonCyan.withValues(alpha: 0.1),
            ),
            child: Icon(
              isDone ? Icons.check_rounded : Icons.circle_outlined,
              color: isDone ? AppColors.neonGreen : AppColors.neonCyan,
            ),
          ),
          title: Text(
            task.title,
            style: GoogleFonts.sora(
              fontWeight: FontWeight.w600,
              decoration: isDone ? TextDecoration.lineThrough : null,
              color: isDone ? Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5) : Theme.of(context).colorScheme.onSurface,
            ),
          ),
          subtitle: Text(
            task.timestamp,
            style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5), fontSize: 12),
          ),
          trailing: IconButton(
            icon: const Icon(Icons.delete_outline_rounded, color: AppColors.neonCoral, size: 20),
            onPressed: onDelete,
          ),
        ),
      ),
    );
  }
}
