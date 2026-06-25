# Modular Product Spec

`조금씩`은 modular SPEC 구조를 사용한다.

## 문서 역할

- [`../spec.md`](../spec.md): 진입점과 전역 규칙.
- 이 디렉터리의 feature spec: 각 user-facing 영역의 현재 product truth.
- [`domain_model.md`](domain_model.md): feature 간 shared model name, ownership field, Firestore mapping.
- [`legacy_full_spec.md`](legacy_full_spec.md): archived monolithic spec. 주 기준 문서가 아니라 역사적 맥락 확인용이다.
- [`../test_plan.md`](../test_plan.md): 이 spec들에서 파생된 verification plan.
- [`../design/README.md`](../design/README.md): 구현 전 HTML 디자인 제안서의 구조와 작성 규칙.
- [`../firebase_setup.md`](../firebase_setup.md): [`firestore.md`](firestore.md)에서 파생된 Firebase setup과 rules guide.
- [`../map_open_api_guide.md`](../map_open_api_guide.md): Places feature의 Kakao Map API setup guide.
- [`../sdd.md`](../sdd.md): archived SDD redirect. active spec으로 사용하지 않는다.

## 변경 Workflow

1. 관련 feature spec을 찾는다.
2. behavior를 바꾸기 전에 해당 spec을 갱신한다.
3. test plan과 tests를 갱신한다.
4. spec을 만족하는 가장 작은 변경을 구현한다.
5. 관련 verification gate를 실행한다.

## 제품 원칙

- 조용하고 private하며 mobile-first로 만든다.
- performance나 obligation보다 gentle curiosity를 우선한다.
- live chat보다 shared records를 우선한다.
- background tracking보다 explicit action을 우선한다.
- private notes, shared entries, revealed results를 명확히 구분한다.

## 현재 Feature Map

| 영역 | Spec |
| --- | --- |
| Home, navigation, first visit | [`home.md`](home.md) |
| Shared domain model과 ownership | [`domain_model.md`](domain_model.md) |
| Daily questions, answers, archive, records | [`questions.md`](questions.md) |
| Taste match | [`taste_match.md`](taste_match.md) |
| Schedule coordination과 fixed meeting plans | [`meetings.md`](meetings.md) |
| Kakao map place board | [`places.md`](places.md) |
| Music notes | [`music.md`](music.md) |
| Stock stories와 holdings | [`stocks.md`](stocks.md) |
| Profile cards | [`profile_cards.md`](profile_cards.md) |
| Wishlist | [`wishlist.md`](wishlist.md) |
| Improvement board | [`improvements.md`](improvements.md) |
| Firestore data/rules/budget | [`firestore.md`](firestore.md) |
| Testing | [`testing.md`](testing.md) |
