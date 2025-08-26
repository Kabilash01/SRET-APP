import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // SRET Color Tokens
  static const Color sretBg = Color(0xFFFAF6F1);           // SRET/BG
  static const Color sretSurface = Color(0xFFF7EFE6);      // SRET/Surface
  static const Color sretPrimary = Color(0xFF7A0E2A);      // SRET/Primary (Burgundy)
  static const Color sretAccent = Color(0xFFDFA06E);       // SRET/Accent (Copper)
  static const Color sretText = Color(0xFF1F1B16);         // SRET/Text
  static const Color sretTextSecondary = Color(0xFF4B5563); // SRET/TextSecondary
  static const Color sretDivider = Color(0xFFE7DED3);      // SRET/Divider

  // Glass effect colors
  static const Color glassFrost = Color(0x29FFFFFF);       // White @16%
  static const Color glassBorder = Color(0x38FFFFFF);      // White @22%
  static const Color glassShadow = Color(0x1A7A0E2A);      // Burgundy @10%

  static ThemeData get lightTheme {
    final textTheme = GoogleFonts.robotoSerifTextTheme();
    
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      
      // Color scheme with SRET colors
      colorScheme: ColorScheme.fromSeed(
        seedColor: sretPrimary,
        brightness: Brightness.light,
        primary: sretPrimary,
        onPrimary: Colors.white,
        secondary: sretAccent,
        onSecondary: sretText,
        surface: sretSurface,
        onSurface: sretText,
        surfaceContainerHighest: sretSurface,
        outline: sretDivider,
      ),
      
      // Scaffold background
      scaffoldBackgroundColor: sretBg,
      
      // App Bar theme with frosted glass
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        titleTextStyle: textTheme.titleLarge?.copyWith(
          color: sretText,
          fontWeight: FontWeight.w600,
        ),
        iconTheme: const IconThemeData(color: sretText),
      ),
      
      // Card theme with frosted glass effect
      cardTheme: CardThemeData(
        color: glassFrost,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: glassBorder, width: 1),
        ),
        margin: const EdgeInsets.all(0),
      ),
      
      // Divider theme
      dividerTheme: const DividerThemeData(
        color: sretDivider,
        thickness: 1,
      ),
      
      // Text theme with Roboto Serif and SRET colors
      textTheme: textTheme.copyWith(
        displayLarge: textTheme.displayLarge?.copyWith(
          color: sretText,
          fontWeight: FontWeight.bold,
        ),
        displayMedium: textTheme.displayMedium?.copyWith(
          color: sretText,
          fontWeight: FontWeight.bold,
        ),
        headlineLarge: textTheme.headlineLarge?.copyWith(
          color: sretText,
          fontWeight: FontWeight.bold,
        ),
        headlineMedium: textTheme.headlineMedium?.copyWith(
          color: sretText,
          fontWeight: FontWeight.w600,
        ),
        titleLarge: textTheme.titleLarge?.copyWith(
          color: sretText,
          fontWeight: FontWeight.w600,
        ),
        titleMedium: textTheme.titleMedium?.copyWith(
          color: sretText,
          fontWeight: FontWeight.w500,
        ),
        bodyLarge: textTheme.bodyLarge?.copyWith(
          color: sretText,
        ),
        bodyMedium: textTheme.bodyMedium?.copyWith(
          color: sretText,
        ),
        bodySmall: textTheme.bodySmall?.copyWith(
          color: sretTextSecondary,
        ),
        labelLarge: textTheme.labelLarge?.copyWith(
          color: sretText,
          fontWeight: FontWeight.w500,
        ),
      ),
      
      // Button themes with SRET colors
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: sretPrimary,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          minimumSize: const Size(88, 48),
          textStyle: textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: sretPrimary,
          side: const BorderSide(color: sretPrimary, width: 1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          minimumSize: const Size(88, 48),
          textStyle: textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: sretPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          minimumSize: const Size(88, 48),
          textStyle: textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      
      // Input field themes
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: sretSurface.withValues(alpha: 0.8),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: sretDivider, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: sretDivider, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: sretPrimary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Colors.red, width: 1),
        ),
        labelStyle: textTheme.bodyMedium?.copyWith(color: sretTextSecondary),
        hintStyle: textTheme.bodyMedium?.copyWith(color: sretTextSecondary),
        helperStyle: textTheme.bodySmall?.copyWith(color: sretTextSecondary),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
      
      // Checkbox theme
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return sretPrimary;
          }
          return Colors.transparent;
        }),
        checkColor: WidgetStateProperty.all(Colors.white),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      ),
      
      // Bottom navigation theme
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: glassFrost,
        selectedItemColor: sretPrimary,
        unselectedItemColor: sretTextSecondary,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        selectedLabelStyle: textTheme.bodySmall?.copyWith(
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: textTheme.bodySmall,
      ),
      
      // Snackbar theme
      snackBarTheme: SnackBarThemeData(
        backgroundColor: glassFrost,
        contentTextStyle: textTheme.bodyMedium?.copyWith(color: sretText),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        behavior: SnackBarBehavior.floating,
        elevation: 0,
      ),
    );
  }
  
  // Glass Effect Utilities
  
  /// Frosted glass effect for standard cards and components
  static BoxDecoration get frostedGlass => BoxDecoration(
    color: glassFrost,
    borderRadius: BorderRadius.circular(20),
    border: Border.all(color: glassBorder, width: 1),
    boxShadow: [
      BoxShadow(
        color: glassShadow,
        blurRadius: 24,
        offset: const Offset(0, 8),
      ),
    ],
  );
  
  /// Liquid glass effect for hero components (splash, sign-in, next class card)
  static BoxDecoration get liquidGlass => BoxDecoration(
    gradient: const LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        Color(0x33FFFFFF), // White 20%
        Color(0x0FFFFFFF), // White 6%
      ],
    ),
    borderRadius: BorderRadius.circular(28),
    border: Border.all(color: glassBorder, width: 1),
    boxShadow: [
      BoxShadow(
        color: glassShadow,
        blurRadius: 24,
        offset: const Offset(0, 8),
      ),
    ],
  );
  
  /// Frosted glass for bottom sheets
  static BoxDecoration get bottomSheetGlass => BoxDecoration(
    color: glassFrost,
    borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
    border: const Border(
      top: BorderSide(color: glassBorder, width: 1),
      left: BorderSide(color: glassBorder, width: 1),
      right: BorderSide(color: glassBorder, width: 1),
    ),
    boxShadow: [
      BoxShadow(
        color: glassShadow,
        blurRadius: 24,
        offset: const Offset(0, -8),
      ),
    ],
  );
  
  /// Background blurred blobs decoration
  static Widget get backgroundBlobs => Container(
    decoration: const BoxDecoration(
      gradient: RadialGradient(
        center: Alignment.topLeft,
        radius: 1.5,
        colors: [
          Color(0x1A7A0E2A), // Burgundy 10%
          Color(0x0A7A0E2A), // Burgundy 4%
        ],
      ),
    ),
    child: Container(
      decoration: const BoxDecoration(
        gradient: RadialGradient(
          center: Alignment.bottomRight,
          radius: 1.2,
          colors: [
            Color(0x1ADFA06E), // Copper 10%
            Color(0x0ADFA06E), // Copper 4%
          ],
        ),
      ),
    ),
  );
}
