# Seaman IAM Admin 화면 구조 분석

분석 일자: 2026-04-15  
프로젝트: `D:\project\seaman\seaman-app-custom\bandisnc-webserver-iam-admin-gradle`  
공통모듈 (현재버전): `D:\project\bandisnc-aapp-base\bandisnc-aapp-base3\`  
공통모듈 (구버전): `D:\project\bandisnc-aapp-base\bandisnc-aapp-base\`

---

## 1. 전체 요청 처리 흐름

```
브라우저 요청 (GET /adm/{page})
    │
    ▼
AdminTemplateController  (@GetMapping("/adm/**"))
  └─ AbstractTemplateController (공통)
       └─ TemplateHttpService.getHtml()
            └─ AbstractTemplateHttpService.getHtml()
                 ├─ getPageId(request)          → "ttpl.admin.{page}"
                 ├─ getTemplate(pageId)          → XML에서 템플릿 이름 조회
                 ├─ getPageJs(pageId)            → XML에서 JS 경로 조회
                 ├─ setPublicModel(model, ...)   → 공통 모델 속성 주입
                 └─ return templateName          → Thymeleaf 렌더링
```

**핵심:** URL path에서 page id를 만들어 `bandisnc.template.mappings.xml`에서 템플릿 이름을 찾는 구조.

---

## 2. URL → 페이지 매핑 규칙

| 요청 URL | pageId (XML key) | 템플릿 | JS |
|---------|-----------------|--------|-----|
| `/adm/user` | `ttpl.admin.user` | `admin/adminUser` | `common/admin.user.js` |
| `/adm/iam-user` | `ttpl.admin.iam-user` | `iam/iamUser` | `iam/admin.iamuser.js` |
| `/adm/iam-dept` | `ttpl.admin.iam-dept` | `iam/iamDept` | `iam/admin.iamdept.js` |
| `/adm/dashboard` | `ttpl.admin.dashboard` | `admin/adminDashBoard` | `common/admin.dashBoard.js` |
| `/adm/batch/job/list` | `ttpl.admin.batch/job/list` | `jobadmin/commonJobList` | `batch/bandi.batch.js` |

**basePath 설정:** `bandisnc.site.base.path=/iam` (XML 설정)  
→ `AbstractTemplateHttpService.getPath()`에서 URI에서 `/iam/` 이후 부분을 추출

---

## 3. 라우터 역할 파일 설명

### `resources/config/bandisnc.template.mappings.xml`

모든 페이지의 **템플릿 이름**과 **JS 파일 경로**를 key-value로 관리.

```xml
<!-- 패턴: ttpl.admin.{url-path} = 템플릿경로 -->
<entry key="ttpl.admin.iam-user">iam/iamUser</entry>
<entry key="ttpl.admin.iam-user.js">/webjars/bandijs/${main.js.version}/base/pagejs/iam/admin.iamuser.js</entry>

<!-- 레이아웃 설정 -->
<entry key="bandisnc.site.html.layout">fragments/iamadminlayout</entry>
<entry key="bandisnc.site.base.path">/iam</entry>
```

**주요 설정 키:**
- `bandisnc.site.html.layout` → 전체 레이아웃 HTML (동적으로 `${htmlLayout}`에 주입됨)
- `bandisnc.site.base.path` → URL base path
- `main.js.version` / `main.file.version` → JS 버전 관리
- `ext.js.version` → 외부 라이브러리 버전 JSON

---

## 4. 레이아웃 구조

### `fragments/iamadminlayout.html`

> 실제 위치: `D:\project\bandisnc-aapp-base3\test-server\bandisnc-webserver-iam-admin-gradle\src\main\resources\templates\fragments\iamadminlayout.html`  
> ⚠️ 현재 커스텀 프로젝트(`seaman-app-custom`)에는 이 파일이 없음 → test-server에서 복사하거나 webjar에 포함됨

```
<html layout:decorate 선언 없음 (레이아웃 자체)>
<head>
  ├─ CSS: Bootstrap5, AdminLTE, DataTables, jsTree, tagify, tempus-dominus
  ├─ CSS: bandi.custom.css, site.custom.css (커스텀)
  ├─ JS (선행): first.setup.js, jQuery, i18next, handlebars, forge...
  ├─ JS (bandiJS): bandi.lib.common.js, bandi.web.lib.js
  ├─ JS (Grid/GQL info): common, sso, oauth, saml, iam 계열
  └─ JS (다국어): message_ko.js, message_en.js (common/sso/oauth/saml/iam)
