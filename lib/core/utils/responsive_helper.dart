import 'package:flutter/material.dart';

class ResponsiveHelper {
  static bool isMobile(BuildContext ctx) =>
      MediaQuery.of(ctx).size.width < 600;
  
  static bool isTablet(BuildContext ctx) =>
      MediaQuery.of(ctx).size.width >= 600 && MediaQuery.of(ctx).size.width < 900;
  
  static bool isDesktop(BuildContext ctx) =>
      MediaQuery.of(ctx).size.width >= 900;
  
  static double scale(BuildContext ctx, double mobile, [double? tablet, double? desktop]) {
    if (isDesktop(ctx)) return desktop ?? tablet ?? mobile;
    if (isTablet(ctx)) return tablet ?? mobile;
    return mobile;
  }
}
