import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_typography.dart';

class OutlinedNeonButton extends StatefulWidget {
  final String label;
  final VoidCallback onPressed;
  final Color neonColor;
  final IconData? icon;

  const OutlinedNeonButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.neonColor = AppColors.neonCyan,
    this.icon,
  });

  @override
  State<OutlinedNeonButton> createState() => _OutlinedNeonButtonState();
}

class _OutlinedNeonButtonState extends State<OutlinedNeonButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: () {
          HapticFeedback.lightImpact();
          widget.onPressed();
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: double.infinity,
          height: 56,
          decoration: BoxDecoration(
            color: _isHovered ? widget.neonColor.withValues(alpha: 0.1) : Colors.transparent,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: widget.neonColor, width: 2),
            boxShadow: _isHovered
                ? [
                    BoxShadow(
                      color: widget.neonColor.withValues(alpha: 0.3),
                      blurRadius: 12,
                      spreadRadius: 2,
                    )
                  ]
                : [],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (widget.icon != null) ...[
                Icon(widget.icon, color: widget.neonColor),
                const SizedBox(width: 8),
              ],
              Text(
                widget.label,
                style: AppTypography.h2(Theme.of(context).colorScheme.onSurface).copyWith(color: widget.neonColor),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
