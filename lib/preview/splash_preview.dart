import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import '../core/constants/app_colors.dart';
import '../shared/widgets/custom/safe_lottie.dart';

void main() {
  runApp(
    const ProviderScope(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: _SplashPreviewWidget(),
      ),
    ),
  );
}

class _SplashPreviewWidget extends StatelessWidget {
  const _SplashPreviewWidget();

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;

    // ── Lottie SizedBox geometry (DO NOT CHANGE — matches layer 1 exactly) ──
    // The SizedBox is centered on screen: top = (h - lottieBoxH) / 2
    final double lottieBoxH   = h * 0.55;
    final double lottieBoxTop = (h - lottieBoxH) / 2;

    // ── OverflowBox clip region (matches the ClipRect in layer 1) ──────────
    // ClipRect clips to the SizedBox bounds, so the visible rect is:
    //   left:   0
    //   top:    lottieBoxTop
    //   width:  w          (full screen width)
    //   height: lottieBoxH
    // The glow lines sit exactly on those top/bottom edges.

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        width: w,
        height: h,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
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

            // ── 1. Lottie (UNCHANGED) ──────────────────────────────────────
            Align(
              alignment: Alignment.center,
              child: SizedBox(
                width: w,
                height: lottieBoxH,
                child: ClipRect(
                  child: OverflowBox(
                    maxWidth: w * 1.35,
                    maxHeight: lottieBoxH,
                    alignment: Alignment.centerLeft,
                    child: Transform.translate(
                      offset: Offset(-w * 0.05, 0),
                      child: RepaintBoundary(
                        child: Lottie.asset(
                          'assets/lottie/purple_hero.json',
                          fit: BoxFit.fitHeight,
                          alignment: Alignment.center,
                          repeat: true,
                          frameRate: FrameRate.max,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // ── 2. Edge-blend feathers (UNCHANGED) ────────────────────────
            Align(
              alignment: Alignment.center,
              child: SizedBox(
                width: w,
                height: lottieBoxH,
                child: Column(
                  children: [
                    Container(
                      height: 32,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
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
                          end: Alignment.topCenter,
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

            // ── 3. Glow lines — pinned to ClipRect edges ───────────────────
            // Top edge: sits right at lottieBoxTop
            Positioned(
              top: lottieBoxTop,
              left: 0,
              right: 0,
              child: _GlowEdgeLine(
                width: w,
                direction: _GlowDirection.leftToRight,
                streakFraction: 0.35,   // wider streak
                durationMs: 1200,       // faster
              ),
            ),
            // Bottom edge: sits at lottieBoxTop + lottieBoxH (minus line thickness)
            Positioned(
              top: lottieBoxTop + lottieBoxH - 2,
              left: 0,
              right: 0,
              child: _GlowEdgeLine(
                width: w,
                direction: _GlowDirection.rightToLeft,
                streakFraction: 0.35,
                durationMs: 1200,
              ),
            ),

            // ── 4. NEXUS title + subtitle (UNCHANGED) ─────────────────────
            Align(
              alignment: const Alignment(0, -0.75),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'NEXUS',
                    style: GoogleFonts.orbitron(
                      fontSize: 56,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      letterSpacing: 12,
                      shadows: [
                        Shadow(
                          color: Colors.black.withValues(alpha: 0.8),
                          blurRadius: 16,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'The Hub for Doers.',
                    style: GoogleFonts.sora(
                      fontSize: 20,
                      color: AppColors.neonCyan,
                      letterSpacing: 3,
                    ),
                  ),
                ],
              ),
            ),

            // ── 5. Bottom rocket + version (UNCHANGED) ────────────────────
            Positioned(
              bottom: 52,
              left: 0,
              right: 0,
              child: Column(
                children: [
                  const SafeLottie(
                    assetPath: 'assets/lottie/rocketlaunch.json',
                    width: 200,
                    height: 200,
                  ),
                  Text(
                    'v1.0.0 · Nexus',
                    style: GoogleFonts.nunito(
                      color: Colors.white54,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
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
    this.durationMs = 1200,
  });

  final double width;
  final _GlowDirection direction;
  final double streakFraction;
  final int durationMs;

  @override
  State<_GlowEdgeLine> createState() => _GlowEdgeLineState();
}

class _GlowEdgeLineState extends State<_GlowEdgeLine>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _anim;

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
      width: widget.width,
      height: 2,
      child: AnimatedBuilder(
        animation: _anim,
        builder: (_, __) {
          final progress = widget.direction == _GlowDirection.leftToRight
              ? _anim.value
              : 1.0 - _anim.value;

          final startFrac = progress - widget.streakFraction / 2;

          return CustomPaint(
            painter: _GlowLinePainter(
              startFrac: startFrac,
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
    required this.startFrac,
    required this.streakFraction,
  });

  final double startFrac;
  final double streakFraction;

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final cx = (startFrac + streakFraction / 2) * w;
    final half = streakFraction * w / 2;

    final paint = Paint()
      ..shader = const LinearGradient(
        colors: [
          Colors.transparent,
          Color(0x33FFFFFF), // 20% white shoulder
          Colors.white,      // full white core
          Color(0x33FFFFFF),
          Colors.transparent,
        ],
        stops: [0.0, 0.3, 0.5, 0.7, 1.0],
      ).createShader(Rect.fromLTWH(cx - half, 0, half * 2, size.height))
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.clipRect(Rect.fromLTWH(0, 0, w, size.height));
    canvas.drawLine(Offset(cx - half, 1), Offset(cx + half, 1), paint);
  }

  @override
  bool shouldRepaint(_GlowLinePainter old) =>
      old.startFrac != startFrac;
}