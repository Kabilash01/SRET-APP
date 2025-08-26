import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../theme/app_theme.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _isLoading = false;
  bool _isEmailValid = false;

  // SRET email validation regex (case-insensitive)
  static const String _sretEmailRegex = r'^[a-zA-Z0-9._%+-]+@sret\.edu\.in$';

  @override
  void initState() {
    super.initState();
    _emailController.addListener(_validateEmail);
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _validateEmail() {
    final email = _emailController.text.toLowerCase().trim();
    final isValid = RegExp(_sretEmailRegex, caseSensitive: false).hasMatch(email);
    
    setState(() {
      _isEmailValid = isValid;
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

  Future<void> _handleSendResetLink() async {
    if (!_formKey.currentState!.validate() || !_isEmailValid) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final email = _emailController.text.toLowerCase().trim();
      
      // Mock delay for sending reset link
      await Future.delayed(const Duration(milliseconds: 1500));

      if (mounted) {
        setState(() {
          _isLoading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.white),
                const SizedBox(width: 8),
                Expanded(
                  child: Text('Reset link sent to $email'),
                ),
              ],
            ),
            duration: const Duration(seconds: 3),
          ),
        );

        // Navigate back to login page after brief delay
        await Future.delayed(const Duration(milliseconds: 500));
        if (mounted) {
          context.pop();
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to send reset link. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.sretBg,
      appBar: AppBar(
        title: Text(
          'Reset Password',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: AppTheme.sretPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: AppTheme.sretPrimary,
          ),
          onPressed: () => context.pop(),
          tooltip: 'Back to Sign In',
        ),
      ),
      body: Stack(
        children: [
          // Background with blurred blobs
          Positioned.fill(child: AppTheme.backgroundBlobs),
          
          // Main content
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 420),
                child: Container(
                  decoration: AppTheme.liquidGlass,
                  padding: const EdgeInsets.all(32),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Title
                        Text(
                          'Reset Password',
                          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            color: AppTheme.sretPrimary,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ).animate().fadeIn(duration: 600.ms).slideY(begin: -0.2),
                        
                        const SizedBox(height: 8),
                        
                        Text(
                          'Enter your SRET email address and we\'ll send you a link to reset your password.',
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: AppTheme.sretTextSecondary,
                            height: 1.4,
                          ),
                          textAlign: TextAlign.center,
                        ).animate().fadeIn(delay: 100.ms, duration: 600.ms),
                        
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
                          decoration: const InputDecoration(
                            labelText: 'SRET Email',
                            hintText: 'yourname@sret.edu.in',
                            prefixIcon: Icon(Icons.mail_outline),
                            helperText: 'Use your @sret.edu.in email address',
                          ),
                        ).animate().fadeIn(delay: 200.ms, duration: 600.ms).slideX(begin: -0.2),
                        
                        const SizedBox(height: 32),
                        
                        // Send Reset Link Button
                        Transform.scale(
                          scale: _isLoading ? 0.96 : 1.0,
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 150),
                            child: ElevatedButton(
                              onPressed: (_isEmailValid && !_isLoading)
                                  ? _handleSendResetLink
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
                                  : const Text('Send Reset Link'),
                            ),
                          ),
                        ).animate().fadeIn(delay: 300.ms, duration: 600.ms).scale(begin: const Offset(0.95, 0.95)),
                        
                        const SizedBox(height: 16),
                        
                        // Back to sign in link
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Remember your password? ',
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: AppTheme.sretTextSecondary,
                              ),
                            ),
                            TextButton(
                              onPressed: () => context.pop(),
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.zero,
                                minimumSize: Size.zero,
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                              child: Text(
                                'Sign in',
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: AppTheme.sretPrimary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ).animate().fadeIn(delay: 400.ms, duration: 600.ms).slideY(begin: 0.2),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
