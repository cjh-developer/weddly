
결혼준비 애플리케이션 WEDDLY DB SCHEMA 정보를 관리합니다.

#### 공통 사항

##### 공통 컬럼
>created_at : 생성일
  created_by : 생성자
  updated_at : 수정일
  updated_by : 수정자

#### DB 설계 원칙
- PK : auto-increment 금지 -> SecureRandom 포함 14자리 문자열(oid)
- FK : 전부 제거 -> 관계 컬럼 INDEX만 부여, 참조 무결성은 Service 트랜잭션으로 관리
- 테이블 접두사 : wdl_
- 문자셋 : utf_8 통일

### 테이블 목록

| 테이블 ID                      | 테이블 명                     | 설명  |
| --------------------------- | ------------------------- | --- |
| wdl_cm_admin                | 관리자 테이블                   |     |
| wdl_cm_user                 | 사용자 테이블                   |     |
| wdl_cm_alk                  | 대체로그인 정보 테이블              |     |
| wdl_cm_schedule             | 일정관리 테이블                  |     |
| wdl_cm_couple               | 커플 관리 테이블                 |     |
| wdl_cm_budget               | 예산 관리 테이블                 |     |
| wdl_cm_budget_category      | 예산 카테고리 관리 테이블            |     |
| wdl_cm_wedding              | 기본 웨딩 관리 테이블              |     |
| wdl_cm_wedding_custom       | 커스텀 웨딩 관리 테이블             |     |
| wdl_cm_wedding_phase        | 웨딩 로드맵 개월/기간 단위 구조 관리     |     |
| wdl_cm_wedding_custom_phase | 커스텀 웨딩 로드맵 개월/기간 단위 구조 관리 |     |
| wdl_cm_wedding_task         | 웨딩 로드맵 템플릿 업무 상세          |     |
| wdl_cm_wedding_custom_task  | 웨딩 로드맵 템플릿 업무 상세          |     |
| wdl_cm_wedding_file         | 웨딩 관리 내 파일 관리 테이블         |     |
| wdl_cm_customer             | 하객 관리 테이블                 |     |
| wdl_cm_studio               | 스튜디오 업체 관리 테이블            |     |
| wdl_cm_dress                | 드레스 업체 관리 테이블             |     |
| wdl_cm_makeup               | 메이크업 업체 관리 테이블            |     |
| wdl_cm_planner              | 플래너 업체 관리 테이블             |     |
| wdl_cm_hall                 | 웨딩홀 관리 테이블                |     |
| wdl_cm_appliance            | 가전 업체 관리 테이블              |     |
| wdl_cm_cam                  | 촬영 업체 관리 테이블              |     |
| wdl_cm_notice               | 이용약관 / 동의서 정보 관리 테이블      |     |
| wdl_cm_cumm                 | 커뮤니티 관리 테이블               |     |
| wdl_cm_cumm_post            | 커뮤니티 게시글 관리 테이블           |     |
| wdl_cm_cumm_comment         | 커뮤니티 댓글 관리 테이블            |     |
| wdl_cm_cumm_like            | 좋아요/싫어요 관리 테이블            |     |
| wdl_cm_cumm_file            | 커뮤니티 파일 업로드 테이블           |     |
| wdl_cm_cumm_tag             | 커뮤니티 태그 관리 테이블            |     |
| wdl_cm_icon                 | 아이콘 관리 테이블                |     |
| wdl_cm_memo                 | 메모 테이블                    |     |
| wdl_cm_memo_folder          | 메모 폴더 테이블                 |     |
| wdl_cm_memo_tag             | 메모 태그 테이블                 |     |
| wdl_cm_memo_file            | 메모 첨부 파일 테이블              |     |
| wdl_cm_memo_share           | 메모 공유 테이블                 |     |
| wdl_cm_config               | 애플리케이션 설정 테이블             |     |
| wdl_cm_version              | 애플리케이션 버전 관리 테이블          |     |
| wdl_cm_token                | JWT 토큰 관리 테이블             |     |
| wdl_cm_role                 | 권한 테이블                    |     |
| wdl_cm_user_role            | 사용자 권한 테이블                |     |
| wdl_cm_status               | 사용자 상태 코드 관리 테이블          |     |
| wdl_cm_code                 | 공통 코드 관리 테이블              |     |
| wdl_cm_log                  | 애플리케이션 로그 관리 테이블          |     |
| wdl_cm_audit_log            | 등록/수정/삭제 등 로그 관리 테이블      |     |
| wdl_cm_notifications        | 알림 / 메시지 관리 테이블           |     |
| wdl_cm_login_history        | 로그인 이력 관리 테이블             |     |
| wdl_cm_password_history     | 비밀번호 이력 관리 테이블            |     |
테이블 생성 예시
#####  wdl_cm_admin

| 컬럼ID          | 컬럼명       | 타입      | 크기   | NULL 여부  | PK 여부 | 설명               |
| ------------- | --------- | ------- | ---- | -------- | ----- | ---------------- |
| oid           | 객체ID      | varchar | 255  | not null | pk    |                  |
| user_id       | 관리자 ID    | varchar | 255  | not null |       |                  |
| name          | 관리자명      | varchar | 255  | not null |       | defualt : weddly |
| password      | 비밀번호      | varchar | 1000 | not null |       |                  |
| password_salt | 비밀번호 SALT | varchar | 255  | null     |       |                  |
| created_at    | 생성일       | date    |      |          |       | sysdate          |
| created_by    | 생성자       | varchar | 255  |          |       |                  |
| updated_at    | 수정일       | date    |      |          |       | sysdate          |
| updated_by    | 수정자       | varchar | 255  |          |       |                  |


#####  wdl_cm_user

| 컬럼 ID         | 컬럼명       | 타입      | 크기   | NULL 여부  | PK 여부 | 설명                                    |
| ------------- | --------- | ------- | ---- | -------- | ----- | ------------------------------------- |
| oid           | 객체ID      | varchar | 255  | not null | PK    |                                       |
| user_id       | 사용자ID     | varchar | 255  | not null |       |                                       |
| name          | 사용자명      | varchar | 255  | not null |       |                                       |
| password      | 비밀번호      | varchar | 1000 | not null |       |                                       |
| password_salt | 비밀번호 salt | varchar | 255  | null     |       |                                       |
| hand_phone    | 휴대번호      | varchar | 255  | not null |       |                                       |
| email         | 이메일       | varchar | 255  | not null |       |                                       |
| user_type     | 사용자 유형    | char    | 1    | not null |       | 신랑 : M / 신부 : W                       |
| use_yn        | 사용 여부     | char    | 1    | not null |       | 사용 : Y / 미사용 : N                      |
| status        | 사용 상태     | varchar | 50   | not null |       | 활성 : ACTIVE / 휴먼 : SLEEPER / 탈퇴 : OUT |
| created_at    | 생성일       | date    |      |          |       | sysdate                               |
| created_by    | 생성자       | varchar | 255  |          |       |                                       |
| updated_at    | 수정일       | date    |      |          |       | sysdate                               |
| updated_by    | 수정자       | varchar | 255  |          |       |                                       |





