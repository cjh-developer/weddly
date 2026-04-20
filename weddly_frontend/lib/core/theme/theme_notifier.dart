import 'package:flutter/material.dart';

/// App-wide dark mode state management
final themeNotifier = _ThemeNotifier();

class _ThemeNotifier extends ValueNotifier<ThemeMode> {
  _ThemeNotifier() : super(ThemeMode.light);

  bool get isDark => value == ThemeMode.dark;

  void toggle() {
    value = isDark ? ThemeMode.light : ThemeMode.dark;
  }
}
