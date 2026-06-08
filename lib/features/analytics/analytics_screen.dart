import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import '../../core/constants/app_colors.dart';
import '../../shared/widgets/lottie_hamburger.dart';

class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        leading: const LottieHamburger(),
        title: const Text('Analytics'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: double.infinity,
                height: 180,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.neonPurple.withValues(alpha: 0.1),
                      blurRadius: 40,
                      spreadRadius: 10,
                    ),
                  ],
                ),
                child: Lottie.asset(
                  'assets/lottie/graphs.json',
                  fit: BoxFit.contain,
                  errorBuilder: (ctx, err, stack) => const Icon(
                    Icons.insights_rounded,
                    size: 80,
                    color: AppColors.neonPurple,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Lottie.asset(
                'assets/lottie/comingsoon.json',
                width: 250,
                fit: BoxFit.contain,
                errorBuilder: (ctx, err, stack) => Text(
                  'Coming Soon',
                  style: GoogleFonts.orbitron(
                    fontSize: 32,
                    fontWeight: FontWeight.w900,
                    color: isDark ? Colors.white : Colors.black,
                    letterSpacing: 2,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'We are building powerful insights and data visualizations for your workflow. Stay tuned!',
                textAlign: TextAlign.center,
                style: GoogleFonts.sora(
                  fontSize: 16,
                  color: isDark ? Colors.white70 : Colors.black87,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
