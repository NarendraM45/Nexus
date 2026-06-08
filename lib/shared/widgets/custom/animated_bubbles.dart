import 'package:flutter/material.dart';
import 'dart:math';
import '../../../core/constants/app_colors.dart';
import '../../../core/providers/theme_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AnimatedBubbles extends ConsumerStatefulWidget {
  const AnimatedBubbles({super.key});

  @override
  ConsumerState<AnimatedBubbles> createState() => _AnimatedBubblesState();
}

class _AnimatedBubblesState extends ConsumerState<AnimatedBubbles>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<_Bubble> _bubbles = [];
  final Random _rnd = Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final size = MediaQuery.of(context).size;
      for (int i = 0; i < 20; i++) {
        _bubbles.add(_Bubble(
          x: _rnd.nextDouble() * size.width,
          y: _rnd.nextDouble() * size.height,
          radius: _rnd.nextDouble() * 30 + 10,
          speed: _rnd.nextDouble() * 0.5 + 0.2,
          colorIndex: _rnd.nextInt(4),
        ));
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = ref.watch(themeProvider) == ThemeMode.dark;
    
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        if (_bubbles.isNotEmpty) {
          final size = MediaQuery.of(context).size;
          for (var b in _bubbles) {
            b.y -= b.speed;
            if (b.y < -b.radius * 2) {
              b.y = size.height + b.radius;
              b.x = _rnd.nextDouble() * size.width;
            }
          }
        }
        return CustomPaint(
          painter: _BubblesPainter(bubbles: _bubbles, isDark: isDark),
          size: Size.infinite,
        );
      },
    );
  }
}

class _Bubble {
  double x, y, radius, speed;
  int colorIndex;

  _Bubble({
    required this.x, required this.y,
    required this.radius, required this.speed,
    required this.colorIndex,
  });
}

class _BubblesPainter extends CustomPainter {
  final List<_Bubble> bubbles;
  final bool isDark;

  _BubblesPainter({required this.bubbles, required this.isDark});

  final List<Color> _colors = const [
    AppColors.neonCyan,
    AppColors.neonViolet,
    AppColors.neonRose,
    AppColors.neonAmber,
  ];

  @override
  void paint(Canvas canvas, Size size) {
    for (var b in bubbles) {
      final color = _colors[b.colorIndex].withValues(alpha: isDark ? 0.05 : 0.15); // ✅ boosted light opacity
      final paint = Paint()
        ..color = color
        ..style = PaintingStyle.fill
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10);
      
      canvas.drawCircle(Offset(b.x, b.y), b.radius, paint);
      
      // inner subtle stroke
      final borderPaint = Paint()
        ..color = color.withValues(alpha: isDark ? 0.1 : 0.25) // ✅ boosted border
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.0;
      canvas.drawCircle(Offset(b.x, b.y), b.radius, borderPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _BubblesPainter old) => true;
}
