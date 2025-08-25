import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../shared/blurred_background.dart';
import '../shared/glass_card.dart';

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
      // Mock sending reset email (900ms delay)
      await Future.delayed(const Duration(milliseconds: 900));

      if (mounted) {
        setState(() {
          _isLoading = false;
        });

        final email = _emailController.text.toLowerCase().trim();
        
        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.white),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Reset link sent to $email',
                    style: GoogleFonts.robotoSerif(),
                  ),
                ),
              ],
            ),
            backgroundColor: const Color(0xFF0D2240),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            duration: const Duration(seconds: 3),
          ),
        );

        // Navigate back to login page after brief delay
        await Future.delayed(const Duration(milliseconds: 500));
        if (mounted) {
          Navigator.of(context).pop();
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Failed to send reset link. Please try again.',
              style: GoogleFonts.robotoSerif(),
            ),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF7E6), // CREAM_BG
      appBar: AppBar(
        title: Text(
          'Reset Password',
          style: GoogleFonts.robotoSerif(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF0D2240),
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Color(0xFF0D2240),
          ),
          onPressed: () => Navigator.of(context).pop(),
          tooltip: 'Back to Sign In',
        ),
      ),
      body: BlurredBackground(
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
                        'Reset Password',
                        style: GoogleFonts.robotoSerif(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF0D2240),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      
                      const SizedBox(height: 8),
                      
                      Text(
                        'Enter your SRET email address and we\'ll send you a link to reset your password.',
                        style: GoogleFonts.robotoSerif(
                          fontSize: 16,
                          color: const Color(0xFF4B5563),
                          height: 1.4,
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
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _isEmailValid
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
                                    'Send Reset Link',
                                    style: GoogleFonts.robotoSerif(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    semanticsLabel: 'Send password reset link',
                                  ),
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
                            style: GoogleFonts.robotoSerif(
                              color: const Color(0xFF4B5563),
                            ),
                          ),
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            child: Text(
                              'Sign in',
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
      ),
    );
  }
}
