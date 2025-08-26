import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import 'apple_liquid_glass.dart';

class GlassChip extends StatelessWidget {
  final String text;
  final TextStyle? textStyle;
  final EdgeInsetsGeometry? padding;
  final double radius;
  final double blur;

  const GlassChip({
    super.key,
    required this.text,
    this.textStyle,
    this.padding,
    this.radius = 16.0,
    this.blur = 20.0,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveTextStyle = textStyle ?? 
        Theme.of(context).textTheme.labelSmall?.copyWith(
          color: AppTheme.sretText,
          fontWeight: FontWeight.w500,
        );

    final effectivePadding = padding ?? 
        const EdgeInsets.symmetric(horizontal: 10, vertical: 6);

    return AppleLiquidGlass(
      radius: BorderRadius.circular(radius),
      blur: blur,
      // Subtle animation for chips
      period: const Duration(seconds: 9),
      sheen: 0.06,
      grain: 0.03,
      child: Container(
        padding: effectivePadding,
        child: Text(
          text,
          style: effectiveTextStyle,
        ),
      ),
    );
  }
}
