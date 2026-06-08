# 알아가기 Product Spec

## 0. Source

- Reference board: `/Users/admin/AndroidStudioProjects/skylife-ux3.0/webapp-design/index.html`
- Primary visual direction: `design2.html` 시안 2, Modern Minimal
- Included flow screens: `invite.html`, `design2.html`, `answer.html`, `archive.html`, `us.html`
- Included plus screens: `balance.html`, `card.html`, `wishlist.html`, `features.html`
- Alternative visual references: `design1.html`, `design3.html`

## 1. Product Summary

`알아가기`는 소개팅 이후 두 사람이 부담 없이 서로를 알아가도록 돕는 비공개 모바일 웹앱이다.
사용자는 링크 하나로 들어오고, 민영과 영우에게만 발급된 아이디/비밀번호로 로그인해 시작한다.
앱은 매일 하나의 질문, 가벼운 밸런스 선택, 천천히 채워지는 소개 카드, 함께 해보고 싶은 위시리스트를 통해 관계가 서두르지 않고 자연스럽게 깊어지도록 설계한다.

현재 Flutter 앱 `민영 Pick`은 `알아가기` 컨셉으로 전체 리디자인한다.
데이트 후보 선택/쿠폰 중심 구조는 제거하거나 후순위로 내리고, 질문 기반의 친밀감 형성 경험을 핵심으로 삼는다.

## 2. Product Goals

- 링크만 열어도 바로 이해되는 둘만의 초대 경험을 만든다.
- 매일 하나의 질문에 답하는 가벼운 루틴을 만든다.
- 내 답을 남기면 상대 답이 열리는 구조로 상호성을 만든다.
- 답하지 않아도 괜찮은 무압박 흐름을 제공한다.
- 쌓인 답변에서 닮은 키워드와 기록을 보여준다.
- “다음 만남”으로 이어질 수 있는 위시리스트를 자연스럽게 제공한다.

## 3. Non Goals

- 공개 소셜 네트워크
- 여러 명이 쓰는 커뮤니티
- 실시간 채팅
- 위치 추적
- 연락 빈도 분석
- 과한 커플앱/기념일앱 톤
- App Store 배포 필수 기능
- 공개 회원가입
- 비밀번호 찾기/이메일 인증 자동화
- 관리자 화면

## 4. Target Users

### Primary User

- 소개팅 이후 호감은 있지만 아직 관계가 확정되지 않은 사람
- 직접적인 고백이나 커플앱보다 가볍고 센스 있는 장치를 선호하는 사람
- 모바일 링크로 부담 없이 들어와 짧게 답할 수 있는 경험을 원하는 사람

### Relationship Stage

- 소개팅 이후 1-4주
- 서로를 더 알고 싶지만 과하게 빠른 친밀감 표현은 피해야 하는 단계
- 앱 표현은 “우리 사귀자”가 아니라 “천천히 알아가 볼래요?”에 머물러야 한다.

## 5. Tone Principles

- 부드럽다: 명령형보다 초대형 문장을 사용한다.
- 조용하다: 과도한 이모지, 알림, 축하 효과를 줄인다.
- 안전하다: 언제든 패스/그만두기 가능하다는 감각을 준다.
- 상호적이다: 한 사람이 일방적으로 관찰하는 느낌을 피한다.
- 천천히 깊어진다: 처음부터 가치관/속마음 질문으로 들어가지 않는다.

### Preferred Copy

- `우리, 천천히 알아가 볼래요?`
- `하루에 질문 하나, 서로의 이야기를 나누는 작고 조용한 공간이에요.`
- `정답은 없어요. 떠오르는 대로, 솔직한 한 줄이면 충분해요.`
- `내 답을 남기면 함께 열려요.`
- `오늘은 답하기 어렵나요? 내일 다시 보기`
- `생각보다 결이 잘 맞는 사이예요`

### Avoided Copy

- `여자친구 앱`
- `커플 전용`
- `사랑 지수`
- `상대 추적`
- `답장 안 했어요`
- `왜 답하지 않았나요?`

## 6. Visual Direction

### Chosen Direction

Reference `design2.html`: Modern Minimal, sage, warm paper, serif title.

### Visual Keywords

- 세이지 미니멀
- 종이 같은 배경
- 낮은 대비의 따뜻함
- serif headline
- 조용한 카드형 정보
- 작은 점 형태의 bottom navigation indicator

### Color Tokens

- Background outer: `#e9e8e2`
- App background: `#f4f3ef`
- Paper: `#fcfcfa`
- Ink: `#2e2e2c`
- Muted: `#9a9890`
- Sage: `#8a9a7e`
- Sage deep: `#6f7f63`
- Lavender accent: `#b9a8c9`
- Line: `#e8e6df`
- Soft sage fill: `#dfe6d4`
- Sage panel: `#cdd6c2`

### Typography

- Display/heading reference: `Nanum Myeongjo`
- Body reference: `Noto Sans KR`
- Flutter implementation should use available fonts first.
- If external font assets are not added in MVP, use system fallback while preserving weight, spacing, and hierarchy.

### Layout

