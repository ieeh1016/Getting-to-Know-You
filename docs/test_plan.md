# Test Plan

> Current source of truth: [spec.md](spec.md). All new behavior must be added to the spec first, then covered by failing tests before production code changes.

## Unit Tests

- `AlagagiAuthRepository`가 짧은 로그인 아이디를 Firebase 이메일로 변환한다.
- fake auth repository가 로그인 성공/실패/로그아웃 상태를 스트림으로 노출한다.
- Firestore-style user data에서 `AlagagiSession`을 구성한다.
- Firebase mode의 빈 Firestore answers snapshot은 샘플 답변이 아닌 empty state로 변환된다.
- Firebase mode의 빈 Firestore wishes snapshot은 샘플 위시가 아닌 empty state로 변환된다.
- Firebase mode의 빈 Firestore profile slots snapshot은 샘플 소개 카드 값이 아닌 locked/empty state로 변환된다.
- 질문 카탈로그는 day/depth 규칙에 맞는 질문만 선택한다.
- 밸런스 결과는 나와 상대의 실제 선택이 모두 있을 때만 계산된다.
- 우리 기록 insight는 실제 답변 데이터만 기반으로 계산한다.
- `AlagagiController` 기본 로컬 모드는 초대 화면에서 시작한다.
- session 기반 controller는 로그인된 홈 화면에서 시작한다.
- 답변 제출/패스가 repository 저장 경계로 전달된다.
- 아카이브 필터가 전체/둘 다 답함/닮은 답을 구분한다.
- 밸런스 선택과 다음 질문 이동이 상태에 반영된다.
- 소개 카드 슬롯 입력이 진행률에 반영된다.
- 위시리스트 좋아요가 둘 다 필터에 반영된다.

## Widget Tests

- Firebase-enabled app이 signed-out 상태에서 로그인 화면을 보여준다.
- 아이디/비밀번호를 입력하고 로그인하면 fake session을 로드해 홈으로 이동한다.
- 기존 auth session이 있으면 로그인 화면을 건너뛰고 홈으로 이동한다.
- 로그인은 실패 시 입력값을 유지하고 오류 문구를 보여준다.
- `users/{uid}` 문서가 없으면 setup required 화면에 UID를 보여준다.
- 로그아웃 버튼을 누르면 로그인 화면으로 돌아온다.
- Firebase mode에서 실제 답변이 없으면 홈/질문함에 샘플 상대 답변이 보이지 않는다.
- Firebase mode에서 실제 기록이 없으면 우리 기록은 0/empty state를 보여준다.
- Firebase mode에서 실제 위시가 없으면 위시리스트는 비어 있고 추천 템플릿만 제안으로 보인다.
- Firebase mode에서 밸런스 선택 전에는 샘플 상대 선택이 보이지 않는다.
- 로컬 데모 모드는 초대 화면과 닉네임 진입을 유지한다.
- 홈은 오늘의 질문과 기록 요약을 보여준다.
- 답변 화면은 글자 수 갱신과 저장 후 상대 답 공개를 검증한다.
- 아카이브/기록/밸런스/소개 카드/위시 화면 내비게이션을 검증한다.

## Manual Checks

- 모바일 폭 390px 기준에서 텍스트가 잘리지 않는다.
- 웹에서 스크롤, 탭, 상태 표시가 자연스럽다.
- Android/iOS 네이티브 빌드는 v0.1 이후 별도 확인한다.
- Firebase dart-define이 없을 때 release web build가 실패하지 않는다.
- Firebase Console에 계정/Firestore 문서를 만든 뒤 GitHub Pages 배포에서 로그인과 자동 로그인이 동작한다.
- 새 Firebase 계정으로 첫 로그인하면 샘플 기록 없이 빈 상태에서 시작한다.
