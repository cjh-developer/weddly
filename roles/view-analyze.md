# Weddly example-view-html 화면 분석

> 분석 일자: 2026-04-19
> 분석 대상: `D:\workspace\weddly\example-view-html\` 전체 HTML 파일
> 공유 자원: `style.css`, `style.js`

---

## 목차

1. [전체 구조 개요](#1-전체-구조-개요)
2. [공통 디자인 시스템](#2-공통-디자인-시스템)
3. [화면별 상세 분석](#3-화면별-상세-분석)
   - [3-1. 로그인 (login.html)](#3-1-로그인-loginhtml)
   - [3-2. 회원가입 (signup.html)](#3-2-회원가입-signuphtml)
   - [3-3. 아이디 찾기 (find_id.html)](#3-3-아이디-찾기-find_idhtml)
   - [3-4. 비밀번호 초기화 (reset_pw.html)](#3-4-비밀번호-초기화-reset_pwhtml)
   - [3-5. 결혼 예정일 설정 (wedding_date.html)](#3-5-결혼-예정일-설정-wedding_datehtml)
   - [3-6. 메인 대시보드 (main.html)](#3-6-메인-대시보드-mainhtml)
   - [3-7. 일정관리 (schedule.html)](#3-7-일정관리-schedulehtml)
   - [3-8. 하객관리 (guest.html)](#3-8-하객관리-guesthtml)
   - [3-9. 예산관리 (budget.html)](#3-9-예산관리-budgethtml)
   - [3-10. 메모장 (memo.html)](#3-10-메모장-memohtml)
   - [3-11. 메모 작성 (memo_write.html)](#3-11-메모-작성-memo_writehtml)
   - [3-12. 웨딩관리 / 로드맵 (roadmap.html)](#3-12-웨딩관리--로드맵-roadmaphtml)
   - [3-13. 식순관리 (ceremony_order.html)](#3-13-식순관리-ceremony_orderhtml)
   - [3-14. 업체 둘러보기 (vendor.html)](#3-14-업체-둘러보기-vendorhtml)
   - [3-15. 커뮤니티 (community.html)](#3-15-커뮤니티-communityhtml)
   - [3-16. 커뮤니티 상세 (community_detail.html)](#3-16-커뮤니티-상세-community_detailhtml)
   - [3-17. 커뮤니티 작성 (community_write.html)](#3-17-커뮤니티-작성-community_writehtml)
   - [3-18. 설정 (settings.html)](#3-18-설정-settingshtml)
   - [3-19. 사용자 정보 (user.html)](#3-19-사용자-정보-userhtml)
   - [3-20. 관리자 (admin.html)](#3-20-관리자-adminhtml)
   - [3-21. 개인정보 처리방침 (privacy.html)](#3-21-개인정보-처리방침-privacyhtml)
   - [3-22. 앱 정보 (app_info.html)](#3-22-앱-정보-app_infohtml)
4. [화면 간 내비게이션 흐름](#4-화면-간-내비게이션-흐름)
5. [공통 동작 (style.js)](#5-공통-동작-stylejs)
6. [하단 네비게이션 개선 제안](#6-하단-네비게이션-개선-제안)

---

## 1. 전체 구조 개요

### 물리 구조
```
example-view-html/
├── style.css           ← 공통 CSS (phone-wrapper, 컴포넌트 기반)
├── style.js            ← 공통 JS (유효성 검사, 캘린더, 다크모드 등)
│
├── [인증 플로우]
│   ├── login.html
│   ├── signup.html
│   ├── find_id.html
│   └── reset_pw.html
│
├── [온보딩]
│   └── wedding_date.html
│
├── [메인]
│   └── main.html
│
├── [기능 화면]
│   ├── schedule.html
│   ├── guest.html
│   ├── budget.html
│   ├── memo.html
│   ├── memo_write.html
│   ├── roadmap.html
│   ├── ceremony_order.html
│   └── vendor.html
│
├── [커뮤니티]
│   ├── community.html
│   ├── community_detail.html
│   └── community_write.html
│
├── [설정/관리]
│   ├── settings.html
│   ├── user.html
│   └── admin.html
│
└── [기타]
    ├── privacy.html
    └── app_info.html
```

### HTML 기본 골격 (모든 파일 공통)
```html
<div class="phone-wrapper">    <!-- 390px 폰 프레임 -->
  <div class="phone-screen">   <!-- 내부 콘텐츠 영역, overflow-y: auto -->
    <!-- 페이지 콘텐츠 -->
  </div>
</div>
```
- 데스크탑: `phone-wrapper`가 390×844 사이즈의 폰 목업으로 보임
- 모바일(`max-width: 430px`): 전체 화면으로 확장, 노치 숨김

---

## 2. 공통 디자인 시스템

### 색상
| 역할 | 값 |
|------|-----|
| Primary (골드) | `#D4A96A` |
| Primary Dark | `#C49050` |
| Primary Light | `#E8C07A` |
| 배경 | `#f8f8f8` |
| 텍스트 기본 | `#222222` |
| 텍스트 보조 | `#555555` |
| 텍스트 힌트 | `#888888` |
| 성공 | `#4caf50` |
| 에러 | `#f44336` |
| 경고 | `#FF9800` |

### 타이포그래피
- 폰트 패밀리: `'Apple SD Gothic Neo', 'Pretendard', 'Noto Sans KR', sans-serif`
- 로고: 38px / 800 weight / italic
- 페이지 제목: 18–20px / 700–800
- 본문: 14px / 500–600
- 캡션: 12px / 500

