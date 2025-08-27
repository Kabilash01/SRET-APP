import 'package:flutter/material.dart';
import 'dart:ui';

class AppleLiquidGlass extends StatelessWidget {
  final Widget child;
  final BorderRadius radius;
  final double blur;
  final Color? color;
  final double opacity;

  const AppleLiquidGlass({
    super.key,
    required this.child,
    this.radius = const BorderRadius.all(Radius.circular(12)),
    this.blur = 20.0,
    this.color,
    this.opacity = 0.1,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: radius,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: radius,
            color: color ?? Colors.white.withOpacity(opacity),
            border: Border.all(
              color: Colors.white.withOpacity(0.2),
              width: 1.0,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: child,
        ),
      ),
    );
  }
}
