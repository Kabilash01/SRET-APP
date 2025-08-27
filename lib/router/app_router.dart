import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../widgets/app_scaffold.dart';
import '../pages/splash_page.dart';
import '../pages/signin_page.dart';
import '../pages/reset_password_page.dart';
import '../pages/today_page.dart';
import '../pages/timetable_page.dart';
import '../pages/calendar_page.dart';
import '../pages/inbox_page.dart';
import '../pages/dept_page.dart';
import '../pages/profile_page.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/splash',
    routes: [
      // Authentication Routes
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashPage(),
      ),
      GoRoute(
        path: '/signin',
        builder: (context, state) => const SignInPage(),
      ),
      GoRoute(
        path: '/reset-password',
        builder: (context, state) => const ResetPasswordPage(),
      ),
      
      // Main App Routes
      GoRoute(
        path: '/today',
        builder: (context, state) => const AppScaffold(
          currentIndex: 0,
          body: TodayPage(),
        ),
      ),
      GoRoute(
        path: '/timetable',
        builder: (context, state) => const AppScaffold(
          currentIndex: 1,
          title: 'Timetable',
          body: TimetablePage(),
        ),
      ),
      GoRoute(
        path: '/calendar',
        builder: (context, state) => const AppScaffold(
          currentIndex: 2,
          title: 'Calendar',
          body: CalendarPage(),
        ),
      ),
      GoRoute(
        path: '/inbox',
        builder: (context, state) => const AppScaffold(
          currentIndex: 3,
          title: 'Inbox',
          body: InboxPage(),
        ),
      ),
      GoRoute(
        path: '/dept',
        builder: (context, state) => const AppScaffold(
          currentIndex: 4,
          title: 'Department',
          body: DeptPage(),
        ),
      ),
      GoRoute(
        path: '/profile',
        builder: (context, state) => AppScaffold(
          currentIndex: kShowDept ? 4 : 3,
          title: 'Profile',
          body: const ProfilePage(),
        ),
      ),
    ],
  );
}
