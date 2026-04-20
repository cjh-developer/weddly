# Weddly Frontend - Project Memory

## Tech Stack
- Flutter (Dart), Material 3
- Font: Pretendard
- State management: ValueNotifier (lightweight, no external packages)

## Project Structure
- `lib/core/theme/` - AppColors, AppTheme (light/dark), ThemeNotifier, WeddlyColors extension
- `lib/core/widgets/` - Shared widgets (AuthInputField, GradientButton, WeddlyAppBar, WeddlyFooter)
- `lib/features/auth/screens/` - Login, Signup, FindId, ResetPw screens
- `lib/features/home/screens/` - MainScreen (dashboard with sub-widgets)

## Dark Mode Architecture (implemented 2026-04-20)
- `ThemeNotifier` (ValueNotifier<ThemeMode>) for global toggle
- `WeddlyColors` BuildContext extension for per-widget dark/light color access
- AppTheme._build(Brightness) generates both light and dark ThemeData
- Dark mode toggle in MainScreen header via `_IconBtn.onTap -> themeNotifier.toggle()`
- DonutPainter receives `bgColor` parameter from `_StatHalf` to support dark mode

## Key Patterns
- Colors accessed via `context.wSurface`, `context.wTextPrimary`, etc.
- Brand colors (Kakao yellow, Naver green) stay constant across themes
- Primary gold (#D4A96A) is identical in both themes
- `const` keyword removed from widgets using context-dependent colors (info-level lint, acceptable)

## User Preferences
- Korean language for code comments and UI
- Response language matches user input language
