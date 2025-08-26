import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../theme/app_theme.dart';

class AppShell extends ConsumerStatefulWidget {
  final StatefulNavigationShell child;

  const AppShell({
    super.key,
    required this.child,
  });

  @override
  ConsumerState<AppShell> createState() => _AppShellState();
}

class _AppShellState extends ConsumerState<AppShell> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: widget.child,
    );
  }
}

/// Frosted glass effect widget for surfaces
class FrostedGlass extends StatelessWidget {
  final Widget child;
  final BorderRadius? borderRadius;
  final double opacity;
  final double blurSigma;
  final Color? color;

  const FrostedGlass({
    super.key,
    required this.child,
    this.borderRadius,
    this.opacity = 0.9,
    this.blurSigma = 10.0,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: (color ?? AppTheme.sretSurface).withValues(alpha: opacity),
        borderRadius: borderRadius ?? BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.sretDivider.withValues(alpha: 0.5),
          width: 0.5,
        ),
        boxShadow: [
          BoxShadow(
            color: AppTheme.sretPrimary.withValues(alpha: 0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: borderRadius ?? BorderRadius.circular(12),
        child: child,
      ),
    );
  }
}
