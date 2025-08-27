import 'dart:ui';
import 'package:flutter/material.dart';
import '../../theme/ambient_tokens.dart';

class AmbientBackground extends StatelessWidget {
  final ImageProvider? illustration;
  final double illustrationOpacity;

  const AmbientBackground({
    super.key,
    this.illustration,
    this.illustrationOpacity = 0.40,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      color: isDark ? AmbientTokens.kDark0 : AmbientTokens.kBaseWarm,
    );
  }
}