</head>
<body class="layout-fixed sidebar-expand-lg bg-body-tertiary">
  <div class="app-wrapper">
    ├─ fragments/adminheader  → 상단 네비게이션 바 (로그아웃, 언어전환)
    ├─ <aside class="app-sidebar">
    │    └─ th:utext="${navMenu}"  → 동적 사이드바 메뉴 (서버에서 HTML 생성)
    ├─ <main class="app-main">
    │    └─ <div class="app-content">
    │         └─ layout:fragment="content"  ← ★ 각 페이지 콘텐츠 삽입 위치
    └─ fragments/adminfooter
  </div>
  ├─ #page-loading (로딩 모달)
  ├─ ui/cmTpl :: tpl (공통 팝업 템플릿)
  └─ JS (후행): Bootstrap, AdminLTE, DataTables, jstree, cm.ui.*.js
       └─ custom/js/site.custom.js (커스텀 JS)
</body>
```

**`adminlayout.html` vs `iamadminlayout.html` 차이점:**

| 항목 | adminlayout | iamadminlayout |
|------|------------|----------------|
| IAM 전용 JS info | 없음 | iam.*.ui.info.js, iam.*.gql.query.js 포함 |
| IAM 다국어 | 없음 | iam_message_ko.js, iam_message_en.js 포함 |
| cm.duallistbox.js | 없음 | 포함 |
| 사이드바 role 속성 | `role="navigation"` | `role="menu"` |

---

## 5. 각 페이지 콘텐츠 템플릿 구조

모든 페이지 HTML 파일의 공통 패턴:

```html
<!DOCTYPE html>
<html xmlns:layout="http://www.ultraq.net.nz/thymeleaf/layout"
      xmlns:th="http://www.thymeleaf.org"
      layout:decorate="~{${htmlLayout}}">   <!-- ← 레이아웃 동적 선택 -->
<head>
    <title>페이지 제목</title>
</head>
<body>
<!-- layout:fragment="content" 와 frag-content 를 동시에 선언 -->
<!-- GET 요청: layout:fragment="content" 로 전체 페이지 렌더링 -->
<!-- POST 요청: th:fragment="frag-content" 로 콘텐츠 부분만 Ajax 반환 -->
<div layout:fragment="content" th:remove="tag" th:fragment="frag-content">

    <!-- 브레드크럼 -->
    <nav aria-label="breadcrumb">...</nav>

    <!-- 그리드/뷰 컴포넌트 (공통 UI 모듈 참조) -->
    <div th:replace="~{ui/cmGrid :: ui-content ('엔티티명', 'i18n.key')}"></div>

    <!-- 페이지 JS 변수 / 초기화 -->
    <script th:inline="javascript">
        var someConfig = /*[[${modelAttribute}]]*/ 'default';
    </script>
    <script th:src="@{${pageJs}}"></script>  <!-- 동적 JS 로드 -->
</div>
</body>
</html>
```

---

## 6. 레이아웃 선택 메커니즘

```
bandisnc.template.mappings.xml
  └─ bandisnc.site.html.layout = "fragments/iamadminlayout"
        │
        ▼ @Value("${bandisnc.site.html.layout:fragments/adminlayout}")
  AbstractTemplateModelService.htmlLayout = "fragments/iamadminlayout"
        │
        ▼ getDefaultMap() → defaultInfo.put("htmlLayout", getLayout(request))
  model.addAttribute("htmlLayout", "fragments/iamadminlayout")
        │
        ▼ (Thymeleaf Layout Dialect)
  layout:decorate="~{${htmlLayout}}"
  → 실제 파일: classpath:templates/fragments/iamadminlayout.html
