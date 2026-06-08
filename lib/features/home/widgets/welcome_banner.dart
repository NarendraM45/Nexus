import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/providers/app_providers.dart';
import '../../../../shared/widgets/custom/safe_lottie.dart';
class WelcomeBanner extends ConsumerWidget {
  const WelcomeBanner({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);
    final firstName = user.name.split(' ').first;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: AppColors.warmGrad,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.neonRose.withValues(alpha: 0.4),
            blurRadius: 20,
            spreadRadius: 2,
          )
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hey, $firstName 👋',
                  style: AppTypography.h1(Theme.of(context).colorScheme.onSurface).copyWith(color: Colors.white),
                ),
                const SizedBox(height: 8),
                Text(
                  'Ready to elevate your world?',
                  style: AppTypography.bodySmall(Theme.of(context).colorScheme.onSurface).copyWith(color: Colors.white70),
                ),
                const SizedBox(height: 12),
                TweenAnimationBuilder<int>(
                  tween: IntTween(begin: 0, end: user.streak),
                  duration: const Duration(milliseconds: 1500),
                  curve: Curves.easeOutCubic,
                  builder: (ctx, value, child) => Text(
                    '🔥 $value Day Streak',
                    style: AppTypography.bodySmall(Theme.of(context).colorScheme.onSurface).copyWith(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
          const SafeLottie(
            assetPath: 'assets/lottie/wave_hello_robot.json',
            width: 80,
            height: 80,
            repeat: true,
            fallback: Icon(Icons.waving_hand_rounded, color: Colors.white, size: 40),
          ),
        ],
      ),
    ).animate().fadeIn(delay: const Duration(milliseconds: 200)).slideX(begin: 0.3);
  }
}
