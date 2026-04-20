import 'package:flutter/material.dart';

extension WeddlyColors on BuildContext {
  bool get isDark => Theme.of(this).brightness == Brightness.dark;

  // -- Background
  Color get wBg         => isDark ? const Color(0xFF15120E) : const Color(0xFFF8F8F8);
  Color get wSurface    => isDark ? const Color(0xFF1E1A14) : Colors.white;
  Color get wSurfaceAlt => isDark ? const Color(0xFF1A1610) : const Color(0xFFFAFAFA);
  Color get wHeaderBg   => isDark ? const Color(0xF721180E) : const Color(0xF5FFFFFF);
  Color get wNavBg      => isDark ? const Color(0xF821180E) : const Color(0xF8FFFFFF);

  // -- Text
  Color get wTextPrimary   => isDark ? const Color(0xFFEDE8E0) : const Color(0xFF222222);
  Color get wTextSecondary => isDark ? const Color(0xFFC8C0B0) : const Color(0xFF555555);
  Color get wTextLight     => isDark ? const Color(0xFF7A7068) : const Color(0xFF888888);
  Color get wTextMuted     => isDark ? const Color(0xFF584E42) : const Color(0xFFBBBBBB);
  Color get wTextHint      => isDark ? const Color(0xFF7A6A58) : const Color(0xFFCCCCCC);

  // -- Border / Divider
  Color get wBorderLight => isDark ? const Color(0xFF2A2418) : const Color(0xFFF0F0F0);
  Color get wBorder      => isDark ? const Color(0xFF3A3028) : const Color(0xFFE8E8E8);

  // -- Input
  Color get wInputBg     => isDark ? const Color(0xFF1E1A14) : const Color(0xFFF8F8F8);

  // -- Icon button
  Color get wIconBtnBg    => isDark ? const Color(0xFF26201A) : const Color(0xFFF8F8F8);
  Color get wIconBtnColor => isDark ? const Color(0xFF9A9080) : const Color(0xFF888888);

  // -- Partner section
  Color get wPartnerBg     => isDark ? const Color(0xFF1E1A14) : const Color(0xFFFFFAF4);
  Color get wPartnerBorder => isDark ? const Color(0xFF2E2818) : const Color(0xFFF0E8D8);

  // -- Social Google
  Color get wGoogleBg     => isDark ? const Color(0xFF26201A) : Colors.white;
  Color get wGoogleBorder => isDark ? const Color(0xFF3A3028) : const Color(0xFFE0E0E0);
  Color get wGoogleText   => isDark ? const Color(0xFFC8C0B0) : const Color(0xFF444444);

  // -- Menu / card label
  Color get wMenuLabel      => isDark ? const Color(0xFF7A7068) : const Color(0xFF555555);
  Color get wMenuIconBg     => isDark ? const Color(0xFF1E1A14) : Colors.white;
  Color get wMenuIconBorder => isDark ? const Color(0xFF2E2818) : const Color(0xFFF0E8D8);

  // -- Community tag
  Color get wCmTagBg => isDark ? const Color(0xFF26190A) : const Color(0xFFFFF8EF);

  // -- Copyright
  Color get wCopyrightColor => isDark ? const Color(0xFF3A3028) : const Color(0xFFCCCCCC);

  // -- Modal
  Color get wModalBg           => isDark ? const Color(0xFF1E1A14) : Colors.white;
  Color get wModalCodeCard     => isDark ? const Color(0xFF231A0B) : const Color(0xFFFFFAF4);
  Color get wModalCodeBorder   => isDark ? const Color(0xFF3A2E18) : const Color(0xFFF0E8D8);
  Color get wModalActionBtnBg  => isDark ? const Color(0xFF2A2418) : Colors.white;
  Color get wModalConnectBg    => isDark ? const Color(0xFF181410) : const Color(0xFFFAFAFA);
  Color get wModalInputBg      => isDark ? const Color(0xFF221D16) : Colors.white;
  Color get wModalInputBorder  => isDark ? const Color(0xFF3A3028) : const Color(0xFFE8E8E8);
  Color get wModalInputText    => isDark ? const Color(0xFFEDE8E0) : const Color(0xFF222222);

  // -- Donut chart ring background
  Color get wDonutRingBg => isDark ? const Color(0xFF2E2818) : const Color(0xFFF2F2F2);
}
