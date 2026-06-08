import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTypography {
  AppTypography._();

  // Orbitron — display/impact numbers only
  static TextStyle display(Color color) => GoogleFonts.orbitron(
    fontSize: 36, fontWeight: FontWeight.w900,
    color: color, letterSpacing: 1.5,
  );

  // Sora — all headings and labels
  static TextStyle h1(Color color) => GoogleFonts.sora(
    fontSize: 24, fontWeight: FontWeight.w700, color: color,
  );
  static TextStyle h2(Color color) => GoogleFonts.sora(
    fontSize: 18, fontWeight: FontWeight.w600, color: color,
  );
  static TextStyle h3(Color color) => GoogleFonts.sora(
    fontSize: 15, fontWeight: FontWeight.w600, color: color,
  );
  static TextStyle label(Color color) => GoogleFonts.sora(
    fontSize: 11, fontWeight: FontWeight.w500,
    color: color, letterSpacing: 0.5,
  );

  // Nunito — all body text
  static TextStyle body(Color color) => GoogleFonts.nunito(
    fontSize: 15, fontWeight: FontWeight.w400, color: color,
  );
  static TextStyle bodySmall(Color color) => GoogleFonts.nunito(
    fontSize: 13, fontWeight: FontWeight.w400, color: color,
  );
  static TextStyle bodySemiBold(Color color) => GoogleFonts.nunito(
    fontSize: 15, fontWeight: FontWeight.w600, color: color,
  );
}
