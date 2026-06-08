import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../core/constants/app_colors.dart';
import '../../core/providers/onboarding_provider.dart';
import '../../core/providers/theme_provider.dart';
import '../../shared/widgets/custom/safe_lottie.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _finish() {
    ref.read(onboardingProvider.notifier).complete();
    context.go('/login');
  }

  @override
  Widget build(BuildContext context) {
    final isDark = ref.watch(themeProvider) == ThemeMode.dark;
    
    final slides = [
      _SlideData(
        title: 'Own Your Tasks',
        subtitle: 'Create, organize, and complete tasks with deadline tracking, priorities, and progress rings.',
        lottie: 'assets/lottie/tile_tasks.json',
        gradient: AppColors.primaryGrad,
      ),
      _SlideData(
        title: 'Connect with Team',
        subtitle: 'Stay synced with your cohort. See who\'s online, track team progress, and collaborate seamlessly.',
        lottie: 'assets/lottie/tile_team.json',
        gradient: AppColors.roseViolet,
      ),
      _SlideData(
        title: 'You\'re Ready.',
        subtitle: 'Nexus is your personal command center. Every task, every goal, every win — tracked here.',
        lottie: 'assets/lottie/purple_hero.json',
        gradient: AppColors.nexusBrandGrad,
      ),
    ];

    final currentSlide = slides[_currentPage];

    return Scaffold(
      body: Stack(
        children: [
          // Background Gradient Overlay
          AnimatedContainer(
            duration: const Duration(milliseconds: 400),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  currentSlide.gradient.colors.first.withValues(alpha: isDark ? 0.25 : 0.12),
                  Colors.transparent,
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          
          SafeArea(
            child: Column(
              children: [
                // Top Bar
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () => ref.read(themeProvider.notifier).toggleTheme(),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.surfaceContainerHighest,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Theme.of(context).colorScheme.outline),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
                                size: 18,
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                isDark ? 'Light' : 'Dark',
                                style: GoogleFonts.sora(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: Theme.of(context).colorScheme.onSurface,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Pager
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    onPageChanged: (i) => setState(() => _currentPage = i),
                    itemCount: slides.length,
                    itemBuilder: (ctx, i) {
                      final slide = slides[i];
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SafeLottie(
                              assetPath: slide.lottie,
                              width: 260,
                              height: 260,
                            ),
                            const SizedBox(height: 48),
                            Text(
                              slide.title,
                              style: GoogleFonts.orbitron(
                                fontSize: 26,
                                fontWeight: FontWeight.w900,
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              slide.subtitle,
                              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                height: 1.6,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                
                // Bottom Controls
                Padding(
                  padding: const EdgeInsets.fromLTRB(40, 0, 40, 48),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SmoothPageIndicator(
                        controller: _pageController,
                        count: slides.length,
                        effect: WormEffect(
                          dotWidth: 10,
                          dotHeight: 10,
                          activeDotColor: AppColors.neonCyan,
                          dotColor: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.15),
                        ),
                      ),
                      
                      if (_currentPage < slides.length - 1)
                        TextButton(
                          onPressed: _finish,
                          child: Text(
                            'Skip',
                            style: GoogleFonts.sora(
                              fontWeight: FontWeight.w600,
                              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                            ),
                          ),
                        ),
                        
                      GestureDetector(
                        onTap: () {
                          if (_currentPage < slides.length - 1) {
                            _pageController.nextPage(
                              duration: const Duration(milliseconds: 400),
                              curve: Curves.easeInOut,
                            );
                          } else {
                            _finish();
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                          decoration: BoxDecoration(
                            gradient: _currentPage == slides.length - 1
                                ? AppColors.nexusBrandGrad
                                : AppColors.primaryGrad,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                _currentPage == slides.length - 1 ? 'Get Started' : 'Next',
                                style: GoogleFonts.sora(
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Icon(
                                _currentPage == slides.length - 1
                                    ? Icons.rocket_launch_rounded
                                    : Icons.arrow_forward_rounded,
                                color: Colors.white,
                                size: 20,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SlideData {
  final String title;
  final String subtitle;
  final String lottie;
  final LinearGradient gradient;

  _SlideData({
    required this.title,
    required this.subtitle,
    required this.lottie,
    required this.gradient,
  });
}
