import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lottie/lottie.dart';
import '../../core/constants/app_colors.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 2800), () {
      if (mounted) {
        context.go('/home');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBg,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Full-screen Rocket Animation
          Positioned.fill(
            child: RepaintBoundary(
              child: Lottie.asset(
                'assets/lottie/rocket_loading.json',
                fit: BoxFit.contain, // Changed from cover to contain to fit the whole screen
                repeat: true,
                frameRate: FrameRate.max,
                errorBuilder: (ctx, err, stack) => const Center(
                  child: CircularProgressIndicator(
                    color: AppColors.neonPurple,
                    strokeWidth: 3,
                  ),
                ),
              ),
            ),
          ),
          
          // Gradient Overlay to ensure text readability
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    AppColors.darkBg.withValues(alpha: 0.8),
                  ],
                ),
              ),
            ),
          ),

          // Text overlay at bottom
          Positioned(
            bottom: 80,
            left: 0,
            right: 0,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'NEXUS',
                  style: GoogleFonts.orbitron(
                    fontSize: 32,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                    letterSpacing: 8,
                    shadows: [Shadow(color: Colors.black.withValues(alpha: 0.8), blurRadius: 10)],
                  ),
                ).animate(onPlay: (c) => c.repeat())
                 .shimmer(duration: const Duration(milliseconds: 1200), color: AppColors.neonCyan),
                const SizedBox(height: 12),
                Text(
                  'Your home screen is loading...',
                  style: GoogleFonts.sora(
                    fontSize: 14,
                    color: Colors.white.withValues(alpha: 0.8),
                    shadows: [Shadow(color: Colors.black.withValues(alpha: 0.8), blurRadius: 5)],
                  ),
                ).animate().fadeIn(delay: const Duration(milliseconds: 400)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
