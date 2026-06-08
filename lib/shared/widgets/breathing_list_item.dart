import 'package:flutter/material.dart';

class AnimatedBreathingListItem extends StatefulWidget {
  final Widget child;
  final int delayMs;
  const AnimatedBreathingListItem({super.key, required this.child, this.delayMs = 0});

  @override
  State<AnimatedBreathingListItem> createState() => _AnimatedBreathingListItemState();
}

class _AnimatedBreathingListItemState extends State<AnimatedBreathingListItem>
    with SingleTickerProviderStateMixin {
  late final AnimationController _breathCtrl;
  late final Animation<double> _floatAnim;
  late final Animation<double> _opacityAnim;

  @override
  void initState() {
    super.initState();
    _breathCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2800),
    );
    _floatAnim = Tween<double>(begin: 0, end: -3)
      .chain(CurveTween(curve: Curves.easeInOut))
      .animate(_breathCtrl);
    _opacityAnim = Tween<double>(begin: 0.85, end: 1.0)
      .chain(CurveTween(curve: Curves.easeInOut))
      .animate(_breathCtrl);
    Future.delayed(Duration(milliseconds: widget.delayMs), () {
      if (mounted) _breathCtrl.repeat(reverse: true);
    });
  }

  @override
  void dispose() {
    _breathCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _breathCtrl,
      builder: (ctx, child) => Transform.translate(
        offset: Offset(0, _floatAnim.value),
        child: Opacity(
          opacity: _opacityAnim.value,
          child: child,
        ),
      ),
      child: widget.child,
    );
  }
}