```

**관련 파일:**
`D:\project\bandisnc-aapp-base\bandisnc-aapp-base3\common\bandisnc-web-common\src\main\java\com\bandisnc\web\common\service\AbstractTemplateModelService.java`

---

## 7. 사이드바 메뉴 구성

**설정 파일:** `resources/config/bandisnc.menu.settings.xml`

```
menu.type.json = "common, sso, oauth, saml, agent"
menu.json.string = { "common": [...], "sso": [...], ... }
```

**처리 흐름:**
```
MenuNodeService.getList()      → JSON 메뉴 데이터 파싱
PathNodeService.render()       → HTML <ul><li> 트리 생성  
model("navMenu")               → 레이아웃에서 th:utext="${navMenu}"로 출력
```

---

## 8. 현재 프로젝트 페이지 목록

### Common 계열 (`admin/` 템플릿)
| URL path | 템플릿 | 설명 |
|---------|--------|------|
| dashboard | admin/adminDashBoard | 대시보드 |
| user | admin/adminUser | 사용자 |
| admin | admin/adminAdmin | 관리자 |
| client | admin/adminClient | 클라이언트 |
| client-group | admin/adminClientGroup | 클라이언트 그룹 |
| config | admin/adminConfig | 설정 |
| audit-log | admin/adminAuditLog | 감사 로그 |
| statistics | admin/adminStatistics | 통계 |

### IAM 계열 (`iam/` 템플릿)
| URL path | 템플릿 | 설명 |
|---------|--------|------|
| iam-user | iam/iamUser | IAM 사용자 |
| iam-dept | iam/iamDept | 부서 |
| iam-dept-user | iam/iamDeptUser | 부서-사용자 |
| iam-auth | iam/iamAuth | 권한 |
| iam-menu-auth | iam/iamMenuAuth | 메뉴 권한 |
| position / grade / job / duty / usertype | iam/cmCode | 공통코드 (동일 템플릿) |
| my-page | iam/myPage | 마이페이지 |
| request-join | iam/iamRequestJoin | 가입 신청 |
| request-auth | iam/iamRequestAuth | 권한 신청 |
| entity-history | iam/cmEntityHistory | 엔티티 변경이력 |

### SSO/OAuth/SAML/Batch 계열
| URL path | 템플릿 | 설명 |
|---------|--------|------|
| auth-code | admin/adminAuthCode | SSO 인증코드 |
| token-info | admin/adminTokenInfo | SSO 토큰 |
| scope | admin/adminScope | OAuth 스코프 |
| saml-sp | admin/adminSamlSp | SAML SP |
| batch/job/list | jobadmin/commonJobList | 배치 잡 목록 |

---

## 9. 커스텀 파일 위치 (seaman-app-custom)

화면 수정 시 관련 파일들:

```
bandisnc-webserver-iam-admin-gradle/src/main/
├─ resources/
│   ├─ config/
│   │   ├─ bandisnc.template.mappings.xml  ★ 페이지 라우팅 (새 페이지 추가 시 수정)
│   │   └─ bandisnc.menu.settings.xml      ★ 사이드바 메뉴 (메뉴 추가 시 수정)
│   ├─ messages/
│   │   ├─ custom-message_ko.properties    ← 커스텀 한국어 메시지
│   │   └─ custom-message_en.properties    ← 커스텀 영어 메시지
│   └─ static/ (커스텀 정적 파일)
└─ java/com/bandisnc/
    ├─ web/admin/controller/
    │   └─ AdminTemplateController.java    ← 화면 라우터 (거의 수정 불필요)
    └─ custom/ (커스텀 비즈니스 로직)
```

**공통모듈 경로 정리:**
```
D:\project\bandisnc-aapp-base\bandisnc-aapp-base3\
├─ common\
│   ├─ bandisnc-webui\src\main\resources\templates\   ★ 실제 참조 webui
│   │   ├─ fragments/
│   │   │   ├─ iamadminlayout.html  ✅ 여기에 있음
│   │   │   ├─ adminlayout.html     (기본 레이아웃)
│   │   │   ├─ adminheader.html
│   │   │   └─ adminfooter.html
│   │   ├─ admin/        → 공통 관리자 페이지들
│   │   ├─ iam/          → IAM 페이지들
│   │   ├─ jobadmin/     → 배치 관리 페이지들
│   │   └─ ui/           → 공통 UI 컴포넌트 (cmGrid, cmView, cmTree 등)
│   └─ bandisnc-web-common\  ★ htmlLayout 주입 서비스 포함
│       └─ AbstractTemplateModelService.java
└─ (iam, sso, oauth, saml 등 다른 공통모듈들)