### 레이아웃 원칙
- 화면 좌우 패딩: `28px`
- 화면 하단 여백: `40px`
- 폼 그룹 간격: `14px gap`
- 헤더: sticky, backdrop-filter: blur

### 공통 컴포넌트
- **Primary Button**: 골드 그라디언트, `border-radius: 12px`, 전체 너비
- **Input Wrap**: 회색 배경(`#f8f8f8`), 포커스 시 골드 테두리 + 그림자
- **Modal**: `border-radius: 20px`, `modalIn` 애니메이션 (scale + translateY)
- **FAB 버튼**: 우하단 고정, 골드 그라디언트, 원형 또는 사각형(radius 16px)
- **Icon Button**: 38×38px, `border-radius: 12px`, hover 시 골드 배경
- **Bottom Navigation**: 5탭, 활성 탭 상단에 골드 2.5px 인디케이터

---

## 3. 화면별 상세 분석

---

### 3-1. 로그인 (login.html)

**목적**: 앱 진입점. 일반 로그인 + 소셜 로그인

**구조**
```
phone-screen
├── logo-section          ← "weddly" + 슬로건
├── form-section
│   ├── input-group[아이디]   ← 사용자 아이콘 + 텍스트 입력
│   ├── input-group[비밀번호] ← 자물쇠 아이콘 + 비밀번호 입력 + 눈 아이콘(토글)
│   ├── options-row
│   │   ├── remember-me        ← 커스텀 체크박스 + "로그인 유지"
│   │   └── forgot-links       ← "아이디 찾기 | 비밀번호 초기화"
│   ├── btn-login              ← Primary CTA 버튼
│   └── signup-row             ← "아직 계정이 없으신가요? 회원가입"
├── divider                ← "또는 소셜 계정으로 로그인"
├── social-section
│   ├── btn-google          ← 구글 SVG 로고
│   ├── btn-kakao           ← 카카오 SVG 로고
│   └── btn-naver           ← N 텍스트 배지
└── copyright
```

**디자인 특징**
- 로고 섹션: 상단 여백 포함, "weddly" 38px italic 골드, 슬로건 13px 회색
- 입력 컴포넌트: `input-wrapper`(배경 회색, 테두리 없음) 안에 좌측 SVG 아이콘
- 비밀번호 필드: 우측에 눈 아이콘 버튼(토글)
- 옵션 행: 체크박스(골드 배경) + 링크 2개(| 구분)
- 소셜 버튼: 흰 배경, `border: 1.5px solid #e0e0e0`, 아이콘 + 텍스트 flex row
  - Google: 흰 배경, 컬러 SVG
  - Kakao: `#FEE500` 배경
  - Naver: `#03C75A` 배경, "N" 텍스트

**동작**
- 로그인 버튼 클릭: 아이디/비밀번호 빈 값 검사 → alert (API 연동 예정)
- Enter 키: 로그인 버튼 클릭과 동일 동작
- 비밀번호 토글: 눈 아이콘 클릭 시 password ↔ text 전환, 아이콘 변경
- 소셜 버튼: alert로 "OAuth 연동 예정" 메시지

**링크**
- 아이디 찾기 → `find_id.html`
- 비밀번호 초기화 → `reset_pw.html`
- 회원가입 → `signup.html`

---

### 3-2. 회원가입 (signup.html)

**목적**: 신규 사용자 가입 (단계형 UI)

**구조**
```
phone-screen
├── signup-header
│   ├── back-btn          ← 좌측 < 화살표 (login.html로)
│   ├── header-title-wrap ← "weddly" 소형 로고 + "회원가입"
│   └── header-placeholder (우측 균형)
├── step-bar              ← 3단계: 계정정보(●) → 개인정보(●) → 완료(○)
├── signup-form
│   ├── input-group[아이디]     ← 텍스트 + 중복확인 버튼(Secondary)
│   ├── input-group[이름]       ← 텍스트
│   ├── input-group[비밀번호]   ← 비밀번호 + 강도 바 + 눈 아이콘
│   ├── input-group[비밀번호확인] ← 비밀번호 + 눈 아이콘
│   ├── input-group[이메일]     ← 이메일 타입
│   ├── input-group[전화번호]   ← tel + 자동 하이픈
│   ├── input-group[구분]       ← 신랑/신부 역할 카드 2개
│   ├── terms-section
│   │   ├── 전체 동의 체크박스
│   │   ├── [필수] 서비스 이용약관 → 모달 열기
│   │   ├── [필수] 개인정보 처리방침 → 모달 열기
│   │   └── [선택] 마케팅 정보 수신
│   ├── btn-signup             ← Primary CTA
│   └── 로그인 링크
├── modal#modalService         ← 서비스 이용약관 전문
└── modal#modalPrivacy         ← 개인정보 처리방침 전문
```

**디자인 특징**
- 스텝 바: 완료 단계 골드 색상 원 + 번호, 단계 간 연결선(44px 가로선), 미완료는 회색
- 아이디 필드: `input-row` = `flex` → 입력창(flex:1) + 중복확인 버튼(고정 너비)
- 비밀번호 강도 바: 4px 높이, weak(빨강)/medium(주황)/strong(초록) 전환, width 0.35s transition
- 역할 카드(신랑/신부): 이모지 + 이름 + 영문, 선택 시 골드 그라디언트 + 흰 텍스트
- 약관 모달: max-height 80vh, 스크롤 가능, 하단 "동의하고 닫기" + "닫기" 버튼

