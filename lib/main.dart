import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'router/app_router.dart';

void main() {
  runApp(const SretApp());
}

class SretApp extends StatelessWidget {
  const SretApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'SRET Faculty Portal',
      theme: AppTheme.light,
      routerConfig: AppRouter.router,
    );
  }
}
