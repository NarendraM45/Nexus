import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // ── Dark surfaces ──
  static const darkBg      = Color(0xFF080B18);
  static const darkSurface = Color(0xFF0F1428);
  static const darkCard    = Color(0xFF181D35);
  static const darkBorder  = Color(0x22FFFFFF);

  // ── Light surfaces ──
  static const lightBg      = Color(0xFFF2F4FF);
  static const lightSurface = Color(0xFFFFFFFF);
  static const lightCard    = Color(0xFFE8ECFF);
  static const lightBorder  = Color(0x18000000);
  static const lightText    = Color(0xFF0C0F22);
  static const lightSub     = Color(0xFF525A80);
  static const lightSubtext = Color(0xFF525A80);

  // ── Accents ──
  static const neonCyan    = Color(0xFF00D9F5);
  static const neonViolet  = Color(0xFF7C3AED);
  static const neonAmber   = Color(0xFFFFB84C);
  static const neonCoral   = Color(0xFFFF6B6B);
  static const neonGreen   = Color(0xFF10B981);
  static const neonRose    = Color(0xFFEC4899);
  static const neonPurple  = Color(0xFF9B5DE5);

  // ── Gradients ──
  static const LinearGradient primaryGrad = LinearGradient(
    colors: [Color(0xFF00D9F5), Color(0xFF7C3AED)],
    begin: Alignment.topLeft, end: Alignment.bottomRight,
  );

  static const LinearGradient nexusBrandGrad = LinearGradient(
    colors: [Color(0xFF9B5DE5), Color(0xFF4A1FCC)],
    begin: Alignment.topLeft, end: Alignment.bottomRight,
  );

  static const LinearGradient warmGrad = LinearGradient(
    colors: [Color(0xFFFFB84C), Color(0xFFFF6B6B)],
    begin: Alignment.topLeft, end: Alignment.bottomRight,
  );

  static const LinearGradient greenCyan = LinearGradient(
    colors: [Color(0xFF10B981), Color(0xFF00D9F5)],
    begin: Alignment.topLeft, end: Alignment.bottomRight,
  );

  static const LinearGradient roseViolet = LinearGradient(
    colors: [Color(0xFFEC4899), Color(0xFF7C3AED)],
    begin: Alignment.topLeft, end: Alignment.bottomRight,
  );

  // Legacy aliases for backward compat
  static const LinearGradient violetRoseGrad = roseViolet;
  static const LinearGradient greenCyanGrad = greenCyan;
  static const LinearGradient roseCoral = LinearGradient(
    colors: [Color(0xFFEC4899), Color(0xFFFF6B6B)],
    begin: Alignment.topLeft, end: Alignment.bottomRight,
  );
}