D:\project\bandisnc-aapp-base\bandisnc-aapp-base\common\   (구버전 공통모듈)
└─ bandisnc-web-common\
    └─ AbstractTemplateHttpService.java  (구버전)
```

---

## 10. 새 페이지 추가 방법

1. **템플릿 HTML 파일 생성** (`classpath:templates/` 하위)
   - `layout:decorate="~{${htmlLayout}}"` 선언
   - `layout:fragment="content"` + `th:fragment="frag-content"` 동시 선언

2. **`bandisnc.template.mappings.xml`에 매핑 추가**
   ```xml
   <entry key="ttpl.admin.새페이지명">경로/템플릿명</entry>
   <entry key="ttpl.admin.새페이지명.js">/webjars/bandijs/.../새페이지.js</entry>
   ```

3. **`bandisnc.menu.settings.xml`에 메뉴 추가** (사이드바 표시 필요 시)
   ```json
   { "i18nTitle": "menu.key", "path": "새페이지명", "icon": "mdi-...", "children": [] }
   ```

4. **JS 파일 작성** (bandijs webjar 또는 커스텀 static 경로)

---

## 11. GET vs POST 동작 차이

| 구분 | GET `/adm/{page}` | POST `/adm/{page}` |
|------|------------------|--------------------|
| 반환 | 전체 HTML (layout 포함) | `frag-content` 프래그먼트만 |
| 용도 | 최초 페이지 진입 | Ajax 동적 콘텐츠 갱신 |
| 로그인 미처리 | login 페이지로 redirect | 401 + adminBlank 반환 |

---

## 12. aapp vs aapp3 버전 구조 및 htmlLayout 주입 검증

### 로컬 소스 vs 실제 배포 jar 구분

| 구분 | 경로 | 역할 |
|------|------|------|
| aapp 로컬 소스 | `bandisnc-aapp-base\bandisnc-aapp-base\common\` | 구버전 소스 (실제 배포 안 됨) |
| aapp3 로컬 소스 | `bandisnc-aapp-base\bandisnc-aapp-base3\common\` | 차세대 버전 (Jakarta/Spring Boot 4.0.2/Java17, 배포 안 됨) |
| **Nexus 배포 jar** | `commonVersion=1.8.5` | **seaman이 실제로 사용하는 버전** |

> ⚠️ 로컬 소스와 실제 배포 jar는 다를 수 있음. 반드시 Gradle 캐시의 실제 jar 소스로 확인할 것.  
> 캐시 경로: `%USERPROFILE%\.gradle\caches\modules-2\files-2.1\com.bandisnc\`

### 실제 jar 기준 htmlLayout 주입 흐름

`bandisnc-web-common:1.8.5` (Gradle 캐시 sources.jar 확인):
- `AbstractTemplateHttpService` → `templateModelService.setTemplateModel()` 호출 ✅
- `AbstractTemplateModelService.getDefaultMap()` → `htmlLayout` 주입 ✅

```
AdminTemplateController
  └─ IamTemplateHttpService          (bandisnc-web-iam:1.8.5, javax)
       └─ AbstractTemplateHttpService (bandisnc-web-common:1.8.5)
            └─ templateModelService.setTemplateModel()
                 └─ AbstractTemplateModelService.getDefaultMap()
                      └─ defaultInfo.put("htmlLayout", getLayout(request))
                           ↓
                      @Value("${bandisnc.site.html.layout:fragments/adminlayout}")
                      → "fragments/iamadminlayout"  (XML 설정값)
                           ↓
                      webui 3.0.4 템플릿의 ${htmlLayout} 정상 주입 ✅
