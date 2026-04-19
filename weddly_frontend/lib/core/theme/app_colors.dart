import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // ── Primary (골드)
  static const Color primary      = Color(0xFFD4A96A);
  static const Color primaryDark  = Color(0xFFC49050);
  static const Color primaryLight = Color(0xFFE8C07A);

  // ── Neutral
  static const Color white           = Color(0xFFFFFFFF);
  static const Color background      = Color(0xFFF8F8F8);
  static const Color backgroundAlt   = Color(0xFFFAFAFA);
  static const Color border          = Color(0xFFE8E8E8);
  static const Color borderLight     = Color(0xFFF0F0F0);
  static const Color textDark        = Color(0xFF222222);
  static const Color textMedium      = Color(0xFF555555);
  static const Color textLight       = Color(0xFF888888);
  static const Color textPlaceholder = Color(0xFFCCCCCC);
  static const Color textMuted       = Color(0xFFBBBBBB);

  // ── Semantic
  static const Color success = Color(0xFF4CAF50);
  static const Color error   = Color(0xFFF44336);
  static const Color warning = Color(0xFFFF9800);
  static const Color info    = Color(0xFF2196F3);

  // ── Social
  static const Color kakao     = Color(0xFFFEE500);
  static const Color kakaoText = Color(0xFF3C1E1E);
  static const Color naver     = Color(0xFF03C75A);

  // ── Hero 다크 그라디언트
  static const List<Color> heroGradient = [
    Color(0xFF18110A),
    Color(0xFF33210A),
    Color(0xFFA8721E),
  ];

  // ── Primary 그라디언트
  static const List<Color> primaryGradient = [
    Color(0xFFD4A96A),
    Color(0xFFC49050),
  ];
}
