import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/sret_theme.dart';

class CalendarPage extends StatelessWidget {
  const CalendarPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.beige,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppTheme.beige,
              AppTheme.sand.withOpacity(0.8),
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.calendar_today,
                size: 64,
                color: AppTheme.burgundy.withOpacity(0.5),
              ),
              const SizedBox(height: 16),
              Text(
                'Calendar',
                style: GoogleFonts.robotoSerif(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.burgundy,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Coming Soon',
                style: GoogleFonts.robotoSerif(
                  fontSize: 16,
                  color: AppTheme.burgundy.withOpacity(0.7),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
