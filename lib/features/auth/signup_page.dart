import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import '../../core/auth/auth_controller.dart';
import '../shared/blurred_background.dart';
import '../shared/glass_card.dart';
import '../shared/bouncy_button.dart';

class SignUpPage extends ConsumerStatefulWidget {
  const SignUpPage({super.key});

  @override
  ConsumerState<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends ConsumerState<SignUpPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;
  bool _showCheckmark = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.08),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));

    // Start animation on load
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleSignUp() async {
    final controller = ref.read(authControllerProvider.notifier);
    
    try {
      await controller.signInWithGoogle();
      
      // Show success checkmark
      if (mounted) {
        setState(() {
          _showCheckmark = true;
        });
        
        // Wait for checkmark animation, then navigate
        await Future.delayed(const Duration(milliseconds: 500));
        
        if (mounted) {
          context.go('/home');
        }
      }
    } catch (e) {
      // Show error snackbar
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Sign-up failed, please try again'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);
    final isLoading = authState.isLoading;

    return BlurredBackground(
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: SlideTransition(
            position: _slideAnimation,
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: GlassCard(
                width: double.infinity,
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // App Title
                    Text(
                      'SRET',
                      style: Theme.of(context).textTheme.displayMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF0D2240),
                      ),
                    ),
                    
                    const SizedBox(height: 8),
                    
                    // Subtitle
                    Text(
                      'Create your account',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: const Color(0xFF4B5563),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    
                    const SizedBox(height: 8),
                    
                    Text(
                      'Faculty Scheduling & Substitutions',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: const Color(0xFF4B5563),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    
                    const SizedBox(height: 40),
                    
                    // Google Sign-Up Button
                    SizedBox(
                      width: double.infinity,
                      child: BouncyButton(
                        onPressed: isLoading ? null : _handleSignUp,
                        isLoading: isLoading,
                        semanticLabel: 'Continue with Google',
                        leadingIcon: _showCheckmark
                            ? AnimatedSwitcher(
                                duration: const Duration(milliseconds: 300),
                                child: const Icon(
                                  Icons.check,
                                  color: Colors.white,
                                  size: 20,
                                  key: ValueKey('checkmark'),
                                ),
                              )
                            : SvgPicture.asset(
                                'assets/icons/google_g.svg',
                                width: 20,
                                height: 20,
                              ),
                        child: const Text('Continue with Google'),
                      ),
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Sign in link
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Already have an account? ',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: const Color(0xFF4B5563),
                          ),
                        ),
                        TextButton(
                          onPressed: () => context.go('/signin'),
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: Text(
                            'Sign in',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: const Color(0xFF0D2240),
                              decoration: TextDecoration.underline,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