- Mobile first.
- Design target width: 390px.
- Minimum target viewport height: 840px.
- Main content should be constrained around 390-520px on desktop web.
- Cards use 18-24px radius in this specific design system, matching the reference.
- Bottom navigation is fixed at bottom with translucent paper background.
- Avoid nested cards except where the reference explicitly frames a phone preview or a repeated list item.

## 7. Information Architecture

### Primary Navigation

- 홈
- 질문함
- 기록
- 마이

### Expanded Navigation For Plus Features

For MVP, plus features can be reached from home sections or lightweight cards.
If the app grows, bottom navigation may become:

- 홈
- 질문함
- 카드
- 위시

`기록` can remain reachable from 홈/질문함 or be a tab depending on implementation complexity.

## 8. MVP Scope

### MVP v0.2 In Scope

- 초대장 화면
- 닉네임 입력
- 홈 화면
- 오늘의 질문 카드
- 답변 입력/저장
- 내 답 저장 후 상대 답 공개 상태 표현
- 오늘은 패스
- 질문함 목록
- 우리 기록 화면
- 밸런스 게임 1세트
- 소개 카드 화면
- 언젠가 같이 위시리스트 화면
- 로컬 메모리 상태 기반 화면 전환
- Flutter widget/unit tests

### MVP v0.2 Out Of Scope

- 실제 초대 링크 생성
- 실제 다중 사용자 동기화
- 푸시 알림
- 사진 업로드
- 플레이리스트 연동
- 쪽지함
- 타임캡슐 편지
- 실제 로그인/인증
- 데이터 암호화/보안 저장소

### MVP v0.3 Firebase Private In Scope

- Firebase Auth 기반 민영/영우 전용 로그인
- 아이디 입력값을 내부 Firebase 이메일로 매핑
  - `youngwoo` -> `youngwoo@gettoknow.local`
  - `minyoung` -> `minyoung@gettoknow.local`
- Firebase Auth 브라우저 persistence 기반 자동 로그인
- 로그아웃
- 로그인 후 Firestore `users/{uid}` 프로필 문서 로드
- `users/{uid}` 문서가 없으면 UID와 설정 안내를 보여주는 setup required 상태
- Firestore `spaces/{spaceId}` 멤버 공간 모델
- 답변, 패스, 소개 카드 슬롯, 위시 좋아요의 repository 저장 경계
- Firebase dart-define 값이 없을 때 로컬 데모 모드로 빌드/테스트 가능

### MVP v0.3 Firebase Private Out Of Scope

- 앱 안에서 계정 생성
- 비밀번호 변경/초기화 UI
- 소셜 로그인
- 푸시 알림
- 사진 업로드
- 관리자용 데이터 편집 UI
- 완전한 오프라인 충돌 병합

### MVP v0.4 Real Content & Data Cleanup In Scope

- Firebase 모드에서 기존 샘플 기록 데이터 제거
- 질문/밸런스/소개 카드 슬롯/위시 템플릿을 실제 콘텐츠 카탈로그로 정리
- 사용자 생성 데이터는 Firestore를 단일 출처로 사용
- Firestore 데이터가 없을 때는 샘플을 대신 보여주지 않고 빈 상태를 보여준다.
- 오늘의 질문은 실제 질문 카탈로그에서 날짜/순번/depth 기준으로 선택한다.
- 아카이브는 실제 저장된 답변/패스만 보여준다.
- 우리 기록은 실제 답변 수, 함께 답한 수, 닮은 키워드 기반으로 계산한다.
- 밸런스 게임은 실제 선택 전에는 상대 선택을 노출하지 않는다.
- 소개 카드는 실제 작성한 슬롯만 채워진 상태로 보여준다.
- 위시리스트는 실제 추가/좋아요/완료 데이터만 보여준다.

### MVP v0.4 Real Content & Data Cleanup Out Of Scope

- AI 질문 생성
- 외부 캘린더/지도/예약 연동
- 사진 답변 저장
- 푸시 알림 기반 질문 리마인더
- 관리자 CMS
- 다수 커플/다수 공간 운영

### Dummy Data Policy

- `seedMyAnswers`, `seedPartnerAnswers`, `seedInsight`, `seedWishes`처럼 실제 두 사람이 만들지 않은 기록은 Firebase 모드에서 노출하지 않는다.
- 질문 카탈로그, 밸런스 질문, 소개 카드 슬롯 정의, 위시 추천 문구는 제품 콘텐츠이므로 로컬 정적 카탈로그로 유지할 수 있다.
- 테스트 fixture는 test 디렉터리 안에서만 사용하고, 운영 UI에 흘러들어오면 안 된다.
- Firebase dart-define이 없는 로컬 데모 모드는 개발 확인용 fixture를 사용할 수 있지만, 화면이나 문서에서 demo/local 모드임을 구분해야 한다.
- 배포 빌드는 Firebase 설정이 존재하면 반드시 real-data mode로 동작해야 한다.

## 9. Core User Flow

```mermaid
flowchart TD
  A["Login: 링크 진입"] --> B{"Firebase Auth 세션 있음?"}
  B -->|없음| C["민영/영우 전용 로그인"]
  B -->|있음| D["Firestore 프로필 로드"]
  C --> D
  D --> E{"users/{uid} 있음?"}
  E -->|없음| F["Setup Required: UID와 Console 안내"]
  E -->|있음| G["Home: 오늘의 질문 확인"]
  G --> H["Answer: 내 답 작성"]
  H --> I{"답 제출"}
  I --> J["상대 답 열림 또는 대기 상태"]
  G --> K["Archive: 지난 질문 보기"]
  G --> L["Us: 닮은 키워드와 기록 보기"]
  G --> M["Plus: 밸런스/카드/위시"]
```

