import 'package:nexus/core/utils/app_logger.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class SafeLottie extends StatelessWidget {
  final String assetPath;
  final double? width;
  final double? height;
  final bool repeat;
  final BoxFit? fit;
  final Widget? fallback;
  final bool isHero;

  const SafeLottie({
    super.key,
    required this.assetPath,
    this.width,
    this.height,
    this.repeat = true,
    this.fit,
    this.fallback,
    this.isHero = false,
  });

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: SizedBox(
        width: width,
        height: height,
        child: Lottie.asset(
          assetPath,
          width: width,
          height: height,
          repeat: repeat,
          fit: fit ?? BoxFit.contain,
          frameRate: isHero ? FrameRate.max : const FrameRate(30),
          // ✅ If Lottie file missing → show fallback, not crash
          errorBuilder: (ctx, err, stack) {
            AppLogger.log('Lottie load error for $assetPath: $err');
            return fallback ?? const SizedBox.shrink();
          },
          // ✅ If delegates fail → graceful degrade
          frameBuilder: (ctx, child, composition) {
            if (composition == null) {
              return fallback ?? const SizedBox.shrink();
            }
            return child;
          },
        ),
      ),
    );
  }
}
