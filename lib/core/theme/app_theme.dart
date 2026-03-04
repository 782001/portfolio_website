import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color primaryColor = Color(0xFF0CAB60);
  static const Color backgroundColor = Colors.black;
  static const Color surfaceColor = Color(0xFF0F0F0F);

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: primaryColor,
      scaffoldBackgroundColor: backgroundColor,
      colorScheme: ColorScheme.dark(
        primary: primaryColor,
        secondary: primaryColor,
        surface: surfaceColor,
        onSurface: Colors.white,
        onPrimary: Colors.white,
        surfaceContainerHighest: Colors.white.withOpacity(0.05),
      ),
      useMaterial3: true,
      textTheme: GoogleFonts.outfitTextTheme(ThemeData.dark().textTheme)
          .copyWith(
            displayLarge: const TextStyle(
              fontWeight: FontWeight.w900,
              color: Colors.white,
            ),
            displayMedium: const TextStyle(
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
            headlineLarge: const TextStyle(
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
            titleLarge: const TextStyle(
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 10,
          shadowColor: primaryColor.withOpacity(0.4),
          textStyle: GoogleFonts.outfit(
            fontWeight: FontWeight.w900,
            letterSpacing: 1.5,
            fontSize: 13,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.white,
          side: const BorderSide(color: Colors.white24, width: 2),
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          textStyle: GoogleFonts.outfit(
            fontWeight: FontWeight.w900,
            letterSpacing: 1.5,
            fontSize: 13,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white.withOpacity(0.05),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: primaryColor, width: 2),
        ),
        labelStyle: GoogleFonts.outfit(color: Colors.white70),
        hintStyle: GoogleFonts.outfit(color: Colors.white38),
      ),
    );
  }
}
