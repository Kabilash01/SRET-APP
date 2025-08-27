import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Color constants - Apple liquid glass palette
  static const Color beige = Color(0xFFF6EFE8);
  static const Color burgundy = Color(0xFF6B1020);
  static const Color navyBlue = Color(0xFF1E3A8A); // Navy blue color
  static const Color darkNavy = Color(0xFF1A2332); // Dark navy from image
  static const Color cream = Color(0xFFFFFDD0); // Cream color
  static const Color rose = Color(0xFFEADDD5);
  static const Color gold = Color(0xFFC7923A);
  static const Color textPrimary = Color(0xFF2B1E1E);
  static const Color textSecondary = Color(0xFF6C5959);
  static const Color lightBeige = Color(0xFFEDE8D0); // Light beige background
  static const Color backgroundColor = beige;
  
  // Legacy colors for compatibility
  static const Color sand = Color(0xFFF7EFE6);
  static const Color copper = Color(0xFFDFA06E);
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
          backgroundColor: navyBlue,
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
