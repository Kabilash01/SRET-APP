import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../core/auth/fake_auth_repo.dart';
import '../../theme/app_theme.dart';
import '../shared/apple_liquid_glass.dart';
import '../shared/validators.dart';

class ForgotPasswordPageSret extends StatefulWidget {
  const ForgotPasswordPageSret({super.key});

  @override
  State<ForgotPasswordPageSret> createState() => _ForgotPasswordPageSretState();
}

class _ForgotPasswordPageSretState extends State<ForgotPasswordPageSret> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _authRepo = FakeAuthRepo();
  
  bool _isLoading = false;
  bool _emailSent = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  bool get _isFormValid {
    return _emailController.text.trim().isNotEmpty &&
        validateSretEmail(_emailController.text) == null;
  }

  Future<void> _handleSendResetEmail() async {
    if (!_formKey.currentState!.validate() || !_isFormValid) return;

    setState(() {
      _isLoading = true;
    });

    try {
      await _authRepo.sendResetEmail(_emailController.text.trim().toLowerCase());

      if (mounted) {
        setState(() {
          _emailSent = true;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to send reset email: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _resetForm() {
    setState(() {
      _emailSent = false;
      _emailController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: AppTheme.sretPrimary,
          ),
          onPressed: () {
            if (_emailSent) {
              _resetForm();
            } else {
              context.pop();
            }
          },
        ),
      ),
      body: Stack(
        children: [
          // Background with subtle blobs
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment.topRight,
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
                    center: Alignment.bottomLeft,
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
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 420),
                  child: AppleLiquidGlass(
                    radius: const BorderRadius.all(Radius.circular(20)),
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: _emailSent ? _buildSuccessView() : _buildFormView(),
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

  Widget _buildFormView() {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Icon
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppTheme.sretPrimary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.lock_reset,
              size: 40,
              color: AppTheme.sretPrimary,
            ),
          ).animate().scale(duration: 300.ms, curve: Curves.easeOut),
          
          const SizedBox(height: 24),
          
          // Title
          Text(
            'Reset Password',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              color: AppTheme.sretPrimary,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: 8),
          
          // Subtitle
          Text(
            'Enter your SRET email to receive a password reset link',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppTheme.sretTextSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: 32),
          
          // Email Field
          TextFormField(
            controller: _emailController,
            enabled: !_isLoading,
            keyboardType: TextInputType.emailAddress,
            autofillHints: const [AutofillHints.email],
            validator: validateSretEmail,
            onChanged: (value) {
              // Auto-convert to lowercase
              if (value != value.toLowerCase()) {
                final selection = _emailController.selection;
                _emailController.value = TextEditingValue(
                  text: value.toLowerCase(),
                  selection: selection,
                );
              }
            },
            decoration: const InputDecoration(
              labelText: 'Email',
              hintText: 'yourname@sret.edu.in',
              prefixIcon: Icon(Icons.mail_outline),
              helperText: 'Must end with @sret.edu.in',
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Send Reset Link Button
          AnimatedScale(
            scale: _isLoading ? 0.96 : 1.0,
            duration: const Duration(milliseconds: 150),
            child: ElevatedButton(
              onPressed: (_isFormValid && !_isLoading) ? _handleSendResetEmail : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: _isFormValid ? AppTheme.sretPrimary : AppTheme.sretTextSecondary,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
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
                  : const Text(
                      'Send reset link',
                      semanticsLabel: 'Send password reset link',
                    ),
            ),
          ),
          
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
                onPressed: _isLoading ? null : () {
                  context.go('/login');
                },
                child: Text(
                  'Sign in',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppTheme.sretPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSuccessView() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Success Icon
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: Colors.green.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.check_circle,
            size: 40,
            color: Colors.green,
          ),
        ).animate().scale(
          delay: 200.ms,
          duration: 400.ms,
          curve: Curves.elasticOut,
        ),
        
        const SizedBox(height: 24),
        
        // Success Title
        Text(
          'Check your email',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            color: AppTheme.sretPrimary,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        
        const SizedBox(height: 8),
        
        // Success Message
        Text(
          'We sent a password reset link to',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: AppTheme.sretTextSecondary,
          ),
          textAlign: TextAlign.center,
        ),
        
        const SizedBox(height: 8),
        
        // Email
        Text(
          _emailController.text.trim(),
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: AppTheme.sretPrimary,
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),
        
        const SizedBox(height: 24),
        
        // Helper note
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppTheme.sretSurface.withOpacity(0.7),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: AppTheme.sretDivider,
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Icon(
                Icons.info_outline,
                size: 16,
                color: AppTheme.sretTextSecondary,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Check your spam folder if you don\'t see the email within a few minutes.',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppTheme.sretTextSecondary,
                  ),
                ),
              ),
            ],
          ),
        ),
        
        const SizedBox(height: 24),
        
        // Resend Button
        OutlinedButton(
          onPressed: () {
            _resetForm();
          },
          style: OutlinedButton.styleFrom(
            side: BorderSide(color: AppTheme.sretPrimary),
            minimumSize: const Size(double.infinity, 48),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          child: Text(
            'Resend email',
            style: TextStyle(
              color: AppTheme.sretPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        
        const SizedBox(height: 16),
        
        // Back to sign in link
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              onPressed: () {
                context.go('/login');
              },
              child: Text(
                'Back to sign in',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppTheme.sretPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ],
    ).animate().slideY(
      begin: 0.1,
      end: 0,
      duration: 300.ms,
      curve: Curves.easeOut,
    ).fadeIn(duration: 300.ms);
  }
}
