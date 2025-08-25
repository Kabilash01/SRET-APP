import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Color constants
  static const Color creamBg = Color(0xFFFFF7E6);
  static const Color creamSurface = Color(0xFFFFF9EC);
  static const Color navy = Color(0xFF0D2240);
  static const Color divider = Color(0xFFE8E2D6);
  static const Color textSecondary = Color(0xFF4B5563);

  static ThemeData get lightTheme {
    final textTheme = GoogleFonts.robotoSerifTextTheme();
    
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      
      // Color scheme
      colorScheme: ColorScheme.fromSeed(
        seedColor: navy,
        brightness: Brightness.light,
        primary: navy,
        onPrimary: Colors.white,
        surface: creamSurface,
        onSurface: navy,
        surfaceContainerHighest: creamSurface,
      ),
      
      // Scaffold background
      scaffoldBackgroundColor: creamBg,
      
      // Divider theme
      dividerTheme: const DividerThemeData(
        color: divider,
        thickness: 1,
      ),
      
      // Text theme with Roboto Serif
      textTheme: textTheme.copyWith(
        displayLarge: textTheme.displayLarge?.copyWith(
          color: navy,
          fontWeight: FontWeight.bold,
        ),
        displayMedium: textTheme.displayMedium?.copyWith(
          color: navy,
          fontWeight: FontWeight.bold,
        ),
        headlineLarge: textTheme.headlineLarge?.copyWith(
          color: navy,
          fontWeight: FontWeight.bold,
        ),
        headlineMedium: textTheme.headlineMedium?.copyWith(
          color: navy,
          fontWeight: FontWeight.w600,
        ),
        titleLarge: textTheme.titleLarge?.copyWith(
          color: navy,
          fontWeight: FontWeight.w600,
        ),
        titleMedium: textTheme.titleMedium?.copyWith(
          color: navy,
          fontWeight: FontWeight.w500,
        ),
        bodyLarge: textTheme.bodyLarge?.copyWith(
          color: navy,
        ),
        bodyMedium: textTheme.bodyMedium?.copyWith(
          color: navy,
        ),
        bodySmall: textTheme.bodySmall?.copyWith(
          color: textSecondary,
        ),
      ),
      
      // Input decoration theme
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: divider),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: divider),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: navy, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red, width: 2),
        ),
        filled: true,
        fillColor: creamSurface,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        labelStyle: GoogleFonts.robotoSerif(color: textSecondary),
        hintStyle: GoogleFonts.robotoSerif(color: textSecondary),
      ),
      
      // Elevated button theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: navy,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
          minimumSize: const Size(0, 48),
          textStyle: GoogleFonts.robotoSerif(
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
      ),
      
      // Text button theme
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: navy,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          textStyle: GoogleFonts.robotoSerif(),
        ),
      ),
      
      // App bar theme
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: navy,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.robotoSerif(
          color: navy,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
