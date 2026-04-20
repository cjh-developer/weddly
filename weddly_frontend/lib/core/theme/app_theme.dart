import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get light => _build(Brightness.light);
  static ThemeData get dark  => _build(Brightness.dark);

  static ThemeData _build(Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      fontFamily: 'Pretendard',
      scaffoldBackgroundColor: isDark ? const Color(0xFF15120E) : AppColors.white,
      colorScheme: ColorScheme.fromSeed(
        brightness: brightness,
        seedColor: AppColors.primary,
        primary: AppColors.primary,
        error: AppColors.error,
        surface: isDark ? const Color(0xFF1E1A14) : AppColors.white,
        onSurface: isDark ? const Color(0xFFEDE8E0) : AppColors.textDark,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: isDark ? const Color(0xFF1E1A14) : AppColors.white,
        foregroundColor: isDark ? const Color(0xFFEDE8E0) : AppColors.textDark,
        elevation: 0,
        scrolledUnderElevation: 0,
        titleTextStyle: TextStyle(
          color: isDark ? const Color(0xFFEDE8E0) : AppColors.textDark,
          fontSize: 16,
          fontWeight: FontWeight.w700,
          fontFamily: 'Pretendard',
        ),
        iconTheme: IconThemeData(
          color: isDark ? const Color(0xFFEDE8E0) : AppColors.textDark,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: isDark ? const Color(0xFF1E1A14) : AppColors.background,
        hintStyle: TextStyle(
          color: isDark ? const Color(0xFF483E32) : AppColors.textPlaceholder,
          fontSize: 14,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: isDark ? const Color(0xFF3A3028) : AppColors.border,
            width: 1.5,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: isDark ? const Color(0xFF3A3028) : AppColors.border,
            width: 1.5,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.error, width: 1.5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.error, width: 1.5),
        ),
      ),
      textTheme: TextTheme(
        bodyLarge: TextStyle(
          color: isDark ? const Color(0xFFEDE8E0) : AppColors.textDark,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        bodyMedium: TextStyle(
          color: isDark ? const Color(0xFFC8C0B0) : AppColors.textMedium,
          fontSize: 13,
          fontWeight: FontWeight.w500,
        ),
        bodySmall: TextStyle(
          color: isDark ? const Color(0xFF7A7068) : AppColors.textLight,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return AppColors.primary;
          return isDark ? const Color(0xFF2A2418) : AppColors.white;
        }),
        checkColor: WidgetStateProperty.all(AppColors.white),
        side: BorderSide(
          color: isDark ? const Color(0xFF3A3028) : const Color(0xFFDDDDDD),
          width: 2,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      ),
    );
  }
}
