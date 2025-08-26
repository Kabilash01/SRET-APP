import 'package:flutter/material.dart';

/// Global background widget with warm peach-cream gradient and liquid-glass highlight
class AppBackground extends StatelessWidget {
  final Widget child;

  const AppBackground({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Layer 1: Main peach-cream linear gradient
        Positioned.fill(
          child: DecoratedBox(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: [0.0, 0.55, 1.0],
                colors: [
                  Color(0xFFFFF7E9), // cream
                  Color(0xFFFFE1CF), // peach
                  Color(0xFFF8B4A6), // warm coral
                ],
              ),
            ),
          ),
        ),
        
        // Layer 2: Radial highlight overlay for liquid-glass effect
        Positioned.fill(
          child: DecoratedBox(
            decoration: const BoxDecoration(
              gradient: RadialGradient(
                center: Alignment(-0.85, -0.85),
                radius: 1.0,
                colors: [
                  Color(0x22FFFFFF), // white 13.3% opacity
                  Color(0x00FFFFFF), // transparent white
                ],
              ),
            ),
          ),
        ),
        
        // Layer 3: Child content on top
        child,
      ],
    );
  }
}
