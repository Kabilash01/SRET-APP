import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import '../../theme/app_theme.dart';
import '../shared/liquid_glass.dart';
import '../shared/validators.dart';

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
    final isEmailValid = validateSretEmail(email) == null;
    final isPasswordValid = validatePassword(_passwordController.text) == null;
    
    setState(() {
      _isFormValid = isEmailValid && isPasswordValid;
    });
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
        const SnackBar(
          content: Row(
            children: [
              Icon(Icons.check_circle, color: Colors.white),
              SizedBox(width: 8),
              Text('Sign in successful!'),
            ],
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
        const SnackBar(
          content: Row(
            children: [
              Icon(Icons.check_circle, color: Colors.white),
              SizedBox(width: 8),
              Text('Google sign in successful!'),
            ],
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
    return Scaffold(
      backgroundColor: AppTheme.sretBg,
      body: Stack(
        children: [
          // Background with subtle blobs
          Positioned.fill(
            child: Container(
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
            ),
          ),
          
          // Main content
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 420),
                child: LiquidGlass(
                  radius: const BorderRadius.all(Radius.circular(20)),
                  child: Padding(
                    padding: const EdgeInsets.all(32),
                    child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Title
                        Text(
                          'Sign In',
                          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            color: AppTheme.sretPrimary,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ).animate().fadeIn(duration: 600.ms).slideY(begin: -0.2),
                        
                        const SizedBox(height: 8),
                        
                        Text(
                          'Welcome back to SRET',
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: AppTheme.sretTextSecondary,
                          ),
                          textAlign: TextAlign.center,
                        ).animate().fadeIn(delay: 100.ms, duration: 600.ms),
                        
                        const SizedBox(height: 32),
                        
                        // Email Field
                        TextFormField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          autofillHints: const [AutofillHints.email],
                          validator: validateSretEmail,
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
                          decoration: const InputDecoration(
                            labelText: 'SRET Email',
                            hintText: 'yourname@sret.edu.in',
                            prefixIcon: Icon(Icons.mail_outline),
                            helperText: 'Use your @sret.edu.in email address',
                          ),
                        ).animate().fadeIn(delay: 200.ms, duration: 600.ms).slideX(begin: -0.2),
                        
                        const SizedBox(height: 16),
                        
                        // Password Field
                        TextFormField(
                          controller: _passwordController,
                          obscureText: !_isPasswordVisible,
                          validator: validatePassword,
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
                        ).animate().fadeIn(delay: 300.ms, duration: 600.ms).slideX(begin: -0.2),
                        
                        const SizedBox(height: 8),
                        
                        // Forgot password link
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {
                              context.push('/forgot-password');
                            },
                            child: Text(
                              'Forgot password?',
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: AppTheme.sretPrimary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ).animate().fadeIn(delay: 400.ms, duration: 600.ms),
                        
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
                                  : const Text('Sign In'),
                            ),
                          ),
                        ).animate().fadeIn(delay: 500.ms, duration: 600.ms).scale(begin: const Offset(0.95, 0.95)),
                        
                        const SizedBox(height: 24),
                        
                        // Divider
                        Row(
                          children: [
                            const Expanded(
                              child: Divider(),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              child: Text(
                                'OR',
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: AppTheme.sretTextSecondary,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            const Expanded(
                              child: Divider(),
                            ),
                          ],
                        ).animate().fadeIn(delay: 600.ms, duration: 600.ms),
                        
                        const SizedBox(height: 24),
                        
                        // Google Sign In Button
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
                              label: const Text('Continue with Google'),
                            ),
                          ),
                        ).animate().fadeIn(delay: 700.ms, duration: 600.ms).scale(begin: const Offset(0.95, 0.95)),
                        
                        const SizedBox(height: 24),
                        
                        // Create account link
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Don't have an account? ",
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: AppTheme.sretTextSecondary,
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
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: AppTheme.sretPrimary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ).animate().fadeIn(delay: 800.ms, duration: 600.ms).slideY(begin: 0.2),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    ).animate().slideY(
      begin: 0.15,
      end: 0,
      duration: 300.ms,
      curve: Curves.easeOut,
    ).fadeIn(duration: 300.ms, curve: Curves.easeOut);
  }
}
