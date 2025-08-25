import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/auth/auth_controller.dart';
import '../shared/glass_card.dart';
import '../shared/bouncy_button.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authControllerProvider);
    final user = authState.value;

    return Scaffold(
      backgroundColor: const Color(0xFFFFF7E6), // CREAM_BG
      appBar: AppBar(
        title: Text(
          'Home',
          style: GoogleFonts.robotoSerif(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF0D2240),
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              // User Profile Card
              GlassCard(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    // User Avatar
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color(0xFF0D2240),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.3),
                          width: 2,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          _getInitials(user?.name ?? 'U'),
                          style: GoogleFonts.robotoSerif(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // User Name
                    Text(
                      user?.name ?? 'Welcome User',
                      style: GoogleFonts.robotoSerif(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF0D2240),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    
                    const SizedBox(height: 8),
                    
                    // User Email
                    Text(
                      user?.email ?? 'user@sret.edu',
                      style: GoogleFonts.robotoSerif(
                        fontSize: 16,
                        color: const Color(0xFF4B5563),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 32),
              
              // Welcome Message
              GlassCard(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    Icon(
                      Icons.school,
                      size: 48,
                      color: const Color(0xFF0D2240).withValues(alpha: 0.7),
                    ),
                    
                    const SizedBox(height: 16),
                    
                    Text(
                      'Welcome to SRET',
                      style: GoogleFonts.robotoSerif(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF0D2240),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    
                    const SizedBox(height: 8),
                    
                    Text(
                      'Sri Ramachandra Faculty of Engineering and Technology. Your dashboard for scheduling and substitutions will be available here once the backend is integrated.',
                      style: GoogleFonts.robotoSerif(
                        fontSize: 14,
                        color: const Color(0xFF4B5563),
                        height: 1.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              
              const Spacer(),
              
              // Sign Out Button
              SizedBox(
                width: double.infinity,
                child: BouncyButton(
                  onPressed: () async {
                    final controller = ref.read(authControllerProvider.notifier);
                    await controller.signOut();
                    if (context.mounted) {
                      context.go('/login');
                    }
                  },
                  backgroundColor: const Color(0xFF0D2240),
                  semanticLabel: 'Sign out',
                  child: Text(
                    'Sign out',
                    style: GoogleFonts.robotoSerif(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  String _getInitials(String name) {
    final parts = name.trim().split(' ');
    if (parts.isEmpty) return 'U';
    
    if (parts.length == 1) {
      return parts[0][0].toUpperCase();
    }
    
    return '${parts[0][0]}${parts[parts.length - 1][0]}'.toUpperCase();
  }
}
