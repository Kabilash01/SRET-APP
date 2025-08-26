import 'dart:ui';
import 'package:flutter/material.dart';

class AcrylicGlass extends StatelessWidget {
  final Widget child;
  final BorderRadius radius;
  final double blur;
  final Color tint;

  const AcrylicGlass({
    super.key,
    required this.child,
    this.radius = const BorderRadius.all(Radius.circular(20)),
    this.blur = 18.0,
    this.tint = const Color(0xFF0D2240),
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: radius,
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: blur,
          sigmaY: blur,
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: radius,
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color.fromRGBO(255, 255, 255, 0.20),
                Color.fromRGBO(255, 255, 255, 0.06),
              ],
            ),
            color: Color.fromRGBO(255, 255, 255, 0.16).withOpacity(0.16),
            border: Border.all(
              color: const Color.fromRGBO(255, 255, 255, 0.22),
              width: 1.0,
            ),
            boxShadow: [
              BoxShadow(
                color: tint.withOpacity(0.10),
                blurRadius: 24,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Stack(
            children: [
              // Base container with tint
              Container(
                decoration: BoxDecoration(
                  borderRadius: radius,
                  color: tint.withOpacity(0.08),
                ),
              ),
              
              // Noise texture overlay (fallback to programmatic noise)
              Positioned.fill(
                child: _NoiseOverlay(radius: radius),
              ),
              
              // Content
              child,
            ],
          ),
        ),
      ),
    );
  }
}

// Helper widget for creating programmatic noise pattern
class _NoiseOverlay extends StatelessWidget {
  final BorderRadius radius;
  
  const _NoiseOverlay({required this.radius});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: radius,
        // Create a subtle noise-like pattern using a repeating gradient
        image: const DecorationImage(
          image: NetworkImage('data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mNkYPhfDwAChwGA60e6kgAAAABJRU5ErkJggg=='), // 1x1 transparent pixel as fallback
          fit: BoxFit.cover,
          repeat: ImageRepeat.repeat,
          opacity: 0.04,
          colorFilter: ColorFilter.mode(
            Colors.white,
            BlendMode.overlay,
          ),
          onError: _handleImageError,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: radius,
          // Fallback pattern using gradient for texture
          gradient: const RadialGradient(
            center: Alignment.center,
            radius: 0.1,
            colors: [
              Color.fromRGBO(255, 255, 255, 0.02),
              Colors.transparent,
            ],
            stops: [0.5, 1.0],
          ),
        ),
      ),
    );
  }
  
  static void _handleImageError(Object exception, StackTrace? stackTrace) {
    // Silently handle missing noise.png asset
  }
}
