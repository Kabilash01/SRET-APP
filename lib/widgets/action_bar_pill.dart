import 'package:flutter/material.dart';
import '../widgets/liquid_glass.dart';
import '../theme/sret_theme.dart';

class ActionBarPill extends StatelessWidget {
  final VoidCallback? onBackPressed;
  final VoidCallback? onMorePressed;
  final VoidCallback? onRefreshPressed;

  const ActionBarPill({
    super.key,
    this.onBackPressed,
    this.onMorePressed,
    this.onRefreshPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        // Back button
        LiquidGlass.circle(
          size: 44,
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onBackPressed,
              borderRadius: BorderRadius.circular(22),
              child: Container(
                width: 44,
                height: 44,
                alignment: Alignment.center,
                child: Icon(
                  Icons.arrow_back,
                  size: 20,
                  color: AppTheme.burgundy,
                ),
              ),
            ),
          ),
        ),
        
        const SizedBox(width: 10),
        
        // Center pill with icon, text, and refresh
        Expanded(
          child: LiquidGlass.pill(
            height: 48,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.palette,
                    size: 18,
                    color: AppTheme.burgundy,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'floralarrangem…',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppTheme.textPrimary,
                        fontWeight: FontWeight.w500,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  InkWell(
                    onTap: onRefreshPressed,
                    borderRadius: BorderRadius.circular(12),
                    child: Padding(
                      padding: const EdgeInsets.all(4),
                      child: Icon(
                        Icons.refresh,
                        size: 18,
                        color: AppTheme.burgundy,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        
        const SizedBox(width: 10),
        
        // More button
        LiquidGlass.circle(
          size: 44,
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onMorePressed,
              borderRadius: BorderRadius.circular(22),
              child: Container(
                width: 44,
                height: 44,
                alignment: Alignment.center,
                child: Icon(
                  Icons.more_horiz,
                  size: 20,
                  color: AppTheme.burgundy,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
