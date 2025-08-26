import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _navigateToLogin();
  }

  void _navigateToLogin() async {
    await Future.delayed(const Duration(seconds: 1));
    if (mounted) {
      context.go('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // SRET Logo
            Container(
              width: 280,
              height: 100,
              child: SvgPicture.asset(
                'assets/brand/sret_logo.svg',
                fit: BoxFit.contain,
              ),
            )
                .animate()
                .fadeIn(duration: 400.ms, curve: Curves.easeOut)
                .scale(begin: const Offset(0.8, 0.8), end: const Offset(1.0, 1.0)),
            
            const SizedBox(height: 32),
            
            // SRET Title (fallback)
            Text(
              'SRET',
              style: GoogleFonts.robotoSerif(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF0D2240), // NAVY
              ),
            )
                .animate(delay: 200.ms)
                .fadeIn(duration: 300.ms, curve: Curves.easeOut)
                .scale(begin: const Offset(0.8, 0.8), end: const Offset(1.0, 1.0)),
            
            const SizedBox(height: 16),
            
            // Full form subtitle
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Text(
                'Sri Ramachandra Faculty of\nEngineering and Technology',
                style: GoogleFonts.robotoSerif(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF4B5563), // TEXT_SECONDARY
                  height: 1.4,
                ),
                textAlign: TextAlign.center,
              ),
            )
                .animate(delay: 150.ms)
                .fadeIn(duration: 300.ms, curve: Curves.easeOut)
                .slideY(begin: 0.3, end: 0),
            
            const SizedBox(height: 48),
            
            // Progress indicator
            SizedBox(
              width: 200,
              child: const LinearProgressIndicator(
                backgroundColor: Color(0xFFE8E2D6), // DIVIDER
                valueColor: AlwaysStoppedAnimation<Color>(
                  Color(0xFF0D2240), // NAVY
                ),
              ),
            )
                .animate(delay: 300.ms)
                .fadeIn(duration: 300.ms, curve: Curves.easeOut)
                .slideY(begin: 0.5, end: 0),
          ],
        ),
      ),
    );
  }
}