**동작**
- 아이디 중복확인 버튼: 클릭 시 시뮬레이션 (confirmed 상태로 전환 - 초록 테두리)
- 비밀번호 강도 실시간 분석: 입력 시 길이·대소문자·숫자·특수문자 조합으로 weak/medium/strong 판단
- 비밀번호 확인 일치 여부 실시간 검증
- 전화번호 자동 하이픈: `010-xxxx-xxxx` 포맷 자동 변환
- 전체 동의 체크박스: 하위 체크박스 전체 선택/해제 연동
- 약관 링크 "보기": 해당 모달 열기
- 모달 "동의하고 닫기": 해당 항목 자동 체크 후 닫기
- 제출: 전체 필수 항목 검증 후 alert(API 연동 예정)

---

### 3-3. 아이디 찾기 (find_id.html)

**목적**: 가입한 이름 + 이메일로 아이디 조회

**구조**
```
phone-screen
├── signup-header         ← 뒤로가기 + "weddly" + "아이디 찾기"
├── find-guide
│   ├── find-icon          ← 32px 사람 SVG (#D4A96A)
│   ├── find-guide-title   ← "아이디를 잊으셨나요?"
│   └── find-guide-desc    ← 안내 문구
├── find-form
│   ├── input-group[이름]
│   ├── input-group[이메일]
│   └── btn-login          ← "아이디 찾기" Primary 버튼
├── find-result (숨김 → JS 표시)
│   ├── result-box
│   │   ├── result-icon    ← 초록 체크 SVG
│   │   ├── result-label   ← "회원님의 아이디"
│   │   ├── result-id      ← 조회된 아이디 텍스트
│   │   └── result-date    ← 가입일 텍스트
│   └── result-actions
│       ├── 로그인하러 가기 (Primary 버튼)
│       └── 비밀번호 초기화 (텍스트 링크)
├── find-bottom-links     ← "로그인 | 회원가입"
└── copyright
```

**디자인 특징**
- 안내 아이콘 영역: 중앙 정렬, 골드 아이콘 + 제목 + 설명
- 결과 박스: `background: #fafafa`, `border: 1.5px solid #f0e8d8`, `border-radius: 16px`
- 초기 상태: `find-result` display:none → JS로 표시

**동작**
- 버튼 클릭: 이름/이메일 빈 값 검증 → 이메일 형식 검증 → 시뮬레이션 아이디 반환
- 성공 시: `find-result` 영역 표시(fadeIn), 조회된 아이디/가입일 텍스트 주입
- 비밀번호 초기화 링크: reset_pw.html로 이동

---

### 3-4. 비밀번호 초기화 (reset_pw.html)

**목적**: 아이디 + 이메일 + 전화번호 3요소 일치 시 임시 비밀번호 발송

**구조**
```
phone-screen
├── signup-header         ← 뒤로가기 + "weddly" + "비밀번호 초기화"
├── find-guide
│   ├── find-icon          ← 32px 자물쇠 SVG (#D4A96A)
│   ├── find-guide-title   ← "비밀번호를 잊으셨나요?"
│   └── find-guide-desc    ← 3가지 정보 안내
├── reset-form
│   ├── input-group[아이디]
│   ├── input-group[이메일]
│   ├── input-group[전화번호]  ← 자동 하이픈
│   └── btn-login           ← "비밀번호 초기화" Primary 버튼
├── resetResult (숨김 → JS 표시)
│   ├── result-box-reset
│   │   ├── result-icon-reset  ← 골드 전송 아이콘 SVG
│   │   ├── "임시 비밀번호 발송 완료"
│   │   ├── 발송된 이메일 주소 표시
│   │   └── "임시 비밀번호로 로그인 후 반드시 변경해주세요."
│   └── result-actions → 로그인하러 가기
├── find-bottom-links     ← "로그인 | 아이디 찾기 | 회원가입"
└── copyright
```

**디자인 특징**
- find_id.html과 동일 레이아웃 패턴 공유
- 결과 아이콘은 골드(전송 아이콘), find_id는 초록(성공 체크)
- 하단 링크 3개 (find_id는 2개)

**동작**
- 버튼 클릭: 아이디/이메일/전화번호 빈 값 + 형식 검증 → 시뮬레이션 결과 표시
- 성공 시: `resetResult` 표시, 마스킹된 이메일 주소 표시

---

### 3-5. 결혼 예정일 설정 (wedding_date.html)

**목적**: 온보딩 단계에서 결혼 예정일 선택

**구조**
```
phone-screen
├── wd-top          ← "weddly" 소형 로고
├── wd-welcome
│   ├── wd-ring-icon  ← 반지 SVG (52px, 골드)
│   ├── wd-welcome-title ← "웨딩 날짜를 알려주세요"
│   └── wd-welcome-desc  ← 안내 문구
├── wd-card         ← 날짜 선택 카드
│   ├── wd-selected-banner ← 선택한 날짜 + D-Day 표시
│   ├── wd-nav             ← < 연/월 버튼 > (휠 피커 내장)
│   │   ├── prevMonth 버튼
│   │   ├── 년도 피커 (버튼 클릭 → 휠 패널)
│   │   ├── 월 피커 (버튼 클릭 → 휠 패널)
│   │   └── nextMonth 버튼
│   ├── wd-weekdays  ← 일~토 헤더 (일=빨강, 토=파랑)
│   └── wd-days      ← 7열 날짜 그리드 (JS로 렌더링)
├── wd-tags          ← "💍 날짜 미정이면 나중에 설정 가능"
└── wd-actions
    ├── wd-btn-confirm ← "결혼 예정일 저장하기" (날짜 미선택 시 disabled)
    └── wd-btn-skip    ← "나중에 설정할게요" (회색 텍스트 버튼)
```

