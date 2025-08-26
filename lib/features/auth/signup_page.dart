import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../core/auth/fake_auth_repo.dart';
import '../../theme/app_theme.dart';

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
        const SnackBar(
          content: Text('Please agree to Terms & Privacy Policy'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    if (_selectedDepartment == null || _selectedRole == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select department and role'),
          backgroundColor: Colors.red,
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
                const Text('Account created. Please sign in.'),
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
          const SnackBar(
            content: Text('Account creation failed. Please try again.'),
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
                          'Create account',
                          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            color: AppTheme.sretPrimary,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ).animate().fadeIn(duration: 600.ms).slideY(begin: -0.2),
                        
                        const SizedBox(height: 32),
                        
                        // Full Name Field
                        TextFormField(
                          controller: _fullNameController,
                          enabled: !_isLoading,
                          keyboardType: TextInputType.name,
                          autofillHints: const [AutofillHints.name],
                          validator: _validateFullName,
                          decoration: const InputDecoration(
                            labelText: 'Full Name',
                            hintText: 'Enter your full name',
                            prefixIcon: Icon(Icons.person_outline),
                          ),
                        ).animate().fadeIn(delay: 100.ms, duration: 600.ms).slideX(begin: -0.2),
                        
                        const SizedBox(height: 16),
                        
                        // Employee ID Field
                        TextFormField(
                          controller: _employeeIdController,
                          enabled: !_isLoading,
                          validator: _validateEmployeeId,
                          decoration: const InputDecoration(
                            labelText: 'Employee ID',
                            hintText: 'Enter your employee ID',
                            prefixIcon: Icon(Icons.badge_outlined),
                          ),
                        ).animate().fadeIn(delay: 200.ms, duration: 600.ms).slideX(begin: -0.2),
                        
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
                          decoration: const InputDecoration(
                            labelText: 'Phone Number',
                            hintText: '+91 9876543210',
                            prefixIcon: Icon(Icons.phone_outlined),
                          ),
                        ).animate().fadeIn(delay: 300.ms, duration: 600.ms).slideX(begin: -0.2),
                        
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
                          decoration: const InputDecoration(
                            labelText: 'Email',
                            hintText: 'yourname@sret.edu.in',
                            prefixIcon: Icon(Icons.mail_outline),
                            helperText: 'Must end with @sret.edu.in',
                          ),
                        ).animate().fadeIn(delay: 400.ms, duration: 600.ms).slideX(begin: -0.2),
                        
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
                          ),
                        ).animate().fadeIn(delay: 500.ms, duration: 600.ms).slideX(begin: -0.2),
                        
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
                        ),
                      ).animate().fadeIn(delay: 600.ms, duration: 600.ms).slideX(begin: -0.2),
                      
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
                      ).animate().fadeIn(delay: 700.ms, duration: 600.ms).slideX(begin: -0.2),
                      
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
                      ).animate().fadeIn(delay: 800.ms, duration: 600.ms).slideX(begin: -0.2),
                      
                      const SizedBox(height: 16),
                      
                      // Helper note
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: AppTheme.frostedGlass.copyWith(
                          borderRadius: BorderRadius.circular(12),
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
                      ).animate().fadeIn(delay: 900.ms, duration: 600.ms).scale(begin: const Offset(0.8, 0.8)),
                      
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
                      ).animate().fadeIn(delay: 1000.ms, duration: 600.ms).slideX(begin: -0.2),
                      
                      const SizedBox(height: 24),
                      
                      // Create Account Button
                      Transform.scale(
                        scale: _isLoading ? 0.96 : 1.0,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 150),
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _handleCreateAccount,
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
                                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
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
                              'Create account',
                              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ).animate().fadeIn(delay: 1100.ms, duration: 600.ms).scale(begin: const Offset(0.95, 0.95)),
                        
                        const SizedBox(height: 16),
                        
                        // Sign in link
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
                        ).animate().fadeIn(delay: 1200.ms, duration: 600.ms).slideY(begin: 0.2),
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
