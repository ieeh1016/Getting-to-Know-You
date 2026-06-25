# 조금씩 Product Spec Index

> 기준 문서: 이 index와 [`docs/spec/`](spec/) 아래의 feature spec.
> 이전 monolithic spec은 migration context 확인용으로만 [`docs/spec/legacy_full_spec.md`](spec/legacy_full_spec.md)에 보관한다.

## 사용 방법

1. product principle, scope rule, document ownership은 [`docs/spec/README.md`](spec/README.md)에서 먼저 확인한다.
2. behavior를 바꾸기 전에 관련 feature spec을 연다.
3. data, rules, cross-feature 변경이면 [`docs/spec/domain_model.md`](spec/domain_model.md)도 함께 확인한다.
4. feature spec을 먼저 갱신한 뒤 [`docs/test_plan.md`](test_plan.md), tests, implementation 순서로 진행한다.
5. spec이 충돌하면 legacy archive보다 더 구체적인 최신 feature spec을 우선한다.

## 보조 문서

- [`docs/code_structure.md`](code_structure.md): implementation structure와 extraction guide.
- [`docs/design/README.md`](design/README.md): HTML 디자인 제안서 구조와 작성 규칙.
- [`docs/spec/domain_model.md`](spec/domain_model.md): shared domain model, ownership, Firestore mapping guide.
- [`docs/firebase_setup.md`](firebase_setup.md): Firebase setup과 canonical Firestore Rules 문서.
- [`docs/map_open_api_guide.md`](map_open_api_guide.md): Places feature의 Kakao Map API setup과 운영 가이드.
- [`docs/agent_harness_playbook.md`](agent_harness_playbook.md): development-only multi-agent workflow guide.
- [`docs/sdd.md`](sdd.md): archived SDD redirect. behavior 기준 문서로 사용하지 않는다.

## Feature Spec

- [Home과 navigation](spec/home.md)
- [Domain model](spec/domain_model.md)
- [Questions와 records](spec/questions.md)
- [Taste match](spec/taste_match.md)
- [Meetings](spec/meetings.md)
- [Places](spec/places.md)
- [Music](spec/music.md)
- [Stocks](spec/stocks.md)
- [Profile cards](spec/profile_cards.md)
- [Wishlist](spec/wishlist.md)
- [Improvement board](spec/improvements.md)
- [Firestore와 data policy](spec/firestore.md)
- [Testing과 verification](spec/testing.md)

## 전역 규칙

- 이 앱은 두 사람이 천천히 서로를 알아가는 private, low-pressure 공간이다.
- couple-app pressure, anniversary language, public social-network mechanics, score, percentage, ranking copy를 사용하지 않는다.
- core UI에서는 heart와 노골적인 romantic commitment signal을 피한다.
- user-generated data는 explicit-save 중심이어야 한다. typing, scrolling, route changes, tab changes, map movement는 Firestore write를 만들면 안 된다.
- 새 Firebase-backed feature는 사용자가 명시적으로 paid dependency를 승인하지 않는 한 Spark/free-plan assumption 안에 둔다.
- behavior change는 spec -> tests -> implementation으로 추적 가능해야 한다.
