import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_colors.dart';

class AppTheme {
  AppTheme._();

  static ThemeData darkTheme = _build(Brightness.dark);
  static ThemeData lightTheme = _build(Brightness.light);

  static ThemeData _build(Brightness brightness) {
    final isDark = brightness == Brightness.dark;

    final colorScheme = isDark
      ? const ColorScheme.dark(
          brightness: Brightness.dark,
          primary:       AppColors.neonPurple,
          onPrimary:     Colors.white,
          secondary:     AppColors.neonCyan,
          onSecondary:   Colors.black,
          tertiary:      AppColors.neonAmber,
          onTertiary:    Colors.black,
          surface:       AppColors.darkSurface,
          onSurface:     Color(0xFFE8EAFF),
          surfaceContainerHighest: AppColors.darkCard,
          error:         AppColors.neonCoral,
          onError:       Colors.white,
          outline:       AppColors.darkBorder,
        )
      : const ColorScheme.light(
          brightness: Brightness.light,
          primary:       AppColors.neonViolet,
          onPrimary:     Colors.white,
          secondary:     AppColors.neonAmber,
          onSecondary:   Colors.black,
          tertiary:      AppColors.neonCyan,
          onTertiary:    Colors.black,
          surface:       AppColors.lightSurface,
          onSurface:     AppColors.lightText,
          surfaceContainerHighest: AppColors.lightCard,
          error:         AppColors.neonCoral,
          onError:       Colors.white,
          outline:       AppColors.lightBorder,
        );

    final textTheme = TextTheme(
      displayLarge:  GoogleFonts.orbitron(
        fontWeight: FontWeight.w900,
        color: colorScheme.onSurface),
      headlineLarge:  GoogleFonts.sora(
        fontSize: 24, fontWeight: FontWeight.w700,
        color: colorScheme.onSurface),
      headlineMedium: GoogleFonts.sora(
        fontSize: 18, fontWeight: FontWeight.w600,
        color: colorScheme.onSurface),
      headlineSmall:  GoogleFonts.sora(
        fontSize: 15, fontWeight: FontWeight.w600,
        color: colorScheme.onSurface),
      bodyLarge:   GoogleFonts.nunito(
        fontSize: 15,
        color: colorScheme.onSurface),
      bodyMedium:  GoogleFonts.nunito(
        fontSize: 13,
        color: colorScheme.onSurface.withValues(alpha: 0.7)),
      bodySmall:   GoogleFonts.nunito(
        fontSize: 11,
        color: colorScheme.onSurface.withValues(alpha: 0.5)),
      labelLarge:  GoogleFonts.sora(
        fontSize: 13, fontWeight: FontWeight.w600,
        color: colorScheme.onSurface),
    );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colorScheme,
      textTheme: textTheme,
      scaffoldBackgroundColor: isDark ? AppColors.darkBg : AppColors.lightBg,
      cardColor: isDark ? AppColors.darkCard : AppColors.lightCard,
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        titleTextStyle: GoogleFonts.sora(
          fontSize: 20, fontWeight: FontWeight.w700,
          color: colorScheme.onSurface),
        iconTheme: IconThemeData(color: colorScheme.onSurface),
        systemOverlayStyle: isDark
          ? SystemUiOverlayStyle.light.copyWith(
              statusBarColor: Colors.transparent)
          : SystemUiOverlayStyle.dark.copyWith(
              statusBarColor: Colors.transparent),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        selectedItemColor: colorScheme.primary,
        unselectedItemColor: colorScheme.onSurface.withValues(alpha: 0.4),
        type: BottomNavigationBarType.fixed,
        elevation: 0,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: isDark ? AppColors.darkCard : AppColors.lightCard,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: colorScheme.primary, width: 1.5)),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: colorScheme.error, width: 1.5)),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16, vertical: 14),
        hintStyle: GoogleFonts.nunito(
          color: colorScheme.onSurface.withValues(alpha: 0.4)),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16)),
          padding: const EdgeInsets.symmetric(vertical: 16),
          textStyle: GoogleFonts.sora(
            fontWeight: FontWeight.w700, fontSize: 15),
          elevation: 0,
        ),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) =>
          states.contains(WidgetState.selected)
            ? colorScheme.primary : colorScheme.onSurface.withValues(alpha: 0.4)),
        trackColor: WidgetStateProperty.resolveWith((states) =>
          states.contains(WidgetState.selected)
            ? colorScheme.primary.withValues(alpha: 0.3)
            : colorScheme.onSurface.withValues(alpha: 0.1)),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24)),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(28))),
      ),
    );
  }
}
