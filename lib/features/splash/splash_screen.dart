import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lottie/lottie.dart';
import '../../core/constants/app_colors.dart';
import '../../core/providers/auth_provider.dart';
import '../../core/providers/onboarding_provider.dart';
import '../../shared/widgets/custom/safe_lottie.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with TickerProviderStateMixin {

  late AnimationController _fadeCtrl;
  late Animation<double>   _fade;

  @override
  void initState() {
    super.initState();

    _fadeCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _fade = CurvedAnimation(parent: _fadeCtrl, curve: Curves.easeIn);
    _fadeCtrl.forward();

    Future.delayed(const Duration(milliseconds: 8000), () {
      if (!mounted) return;
      final authState = ref.read(authProvider);
      final hasOnboarded = ref.read(onboardingProvider);
      
      if (authState.isLoggedIn) {
        context.go('/loading');
      } else if (hasOnboarded) {
        context.go('/login');
      } else {
        context.go('/onboarding');
      }
    });
  }

  @override
  void dispose() {
    _fadeCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;

    // ── Lottie box geometry — EXACT match to splash_preview.dart ────────────
    // Align(center) + SizedBox(w, h*0.55)  →  top = (h - h*0.55) / 2
    final double lottieBoxH   = h * 0.55;
    final double lottieBoxTop = (h - lottieBoxH) / 2;

    return Scaffold(
      backgroundColor: AppColors.darkBg,
      body: Container(
        width: w,
        height: h,
        // ── Background gradient (from splash_preview.dart) ─────────────────
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end:   Alignment.bottomCenter,
            colors: [
              Color(0xFF0D0A1A),
              Color(0xFF1B1040),
              Color(0xFF2E1858),
              Color(0xFF4E2080),
              Color(0xFF3D1868),
            ],
            stops: [0.0, 0.25, 0.50, 0.70, 1.0],
          ),
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [

            // ── 1. Lottie — EXACT copy from splash_preview.dart ─────────────
            Align(
              alignment: Alignment.center,
              child: SizedBox(
                width:  w,
                height: lottieBoxH,
                child: ClipRect(
                  child: OverflowBox(
                    maxWidth:  w * 1.35,
                    maxHeight: lottieBoxH,
                    alignment: Alignment.centerLeft,
                    child: Transform.translate(
                      offset: Offset(-w * 0.05, 0),
                      child: RepaintBoundary(
                        child: Lottie.asset(
                          'assets/lottie/purple_hero.json',
                          width:  w * 1.35,
                          fit:    BoxFit.contain,
                          repeat: true,
                          frameRate: FrameRate.max,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // ── 2. Edge-blend feathers — EXACT copy from splash_preview.dart ─
            Align(
              alignment: Alignment.center,
              child: SizedBox(
                width:  w,
                height: lottieBoxH,
                child: Column(
                  children: [
                    Container(
                      height: 32,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end:   Alignment.bottomCenter,
                          colors: [
                            const Color(0xFF1B1040),
                            const Color(0xFF1B1040).withValues(alpha: 0),
                          ],
                        ),
                      ),
                    ),
                    const Spacer(),
                    Container(
                      height: 32,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end:   Alignment.topCenter,
                          colors: [
                            const Color(0xFF4E2080),
                            const Color(0xFF4E2080).withValues(alpha: 0),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ── 3. Glow line — TOP edge, pinned to ClipRect top ─────────────
            Positioned(
              top:   lottieBoxTop,
              left:  0,
              right: 0,
              child: _GlowEdgeLine(
                width:          w,
                direction:      _GlowDirection.leftToRight,
                streakFraction: 0.35,
                durationMs:     1200,
              ),
            ),

            // ── 4. Glow line — BOTTOM edge, pinned to ClipRect bottom ────────
            Positioned(
              top:   lottieBoxTop + lottieBoxH - 2,
              left:  0,
              right: 0,
              child: _GlowEdgeLine(
                width:          w,
                direction:      _GlowDirection.rightToLeft,
                streakFraction: 0.35,
                durationMs:     1200,
              ),
            ),

            // ── 5. NEXUS title + typewriter (unchanged logic) ────────────────
            Align(
              alignment: const Alignment(0, -0.75),
              child: FadeTransition(
                opacity: _fade,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'NEXUS',
                      style: GoogleFonts.orbitron(
                        fontSize:      56,
                        fontWeight:    FontWeight.w900,
                        color:         Colors.white,
                        letterSpacing: 12,
                        shadows: [
                          Shadow(
                            color:      Colors.black.withValues(alpha: 0.8),
                            blurRadius: 16,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    AnimatedTextKit(
                      animatedTexts: [
                        TypewriterAnimatedText(
                          'The Hub for Doers.',
                          textStyle: GoogleFonts.sora(
                            fontSize:      20,
                            color:         AppColors.neonCyan,
                            letterSpacing: 3,
                            shadows: [
                              Shadow(
                                color:      Colors.black.withValues(alpha: 0.8),
                                blurRadius: 10,
                              ),
                            ],
                          ),
                          speed: const Duration(milliseconds: 75),
                        ),
                      ],
                      isRepeatingAnimation: false,
                    ),
                  ],
                ),
              ),
            ),

            // ── 6. Rocket + version (unchanged) ─────────────────────────────
            Positioned(
              bottom: 52,
              left:   0,
              right:  0,
              child: Column(
                children: [
                  const SafeLottie(
                    assetPath: 'assets/lottie/rocketlaunch.json',
                    width:  72,
                    height: 72,
                  ),
                  Text(
                    'v1.0.0 · Nexus',
                    style: GoogleFonts.nunito(
                      color:    Colors.white54,
                      fontSize: 12,
                    ),
                  ),
                ],
              ).animate().fadeIn(delay: const Duration(milliseconds: 2000)),
            ),

          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  Glow edge line
// ─────────────────────────────────────────────────────────────────────────────

enum _GlowDirection { leftToRight, rightToLeft }

class _GlowEdgeLine extends StatefulWidget {
  const _GlowEdgeLine({
    required this.width,
    required this.direction,
    this.streakFraction = 0.35,
    this.durationMs     = 1200,
  });

  final double         width;
  final _GlowDirection direction;
  final double         streakFraction;
  final int            durationMs;

  @override
  State<_GlowEdgeLine> createState() => _GlowEdgeLineState();
}

class _GlowEdgeLineState extends State<_GlowEdgeLine>
    with SingleTickerProviderStateMixin {

  late final AnimationController _ctrl;
  late final Animation<double>   _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: widget.durationMs),
    )..repeat();
    _anim = Tween<double>(begin: 0.0, end: 1.0).animate(_ctrl);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width:  widget.width,
      height: 2,
      child: AnimatedBuilder(
        animation: _anim,
        builder: (_, __) {
          final progress = widget.direction == _GlowDirection.leftToRight
              ? _anim.value
              : 1.0 - _anim.value;

          return CustomPaint(
            painter: _GlowLinePainter(
              progress:       progress,
              streakFraction: widget.streakFraction,
            ),
          );
        },
      ),
    );
  }
}

class _GlowLinePainter extends CustomPainter {
  const _GlowLinePainter({
    required this.progress,
    required this.streakFraction,
  });

  final double progress;
  final double streakFraction;

  @override
  void paint(Canvas canvas, Size size) {
    final w    = size.width;
    final half = streakFraction * w / 2;
    final cx   = progress * w;

    final paint = Paint()
      ..shader = const LinearGradient(
        colors: [
          Colors.transparent,
          Color(0x33FFFFFF),
          Colors.white,
          Color(0x33FFFFFF),
          Colors.transparent,
        ],
        stops: [0.0, 0.3, 0.5, 0.7, 1.0],
      ).createShader(Rect.fromLTWH(cx - half, 0, half * 2, size.height))
      ..strokeWidth = 2.5
      ..style       = PaintingStyle.stroke
      ..strokeCap   = StrokeCap.round;

    canvas.clipRect(Rect.fromLTWH(0, 0, w, size.height));
    canvas.drawLine(Offset(cx - half, 1), Offset(cx + half, 1), paint);
  }

  @override
  bool shouldRepaint(_GlowLinePainter old) => old.progress != progress;
}