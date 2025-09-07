import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../theme/app_theme.dart';
import '../../widgets/liquid_glass.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  
  bool _isPasswordVisible = false;
  bool _rememberMe = false;
  bool _isSigningIn = false;
  bool _isMagicLinkCooldown = false;
  int _cooldownSeconds = 0;
  bool _showMagicLinkAction = false;
  
  String? _emailError;
  String? _passwordError;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
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
        _emailError = 'Use your institutional @sret.edu.in email';
      } else {
        _emailError = null;
      }
    });
  }

  void _validatePassword() {
    final password = _passwordController.text;
    setState(() {
      if (password.isEmpty) {
        _passwordError = 'Password is required';
      } else if (password.length < 8) {
        _passwordError = 'Password must be at least 8 characters';
      } else {
        _passwordError = null;
      }
    });
  }

  Future<void> _signIn() async {
    _validateEmail();
    _validatePassword();
    
    if (_emailError != null || _passwordError != null) {
      return;
    }

    setState(() {
      _isSigningIn = true;
    });

    // Simulate API call
    await Future.delayed(const Duration(milliseconds: 1200));

    if (mounted) {
      setState(() {
        _isSigningIn = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Signed in (demo)'),
          backgroundColor: AppColors.primary,
        ),
      );

      context.go('/today');
    }
  }

  Future<void> _forgotPassword() async {
    context.pushNamed('resetPassword');
  }

  Future<void> _sendMagicLink() async {
    final email = _emailController.text.trim();
    
    if (!_isValidSretEmail(email)) {
      setState(() {
        _emailError = 'Use your institutional @sret.edu.in email';
      });
      return;
    }

    setState(() {
      _isMagicLinkCooldown = true;
      _cooldownSeconds = 60;
      _showMagicLinkAction = true;
      _emailError = null;
    });

    // Start countdown
    _startCooldown();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Magic link sent (demo). Check your inbox.'),
        backgroundColor: AppColors.primary,
      ),
    );
  }

  void _startCooldown() {
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted && _cooldownSeconds > 0) {
        setState(() {
          _cooldownSeconds--;
        });
        _startCooldown();
      } else if (mounted) {
        setState(() {
          _isMagicLinkCooldown = false;
          _showMagicLinkAction = false;
        });
      }
    });
  }

  Future<void> _completeMagicLinkLogin() async {
    setState(() {
      _isSigningIn = true;
    });

    await Future.delayed(const Duration(milliseconds: 800));

    if (mounted) {
      setState(() {
        _isSigningIn = false;
      });

      context.go('/today');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 40),
              
              // Title and subtitle
              Text(
                'Sign In',
                style: Theme.of(context).textTheme.headlineLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Welcome back to SRET',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: 48),
              
              // Sign in form
              LiquidGlass.card(
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Email field
                      Text(
                        'Email',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 8),
                      LiquidGlass(
                        borderRadius: 16,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                        child: TextField(
                          controller: _emailController,
                          onChanged: (_) => setState(() => _emailError = null),
                          decoration: InputDecoration(
                            hintText: 'Enter your @sret.edu.in email',
                            prefixIcon: const Icon(Icons.mail_outline, size: 20),
                            prefixIconColor: AppColors.textSecondary,
                          ),
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                        ),
                      ),
                      if (_emailError != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          _emailError!,
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 12,
                          ),
                        ),
                      ],
                      
                      const SizedBox(height: 20),
                      
                      // Password field
                      Text(
                        'Password',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 8),
                      LiquidGlass(
                        borderRadius: 16,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                        child: TextField(
                          controller: _passwordController,
                          onChanged: (_) => setState(() => _passwordError = null),
                          obscureText: !_isPasswordVisible,
                          decoration: InputDecoration(
                            hintText: 'Enter your password',
                            prefixIcon: const Icon(Icons.lock_outline, size: 20),
                            prefixIconColor: AppColors.textSecondary,
                            suffixIcon: IconButton(
                              icon: Icon(
                                _isPasswordVisible ? Icons.visibility_off : Icons.visibility,
                                size: 20,
                              ),
                              onPressed: () {
                                setState(() {
                                  _isPasswordVisible = !_isPasswordVisible;
                                });
                              },
                            ),
                            suffixIconColor: AppColors.textSecondary,
                          ),
                          textInputAction: TextInputAction.done,
                          onSubmitted: (_) => _signIn(),
                        ),
                      ),
                      if (_passwordError != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          _passwordError!,
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 12,
                          ),
                        ),
                      ],
                      
                      const SizedBox(height: 20),
                      
                      // Remember me and forgot password
                      Row(
                        children: [
                          Checkbox(
                            value: _rememberMe,
                            onChanged: (value) {
                              setState(() {
                                _rememberMe = value ?? false;
                              });
                            },
                            activeColor: AppColors.primary,
                          ),
                          const Text('Remember me'),
                          const Spacer(),
                          TextButton(
                            onPressed: _forgotPassword,
                            child: const Text('Forgot Password?'),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 24),
                      
                      // Sign in button
                      ElevatedButton(
                        onPressed: _isSigningIn ? null : _signIn,
                        child: _isSigningIn
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                ),
                              )
                            : const Text('Sign In'),
                      ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 32),
              
              // Divider
              Row(
                children: [
                  const Expanded(child: Divider()),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'OR',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                  const Expanded(child: Divider()),
                ],
              ),
              
              const SizedBox(height: 32),
              
              // Magic link button
              LiquidGlass.pill(
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: _isMagicLinkCooldown ? null : _sendMagicLink,
                    borderRadius: BorderRadius.circular(26),
                    child: Container(
                      height: 52,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.mail_outline,
                            size: 22,
                            color: AppColors.textPrimary,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            _isMagicLinkCooldown
                                ? 'Link sent · ${_cooldownSeconds}s'
                                : 'Send Magic Link',
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              
              // Magic link action
              if (_showMagicLinkAction) ...[
                const SizedBox(height: 16),
                TextButton(
                  onPressed: _isSigningIn ? null : _completeMagicLinkLogin,
                  child: _isSigningIn
                      ? SizedBox(
                          height: 16,
                          width: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                          ),
                        )
                      : const Text("I've opened the link"),
                ),
              ],
              
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
