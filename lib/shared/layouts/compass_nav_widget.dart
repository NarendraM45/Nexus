import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:haptic_feedback/haptic_feedback.dart';
import 'dart:math' as math;
import '../widgets/custom/user_avatar.dart';
import '../widgets/custom/safe_lottie.dart';

class NavItem {
  final IconData icon;
  final String label;
  final String route;
  final Color color;
  NavItem(this.icon, this.label, this.route, this.color);
}

final List<NavItem> navItems = [
  NavItem(Icons.home_rounded, 'Home', '/home', const Color(0xFF00BCD4)),
  NavItem(Icons.track_changes_rounded, 'Status', '/status', const Color(0xFF00E5FF)),
  NavItem(Icons.task_alt_rounded, 'My Tasks', '/tasks', const Color(0xFFFFB300)),
  NavItem(Icons.account_tree_rounded, 'Projects', '/projects', const Color(0xFF00E5FF)),
  NavItem(Icons.note_alt_rounded, 'Notes', '/notes', const Color(0xFF00E676)),
  NavItem(Icons.explore_rounded, 'Explore', '/explore', const Color(0xFF7C4DFF)),
  NavItem(Icons.bar_chart_rounded, 'Analytics', '/analytics', const Color(0xFFFF9800)),
  NavItem(Icons.group_rounded, 'Team', '/team', const Color(0xFF10B981)),
  NavItem(Icons.calendar_month_rounded, 'Calendar', '/calendar', const Color(0xFFFF4081)),
  NavItem(Icons.person_rounded, 'Profile', '/profile', const Color(0xFFFF4081)),
];

class CompassNavWidget extends StatefulWidget {
  const CompassNavWidget({super.key});

  @override
  State<CompassNavWidget> createState() => _CompassNavWidgetState();
}

class _CompassNavWidgetState extends State<CompassNavWidget> with SingleTickerProviderStateMixin {
  bool _isOpen = false;
  int _activeIndex = -1;
  double _needleAngle = -math.pi / 2;
  
  late AnimationController _animCtrl;
  late Animation<double> _scaleAnim;
  late Animation<double> _fadeAnim;
  
