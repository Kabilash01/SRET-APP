import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:go_router/go_router.dart';
import '../theme/app_theme.dart';

/// Apple-style frosted glass pill navigation overlay
class GlassPillNav extends StatefulWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;
  final List<NavItem> items;

  const GlassPillNav({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
    required this.items,
  });

  @override
  State<GlassPillNav> createState() => _GlassPillNavState();
}

class _GlassPillNavState extends State<GlassPillNav>
    with TickerProviderStateMixin {
  late AnimationController _selectionController;
  late Animation<double> _selectionAnimation;

  @override
  void initState() {
    super.initState();
    _selectionController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _selectionAnimation = CurvedAnimation(
      parent: _selectionController,
      curve: Curves.easeOut,
    );
  }

  @override
  void didUpdateWidget(GlassPillNav oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedIndex != widget.selectedIndex) {
      _selectionController.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _selectionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final mediaQuery = MediaQuery.of(context);
    
    // Calculate position to avoid keyboard overlap
    final keyboardHeight = mediaQuery.viewInsets.bottom;
    final safeAreaBottom = mediaQuery.padding.bottom;
    
    // Hide or adjust position when keyboard is open
    if (keyboardHeight > 0) {
      return const SizedBox.shrink();
    }

    return Positioned(
      left: 16,
      right: 16,
      bottom: safeAreaBottom + 12,
      child: _buildGlassPill(context, colorScheme),
    );
  }

  Widget _buildGlassPill(BuildContext context, ColorScheme colorScheme) {
    return Container(
      // Micro vignette background for depth
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        gradient: RadialGradient(
          radius: 1.2,
          colors: [
            Colors.transparent,
            AppColors.primary.withValues(alpha: 0.02), // Very subtle vignette
          ],
        ),
      ),
      padding: const EdgeInsets.all(2), // Space for vignette
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            height: 60,
            decoration: _buildGlassDecoration(colorScheme),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: widget.items.asMap().entries.map((entry) {
                final index = entry.key;
                final item = entry.value;
                return _buildNavItem(
                  context,
                  item,
                  index == widget.selectedIndex,
                  index,
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }

  BoxDecoration _buildGlassDecoration(ColorScheme colorScheme) {
    return BoxDecoration(
      // Glass fill with burgundy tint
      color: colorScheme.surface.withValues(alpha: 0.38), // ~38% opacity surface
      border: Border.all(
        color: Colors.white.withValues(alpha: 0.25), // 25% white border
        width: 1,
      ),
      borderRadius: BorderRadius.circular(30),
      boxShadow: [
        // Soft burgundy-tinted shadow
        BoxShadow(
          color: AppColors.primary.withValues(alpha: 0.08),
          blurRadius: 16,
          offset: const Offset(0, 6),
        ),
      ],
      // Optional inner highlight gradient for "wet glass" effect
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Colors.white.withValues(alpha: 0.12), // 12% highlight at top
          Colors.white.withValues(alpha: 0.04), // 4% highlight at bottom
        ],
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context,
    NavItem item,
    bool isActive,
    int index,
  ) {
    final theme = Theme.of(context);
    
    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => widget.onItemTapped(index),
          borderRadius: BorderRadius.circular(20),
          child: AnimatedBuilder(
            animation: _selectionAnimation,
            builder: (context, child) {
              final animationValue = isActive ? _selectionAnimation.value : 0.0;
              final scale = 1.0 + (animationValue * 0.1); // Subtle lift effect
              
              return Transform.scale(
                scale: scale,
                child: Container(
                  height: 60,
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        item.icon,
                        size: 20,
                        color: _getItemColor(context, isActive),
                        semanticLabel: '${item.label} tab${isActive ? ', selected' : ''}',
                      ),
                      const SizedBox(height: 2),
                      Text(
                        item.label,
                        style: theme.textTheme.bodySmall?.copyWith(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: _getItemColor(context, isActive),
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Color _getItemColor(BuildContext context, bool isActive) {
    if (isActive) {
      return AppColors.primary; // Active items in burgundy
    } else {
      return AppColors.primary.withValues(alpha: 0.7); // Inactive at 70% opacity
    }
  }
}

/// Navigation item data class
class NavItem {
  final IconData icon;
  final String label;
  final String route;

  const NavItem({
    required this.icon,
    required this.label,
    required this.route,
  });
}

/// Mixin to provide consistent glass pill navigation behavior
mixin GlassPillNavMixin<T extends StatefulWidget> on State<T> {
  int get selectedNavIndex;
  
  static const List<NavItem> navItems = [
    NavItem(icon: Icons.home, label: 'Today', route: '/today'),
    NavItem(icon: Icons.access_time, label: 'Timetable', route: '/timetable'),
    NavItem(icon: Icons.calendar_month, label: 'Calendar', route: '/calendar'),
    NavItem(icon: Icons.dashboard, label: 'Dept', route: '/dept'),
    NavItem(icon: Icons.person, label: 'Profile', route: '/profile'),
  ];

  void handleNavTap(int index) {
    if (index == selectedNavIndex) return;
    
    final item = navItems[index];
    _navigateToRoute(item.route);
  }

  void _navigateToRoute(String route) {
    // Use go_router for navigation
    if (mounted) {
      context.go(route);
    }
  }

  void _showNavigationFeedback(String section) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$section feature coming soon!'),
        duration: const Duration(seconds: 1),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.only(bottom: 80, left: 16, right: 16),
      ),
    );
  }

  /// Calculate bottom padding needed for content to avoid pill overlap
  double get glassPillBottomPadding {
    final mediaQuery = MediaQuery.of(context);
    return 60 + // pill height
           24 + // spacing above pill
           mediaQuery.padding.bottom; // safe area
  }
}
