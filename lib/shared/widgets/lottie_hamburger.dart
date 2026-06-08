import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'custom/safe_lottie.dart';

class LottieHamburger extends StatelessWidget {
  const LottieHamburger({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    Widget lottieWidget = SafeLottie(
      assetPath: 'assets/lottie/hamburger_menu.json',
      width: 28, height: 28,
      repeat: false,
      fallback: Icon(Icons.menu_rounded,
        color: Theme.of(context).colorScheme.onSurface, size: 26),
    );

    if (isDark) {
      lottieWidget = ColorFiltered(
        colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
        child: lottieWidget,
      );
    }

    return GestureDetector(
      onTap: () {
        ScaffoldState? state = Scaffold.maybeOf(context);
        while (state != null && !state.hasDrawer) {
          state = state.context.findAncestorStateOfType<ScaffoldState>();
        }
        state?.openDrawer();
        HapticFeedback.selectionClick();
      },
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: lottieWidget,
      ),
    );
  }
}
