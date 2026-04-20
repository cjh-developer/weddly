import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_notifier.dart';
import 'features/auth/screens/login_screen.dart';
import 'features/home/screens/main_screen.dart';

void main() {
  runApp(const WeddlyApp());
}

class WeddlyApp extends StatelessWidget {
  const WeddlyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (_, mode, __) => MaterialApp(
        title: 'Weddly',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        themeMode: mode,
        home: const MainScreen(),
        routes: {
          '/login': (ctx) => const LoginScreen(),
          '/main': (ctx) => const MainScreen(),
        },
      ),
    );
  }
}
