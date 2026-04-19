# 작업 내역 — 2026-04-19

## 1. HTML 화면 분석 및 문서화

### 작업 내용
- `example-view-html/` 내 전체 HTML 파일(22개 화면) 분석
- 각 화면의 구조·디자인·동작 상세 문서화
- `weddly/roles/view-analyze.md` 생성

### 분석 대상 화면
login, signup, find_id, reset_pw, wedding_date, main, schedule, guest, budget, memo, memo_write, roadmap, ceremony_order, vendor, community, settings, user, admin 등

### 주요 결정 사항 (사용자 답변 반영)
| 항목 | 결정 |
|------|------|
| 로드맵 데이터 | 메인 대시보드 타임라인과 공유, 기본 로드맵 존재 |
| 하단 네비게이션 | 홈/일정/웨딩관리(통합)/업체/설정 5탭 구조 추천 |
| user.html vs settings.html | user.html = 상단 프로필 버튼 → 개인 페이지 / settings.html = 설정 탭 → 앱 설정 |

---

## 2. Flutter 프로젝트 초기 구조 설정

### 생성 파일
```
weddly_frontend/lib/
├── core/
│   ├── theme/
│   │   ├── app_colors.dart       # 전체 컬러 상수
│   │   └── app_theme.dart        # ThemeData (AppBar, Input, Checkbox)
│   └── widgets/
│       ├── gradient_button.dart  # 골드 그라디언트 CTA 버튼
│       └── auth_input_field.dart # 공통 입력 필드 + PhoneInputFormatter
└── main.dart                     # WeddlyApp (LoginScreen 진입)
```

### 디자인 시스템
- **Primary**: `#D4A96A` (골드), `#C49050` (Dark Gold)
- **폰트**: Pretendard (번들)
- **Border Radius**: 12px
- **Horizontal Padding**: 28px

---

## 3. 인증 화면 4개 Flutter 구현

### 3-1. 로그인 화면 (`login_screen.dart`)
- weddly 이탤릭 골드 로고 + 서브텍스트 (중앙 정렬)
- 아이디/비밀번호 입력 + 비밀번호 보기/숨기기
- 로그인 유지 커스텀 체크박스
- 아이디 찾기 / 비밀번호 초기화 링크 (primary 골드 색상)
- GradientButton 로그인 버튼
- 소셜 로그인: Google / Kakao / Naver

### 3-2. 회원가입 화면 (`signup_screen.dart`)
- 3단계 스텝 바 (`_StepDot` + `_StepLine`)
- 아이디 중복 확인 버튼 (확인 시 초록 상태)
- 비밀번호 강도 바 (`TweenAnimationBuilder` 애니메이션)
- 신랑/신부 역할 카드 (`_RoleCard`, 선택 시 골드 그라디언트)
- 약관 동의 섹션 (전체 동의 토글, 필수/선택 구분, 모달 뷰어)

### 3-3. 아이디 찾기 화면 (`find_id_screen.dart`)
- 이름 + 이메일 입력
- `AnimatedCrossFade`로 폼 ↔ 결과 전환
- 결과: 마스킹된 아이디 + 가입일 표시

### 3-4. 비밀번호 초기화 화면 (`reset_pw_screen.dart`)
- 아이디 + 이메일 + 전화번호 입력 (PhoneInputFormatter 적용)
- `AnimatedCrossFade`로 폼 ↔ 결과 전환
- 결과: 마스킹된 이메일 + 임시 비밀번호 발송 안내

---

## 4. 로그인 화면 버그 수정 (1차)

| # | 문제 | 수정 |
|---|------|------|
| 1 | 로고/문구 좌측 정렬 | Column `crossAxisAlignment.stretch` + 로고 섹션 `center` |
| 2 | 아이디 찾기·비밀번호 초기화 링크 색상 없음 | `textLight` → `AppColors.primary` (골드) |
| 3 | 소셜 로그인 로고 부정확 | Google: `CustomPainter` 4색 링 / Kakao: `chat_bubble_rounded` 아이콘 |

---

## 5. 인증 화면 전체 개선 (5가지 이슈)

### 5-1. 로고 굵기
- `FontWeight.w800` → `FontWeight.w900`

### 5-2. 소셜 로그인 로고 교체
- `flutter_svg: ^2.0.16` 패키지 추가
- HTML 원본 SVG 경로 그대로 적용
  - **Google**: 4색 G 로고 (Red/Blue/Yellow/Green 4개 path)
  - **Kakao**: 말풍선 SVG (fill `#3C1E1E`, 노란 버튼 배경 위)
  - **Naver**: N 패스 SVG (fill `#FFFFFF`, 초록 버튼 배경 위)

