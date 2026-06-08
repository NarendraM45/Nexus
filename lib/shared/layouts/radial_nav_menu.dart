import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:haptic_feedback/haptic_feedback.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'dart:math' as math;
import 'dart:ui';
import '../../core/constants/app_colors.dart';

class NavItem {
  final IconData icon;
  final String label;
  final String route;
  final Color color;

  NavItem(this.icon, this.label, this.route, this.color);
}

final List<NavItem> navItems = [
  NavItem(Icons.home_rounded, 'Home', '/home', AppColors.neonCyan),
  NavItem(Icons.explore_rounded, 'Explore', '/explore', AppColors.neonViolet),
  NavItem(Icons.task_alt_rounded, 'Tasks', '/tasks', AppColors.neonGreen),
  NavItem(Icons.calendar_month_rounded, 'Calendar', '/calendar', AppColors.neonRose),
  NavItem(Icons.people_rounded, 'Team', '/team', AppColors.neonAmber),
  NavItem(Icons.auto_graph_rounded, 'Activity', '/activity', const Color(0xFF10B981)),
  NavItem(Icons.bar_chart_rounded, 'Analytics', '/analytics', const Color(0xFFF59E0B)),
  NavItem(Icons.person_rounded, 'Profile', '/profile', AppColors.neonCoral),
];

class RadialNavMenu extends StatefulWidget {
  final Widget child;
  const RadialNavMenu({super.key, required this.child});

  @override
  State<RadialNavMenu> createState() => _RadialNavMenuState();
}

class _RadialNavMenuState extends State<RadialNavMenu> with SingleTickerProviderStateMixin {
  bool _isOpen = false;
  int _hoveredIndex = -1;
  final double _radius = 140.0;
  final GlobalKey _fabKey = GlobalKey();

  void _onPanStart(DragStartDetails details) {
    Haptics.vibrate(HapticsType.medium);
    setState(() {
      _isOpen = true;
      _hoveredIndex = -1;
    });
    _updateHover(details.globalPosition);
  }

  void _onPanUpdate(DragUpdateDetails details) {
    _updateHover(details.globalPosition);
  }

  void _updateHover(Offset globalPosition) {
    if (_fabKey.currentContext == null) return;
    final RenderBox renderBox = _fabKey.currentContext!.findRenderObject() as RenderBox;
    final fabCenter = renderBox.localToGlobal(renderBox.size.center(Offset.zero));
    
    final dx = globalPosition.dx - fabCenter.dx;
    final dy = globalPosition.dy - fabCenter.dy;
    
    // Only process if user dragged far enough from center to avoid accidental selection
    final distance = math.sqrt(dx * dx + dy * dy);
    if (distance < 40) {
      if (_hoveredIndex != -1) {
        setState(() => _hoveredIndex = -1);
      }
      return;
    }

    double angle = math.atan2(dy, dx);
    
    // Normalize angle to be between 0 and -pi (upper semicircle)
    if (angle > 0) angle = -0.01; // Restrict to upper hemisphere
    if (angle < -math.pi) angle = -math.pi;

    // We have 8 items spanning 0 to -pi.
    // Index 0 is at 0 (right), Index 7 is at -pi (left)
    // Slice size = pi / 7 (since there are 7 intervals between 8 items)
    const sliceSize = math.pi / 7;
    
    // Reverse mapping angle to index
    int index = (-angle / sliceSize).round();
    index = index.clamp(0, 7);

    if (_hoveredIndex != index) {
      Haptics.vibrate(HapticsType.light);
      setState(() {
        _hoveredIndex = index;
      });
    }
  }

  void _onPanEnd(DragEndDetails details) {
    if (_hoveredIndex != -1) {
      Haptics.vibrate(HapticsType.success);
      context.go(navItems[_hoveredIndex].route);
    } else {
      Haptics.vibrate(HapticsType.light); // Cancelled
    }
    setState(() {
      _isOpen = false;
      _hoveredIndex = -1;
    });
  }

  void _toggleMenu() {
    setState(() {
      _isOpen = !_isOpen;
      _hoveredIndex = -1;
    });
    if (_isOpen) Haptics.vibrate(HapticsType.medium);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Stack(
      children: [
        widget.child,
        
        // Glassmorphic Overlay
        if (_isOpen)
          Positioned.fill(
            child: GestureDetector(
              onTap: _toggleMenu,
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  color: (isDark ? Colors.black : Colors.white).withValues(alpha: 0.6),
                ).animate().fadeIn(duration: 200.ms),
              ),
            ),
          ),

        // Radial Menu Items
        if (_isOpen)
          ...List.generate(navItems.length, (index) {
            final item = navItems[index];
            final angle = -math.pi * (index / 7);
            final dx = _radius * math.cos(angle);
            final dy = _radius * math.sin(angle);
            final isHovered = _hoveredIndex == index;

            return Positioned(
              bottom: 40 + MediaQuery.of(context).padding.bottom + 28 - dy,
              left: MediaQuery.of(context).size.width / 2 - 28 + dx,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeOutBack,
                transform: Matrix4.diagonal3Values(isHovered ? 1.4 : 1.0, isHovered ? 1.4 : 1.0, 1.0),
                transformAlignment: Alignment.center,
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkCard : AppColors.lightCard,
                  shape: BoxShape.circle,
                  boxShadow: isHovered ? [
                    BoxShadow(color: item.color.withValues(alpha: 0.5), blurRadius: 20, spreadRadius: 2)
                  ] : [],
                  border: Border.all(color: item.color.withValues(alpha: isHovered ? 1.0 : 0.3), width: isHovered ? 2 : 1),
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    customBorder: const CircleBorder(),
                    onTap: () {
                      Haptics.vibrate(HapticsType.success);
                      context.go(item.route);
                      setState(() {
                        _isOpen = false;
                        _hoveredIndex = -1;
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Icon(item.icon, color: item.color, size: 24),
                    ),
                  ),
                ),
              ).animate()
               .scaleXY(begin: 0, end: 1, duration: 300.ms, curve: Curves.easeOutBack, delay: (index * 30).ms)
               .fadeIn(),
            );
          }),

        // Central FAB (Always visible)
        Positioned(
          bottom: 40 + MediaQuery.of(context).padding.bottom,
          left: MediaQuery.of(context).size.width / 2 - 32,
          child: GestureDetector(
            key: _fabKey,
            onPanStart: _onPanStart,
            onPanUpdate: _onPanUpdate,
            onPanEnd: _onPanEnd,
            onLongPressStart: (_) => _onPanStart(DragStartDetails(globalPosition: Offset.zero)), // Fallback
            onLongPressUp: () => _onPanEnd(DragEndDetails()),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 64, height: 64,
              decoration: BoxDecoration(
                gradient: AppColors.primaryGrad,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(color: AppColors.neonCyan.withValues(alpha: 0.4), blurRadius: 20, spreadRadius: _isOpen ? 5 : 0)
                ],
              ),
              child: FloatingActionButton(
                heroTag: 'radial_fab',
                elevation: 0,
                backgroundColor: Colors.transparent,
                onPressed: _toggleMenu,
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  transitionBuilder: (child, anim) => RotationTransition(
                    turns: child.key == const ValueKey('close') 
                      ? Tween<double>(begin: -0.5, end: 0).animate(anim)
                      : Tween<double>(begin: 0.5, end: 0).animate(anim),
                    child: FadeTransition(opacity: anim, child: child),
                  ),
                  child: Icon(
                    _isOpen ? Icons.close_rounded : Icons.apps_rounded,
                    key: ValueKey(_isOpen ? 'close' : 'open'),
                    color: Colors.white,
                    size: 32,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
