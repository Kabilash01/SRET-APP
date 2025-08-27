import 'package:flutter/material.dart';
import '../theme/sret_theme.dart';
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
                    label: 'Today',
                    isSelected: selectedIndex == 0,
                    onTap: () => onChanged(0),
                  ),
                  _NavChip(
                    icon: Icons.access_time_rounded,
                    label: 'Timetable',
                    isSelected: selectedIndex == 1,
                    onTap: () => onChanged(1),
                  ),
                  _NavChip(
                    icon: Icons.calendar_today_rounded,
                    label: 'Calendar',
                    isSelected: selectedIndex == 2,
                    onTap: () => onChanged(2),
                  ),
                  _NavChip(
                    icon: Icons.inbox_rounded,
                    label: 'Inbox',
                    isSelected: selectedIndex == 3,
                    onTap: () => onChanged(3),
                  ),
                  _NavChip(
                    icon: Icons.business_rounded,
                    label: 'Dept',
                    isSelected: selectedIndex == 4,
                    onTap: () => onChanged(4),
                  ),
                ],
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
    final color = isSelected ? AppTheme.burgundy : AppTheme.burgundy.withOpacity(0.6);
    
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
                  ? AppTheme.burgundy.withOpacity(0.15) // Selected background
                  : Colors.transparent, // Unselected background
              border: isSelected 
                  ? Border.all(
                      color: AppTheme.burgundy.withOpacity(0.3),
                      width: 1.0,
                    )
                  : null,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  icon,
                  color: color,
                  size: 18,
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
