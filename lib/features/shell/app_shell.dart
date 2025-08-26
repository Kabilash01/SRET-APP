import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/schedule/schedule_providers.dart';
import '../../theme/app_theme.dart';

class AppShell extends ConsumerStatefulWidget {
  final StatefulNavigationShell child;

  const AppShell({
    super.key,
    required this.child,
  });

  @override
  ConsumerState<AppShell> createState() => _AppShellState();
}

class _AppShellState extends ConsumerState<AppShell> {
  void _onDestinationSelected(int index) {
    widget.child.goBranch(index);
  }

  @override
  Widget build(BuildContext context) {
    final canAccessDept = ref.watch(canAccessDepartmentProvider);

    // Build navigation destinations
    final destinations = <NavigationDestination>[
      const NavigationDestination(
        icon: Icon(Icons.today_outlined),
        selectedIcon: Icon(Icons.today),
        label: 'Today',
      ),
      const NavigationDestination(
        icon: Icon(Icons.schedule_outlined),
        selectedIcon: Icon(Icons.schedule),
        label: 'Timetable',
      ),
      const NavigationDestination(
        icon: Icon(Icons.inbox_outlined),
        selectedIcon: Icon(Icons.inbox),
        label: 'Inbox',
      ),
    ];

    // Add Dept tab only for authorized roles
    if (canAccessDept) {
      destinations.add(
        const NavigationDestination(
          icon: Icon(Icons.domain_outlined),
          selectedIcon: Icon(Icons.domain),
          label: 'Dept',
        ),
      );
    }

    // Always add Profile tab
    destinations.add(
      const NavigationDestination(
        icon: Icon(Icons.person_outline),
        selectedIcon: Icon(Icons.person),
        label: 'Profile',
      ),
    );

    return Scaffold(
      backgroundColor: AppTheme.sretBg,
      body: widget.child,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppTheme.sretSurface.withValues(alpha: 0.95),
          border: Border(
            top: BorderSide(
              color: AppTheme.sretDivider,
              width: 0.5,
            ),
          ),
          boxShadow: [
            BoxShadow(
              color: AppTheme.sretPrimary.withValues(alpha: 0.08),
              blurRadius: 8,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: NavigationBar(
            selectedIndex: widget.child.currentIndex,
            onDestinationSelected: _onDestinationSelected,
            backgroundColor: Colors.transparent,
            elevation: 0,
            surfaceTintColor: Colors.transparent,
            indicatorColor: AppTheme.sretPrimary.withValues(alpha: 0.12),
            destinations: destinations,
            labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
          ),
        ),
      ),
    );
  }
}

/// Frosted glass effect widget for surfaces
class FrostedGlass extends StatelessWidget {
  final Widget child;
  final BorderRadius? borderRadius;
  final double opacity;
  final double blurSigma;
  final Color? color;

  const FrostedGlass({
    super.key,
    required this.child,
    this.borderRadius,
    this.opacity = 0.9,
    this.blurSigma = 10.0,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: (color ?? AppTheme.sretSurface).withValues(alpha: opacity),
        borderRadius: borderRadius ?? BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.sretDivider.withValues(alpha: 0.5),
          width: 0.5,
        ),
        boxShadow: [
          BoxShadow(
            color: AppTheme.sretPrimary.withValues(alpha: 0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: borderRadius ?? BorderRadius.circular(12),
        child: child,
      ),
    );
  }
}
