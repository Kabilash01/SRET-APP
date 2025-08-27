import 'package:flutter/material.dart';
import '../widgets/liquid_glass.dart';
import '../theme/sret_theme.dart';

class BottomNavCapsule extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onItemSelected;

  const BottomNavCapsule({
    super.key,
    required this.selectedIndex,
    required this.onItemSelected,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: LiquidGlass.pill(
        height: 64,
        child: Container(
          width: screenWidth - 32,
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildNavItem(0, Icons.home, 'Today'),
              _buildNavItem(1, Icons.access_time, 'Timetable'),
              _buildNavItem(2, Icons.calendar_today, 'Calendar'),
              _buildNavItem(3, Icons.inbox, 'Inbox'),
              _buildNavItem(4, Icons.business, 'Dept'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    final isSelected = selectedIndex == index;
    
    return Expanded(
      child: GestureDetector(
        onTap: () => onItemSelected(index),
        child: Container(
          height: 48,
          decoration: isSelected
              ? BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0x29FFFFFF), // white 16%
                      Color(0x0FFFFFFF), // white 6%
                    ],
                  ),
                  border: Border.all(
                    color: const Color(0x996B1020), // burgundy 60%
                    width: 1.5,
                  ),
                  color: const Color(0x0F6B1020), // burgundy 6% tint
                )
              : null,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 20,
                color: isSelected 
                    ? AppTheme.burgundy 
                    : AppTheme.burgundy.withOpacity(0.7),
              ),
              const SizedBox(height: 2),
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: isSelected 
                      ? AppTheme.burgundy 
                      : AppTheme.burgundy.withOpacity(0.7),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
