# Archived SDD Notes

> 상태: archived.
> 현재 기준 문서: [`spec.md`](spec.md)와 [`spec/`](spec/) 아래 feature spec.

이 파일은 첫 MVP의 early single-document SDD note를 담던 문서다.
현재 active development workflow는 modular spec 구조로 이동했다.

1. [`spec.md`](spec.md) 또는 [`spec/`](spec/) 아래 관련 feature spec을 갱신한다.
2. [`test_plan.md`](test_plan.md)를 갱신한다.
3. test를 추가하거나 조정한다.
4. 구현하고 검증한다.

## 현재 Active Document

- [`spec.md`](spec.md): product entry point와 global rules.
- [`spec/README.md`](spec/README.md): spec document ownership과 feature map.
- [`test_plan.md`](test_plan.md): verification plan과 regression intent.
- [`code_structure.md`](code_structure.md): implementation structure guide.
- [`agent_harness_playbook.md`](agent_harness_playbook.md): multi-agent development guide.
- [`firebase_setup.md`](firebase_setup.md): Firebase setup과 Firestore Rules guide.

## Historical Context

이전 product decision은 [`spec/legacy_full_spec.md`](spec/legacy_full_spec.md)에 보관한다.
해당 archive는 background context로만 사용한다. `spec.md` 또는 feature spec과 충돌하면 current modular spec을 우선한다.
