import 'package:flutter/material.dart';
import '../theme/sret_theme.dart';
import 'liquid_glass.dart';

class ScheduleTile extends StatelessWidget {
  final String time;
  final String title;
  final String subtitle;
  final Color color;

  const ScheduleTile({
    super.key,
    required this.time,
    required this.title,
    required this.subtitle,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return LiquidGlass.card(
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            // Time column
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  time,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimary,
                  ),
                ),
              ],
            ),
            const SizedBox(width: 16),
            // Vertical color bar
            Container(
              width: 6,
              height: 40,
              decoration: BoxDecoration(
                color: color,
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
                    title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            // Trailing button
            LiquidGlass.circle(
              size: 32,
              child: Icon(
                Icons.more_horiz,
                size: 16,
                color: AppTheme.burgundy,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
