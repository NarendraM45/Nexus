import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'dart:ui';
import '../../../core/constants/app_typography.dart';
import '../../../models/feature_item_model.dart';

class FeatureCard extends StatefulWidget {
  final FeatureItem feature;
  final VoidCallback onTap;

  const FeatureCard({super.key, required this.feature, required this.onTap});

  @override
  State<FeatureCard> createState() => _FeatureCardState();
}

class _FeatureCardState extends State<FeatureCard> {
  double _xOffset = 0;
  double _yOffset = 0;

  void _onPanUpdate(DragUpdateDetails details) {
    setState(() {
      _xOffset += details.delta.dx;
      _yOffset += details.delta.dy;
    });
  }

  void _onPanEnd(DragEndDetails details) {
    setState(() {
      _xOffset = 0;
      _yOffset = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final transform = Matrix4.identity()
      ..setEntry(3, 2, 0.001)
      ..rotateX(0.01 * _yOffset)
      ..rotateY(-0.01 * _xOffset);

    return GestureDetector(
      onPanUpdate: _onPanUpdate,
      onPanEnd: _onPanEnd,
      onTap: () {
        HapticFeedback.lightImpact();
        context.go(widget.feature.route);
        widget.onTap(); // Keep original callback if any
      },
      child: Transform(
        transform: transform,
        alignment: FractionalOffset.center,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              decoration: BoxDecoration(
                gradient: widget.feature.gradient, // Use specific gradient
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white.withValues(alpha: 0.12), width: 1),
              ),
              child: Stack(
                children: [
                  // Gradient Shimmer Background
                  Positioned(
                    right: -20,
                    bottom: -20,
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: widget.feature.glowColor.withValues(alpha: 0.2),
                        boxShadow: [
                          BoxShadow(color: widget.feature.glowColor.withValues(alpha: 0.5), blurRadius: 40)
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(widget.feature.icon, color: Colors.white, size: 32),
                        const Spacer(),
                        if (widget.feature.subtitle != null)
                          Text(
                            widget.feature.subtitle!,
                            style: AppTypography.bodySmall(Theme.of(context).colorScheme.onSurface).copyWith(color: Colors.white70),
                          ),
                        Text(
                          widget.feature.title,
                          style: AppTypography.h2(Theme.of(context).colorScheme.onSurface).copyWith(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
