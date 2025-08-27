import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../shared/apple_liquid_glass.dart';
import '../../theme/app_theme.dart';
import '../../core/auth/auth_controller.dart';

class LoginPageFixed extends ConsumerStatefulWidget {
  const LoginPageFixed({super.key});

  @override
  ConsumerState<LoginPageFixed> createState() => _LoginPageFixedState();
}

class _LoginPageFixedState extends ConsumerState<LoginPageFixed>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;
  bool _rememberMe = false;

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
    ));
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.2, 0.8, curve: Curves.easeOut),
    ));
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    
    try {
      final authController = ref.read(authControllerProvider.notifier);
      await authController.signInWithEmail(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );
      // Navigation will be handled automatically by the router redirect
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Login failed: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _handleGoogleSignIn() async {
    setState(() => _isLoading = true);
    try {
      final authController = ref.read(authControllerProvider.notifier);
      await authController.signInWithGoogle();
      // Navigation will be handled automatically by the router redirect
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Google sign-in failed: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: AppleLiquidGlass(
              child: Container(
                padding: const EdgeInsets.all(32),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Logo and title
                      Column(
                        children: [
                          Container(
                            width: 140,
                            height: 50,
                            child: SvgPicture.asset(
                              'assets/icons/sret_logo.svg',
                              colorFilter: ColorFilter.mode(
                                AppTheme.sretPrimary,
                                BlendMode.srcIn,
                              ),
                            ),
                          ).animate().fadeIn(duration: 600.ms).scale(
                            begin: const Offset(0.8, 0.8),
                            duration: 600.ms,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Welcome Back',
                            style: GoogleFonts.inter(
                              fontSize: 28,
                              fontWeight: FontWeight.w700,
                              color: AppTheme.sretText,
                            ),
                          ).animate().fadeIn(delay: 200.ms, duration: 600.ms),
                          const SizedBox(height: 8),
                          Text(
                            'Sign in to continue to SRET',
                            style: GoogleFonts.inter(
                              fontSize: 16,
                              color: AppTheme.sretTextSecondary,
                            ),
                          ).animate().fadeIn(delay: 300.ms, duration: 600.ms),
                        ],
                      ),
                      
                      const SizedBox(height: 40),
                      
                      // Email field
                      TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        style: GoogleFonts.inter(color: AppTheme.sretText),
                        decoration: InputDecoration(
                          labelText: 'Email',
                          hintText: 'Enter your email',
                          prefixIcon: Icon(Icons.email_outlined, color: AppTheme.sretPrimary),
                          filled: true,
                          fillColor: AppTheme.sretSurface.withOpacity(0.5),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide.none,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide(color: AppTheme.sretDivider),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide(color: AppTheme.sretPrimary, width: 2),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: const BorderSide(color: Colors.red),
                          ),
                          labelStyle: GoogleFonts.inter(color: AppTheme.sretTextSecondary),
                          hintStyle: GoogleFonts.inter(color: AppTheme.sretTextSecondary),
                        ),
                        validator: (value) {
                          if (value?.isEmpty ?? true) {
                            return 'Email is required';
                          }
                          if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value!)) {
                            return 'Enter a valid email';
                          }
                          return null;
                        },
                      ).animate().fadeIn(delay: 400.ms, duration: 600.ms).slideX(begin: -0.2),
                      
                      const SizedBox(height: 16),
                      
                      // Password field
                      TextFormField(
                        controller: _passwordController,
                        obscureText: _obscurePassword,
                        style: GoogleFonts.inter(color: AppTheme.sretText),
                        decoration: InputDecoration(
                          labelText: 'Password',
                          hintText: 'Enter your password',
                          prefixIcon: Icon(Icons.lock_outline, color: AppTheme.sretPrimary),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword ? Icons.visibility_off : Icons.visibility,
                              color: AppTheme.sretTextSecondary,
                            ),
                            onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                          ),
                          filled: true,
                          fillColor: AppTheme.sretSurface.withOpacity(0.5),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide.none,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide(color: AppTheme.sretDivider),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide(color: AppTheme.sretPrimary, width: 2),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: const BorderSide(color: Colors.red),
                          ),
                          labelStyle: GoogleFonts.inter(color: AppTheme.sretTextSecondary),
                          hintStyle: GoogleFonts.inter(color: AppTheme.sretTextSecondary),
                        ),
                        validator: (value) {
                          if (value?.isEmpty ?? true) {
                            return 'Password is required';
                          }
                          if (value!.length < 6) {
                            return 'Password must be at least 6 characters';
                          }
                          return null;
                        },
                      ).animate().fadeIn(delay: 500.ms, duration: 600.ms).slideX(begin: 0.2),
                      
                      const SizedBox(height: 16),
                      
                      // Remember me and forgot password
                      Row(
                        children: [
                          Row(
                            children: [
                              SizedBox(
                                width: 20,
                                height: 20,
                                child: Checkbox(
                                  value: _rememberMe,
                                  onChanged: (value) => setState(() => _rememberMe = value ?? false),
                                  activeColor: AppTheme.sretPrimary,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Remember me',
                                style: GoogleFonts.inter(
                                  fontSize: 14,
                                  color: AppTheme.sretTextSecondary,
                                ),
                              ),
                            ],
                          ),
                          const Spacer(),
                          TextButton(
                            onPressed: () {
                              // Handle forgot password
                            },
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            child: Text(
                              'Forgot password?',
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                color: AppTheme.sretPrimary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ).animate().fadeIn(delay: 550.ms, duration: 600.ms),
                      
                      const SizedBox(height: 32),
                      
                      // Login button
                      Transform.scale(
                        scale: _isLoading ? 0.96 : 1.0,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 150),
                          child: ElevatedButton(
                            onPressed: !_isLoading ? _handleLogin : null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.sretPrimary,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              elevation: _isLoading ? 0 : 4,
                              shadowColor: AppTheme.sretPrimary.withOpacity(0.3),
                            ),
                            child: _isLoading
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                    ),
                                  )
                                : Text(
                                    'Sign In',
                                    style: GoogleFonts.inter(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                          ),
                        ),
                      ).animate().fadeIn(delay: 600.ms, duration: 600.ms).scale(begin: const Offset(0.95, 0.95)),
                      
                      const SizedBox(height: 24),
                      
                      // Divider
                      Row(
                        children: [
                          Expanded(child: Divider(color: AppTheme.sretDivider)),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Text(
                              'or',
                              style: GoogleFonts.inter(
                                color: AppTheme.sretTextSecondary,
                                fontSize: 14,
                              ),
                            ),
                          ),
                          Expanded(child: Divider(color: AppTheme.sretDivider)),
                        ],
                      ).animate().fadeIn(delay: 650.ms, duration: 600.ms),
                      
                      const SizedBox(height: 24),
                      
                      // Google sign in button
                      Transform.scale(
                        scale: _isLoading ? 0.96 : 1.0,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 150),
                          child: ElevatedButton.icon(
                            onPressed: !_isLoading ? _handleGoogleSignIn : null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.sretSurface,
                              foregroundColor: AppTheme.sretText,
                              side: BorderSide(color: AppTheme.sretDivider),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            icon: _isLoading
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  )
                                : SvgPicture.asset(
                                    'assets/icons/google_g.svg',
                                    width: 20,
                                    height: 20,
                                  ),
                            label: Text(
                              'Continue with Google',
                              style: GoogleFonts.inter(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ).animate().fadeIn(delay: 700.ms, duration: 600.ms).scale(begin: const Offset(0.95, 0.95)),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