**디자인 특징**
- 반지 SVG: 원형 반지 + 보석 형태 (커스텀 SVG)
- 선택 배너: 선택 날짜 + D-Day 실시간 계산 표시
- 달력: CSS Grid 7열, 오늘=골드 원, 선택=골드 배경, 일=빨강, 토=파랑
- 휠 피커: 스크롤 snap 방식, 상하 페이드 오버레이, `wheelIn` 애니메이션
- 저장 버튼: 날짜 선택 전 `disabled`, 선택 후 활성화

**동작**
- 달력 렌더링: JS로 현재 월 날짜 그리드 생성
- 날짜 클릭: 선택 상태 표시, 배너에 선택일/D-Day 업데이트
- < > 버튼: 이전/다음 달 이동
- 년/월 버튼 클릭: 휠 피커 패널 오픈 (스크롤로 선택)
- 저장: alert(API 연동 예정) → main.html 이동 예정
- 나중에 설정: main.html 이동

---

### 3-6. 메인 대시보드 (main.html)

**목적**: 앱의 핵심 허브. 웨딩 준비 현황 한눈에 파악

**구조**
```
phone-screen
├── main-header (sticky)
│   ├── main-logo       ← "weddly" 24px italic 골드
│   └── header-actions
│       ├── 다크모드 토글 버튼 (달/태양 아이콘 전환)
│       ├── 알림 버튼 (빨간 배지)
│       └── 프로필 버튼
├── hero-card
│   ├── hero-deco (배경 데코 원 3개)
│   ├── hero-left
│   │   ├── hero-greeting  ← "안녕하세요 👋"
│   │   ├── hero-name      ← "홍길동님, 환영합니다!!"
│   │   └── hero-date-pill ← 💍 웨딩 날짜 pill
│   └── hero-dday-box      ← D·DAY / 숫자 / "결혼까지"
├── section[파트너 연결]
│   └── partner-trigger-btn → 클릭 시 모달
├── section[현황]
│   └── stats-card
│       ├── stats-half[전체 진행률]   ← 도넛 SVG 차트 + 수치
│       └── stats-half[예산 사용률]   ← 도넛 SVG 차트 + 수치
├── section[웨딩 타임라인]
│   ├── roadmapSelect       ← 로드맵 선택 셀렉트
│   └── tl-wrap
│       ├── tl-summary       ← 완료 N / 전체 N + 진행바
│       ├── timelineList     ← 타임라인 아이템 목록 (JS 렌더링)
│       └── tl-preview-more  ← 전체보기 → 바텀시트 오픈
├── section[메뉴]
│   └── menu-grid (3열)
│       ├── 일정관리 → schedule.html
│       ├── 예산관리 → budget.html
│       ├── 웨딩관리 → roadmap.html
│       ├── 하객관리 → guest.html
│       ├── 메모장 → memo.html
│       └── 식순관리 → ceremony_order.html
├── section[업체 둘러보기]
│   └── vendor-scroll (수평 스크롤)
│       ← 예식장/스튜디오/드레스/메이크업/DVD/웨딩플래너
├── section[커뮤니티 인기글]
│   └── community-card (4개 게시글 목록)
├── main-copyright
│
├── partner-modal-overlay (모달)
│   └── partner-modal
│       ├── 내 코드 표시 + 복사 버튼
│       ├── QR 코드 섹션
│       └── 파트너 코드 입력 섹션
│
├── tl-sheet-overlay (타임라인 바텀시트)
│   └── tl-sheet (전체 타임라인 그룹별)
│
└── bottom-nav (5탭 고정 하단)
    ← 홈 / 일정 / 예산 / 커뮤니티 / 설정
```

**디자인 특징**
- Hero 카드: 다크 골드 그라디언트(`#18110a → #33210a → #a8721e`), 우측 D-Day 반투명 박스
- Hero 반짝임 오버레이: `::before` 의사 요소로 대각선 반투명 레이어
- 배경 데코: 우하단에 3개의 반투명 원
- 도넛 차트: SVG `stroke-dasharray` 기반, CSS 변수로 진행률 표현
- 타임라인 아이콘: done(골드 체크), urgent(빨간 !), todo(회색), d-day(골드 별★)
- 메뉴 그리드: 3열, 56×56 아이콘 박스 + 라벨
- 업체 카드: 수평 스크롤, `scroll-snap-type: x mandatory`
- 커뮤니티: 순위(1위=골드, 2위=실버, 3위=동) + 썸네일 + 제목 + 메타
- 하단 내비게이션: 활성 탭 상단에 2.5px 골드 인디케이터

**동작 (다크모드)**
- 다크 토글 버튼: `.phone-wrapper`에 `.dark` 클래스 추가/제거
- 다크 시 배경 `#15120e`, 텍스트 반전, 헤더/카드/모달 배경 모두 다크 처리
- 아이콘 달 ↔ 태양 자동 전환

**파트너 코드 모달 동작**
- 내 코드 표시 (6자리 숫자)
- 복사 버튼: 클립보드 복사 + 버튼 텍스트 "복사됨!"으로 변경
- 파트너 코드 입력 → 연결 버튼

**타임라인 동작**
- 로드맵 셀렉트 변경 시: 해당 로드맵 항목으로 타임라인 재렌더링
- 전체보기 버튼: 바텀시트 오픈 (그룹 접기/펼치기 가능)

