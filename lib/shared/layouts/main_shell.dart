import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'compass_nav_widget.dart';
import 'drawer_layout.dart';
import '../../core/providers/nav_state_provider.dart';

class MainShell extends ConsumerWidget {
  final Widget child;

  const MainShell({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentRoute = GoRouterState.of(context).uri.path;
    final isHome = currentRoute == '/home' || currentRoute == '/';
    final navVisible = ref.watch(navVisibleProvider);

    return PopScope(
      canPop: isHome,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop && !isHome) {
          context.go('/home');
        }
      },
      child: Scaffold(
        drawer: DrawerLayout(
          onNavigate: (index) {},
        ),
        body: Stack(
          children: [
            child,
            Positioned(
              bottom: 0, left: 0, right: 0,
              child: AnimatedSlide(
                offset: navVisible ? Offset.zero : const Offset(0, 1),
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeInOut,
                child: AnimatedOpacity(
                  opacity: navVisible ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 200),
                  child: const CompassNavWidget(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
