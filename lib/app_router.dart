import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'core/auth/auth_controller.dart';
import 'features/splash/splash_page.dart';
import 'features/auth/login_page.dart';
import 'features/auth/forgot_password_page.dart';
import 'features/auth/google_signin_page.dart';
import 'features/auth/signup_page.dart';
import 'features/home/home_page.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authControllerProvider);
  
  return GoRouter(
    initialLocation: '/splash',
    redirect: (context, state) {
      final isSignedIn = authState.value != null;
      final isOnSplash = state.matchedLocation == '/splash';
      final isOnAuthRoute = state.matchedLocation == '/login' || 
                           state.matchedLocation == '/forgot' ||
                           state.matchedLocation == '/signin' || 
                           state.matchedLocation == '/signup';
      
      // If signed in and on auth/splash route, redirect to home
      if (isSignedIn && (isOnAuthRoute || isOnSplash)) {
        return '/home';
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
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: '/forgot',
        builder: (context, state) => const ForgotPasswordPage(),
      ),
      GoRoute(
        path: '/signin',
        builder: (context, state) => const GoogleSignInPage(),
      ),
      GoRoute(
        path: '/signup',
        builder: (context, state) => const SignUpPage(),
      ),
      GoRoute(
        path: '/home',
        builder: (context, state) => const HomePage(),
      ),
    ],
  );
});
