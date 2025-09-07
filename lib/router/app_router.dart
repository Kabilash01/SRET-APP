import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import '../pages/auth/sign_in_page.dart';
import '../pages/auth/reset_password_page.dart';
import '../pages/today_page.dart';
import '../pages/profile_page.dart';
import '../features/hod/pages/hod_dashboard_page.dart';
import '../widgets/glass_pill_nav.dart';
import '../theme/app_theme.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/signin',
    routes: [
      // Authentication Routes
      GoRoute(
        path: '/signin',
        builder: (context, state) => const SignInPage(),
      ),
      GoRoute(
        path: '/auth/reset-password',
        name: 'resetPassword',
        builder: (context, state) => const ResetPasswordPage(),
      ),
      
      // Main App Routes
      GoRoute(
        path: '/today',
        builder: (context, state) => const TodayPage(),
      ),
      GoRoute(
        path: '/profile',
        builder: (context, state) => const ProfilePage(),
      ),
      GoRoute(
        path: '/dept',
        builder: (context, state) => const HodDashboardPage(),
      ),
      // Placeholder routes for remaining navigation items
      GoRoute(
        path: '/timetable',
        builder: (context, state) => const _PlaceholderPage(title: 'Timetable', index: 1),
      ),
      GoRoute(
        path: '/calendar',
        builder: (context, state) => const _PlaceholderPage(title: 'Calendar', index: 2),
      ),
      GoRoute(
        path: '/inbox',
        builder: (context, state) => const _PlaceholderPage(title: 'Inbox', index: 3),
      ),
    ],
  );
}

class _PlaceholderPage extends StatefulWidget {
  final String title;
  final int index;
  
  const _PlaceholderPage({required this.title, required this.index});

  @override
  State<_PlaceholderPage> createState() => _PlaceholderPageState();
}

class _PlaceholderPageState extends State<_PlaceholderPage> with GlassPillNavMixin {
  @override
  int get selectedNavIndex => widget.index;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      extendBody: true,
      body: Stack(
        children: [
          SafeArea(
            child: Padding(
              padding: EdgeInsets.only(bottom: glassPillBottomPadding),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.construction,
                      size: 64,
                      color: AppColors.primary,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      '${widget.title} Page',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Coming soon!',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          
          // Glass Pill Navigation
          GlassPillNav(
            selectedIndex: selectedNavIndex,
            onItemTapped: handleNavTap,
            items: GlassPillNavMixin.navItems,
          ),
        ],
      ),
    );
  }
}