```

### 결론

seaman 프로젝트는 **정상 구성**:
- `bandisnc-web-common:1.8.5` jar가 이미 `htmlLayout` 주입 로직 포함
- webui 3.0.4 템플릿의 `${htmlLayout}` → `fragments/iamadminlayout` 정상 연결
- aapp 로컬 소스의 구버전 코드를 보고 "없다"고 판단하면 오류 → 실제 jar 기준으로 확인해야 함

---

## 13. 화면 수정 절차 (케이스별 상세 가이드)

> **공통 원칙**: seaman-app-custom 프로젝트의 로컬 파일이 webjar(공통모듈) 파일보다 **classpath 우선순위**가 높다.  
> → 공통 파일을 직접 수정하지 말고, 프로젝트 내 동일 경로에 복사 후 수정할 것.

---

### Case 1. 전역 CSS 수정 (모든 페이지에 적용)

**목적:** 사이트 전체 디자인, 색상, 폰트, 공통 요소 스타일 변경

**수정 파일:**
```
src/main/resources/static/custom/css/site.custom.css
```

**특이사항:**
- 이 파일은 이미 `iamadminlayout.html`에 `<link rel="stylesheet" th:href="@{/custom/css/site.custom.css}">` 로 포함되어 있음
- 추가 파일이 필요하면 → `iamadminlayout.html` 오버라이드(Case 3) 후 `<link>` 태그 추가

**절차:**
1. `site.custom.css` 파일을 열어 스타일 추가/수정
2. 서버 재시작 또는 static 캐시 갱신 후 확인

---

### Case 2. 전역 JS 수정 (모든 페이지에 적용되는 공통 JS)

**목적:** 전체 페이지에 공통으로 실행할 JS 로직 추가 (예: 공통 이벤트, 전역 함수 등)

**수정 파일:**
```
src/main/resources/static/custom/js/site.custom.js
```

**현재 파일 패턴 (비어 있는 상태):**
```javascript
(function(bandiJS) {
    "use strict";
    // 여기에 공통 JS 로직 작성
})(window.bandiJS = window.bandiJS || {});
```

**특이사항:**
- `iamadminlayout.html` body 최하단에 `<script th:src="@{/custom/js/site.custom.js}">` 로 포함되어 있음
- 모든 라이브러리(jQuery, bandiJS 등)가 로드된 이후에 실행됨

**절차:**
1. `site.custom.js` 파일에 공통 로직 작성
2. `window.bandiJS` 네임스페이스 또는 `$(document).ready()` 패턴 사용

---

### Case 3. 레이아웃 수정 (헤더/사이드바/푸터/공통 JS 추가)

**목적:** 전체 페이지 구조 변경 - 헤더/사이드바/푸터 HTML 수정, 공통 CSS/JS 추가

**원본 파일 위치:**
```
D:\project\bandisnc-aapp-base\bandisnc-aapp-base3\common\bandisnc-webui\src\main\resources\templates\fragments\iamadminlayout.html
```

**작업 절차:**

1. **원본 파일 복사**: 위 경로의 `iamadminlayout.html`을 프로젝트에 동일 경로로 복사
   ```
   src/main/resources/templates/fragments/iamadminlayout.html   ← 새로 생성
   ```

2. **복사한 파일 수정**: 원하는 부분만 변경
   - 헤더 수정: `th:replace="~{fragments/adminheader :: header}"` 부분 또는 헤더 직접 inline 처리
   - 사이드바 수정: `<aside class="app-sidebar">` 내부 `th:utext="${navMenu}"` 주변 구조 변경
   - 공통 CSS 추가: `</head>` 직전에 `<link>` 태그 추가
   - 공통 JS 추가: `</body>` 직전에 `<script>` 태그 추가

3. **동작 원리**: Thymeleaf classpath 로딩 순서
   ```
   classpath:templates/ (프로젝트 로컬)   ← 우선순위 높음 ★
   classpath:templates/ (webjar 내부)     ← 우선순위 낮음
   ```
   → 로컬에 `fragments/iamadminlayout.html`이 존재하면 webjar 버전은 무시됨

4. **주의사항**: 공통모듈(webui) 버전 업그레이드 시 원본 변경사항을 수동으로 병합해야 함

---

### Case 4. 기존 공통 페이지 내용 수정

**목적:** webui에 있는 공통 페이지(예: `iam/iamUser.html`, `admin/adminUser.html`)의 HTML 구조나 내용 변경

**원본 파일 위치 (예: IAM 사용자 페이지):**
```
D:\project\bandisnc-aapp-base\bandisnc-aapp-base3\common\bandisnc-webui\src\main\resources\templates\iam\iamUser.html
```

**작업 절차:**

1. **원본 파일 확인**: `bandisnc-aapp-base3\common\bandisnc-webui\src\main\resources\templates\` 하위에서 해당 파일 찾기
   - `bandisnc.template.mappings.xml`의 value 값 = 템플릿 경로 (예: `iam/iamUser` → `iam/iamUser.html`)

2. **프로젝트에 동일 경로로 복사**:
   ```
   src/main/resources/templates/iam/iamUser.html   ← 새로 생성
   ```
   > ⚠️ 경로가 정확히 같아야 Thymeleaf가 오버라이드 인식

3. **복사한 파일 수정**: 원하는 부분만 변경
   - `layout:decorate="~{${htmlLayout}}"` 선언 유지 필수
   - `layout:fragment="content"` 와 `th:fragment="frag-content"` 동시 선언 유지 필수

4. **확인**: 서버 재시작 후 해당 URL 접근 시 수정된 내용 적용 확인

**오버라이드 가능한 주요 템플릿 경로들:**
```
templates/
├─ fragments/iamadminlayout.html    → 전체 레이아웃
├─ fragments/adminheader.html       → 헤더
├─ fragments/adminfooter.html       → 푸터
├─ admin/adminUser.html             → 사용자 관리
├─ admin/adminDashBoard.html        → 대시보드
├─ iam/iamUser.html                 → IAM 사용자
├─ iam/iamDept.html                 → IAM 부서
├─ iam/myPage.html                  → 마이페이지
└─ ui/cmGrid.html                   → 공통 그리드 UI
```

---

### Case 5. 새 페이지 추가

**목적:** 현재 없는 새로운 URL 경로와 화면 추가

**전체 절차 (4단계):**

#### 5-1. 템플릿 HTML 파일 생성
```
src/main/resources/templates/{카테고리}/{페이지명}.html
```

**필수 구조:**
```html
<!DOCTYPE html>
<html xmlns:layout="http://www.ultraq.net.nz/thymeleaf/layout"
      xmlns:th="http://www.thymeleaf.org"
      layout:decorate="~{${htmlLayout}}">
