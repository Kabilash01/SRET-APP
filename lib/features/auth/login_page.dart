import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../shared/blurred_background.dart';
import '../shared/glass_card.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isLoading = false;
  bool _isFormValid = false;

  // SRET email validation regex (case-insensitive)
  static const String _sretEmailRegex = r'^[a-zA-Z0-9._%+-]+@sret\.edu\.in$';

  @override
  void initState() {
    super.initState();
    _emailController.addListener(_validateForm);
    _passwordController.addListener(_validateForm);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _validateForm() {
    final email = _emailController.text.toLowerCase().trim();
    final isEmailValid = RegExp(_sretEmailRegex, caseSensitive: false).hasMatch(email);
    final isPasswordValid = _passwordController.text.length >= 6;
    
    setState(() {
      _isFormValid = isEmailValid && isPasswordValid;
    });
  }

  String? _validateSretEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    
    final email = value.toLowerCase().trim();
    if (!RegExp(_sretEmailRegex, caseSensitive: false).hasMatch(email)) {
      return 'Please enter a valid @sret.edu.in email';
    }
    
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  Future<void> _handleSignIn() async {
    if (!_formKey.currentState!.validate() || !_isFormValid) return;

    setState(() {
      _isLoading = true;
    });

    // Mock authentication delay
    await Future.delayed(const Duration(milliseconds: 900));

    if (mounted) {
      setState(() {
        _isLoading = false;
      });

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.check_circle, color: Colors.white),
              const SizedBox(width: 8),
              Text(
                'Sign in successful!',
                style: GoogleFonts.robotoSerif(),
              ),
            ],
          ),
          backgroundColor: const Color(0xFF0D2240),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      );

      // Navigate to home after a brief delay
      await Future.delayed(const Duration(milliseconds: 500));
      if (mounted) {
        context.go('/home');
      }
    }
  }

  Future<void> _handleGoogleSignIn() async {
    setState(() {
      _isLoading = true;
    });

    // Mock Google sign-in delay
    await Future.delayed(const Duration(milliseconds: 900));

    if (mounted) {
      setState(() {
        _isLoading = false;
      });

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.check_circle, color: Colors.white),
              const SizedBox(width: 8),
              Text(
                'Google sign in successful!',
                style: GoogleFonts.robotoSerif(),
              ),
            ],
          ),
          backgroundColor: const Color(0xFF0D2240),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      );

      await Future.delayed(const Duration(milliseconds: 500));
      if (mounted) {
        context.go('/home');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlurredBackground(
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: GlassCard(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Title
                    Text(
                      'Sign In',
                      style: GoogleFonts.robotoSerif(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF0D2240),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    
                    const SizedBox(height: 8),
                    
                    Text(
                      'Welcome back to SRET',
                      style: GoogleFonts.robotoSerif(
                        fontSize: 16,
                        color: const Color(0xFF4B5563),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    
                    const SizedBox(height: 32),
                    
                    // Email Field
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      autofillHints: const [AutofillHints.email],
                      validator: _validateSretEmail,
                      onChanged: (value) {
                        // Convert to lowercase as user types
                        if (value != value.toLowerCase()) {
                          final selection = _emailController.selection;
                          _emailController.value = TextEditingValue(
                            text: value.toLowerCase(),
                            selection: selection,
                          );
                        }
                      },
                      decoration: InputDecoration(
                        labelText: 'SRET Email',
                        hintText: 'yourname@sret.edu.in',
                        prefixIcon: const Icon(Icons.mail_outline),
                        helperText: 'Use your @sret.edu.in email address',
                        helperStyle: GoogleFonts.robotoSerif(
                          fontSize: 12,
                          color: const Color(0xFF4B5563),
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Password Field
                    TextFormField(
                      controller: _passwordController,
                      obscureText: !_isPasswordVisible,
                      validator: _validatePassword,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        hintText: 'Enter your password',
                        prefixIcon: const Icon(Icons.lock_outline),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isPasswordVisible
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                          onPressed: () {
                            setState(() {
                              _isPasswordVisible = !_isPasswordVisible;
                            });
                          },
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 8),
                    
                    // Forgot password link
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          context.push('/forgot');
                        },
                        child: Text(
                          'Forgot password?',
                          style: GoogleFonts.robotoSerif(
                            color: const Color(0xFF0D2240),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Sign In Button
                    Transform.scale(
                      scale: _isLoading ? 0.96 : 1.0,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 150),
                        child: ElevatedButton(
                        onPressed: (_isFormValid && !_isLoading)
                            ? _handleSignIn
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _isFormValid
                              ? const Color(0xFF0D2240)
                              : const Color(0xFF4B5563),
                          minimumSize: const Size(double.infinity, 48),
                        ),
                        child: _isLoading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white,
                                  ),
                                ),
                              )
                            : Text(
                                'Sign In',
                                style: GoogleFonts.robotoSerif(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                        ),
                      ),
                    ),                    const SizedBox(height: 24),
                    
                    // Divider
                    Row(
                      children: [
                        const Expanded(
                          child: Divider(color: Color(0xFFE8E2D6)),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            'OR',
                            style: GoogleFonts.robotoSerif(
                              color: const Color(0xFF4B5563),
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        const Expanded(
                          child: Divider(color: Color(0xFFE8E2D6)),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Google Sign In Button
                    Transform.scale(
                      scale: _isLoading ? 0.96 : 1.0,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 150),
                        child: ElevatedButton.icon(
                        onPressed: !_isLoading ? _handleGoogleSignIn : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0D2240),
                          minimumSize: const Size(double.infinity, 48),
                        ),
                        icon: _isLoading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white,
                                  ),
                                ),
                              )
                            : SvgPicture.asset(
                                'assets/icons/google_g.svg',
                                width: 20,
                                height: 20,
                              ),
                        label: Text(
                          'Continue with Google',
                          style: GoogleFonts.robotoSerif(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Create account link
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Don't have an account? ",
                          style: GoogleFonts.robotoSerif(
                            color: const Color(0xFF4B5563),
                          ),
                        ),
                        TextButton(
                          onPressed: () => context.push('/signup'),
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: Text(
                            'Create account',
                            style: GoogleFonts.robotoSerif(
                              color: const Color(0xFF0D2240),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            )
                .animate()
                .slideY(
                  begin: 0.4,
                  end: 0,
                  duration: 300.ms,
                  curve: Curves.easeOut,
                )
                .fadeIn(duration: 300.ms, curve: Curves.easeOut),
          ),
        ),
      ),
    );
  }
}
