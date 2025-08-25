import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/auth/fake_auth_repo.dart';
import '../shared/blurred_background.dart';
import '../shared/glass_card.dart';

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

  // SRET email validation regex (case-insensitive)
  static const String _sretEmailRegex = r'^[A-Za-z0-9._%+-]+@sret\.edu\.in$';

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

  // Validation helpers
  bool isSretEmail(String email) {
    return RegExp(_sretEmailRegex, caseSensitive: false).hasMatch(email.toLowerCase().trim());
  }

  String? _validateFullName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Full name is required';
    }
    if (value.trim().length < 3) {
      return 'Name must be at least 3 characters';
    }
    return null;
  }

  String? _validateEmployeeId(String? value) {
    if (value == null || value.isEmpty) {
      return 'Employee ID is required';
    }
    if (!RegExp(r'^[A-Za-z0-9_-]{3,20}$').hasMatch(value)) {
      return 'Employee ID must be 3-20 characters (letters, numbers, _, -)';
    }
    return null;
  }

  String? _validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Phone number is required';
    }
    final cleanedPhone = value.replaceAll(RegExp(r'[^\d]'), '');
    if (cleanedPhone.length < 10 || cleanedPhone.length > 15) {
      return 'Phone number must be 10-15 digits';
    }
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    if (!isSretEmail(value)) {
      return 'Must be a valid @sret.edu.in email address';
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

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    if (value != _passwordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  Future<void> _handleCreateAccount() async {
    if (!_formKey.currentState!.validate()) return;
    if (!_agreeToTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Please agree to Terms & Privacy Policy',
            style: GoogleFonts.robotoSerif(),
          ),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }
    if (_selectedDepartment == null || _selectedRole == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Please select department and role',
            style: GoogleFonts.robotoSerif(),
          ),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await _authRepo.createAccount(
        fullName: _fullNameController.text.trim(),
        employeeId: _employeeIdController.text.trim(),
        phoneNumber: _phoneController.text.trim(),
        email: _emailController.text.toLowerCase().trim(),
        password: _passwordController.text,
        department: _selectedDepartment!,
        role: _selectedRole!,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.white),
                const SizedBox(width: 8),
                Text(
                  'Account created. Please sign in.',
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

        // Navigate back to login
        context.go('/login');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Account creation failed. Please try again.',
              style: GoogleFonts.robotoSerif(),
            ),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
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
      backgroundColor: const Color(0xFFFFF7E6), // CREAM_BG
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
                        'Create account',
                        style: GoogleFonts.robotoSerif(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF0D2240), // NAVY
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
                        validator: _validateFullName,
                        decoration: InputDecoration(
                          labelText: 'Full Name',
                          hintText: 'Enter your full name',
                          prefixIcon: const Icon(Icons.person_outline),
                          labelStyle: GoogleFonts.robotoSerif(),
                          hintStyle: GoogleFonts.robotoSerif(),
                        ),
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Employee ID Field
                      TextFormField(
                        controller: _employeeIdController,
                        enabled: !_isLoading,
                        validator: _validateEmployeeId,
                        decoration: InputDecoration(
                          labelText: 'Employee ID',
                          hintText: 'Enter your employee ID',
                          prefixIcon: const Icon(Icons.badge_outlined),
                          labelStyle: GoogleFonts.robotoSerif(),
                          hintStyle: GoogleFonts.robotoSerif(),
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
                        validator: _validatePhone,
                        decoration: InputDecoration(
                          labelText: 'Phone Number',
                          hintText: '+91 9876543210',
                          prefixIcon: const Icon(Icons.phone_outlined),
                          labelStyle: GoogleFonts.robotoSerif(),
                          hintStyle: GoogleFonts.robotoSerif(),
                        ),
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Email Field
                      TextFormField(
                        controller: _emailController,
                        enabled: !_isLoading,
                        keyboardType: TextInputType.emailAddress,
                        autofillHints: const [AutofillHints.email],
                        validator: _validateEmail,
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
                        decoration: InputDecoration(
                          labelText: 'Email',
                          hintText: 'yourname@sret.edu.in',
                          prefixIcon: const Icon(Icons.mail_outline),
                          helperText: 'Must end with @sret.edu.in',
                          labelStyle: GoogleFonts.robotoSerif(),
                          hintStyle: GoogleFonts.robotoSerif(),
                          helperStyle: GoogleFonts.robotoSerif(
                            fontSize: 12,
                            color: const Color(0xFF4B5563), // TEXT_SECONDARY
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Password Field
                      TextFormField(
                        controller: _passwordController,
                        enabled: !_isLoading,
                        obscureText: !_isPasswordVisible,
                        autofillHints: const [AutofillHints.newPassword],
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
                          helperText: 'Minimum 6 characters',
                          labelStyle: GoogleFonts.robotoSerif(),
                          hintStyle: GoogleFonts.robotoSerif(),
                          helperStyle: GoogleFonts.robotoSerif(
                            fontSize: 12,
                            color: const Color(0xFF4B5563), // TEXT_SECONDARY
                          ),
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
                          hintText: 'Confirm your password',
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
                          labelStyle: GoogleFonts.robotoSerif(),
                          hintStyle: GoogleFonts.robotoSerif(),
                        ),
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Department Dropdown
                      DropdownButtonFormField<String>(
                        value: _selectedDepartment,
                        isExpanded: true,
                        decoration: InputDecoration(
                          labelText: 'Department',
                          prefixIcon: const Icon(Icons.school_outlined),
                          labelStyle: GoogleFonts.robotoSerif(),
                        ),
                        items: _departments.map((dept) {
                          return DropdownMenuItem(
                            value: '${dept['code']} — ${dept['name']}',
                            child: Text(
                              '${dept['code']} — ${dept['name']}',
                              style: GoogleFonts.robotoSerif(),
                            ),
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
                        decoration: InputDecoration(
                          labelText: 'Role',
                          prefixIcon: const Icon(Icons.work_outline),
                          labelStyle: GoogleFonts.robotoSerif(),
                        ),
                        items: _roles.map((role) {
                          return DropdownMenuItem(
                            value: role,
                            child: Text(
                              role,
                              style: GoogleFonts.robotoSerif(),
                            ),
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
                          color: const Color(0xFFFFF9EC).withOpacity(0.7), // CREAM_SURFACE
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: const Color(0xFFE8E2D6), // DIVIDER
                            width: 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.info_outline,
                              size: 16,
                              color: Color(0xFF4B5563), // TEXT_SECONDARY
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'DEAN/VICE DEAN/HOD accounts require admin verification.',
                                style: GoogleFonts.robotoSerif(
                                  fontSize: 12,
                                  color: const Color(0xFF4B5563), // TEXT_SECONDARY
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
                              activeColor: const Color(0xFF0D2240), // NAVY
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
                                style: GoogleFonts.robotoSerif(
                                  fontSize: 14,
                                  color: const Color(0xFF4B5563), // TEXT_SECONDARY
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 24),
                      
                      // Create Account Button
                      Transform.scale(
                        scale: _isLoading ? 0.96 : 1.0,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 150),
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _handleCreateAccount,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF0D2240), // NAVY
                              minimumSize: const Size(double.infinity, 48),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
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
                                : Text(
                                    'Create account',
                                    style: GoogleFonts.robotoSerif(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                    semanticsLabel: 'Create account',
                                  ),
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 24),
                      
                      // Back to Sign in link
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextButton(
                            onPressed: _isLoading ? null : () => context.pop(),
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            child: Text(
                              'Back to Sign in',
                              style: GoogleFonts.robotoSerif(
                                color: const Color(0xFF0D2240), // NAVY
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
            )
                .animate()
                .slideY(
                  begin: 0.15, // Slide from y:+48
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
