import 'dart:ui';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class LiquidGlass extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final double borderRadius;
  final double? width;
  final double? height;

  const LiquidGlass({
    super.key,
    required this.child,
    this.padding,
    this.borderRadius = 24,
    this.width,
    this.height,
  });

  /// Creates a glass card with default padding
  static Widget card({
    required Widget child,
    EdgeInsetsGeometry? padding,
    double borderRadius = 24,
    double? width,
    double? height,
  }) {
    return LiquidGlass(
      padding: padding ?? const EdgeInsets.all(24),
      borderRadius: borderRadius,
      width: width,
      height: height,
      child: child,
    );
  }

  /// Creates a glass pill with fixed height
  static Widget pill({
    required Widget child,
    EdgeInsetsGeometry? padding,
    double height = 52,
    double? width,
  }) {
    return LiquidGlass(
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 20),
      borderRadius: height / 2,
      width: width,
      height: height,
      child: child,
    );
  }

  /// Creates a circular glass widget
  static Widget circle({
    required Widget child,
    required double size,
    EdgeInsetsGeometry? padding,
  }) {
    return LiquidGlass(
      padding: padding,
      borderRadius: size / 2,
      width: size,
      height: size,
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 22, sigmaY: 22),
        child: Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(borderRadius),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.glassFill1, // white@16%
                AppColors.glassFill2, // white@6%
              ],
            ),
            border: Border.all(
              color: AppColors.glassStroke, // white@35%
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.glassShadow, // black@8%
                blurRadius: 24,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Stack(
            children: [
              // Top-left radial highlight
              Positioned(
                top: 0,
                left: 0,
                child: Container(
                  width: borderRadius * 2,
                  height: borderRadius * 2,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(borderRadius),
                    gradient: RadialGradient(
                      center: Alignment.topLeft,
                      radius: 1.0,
                      colors: [
                        AppColors.glassHighlight, // white@10-12%
                        Colors.transparent,
                      ],
                      stops: const [0.0, 1.0],
                    ),
                  ),
                ),
              ),
              // Child content
              if (padding != null)
                Padding(
                  padding: padding!,
                  child: child,
                )
              else
                child,
            ],
          ),
        ),
      ),
    );
  }
}
