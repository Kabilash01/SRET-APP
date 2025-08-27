import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/sret_theme.dart';
import '../widgets/liquid_glass.dart';
import '../services/auth_service.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage>
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
    _loadRememberMe();
  }

  Future<void> _loadRememberMe() async {
    final savedEmail = await AuthService.getSavedEmail();
    
    if (savedEmail != null) {
      _emailController.text = savedEmail;
      setState(() {
        _rememberMe = true;
      });
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _signInWithEmail() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final success = await AuthService.signInWithEmail(
        _emailController.text,
        _passwordController.text,
        _rememberMe,
      );

      if (success && mounted) {
        context.go('/today');
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Invalid email or password'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        String errorMessage = 'Sign in failed';
        if (e.toString().contains('Only @sret.edu.in emails are allowed')) {
          errorMessage = 'Only @sret.edu.in emails are allowed for sign in';
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
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

  Future<void> _signInWithGoogle() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final success = await AuthService.signInWithGoogle();
      
      if (success && mounted) {
        context.go('/today');
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Google sign in was cancelled'),
            backgroundColor: Colors.orange,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        String errorMessage = 'Google sign in failed';
        if (e.toString().contains('Only @sret.edu.in emails are allowed')) {
          errorMessage = 'Only @sret.edu.in emails are allowed for sign in';
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
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
      backgroundColor: AppTheme.beige,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppTheme.beige,
              AppTheme.sand.withOpacity(0.8),
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                return FadeTransition(
                  opacity: _fadeAnimation,
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Header Section
                        const SizedBox(height: 60),
                        Center(
                          child: Column(
                            children: [
                              Text(
                                'Sign In',
                                style: GoogleFonts.robotoSerif(
                                  fontSize: 36,
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.burgundy,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                'Welcome back to SRET',
                                style: GoogleFonts.robotoSerif(
                                  fontSize: 18,
                                  color: AppTheme.burgundy.withOpacity(0.7),
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ),
                        
                        const SizedBox(height: 48),
                        
                        // Sign In Form
                        LiquidGlass.card(
                          child: Padding(
                            padding: const EdgeInsets.all(24),
                            child: Form(
                              key: _formKey,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  // Email Field
                                  Text(
                                    'Email',
                                    style: GoogleFonts.robotoSerif(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: AppTheme.burgundy,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  TextFormField(
                                    controller: _emailController,
                                    keyboardType: TextInputType.emailAddress,
                                    decoration: InputDecoration(
                                      hintText: 'Enter your @sret.edu.in email',
                                      prefixIcon: Icon(
                                        Icons.email_outlined,
                                        color: AppTheme.burgundy.withOpacity(0.6),
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide(
                                          color: AppTheme.burgundy.withOpacity(0.3),
                                        ),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide(
                                          color: AppTheme.burgundy.withOpacity(0.3),
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide(
                                          color: AppTheme.burgundy,
                                          width: 2,
                                        ),
                                      ),
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter your email';
                                      }
                                      if (!value.contains('@')) {
                                        return 'Please enter a valid email';
                                      }
                                      // Check if email ends with @sret.edu.in
                                      if (!value.toLowerCase().endsWith('@sret.edu.in')) {
                                        return 'Only @sret.edu.in emails are allowed';
                                      }
                                      // Additional validation for proper email format
                                      final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@sret\.edu\.in$');
                                      if (!emailRegex.hasMatch(value.toLowerCase())) {
                                        return 'Please enter a valid @sret.edu.in email';
                                      }
                                      return null;
                                    },
                                  ),
                                  
                                  const SizedBox(height: 20),
                                  
                                  // Password Field
                                  Text(
                                    'Password',
                                    style: GoogleFonts.robotoSerif(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: AppTheme.burgundy,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  TextFormField(
                                    controller: _passwordController,
                                    obscureText: _obscurePassword,
                                    decoration: InputDecoration(
                                      hintText: 'Enter your password',
                                      prefixIcon: Icon(
                                        Icons.lock_outlined,
                                        color: AppTheme.burgundy.withOpacity(0.6),
                                      ),
                                      suffixIcon: IconButton(
                                        icon: Icon(
                                          _obscurePassword
                                              ? Icons.visibility_outlined
                                              : Icons.visibility_off_outlined,
                                          color: AppTheme.burgundy.withOpacity(0.6),
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            _obscurePassword = !_obscurePassword;
                                          });
                                        },
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide(
                                          color: AppTheme.burgundy.withOpacity(0.3),
                                        ),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide(
                                          color: AppTheme.burgundy.withOpacity(0.3),
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide(
                                          color: AppTheme.burgundy,
                                          width: 2,
                                        ),
                                      ),
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter your password';
                                      }
                                      if (value.length < 6) {
                                        return 'Password must be at least 6 characters';
                                      }
                                      return null;
                                    },
                                  ),
                                  
                                  const SizedBox(height: 16),
                                  
                                  // Remember Me and Forgot Password
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Checkbox(
                                            value: _rememberMe,
                                            onChanged: (value) {
                                              setState(() {
                                                _rememberMe = value ?? false;
                                              });
                                            },
                                            activeColor: AppTheme.burgundy,
                                          ),
                                          Text(
                                            'Remember me',
                                            style: GoogleFonts.robotoSerif(
                                              fontSize: 14,
                                              color: AppTheme.burgundy.withOpacity(0.8),
                                            ),
                                          ),
                                        ],
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          context.push('/reset-password');
                                        },
                                        child: Text(
                                          'Forgot Password?',
                                          style: GoogleFonts.robotoSerif(
                                            fontSize: 14,
                                            color: AppTheme.burgundy,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  
                                  const SizedBox(height: 24),
                                  
                                  // Sign In Button
                                  ElevatedButton(
                                    onPressed: _isLoading ? null : _signInWithEmail,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppTheme.burgundy,
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(vertical: 16),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      elevation: 4,
                                    ),
                                    child: _isLoading
                                        ? const SizedBox(
                                            height: 20,
                                            width: 20,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                              valueColor: AlwaysStoppedAnimation<Color>(
                                                Colors.white,
                                              ),
                                            ),
                                          )
                                        : Text(
                                            'Sign In',
                                            style: GoogleFonts.robotoSerif(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        
                        const SizedBox(height: 32),
                        
                        // Divider
                        Row(
                          children: [
                            Expanded(
                              child: Divider(
                                color: AppTheme.burgundy.withOpacity(0.3),
                                thickness: 1,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              child: Text(
                                'OR',
                                style: GoogleFonts.robotoSerif(
                                  fontSize: 14,
                                  color: AppTheme.burgundy.withOpacity(0.6),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Divider(
                                color: AppTheme.burgundy.withOpacity(0.3),
                                thickness: 1,
                              ),
                            ),
                          ],
                        ),
                        
                        const SizedBox(height: 24),
                        
                        // Google Sign In Button
                        LiquidGlass.card(
                          child: InkWell(
                            onTap: _isLoading ? null : _signInWithGoogle,
                            borderRadius: BorderRadius.circular(16),
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 28,
                                    height: 28,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(6),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.1),
                                          blurRadius: 2,
                                          offset: const Offset(0, 1),
                                        ),
                                      ],
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(4),
                                      child: CustomPaint(
                                        size: const Size(20, 20),
                                        painter: GoogleLogoPainter(),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Text(
                                    'Continue with Google',
                                    style: GoogleFonts.robotoSerif(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: AppTheme.burgundy,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        
                        const SizedBox(height: 32),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class GoogleLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width * 0.35;
    final strokeWidth = size.width * 0.12;
    
    // Google brand colors
    final blue = Paint()
      ..color = const Color(0xFF4285F4)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;
      
    final red = Paint()
      ..color = const Color(0xFFEA4335)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;
      
    final yellow = Paint()
      ..color = const Color(0xFFFBBC05)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;
      
    final green = Paint()
      ..color = const Color(0xFF34A853)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;
    
    // Create the circular path
    final rect = Rect.fromCircle(center: center, radius: radius);
    
    // Draw blue arc (left side)
    canvas.drawArc(
      rect,
      2.356, // 135 degrees in radians
      1.57,  // 90 degrees
      false,
      blue,
    );
    
    // Draw green arc (bottom)
    canvas.drawArc(
      rect,
      0.785, // 45 degrees
      1.57,  // 90 degrees
      false,
      green,
    );
    
    // Draw yellow arc (bottom right)
    canvas.drawArc(
      rect,
      -0.785, // -45 degrees
      1.57,   // 90 degrees
      false,
      yellow,
    );
    
    // Draw red arc (top)
    canvas.drawArc(
      rect,
      -2.356, // -135 degrees
      1.57,   // 90 degrees
      false,
      red,
    );
    
    // Draw the horizontal line (Google G's crossbar)
    final lineY = center.dy;
    final lineStartX = center.dx - strokeWidth * 0.3;
    final lineEndX = center.dx + radius * 0.7;
    
    final linePaint = Paint()
      ..color = const Color(0xFF4285F4)
      ..strokeWidth = strokeWidth * 0.7
      ..strokeCap = StrokeCap.round;
    
    canvas.drawLine(
      Offset(lineStartX, lineY),
      Offset(lineEndX, lineY),
      linePaint,
    );
    
    // Draw small vertical line to complete the G
    canvas.drawLine(
      Offset(lineEndX, lineY),
      Offset(lineEndX, lineY + strokeWidth * 0.8),
      linePaint,
    );
  }
  
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
