import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Color constants
  static const Color beige = Color(0xFFFAF6F1);
  static const Color burgundy = Color(0xFF7A0E2A);
  static const Color sand = Color(0xFFF7EFE6);
  static const Color copper = Color(0xFFDFA06E);
  static const Color textPrimary = Color(0xFF1F1B16);
  static const Color textSecondary = Color(0xFF4B5563);
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color outline = Color(0xFFE7DED3);

  static ThemeData get light {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: burgundy,
      brightness: Brightness.light,
    ).copyWith(
      primary: burgundy,
      surface: beige,
      background: beige,
      onPrimary: onPrimary,
      onSurface: textPrimary,
      onBackground: textPrimary,
      outline: outline,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: beige,
      fontFamily: GoogleFonts.robotoSerif().fontFamily,
      textTheme: GoogleFonts.robotoSerifTextTheme().copyWith(
        displayLarge: GoogleFonts.robotoSerif(
          fontWeight: FontWeight.bold,
          color: textPrimary,
        ),
        displayMedium: GoogleFonts.robotoSerif(
          fontWeight: FontWeight.bold,
          color: textPrimary,
        ),
        displaySmall: GoogleFonts.robotoSerif(
          fontWeight: FontWeight.bold,
          color: textPrimary,
        ),
        headlineLarge: GoogleFonts.robotoSerif(
          fontWeight: FontWeight.w600,
          color: textPrimary,
        ),
        headlineMedium: GoogleFonts.robotoSerif(
          fontWeight: FontWeight.w600,
          color: textPrimary,
        ),
        headlineSmall: GoogleFonts.robotoSerif(
          fontWeight: FontWeight.w600,
          color: textPrimary,
        ),
        titleLarge: GoogleFonts.robotoSerif(
          fontWeight: FontWeight.w600,
          color: textPrimary,
        ),
        titleMedium: GoogleFonts.robotoSerif(
          fontWeight: FontWeight.w600,
          color: textPrimary,
        ),
        titleSmall: GoogleFonts.robotoSerif(
          fontWeight: FontWeight.w500,
          color: textPrimary,
        ),
        bodyLarge: GoogleFonts.robotoSerif(
          fontWeight: FontWeight.normal,
          color: textPrimary,
        ),
        bodyMedium: GoogleFonts.robotoSerif(
          fontWeight: FontWeight.normal,
          color: textPrimary,
        ),
        bodySmall: GoogleFonts.robotoSerif(
          fontWeight: FontWeight.normal,
          color: textSecondary,
        ),
        labelLarge: GoogleFonts.robotoSerif(
          fontWeight: FontWeight.w500,
          color: textPrimary,
        ),
        labelMedium: GoogleFonts.robotoSerif(
          fontWeight: FontWeight.w500,
          color: textPrimary,
        ),
        labelSmall: GoogleFonts.robotoSerif(
          fontWeight: FontWeight.w500,
          color: textSecondary,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: burgundy,
          foregroundColor: onPrimary,
          minimumSize: const Size(double.infinity, 48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: GoogleFonts.robotoSerif(
            fontWeight: FontWeight.w500,
            fontSize: 16,
          ),
        ),
      ),
      cardTheme: const CardThemeData(
        color: Colors.transparent,
        elevation: 0,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        titleTextStyle: TextStyle(
          color: textPrimary,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
        iconTheme: IconThemeData(color: textPrimary),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: beige,
        selectedItemColor: burgundy,
        unselectedItemColor: textSecondary,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        selectedLabelStyle: GoogleFonts.robotoSerif(
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
        unselectedLabelStyle: GoogleFonts.robotoSerif(
          fontSize: 12,
          fontWeight: FontWeight.normal,
        ),
      ),
    );
  }
}
