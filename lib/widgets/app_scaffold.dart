import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'liquid_glass.dart';
import 'liquid_pill_nav.dart';
import '../theme/sret_theme.dart';

// Toggle for department tab
const bool kShowDept = true;

class AppScaffold extends StatelessWidget {
  final Widget body;
  final int currentIndex;
  final String title;

  const AppScaffold({
    super.key,
    required this.body,
    required this.currentIndex,
    this.title = '',
  });

  @override
  Widget build(BuildContext context) {
    // Check if this is the Today page to remove padding and AppBar
    final isTodayPage = currentIndex == 0;
    
    return Scaffold(
      appBar: (title.isNotEmpty && !isTodayPage)
          ? AppBar(
              title: Text(title),
              backgroundColor: Colors.transparent,
              elevation: 0,
            )
          : null,
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
        child: isTodayPage 
            ? body // No padding for Today page
            : Padding(
                padding: const EdgeInsets.all(24),
                child: body,
              ),
      ),
      bottomNavigationBar: _buildLiquidGlassNavigation(context),
    );
  }

  Widget _buildLiquidGlassNavigation(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppTheme.beige.withOpacity(0.0),
            AppTheme.beige,
          ],
        ),
      ),
      child: LiquidPillNav(
        selectedIndex: currentIndex,
        onChanged: (index) {
          switch (index) {
            case 0:
              context.go('/today');
              break;
            case 1:
              context.go('/timetable');
              break;
            case 2:
              context.go('/calendar');
              break;
            case 3:
              context.go('/inbox');
              break;
            case 4:
              context.go('/dept');
              break;
          }
        },
      ),
    );
  }

}