<head>
    <title>페이지 제목</title>
</head>
<body>
<div layout:fragment="content" th:remove="tag" th:fragment="frag-content">

    <!-- 브레드크럼 (선택) -->
    <div class="app-content-header">
        <div class="container-fluid">
            <div class="row">
                <div class="col-sm-6"><h3 class="mb-0">페이지 제목</h3></div>
            </div>
        </div>
    </div>

    <!-- 실제 콘텐츠 -->
    <div class="app-content">
        <div class="container-fluid">
            <!-- 여기에 HTML 작성 -->
        </div>
    </div>

    <!-- 페이지 JS -->
    <script th:src="@{${pageJs}}"></script>
</div>
</body>
</html>
```

#### 5-2. `bandisnc.template.mappings.xml`에 매핑 추가
```
src/main/resources/config/bandisnc.template.mappings.xml
```
```xml
<!-- 템플릿 경로 등록 -->
<entry key="ttpl.admin.{url-path}">{카테고리}/{페이지명}</entry>

<!-- JS 파일 경로 등록 (커스텀 static JS 사용 시) -->
<entry key="ttpl.admin.{url-path}.js">/custom/pagejs/{페이지명}.js</entry>
```

> **URL 규칙**: `/iam/adm/{url-path}` → `ttpl.admin.{url-path}`  
> (basePath `/iam` 제거 후 `/adm/` 이후 부분이 key suffix)

#### 5-3. `bandisnc.menu.settings.xml`에 메뉴 항목 추가 (사이드바 노출 필요 시)
```
src/main/resources/config/bandisnc.menu.settings.xml
```
```json
{
    "i18nTitle": "menu.새메뉴키",
    "path": "{url-path}",
    "icon": "mdi mdi-account",
    "children": []
}
```
- `i18nTitle`: 다국어 메시지 키 (messages 파일에도 추가 필요)
- `path`: `{url-path}` 그대로 (basePath는 자동 결합)
- `icon`: MaterialDesignIcons 클래스명

#### 5-4. 페이지 JS 파일 생성 (필요 시)
```
src/main/resources/static/custom/pagejs/{페이지명}.js
```
```javascript
$(document).ready(function() {
    // 페이지 초기화 로직
});
```

---

### Case 6. 사이드바 메뉴만 추가/수정

**목적:** 기존 페이지에 대한 사이드바 링크 추가, 메뉴 순서 변경, 메뉴 이름 변경

**수정 파일:**
```
src/main/resources/config/bandisnc.menu.settings.xml
```

**메뉴 JSON 구조:**
```json
{
    "menu.json.string": {
        "common": [
            {
                "i18nTitle": "menu.dashboard",
                "path": "dashboard",
                "icon": "mdi mdi-speedometer",
                "children": []
            }
        ],
        "iam": [
            {
                "i18nTitle": "menu.iam.user",
                "path": "iam-user",
                "icon": "mdi mdi-account-multiple",
                "children": [
                    {
                        "i18nTitle": "menu.iam.dept",
                        "path": "iam-dept",
                        "icon": "mdi mdi-sitemap"
                    }
                ]
            }
        ]
    }
}
```

**메뉴 이름 변경 시**: `i18nTitle` 키에 해당하는 messages 파일도 함께 수정

---

### Case 7. 다국어 메시지 추가/수정

**두 종류의 메시지 시스템:**

#### 7-1. Java 서버측 메시지 (Spring MessageSource)
```
src/main/resources/messages/custom-message_ko.properties  ← 한국어
src/main/resources/messages/custom-message_en.properties  ← 영어
```
```properties
# 사이드바 메뉴 이름, 서버 에러 메시지 등
menu.new.page=새 페이지
error.custom.001=커스텀 오류 메시지
```

#### 7-2. 클라이언트 JS 메시지 (i18next)
```
src/main/resources/static/custom/locales/custom_message_ko.js  ← 한국어
src/main/resources/static/custom/locales/custom_message_en.js  ← 영어
```
```javascript
// custom_message_ko.js
i18next.addResourceBundle('ko', 'translation', {
    "custom.label.newField": "새 항목",
    "custom.btn.save": "저장",
    "custom.msg.saveSuccess": "저장되었습니다."
}, true, true);
```

> **참고**: 이 JS 파일들은 `iamadminlayout.html`에 이미 포함되어 있음  
> `<script th:src="@{/custom/locales/custom_message_ko.js}"></script>`

---

### Case 8. 페이지별 JS 수정 (공통 JS 오버라이드 없이)

**목적:** 특정 페이지의 버튼 동작, 그리드 설정, 초기화 로직만 변경

**방법 A: 해당 페이지 JS 파일 직접 교체**
1. `bandisnc.template.mappings.xml`에서 해당 페이지의 `.js` 키 확인
   ```xml
   <entry key="ttpl.admin.iam-user.js">/webjars/bandijs/3.0.4/base/pagejs/iam/admin.iamuser.js</entry>
   ```
2. `.js` 값을 커스텀 파일 경로로 변경:
   ```xml
   <entry key="ttpl.admin.iam-user.js">/custom/pagejs/admin.iamuser.js</entry>
   ```
3. `src/main/resources/static/custom/pagejs/admin.iamuser.js` 파일 생성 후 로직 작성

**방법 B: 템플릿 HTML 오버라이드 후 추가 script 삽입** (Case 4 참조)
- 페이지 HTML을 오버라이드한 뒤 `<script>` 블록을 직접 추가

---

### 수정 케이스 요약표

| 목적 | 수정 파일 | 비고 |
|------|----------|------|
| 전체 CSS 스타일 | `static/custom/css/site.custom.css` | 추가 파일은 layout 오버라이드 필요 |
| 전체 공통 JS | `static/custom/js/site.custom.js` | 라이브러리 로드 후 실행 |
| 헤더/사이드바/푸터 HTML | `templates/fragments/iamadminlayout.html` 복사·수정 | webui 원본에서 복사 |
| 공통 페이지 내용 | `templates/{경로}/{파일}.html` 복사·수정 | webui 원본에서 복사 |
| 새 페이지 추가 | template 생성 + mappings.xml + menu.xml + JS | 4단계 모두 필요 |
| 사이드바 메뉴 변경 | `config/bandisnc.menu.settings.xml` | i18n 키도 함께 확인 |
| JS 메시지 | `static/custom/locales/custom_message_ko/en.js` | i18next addResourceBundle |
| 서버 메시지 | `messages/custom-message_ko/en.properties` | Spring MessageSource |
| 특정 페이지 JS 교체 | mappings.xml JS 키 값 변경 + static JS 파일 생성 | - |