### v0.2 Legacy Local Flow

```mermaid
flowchart TD
  A["Invite: 링크 진입"] --> B["닉네임 입력"]
  B --> C["Home: 오늘의 질문 확인"]
  C --> D["Answer: 내 답 작성"]
  D --> E{"답 제출"}
  E --> F["상대 답 열림 또는 대기 상태"]
  C --> G["Archive: 지난 질문 보기"]
  C --> H["Us: 닮은 키워드와 기록 보기"]
  C --> I["Plus: 밸런스/카드/위시"]
```

## 10. Screens

### 10.0 Login Screen

Reference: `invite.html`

Purpose:

- Firebase Auth 세션이 없을 때 민영과 영우만 앱에 들어오게 한다.
- 기존 초대장 디자인의 부드러운 분위기를 유지하되, 닉네임 입력 대신 아이디/비밀번호를 받는다.
- 로그인 성공 후에는 Firestore 프로필을 불러와 나와 상대 이름을 정확히 보여준다.

Required UI:

- Status row mock or safe top spacing
- Seal icon area
- Kicker: `A L A G A G I`
- Hero headline: `우리, 천천히 알아가 볼래요?`
- Helper copy: `민영과 영우만 들어올 수 있어요.`
- Login ID field
- Password field
- CTA: `로그인`
- Soft error copy area
- Fine print: `한 번 로그인하면 다음엔 자동으로 이어서 들어와요`

State:

- Signed out
- Signing in
- Invalid id/password error
- Signed in but profile document missing
- Firebase not configured local demo mode

Acceptance Criteria:

- Firebase가 설정된 배포 빌드에서 첫 진입 시 로그인 화면이 보인다.
- `youngwoo` 또는 `minyoung` 아이디는 내부적으로 `@gettoknow.local` 이메일로 매핑된다.
- 로그인 성공 후 `users/{uid}` 문서를 로드하고 홈으로 이동한다.
- 이미 Firebase Auth 세션이 있으면 로그인 화면을 건너뛰고 홈으로 이동한다.
- `users/{uid}` 문서가 없으면 UID와 Firebase Console 설정 안내를 보여준다.
- 로그인 실패 시 입력값을 유지하고 부드러운 오류 문구를 보여준다.
- 비밀번호는 Firestore, app state, local repository에 저장하지 않는다.
- Firebase dart-define 값이 없으면 로컬 데모 모드로 기존 화면을 볼 수 있다.

### 10.1 Invite Screen

Reference: `invite.html`

Purpose:

- 링크를 처음 열었을 때 앱의 분위기와 안전한 사용 방식을 알려준다.
- 가입 없이 닉네임만 입력해 시작하게 한다.

Required UI:

- Status row mock or safe top spacing
- Seal icon area
- Kicker: `A L A G A G I`
- Hero headline: `우리, 천천히 알아가 볼래요?`
- Inviter copy: `{inviterName}님이 당신을 초대했어요.`
- Note rows:
  - 하루에 딱 하나
  - 둘만의 공간
  - 천천히 가까워지기
- Nickname field
- CTA: `우리 공간으로 들어가기`
- Fine print: `가입 절차 없이 바로 시작해요 · 언제든 그만둘 수 있어요`

State:

- Empty nickname
- Prefilled nickname
- Submit disabled or soft validation when nickname is empty
- Submit moves to Home

Acceptance Criteria:

- 첫 진입 시 `우리, 천천히 알아가 볼래요?`가 보인다.
- 닉네임을 입력하고 CTA를 누르면 홈으로 이동한다.
- 닉네임이 비어 있으면 앱은 강하게 막지 않고 부드러운 안내를 보여준다.

### 10.2 Home Screen

Reference: `design2.html`

Purpose:

- 매일 돌아오는 메인 화면.
- 오늘의 질문, 내 답/상대 답 상태, 관계 기록 요약을 한눈에 보여준다.

Required UI:

- Header title: `알아가기`
- Notification dot or icon
- Progress strip:
  - `DAY 12 · 서로의 12번째 질문`
  - `오늘도 한 걸음 가까워졌어요`
  - two avatar markers
- Today question label
- Question card:
  - question number
  - `TODAY'S QUESTION`
  - question text
  - my answer preview
  - partner answer locked/waiting state
  - one-line answer field or CTA
- Insight cards:
  - 마음의 결 percentage
  - 주고받은 질문 count
  - 닮은 취향 키워드
- Bottom navigation

State:

- Not answered today
- My answer saved, partner waiting
- Both answered, partner answer visible
- Today skipped

Acceptance Criteria:

- 홈에 `오늘의 질문`과 질문 번호가 보인다.
- 내 답이 없으면 답변 CTA가 보인다.
- 내 답이 있으면 내 답 preview가 보인다.
- 상대 답이 잠겨 있으면 `내 답을 남기면 함께 열려요` 계열 문구가 보인다.
- 기록 요약으로 닮음 퍼센트, 질문 수, 키워드가 보인다.

