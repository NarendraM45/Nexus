import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_typography.dart';
import '../../core/providers/app_providers.dart';
import '../../core/providers/theme_provider.dart';
import '../../shared/widgets/custom/safe_lottie.dart';
import '../../shared/widgets/custom/user_avatar.dart';
import '../../shared/widgets/custom/animated_bubbles.dart';
import 'package:go_router/go_router.dart';
import '../../shared/widgets/lottie_hamburger.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);
    final isDark = ref.watch(themeProvider) == ThemeMode.dark;

    final settingsItems = [
      _SettingItem(
        icon: Icons.notifications_rounded,
        color: AppColors.neonCyan,
        title: 'Notifications',
        subtitle: 'Manage your alerts',
        onTap: () { /* show notification prefs bottom sheet */ },
      ),
      _SettingItem(
        icon: Icons.shield_rounded,
        color: AppColors.neonViolet,
        title: 'Privacy & Security',
        subtitle: 'Passwords and 2FA',
        onTap: () { /* show privacy sheet */ },
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        leading: const LottieHamburger(),
        title: Text('Profile', style: TextStyle(color: Theme.of(context).colorScheme.onSurface)),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_rounded, color: AppColors.neonCyan),
            onPressed: () => context.push('/profile/edit'),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Stack(
        children: [
          const AnimatedBubbles(),
          SingleChildScrollView(
            padding: EdgeInsets.only(bottom: 120 + MediaQuery.of(context).padding.bottom), // ✅ scroll fix
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 24),
            
            // Avatar & Name
            Center(
              child: Column(
                children: [
                  const SizedBox(
                    width: 110,
                    height: 110,
                    child: UserAvatar(size: 100, showEditButton: true),
                  )
                    .animate()
                    .fadeIn(duration: const Duration(milliseconds: 400))
                    .scaleXY(
                      begin: 0.5,
                      end: 1.0,
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeOutBack,
                    )
                    .shimmer(
                      delay: const Duration(milliseconds: 600),
                      duration: const Duration(milliseconds: 1200),
                      color: AppColors.neonCyan.withValues(alpha: 0.12),
                    ),
                  const SizedBox(height: 16),
                  
                  Text(user.name, style: AppTypography.display(Theme.of(context).colorScheme.onSurface).copyWith(fontSize: 24, color: Theme.of(context).colorScheme.onSurface))
                    .animate().fadeIn(delay: const Duration(milliseconds: 100)).slideY(begin: 0.2),
                  
                  const SizedBox(height: 4),
                  
                  Text(user.role, style: AppTypography.body(Theme.of(context).colorScheme.onSurface).copyWith(color: AppColors.neonAmber))
                    .animate().fadeIn(delay: const Duration(milliseconds: 200)).slideY(begin: 0.2),
                ],
              ),
            ),
            
            const SizedBox(height: 32),
            
            // Stats Row
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                children: [
                  Expanded(
                    child: _StatCard(
                      label: 'Tasks',
                      value: user.taskCount.toString(),
                      icon: Icons.task_alt_rounded,
                      color: AppColors.neonCyan,
                    ),
                  ).animate().fadeIn(delay: const Duration(milliseconds: 300)).slideY(begin: 0.2),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _StatCard(
                      label: 'Streak',
                      value: '${user.streak}d',
                      icon: Icons.local_fire_department_rounded,
                      color: AppColors.neonAmber,
                    ),
                  ).animate().fadeIn(delay: const Duration(milliseconds: 400)).slideY(begin: 0.2),
                ],
              ),
            ),
            
            const SizedBox(height: 40),
            
            // Settings Header with Lottie
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                children: [
                  Text('Settings', style: AppTypography.h2(Theme.of(context).colorScheme.onSurface).copyWith(color: Theme.of(context).colorScheme.onSurface)),
                  const SizedBox(width: 8),
                  const SafeLottie(
                    assetPath: 'assets/lottie/settings_gear.json',
                    width: 32, height: 32,
                    repeat: true,
                    fallback: Icon(Icons.settings, color: AppColors.neonCyan, size: 20),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Appearance Toggle Card
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              child: Container(
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkCard : AppColors.lightCard,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                child: Row(
                  children: [
                    Icon(
                      isDark ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
                      color: isDark ? AppColors.neonViolet : AppColors.neonAmber,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Appearance', style: AppTypography.h3(Theme.of(context).colorScheme.onSurface).copyWith(color: Theme.of(context).colorScheme.onSurface)),
                          Text(isDark ? 'Dark theme active' : 'Light theme active',
                            style: AppTypography.bodySmall(Theme.of(context).colorScheme.onSurface).copyWith(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6))),
                        ],
                      ),
                    ),
                    // ✅ REAL toggle that actually works
                    Switch.adaptive(
                      value: isDark,
                      activeThumbColor: AppColors.neonCyan,
                      onChanged: (_) {
                        ref.read(themeProvider.notifier).toggleTheme();
                        HapticFeedback.lightImpact();
                      },
                    ),
                  ],
                ),
              ),
            ).animate().fadeIn(delay: const Duration(milliseconds: 500)).slideX(begin: 0.2),
            
            // Other Settings List
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              itemCount: settingsItems.length,
              itemBuilder: (context, index) {
                final item = settingsItems[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: InkWell(
                    onTap: item.onTap,
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.darkCard : AppColors.lightCard,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: item.color.withValues(alpha: 0.2),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(item.icon, color: item.color, size: 20),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(item.title, style: AppTypography.h3(Theme.of(context).colorScheme.onSurface).copyWith(color: Theme.of(context).colorScheme.onSurface)),
                                Text(item.subtitle, style: AppTypography.bodySmall(Theme.of(context).colorScheme.onSurface).copyWith(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6))),
                              ],
                            ),
                          ),
                          const Icon(Icons.chevron_right_rounded, color: AppColors.lightSubtext),
                        ],
                      ),
                    ),
                  ),
                ).animate().fadeIn(delay: Duration(milliseconds: 600 + (100 * index))).slideX(begin: 0.2);
              },
            ),
          ],
        ),
      ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    // using Consumer here wouldn't be ideal inside a simple StatelessWidget, 
    // but we can assume parent gives correct theme context or we stick to transparent glass.
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.lightCard,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 12),
          Text(value, style: AppTypography.display(Theme.of(context).colorScheme.onSurface).copyWith(fontSize: 24, color: isDark ? color : Theme.of(context).colorScheme.primary)),
          Text(label, style: AppTypography.label(Theme.of(context).colorScheme.onSurface).copyWith(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.8))),
        ],
      ),
    );
  }
}

class _SettingItem {
  final IconData icon;
  final Color color;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  _SettingItem({
    required this.icon,
    required this.color,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });
}
