import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../theme/app_theme.dart';
import '../../widgets/liquid_glass.dart';

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({super.key});

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  
  bool _isSubmitting = false;
  bool _isSuccess = false;
  String? _emailError;
  String? _generalError;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  bool _isValidSretEmail(String email) {
    return email.isNotEmpty && email.endsWith('@sret.edu.in');
  }

  void _validateEmail() {
    final email = _emailController.text.trim();
    setState(() {
      if (email.isEmpty) {
        _emailError = 'Email is required';
      } else if (!_isValidSretEmail(email)) {
        _emailError = 'Must end with @sret.edu.in';
      } else {
        _emailError = null;
      }
    });
  }

  Future<void> _submitReset() async {
    _validateEmail();
    
    if (_emailError != null) {
      return;
    }

    setState(() {
      _isSubmitting = true;
      _generalError = null;
    });

    // Simulate API call with random responses
    await Future.delayed(const Duration(milliseconds: 1000));

    if (mounted) {
      // Simulate different responses (90% success, 10% error for demo)
      final random = DateTime.now().millisecondsSinceEpoch % 10;
      
      if (random < 9) {
        // Success case
        setState(() {
          _isSubmitting = false;
          _isSuccess = true;
        });
      } else {
        // Error cases
        setState(() {
          _isSubmitting = false;
          _generalError = random == 9 
            ? 'Too many attempts. Please try again in 5 minutes.'
            : 'Network error. Please check your connection.';
        });
      }
    }
  }

  Future<void> _resendLink() async {
    setState(() {
      _isSuccess = false;
      _generalError = null;
    });
    await _submitReset();
  }

  void _openEmailApp() {
    // Stub for opening email app
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Email app would open here'),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isEmailValid = _isValidSretEmail(_emailController.text.trim());

    // Show error banner if there's a general error
    if (_generalError != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          ScaffoldMessenger.of(context).showMaterialBanner(
            MaterialBanner(
              content: Text(_generalError!),
              leading: Icon(
                Icons.error_outline,
                color: theme.colorScheme.error,
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
                    setState(() => _generalError = null);
                  },
                  child: const Text('Dismiss'),
                ),
                TextButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
                    setState(() => _generalError = null);
                    _submitReset();
                  },
                  child: const Text('Try again'),
                ),
              ],
            ),
          );
        }
      });
    }

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Back button
              Row(
                children: [
                  IconButton(
                    onPressed: () => context.pop(),
                    icon: Icon(
                      Icons.arrow_back,
                      color: theme.colorScheme.primary,
                    ),
                    tooltip: 'Back to sign in',
                  ),
                ],
              ),
              
              const SizedBox(height: 40),
              
              // Main content
              LiquidGlass.card(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Icon
                    Center(
                      child: Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: theme.colorScheme.primary,
                        ),
                        child: Icon(
                          Icons.lock_reset,
                          size: 40,
                          color: theme.colorScheme.onPrimary,
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Header
                    Text(
                      'Reset Password',
                      style: theme.textTheme.headlineLarge,
                      textAlign: TextAlign.center,
                    ),
                    
                    const SizedBox(height: 8),
                    
                    // Subtitle
                    Text(
                      'Enter your SRET email to receive a password reset link',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    
                    const SizedBox(height: 32),
                    
                    // Form
                    Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Email field
                          Text(
                            'Email',
                            style: theme.textTheme.titleLarge,
                          ),
                          const SizedBox(height: 8),
                          LiquidGlass(
                            borderRadius: 16,
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                            child: TextField(
                              controller: _emailController,
                              enabled: !_isSubmitting && !_isSuccess,
                              onChanged: (_) => setState(() => _emailError = null),
                              decoration: InputDecoration(
                                hintText: 'Enter your @sret.edu.in email',
                                prefixIcon: Icon(
                                  Icons.mail_outline,
                                  size: 20,
                                  color: AppColors.textSecondary,
                                ),
                                helperText: 'Must end with @sret.edu.in',
                                helperStyle: theme.textTheme.bodySmall,
                              ),
                              keyboardType: TextInputType.emailAddress,
                              textInputAction: TextInputAction.done,
                              onSubmitted: (_) => isEmailValid ? _submitReset() : null,
                            ),
                          ),
                          if (_emailError != null) ...[
                            const SizedBox(height: 4),
                            Text(
                              _emailError!,
                              style: TextStyle(
                                color: theme.colorScheme.error,
                                fontSize: 12,
                              ),
                            ),
                          ],
                          
                          const SizedBox(height: 24),
                          
                          // Submit button or success state
                          if (!_isSuccess) ...[
                            ElevatedButton(
                              onPressed: (isEmailValid && !_isSubmitting) ? _submitReset : null,
                              child: _isSubmitting
                                  ? SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor: AlwaysStoppedAnimation<Color>(
                                          theme.colorScheme.onPrimary,
                                        ),
                                      ),
                                    )
                                  : const Text('Send reset link'),
                            ),
                          ] else ...[
                            // Success panel
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: theme.colorScheme.primaryContainer,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: theme.colorScheme.primary.withValues(alpha: 0.3),
                                ),
                              ),
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.check_circle,
                                    color: theme.colorScheme.primary,
                                    size: 32,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Link sent. Check your @sret.edu.in inbox.',
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      color: theme.colorScheme.onPrimaryContainer,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 16),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: OutlinedButton(
                                          onPressed: _openEmailApp,
                                          child: const Text('Open email app'),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: TextButton(
                                          onPressed: _resendLink,
                                          child: const Text('Resend'),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Footer
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Remember your password? ',
                          style: theme.textTheme.bodyMedium,
                        ),
                        TextButton(
                          onPressed: () => context.pop(),
                          child: const Text('Sign in'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