### 10.3 Answer Screen

Reference: `answer.html`

Purpose:

- 오늘의 질문에 집중해서 답을 남긴다.
- 답변 후 상대 답을 공개하거나 대기 상태를 보여준다.
- 답변을 강제하지 않고 패스할 수 있게 한다.

Required UI:

- Back button
- Title: `오늘의 질문`
- Day indicator
- Large question number
- Question text
- Answer editor
- Character count, max 300
- Hint card
- Partner answer locked box
- Skip link: `내일 다시 보기`
- Submit CTA: `답 남기고 {partnerName}님 답 열어보기`

State:

- Draft answer
- Character count
- Submitted answer
- Skipped today
- Partner answer locked
- Partner answer revealed

Acceptance Criteria:

- 답변 입력 시 글자 수가 갱신된다.
- 300자를 넘으면 제출을 막거나 초과 상태를 안내한다.
- 제출 후 내 답이 저장된다.
- 상대 답이 준비된 경우 상대 답이 열린다.
- 상대 답이 없는 경우 대기 상태가 유지된다.
- 패스 선택 시 홈으로 돌아가며 오늘 질문은 skipped 상태가 된다.

### 10.4 Archive Screen

Reference: `archive.html`

Purpose:

- 주고받은 질문과 답변을 다시 볼 수 있게 한다.
- 필터로 전체, 둘 다 답함, 닮은 답을 나눠 본다.

Required UI:

- Header: `질문함`
- Subtitle: `그동안 주고받은 {count}개의 이야기`
- Tabs:
  - 전체
  - 둘 다 답함
  - 닮은 답
- QA list items:
  - question number
  - date label
  - status
  - question text
  - my answer
  - partner answer
  - similarity badge when applicable
- Waiting card for current unanswered partner state

State:

- All
- Both answered
- Similar only
- Waiting partner answer
- Empty archive

Acceptance Criteria:

- `전체` 탭은 모든 질문을 보여준다.
- `둘 다 답함` 탭은 양쪽 답이 있는 항목만 보여준다.
- `닮은 답` 탭은 similarity badge가 있는 항목만 보여준다.
- 상대 답 대기 항목은 답변 내용을 보여주지 않고 locked/waiting copy를 보여준다.

### 10.5 Us Record Screen

Reference: `us.html`

Purpose:

- 두 사람의 누적 기록과 닮은 키워드를 보여준다.
- “잘 맞네” 하는 작은 즐거움을 제공한다.

Required UI:

- Header: `우리 기록`
- Subtitle: `{days}일 동안 우리가 닮아온 이야기`
- Hero similarity percentage
- Copy: `생각보다 결이 잘 맞는 사이예요`
- Matched keyword chips
- Stats:
  - 함께한 날
  - 주고받은 질문
  - 닮은 답
  - 가장 긴 답
- Timeline:
  - date
  - event sentence
  - highlighted keyword
- Bottom navigation

Acceptance Criteria:

- 닮음 퍼센트가 홈과 같은 기준으로 표시된다.
- 닮은 키워드가 칩 형태로 보인다.
- 타임라인은 최신순으로 표시된다.
- 기록이 없으면 빈 상태 문구를 보여준다.

### 10.6 Balance Game Screen

Reference: `balance.html`

Purpose:

- 글을 쓰지 않아도 1초 안에 취향을 표현하게 한다.
- 답 안 하는 날을 줄이는 가벼운 장치다.

Required UI:

- Header: `밸런스 게임`
- Progress: `{current} / {total}`
- Question: `둘 중 하나만!`
- Two option cards
- VS marker
- Selected state for me
- Partner choice indicator
- Result summary
- Progress dots
- Next question button

State:

- Before selection
- My selected option
- Partner selected same option
- Partner selected different option
- Next balance question

Acceptance Criteria:

- 선택 전에는 두 선택지가 동일한 가중치로 보인다.
- 하나를 선택하면 선택 상태가 표시된다.
- 상대 선택이 있으면 결과 문장이 표시된다.
- 다음 질문을 누르면 다음 밸런스 질문으로 이동한다.

### 10.7 Profile Card Screen

Reference: `card.html`

Purpose:

- 상대의 정보를 한 번에 묻지 않고 하루 한 칸씩 채워간다.
- 시간이 지나며 상대가 또렷해지는 느낌을 준다.

Required UI:

- Header: `소개 카드`
- Subtitle: `하루 한 칸씩, 서로가 또렷해져요`
- Segmented control:
  - `{partnerName}님 카드`
  - `내 카드`
- Profile card:
  - avatar
  - name
  - days subtitle
  - fill progress
  - slots
- Locked slots
- Today fill card
- Fill input and CTA

State:

- Partner card
- My card
- Filled slot
- Locked slot
- Today fill prompt

Acceptance Criteria:

- 채워진 칸 수와 전체 칸 수가 보인다.
- 잠긴 칸은 내용을 숨기고 열린 날짜/조건을 안내한다.
- 오늘 채울 칸에 답하면 해당 칸이 채워진다.
- 탭 전환 시 상대 카드와 내 카드가 바뀐다.

### 10.8 Wishlist Screen

Reference: `wishlist.html`

