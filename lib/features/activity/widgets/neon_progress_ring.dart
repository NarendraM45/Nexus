import 'package:flutter/material.dart';
import 'dart:math';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_typography.dart';

class NeonProgressRing extends StatefulWidget {
  final double percent;   // 0.0 to 1.0
  final double size;
  const NeonProgressRing({super.key, required this.percent, this.size = 200});

  @override
  State<NeonProgressRing> createState() => _NeonProgressRingState();
}

class _NeonProgressRingState extends State<NeonProgressRing>
    with TickerProviderStateMixin {

  late final AnimationController _rotationCtrl;   // continuous clockwise spin
  late final AnimationController _fillCtrl;        // 0 → percent fill

  @override
  void initState() {
    super.initState();
    // ✅ Continuous clockwise rotation — 4 seconds per full revolution
    _rotationCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();  // loops forever clockwise

    // ✅ Fill animation — 0 to actual value
    _fillCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );
    _fillCtrl.animateTo(widget.percent, curve: Curves.easeOutCubic);
  }

  @override
  void didUpdateWidget(NeonProgressRing old) {
    super.didUpdateWidget(old);
    if (old.percent != widget.percent) {
      _fillCtrl.animateTo(widget.percent, curve: Curves.easeOutCubic);
    }
  }

  @override
  void dispose() {
    _rotationCtrl.dispose();
    _fillCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size, height: widget.size,
      child: AnimatedBuilder(
        animation: Listenable.merge([_rotationCtrl, _fillCtrl]),
        builder: (ctx, _) {
          return Transform.rotate(
            angle: _rotationCtrl.value * 2 * pi,  // ✅ clockwise spin
            child: CustomPaint(
              painter: _RingPainter(
                progress: _fillCtrl.value,
                trackColor: Colors.white12,
                progressGradientStart: AppColors.neonCyan,
                progressGradientEnd: AppColors.neonViolet,
                strokeWidth: 14,
                glowColor: AppColors.neonCyan.withValues(alpha: 0.4),
              ),
              // Center text doesn't rotate with the ring
              child: Transform.rotate(
                angle: -_rotationCtrl.value * 2 * pi,  // ✅ counter-rotate text
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TweenAnimationBuilder<double>(
                        tween: Tween(begin: 0, end: widget.percent * 100),
                        duration: const Duration(milliseconds: 2000),
                        curve: Curves.easeOutCubic,
                        builder: (ctx, val, _) => Text(
                          '${val.toInt()}%',
                          style: GoogleFonts.orbitron(
                            fontSize: 32, fontWeight: FontWeight.w900,
                            color: Theme.of(context).brightness == Brightness.dark ? Colors.white : const Color(0xFF1A1A2E),
                          ),
                        ),
                      ),
                      Text('Completed',
                        style: AppTypography.label(Theme.of(context).colorScheme.onSurface).copyWith(
                          color: AppColors.neonCyan)),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  final double progress;
  final Color trackColor;
  final Color progressGradientStart;
  final Color progressGradientEnd;
  final double strokeWidth;
  final Color glowColor;

  const _RingPainter({
    required this.progress, required this.trackColor,
    required this.progressGradientStart, required this.progressGradientEnd,
    required this.strokeWidth, required this.glowColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width / 2) - (strokeWidth / 2);
    final rect = Rect.fromCircle(center: center, radius: radius);

    // Track
    canvas.drawArc(rect, 0, 2 * pi, false,
      Paint()..color = trackColor
             ..style = PaintingStyle.stroke
             ..strokeWidth = strokeWidth
             ..strokeCap = StrokeCap.round);

    if (progress <= 0) return;

    // Progress arc with gradient
    final gradient = SweepGradient(
      startAngle: -pi / 2,
      endAngle: -pi / 2 + (2 * pi * progress),
      colors: [progressGradientStart, progressGradientEnd],
    ).createShader(rect);

    // Glow layer
    canvas.drawArc(rect, -pi / 2, 2 * pi * progress, false,
      Paint()..shader = gradient
             ..style = PaintingStyle.stroke
             ..strokeWidth = strokeWidth + 8
             ..strokeCap = StrokeCap.round
             ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8));

    // Main arc
    canvas.drawArc(rect, -pi / 2, 2 * pi * progress, false,
      Paint()..shader = gradient
             ..style = PaintingStyle.stroke
             ..strokeWidth = strokeWidth
             ..strokeCap = StrokeCap.round);
  }

  @override
  bool shouldRepaint(_RingPainter old) =>
    old.progress != progress;
}
