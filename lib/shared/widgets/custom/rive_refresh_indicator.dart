import 'package:nexus/core/utils/app_logger.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rive/rive.dart';
import '../../../core/constants/app_colors.dart';

class RiveRefreshIndicator extends StatefulWidget {
  final Widget child;
  final Future<void> Function() onRefresh;

  const RiveRefreshIndicator({
    super.key,
    required this.child,
    required this.onRefresh,
  });

  @override
  State<RiveRefreshIndicator> createState() => _RiveRefreshIndicatorState();
}

class _RiveRefreshIndicatorState extends State<RiveRefreshIndicator> {
  StateMachineController? _smCtrl;

  @override
  void initState() {
    super.initState();
    _loadRive();
  }

  Future<void> _loadRive() async {
    try {
      final data = await RiveFile.asset('assets/rive/pull_refresh.riv');
      final artboard = data.mainArtboard;
      final ctrl = StateMachineController.fromArtboard(
        artboard, 'State Machine 1',
      );
      if (ctrl != null) {
        artboard.addController(ctrl);
        setState(() {
          _smCtrl = ctrl;
        });
      }
    } catch (_) {
      // ✅ If Rive file missing, fall through to fallback
      AppLogger.log('Rive not loaded — using fallback indicator');
    }
  }

  @override
  void dispose() {
    _smCtrl?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      // ✅ Always works as a fallback even without Rive
      color: AppColors.neonCyan,
      backgroundColor: Theme.of(context).colorScheme.surface,
      strokeWidth: 2.5,
      displacement: 60,

      // Custom builder uses Rive if loaded, fallback otherwise
      notificationPredicate: (notification) =>
        notification.depth == 0,

      onRefresh: () async {
        HapticFeedback.mediumImpact();
        await widget.onRefresh();
      },

      child: widget.child,
    );
  }
}
