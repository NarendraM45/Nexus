import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';
import '../../core/providers/auth_provider.dart';
import '../../shared/widgets/custom/user_avatar.dart';
import '../../shared/widgets/custom/safe_lottie.dart';
import '../../shared/widgets/breathing_list_item.dart';

class DrawerLayout extends ConsumerWidget {
  final void Function(int index)? onNavigate;
  const DrawerLayout({super.key, this.onNavigate});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final user = authState.user;

    final menuItems = [
      _DrawerItemModel(icon: Icons.home_rounded, label: 'Home', route: '/home'),
      _DrawerItemModel(icon: Icons.track_changes_rounded, label: 'Status', route: '/status'),
      _DrawerItemModel(icon: Icons.task_alt_rounded, label: 'My Tasks', route: '/tasks'),
      _DrawerItemModel(icon: Icons.account_tree_rounded, label: 'Projects', route: '/projects'),
      _DrawerItemModel(icon: Icons.note_alt_rounded, label: 'Notes', route: '/notes'),
      _DrawerItemModel(icon: Icons.explore_rounded, label: 'Explore', route: '/explore'),
      _DrawerItemModel(icon: Icons.bar_chart_rounded, label: 'Analytics', route: '/analytics'),
      _DrawerItemModel(icon: Icons.group_rounded, label: 'Team', route: '/team'),
      _DrawerItemModel(icon: Icons.calendar_month_rounded, label: 'Calendar', route: '/calendar'),
      _DrawerItemModel(icon: Icons.person_rounded, label: 'Profile', route: '/profile'),
    ];

    final currentRoute = GoRouterState.of(context).uri.path;

    return Drawer(
      backgroundColor: Colors.transparent,
      child: Stack(
        children: [
          // Background Blur
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
              child: Container(
                color: Theme.of(context).scaffoldBackgroundColor.withValues(alpha: 0.85),
              ),
            ),
          ),
          
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Profile Section
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (user != null)
                        const UserAvatar(size: 64, showOnlineDot: true),
                      const SizedBox(height: 16),
                      Text(
                        user?.name ?? 'Guest',
                        style: GoogleFonts.sora(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                      Text(
                        user?.email ?? '',
                        style: GoogleFonts.nunito(
                          fontSize: 13,
                          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                        ),
                      ),
                    ],
                  ),
                ),
                Divider(color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.5), height: 1),
                
                // Menu Items
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    itemCount: menuItems.length,
                    itemBuilder: (context, index) {
                      final item = menuItems[index];
                      final isActive = currentRoute == item.route;
                      
                      return AnimatedBreathingListItem(
                        delayMs: index * 100,
                        child: _DrawerItemWidget(
                          icon: item.icon,
                          title: item.label,
                          isActive: isActive,
                          onTap: () {
                            Navigator.pop(context); // close drawer
                            if (!isActive) {
                              context.go(item.route);
                            }
                          },
                        ),
                      );
                    },
                  ),
                ),
                
                // Logout Button
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: GestureDetector(
                    onTap: () async {
                      HapticFeedback.mediumImpact();
                      final confirmed = await showDialog<bool>(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          backgroundColor: Theme.of(context).colorScheme.surface,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                            side: BorderSide(color: AppColors.neonCoral.withValues(alpha: 0.3)),
                          ),
                          title: Text('Log out?', style: GoogleFonts.sora(fontWeight: FontWeight.w700, color: Theme.of(context).colorScheme.onSurface)),
                          content: Text(
                            'You\'ll need to sign in again to access your dashboard.',
                            style: GoogleFonts.nunito(color: Theme.of(context).colorScheme.onSurface),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(ctx, false),
                              child: Text('Cancel', style: GoogleFonts.sora(fontWeight: FontWeight.w600, color: AppColors.neonCyan)),
                            ),
                            TextButton(
                              onPressed: () => Navigator.pop(ctx, true),
                              child: Text('Log out', style: GoogleFonts.sora(fontWeight: FontWeight.w600, color: AppColors.neonCoral)),
                            ),
                          ],
                        ),
                      );
                      
                      if (confirmed == true && context.mounted) {
                        showDialog(
                          context: context,
      useRootNavigator: true,
                          barrierColor: Colors.black87,
                          barrierDismissible: false,
                          builder: (ctx) => const Center(
                            child: SafeLottie(
                              assetPath: 'assets/lottie/rocket_logout.json',
                              width: 250, height: 250,
                              repeat: false,
                              fallback: Icon(Icons.rocket_launch, size: 64, color: AppColors.neonCyan),
                            ),
                          ),
                        );
                        await Future.delayed(const Duration(milliseconds: 1500));
                        if (context.mounted) {
                          Navigator.pop(context); // close rocket
                        }
                        
                        await ref.read(authProvider.notifier).logout();
                        
                        if (context.mounted) {
                          context.go('/login');
                        }
                      }
                    },
                    child: Row(
                      children: [
                        const Icon(Icons.logout_rounded, color: AppColors.neonCoral),
                        const SizedBox(width: 16),
                        Text('Logout',
                          style: GoogleFonts.sora(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: AppColors.neonCoral,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DrawerItemModel {
  final IconData icon;
  final String label;
  final String route;
  _DrawerItemModel({required this.icon, required this.label, required this.route});
}

class _DrawerItemWidget extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool isActive;
  final VoidCallback onTap;

  const _DrawerItemWidget({
    required this.icon,
    required this.title,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final itemColor = isActive ? AppColors.neonPurple : Theme.of(context).colorScheme.onSurface;
    
    return InkWell(
      onTap: onTap,
      splashColor: AppColors.neonPurple.withValues(alpha: 0.2),
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            left: BorderSide(
              color: isActive ? AppColors.neonPurple : Colors.transparent,
              width: 4,
            ),
          ),
          color: isActive ? Theme.of(context).colorScheme.surfaceContainerHighest : Colors.transparent,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          children: [
            Icon(icon, color: itemColor, size: 24),
            const SizedBox(width: 16),
            Text(
              title,
              style: GoogleFonts.sora(
                fontSize: 15,
                color: itemColor,
                fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
