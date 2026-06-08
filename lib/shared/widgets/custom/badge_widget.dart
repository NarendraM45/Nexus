import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_typography.dart';

class BadgeWidget extends StatelessWidget {
  final String label;
  final Color color;

  const BadgeWidget({
    super.key,
    required this.label,
    this.color = AppColors.neonRose,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.5)),
      ),
      child: Text(
        label,
        style: AppTypography.label(Theme.of(context).colorScheme.onSurface).copyWith(color: color, fontWeight: FontWeight.bold),
      ),
    ).animate().scale(delay: const Duration(milliseconds: 300));
  }
}
