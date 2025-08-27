import 'package:flutter/material.dart';
import '../widgets/liquid_glass.dart';
import '../theme/sret_theme.dart';

class QuickScheduleTile extends StatelessWidget {
  final String time;
  final String title;
  final String subtitle;
  final Color barColor;
  final VoidCallback? onTap;

  const QuickScheduleTile({
    super.key,
    required this.time,
    required this.title,
    required this.subtitle,
    required this.barColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: LiquidGlass.card(
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(24),
            child: Container(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  // Left vertical bar
                  Container(
                    width: 6,
                    height: 48,
                    decoration: BoxDecoration(
                      color: barColor,
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
                          style: Theme.of(context).textTheme.labelMedium?.copyWith(
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          title,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: AppTheme.burgundy,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          subtitle,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppTheme.burgundy.withOpacity(0.6),
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // Trailing more button
                  LiquidGlass.circle(
                    size: 32,
                    child: Container(
                      alignment: Alignment.center,
                      child: Icon(
                        Icons.more_horiz,
                        size: 16,
                        color: AppTheme.burgundy.withOpacity(0.7),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