Purpose:

- 같이 해보고 싶은 것을 부담 없이 담는다.
- 실제 만남으로 이어질 자연스러운 다리를 만든다.

Required UI:

- Header: `언젠가, 같이`
- Subtitle: `부담 없이 적어두는 우리의 위시리스트`
- Filters:
  - 전체
  - 둘 다
  - 가고 싶은 곳
  - 해보고 싶은 것
- Groups:
  - 둘 다 하고 싶어요
  - 한 명이 담아둔 것
  - 이미 함께했어요
- Wish cards:
  - icon
  - title
  - who added
  - liked/hearted state
  - done state
- Add button: `하고 싶은 것 담기`

State:

- All wishes
- Mutual wishes
- Place wishes
- Activity wishes
- Done wishes
- Add wish draft
- Toggle heart
- Mark as done

Acceptance Criteria:

- 둘 다 선택한 wish는 별도 강조된다.
- 한 명만 담은 wish는 heart action이 가능하다.
- 완료된 wish는 흐리게 처리되고 취소선이 보인다.
- Add CTA는 새 wish draft flow로 이어진다.

## 11. Real Data Source Policy

### Static Product Content

아래 데이터는 두 사람이 작성한 기록이 아니라 앱이 제공하는 제품 콘텐츠다.

- Daily question catalog
- Balance question catalog
- Profile card slot catalog
- Wishlist starter templates
- Empty state copy
- Locked/waiting state copy

Static product content can live in code for MVP, but it must be named as catalog data, not seed history.

### User Generated Data

아래 데이터는 반드시 Firestore에서 읽고 쓴다.

- Answers
- Skipped answers
- Balance selections
- Profile card slot values
- Wishlist items
- Wish likes
- Wish done state

Firebase mode must never fabricate these records.

### Empty States

- 오늘의 답변 없음: `아직 오늘 답을 남기지 않았어요.`
- 상대 답변 없음: `{partnerName}님이 답하면 함께 열려요.`
- 질문함 비어 있음: `아직 쌓인 질문이 없어요. 오늘의 질문부터 천천히 시작해요.`
- 우리 기록 비어 있음: `기록은 답이 쌓이면 자연스럽게 만들어져요.`
- 밸런스 선택 없음: `둘 중 끌리는 쪽을 골라볼까요?`
- 소개 카드 비어 있음: `오늘 한 칸만 채워도 충분해요.`
- 위시리스트 비어 있음: `같이 해보고 싶은 걸 하나만 담아볼까요?`

Acceptance Criteria:

- Firebase mode에서 Firestore answer 문서가 없으면 샘플 답변이 보이지 않는다.
- Firebase mode에서 Firestore wish 문서가 없으면 샘플 wish card가 보이지 않는다.
- Firebase mode에서 상대가 아직 답하지 않았으면 샘플 상대 답변이 보이지 않는다.
- Firebase mode에서 실제 데이터가 없어도 홈, 질문함, 기록, 밸런스, 카드, 위시는 모두 빈 상태로 자연스럽게 렌더링된다.

## 12. Real Content Catalog

### 12.1 Daily Question Catalog v1

Question IDs are stable and must not be reused for different text.

| ID | Day | Depth | Question | Intent |
| --- | ---: | --- | --- | --- |
| q001 | 1 | light | 하루 중 가장 좋아하는 시간은 언제예요? | 부담 없는 취향 |
| q002 | 2 | light | 요즘 자주 듣는 노래가 있나요? | 음악 취향 |
| q003 | 3 | light | 쉬는 날 혼자 시간이 생기면 제일 먼저 뭘 하고 싶어요? | 휴식 방식 |
| q004 | 4 | light | 카페를 고를 때 제일 먼저 보는 건 뭐예요? | 공간 취향 |
| q005 | 5 | light | 산책한다면 어떤 분위기의 길이 좋아요? | 산책 취향 |
| q006 | 6 | light | 요즘 유난히 먹고 싶은 음식이 있어요? | 음식 취향 |
| q007 | 7 | light | 갑자기 하루가 비면 어디에 가보고 싶어요? | 즉흥 취향 |
| q008 | 8 | daily | 오늘 하루가 괜찮았다고 느끼는 순간은 언제예요? | 일상 감각 |
| q009 | 9 | daily | 기분 전환이 필요할 때 보통 뭘 해요? | 회복 루틴 |
| q010 | 10 | daily | 최근에 나를 웃게 한 작은 일이 있었나요? | 긍정 기억 |
| q011 | 11 | daily | 완벽한 주말 아침을 그려본다면 어떤 모습이에요? | 생활 리듬 |
| q012 | 12 | daily | 일이 끝난 뒤 제일 편해지는 루틴은 뭐예요? | 퇴근 이후 |
| q013 | 13 | daily | 요즘 새롭게 관심이 생긴 게 있나요? | 현재 관심사 |
| q014 | 14 | daily | 나를 편하게 해주는 말이나 행동은 뭐예요? | 편안함 |
| q015 | 15 | beliefs | 어떤 사람과 있을 때 마음이 편해져요? | 관계 기준 |
| q016 | 16 | beliefs | 약속에서 은근히 중요하게 생각하는 게 있다면요? | 만남 기준 |
| q017 | 17 | beliefs | 처음엔 잘 안 보이지만 가까워지면 드러나는 내 모습은? | 자기 이해 |
| q018 | 18 | beliefs | 마음에 드는 공간들은 어떤 공통점이 있어요? | 감각의 이유 |
| q019 | 19 | beliefs | 오래 기억에 남는 다정함은 어떤 종류예요? | 다정함의 기준 |
| q020 | 20 | beliefs | 요즘 나에게 필요한 속도는 어느 정도인 것 같아요? | 관계 속도 |
| q021 | 21 | beliefs | 관계에서 서두르고 싶지 않은 부분이 있다면요? | 안전한 경계 |
| q022 | 22 | inner | 힘든 날에는 티가 나는 편이에요, 조용해지는 편이에요? | 감정 표현 |
| q023 | 23 | inner | 마음이 놓인다고 느끼는 순간은 언제예요? | 안정감 |
| q024 | 24 | inner | 내가 좋아하는 애정 표현은 어떤 쪽에 가까워요? | 애정 언어 |
| q025 | 25 | inner | 요즘 나를 가장 많이 움직이게 하는 건 뭐예요? | 동기 |
| q026 | 26 | inner | 천천히 가까워지면 알려주고 싶은 내 모습이 있나요? | 자기 개방 |
| q027 | 27 | inner | 언젠가 같이 해보고 싶은 작은 장면이 있다면요? | 다음 만남 |
| q028 | 28 | inner | 지금 우리 사이에서 고마운 점을 하나만 적는다면요? | 상호 감사 |