  final GlobalKey _hubKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _animCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 300));
    _scaleAnim = CurvedAnimation(parent: _animCtrl, curve: Curves.elasticOut);
    _fadeAnim = CurvedAnimation(parent: _animCtrl, curve: Curves.easeIn);
  }

  @override
  void dispose() {
    _animCtrl.dispose();
    super.dispose();
  }

  void _toggleNav() {
    setState(() {
      _isOpen = !_isOpen;
      if (_isOpen) {
        _animCtrl.forward();
        _activeIndex = -1;
      } else {
        _animCtrl.reverse();
      }
    });
  }

  void _onPanStart(DragStartDetails details) {
    if (!_isOpen) _toggleNav();
    Haptics.vibrate(HapticsType.light);
    _updateDrag(details.globalPosition);
  }

  void _onPanUpdate(DragUpdateDetails details) {
    _updateDrag(details.globalPosition);
  }

  void _updateDrag(Offset globalPosition) {
    if (_hubKey.currentContext == null) return;
    final RenderBox renderBox = _hubKey.currentContext!.findRenderObject() as RenderBox;
    final hubCenter = renderBox.localToGlobal(renderBox.size.center(Offset.zero));
    
    final dx = globalPosition.dx - hubCenter.dx;
    final dy = globalPosition.dy - hubCenter.dy;
    
    final distance = math.sqrt(dx * dx + dy * dy);
    if (distance < 40) {
      if (_activeIndex != -1) setState(() => _activeIndex = -1);
      return;
    }
    
    double angle = math.atan2(dy, dx);
    if (angle > 0) angle = -0.001; // Clamp bottom half
    if (angle < -math.pi) angle = -math.pi; // Clamp

    double normalized = angle + math.pi; // 0 to pi
    final slice = math.pi / navItems.length;
    int index = (normalized / slice).clamp(0, navItems.length - 1).floor();

    setState(() {
      _needleAngle = angle;
    });

    if (_activeIndex != index) {
      setState(() => _activeIndex = index);
      Haptics.vibrate(HapticsType.selection);
    }
  }

  void _onPanEnd(DragEndDetails details) {
    if (_activeIndex != -1) {
      Haptics.vibrate(HapticsType.medium);
      final index = _activeIndex;
      
      // Snap needle
      setState(() {
        _needleAngle = -math.pi + (index + 0.5) * (math.pi / navItems.length);
      });
      
      Future.delayed(const Duration(milliseconds: 150), () {
        if (mounted) {
          context.go(navItems[index].route);
          _toggleNav();
        }
      });
    } else {
      _toggleNav();
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom + 12.0;

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(bottom: bottomPadding),
        child: Stack(
          alignment: Alignment.bottomCenter,
          clipBehavior: Clip.none,
          children: [
            // Arc & Icons
            ScaleTransition(
              scale: _scaleAnim,
              alignment: Alignment.bottomCenter,
              child: FadeTransition(
                opacity: _fadeAnim,
                child: SizedBox(
                  width: 380,
                  height: 200, // Accommodate outer radius
                  child: Stack(
                    alignment: Alignment.bottomCenter,
                    clipBehavior: Clip.none,
                    children: [
                      RepaintBoundary(
                        child: CustomPaint(
                          size: const Size(360, 180),
                          painter: _CompassArcPainter(activeIndex: _activeIndex),
                        ),
                      ),
                      
                      // Icons
                      ...List.generate(navItems.length, (i) {
                        final item = navItems[i];
                        final isActive = _activeIndex == i;
                        
                        final angle = -math.pi + (i + 0.5) * (math.pi / navItems.length);
                        final radius = isActive ? 160.0 : 145.0; // float icon up 15dp
                        final dx = radius * math.cos(angle);
                        final dy = radius * math.sin(angle);
                        
                        return AnimatedPositioned(
                          duration: const Duration(milliseconds: 200),
                          curve: Curves.easeOut,
                          bottom: -dy, // negative because y points up in math
                          left: 190 + dx - 20, // 190 is half of 380 width
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (isActive)
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 4.0),
                                  child: Text(
                                    item.label,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              AnimatedScale(
                                scale: isActive ? 1.08 : 1.0,
                                duration: const Duration(milliseconds: 200),
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: isActive ? item.color.withValues(alpha: 0.2) : Colors.transparent,
                                    boxShadow: isActive ? [BoxShadow(color: item.color.withValues(alpha: 0.5), blurRadius: 8)] : [],
                                  ),
                                  child: i == navItems.length - 1 
                                      ? const UserAvatar(size: 26, showEditButton: false, showOnlineDot: false)
                                      : Icon(item.icon, color: isActive ? Colors.white : item.color, size: 26),
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                      
                      // Needle
                      RepaintBoundary(
                        child: CustomPaint(
                          size: const Size(360, 180),
                          painter: _CompassNeedlePainter(angle: _needleAngle),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            
            // Hub
            GestureDetector(
              key: _hubKey,
              onTap: _toggleNav,
              onPanStart: _onPanStart,
              onPanUpdate: _onPanUpdate,
              onPanEnd: _onPanEnd,
              child: Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF00E5FF).withValues(alpha: 0.4),
                      blurRadius: 16,
                    )
                  ]
                ),
                child: ClipOval(
                  child: Container(
                    color: const Color(0xFF1E2030), // Dark base
                    child: Center(
                      child: _isOpen 
                        ? const Icon(Icons.close, color: Colors.white, size: 28)
                        : const SafeLottie(
                            assetPath: 'assets/lottie/3d.json',
                            width: 50, height: 50,
                            repeat: true,
                            fallback: Icon(Icons.grid_view, color: Colors.white, size: 28),
                          ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CompassArcPainter extends CustomPainter {
  final int activeIndex;
  _CompassArcPainter({required this.activeIndex});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height);
    const innerRadius = 110.0;
    const outerRadius = 180.0;
    
    // Draw segments
    final slice = math.pi / navItems.length;
    final sweepAngle = slice - 0.04; // gap
    const gap = 0.02;
    
    for (int i = 0; i < navItems.length; i++) {
      final startAngle = -math.pi + (i * slice) + gap;
      
      final path = Path();
      path.arcTo(Rect.fromCircle(center: center, radius: outerRadius), startAngle, sweepAngle, true);
      path.arcTo(Rect.fromCircle(center: center, radius: innerRadius), startAngle + sweepAngle, -sweepAngle, false);
      path.close();
      
      final isActive = activeIndex == i;
      final paint = Paint()
        ..color = isActive ? const Color(0xFF2A3050) : const Color(0xFF1E2030)
        ..style = PaintingStyle.fill
        ..isAntiAlias = true;
        
      canvas.drawPath(path, paint);
      
      if (isActive) {
        // Neon glow for active segment
        canvas.drawPath(path, Paint()
          ..color = const Color(0xFF00E5FF).withValues(alpha: 0.3)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2
          ..maskFilter = const MaskFilter.blur(BlurStyle.solid, 4));
      }
    }
  }

  @override
  bool shouldRepaint(covariant _CompassArcPainter oldDelegate) => oldDelegate.activeIndex != activeIndex;
}

class _CompassNeedlePainter extends CustomPainter {
  final double angle;
  _CompassNeedlePainter({required this.angle});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height);
    const needleLength = 130.0; // Reach past inner radius
    
    final endX = center.dx + needleLength * math.cos(angle);
    final endY = center.dy + needleLength * math.sin(angle);
    
    // Glowing Line
    final paint = Paint()
      ..color = const Color(0xFF00E5FF)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round
      ..isAntiAlias = true;
      
    // Shadow layers
    for (int i = 1; i <= 3; i++) {
      canvas.drawLine(center, Offset(endX, endY), Paint()
        ..color = const Color(0xFF00E5FF).withValues(alpha: 0.2 * (4-i))
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3.0 + i*2
        ..strokeCap = StrokeCap.round
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, i*2.0));
    }
    
    canvas.drawLine(center, Offset(endX, endY), paint);
    
    // Arrowhead at tip
    final arrowPath = Path();
    const arrowSize = 8.0;
    final tipAngle1 = angle + math.pi * 0.8;
    final tipAngle2 = angle - math.pi * 0.8;
    
    arrowPath.moveTo(endX, endY);
    arrowPath.lineTo(endX + arrowSize * math.cos(tipAngle1), endY + arrowSize * math.sin(tipAngle1));
    arrowPath.lineTo(endX + arrowSize * math.cos(tipAngle2), endY + arrowSize * math.sin(tipAngle2));
    arrowPath.close();
    
    canvas.drawPath(arrowPath, Paint()..color = const Color(0xFF00E5FF)..style = PaintingStyle.fill);
  }

  @override
  bool shouldRepaint(covariant _CompassNeedlePainter oldDelegate) => oldDelegate.angle != angle;
}