---

### 3-7. 일정관리 (schedule.html)

**목적**: 웨딩 일정을 월/주/목록 뷰로 관리

**구조**
```
sch-page
├── sch-header
│   ├── sch-header-top    ← 뒤로가기 + weddly 로고 + 아이콘 버튼들
│   │   └── 다크모드 / 검색 / 필터 / 추가 아이콘
│   └── sch-header-nav    ← < 기간 레이블 > + 오늘 버튼
├── sch-tabs              ← 월 | 주 | 목록 탭
├── sch-content
│   ├── [월 뷰 .month-view]
│   │   ├── cal-weekdays  ← 요일 헤더 (sticky)
│   │   ├── cal-grid      ← 7열 날짜 그리드 + 이벤트 점
│   │   └── month-events  ← 선택일 이벤트 목록
│   ├── [주 뷰 .week-view]
│   │   ├── week-day-strip ← 7일 날짜 스트립
│   │   └── week-day-group ← 날짜별 이벤트 그룹
│   └── [목록 뷰 .list-view]
│       └── 날짜별 이벤트 섹션
├── sch-fab               ← + FAB (이벤트 추가)
│
├── ev-modal-overlay      ← 이벤트 등록/수정 모달
│   └── ev-sheet
│       ├── 제목 입력
│       ├── 날짜/시간 (2열)
│       ├── 종일 여부 토글
│       ├── 카테고리 선택
│       ├── 색상 선택기 (원형 버튼 5개)
│       ├── 메모 텍스트에어리어
│       └── footer: 취소 | 저장
│
└── del-modal-overlay     ← 삭제 확인 모달
    └── del-box
        ├── 이모지 + 제목 + 설명
        └── 취소 | 삭제 버튼
```

**디자인 특징**
- 헤더: 2단 구성 (로고+액션 상단 / 기간네비+오늘버튼 하단)
- 탭: 활성 탭 하단에 28px 골드 언더라인
- 오늘 버튼: 골드 아웃라인, hover 시 채움
- 달력 셀: min-height 52px, 이벤트 점(5px 원)으로 일정 표시
- 이벤트 색상 선택: 5가지 원형 버튼 (선택 시 외곽 링 표시)
- FAB: 원형(54px), 골드 그라디언트, hover 시 scale(1.08)
- 삭제 모달: 빨간 확인 버튼, 중앙 팝업

**동작**
- 탭 전환: 월/주/목록 뷰 교체 (display 전환)
- 달력 날짜 클릭: selected 상태, 하단 이벤트 목록 업데이트
- 월 네비게이션: < > 클릭 시 달력 재렌더링
- 오늘 버튼: 현재 월/오늘 날짜로 이동
- FAB 클릭: 이벤트 등록 모달 오픈
- 이벤트 아이템 클릭: 수정 모달 오픈
- 이벤트 삭제: 삭제 확인 모달 → 확인 시 목록에서 제거

---

### 3-8. 하객관리 (guest.html)

**목적**: 결혼식 하객 정보 관리 및 통계

**구조**
```
guest-page
├── gh-header
│   ├── gh-header-top    ← 뒤로가기 + weddly + 아이콘(다크모드/검색/필터/추가)
│   └── gh-header-nav    ← 제목 "하객관리" + 정렬 셀렉트
├── gh-cat-strip         ← 카테고리 탭 (수평 스크롤)
│   ← 전체 / 신랑측 / 신부측 / 가족 / 친구 / 직장 + 추가(+) 버튼
├── gh-stats             ← 3열 통계
│   ← 총 하객 수 / 참석 확인 수 / 미확인 수
├── gh-content           ← 하객 목록
│   └── 하객 카드 (이름 / 관계 / 연락처 / 참석 여부 토글)
└── FAB                  ← + 하객 추가
```

**디자인 특징**
- 카테고리 탭: 활성 탭 골드 배경 + 흰 텍스트, overflow-x auto 스크롤
- 추가 버튼(+): 원형 dashed 테두리, hover 시 골드
- 통계 영역: 3열 그리드, `background: #fafafa`, `border-bottom: 1px solid #f0f0f0`
- 정렬 셀렉트: 커스텀 화살표 아이콘, 포커스 시 골드 테두리

**동작**
- 카테고리 탭 클릭: 해당 그룹 필터링
- 정렬 셀렉트: 이름순/관계순/참석여부순 정렬
- 참석 여부 토글: 해당 하객 상태 변경 → 통계 바 업데이트
- FAB: 하객 추가 모달/시트 오픈

---

### 3-9. 예산관리 (budget.html)

**목적**: 웨딩 예산 카테고리별 관리

**구조**
```
phone-screen
├── main-header (sticky) ← weddly 로고 + 아이콘(다크모드/알림/프로필)
├── 예산 요약 카드
│   ├── 도넛 SVG 차트 (사용률 %)
│   ├── 총 예산 / 사용 금액 / 잔액
│   └── 카테고리별 비율 미니 바
├── 카테고리 목록 (아코디언)
│   └── budget-category-item (아코디언)
│       ├── 카테고리 아이콘 + 이름
│       ├── 진행 미니바 + %
│       ├── 편집/삭제 버튼
│       ├── 펼침 화살표 (open 시 rotate 180deg)
│       └── budget-sub-list (접힘/펼침)
│           └── budget-sub-item (세부 항목)
│               ← 점 + 항목명 + 금액 + 메모 + 삭제 버튼
├── fab-btn              ← + 항목 추가 FAB
└── modal-overlay        ← 예산 항목 추가 모달
    └── modal-box
        ← 카테고리 / 항목명 / 금액 / 메모 입력
```

