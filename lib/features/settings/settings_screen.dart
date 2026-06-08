import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'dart:ui';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_typography.dart';
import '../../core/providers/auth_provider.dart';
import '../../shared/widgets/cards/list_item_card.dart';
import '../../shared/widgets/buttons/outlined_button.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  bool _notificationsEnabled = true;
  bool _biometricsEnabled = false;

  void _showLogoutDialog() {
    showDialog(
      context: context,
      useRootNavigator: true,
      builder: (ctx) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: AlertDialog(
          backgroundColor: Theme.of(context).brightness == Brightness.dark 
              ? AppColors.darkCard : AppColors.lightCard,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20), side: BorderSide(color: Colors.white.withValues(alpha: 0.1))),
          title: Text('Logout', style: AppTypography.h2(Theme.of(context).colorScheme.onSurface)),
          content: Text('Are you sure you want to disconnect from the vault?', style: AppTypography.body(Theme.of(context).colorScheme.onSurface)),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text('Cancel', style: AppTypography.body(Theme.of(context).colorScheme.onSurface).copyWith(color: AppColors.lightSubtext)),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
                ref.read(authProvider.notifier).logout();
                context.go('/login');
              },
              child: Text('Logout', style: AppTypography.body(Theme.of(context).colorScheme.onSurface).copyWith(color: AppColors.neonRose)),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.lightText),
          onPressed: () => context.pop(),
        ),
        actions: [
          Lottie.asset(
            'assets/lottie/setings_gear.json',
            width: 40,
            height: 40,
            errorBuilder: (ctx, err, stack) => const Icon(Icons.settings, color: AppColors.neonCyan),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            ListItemCard(
              icon: Icons.dark_mode,
              title: 'Dark Mode',
              subtitle: 'Locked to deep space mode',
              iconColor: AppColors.lightSubtext,
              trailing: Switch(
                value: true,
                onChanged: (val) {}, // Always true
                activeThumbColor: AppColors.neonCyan,
                inactiveThumbColor: AppColors.lightSubtext,
              ),
            ),
            ListItemCard(
              icon: Icons.notifications_active,
              title: 'Push Notifications',
              subtitle: 'Receive alerts',
              iconColor: AppColors.neonViolet,
              trailing: Switch(
                value: _notificationsEnabled,
                onChanged: (val) => setState(() => _notificationsEnabled = val),
                activeThumbColor: AppColors.neonViolet,
              ),
            ),
            ListItemCard(
              icon: Icons.fingerprint,
              title: 'Biometrics',
              subtitle: 'Unlock with fingerprint',
              iconColor: AppColors.neonGreen,
              trailing: Switch(
                value: _biometricsEnabled,
                onChanged: (val) => setState(() => _biometricsEnabled = val),
                activeThumbColor: AppColors.neonGreen,
              ),
            ),
            
            const SizedBox(height: 40),
            
            OutlinedNeonButton(
              label: 'Disconnect',
              icon: Icons.power_settings_new,
              neonColor: AppColors.neonRose,
              onPressed: _showLogoutDialog,
            ),
            
            const SizedBox(height: 40),
            
            Text('Nexus v1.0.0+1', style: AppTypography.label(Theme.of(context).colorScheme.onSurface)),
          ],
        ),
      ),
    );
  }
}
