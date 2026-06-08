import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_typography.dart';
import '../../../models/activity_model.dart';
import '../../../shared/widgets/custom/badge_widget.dart';

class RecentActivityTile extends StatelessWidget {
  final ActivityModel activity;
  final bool isFirst;
  final bool isLast;

  const RecentActivityTile({
    super.key,
    required this.activity,
    this.isFirst = false,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Timeline painter
          SizedBox(
            width: 40,
            child: CustomPaint(
              painter: _TimelinePainter(
                isFirst: isFirst,
                isLast: isLast,
                color: AppColors.neonCyan,
              ),
            ),
          ),
          
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 24.0),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkCard : AppColors.lightCard,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: AppColors.neonViolet.withValues(alpha: 0.2),
                      child: Text(
                        activity.title.substring(0, 1).toUpperCase(),
                        style: AppTypography.h2(Theme.of(context).colorScheme.onSurface).copyWith(color: AppColors.neonViolet),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(activity.title, style: AppTypography.body(Theme.of(context).colorScheme.onSurface).copyWith(color: Theme.of(context).colorScheme.onSurface)),
                          const SizedBox(height: 4),
                          Text(
                            activity.timestamp,
                            style: AppTypography.label(Theme.of(context).colorScheme.onSurface).copyWith(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6)),
                          ),
                        ],
                      ),
                    ),
                    BadgeWidget(
                      label: activity.status.name.toUpperCase(),
                      color: activity.status == ActivityStatus.done ? AppColors.neonGreen : AppColors.neonAmber,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TimelinePainter extends CustomPainter {
  final bool isFirst;
  final bool isLast;
  final Color color;

  _TimelinePainter({required this.isFirst, required this.isLast, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paintLine = Paint()
      ..color = color.withValues(alpha: 0.3)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;
      
    final paintDot = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
      
    final paintGlow = Paint()
      ..color = color.withValues(alpha: 0.4)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8)
      ..style = PaintingStyle.fill;

    final centerX = size.width / 2;
    const dotY = 28.0; // aligns with avatar center approx

    // Draw line
    if (!isFirst) {
      canvas.drawLine(Offset(centerX, 0), Offset(centerX, dotY - 6), paintLine);
    }
    if (!isLast) {
      canvas.drawLine(Offset(centerX, dotY + 6), Offset(centerX, size.height), paintLine);
    }

    // Draw dot and glow
    canvas.drawCircle(Offset(centerX, dotY), 6, paintGlow);
    canvas.drawCircle(Offset(centerX, dotY), 4, paintDot);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
