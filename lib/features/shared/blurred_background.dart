import 'package:flutter/material.dart';
import 'dart:math' as math;

class BlurredBackground extends StatefulWidget {
  final Widget child;
  
  const BlurredBackground({
    super.key,
    required this.child,
  });

  @override
  State<BlurredBackground> createState() => _BlurredBackgroundState();
}

class _BlurredBackgroundState extends State<BlurredBackground>
    with TickerProviderStateMixin {
  late AnimationController _animationController1;
  late AnimationController _animationController2;
  late AnimationController _animationController3;

  @override
  void initState() {
    super.initState();
    
    _animationController1 = AnimationController(
      duration: const Duration(seconds: 20),
      vsync: this,
    )..repeat();
    
    _animationController2 = AnimationController(
      duration: const Duration(seconds: 25),
      vsync: this,
    )..repeat();
    
    _animationController3 = AnimationController(
      duration: const Duration(seconds: 30),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _animationController1.dispose();
    _animationController2.dispose();
    _animationController3.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    
    return Scaffold(
      body: Stack(
        children: [
          // Background color
          Container(
            width: double.infinity,
            height: double.infinity,
            color: const Color(0xFFFFF7E6), // CREAM_BG
          ),
          
          // Animated blob 1
          AnimatedBuilder(
            animation: _animationController1,
            builder: (context, child) {
              return Positioned(
                left: size.width * 0.1 + 
                       math.sin(_animationController1.value * 2 * math.pi) * 30,
                top: size.height * 0.2 + 
                     math.cos(_animationController1.value * 2 * math.pi) * 20,
                child: Transform.scale(
                  scale: 1.0 + math.sin(_animationController1.value * 2 * math.pi) * 0.1,
                  child: Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          const Color(0xFF0D2240).withValues(alpha: 0.1),
                          const Color(0xFF0D2240).withValues(alpha: 0.05),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
          
          // Animated blob 2
          AnimatedBuilder(
            animation: _animationController2,
            builder: (context, child) {
              return Positioned(
                right: size.width * 0.1 + 
                       math.cos(_animationController2.value * 2 * math.pi) * 25,
                top: size.height * 0.4 + 
                     math.sin(_animationController2.value * 2 * math.pi) * 35,
                child: Transform.scale(
                  scale: 1.0 + math.cos(_animationController2.value * 2 * math.pi) * 0.08,
                  child: Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          const Color(0xFF4B5563).withValues(alpha: 0.08),
                          const Color(0xFF4B5563).withValues(alpha: 0.04),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
          
          // Animated blob 3
          AnimatedBuilder(
            animation: _animationController3,
            builder: (context, child) {
              return Positioned(
                left: size.width * 0.5 + 
                       math.sin(_animationController3.value * 2 * math.pi + 1) * 40,
                bottom: size.height * 0.3 + 
                        math.cos(_animationController3.value * 2 * math.pi + 1) * 30,
                child: Transform.scale(
                  scale: 1.0 + math.sin(_animationController3.value * 2 * math.pi + 1) * 0.12,
                  child: Container(
                    width: 180,
                    height: 180,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          const Color(0xFF0D2240).withValues(alpha: 0.06),
                          const Color(0xFF0D2240).withValues(alpha: 0.03),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
          
          // Child content
          widget.child,
        ],
      ),
    );
  }
}
