import 'package:flutter/material.dart';
import 'liquid_glass.dart';
import '../theme/sret_theme.dart';

class ScheduleTile extends StatelessWidget {
  final String time;
  final String title;
  final String subtitle;
  final Color? accentColor;
  final VoidCallback? onTap;

  const ScheduleTile({
    super.key,
    required this.time,
    required this.title,
    required this.subtitle,
    this.accentColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final accent = accentColor ?? AppTheme.burgundy;

    return GestureDetector(
      onTap: onTap,
      child: LiquidGlass.card(
        child: IntrinsicHeight(
          child: Row(
            children: [
              // Left accent bar
              Container(
                width: 6,
                decoration: BoxDecoration(
                  color: accent,
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
              const SizedBox(width: 16),
              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      time,
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              // Trailing icon
              IconButton(
                icon: const Icon(Icons.more_horiz),
                color: AppTheme.textSecondary,
                onPressed: onTap,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
