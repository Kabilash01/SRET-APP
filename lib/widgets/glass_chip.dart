import 'package:flutter/material.dart';
import '../theme/sret_theme.dart';

class GlassChip extends StatelessWidget {
  final String text;
  final double radius;
  final Color? textColor;
  final Color? backgroundColor;

  const GlassChip({
    super.key,
    required this.text,
    this.radius = 12.0,
    this.textColor,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: backgroundColor ?? Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(
          color: Colors.white.withOpacity(0.3),
          width: 0.5,
        ),
      ),
      child: Text(
        text,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: textColor ?? AppTheme.burgundy,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
