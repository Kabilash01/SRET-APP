import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'core/auth/auth_controller.dart';
import 'features/splash/splash_page.dart';
import 'features/auth/login_page_fixed.dart';
import 'features/auth/forgot_password_page_sret.dart';
import 'features/auth/google_signin_page.dart';
import 'features/auth/signup_page_new.dart';
import 'features/shell/app_shell.dart';
import 'features/today/today_page.dart';
import 'features/navigation/placeholder_pages.dart' as nav;

final appRouterProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authControllerProvider);
  
  return GoRouter(
    initialLocation: '/splash',
    redirect: (context, state) {
      final isSignedIn = authState.value != null && !authState.isLoading;
      final isOnSplash = state.matchedLocation == '/splash';
      final isOnAuthRoute = state.matchedLocation == '/login' || 
                           state.matchedLocation == '/forgot-password' ||
                           state.matchedLocation == '/signin' || 
                           state.matchedLocation == '/signup';
      
      // Debug logging
      print('Router redirect - isSignedIn: $isSignedIn, location: ${state.matchedLocation}, isLoading: ${authState.isLoading}');
      
      // If signed in and on auth/splash route, redirect to today
      if (isSignedIn && (isOnAuthRoute || isOnSplash)) {
        print('Redirecting to /today');
        return '/today';
      }
      
      // If not signed in and not on auth/splash route, redirect to login
      if (!isSignedIn && !isOnAuthRoute && !isOnSplash) {
        return '/login';
      }
      
      return null;
    },
    routes: [
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashPage(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginPageFixed(),
      ),
      GoRoute(
        path: '/forgot-password',
        builder: (context, state) => const ForgotPasswordPageSret(),
      ),
      GoRoute(
        path: '/signin',
        builder: (context, state) => const GoogleSignInPage(),
      ),
      GoRoute(
        path: '/signup',
        builder: (context, state) => const SignUpPage(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) => AppShell(child: navigationShell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/today',
                name: 'today',
                builder: (context, state) => const TodayPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/timetable',
                name: 'timetable',
                builder: (context, state) => const nav.TimetablePage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/inbox',
                name: 'inbox',
                builder: (context, state) => const nav.InboxPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/dept',
                name: 'dept',
                builder: (context, state) => const nav.DeptPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/profile',
                name: 'profile',
                builder: (context, state) => const nav.ProfilePage(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
});