Question rules:

- Day 1-7은 light만 노출한다.
- Day 8-14는 daily까지 허용한다.
- Day 15-21은 beliefs까지 허용한다.
- Day 22 이후 inner를 허용한다.
- 사용자가 패스한 질문은 archive에 skipped 상태로 남기되, 다음 날 질문 진행을 막지 않는다.
- 같은 질문은 같은 space에서 한 번만 오늘의 질문으로 배정한다.

### 12.2 Balance Question Catalog v1

| ID | Prompt | Left | Right | Intent |
| --- | --- | --- | --- | --- |
| b001 | 여행을 떠난다면? | 조용한 바다 | 푸른 숲길 | 여행 취향 |
| b002 | 쉬는 날엔? | 집에서 충전 | 밖에서 산책 | 휴식 방식 |
| b003 | 카페를 고른다면? | 조용한 분위기 | 디저트 맛집 | 공간 선택 |
| b004 | 영화를 본다면? | 잔잔한 영화 | 많이 웃는 영화 | 콘텐츠 취향 |
| b005 | 만나기 좋은 시간은? | 낮 브런치 | 저녁 산책 | 만남 시간 |
| b006 | 데이트 계획은? | 미리 예약 | 즉흥 발견 | 계획 성향 |
| b007 | 대화 분위기는? | 깊은 이야기 | 가벼운 수다 | 대화 리듬 |
| b008 | 메뉴를 고른다면? | 익숙한 맛집 | 새로운 곳 | 음식 모험도 |

Rules:

- 상대 선택은 내가 선택한 뒤에만 보여준다.
- 둘 다 선택하기 전에는 결과 문장을 만들지 않는다.
- 같은 선택이면 `닮은 취향`, 다르면 `서로 다른 취향`으로만 표현하고 점수화하지 않는다.

### 12.3 Profile Card Slot Catalog v1

| Slot ID | Label | Unlock | Input Hint |
| --- | --- | --- | --- |
| song | 요즘 노래 | Day 2 | 요즘 자주 듣는 노래 |
| food | 먹고 싶은 음식 | Day 6 | 요즘 먹고 싶은 음식 |
| rest | 쉬는 방식 | Day 9 | 쉬고 싶을 때 하는 일 |
| cafe | 카페 취향 | Day 10 | 좋아하는 카페 분위기 |
| walk | 산책 취향 | Day 12 | 걷고 싶은 길 |
| comfort | 편해지는 순간 | Day 14 | 나를 편하게 하는 것 |
| promise | 약속에서 중요한 것 | Day 16 | 은근히 중요하게 보는 것 |
| kindness | 기억나는 다정함 | Day 19 | 오래 남는 다정함 |
| pace | 나에게 맞는 속도 | Day 20 | 요즘 필요한 속도 |
| wish_scene | 같이 해보고 싶은 장면 | Day 27 | 언젠가 같이 하고 싶은 것 |

Rules:

- 민감정보를 강제로 묻지 않는다.
- 나이, 연락처, 주소, 회사, 학교, 실명 추가 정보는 MVP 슬롯에 포함하지 않는다.
- 슬롯은 하루에 하나만 채우는 느낌을 유지한다.
- 잠긴 슬롯은 내용 대신 unlock hint를 보여준다.

### 12.4 Wishlist Starter Templates v1

Templates are suggestions, not saved wishes.

| Template ID | Kind | Title |
| --- | --- | --- |
| wt001 | cafe | 조용한 카페에서 커피 마시기 |
| wt002 | food | 서로 좋아하는 음식 하나씩 먹어보기 |
| wt003 | walk | 해 질 때 가볍게 산책하기 |
| wt004 | culture | 작은 전시 보러 가기 |
| wt005 | activity | 영화 보고 천천히 이야기하기 |
| wt006 | place | 한 번도 안 가본 동네 걸어보기 |
| wt007 | food | 늦은 저녁 따뜻한 국물 먹기 |
| wt008 | activity | 필름 사진 서로 찍어주기 |

