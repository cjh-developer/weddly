# Weddly 프로젝트 프레임워크

## 개요

결혼 준비 애플리케이션 **Weddly**의 프론트엔드 및 백엔드 프로젝트 구성.
iOS / Android 앱으로 출시 예정.

---

## 프로젝트 구조

```
weddly/
├── roles/
│   └── framework.md        # 이 파일
├── weddly_frontend/        # Flutter 프론트엔드
└── weddly-backend/         # Spring Boot 백엔드
```

---

## weddly_frontend (Flutter)

| 항목 | 내용 |
|------|------|
| 프레임워크 | Flutter |
| 대상 플랫폼 | iOS, Android |
| 조직 ID | com.weddly |
| 패키지명 | weddly_frontend |
| 진입점 | lib/main.dart |

### 생성 명령

```bash
flutter create --org com.weddly --project-name weddly_frontend --platforms ios,android weddly_frontend
```

---

## weddly-backend (Spring Boot)

| 항목 | 내용 |
|------|------|
| 프레임워크 | Spring Boot 3.5.0 |
| 언어 | Java 17 |
| 빌드 도구 | Gradle |
| Group ID | com.weddly |
| Artifact ID | weddly-backend |
| 패키지명 | com.weddly.backend |
| 진입점 | WeddlyBackendApplication.java |

### 적용 의존성

- Spring Web
- Spring Data JPA
- Spring Security
- Validation
- Lombok

### 생성 방법

Spring Initializr (https://start.spring.io) 를 통해 생성.

---

## 환경 요구사항

| 항목 | 요구 버전 |
|------|----------|
| Flutter | 3.x 이상 |
| Java | 17 이상 (Spring Boot 3.x 필수 요건) |
| Gradle | Spring Boot에 포함된 Gradle Wrapper 사용 |
