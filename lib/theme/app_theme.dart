import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  // Primary palette
  static const Color scaffoldBackground = Color(0xFFF6EFE8); // Beige
  static const Color background = Color(0xFFF6EFE8); // Alias for scaffoldBackground
  static const Color primary = Color(0xFF6B1020); // Burgundy
  static const Color onPrimary = Colors.white;
  
  // Text colors
  static const Color textPrimary = Color(0xFF2B1E1E);
  static const Color textSecondary = Color(0xFF6C5959);
  
  // Surface and accents
  static const Color surface = Color(0xFFEADDD5); // Rose
  static const Color accent = Color(0xFFC7923A); // Gold
  static const Color outline = Color(0xFFD2C2B5); // Muted outline color
  
  // Legacy color names for backward compatibility
  static const Color burgundy = primary; // Alias for primary
  
  // Glass effect colors
  static const Color glassStroke = Color(0x59FFFFFF); // white@35%
  static const Color glassFill1 = Color(0x29FFFFFF); // white@16%
  static const Color glassFill2 = Color(0x0FFFFFFF); // white@6%
  static const Color glassHighlight = Color(0x1AFFFFFF); // white@10%
  static const Color glassShadow = Color(0x14000000); // black@8%
}

class AppTheme {
  static ThemeData get light {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.scaffoldBackground,
      fontFamily: GoogleFonts.robotoSerif().fontFamily, // Set default font family
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        brightness: Brightness.light,
        primary: AppColors.primary,
        onPrimary: AppColors.onPrimary,
        surface: AppColors.surface,
      ),
      textTheme: TextTheme(
        headlineLarge: GoogleFonts.robotoSerif(
          color: AppColors.primary,
          fontSize: 36,
          fontWeight: FontWeight.w900,
          letterSpacing: -0.8,
        ),
        headlineMedium: GoogleFonts.robotoSerif(
          color: AppColors.primary,
          fontSize: 26,
          fontWeight: FontWeight.w800,
        ),
        headlineSmall: GoogleFonts.robotoSerif(
          color: AppColors.primary,
          fontSize: 22,
          fontWeight: FontWeight.w700,
        ),
        titleLarge: GoogleFonts.robotoSerif(
          color: AppColors.primary,
          fontSize: 22,
          fontWeight: FontWeight.w700,
        ),
        titleMedium: GoogleFonts.robotoSerif(
          color: AppColors.primary,
          fontSize: 17,
          fontWeight: FontWeight.w600,
        ),
        titleSmall: GoogleFonts.robotoSerif(
          color: AppColors.primary,
          fontSize: 15,
          fontWeight: FontWeight.w600,
        ),
        bodyLarge: GoogleFonts.robotoSerif(
          color: AppColors.textPrimary,
          fontSize: 17,
          fontWeight: FontWeight.w500,
        ),
        bodyMedium: GoogleFonts.robotoSerif(
          color: AppColors.textPrimary,
          fontSize: 15,
          fontWeight: FontWeight.w500,
        ),
        bodySmall: GoogleFonts.robotoSerif(
          color: AppColors.textSecondary,
          fontSize: 13,
          fontWeight: FontWeight.w400,
        ),
        labelLarge: GoogleFonts.robotoSerif(
          color: AppColors.textPrimary,
          fontSize: 15,
          fontWeight: FontWeight.w600,
        ),
        labelMedium: GoogleFonts.robotoSerif(
          color: AppColors.textPrimary,
          fontSize: 13,
          fontWeight: FontWeight.w500,
        ),
        labelSmall: GoogleFonts.robotoSerif(
          color: AppColors.textSecondary,
          fontSize: 11,
          fontWeight: FontWeight.w500,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: false,
        border: InputBorder.none,
        enabledBorder: InputBorder.none,
        focusedBorder: InputBorder.none,
        errorBorder: InputBorder.none,
        focusedErrorBorder: InputBorder.none,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        hintStyle: GoogleFonts.robotoSerif(
          color: AppColors.textSecondary.withValues(alpha: 0.7),
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.onPrimary,
          minimumSize: const Size(double.infinity, 52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(26),
          ),
          elevation: 0,
          textStyle: GoogleFonts.robotoSerif(
            fontSize: 17,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary,
          textStyle: GoogleFonts.robotoSerif(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.scaffoldBackground,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        titleTextStyle: GoogleFonts.robotoSerif(
          color: AppColors.textPrimary,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

extension AppThemeExtension on AppTheme {
  static Color get beige => AppColors.scaffoldBackground;
  static Color get sand => AppColors.surface;
}