Rules:

- 템플릿은 사용자가 누르기 전까지 Firestore wish가 아니다.
- wish는 `createdByProfileId`, `likedByProfileIds`, `done`, `createdAt`, `updatedAt`을 가진다.
- 둘 다 좋아요한 wish만 mutual group에 들어간다.

## 13. Future Feature Board

Reference: `features.html`

### Priority P1

- 질문 깊이 단계화
- 밸런스 게임
- 소개 카드
- 위시리스트

### Priority P2

- 상대 답 맞춰보기
- 오늘의 기분 한 단어
- 사진 한 장으로 답하기

### Priority P3

- 함께 만드는 플레이리스트
- 한 줄 쪽지함
- 타임캡슐 편지

### Question Depth Ladder

- 1주차: 가벼운 취향
- 2주차: 일상
- 3주차: 생각과 가치관
- 4주차 이후: 속마음

Acceptance Criteria:

- 질문 데이터는 depth level을 가진다.
- 홈은 현재 day/week에 맞는 질문을 보여준다.
- 깊은 질문은 초반 day에는 노출하지 않는다.

## 14. Domain Model Draft

```dart
class AuthUser {
  final String uid;
  final String loginId;
  final String email;
}

class AppProfile {
  final String id;
  final String nickname;
  final String avatar;
  final bool isMe;
}

class DailyQuestion {
  final String id;
  final int day;
  final int number;
  final QuestionDepth depth;
  final String text;
  final String highlightedText;
}

class Answer {
  final String questionId;
  final String profileId;
  final String body;
  final DateTime createdAt;
  final bool skipped;
}

class ArchiveItem {
  final DailyQuestion question;
  final Answer? myAnswer;
  final Answer? partnerAnswer;
  final List<String> matchedKeywords;
}

class RelationshipInsight {
  final int daysTogether;
  final int questionCount;
  final int matchCount;
  final int longestAnswerLength;
  final int similarityPercent;
  final List<String> matchedKeywords;
  final List<TimelineEvent> timeline;
}

class BalanceQuestion {
  final String id;
  final int index;
  final String prompt;
  final BalanceOption left;
  final BalanceOption right;
}

class ProfileSlot {
  final String id;
  final String label;
  final String? value;
  final bool locked;
  final String? unlockHint;
}

class WishItem {
  final String id;
  final String title;
  final WishKind kind;
  final String createdByProfileId;
  final Set<String> likedByProfileIds;
  final bool done;
}

class AlagagiSession {
  final String spaceId;
  final AppProfile me;
  final AppProfile partner;
}
```

## 14.1 Firebase Data Model

### Authentication

- Firebase Auth Email/Password provider를 사용한다.
- 실제 로그인 UI에는 이메일 대신 짧은 아이디를 노출한다.
- UI 아이디는 repository에서만 이메일로 변환한다.
- 자동 로그인은 Firebase Auth의 기본 브라우저 persistence를 사용한다.

### Firestore Collections

`users/{uid}`

```json
{
  "displayName": "민영",
  "avatar": "🪻",
  "role": "guest",
  "spaceId": "main",
  "partnerUid": "{youngwooUid}"
}
```

`spaces/{spaceId}`

```json
{
  "name": "알아가기",
  "memberIds": ["{youngwooUid}", "{minyoungUid}"]
}
```

`spaces/{spaceId}/answers/{questionId_uid}`

```json
{
  "questionId": "q12",
  "profileId": "{uid}",
  "body": "노을 질 때가 좋아요.",
  "createdLabel": "오늘",
  "skipped": false,
  "updatedAt": "serverTimestamp"
}
```

`spaces/{spaceId}/balanceSelections/{questionId_uid}`

```json
{
  "questionId": "b001",
  "profileId": "{uid}",
  "optionId": "sea",
  "updatedAt": "serverTimestamp"
}
```

`spaces/{spaceId}/profileCards/{profileId}/slots/{slotId}`

```json
{
  "id": "song",
  "label": "요즘 노래",
  "icon": "🎧",
  "value": "요즘 자주 듣는 노래",
  "locked": false,
  "updatedAt": "serverTimestamp"
}
```

`spaces/{spaceId}/wishes/{wishId}`

```json
{
  "title": "조용한 영화관 가기",
  "kind": "activity",
  "createdByProfileId": "{uid}",
  "likedByProfileIds": ["{uid}"],
  "done": false,
  "updatedAt": "serverTimestamp"
}
```

### Repository Boundaries

- `AuthRepository` owns sign-in, sign-out, current auth stream, and login-id-to-email mapping.
- `AlagagiDataRepository` owns session/profile load and user-generated writes.
- `AlagagiController` owns screen state and domain transitions, but delegates persistence writes to the repository when present.
- Widget tests use fake repositories; Firebase SDK is not required for ordinary test execution.

## 15. App State Draft

