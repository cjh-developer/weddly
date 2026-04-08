# Weddly 디자인 시스템 가이드

웨딩 플래닝 앱 **Weddly**의 UI 통일성을 위한 디자인 시스템 문서입니다.
모든 화면은 이 가이드를 기준으로 구현합니다.

---

## 목차

1. [디자인 원칙](#1-디자인-원칙)
2. [색상 시스템](#2-색상-시스템)
3. [타이포그래피](#3-타이포그래피)
4. [간격 시스템](#4-간격-시스템)
5. [모서리·그림자](#5-모서리그림자)
6. [컴포넌트](#6-컴포넌트)
7. [레이아웃](#7-레이아웃)
8. [애니메이션·전환](#8-애니메이션전환)
9. [CSS 클래스 네이밍](#9-css-클래스-네이밍)
10. [아이콘 사용법](#10-아이콘-사용법)
11. [반응형 기준](#11-반응형-기준)
12. [페이지별 패턴](#12-페이지별-패턴)

---

## 1. 디자인 원칙

| 원칙 | 설명 |
|------|------|
| **모바일 퍼스트** | 390×844 기준 Phone Mockup으로 설계, 실제 기기에서 100%로 전환 |
| **럭셔리 미니멀** | 골드(#D4A96A)를 포인트로 한 절제된 고급스러운 UI |
| **한국어 우선** | Apple SD Gothic Neo → Pretendard → Noto Sans KR 순 폰트 폴백 |
| **일관된 상태** | 모든 인터랙티브 요소에 hover / active / focus / disabled 상태 정의 |
| **부드러운 피드백** | 0.15s~0.3s 트랜지션으로 자연스러운 인터랙션 |

---

## 2. 색상 시스템

### 브랜드 색상 (Primary)

| 이름 | 값 | 사용 용도 |
|------|----|-----------|
| Primary | `#D4A96A` | CTA 버튼, 포커스 테두리, 선택 상태 |
| Primary Light | `#E8C07A` | 호버, 그라데이션 시작점 |
| Primary Dark | `#C49050` | 활성, 그라데이션 끝점 |

**Primary 그라데이션**
```css
background: linear-gradient(135deg, #D4A96A, #C49050);
```

**Hero 다크 그라데이션**
```css
background: linear-gradient(130deg, #18110a 0%, #33210a 50%, #a8721e 100%);
```

### 중립 색상 (Neutral)

| 이름 | 값 | 사용 용도 |
|------|----|-----------|
| White | `#ffffff` | 카드 배경, 입력 포커스 배경 |
| Background | `#f8f8f8` | 입력창 기본 배경 |
| Background Alt | `#fafafa` | 카드, 리스트 아이템 배경 |
| Border | `#e8e8e8` | 기본 테두리 |
| Border Light | `#f0f0f0` | 구분선, 모달 헤더 |
| Text Dark | `#222222` | 본문, 중요 텍스트 |
| Text Medium | `#555555` | 보조 텍스트 |
| Text Light | `#888888` | 힌트, 부가 정보 |
| Text Placeholder | `#cccccc` | 입력창 플레이스홀더 |
| Text Muted | `#bbbbbb` | 비활성 버튼, 아이콘 |

### 시맨틱 색상 (Semantic)

| 이름 | 값 | 사용 용도 |
|------|----|-----------|
| Success | `#4caf50` | 검증 성공, 확인 상태 |
| Error | `#f44336` | 검증 실패, 오류 |
| Warning | `#FF9800` | 경고, 보통 강도 |
| Info | `#2196F3` | 정보, 링크 |

### 소셜 로그인 색상

| 서비스 | 배경 | 텍스트 |
|--------|------|--------|
| Google | `#ffffff` / border `#e0e0e0` | `#444444` |
| Kakao | `#FEE500` | `#3C1E1E` |
| Naver | `#03C75A` | `#ffffff` |

---

## 3. 타이포그래피

### 폰트 패밀리

```css
font-family: 'Apple SD Gothic Neo', 'Pretendard', 'Noto Sans KR', sans-serif;
```

### 크기 체계

| 역할 | 크기 | 굵기 | 자간 | 사용처 |
|------|------|------|------|--------|
| Logo Large | `38px` | 800 | `-1px` | 메인 로고 (이탤릭) |
| Logo Small | `15px` | 800 | `-0.5px` | 헤더 내 로고 (이탤릭) |
| Page Title | `18–20px` | 700–800 | `-0.5px` | 페이지 제목 |
| Section Title | `16px` | 700 | `0px` | 섹션 헤더 |
| Body | `14px` | 500–600 | `0px` | 본문 텍스트, 입력값 |
| Label | `13px` | 600 | `0px` | 폼 라벨, 버튼 내 텍스트 |
| Caption | `12px` | 500–600 | `0px` | 검증 메시지, 부가 설명 |
| Micro | `11px` | 500–600 | `0.2px` | 비밀번호 강도 레이블 |

### 줄 높이

- 기본 본문: `1.7`
- 설명 텍스트: `1.75`
- 버튼·태그: `1`

---

## 4. 간격 시스템

모든 여백과 패딩은 아래 토큰 기준으로 사용합니다.

| 토큰 | 값 | 사용처 |
|------|----|--------|
| `xs` | `4px` | 아이콘과 텍스트 사이 |
| `sm` | `8px` | 컴팩트한 요소 간격 |
| `md` | `12px` | 기본 요소 간격 |
| `lg` | `16px` | 폼 그룹, 카드 패딩 |
| `xl` | `20px` | 섹션 내부 패딩, 모달 패딩 |
| `2xl` | `28px` | 화면 좌우 패딩 |
| `3xl` | `40px` | 화면 하단 여백 |

**화면 기본 패딩**
```css
padding: 0 28px 40px; /* 좌우 28px, 하단 40px */
```

**폼 섹션 gap**
```css
gap: 14px; /* 입력 그룹 사이 */
```

---

## 5. 모서리·그림자

### Border Radius

| 토큰 | 값 | 사용처 |
|------|----|--------|
| `sm` | `6px` | 체크박스, 작은 배지 |
| `md` | `10px` | 작은 버튼, 태그 |
| `lg` | `12px` | 입력창, 카드, CTA 버튼 |
| `xl` | `14px` | 중형 카드 |
| `2xl` | `20px` | 모달, Hero 카드, 폰 프레임 |
| `full` | `50%` | 아바타, 원형 아이콘 버튼 |

### Box Shadow

| 역할 | 값 |
|------|----|
| 카드 기본 | `0 2px 10px rgba(0,0,0,0.08)` |
| Primary 버튼 | `0 4px 14px rgba(212,169,106,0.40)` |
| 입력 포커스 | `0 2px 8px rgba(212,169,106,0.15)` |
| 에러 포커스 | `0 2px 8px rgba(244,67,54,0.10)` |
| 성공 포커스 | `0 2px 8px rgba(76,175,80,0.10)` |
| 모달 | `0 20px 60px rgba(0,0,0,0.25)` |
| 폰 프레임 | `0 0 0 2px #d0d0d0, 0 20px 60px rgba(0,0,0,0.25)` |

---

## 6. 컴포넌트

### 6-1. 버튼

#### Primary Button (CTA)
```css
/* .btn-login, .btn-primary */
background: linear-gradient(135deg, #D4A96A, #C49050);
color: #fff;
font-size: 15px;
font-weight: 700;
padding: 16px;
border-radius: 12px;
box-shadow: 0 4px 14px rgba(212,169,106,0.4);
width: 100%;

/* hover */
opacity: 0.92;

/* active */
transform: scale(0.98);
```

#### Secondary Button (Outline)
```css
/* .btn-check, .btn-secondary */
background: #fff;
border: 1.5px solid #D4A96A;
color: #D4A96A;
padding: 0 14px;
border-radius: 10px;

/* hover */
background: #D4A96A;
color: #fff;

/* confirmed */
background: #e8f5e9;
border-color: #4caf50;
color: #4caf50;
```

#### Icon Button
```css
/* .icon-btn */
width: 36px;
height: 36px;
border-radius: 11px;
background: #f8f8f8;
color: #666;

/* hover */
background: #f0e8d8;
color: #D4A96A;
```

#### Skip/텍스트 Button
```css
/* .wd-btn-skip */
background: none;
color: #bbb;
font-size: 13px;

/* hover */
color: #888;
text-decoration: underline;
```

#### 소셜 버튼
```css
/* .btn-social */
background: #fff;
border: 1.5px solid #e0e0e0;
border-radius: 12px;
padding: 13px;
width: 100%;
/* 아이콘 + 라벨 flex row, gap: 10px */

/* hover */
box-shadow: 0 2px 8px rgba(0,0,0,0.10);
```

---

### 6-2. 입력 컴포넌트

#### 구조
```html
<div class="input-group">
  <label class="input-label">이름 <span class="required">*</span></label>
  <div class="input-wrap">
    <!-- 아이콘 (선택) -->
    <span class="input-icon">SVG</span>
    <input type="text" placeholder="..." />
    <!-- 우측 버튼 (선택) -->
  </div>
  <span class="field-msg"></span>
</div>
```

#### Input Wrap 스타일
```css
/* .input-wrap */
background: #f8f8f8;
border: 1.5px solid #e8e8e8;
border-radius: 12px;
transition: border-color 0.2s, box-shadow 0.2s;

/* focus */
border-color: #D4A96A;
background: #fff;
box-shadow: 0 2px 8px rgba(212,169,106,0.15);

/* error */
border-color: #f44336;
box-shadow: 0 2px 8px rgba(244,67,54,0.10);

/* success */
border-color: #4caf50;
box-shadow: 0 2px 8px rgba(76,175,80,0.10);
```

#### Field Message
```css
/* .field-msg */
font-size: 12px;
min-height: 16px;

/* 상태별 color */
.success { color: #4caf50; }
.error   { color: #f44336; }
.info    { color: #888888; }
```

#### 비밀번호 강도 바
```css
/* 높이 4px, 너비 transition 0.35s */
.weak   { background: #f44336; }
.medium { background: #FF9800; }
.strong { background: #4caf50; }
```

---

### 6-3. 체크박스·라디오

#### 커스텀 체크박스
```css
/* .custom-check */
width: 18–20px;
height: 18–20px;
border: 2px solid #ddd;
border-radius: 5–6px;

/* checked */
background: #D4A96A;
border-color: #D4A96A;
/* 흰색 체크마크 (::after) */
```

#### 역할 선택 카드
```css
/* .role-card */
border: 2px solid #eee;
border-radius: 12px;
background: #fafafa;

/* hover */
border-color: #D4A96A;
background: #fffaf4;

/* selected */
background: linear-gradient(135deg, #D4A96A, #C49050);
border-color: #D4A96A;
box-shadow: 0 4px 14px rgba(212,169,106,0.4);
color: #fff;
```

---

### 6-4. 모달

#### 구조
```html
<div class="modal-overlay" id="modal">
  <div class="modal-box">
    <div class="modal-header">
      <span class="modal-title">제목</span>
      <button class="modal-close">✕</button>
    </div>
    <div class="modal-body">내용</div>
    <div class="modal-footer">
      <button class="btn-cancel">취소</button>
      <button class="btn-agree">확인</button>
    </div>
  </div>
</div>
```

#### 스타일
```css
/* .modal-overlay */
position: fixed;
background: rgba(0,0,0,0.5);
z-index: 1000;
display: none; /* .active 클래스로 표시 */

/* .modal-box */
max-width: 360px;
max-height: 80vh;
border-radius: 20px;
box-shadow: 0 20px 60px rgba(0,0,0,0.25);
animation: modalIn 0.22s ease;

/* 각 영역 패딩 */
.modal-header, .modal-body, .modal-footer { padding: 18px 20px; }
```

#### 애니메이션
```css
@keyframes modalIn {
  from { opacity: 0; transform: translateY(16px) scale(0.97); }
  to   { opacity: 1; transform: translateY(0) scale(1); }
}
```

---

### 6-5. 카드

#### 기본 카드
```css
background: #fafafa;
border: 1.5px solid #f0e8d8;
border-radius: 16px;
padding: 24px 20px;
```

#### Hero 카드
```css
background: linear-gradient(130deg, #18110a 0%, #33210a 50%, #a8721e 100%);
border-radius: 20px;
padding: 16px 18px;
/* 내부 오버레이 레이어로 광채 효과 */
```

---

### 6-6. 헤더 (메인 페이지 공통)

```css
/* .main-header, .sch-header, .gh-header 등 */
display: flex;
justify-content: space-between;
align-items: center;
padding: 16px 0 12px;
position: sticky;
top: 0;
background: rgba(255,255,255,0.92);
backdrop-filter: blur(6px);
border-bottom: 1px solid #f0f0f0;
z-index: 100;
```

---

### 6-7. 스텝 바 (회원가입 진행)

```css
/* .step-bar */
display: flex;
align-items: center;
justify-content: center;

/* .step-dot - 각 단계 원형 */
width: 28px;
height: 28px;
border-radius: 50%;
/* active: primary 색상 */

/* .step-line - 단계 사이 선 */
width: 44px;
height: 2px;
background: #eee;
/* active: #D4A96A */
```

---

### 6-8. 캘린더 / 날짜 선택

```css
/* 7열 그리드 */
display: grid;
grid-template-columns: repeat(7, 1fr);

/* 날짜 셀 */
.cal-day: aspect-ratio 1 / 1, flex centered
.cal-today: #D4A96A 색상 강조
.cal-selected: primary 배경

/* 휠 스크롤 선택기 */
/* .wheel-wrap - wheelIn 0.18s ease 애니메이션 */
/* scroll-snap-type: y mandatory; */
/* 상하 페이드 그라데이션 오버레이 */
```

---

## 7. 레이아웃

### Phone Frame (데스크탑 미리보기)

```css
/* .phone-wrap */
width: 390px;
min-height: 844px;
border-radius: 44px;
box-shadow: 0 0 0 2px #d0d0d0, 0 20px 60px rgba(0,0,0,0.25);

/* 노치 (::before) */
width: 120px; height: 30px; border-radius: 0 0 20px 20px;

/* .phone-screen */
padding: 0 28px 40px;
min-height: 814px;
overflow-y: auto;
scrollbar-width: none; /* 스크롤바 숨김 */
```

### 실제 모바일 기기 (max-width: 430px)

```css
/* body */
background: #fff;
padding: 0;

/* .phone-wrap */
width: 100%;
min-height: 100vh;
border-radius: 0;
box-shadow: none;

/* ::before (노치) */
display: none;

/* .phone-screen */
height: 100vh;
```

### 페이지 내 레이아웃 원칙

- 화면 전체는 `flex-direction: column`
- 섹션 간 `gap: 14–16px`
- 좌우 패딩 `28px` (phone-screen 상속)
- 요소 간 정렬은 `flexbox` 기본, 캘린더·그리드는 `CSS Grid`

---

## 8. 애니메이션·전환

### 전환 시간 기준

| 용도 | 시간 |
|------|------|
| 버튼 색상·배경 | `0.15s` |
| 테두리·그림자 | `0.2s` |
| 일반 페이드·슬라이드 | `0.3s` |
| 강도 바 width | `0.35s` |

### Keyframes

```css
/* 모달 등장 */
@keyframes modalIn {
  from { opacity: 0; transform: translateY(16px) scale(0.97); }
  to   { opacity: 1; transform: translateY(0) scale(1); }
}

/* 콘텐츠 페이드업 */
@keyframes fadeUp {
  from { opacity: 0; transform: translateY(12px); }
  to   { opacity: 1; transform: translateY(0); }
}

/* 휠 피커 등장 */
@keyframes wheelIn {
  from { opacity: 0; transform: translateX(-50%) scale(0.95); }
  to   { opacity: 1; transform: translateX(-50%) scale(1); }
}
```

### 버튼 클릭 피드백

```css
/* 모든 CTA 버튼 공통 */
button:active { transform: scale(0.98); transition: transform 0.1s; }
```

---

## 9. CSS 클래스 네이밍

### 접두사 규칙

| 접두사 | 용도 |
|--------|------|
| `phone-` | 폰 프레임 |
| `logo-` | 로고 |
| `btn-` | 버튼 |
| `input-` | 입력 관련 |
| `form-` | 폼 컨테이너 |
| `modal-` | 모달 |
| `step-` | 스텝 인디케이터 |
| `role-` | 역할 선택 |
| `terms-` | 약관 |
| `wd-` | 웨딩 날짜 |
| `main-` | 메인 페이지 |
| `sch-` | 일정 페이지 |
| `gh-` | 하객 페이지 |
| `icon-` | 아이콘 버튼 |
| `notif-` | 알림 |
| `hero-` | Hero 카드 |

### 상태 클래스

| 클래스 | 의미 |
|--------|------|
| `.active` | 활성 상태 |
| `.selected` | 선택 상태 |
| `.confirmed` | 확인된 상태 |
| `.disabled` | 비활성 |
| `.error-border` | 오류 테두리 |
| `.success-border` | 성공 테두리 |
| `.show` | 표시 |
| `.open` | 열림 |
| `.checked` | 체크됨 |

### 유틸리티 클래스

| 클래스 | 의미 |
|--------|------|
| `.flex1` | `flex: 1` |
| `.required` | `color: #D4A96A` 필수 표시 (`*`) |
| `.field-msg` | 폼 메시지 |
| `.divider` | 구분선 |

---

## 10. 아이콘 사용법

- **스타일**: SVG 인라인, Outlined(선형) 스타일
- **stroke-width**: `2`–`2.2`
- **크기**: 컨텍스트에 따라 `17–32px`
- **색상**: 부모 요소 color 상속 또는 직접 지정

### 용도별 크기

| 용도 | 크기 |
|------|------|
| 입력창 아이콘 | `20px` |
| 네비게이션 버튼 | `22px` |
| 소셜 로그인 | `20px` |
| 알림 배지 포함 버튼 | `22px` |
| Hero 카드 장식 | `28–32px` |

### 아이콘 버튼 공통

```html
<button class="icon-btn">
  <svg>...</svg>
  <!-- 알림 배지 (선택적) -->
  <span class="notif-badge">3</span>
</button>
```

---

## 11. 반응형 기준

```css
/* 데스크탑: Phone Mockup 형태 */
/* default → 390px 고정 */

/* 실제 모바일 기기 */
@media (max-width: 430px) {
  /* 폰 프레임 제거, 전체 화면 사용 */
}
```

> 현재는 **단일 브레이크포인트(430px)** 전략입니다.
> 태블릿·데스크탑 레이아웃이 추가될 경우 이 문서를 업데이트합니다.

---

## 12. 페이지별 패턴

### 인증 플로우 공통 구조

```
로고 섹션 (상단 패딩 포함)
├── 페이지 제목 + 설명
├── 폼 섹션 (입력 그룹 반복)
├── 검증 메시지
├── Primary CTA 버튼
└── 보조 링크 (회원가입, 비밀번호 찾기 등)
```

### 메인 페이지 공통 구조

```
고정 헤더 (로고 + 아이콘 버튼)
├── Hero 카드 (웨딩 D-Day)
├── 빠른 메뉴 그리드
├── 섹션별 콘텐츠 카드
└── 하단 여백 (40px)
```

### 인증 결과 화면 패턴

```
아이콘 (성공/실패)
├── 결과 제목
├── 결과 상세 정보 (.result-box)
└── 액션 버튼 (Primary)
```

### 캘린더/날짜 선택 패턴

```
헤더 (월 네비게이션)
├── 요일 헤더 (7열 그리드)
├── 날짜 그리드 (7열)
└── 선택된 날짜 표시
```

---

## 변경 이력

| 날짜 | 내용 |
|------|------|
| 2026-04-08 | 초안 작성 (login, signup, find_id, reset_pw, wedding_date, main, schedule, guest 분석) |