**디자인 특징**
- 아코디언: `max-height: 0` → `max-height: 무제한` 전환(0.3s), `border-top-width: 0 → 1px`
- 미니 진행 바: 40px 너비, 골드 그라디언트 채움
- 세부 항목: 들여쓰기 구조 (`padding-left: 20px`)
- 커스텀 스크롤바: 4px 너비, 골드 그라디언트
- FAB: 사각형(border-radius: 16px), 우하단 고정
- 모달: 중앙 팝업, 스크롤바 커스텀

**동작**
- 카테고리 행 클릭: 세부 목록 펼침/접힘 토글
- 화살표 아이콘: open 클래스에 따라 rotate(180deg)
- 항목 삭제: 확인 없이 즉시 삭제 (또는 confirm 팝업)
- FAB → 모달 오픈 → 추가 후 목록 업데이트
- 금액 입력: 숫자 콤마 포맷 자동 처리

---

### 3-10. 메모장 (memo.html)

**목적**: 웨딩 준비 관련 메모 관리

**구조**
```
phone-screen
├── main-header (sticky) ← weddly 로고 + 아이콘
├── 폴더 탭 영역         ← 전체 / 폴더명 탭 (수평 스크롤)
├── 검색바
├── 메모 그리드/목록     ← note-card (제목 + 날짜 + 폴더 배지 + 첨부 배지)
├── fab-backdrop         ← FAB 열릴 때 배경 딤
├── fab-wrapper
│   ├── fab-menu (open 시 표시)
│   │   ├── fab-menu-item[폴더 추가]  ← 폴더 아이콘
│   │   └── fab-menu-item[메모 추가]  ← 펜 아이콘
│   └── fab-btn                      ← + 버튼 (open 시 rotate 45deg = × 모양)
│
├── modal-overlay (바텀 시트 – 삭제 확인)
│   └── modal-sheet (border-radius: 20px 20px 0 0)
│       ← 삭제 확인 텍스트 + 취소/삭제 버튼
│
└── modal-overlay.modal-center (중앙 팝업 – 폴더 추가)
    └── modal-sheet
        ← 폴더명 입력 + 색상 선택 + 확인
```

**디자인 특징**
- FAB: + 버튼이 두 가지 액션을 가짐 (폴더/메모)
- FAB 상태: 닫힘=`+`, 열림=`rotate(45deg)` = `×` 시각적 전환 (0.25s cubic-bezier)
- 메모 카드: `border-radius: 14px`, 좌측 색상 바 (폴더 컬러)
- 폴더 배지: 골드 배경 + 텍스트 (`background: #fff8ef`)
- 바텀 시트: `border-radius: 20px 20px 0 0`, `slideUp` 애니메이션

**동작**
- FAB 클릭: 메뉴 표시/숨김 + 배경 딤 처리
- 폴더 추가: 중앙 모달 → 이름 입력 → 탭에 추가
- 메모 추가: `memo_write.html`로 이동
- 메모 길게 누르기: 삭제 바텀시트 오픈
- 탭 클릭: 해당 폴더 메모 필터링

---

### 3-11. 메모 작성 (memo_write.html)

**목적**: 메모 내용 작성/편집

**구조**
```
phone-screen (flex-direction: column, height: 고정)
├── main-header        ← weddly 로고 + 저장(골드 텍스트) + 닫기(×) 버튼
├── 작성 영역 (flex: 1, overflow: hidden)
│   ├── 제목 입력 (border 없는 large input)
│   ├── 날짜/폴더 선택 메타 행
│   └── 내용 입력 (border 없는 textarea, flex: 1)
└── 하단 툴바
    ← 굵게 / 기울임 / 목록 / 체크리스트 / 이미지 / 링크
```

**디자인 특징**
- 전체가 `flex column`, 콘텐츠 영역이 `flex: 1`로 남은 공간 모두 사용
- 제목: 큰 폰트, 패딩만 있는 무테두리 인풋
- 툴바: 하단 고정, 아이콘 버튼 나열

**동작**
- 저장: 제목/내용 수집 → API 연동 예정
- 닫기: 이전 페이지(`memo.html`)로 이동

---

### 3-12. 웨딩관리 / 로드맵 (roadmap.html)

**목적**: 웨딩 준비 로드맵 단계별 진행 관리
> 메인 대시보드의 타임라인과 동일한 데이터를 공유한다. 기본 로드맵이 시스템에 내장되어 있으며, 사용자가 별도 로드맵을 등록하지 않은 경우 기본 로드맵으로 화면에 표출된다.

**구조**
```
phone-screen
├── rm-header (sticky)
│   ├── 뒤로가기 버튼
│   ├── weddly 로고 + "웨딩관리" 제목
│   └── 우측 아이콘 버튼
├── 로드맵 필터 탭      ← 전체 / 예식장 / 스튜디오 / 드레스 등
├── 로드맵 아이템 목록
│   └── roadmap-item (체크박스 + 항목명 + 기간 + 상태 배지)
└── FAB / 추가 버튼
```

**디자인 특징**
- 체크박스: 완료 시 골드 체크, 미완료 회색 원
- 상태 배지: todo(회색) / in-progress(골드) / done(초록) / urgent(빨강)
- 수직 타임라인과 동일한 dot + line 패턴

