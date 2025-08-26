import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import 'apple_liquid_glass.dart';

class LiquidPillNav extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onChanged;
  final VoidCallback? onSearchTap;

  const LiquidPillNav({
    super.key,
    required this.selectedIndex,
    required this.onChanged,
    this.onSearchTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Main navigation pill
        Expanded(
          child: AppleLiquidGlass(
            radius: const BorderRadius.all(Radius.circular(28)),
            blur: 24.0,
            child: Container(
              height: 56,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _NavChip(
                    icon: Icons.home_rounded,
                    label: 'Home',
                    isSelected: selectedIndex == 0,
                    onTap: () => onChanged(0),
                  ),
                  _NavChip(
                    icon: Icons.calendar_today_rounded,
                    label: 'Calendar',
                    isSelected: selectedIndex == 1,
                    onTap: () => onChanged(1),
                  ),
                  _NavChip(
                    icon: Icons.inbox_rounded,
                    label: 'Inbox',
                    isSelected: selectedIndex == 2,
                    onTap: () => onChanged(2),
                  ),
                ],
              ),
            ),
          ),
        ),
        
        const SizedBox(width: 10),
        
        // Search button
        AppleLiquidGlass(
          radius: const BorderRadius.all(Radius.circular(26)),
          blur: 24.0,
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onSearchTap,
              borderRadius: BorderRadius.circular(26),
              child: Container(
                width: 52,
                height: 52,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.search_rounded,
                  color: AppTheme.sretText,
                  size: 24,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _NavChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _NavChip({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = isSelected ? AppTheme.sretPrimary : AppTheme.sretText;
    
    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: isSelected 
                  ? const Color(0x38FFFFFF) // white 22%
                  : const Color(0x1FFFFFFF), // white 12%
              border: Border.all(
                color: isSelected 
                    ? const Color(0x52FFFFFF) // white 32%
                    : const Color(0x2EFFFFFF), // white 18%
                width: 1.0,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  icon,
                  color: color,
                  size: 20,
                ),
                const SizedBox(height: 2),
                Text(
                  label,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: color,
                    fontWeight: FontWeight.w500,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
