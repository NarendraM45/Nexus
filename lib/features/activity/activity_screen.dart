import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_typography.dart';
import '../../core/providers/task_provider.dart';
import '../../core/providers/theme_provider.dart';
import '../../models/activity_model.dart';
import 'package:confetti/confetti.dart';
import '../../shared/widgets/custom/safe_lottie.dart';
import '../home/widgets/recent_activity_tile.dart';
import 'widgets/neon_progress_ring.dart';
import '../../shared/widgets/lottie_hamburger.dart';

class ActivityScreen extends ConsumerStatefulWidget {
  const ActivityScreen({super.key});

  @override
  ConsumerState<ActivityScreen> createState() => _ActivityScreenState();
}

class _ActivityScreenState extends ConsumerState<ActivityScreen> {
  late ConfettiController _confettiCtrl;

  @override
  void initState() {
    super.initState();
    _confettiCtrl = ConfettiController(duration: const Duration(seconds: 1));
  }

  @override
  void dispose() {
    _confettiCtrl.dispose();
    super.dispose();
  }

  void _showAddTaskSheet() {
    final ctrl = TextEditingController();
    final isDark = ref.read(themeProvider) == ThemeMode.dark;
    
    showModalBottomSheet(
      context: context,
      useRootNavigator: true,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom),
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
              Text('New Task', style: AppTypography.h2(Theme.of(context).colorScheme.onSurface)),
              const SizedBox(height: 16),
              TextField(
                controller: ctrl,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: 'e.g. Complete Week 2 assignment',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(color: AppColors.neonCyan),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(16),
                    backgroundColor: AppColors.neonCyan,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  ),
                  onPressed: () {
                    if (ctrl.text.trim().isNotEmpty) {
                      ref.read(taskListProvider.notifier).addTask(ctrl.text.trim());
                      Navigator.pop(context);
                      HapticFeedback.mediumImpact();
                    }
                  },
                  child: Text('Add Task',
                    style: AppTypography.h3(Theme.of(context).colorScheme.onSurface).copyWith(color: Colors.black)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final activities = ref.watch(taskListProvider);
    final completionPercent = ref.watch(completionProvider);

    return Stack(
      children: [
        Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.transparent,
        elevation: 0,
        onPressed: _showAddTaskSheet,
        label: Container(
          decoration: BoxDecoration(
            gradient: AppColors.primaryGrad,
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: AppColors.neonCyan.withValues(alpha: 0.4),
                blurRadius: 12,
                offset: const Offset(0, 4),
              )
            ]
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Row(
            children: [
              const Icon(Icons.add_rounded, color: Colors.white),
              const SizedBox(width: 8),
              Text('Add Task', style: AppTypography.h3(Theme.of(context).colorScheme.onSurface).copyWith(color: Colors.white)),
            ],
          ),
        ),
      ),
      appBar: AppBar(
        leading: const LottieHamburger(),
        title: const Text('Activity'),
        actions: const [
          SafeLottie(
            assetPath: 'assets/lottie/data_pulse.json',
            width: 40,
            height: 40,
            fallback: Icon(Icons.show_chart, color: AppColors.neonCyan),
          ),
          SizedBox(width: 16),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  RepaintBoundary(
                    child: NeonProgressRing(
                      percent: completionPercent,
                    ),
                  ),
                  const SizedBox(height: 40),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Recent', style: AppTypography.h2(Theme.of(context).colorScheme.onSurface)),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
          if (activities.isEmpty)
            SliverToBoxAdapter(
              child: Center(
                child: Column(
                  children: [
                    const SizedBox(height: 40),
                    const SafeLottie(
                      assetPath: 'assets/lottie/empty_box.json',
                      width: 160,
                      height: 160,
                      repeat: true,
                      fallback: Icon(Icons.inbox_rounded, size: 80, color: AppColors.neonCyan),
                    ),
                    const SizedBox(height: 16),
                    Text('No tasks right now', style: AppTypography.h2(Theme.of(context).colorScheme.onSurface)),
                    Text('Take a break or add a new one!', style: AppTypography.bodySmall(Theme.of(context).colorScheme.onSurface)),
                  ],
                ),
              ),
            )
          else
            SliverPadding(
              padding: EdgeInsets.only(left: 24, right: 24, bottom: 120 + MediaQuery.of(context).padding.bottom),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final task = activities[index];
                    return Dismissible(
                      key: Key(task.id),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 24),
                        margin: const EdgeInsets.only(bottom: 24),
                        decoration: BoxDecoration(
                          color: AppColors.neonCoral.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Icon(Icons.delete_rounded, color: AppColors.neonCoral),
                      ),
                      onDismissed: (_) {
                        ref.read(taskListProvider.notifier).deleteTask(task.id);
                        HapticFeedback.mediumImpact();
                      },
                      child: GestureDetector(
                        onTap: () {
                          if (task.status != ActivityStatus.done) {
                            _confettiCtrl.play();
                          }
                          ref.read(taskListProvider.notifier).toggleStatus(task.id);
                          HapticFeedback.lightImpact();
                        },
                        child: RecentActivityTile(
                          activity: task,
                          isFirst: index == 0,
                          isLast: index == activities.length - 1,
                        ),
                      ),
                    ).animate().fadeIn(delay: Duration(milliseconds: 50 * index)).slideX(begin: 0.2);
                  },
                  childCount: activities.length,
                ),
              ),
            ),
        ],
      ),
      ),
        Align(
          alignment: Alignment.topCenter,
          child: ConfettiWidget(
            confettiController: _confettiCtrl,
            blastDirectionality: BlastDirectionality.explosive,
            shouldLoop: false,
            colors: const [
              AppColors.neonCyan,
              AppColors.neonAmber,
              AppColors.neonViolet,
              AppColors.neonGreen
            ],
          ),
        ),
      ],
    );
  }
}
