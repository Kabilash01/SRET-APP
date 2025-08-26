import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../core/auth/fake_auth_repo.dart';
import '../../theme/app_theme.dart';
import '../shared/liquid_glass.dart';
import '../shared/validators.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _employeeIdController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  
  final _authRepo = FakeAuthRepo();
  
  String? _selectedDepartment;
  String? _selectedRole;
  bool _agreeToTerms = false;
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _isLoading = false;

  // Department options
  final List<Map<String, String>> _departments = [
    {'code': 'E01', 'name': 'AIML'},
    {'code': 'E02', 'name': 'CYBER & IOT'},
    {'code': 'E03', 'name': 'AIDA'},
    {'code': 'E04', 'name': 'MEDICAL ENGINEERING'},
    {'code': 'E05', 'name': 'ECE'},
  ];

  // Role options
  final List<String> _roles = [
    'DEAN',
    'VICE DEAN',
    'HOD',
    'FACULTY',
    'STAFF',
    'NON TEACHING STAFF',
    'GUEST FACULTY',
  ];

  @override
  void dispose() {
    _fullNameController.dispose();
    _employeeIdController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    if (value != _passwordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  bool get _isFormValid {
    return _fullNameController.text.trim().isNotEmpty &&
        _employeeIdController.text.trim().isNotEmpty &&
        _phoneController.text.trim().isNotEmpty &&
        _emailController.text.trim().isNotEmpty &&
        _passwordController.text.isNotEmpty &&
        _confirmPasswordController.text.isNotEmpty &&
        _selectedDepartment != null &&
        _selectedRole != null &&
        _agreeToTerms &&
        validateSretEmail(_emailController.text) == null &&
        validatePassword(_passwordController.text) == null &&
        _passwordController.text == _confirmPasswordController.text;
  }

  Future<void> _handleCreateAccount() async {
    if (!_formKey.currentState!.validate() || !_isFormValid) return;

    setState(() {
      _isLoading = true;
    });

    try {
      await _authRepo.createAccount(
        fullName: _fullNameController.text.trim(),
        employeeId: _employeeIdController.text.trim(),
        phoneNumber: _phoneController.text.trim(),
        email: _emailController.text.trim().toLowerCase(),
        password: _passwordController.text,
        department: _selectedDepartment!,
        role: _selectedRole!,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Row(
              children: [
                Icon(Icons.check_circle, color: Colors.white),
                SizedBox(width: 8),
                Text('Account created. Please sign in.'),
              ],
            ),
          ),
        );

        // Navigate back to login
        context.go('/login');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Account creation failed: ${e.toString()}'),
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
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 420),
                  child: LiquidGlass(
                    radius: const BorderRadius.all(Radius.circular(20)),
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // Title
                            Text(
                              'Create account',
                              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                color: AppTheme.sretPrimary,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            
                            const SizedBox(height: 32),
                            
                            // Full Name Field
                            TextFormField(
                              controller: _fullNameController,
                              enabled: !_isLoading,
                              keyboardType: TextInputType.name,
                              autofillHints: const [AutofillHints.name],
                              validator: validateFullName,
                              decoration: const InputDecoration(
                                labelText: 'Full Name',
                                hintText: 'Enter your full name',
                                prefixIcon: Icon(Icons.person_outline),
                              ),
                            ),
                            
                            const SizedBox(height: 16),
                            
                            // Employee ID Field
                            TextFormField(
                              controller: _employeeIdController,
                              enabled: !_isLoading,
                              validator: validateEmpId,
                              decoration: const InputDecoration(
                                labelText: 'Employee ID',
                                hintText: 'Enter your employee ID',
                                prefixIcon: Icon(Icons.badge_outlined),
                              ),
                            ),
                            
                            const SizedBox(height: 16),
                            
                            // Phone Number Field
                            TextFormField(
                              controller: _phoneController,
                              enabled: !_isLoading,
                              keyboardType: TextInputType.phone,
                              autofillHints: const [AutofillHints.telephoneNumber],
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(RegExp(r'[0-9 +-]')),
                              ],
                              validator: validatePhone,
                              decoration: const InputDecoration(
                                labelText: 'Phone Number',
                                hintText: '+91 9876543210',
                                prefixIcon: Icon(Icons.phone_outlined),
                              ),
                            ),
                            
                            const SizedBox(height: 16),
                            
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
                            
                            const SizedBox(height: 16),
                            
                            // Password Field
                            TextFormField(
                              controller: _passwordController,
                              enabled: !_isLoading,
                              obscureText: !_isPasswordVisible,
                              autofillHints: const [AutofillHints.newPassword],
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
                                helperText: 'Minimum 6 characters',
                              ),
                            ),
                            
                            const SizedBox(height: 16),
                            
                            // Confirm Password Field
                            TextFormField(
                              controller: _confirmPasswordController,
                              enabled: !_isLoading,
                              obscureText: !_isConfirmPasswordVisible,
                              autofillHints: const [AutofillHints.newPassword],
                              validator: _validateConfirmPassword,
                              decoration: InputDecoration(
                                labelText: 'Confirm Password',
                                hintText: 'Re-enter your password',
                                prefixIcon: const Icon(Icons.lock_outline),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _isConfirmPasswordVisible
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                                    });
                                  },
                                ),
                              ),
                            ),
                            
                            const SizedBox(height: 16),
                            
                            // Department Dropdown
                            DropdownButtonFormField<String>(
                              value: _selectedDepartment,
                              isExpanded: true,
                              decoration: const InputDecoration(
                                labelText: 'Department',
                                prefixIcon: Icon(Icons.school_outlined),
                              ),
                              items: _departments.map((dept) {
                                return DropdownMenuItem(
                                  value: '${dept['code']} — ${dept['name']}',
                                  child: Text('${dept['code']} — ${dept['name']}'),
                                );
                              }).toList(),
                              onChanged: _isLoading ? null : (value) {
                                setState(() {
                                  _selectedDepartment = value;
                                });
                              },
                              validator: (value) {
                                if (value == null) {
                                  return 'Please select a department';
                                }
                                return null;
                              },
                            ),
                            
                            const SizedBox(height: 16),
                            
                            // Role Dropdown
                            DropdownButtonFormField<String>(
                              value: _selectedRole,
                              isExpanded: true,
                              decoration: const InputDecoration(
                                labelText: 'Role',
                                prefixIcon: Icon(Icons.work_outline),
                              ),
                              items: _roles.map((role) {
                                return DropdownMenuItem(
                                  value: role,
                                  child: Text(role),
                                );
                              }).toList(),
                              onChanged: _isLoading ? null : (value) {
                                setState(() {
                                  _selectedRole = value;
                                });
                              },
                              validator: (value) {
                                if (value == null) {
                                  return 'Please select a role';
                                }
                                return null;
                              },
                            ),
                            
                            const SizedBox(height: 16),
                            
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
                                      'DEAN/VICE DEAN/HOD accounts require admin verification.',
                                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                        color: AppTheme.sretTextSecondary,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            
                            const SizedBox(height: 16),
                            
                            // Terms Checkbox
                            Row(
                              children: [
                                SizedBox(
                                  width: 44,
                                  height: 44,
                                  child: Checkbox(
                                    value: _agreeToTerms,
                                    onChanged: _isLoading ? null : (value) {
                                      setState(() {
                                        _agreeToTerms = value ?? false;
                                      });
                                    },
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: GestureDetector(
                                    onTap: _isLoading ? null : () {
                                      setState(() {
                                        _agreeToTerms = !_agreeToTerms;
                                      });
                                    },
                                    child: Text(
                                      'I agree to Terms & Privacy Policy',
                                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                        color: AppTheme.sretTextSecondary,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            
                            const SizedBox(height: 24),
                            
                            // Create Account Button
                            AnimatedScale(
                              scale: _isLoading ? 0.96 : 1.0,
                              duration: const Duration(milliseconds: 150),
                              child: ElevatedButton(
                                onPressed: (_isFormValid && !_isLoading) ? _handleCreateAccount : null,
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
                                        'Create account',
                                        semanticsLabel: 'Create account',
                                      ),
                              ),
                            ),
                            
                            const SizedBox(height: 16),
                            
                            // Back to sign in link
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Already have an account? ',
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
                      ),
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
