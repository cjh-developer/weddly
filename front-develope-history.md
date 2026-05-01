# Weddly Frontend 개발 이력

> 기준일: 2026-05-02
> 프레임워크: Flutter (Dart)
> 프로젝트 경로: `D:\workspace\weddly\weddly_frontend`

---

## 전체 구조

```
lib/
├── main.dart                          # 앱 진입점 (한국어 로케일, 테마)
├── core/
│   ├── theme/
│   │   ├── app_colors.dart            # 색상 상수 (primary gold gradient 등)
│   │   ├── app_theme.dart             # Light / Dark 테마 정의
│   │   ├── theme_notifier.dart        # ValueNotifier<ThemeMode> (다크모드 토글)
│   │   └── weddly_colors.dart         # BuildContext 확장 (wSurface, wTextPrimary 등)
│   └── widgets/
│       ├── auth_input_field.dart      # 로그인/회원가입 공통 입력 필드
│       ├── gradient_button.dart       # 골드 그라디언트 버튼
│       ├── weddly_app_bar.dart        # 공통 앱바
│       └── weddly_footer.dart         # 공통 푸터
└── features/
    ├── auth/screens/                  # 인증 관련 4개 화면
    ├── home/screens/                  # 메인 화면
    ├── schedule/screens/              # 일정 관리 화면
    └── budget/screens/               # 예산 관리 화면
```

---

## 1. 인증 (Auth) — 4개 화면

| 파일 | 화면명 | 주요 내용 |
|---|---|---|
| `login_screen.dart` (369줄) | 로그인 | 이메일/비밀번호 입력, 소셜 로그인 버튼, 아이디 찾기·비밀번호 재설정 링크 |
| `signup_screen.dart` (926줄) | 회원가입 | 단계별 폼 (이름·이메일·비밀번호·결혼 정보 등), 유효성 검사 |
| `find_id_screen.dart` (264줄) | 아이디 찾기 | 이메일 입력 후 결과 표시 |
| `reset_pw_screen.dart` (290줄) | 비밀번호 재설정 | 인증코드 발송, 새 비밀번호 입력 |

---

## 2. 메인 화면 (`main_screen.dart`, 1,971줄)

앱의 중심 허브 역할. 스크롤 가능한 홈 피드 형태.

### 주요 섹션

- **헤더** — 로고, 다크모드 토글, 알림·프로필 아이콘
- **D-day 카운터** — 결혼식까지 남은 날수, 파트너 연결 버튼 (모달)
- **통계 카드** — 총 예산·예상 하객·준비 진행률 도넛 차트 (`_DonutPainter`)
- **메뉴 그리드** — 기능 바로가기 셀 (일정관리·예산관리 탭 시 해당 화면 이동)
- **타임라인** — 준비 현황 리스트, 바텀시트로 전체 보기 (`_TimelineSheetContent`)
- **업체 추천** — 가로 스크롤 카드 리스트
- **커뮤니티 인기글** — 랭킹·태그·좋아요·댓글 수 표시

### 내장 모달 / 시트

- `_PartnerModalContent` — 파트너 연결 모달
- `_TimelineSheetContent` — 타임라인 전체 바텀시트

---

## 3. 일정 관리 (`schedule_screen.dart`, 2,355줄)

### 탭 3종 (`IndexedStack`으로 상태 유지)

| 탭 | 뷰 클래스 | 내용 |
|---|---|---|
| 월 (月) | `_MonthView` | 6×7 월간 달력 그리드, 날짜별 일정 점 표시 |
| 주 (週) | `_WeekView` | 요일별 세로 레이아웃, 일정 칩 표시 |
| 일 (日) | `_DayView` | 선택 날짜 일정 카드 리스트 (`_EventCard`) |

### 주요 기능

- 일정 등록 / 수정 / 삭제 (CRUD)
- `_AddModal` — 등록·수정 겸용 (제목·날짜·시작·종료시간·색상·메모)
- `_TimePickerDialog` — 드래그 드럼롤 시간 선택 (0–23시 / 00–59분, `ListWheelScrollView`)
- 한국어 날짜 선택 (`showDatePicker`, `locale: Locale('ko', 'KR')`)
- 일정 클릭 시 수정 모달 자동 팝업

### 모델

```dart
class ScheduleEvent {
  final int id;
  final String title;
  final DateTime date;
  final TimeOfDay startTime;
  final TimeOfDay endTime;
  final Color color;
  final String? memo;
  // copyWith() 지원
}
```

---

## 4. 예산 관리 (`budget_screen.dart`, 1,950줄)

### 화면 구성

- **요약 카드** — 다크 골드 그라디언트 배경, 총 예산·사용액·잔여액, 선형 진행바, 도넛 차트 (`_DonutPainter`)
- **카테고리 카드 리스트** — `_BudgetCard` (접기/펼치기 `AnimatedSize`)
- **FAB** — 골드 그라디언트 둥근 버튼 (카테고리 추가)

### CRUD 전체 지원

| 대상 | 등록 | 수정 | 삭제 |
|---|---|---|---|
| 카테고리 예산 항목 | `_ItemModal` | `_ItemModal` (existingItem) | `_DeleteModal` |
| 세부 항목 (하위) | `_SubItemModal` | `_SubItemModal` (existingItem) | `_DeleteModal` |
| 총 예산 | `_TotalBudgetModal` | — | — |

### 주요 기능

- 하위항목 탭 시 수정 모달 오픈
- `_CommaInputFormatter` — 실시간 쉼표 포맷 입력
- `_formatKRW()` — 억원/만원/원 단위 자동 표기
- 11개 프리셋 카테고리 (이모지 + 한글명)
- 사용률 초과 시 빨간색 강조

### 모델

```dart
class SubBudgetItem {
  final int id;
  final String name;
  final int amount;
  final String? note;
  // copyWith() 지원
}

class BudgetItem {
  final int id;
  final String emoji;
  final String name;
  final int amount;
  final Color color;
  final String? memo;
  final List<SubBudgetItem> subItems;
  // 계산 필드: spent, usageRate
  // copyWith() 지원
}
```

---

## 화면 이동 흐름

```
LoginScreen
    └→ MainScreen (홈)
            ├→ ScheduleScreen  (메뉴 "일정관리" 탭)
            └→ BudgetScreen    (메뉴 "예산관리" 탭)
```

---

## 공통 기술 사항

| 항목 | 내용 |
|---|---|
| 테마 | Light / Dark 모드, `ValueNotifier<ThemeMode>` 전역 관리 |
| 폰트 | Pretendard (Regular / Medium / SemiBold / Bold / ExtraBold / Black) |
| 로케일 | `flutter_localizations` — 한국어(`ko_KR`) 우선, 영어(`en_US`) 지원 |
| 색상 | `WeddlyColors` BuildContext 확장으로 테마 대응 색상 일원화 |
| 모달 | `showDialog` + `barrierColor` 반투명 배경 방식 |
| 상태 관리 | `StatefulWidget` + `setState` (별도 패키지 없음) |

---

## 파일별 코드 규모

| 파일 | 줄 수 |
|---|---|
| `login_screen.dart` | 369 |
| `signup_screen.dart` | 926 |
| `find_id_screen.dart` | 264 |
| `reset_pw_screen.dart` | 290 |
| `main_screen.dart` | 1,971 |
| `schedule_screen.dart` | 2,355 |
| `budget_screen.dart` | 1,950 |
| **합계** | **8,125** |