**동작**
- 항목 클릭: 완료/미완료 토글
- 필터 탭: 카테고리별 필터링
- 추가: 로드맵 항목 추가 모달

---

### 3-13. 식순관리 (ceremony_order.html)

**목적**: 결혼식 식순(순서) 항목 관리

**구조**
```
phone-screen
├── main-header (sticky) ← weddly 로고 + 아이콘
├── 식순 목록
│   └── ceremony-item (드래그 핸들 + 번호 + 항목명 + 시간 + 편집/삭제)
│       ← 드래그 앤 드롭으로 순서 변경 가능
└── FAB                  ← + 식순 추가
```

**디자인 특징**
- 드래그 핸들: `≡` 아이콘, 잡고 드래그
- 번호 배지: 골드 원형
- 좌측에 수직 타임라인 선 스타일

**동작**
- 드래그 앤 드롭: 순서 재배치
- 편집/삭제: 인라인 액션 버튼
- FAB: 식순 추가 모달

---

### 3-14. 업체 둘러보기 (vendor.html)

**목적**: 웨딩 관련 업체 탐색 및 관리

**구조**
```
phone-screen
├── main-header (sticky) ← weddly 로고 + 다크모드/검색/필터 버튼
├── 카테고리 필터 탭     ← 수평 스크롤 (예식장/스튜디오/드레스/메이크업/DVD/플래너)
├── 검색바
├── 업체 목록
│   └── vendor-item
│       ← 업체 이미지 + 이름 + 카테고리 + 별점 + 가격대 + 즐겨찾기 버튼
└── 상세 바텀시트 or 페이지 이동
```

**디자인 특징**
- 카테고리: 아이콘 + 이름, 활성 탭 골드 배경
- 업체 카드: `border-radius: 14px`, 썸네일 이미지 + 정보
- 별점: 골드 별표
- 즐겨찾기: 하트 아이콘 토글

---

### 3-15. 커뮤니티 (community.html)

**목적**: 사용자 간 정보 공유 게시판

**구조**
```
phone-screen
├── main-header (sticky) ← weddly 로고 + 다크모드/알림/글쓰기 버튼
├── cm-search-wrap       ← 검색창 (포커스 시 골드 테두리)
├── 카테고리 탭          ← 전체 / 웨딩홀 / 드레스 / 스튜디오 / 메이크업 등 (수평 스크롤)
├── 공지 배너 (선택)
├── 게시글 목록
│   └── cm-post-item
│       ← 카테고리 배지 + 제목 + 작성자 + 날짜 + 좋아요 + 댓글수
└── FAB                  ← 글쓰기 버튼 (pencil 아이콘)
```

**디자인 특징**
- 검색창: `background: #f8f6f2`, `border: 1.5px solid #ede9e3`, 포커스 시 골드
- 게시글 카드: 제목 말줄임(`text-overflow: ellipsis`), 카테고리 배지 골드
- 순위/인기 배지: top1=골드, top2=은색, top3=동색

**동작**
- 검색 입력: 실시간 필터링 (또는 검색 버튼)
- 카테고리 탭: 해당 카테고리 게시글 필터
- 게시글 클릭: `community_detail.html`로 이동
- FAB: `community_write.html`로 이동

---

### 3-16. 커뮤니티 상세 (community_detail.html)

**목적**: 게시글 본문 + 댓글

**구조**
```
phone-screen
├── 뒤로가기 헤더
├── 게시글 헤더        ← 카테고리 배지 + 제목 + 작성자/날짜
├── 게시글 본문
├── 이미지 첨부 (선택)
├── 좋아요 / 공유 / 신고 버튼
├── 댓글 섹션
│   └── 댓글 아이템 (아바타 + 닉네임 + 내용 + 날짜)
└── 댓글 입력창 (하단 고정)
    ← 텍스트 입력 + 전송 버튼
```

---

### 3-17. 커뮤니티 작성 (community_write.html)

**목적**: 게시글 작성

**구조**
```
phone-screen
├── 헤더 ← 취소 + "글쓰기" + 게시 버튼
├── 카테고리 선택 셀렉트
├── 제목 입력 (border-bottom만)
├── 내용 textarea (flex: 1)
├── 이미지 첨부 버튼
└── 하단 툴바 (이미지/태그 등)
```

---

### 3-18. 설정 (settings.html)

**목적**: 앱 설정 및 사용자 정보 관리
> 하단 네비게이션 설정 탭에서 진입하는 화면. 앱 자체 설정(알림, 다크모드, 언어, 정책 등)을 관리한다.

**구조**
```
phone-screen
├── main-header (sticky) ← weddly 로고 + 아이콘
├── settings-content
│   ├── profile-summary-card
│   │   ← 다크 골드 그라디언트 카드
│   │   ← 아바타 + 이름/구분 + D-DAY
│   ├── 설정 그룹: 계정
│   │   ← 프로필 편집 / 비밀번호 변경 / 파트너 연결
│   ├── 설정 그룹: 앱 설정
│   │   ← 알림 허용 / 다크모드 / 언어
│   ├── 설정 그룹: 개인정보 & 보안
│   │   ← 개인정보 처리방침 / 서비스 이용약관
│   └── 설정 그룹: 기타
│       ← 앱 정보 / 캐시 삭제 / 로그아웃 / 회원탈퇴
└── copyright
```

**디자인 특징**
- 프로필 카드: hero-card와 동일 다크 그라디언트 스타일
- 설정 항목: `chevron` 우측 화살표, 토글 스위치(알림/다크모드)
- 파괴적 항목(회원탈퇴): 빨간색 텍스트

