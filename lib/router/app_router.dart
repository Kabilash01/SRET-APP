import 'package:go_router/go_router.dart';
import '../pages/auth/sign_in_page.dart';
import '../pages/auth/reset_password_page.dart';
import '../pages/today_page.dart';

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
    ],
  );
}