```dart
class AlagagiState {
  final AppProfile me;
  final AppProfile partner;
  final AppRoute route;
  final DailyQuestion todayQuestion;
  final Map<String, Answer> answersByQuestionAndProfile;
  final ArchiveFilter archiveFilter;
  final int activeBalanceIndex;
  final ProfileCardTab profileCardTab;
  final WishlistFilter wishlistFilter;
}
```

## 16. Test Strategy

### Unit Tests

- Login id to Firebase email mapping
- Auth repository success/failure state with fake auth
- Session construction from Firestore-style profile data
- Firebase mode maps empty Firestore snapshots to empty UI state, not seed history
- Question catalog day/depth selection
- Balance result visibility waits for both real selections
- Relationship insight is computed from real answers only
- Invite nickname validation
- Daily question selection by day/depth
- Answer submit and skip state
- Partner answer visibility rule
- Archive filtering
- Similarity keyword aggregation
- Balance selection result
- Profile card fill progress
- Wishlist filter and mutual matching

### Widget Tests

- Firebase-enabled app shows login when signed out
- Successful login loads a fake session and enters home
- Existing fake auth session skips login and enters home
- Missing profile document shows setup required state with UID
- Logout returns to login
- Firebase mode with no answers shows empty archive and no sample partner answer
- Firebase mode with no wishes shows empty wishlist and no sample wish cards
- Firebase mode with no profile slot values shows locked/empty profile card slots
- Invite shows headline and enters home after nickname submit
- Home shows today question and record summary
- Answer screen updates character count and saves answer
- Archive tabs filter list
- Us record renders stats and timeline
- Balance option selection updates selected state
- Profile card tab switches card content
- Wishlist filter shows mutual wishes

### Visual/Manual Checks

- 390px mobile viewport
- Desktop constrained mobile layout
- Bottom navigation does not cover content
- Long Korean text wraps without overflow
- Disabled/locked states are readable
- No page feels like a public landing page
- Login screen follows `invite.html` visual mood and does not feel like a generic admin form

## 17. Implementation Plan

### Step 1: Spec Lock

- Keep this document as the source of truth.
- Update `docs/sdd.md` to point to this new direction after user approval.

### Step 2: Domain First

- Rename product concepts from `MinyoungPick` to `Alagagi` or `GettingToKnow`.
- Add question, answer, insight, balance, profile card, wishlist models.
- Write unit tests for state transitions before UI refactor.

### Step 3: UI Shell

- Create app theme tokens from section 6.
- Create phone-width responsive shell.
- Add simple local route state.
- Build bottom navigation.

### Step 4: Core Screens

- Invite
- Home
- Answer
- Archive
- Us Record

### Step 5: Plus Screens

- Balance
- Profile Card
- Wishlist

### Step 6: Polish

- Copy pass
- Responsive QA
- Widget test coverage
- `flutter test`
- `flutter analyze`

### Step 7: Firebase Private Login

- Update spec first with auth/session/data model.
- Write fake-auth unit/widget tests before production code.
- Add Firebase config through dart-defines.
- Implement AuthGate, LoginScreen, SetupRequiredScreen.
- Add repository interfaces and Firebase-backed implementations.
- Preserve local demo mode when Firebase config is absent.
- Document Firebase Console setup in `docs/firebase_setup.md`.
- Verify `flutter test`, `flutter analyze`, and release web build.

### Step 8: Real Data Cleanup

- Update this spec first with real data policy and content catalog.
- Write tests proving Firebase mode does not show sample answers, sample insights, sample wishes, or fake partner selections.
- Rename seed content that remains valid product content to catalog content.
- Move user-generated state reads to Firestore repository.
- Add empty states for archive, records, balance, profile card, and wishlist.
- Keep local demo fixtures isolated from Firebase mode.

## 18. Migration Notes From Current App

Current app:

- `민영 Pick`
- date option cards
- random date idea panel
- preference chips
- coupon toggles

New app:

- `알아가기`
- invite and nickname
- daily question and answer
- archive
- relationship record
- balance/profile/wishlist plus features

Migration decision:

- Remove date option selection from the primary MVP.
- Reuse the idea of “위시리스트” as the new home for future date ideas.
- Remove coupon concept from MVP.
- Preserve mobile-first Flutter Web approach.
- Preserve SDD/TDD workflow.
- Remove sample relationship history from Firebase mode before sharing the app with Minyoung.

## 19. Open Questions

- 앱 이름을 최종적으로 `알아가기`로 고정할지, `민영 Pick`의 개인화 이름을 일부 남길지.
- 상대 이름을 `민영`으로 고정할지, 닉네임 입력 기반으로 바꿀지.
- 내 이름/상대 이름의 기본값을 무엇으로 둘지.
- MVP에서 실제 local persistence를 넣을지, 메모리 상태로만 갈지.
- Flutter에서 폰트 파일을 번들링할지, 시스템 폰트로 시작할지.
- bottom navigation을 `홈/질문함/기록/마이`로 유지할지, plus features 때문에 `홈/질문함/카드/위시`로 바꿀지.
- Firebase Console에서 두 계정의 최종 비밀번호를 무엇으로 둘지.
- 질문 카탈로그 v1을 28일로 고정할지, 14일 MVP로 줄여 먼저 배포할지.
- 질문 카탈로그를 앱 코드에 둘지, Firestore `content/questions`로 옮길지.
