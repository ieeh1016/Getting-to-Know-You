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
- 답변 수정 시작은 기존 내 답변 본문을 draft에 채운다.
- 답변 수정 저장은 같은 question/profile answer key를 덮어쓴다.
- 답변 draft 변경은 repository write를 호출하지 않는다.
- user-triggered 저장 실패는 failed state와 retry action을 만든다.
- retry action은 사용자가 누를 때만 repository write를 다시 호출한다.
- 긴 답변 preview는 접힘/펼침 상태를 controller state에 반영한다.
- 아카이브 필터가 전체/둘 다 답함/닮은 답을 구분한다.
- 밸런스 선택과 다음 질문 이동이 상태에 반영된다.
- 밸런스 마지막 질문 완료는 첫 질문으로 순환하지 않고 홈으로 돌아간다.
- 하루 질문 progress는 같은 space의 두 사용자에게 같은 current question을 제공한다.
- answer reaction은 question/answer owner/reactor 조합당 하나만 저장된다.
- 소개 카드 슬롯 입력이 진행률에 반영된다.
- 위시리스트 좋아요가 둘 다 필터에 반영된다.
- 위시 추가 draft는 제목/종류를 받아 내가 만든 wish를 저장한다.
- 위시 수정/완료/숨김은 각각 1개 wish 문서 갱신으로 표현된다.
- 개인화 설정이 없으면 기본 이름/아바타/초대 문구로 fallback한다.
- 새 Firestore-backed 기능은 명시적 user action당 1 write 이하를 유지한다.

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
- 홈의 긴 답변은 접힌 preview와 `더 보기` 확장을 검증한다.
- `수정하기`를 누르면 답변 화면에 기존 본문이 채워지고 `수정 저장하기`가 보인다.
- 수정 저장 후 홈에서 수정된 본문이 보이고 상대 답변 공개 상태가 유지된다.
- 수정 저장 실패 시 재시도 가능한 오류 문구가 보인다.
- 답변/위시/밸런스 저장 중에는 중복 저장 버튼 입력이 방지된다.
- 아카이브/기록/밸런스/소개 카드/위시 화면 내비게이션을 검증한다.
- 위시 화면의 `하고 싶은 것 담기` CTA는 draft 입력 UI를 열고 새 wish를 카드로 추가한다.
- 반응 버튼은 하나만 선택 상태가 되고 다시 누르면 같은 reaction 문서를 갱신한다.
- 위시 `같이 했어요` 처리 후 완료 상태/메모가 카드에 보인다.
- 개인화 설정 저장 후 홈/초대/마이 화면의 이름과 emoji가 바뀐다.

## Manual Checks

- 모바일 폭 390px 기준에서 텍스트가 잘리지 않는다.
- 웹에서 스크롤, 탭, 상태 표시가 자연스럽다.
- Android/iOS 네이티브 빌드는 v0.1 이후 별도 확인한다.
- Firebase dart-define이 없을 때 release web build가 실패하지 않는다.
- Firebase Console에 계정/Firestore 문서를 만든 뒤 GitHub Pages 배포에서 로그인과 자동 로그인이 동작한다.
- 새 Firebase 계정으로 첫 로그인하면 샘플 기록 없이 빈 상태에서 시작한다.
- Firestore Usage tab에서 수동 smoke test 후 reads/writes가 무료 플랜 예산 안에 있는지 확인한다.
- 긴 답변, 수정 버튼, 저장 피드백이 390px 모바일 폭에서 겹치지 않는다.

## Firestore Free Plan Budget Checks

- v0.6+ optimized cold home/session load target: 10 document reads 이하.
- Archive page target: 30 reads/page 이하 with cursor pagination.
- Wishlist page target: 30 reads/page 이하 with cursor pagination.
- Normal private daily usage target: 500 reads/day 이하, 50 writes/day 이하, 0 deletes/day.
- Warning threshold: 1,000 reads/day 또는 100 writes/day.
- Review/stop threshold: 2,500 reads/day 또는 500 writes/day.
- Keystroke, scroll, tab switch는 Firestore write를 만들지 않는다.
- 답변 submit/edit, balance select, profile slot fill, wish add/edit/done, reaction select는 각각 1 document write 이하.
- Summary/current 갱신이 필요한 action만 2 writes까지 허용한다.
- Home은 전체 answer/wish/profile slot subcollection hydration 없이 summary/progress/today docs로 렌더링 가능해야 한다.
- TTL, backup, PITR, restore, clone, Storage upload, Cloud Functions가 필요한 기능은 Spark/free-plan MVP 테스트 범위에 넣지 않는다.