---

### 3-19. 사용자 정보 (user.html)

**목적**: 사용자 개인 정보 조회 및 편집
> 헤더 우측의 프로필 버튼 클릭 시 진입하는 개인 페이지. settings.html(앱 설정)과는 독립된 화면이다.

**구조**
```
phone-screen
├── main-header (sticky) ← weddly 로고 + 아이콘
├── 프로필 영역
│   ← 아바타(원형) + 편집 버튼
├── 정보 목록
│   └── 항목 행 (라벨 + 값 + 편집 버튼)
│       ← 이름 / 아이디 / 이메일 / 전화번호 / 구분(신랑/신부)
└── 저장 버튼
```

---

### 3-20. 관리자 (admin.html)

**목적**: 시스템 정책 설정 및 사용자 관리

**구조**
```
phone-screen
├── admin-header (sticky)
│   ├── weddly 로고 + "ADMIN" 배지 (골드 그라디언트)
│   └── 우측 아이콘
├── 관리자 탭           ← 사용자 / 정책 / 로그 / 통계
├── [정책 탭]
│   ├── 비밀번호 정책 섹션
│   │   ← 암호화 방식 / 인코딩 방식 / SALT 설정 / 복잡도 규칙
│   ├── 아이디 정책 섹션
│   │   ← 시작문자 / 포함문자 / 길이 제한
│   ├── 토큰 정책 섹션
│   │   ← 만료 기간 / 연장 기간
│   └── 시스템 정책 섹션
│       ← 로그 보관 기간 설정
├── [사용자 탭]
│   └── 사용자 목록 + 검색/필터
└── [로그 탭]
    └── 로그인/비밀번호/토큰 이력
```

**디자인 특징**
- ADMIN 배지: 골드 그라디언트, `font-size: 10px`, 대문자
- 정책 항목: 셀렉트/인풋 혼합 폼
- 일반 사용자 화면과 헤더 스타일 구분(admin-header)

---

### 3-21. 개인정보 처리방침 (privacy.html)

**목적**: 법적 고지 문서 표시

**구조**
```
phone-screen
├── 헤더 ← 뒤로가기 + "개인정보 처리방침"
└── 문서 내용 (스크롤 가능)
    ← 조항별 h3 + p 구성
```

---

### 3-22. 앱 정보 (app_info.html)

**목적**: 앱 버전, 팀 정보, 오픈소스 라이선스 표시

**구조**
```
phone-screen
├── 헤더
├── 앱 아이콘 + 이름 + 버전
├── 팀 정보
└── 라이선스 목록
```

---

## 4. 화면 간 내비게이션 흐름

```
[앱 시작]
    │
    ▼
login.html ────────────────────── signup.html
    │  ↖ find_id.html                │
    │  ↖ reset_pw.html               │
    │                                ▼
    │                          (가입 완료)
    │                                │
    ▼                                ▼
wedding_date.html  ─────────────────┘
    │
    ▼
main.html  (하단 네비: 홈/일정/예산/커뮤니티/설정)
    ├── schedule.html
    ├── budget.html
    ├── roadmap.html
    │   └── (로드맵 관련)
    ├── guest.html
    ├── memo.html
    │   └── memo_write.html
    ├── ceremony_order.html
    ├── vendor.html
    ├── community.html
    │   ├── community_detail.html
    │   └── community_write.html
    ├── settings.html
    │   ├── user.html
    │   ├── admin.html
    │   ├── privacy.html
    │   └── app_info.html
    └── (파트너 모달, 타임라인 바텀시트 인라인)
```

---

## 5. 공통 동작 (style.js)

공유 스크립트 `style.js`는 페이지 감지(`document.getElementById`로 특정 요소 존재 여부) 후 해당 화면의 로직만 실행하는 단일 파일 구조.

### 공통 유틸
| 함수 | 역할 |
|------|------|
| `setMsg(id, text, type)` | 필드 메시지 설정 (success/error/info 클래스 적용) |
| `setBorder(wrapperId, type)` | 입력창 테두리 상태 변경 (error-border / success-border) |
| `applyPhoneFormat(el)` | 전화번호 자동 하이픈 처리 (`010-xxxx-xxxx`) |

### 페이지별 로직 분기
- **로그인**: 빈 값 검증, Enter 키 제출, 소셜 로그인 alert
- **회원가입**: 아이디 중복확인 시뮬레이션, 비밀번호 강도 계산, 전체 동의 연동, 약관 모달
- **아이디 찾기**: 빈 값 + 이메일 형식 검증, 결과 영역 표시
- **비밀번호 초기화**: 3요소 검증, 결과 영역 표시
- **결혼 예정일**: 달력 렌더링, 날짜 선택, 휠 피커, D-Day 계산
- **메인**: D-Day 계산, 다크모드 토글, 파트너 모달, 타임라인 렌더링/바텀시트
- **일정관리**: 달력 렌더링, 탭 전환, 이벤트 CRUD 모달
- **하객관리**: 카테고리 필터, 통계 업데이트
- **예산관리**: 아코디언, FAB 모달, 금액 포맷
- **메모장**: FAB 메뉴, 바텀시트/모달
- **커뮤니티**: 검색 필터, 탭 필터

### 아이콘 SVG 상수
```js
const EYE_OPEN   = `눈 열린 SVG path`;
const EYE_CLOSED = `눈 닫힌 SVG path (사선 포함)`;
```
비밀번호 가시성 토글 시 아이콘 교체에 사용.

---

