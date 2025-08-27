import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import 'apple_liquid_glass.dart';

class LiquidPillNav extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onChanged;

  const LiquidPillNav({
    super.key,
    required this.selectedIndex,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return AppleLiquidGlass(
      radius: const BorderRadius.all(Radius.circular(32)),
      child: Container(
        height: 64,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
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
              icon: Icons.schedule_rounded,
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
              label: 'Department',
              isSelected: selectedIndex == 4,
              onTap: () => onChanged(4),
            ),
          ],
        ),
      ),
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
          borderRadius: BorderRadius.circular(18),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 2),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              color: isSelected 
                  ? const Color(0x38FFFFFF) // white 22%
                  : Colors.transparent,
              border: isSelected ? Border.all(
                color: const Color(0x52FFFFFF), // white 32%
                width: 1.0,
              ) : null,
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
                    fontSize: 8,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