### 5-3. AppBar 구조 변경 (아이디 찾기 / 비밀번호 초기화 / 회원가입)
- 기존: `weddly` 로고와 타이틀이 좌우 나열
- 변경: `weddly`(상) + 타이틀(하) Column 구조
- 공유 위젯 `WeddlyAuthAppBar` 생성 (`lib/core/widgets/weddly_app_bar.dart`)

### 5-4. 비밀번호 강도 바 항상 표시
- 기존: `if (_strength != _PwStrength.none)` 조건으로 숨김
- 변경: 항상 렌더링 (입력 전 = 빈 회색 바, 입력 후 = 색상 채워짐)

### 5-5. 저작권 Footer 위치 고정
- 공유 위젯 `WeddlyFooter` 생성 (`lib/core/widgets/weddly_footer.dart`)
- 모든 화면 구조 변경:
  ```
  Scaffold.body → Column(
    Expanded(SingleChildScrollView(...)),  // 스크롤 영역
    WeddlyFooter(),                        // 항상 최하단 고정
  )
  ```

---

## 6. Pretendard 폰트 적용

### 설치 방법
- GitHub Releases에서 v1.3.9 자동 다운로드 및 추출
- 경로: `weddly_frontend/assets/fonts/`

### 적용 파일
| 파일명 | Weight |
|--------|--------|
| Pretendard-Regular.ttf | 400 |
| Pretendard-Medium.ttf | 500 |
| Pretendard-SemiBold.ttf | 600 |
| Pretendard-Bold.ttf | 700 |
| Pretendard-ExtraBold.ttf | 800 |
| Pretendard-Black.ttf | 900 |

### 설정
- `pubspec.yaml` fonts 섹션 등록
- `app_theme.dart` → `fontFamily: 'Pretendard'` 전역 적용

---

## 7. 비밀번호 강도 바 UX 개선

### 요구사항
- 타이핑 전: 강도 바가 입력창 바로 아래에 붙어있음
- 타이핑 후: 입력창과 바 사이에 강도 설명 텍스트가 슬라이드인

### 구현 방식
- `AuthInputField` 제거 → `TextField` 직접 구성 (고정 18px 메시지 슬롯 제거)
- `AnimatedSize` (200ms, easeInOut) 로 레이블 영역 높이 애니메이션
  - 타이핑 전: `SizedBox.shrink()` (0 높이) → 바가 입력창에 근접
  - 타이핑 후: 강도 레이블 텍스트 슬라이드인

### 강도 레이블 내용
| 강도 | 텍스트 | 색상 |
|------|--------|------|
| 약함 | 약함 · 8자 이상, 영문+숫자+특수문자를 포함해주세요 | error (red) |
| 보통 | 보통 · 특수문자를 추가하면 더 안전합니다 | warning (orange) |
| 강함 | 강함 · 안전한 비밀번호입니다 | success (green) |

- 입력창과 강도 바 사이 `SizedBox(height: 6)` 으로 살짝 여백 유지

---

## 최종 파일 구조

```
weddly_frontend/
├── assets/
│   └── fonts/
│       ├── Pretendard-Regular.ttf
│       ├── Pretendard-Medium.ttf
│       ├── Pretendard-SemiBold.ttf
│       ├── Pretendard-Bold.ttf
│       ├── Pretendard-ExtraBold.ttf
│       └── Pretendard-Black.ttf
├── lib/
│   ├── core/
│   │   ├── theme/
│   │   │   ├── app_colors.dart
│   │   │   └── app_theme.dart
│   │   └── widgets/
│   │       ├── auth_input_field.dart
│   │       ├── gradient_button.dart
│   │       ├── weddly_app_bar.dart     ← 신규
│   │       └── weddly_footer.dart      ← 신규
│   ├── features/
│   │   └── auth/
│   │       └── screens/
│   │           ├── login_screen.dart
│   │           ├── signup_screen.dart
│   │           ├── find_id_screen.dart
│   │           └── reset_pw_screen.dart
│   └── main.dart
├── pubspec.yaml                         # flutter_svg, Pretendard 추가
└── analysis_options.yaml
```

---

## 사용 패키지 (추가분)

| 패키지 | 버전 | 용도 |
|--------|------|------|
| `flutter_svg` | ^2.0.16 | 소셜 로그인 SVG 로고 렌더링 |
| `Pretendard` (폰트) | v1.3.9 | 앱 전체 한글 폰트 |
