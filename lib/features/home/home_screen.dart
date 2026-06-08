import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';
import '../../core/providers/app_providers.dart';
import '../../core/providers/task_provider.dart';
import '../../models/feature_item_model.dart';
import '../../shared/widgets/custom/animated_bubbles.dart';
import '../../shared/widgets/custom/safe_lottie.dart';
import '../../shared/widgets/lottie_hamburger.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  static bool _hasShownSplash = false;
  late bool _showSplashOverlay;

  @override
  void initState() {
    super.initState();
    _showSplashOverlay = !_hasShownSplash;
    if (_showSplashOverlay) {
      _hasShownSplash = true;
      Future.delayed(const Duration(milliseconds: 2500), () {
        if (mounted) setState(() => _showSplashOverlay = false);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);
    final tasks = ref.watch(taskListProvider);

    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Stack(
        children: [
          // Background Bubbles
          const Positioned.fill(child: AnimatedBubbles()),

          CustomScrollView(
            physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
            slivers: [
              // Custom AppBar
              SliverAppBar(
                expandedHeight: 70.0,
                floating: true,
                pinned: true,
                backgroundColor: Colors.transparent,
                flexibleSpace: ClipRRect(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                    child: Container(
                      color: Theme.of(context).scaffoldBackgroundColor.withValues(alpha: 0.7),
                    ),
                  ),
                ),
                leading: const LottieHamburger(),
                centerTitle: true,
                title: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SafeLottie(
                      assetPath: 'assets/lottie/data_pulse.json',
                      width: 24, height: 24,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'NEXUS',
                      style: GoogleFonts.orbitron(
                        fontWeight: FontWeight.w900,
                        letterSpacing: 4,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
              ),

              // Welcome + Stats
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Welcome Banner
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Welcome back,',
                                  style: GoogleFonts.sora(
                                    fontSize: 14,
                                    color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  user.name,
                                  style: GoogleFonts.sora(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w700,
                                    color: Theme.of(context).colorScheme.onSurface,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SafeLottie(
                            assetPath: 'assets/lottie/wave_hello_robot.json',
                            width: 60, height: 60,
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Stats row
                      Row(
                        children: [
                          _StatChip(label: 'Tasks', value: '${user.taskCount}', icon: Icons.task_alt),
                          const SizedBox(width: 12),
                          _StatChip(label: 'Active', value: '${user.activeCount}', icon: Icons.bolt),
                          const SizedBox(width: 12),
                          _StatChip(label: 'Streak', value: '${user.streak}d', icon: Icons.local_fire_department, isHighlight: true),
                        ],
                      ).animate().fadeIn(delay: const Duration(milliseconds: 200)).slideX(),
                    ],
                  ),
                ),
              ),

              // Lottie Tiles Grid
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.85,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final item = FeatureItems.all[index];
                      return _LottieTileCard(
                        item: item,
                        index: index,
                        onTap: () => context.go(item.route),
                      );
                    },
                    childCount: FeatureItems.all.length,
                  ),
                ),
              ),

              // Recent Activity Title
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 40, 24, 16),
                  child: Text(
                    'Recent Activity',
                    style: GoogleFonts.sora(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                ),
              ),

              // Recent Activity List
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 120),
                sliver: tasks.isEmpty
                  ? SliverToBoxAdapter(
                      child: Center(
                        child: Column(
                          children: [
                            const SafeLottie(assetPath: 'assets/lottie/emptybox.json', width: 120, height: 120),
                            Text('No recent activity', style: GoogleFonts.nunito(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5))),
                          ],
                        ),
                      ),
                    )
                  : SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final task = tasks[index];
                          return Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.5)),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 40, height: 40,
                                  decoration: BoxDecoration(
                                    color: task.status.name == 'done' ? AppColors.neonGreen.withValues(alpha: 0.2) : AppColors.neonCyan.withValues(alpha: 0.2),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    task.status.name == 'done' ? Icons.check_circle_rounded : Icons.pending_actions_rounded,
                                    color: task.status.name == 'done' ? AppColors.neonGreen : AppColors.neonCyan,
                                    size: 20,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        task.title,
                                        style: GoogleFonts.sora(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14,
                                          color: Theme.of(context).colorScheme.onSurface,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        task.timestamp,
                                        style: GoogleFonts.nunito(
                                          fontSize: 12,
                                          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ).animate().fadeIn(delay: Duration(milliseconds: 400 + (index * 50))).slideX(begin: 0.1);
                        },
                        childCount: tasks.length > 3 ? 3 : tasks.length,
                      ),
                    ),
              ),
            ],
          ),

          // Splash Overlay
          if (_showSplashOverlay)
            Positioned.fill(
              child: AnimatedOpacity(
                opacity: _showSplashOverlay ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 600),
                child: Container(
                  color: Theme.of(context).scaffoldBackgroundColor.withValues(alpha: 0.9),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const SafeLottie(
                            assetPath: 'assets/lottie/wave_hello_robot.json',
                            width: 200, height: 200,
                          ).animate().scaleXY(begin: 0.5, end: 1.0, duration: 600.ms, curve: Curves.easeOutBack),
                          const SizedBox(height: 24),
                          Text(
                            'Loading Hub...',
                            style: GoogleFonts.sora(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final bool isHighlight;

  const _StatChip({
    required this.label,
    required this.value,
    required this.icon,
    this.isHighlight = false,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: isHighlight
              ? AppColors.neonAmber.withValues(alpha: 0.15)
              : Theme.of(context).colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isHighlight
                ? AppColors.neonAmber.withValues(alpha: 0.3)
                : Theme.of(context).colorScheme.outline,
          ),
        ),
        child: Column(
          children: [
            Icon(icon, size: 20, color: isHighlight ? AppColors.neonAmber : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6)),
            const SizedBox(height: 8),
            Text(
              value,
              style: GoogleFonts.sora(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: GoogleFonts.nunito(
                fontSize: 11,
                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LottieTileCard extends StatefulWidget {
  final FeatureItem item;
  final int index;
  final VoidCallback onTap;

  const _LottieTileCard({required this.item, required this.index, required this.onTap});

  @override
  State<_LottieTileCard> createState() => _LottieTileCardState();
}

class _LottieTileCardState extends State<_LottieTileCard> {
  bool _isHovered = false;

  String _getLottieForId(String id) {
    switch (id) {
      case 'status': return 'assets/lottie/tile_status.json';
      case 'tasks': return 'assets/lottie/tile_tasks.json';
      case 'projects': return 'assets/lottie/project.json';
      case 'notes': return 'assets/lottie/notes.json';
      case 'explore': return 'assets/lottie/tile_explore.json';
      case 'analytics': return 'assets/lottie/tile_analytics.json';
      case 'team': return 'assets/lottie/tile_team.json';
      case 'calendar': return 'assets/lottie/tile_calendar.json';
      case 'profile': return 'assets/lottie/tile_profile.json';
      default: return 'assets/lottie/emptybox.json';
    }
  }

  @override
  Widget build(BuildContext context) {
    final lottieFile = _getLottieForId(widget.item.id);

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        onTapDown: (_) => setState(() => _isHovered = true),
        onTapUp: (_) => setState(() => _isHovered = false),
        onTapCancel: () => setState(() => _isHovered = false),
        child: AnimatedScale(
          scale: _isHovered ? 0.95 : 1.0,
          duration: const Duration(milliseconds: 150),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).colorScheme.surfaceContainerHighest,
                  Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: widget.item.glowColor.withValues(alpha: _isHovered ? 0.5 : 0.2),
                width: _isHovered ? 2 : 1,
              ),
              boxShadow: _isHovered ? [
                BoxShadow(
                  color: widget.item.glowColor.withValues(alpha: 0.2),
                  blurRadius: 20,
                  spreadRadius: -5,
                )
              ] : [],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: Stack(
                children: [
                  // Lottie Animation
                  Center(
                    child: Opacity(
                      opacity: 0.8,
                      child: SafeLottie(
                        assetPath: lottieFile,
                        width: 120, height: 120,
                        repeat: true,
                        fallback: Icon(widget.item.icon, size: 60, color: widget.item.iconColor.withValues(alpha: 0.5)),
                      ),
                    ),
                  ),

                  // Content
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        if (widget.item.badge != null)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            margin: const EdgeInsets.only(bottom: 8),
                            decoration: BoxDecoration(
                              color: widget.item.iconColor.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              widget.item.badge!,
                              style: GoogleFonts.sora(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: widget.item.iconColor,
                              ),
                            ),
                          ),
                        Text(
                          widget.item.title,
                          style: GoogleFonts.sora(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          widget.item.subtitle ?? '',
                          style: GoogleFonts.nunito(
                            fontSize: 12,
                            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ).animate().fadeIn(delay: Duration(milliseconds: 200 + (widget.index * 100))).scaleXY(begin: 0.8, curve: Curves.easeOutBack),
    );
  }
}
