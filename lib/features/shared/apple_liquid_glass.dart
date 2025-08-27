import 'package:flutter/material.dart';

class AppleLiquidGlass extends StatelessWidget {
  final Widget child;
  final BorderRadius radius;

  const AppleLiquidGlass({
    super.key,
    required this.child,
    this.radius = const BorderRadius.all(Radius.circular(20)),
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      decoration: BoxDecoration(
        borderRadius: radius,
        color: isDark 
            ? const Color(0x1AFFFFFF) // Light glass effect on dark
            : const Color(0x14000000), // Dark glass effect on light
        border: Border.all(
          color: isDark 
              ? const Color(0x2AFFFFFF) 
              : const Color(0x2A000000),
          width: 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }
}
