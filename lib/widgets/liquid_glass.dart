import 'package:flutter/material.dart';
import 'dart:ui';

class LiquidGlass extends StatelessWidget {
  final Widget child;
  final BorderRadius? borderRadius;
  final double? width;
  final double? height;

  const LiquidGlass({
    super.key,
    required this.child,
    this.borderRadius,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 22, sigmaY: 22),
        child: Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            borderRadius: borderRadius ?? BorderRadius.circular(24),
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0x40FFFFFF), // white 25% (increased from 16%)
                Color(0x1AFFFFFF), // white 10% (increased from 6%)
              ],
            ),
            border: Border.all(
              color: const Color(0x70FFFFFF), // white 44% (increased from 35%)
              width: 1.0,
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0x20000000), // black 12% (increased from 8%)
                blurRadius: 24,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Stack(
            children: [
              // Small top-left radial highlight
              Positioned(
                top: 0,
                left: 0,
                child: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    borderRadius: borderRadius ?? BorderRadius.circular(24),
                    gradient: const RadialGradient(
                      center: Alignment.topLeft,
                      radius: 0.8,
                      colors: [
                        Color(0x30FFFFFF), // white 19% (increased from 12%)
                        Color(0x00FFFFFF), // white 0%
                      ],
                    ),
                  ),
                ),
              ),
              child,
            ],
          ),
        ),
      ),
    );
  }

  // Builder methods
  static Widget card({required Widget child}) {
    return LiquidGlass(
      borderRadius: BorderRadius.circular(24),
      child: child,
    );
  }

  static Widget pill({
    required Widget child, 
    double height = 50,
  }) {
    return LiquidGlass(
      height: height,
      borderRadius: BorderRadius.circular(height / 2),
      child: child,
    );
  }

  static Widget circle({
    required Widget child, 
    double size = 46,
    EdgeInsetsGeometry? padding,
  }) {
    return LiquidGlass(
      width: size,
      height: size,
      borderRadius: BorderRadius.circular(size / 2),
      child: Container(
        padding: padding ?? EdgeInsets.zero,
        child: child,
      ),
    );
  }
}
